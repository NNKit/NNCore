//
//  WMRouter.h
//  Pods
//
//  Created by XMFraker on 2017/5/15.
//  Copyright © 2017年 WelfareMall. All rights reserved.
//

#import <NNCore/NNDefines.h>

NS_ASSUME_NONNULL_BEGIN

NNEXTERN NSString *const NNRouterParameterURL;
NNEXTERN NSString *const NNRouterParameterUserInfo;
NNEXTERN NSString *const NNRouterParameterCompletionHandler;

typedef void(^NNRouterCompletionHandler)(id _Nullable result);

/**
 提供模块间基础路由功能
 提供swizzing 方法  获取Appdelegate 生命周期
 
 Router 定义规则
 内部跳转 统一定义为icareinternal://xxx/yyy
 外部跳转 统一定义为icare://xxxxx(外部ID)/xxx/yyy
 
 使用外部跳转时, 需要添加对应外部app验证功能
 */
@interface NNRouter : NSObject

#pragma mark - Router Class Method

/**
 注册URLPattern处理

 @param URLPattern 需要处理的URLPattern
 @param handler    具体处理的handler
 */
+ (void)registerURLPattern:(NSString *)URLPattern
                 toHandler:(void(^)(NSDictionary *parameter))handler;

/**
 注册一个带有返回值的URLPattern处理协议

 @param URLPattern 需要处理的URLPattern
 @param handler    具体处理的handler
 */
+ (void)registerURLPattern:(NSString *)URLPattern
           toObjectHandler:(id(^)(NSDictionary *parameter))handler;

/**
 取消注册一个URLPattern

 @param URLPattern 需要取消的URLPattern
 */
+ (void)deregisterURLPattern:(NSString *)URLPattern;

/**
 处理一个URL

 @param URL 需要被处理的URL
 */
+ (void)openURL:(NSString *)URL;

/**
 处理一个URL
 
 @param URL                 需要处理的URL
 @param completionHandler   处理完成后的回调handler
 */
+ (void)openURL:(NSString *)URL completionHandler:(nullable NNRouterCompletionHandler)completionHandler;

/**
 处理一个URL
 
 @param URL                 需要处理的URL
 @param userInfo            处理URL时附带的参数
 */
+ (void)openURL:(NSString *)URL withUserInfo:(nullable NSDictionary *)userInfo;

/**
 处理一个URL

 @param URL                 需要处理的URL
 @param userInfo            处理URL时附带的参数
 @param completionHandler   处理完成后的回调handler
 */
+ (void)openURL:(NSString *)URL withUserInfo:(nullable NSDictionary *)userInfo completionHandler:(nullable NNRouterCompletionHandler)completionHandler;


/**
 通过URL获取一个对象

 @param URL         需要获取的URL
 @return 获取的对象
 */
+ (nullable id)objectForURL:(NSString *)URL;

/**
 通过URL获取一个对象

 @param URL         需要获取的URL
 @param userInfo    附带的参数
 @return 获取的对象 or nil
 */
+ (nullable id)objectForURL:(NSString *)URL withUserInfo:(nullable NSDictionary *)userInfo;

/**
 判断URL 是否可以被WMRouter 处理

 @param URL    需要判断的URL
 @return YES or NO
 */
+ (BOOL)canOpenURL:(NSString *)URL;


/**
 生成对应的可执行的字符串集合
 匹配pattern 中 :id  字符串, 使用parameters 中进行替换
 未匹配到的parameters 会作为query参数拼接
 @param pattern         需要配置的URL
 @param parameters      参数
 @return    配置后的URL
 */
+ (NSString *)generateURLWithPattern:(NSString *)pattern
                          parameters:(nullable NSDictionary<NSString*,NSString*> *)parameters;
@end


@interface NNRouter (WMDeprecated)

- (instancetype)init __deprecated;

@end
NS_ASSUME_NONNULL_END
