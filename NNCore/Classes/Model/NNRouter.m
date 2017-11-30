//
//  WMRouter.m
//  Pods
//
//  Created by XMFraker on 2017/5/15.
//  Copyright © 2017年 WelfareMall. All rights reserved.
//

#import "NNRouter.h"
#import <objc/runtime.h>

static NSString *const  WM_ROUTER_WILDCARD_CHARACTER = @"~";
static NSString *const  specialCharacters = @"/?&.";

static NSString *const WMRouterHandlerBlockKey = @"com.XMFraker.NNCore.WMRouterHandlerBlockKey";

NSString *const NNRouterParameterURL = @"com.XMFraker.NNCore.WMRouterParameterURL";
NSString *const NNRouterParameterCompletionHandler = @"com.XMFraker.NNCore.WMRouterParameterCompletionHandler";
NSString *const NNRouterParameterUserInfo = @"com.XMFraker.NNCore.WMRouterParameterUserInfo";

@interface NNRouter ()

/** 记录所有现有的routers */
@property (strong, nonatomic) NSMutableDictionary *routes;

@end

@implementation NNRouter

#pragma mark - Life Cycle

+ (instancetype)sharedInstance {
    
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - Router Getter

- (NSMutableDictionary *)routes {
    
    if (!_routes) {
        _routes = [NSMutableDictionary dictionary];
    }
    return _routes;
}

#pragma mark - Router Private Method

- (void)addURLPattern:(NSString *)URLPattern
           andHandler:(id)handler {
    
    NSMutableDictionary *subRoutes = [self addURLPattern:URLPattern];
    if (handler && subRoutes) {
        subRoutes[@"_"] = [handler copy];
    }
}

- (NSMutableDictionary *)addURLPattern:(NSString *)URLPattern {
    
    NSArray *pathComponents = [self pathComponentsFromURL:URLPattern];
    
    NSMutableDictionary* subRoutes = self.routes;
    
    for (NSString* pathComponent in pathComponents) {
        if (![subRoutes objectForKey:pathComponent]) {
            subRoutes[pathComponent] = [[NSMutableDictionary alloc] init];
        }
        subRoutes = subRoutes[pathComponent];
    }
    return subRoutes;
}

- (NSMutableDictionary *)extractParametersFromURL:(NSString *)url {
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    
    parameters[NNRouterParameterURL] = url;
    
    NSMutableDictionary* subRoutes = self.routes;
    NSArray* pathComponents = [self pathComponentsFromURL:url];
    
    BOOL found = NO;
    // borrowed from HHRouter(https://github.com/Huohua/HHRouter)
    for (NSString* pathComponent in pathComponents) {
        
        // 对 key 进行排序，这样可以把 ~ 放到最后
        NSArray *subRoutesKeys =[subRoutes.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [obj1 compare:obj2];
        }];
        
        for (NSString* key in subRoutesKeys) {
            if ([key isEqualToString:pathComponent] || [key isEqualToString:WM_ROUTER_WILDCARD_CHARACTER]) {
                found = YES;
                subRoutes = subRoutes[key];
                break;
            } else if ([key hasPrefix:@":"]) {
                found = YES;
                subRoutes = subRoutes[key];
                NSString *newKey = [key substringFromIndex:1];
                NSString *newPathComponent = pathComponent;
                // 再做一下特殊处理，比如 :id.html -> :id
                if ([self.class checkIfContainsSpecialCharacter:key]) {
                    NSCharacterSet *specialCharacterSet = [NSCharacterSet characterSetWithCharactersInString:specialCharacters];
                    NSRange range = [key rangeOfCharacterFromSet:specialCharacterSet];
                    if (range.location != NSNotFound) {
                        // 把 pathComponent 后面的部分也去掉
                        newKey = [newKey substringToIndex:range.location - 1];
                        NSString *suffixToStrip = [key substringFromIndex:range.location];
                        newPathComponent = [newPathComponent stringByReplacingOccurrencesOfString:suffixToStrip withString:@""];
                    }
                }
                parameters[newKey] = newPathComponent;
                break;
            }
        }
        
        // 如果没有找到该 pathComponent 对应的 handler，则以上一层的 handler 作为 fallback
        if (!found && !subRoutes[@"_"]) {
            return nil;
        }
    }
    
    // Extract Params From Query.
    NSURL *URL = [NSURL URLWithString:url];
    if (URL) {
        /** !!! 增加获取URL判断, 防止URL为空值时,产生的崩溃问题 */
        NSArray<NSURLQueryItem *> *queryItems = [[NSURLComponents alloc] initWithURL:URL resolvingAgainstBaseURL:false].queryItems;
        
        for (NSURLQueryItem *item in queryItems) {
            parameters[item.name] = item.value;
        }
    }
    
    
    if (subRoutes[@"_"]) {
        parameters[WMRouterHandlerBlockKey] = [subRoutes[@"_"] copy];
    }
    
    return parameters;
}

- (void)removeURLPattern:(NSString *)URLPattern {
    
    NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:[self pathComponentsFromURL:URLPattern]];
    
    // 只删除该 pattern 的最后一级
    if (pathComponents.count >= 1) {
        // 假如 URLPattern 为 a/b/c, components 就是 @"a.b.c" 正好可以作为 KVC 的 key
        NSString *components = [pathComponents componentsJoinedByString:@"."];
        NSMutableDictionary *route = [self.routes valueForKeyPath:components];
        
        if (route.count >= 1) {
            NSString *lastComponent = [pathComponents lastObject];
            [pathComponents removeLastObject];
            
            // 有可能是根 key，这样就是 self.routes 了
            route = self.routes;
            if (pathComponents.count) {
                NSString *componentsWithoutLast = [pathComponents componentsJoinedByString:@"."];
                route = [self.routes valueForKeyPath:componentsWithoutLast];
            }
            [route removeObjectForKey:lastComponent];
        }
    }
}

- (NSArray*)pathComponentsFromURL:(NSString*)URL {
    
    NSMutableArray *pathComponents = [NSMutableArray array];
    if ([URL rangeOfString:@"://"].location != NSNotFound) {
        NSArray *pathSegments = [URL componentsSeparatedByString:@"://"];
        // 如果 URL 包含协议，那么把协议作为第一个元素放进去
        [pathComponents addObject:pathSegments[0]];
        
        // 如果只有协议，那么放一个占位符
        URL = pathSegments.lastObject;
        if (!URL.length) {
            [pathComponents addObject:WM_ROUTER_WILDCARD_CHARACTER];
        }
    }
    
    for (NSString *pathComponent in [[NSURL URLWithString:URL] pathComponents]) {
        if ([pathComponent isEqualToString:@"/"]) continue;
        if ([[pathComponent substringToIndex:1] isEqualToString:@"?"]) break;
        [pathComponents addObject:pathComponent];
    }
    return [pathComponents copy];
}

#pragma mark - Router Class Method

+ (BOOL)checkIfContainsSpecialCharacter:(NSString *)checkedString {
    
    NSCharacterSet *specialCharactersSet = [NSCharacterSet characterSetWithCharactersInString:specialCharacters];
    return [checkedString rangeOfCharacterFromSet:specialCharactersSet].location != NSNotFound;
}

+ (void)registerURLPattern:(NSString *)URLPattern toHandler:(void(^)(NSDictionary *))handler {
    
    [[self sharedInstance] addURLPattern:URLPattern andHandler:handler];
}

+ (void)registerURLPattern:(NSString *)URLPattern toObjectHandler:(id(^)(NSDictionary *))handler {
    
    [[self sharedInstance] addURLPattern:URLPattern andHandler:handler];
}

+ (void)deregisterURLPattern:(NSString *)URLPattern {
    
    [[self sharedInstance] removeURLPattern:URLPattern];
}

+ (void)openURL:(NSString *)URL {
    
    [self openURL:URL completionHandler:nil];
}

+ (void)openURL:(NSString *)URL completionHandler:(void (^)(id))completionHandler {
    
    [self openURL:URL withUserInfo:nil completionHandler:completionHandler];
}

+ (void)openURL:(NSString *)URL withUserInfo:(nullable NSDictionary *)userInfo {
    
    [self openURL:URL withUserInfo:userInfo completionHandler:NULL];
}

+ (void)openURL:(NSString *)URL withUserInfo:(NSDictionary *)userInfo completionHandler:(void (^)(id))completionHandler {
 
    URL = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    /** 1. 解析URL参数 */
    NSMutableDictionary *parameters = [[self sharedInstance] extractParametersFromURL:URL];
    
    /** 2. 遍历解析的参数, 将字符串进行编码 */
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, NSString *obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            parameters[key] = [obj stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }];
    
    if (parameters) {
        void(^handler)(NSDictionary *ret) = parameters[WMRouterHandlerBlockKey];
        if (completionHandler) {
            parameters[NNRouterParameterCompletionHandler] = completionHandler;
        }
        if (userInfo) {
            // 将userInfo中的数据, 直接存入parameters中
            parameters[NNRouterParameterUserInfo] = userInfo;
            [parameters addEntriesFromDictionary:userInfo];
        }
        if (handler) {
            [parameters removeObjectForKey:WMRouterHandlerBlockKey];
            handler([parameters copy]);
        }
    }
}

+ (id)objectForURL:(NSString *)URL withUserInfo:(NSDictionary *)userInfo {
    
    NNRouter *router = [NNRouter sharedInstance];
    
    URL = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *parameters = [router extractParametersFromURL:URL];
    id(^handler)(NSDictionary *ret) = parameters[WMRouterHandlerBlockKey];
    
    if (handler) {
        if (userInfo) {
            parameters[NNRouterParameterUserInfo] = userInfo;
        }
        [parameters removeObjectForKey:WMRouterHandlerBlockKey];
        return handler([parameters copy]);
    }
    return nil;
}

+ (id)objectForURL:(NSString *)URL {
    
    return [self objectForURL:URL withUserInfo:nil];
}

+ (BOOL)canOpenURL:(NSString *)URL {
    
    return [[self sharedInstance] extractParametersFromURL:URL][WMRouterHandlerBlockKey] ? YES : NO;
}

+ (NSString *)generateURLWithPattern:(NSString *)pattern
                          parameters:(NSDictionary<NSString*,NSString*> *)parameters {
    
    
    __block NSString *parsePattern = [pattern copy];
    
    if (parameters) {
        
        NSMutableArray *querys = [NSMutableArray array];

        /** 1. 替换掉pattern 中path中 所有 :path */
        [parameters enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
           
            NSRange range = [parsePattern rangeOfString:[NSString stringWithFormat:@":%@",key]];
            if (range.location != NSNotFound) {
                parsePattern = [parsePattern stringByReplacingCharactersInRange:range withString:[obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] ? : @""];
            }else {
                [querys addObject:[NSString stringWithFormat:@"%@=%@",key,[obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] ? : @""]];
            }
        }];
        
        /** 2. 将多余出来的参数 拼接到尾部,左右URL.query */
        if (querys.count) {
            if ([parsePattern containsString:@"?"]) {
                parsePattern = [parsePattern stringByAppendingString:[NSString stringWithFormat:@"&%@",[querys componentsJoinedByString:@"&"]]];
            }else {
                parsePattern = [parsePattern stringByAppendingString:[NSString stringWithFormat:@"?%@",[querys componentsJoinedByString:@"&"]]];
            }
        }
    }
    return [parsePattern copy];
}
@end
