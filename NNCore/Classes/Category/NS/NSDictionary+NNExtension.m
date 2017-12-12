//
//  NSDictionary+NNExtension.m
//  NNCore
//
//  Created by XMFraker on 2017/11/10.
//

#import "NSDictionary+NNExtension.h"

@implementation NSDictionary (NNExtension)

- (NSDictionary *)filterKeys:(NSArray *)keys {
    
    if (!keys || !keys.count) { return [self copy]; }
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithDictionary:self];
    [ret removeObjectsForKeys:keys];
    return [ret copy];
}

- (id)safeObjectForKey:(id)key {
    
    return [self safeObjectForKey:key defaultValue:nil];
}

- (id)safeObjectForKey:(id)key defaultValue:(id)defaultValue {
    
    if (!key) { return nil; }
    return [self objectForKey:key] ? : defaultValue;
}

- (id)safeKeyOfObject:(id)object {
    
    if (![self anyObjectExists:object]) { return nil;  }
    
    __block id retKey = nil;
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([object isEqual:obj]) {
            retKey = key;
            *stop = YES;
        }
    }];
    return retKey;
}

- (nullable NSArray *)safeKeysOfObject:(nonnull __kindof NSObject *)object {
    
    if (![self anyObjectExists:object]) { return nil; }
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([object isEqual:obj]) { [ret addObject:key]; }
    }];
    return [ret copy];
}

- (BOOL)anyKeyExists:(id)key {
    
    if (!key) { return NO; };
    return [self objectForKey:key] != nil;
}

- (BOOL)anyObjectExists:(id)object {
    
    if (!object) { return NO; }
    return [self.allValues containsObject:object];
}

- (nullable NSString *)jsonValueEncoded {
    
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError * error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) return json;
    }
    return nil;
}

@end


@implementation NSDictionary (NNStructExtension)

- (NSNumber *)numberValueForKey:(id)key {
    
    if (![self anyKeyExists:key]) { return nil; }
    NSNumber *number = [self safeObjectForKey:key];
    if (!number || ![number isKindOfClass:[NSNumber class]]) {
        return nil;
    }
    return number;
}

- (NSValue *)structValueForKey:(id)key {
    
    if (![self anyKeyExists:key]) { return nil; }
    NSValue *value = [self safeObjectForKey:key];
    if (!value || ![value isKindOfClass:[NSValue class]]) {
        return nil;
    }
    return value;
}

- (BOOL)boolValueForKey:(id)key {
    
    NSNumber *numberValue = [self safeObjectForKey:key];
    if (numberValue && [numberValue respondsToSelector:@selector(boolValue)]) {
        return [numberValue boolValue];
    }
    return NO;
}

- (NSInteger)integerValueForKey:(nonnull id)key {
    
    NSNumber *numberValue = [self safeObjectForKey:key];
    if (numberValue && [numberValue respondsToSelector:@selector(integerValue)]) {
        return [numberValue integerValue];
    }
    return 0;
}

- (CGFloat)floatValueForKey:(id)key {
    
    NSNumber *numberValue = [self safeObjectForKey:key];
    if (numberValue && [numberValue respondsToSelector:@selector(floatValue)]) {
        return [numberValue floatValue];
    }
    return CGFLOAT_MIN;
}

- (CGSize)sizeValueForKey:(id)key {
    
    NSValue *structValue = [self structValueForKey:key];
    return structValue ?  [structValue CGSizeValue] : CGSizeZero;
}

- (CGRect)rectValueForKey:(id)key {
    
    NSValue *structValue = [self structValueForKey:key];
    return structValue ?  [structValue CGRectValue] : CGRectZero;
}

- (CGPoint)pointValueForKey:(id)key {
    
    NSValue *structValue = [self structValueForKey:key];
    return structValue ?  [structValue CGPointValue] : CGPointZero;
}

@end

@implementation NSMutableDictionary (NNStructExtension)

- (void)setBoolValue:(BOOL)value forKey:(id)key {
    [self setObject:@(value) forKey:key];
}

- (void)setFloatValue:(CGFloat)value forKey:(id)key {
    [self setObject:@(value) forKey:key];
}

- (void)setSizeValue:(CGSize)value forKey:(id)key {
    [self setObject:[NSValue valueWithCGSize:value] forKey:key];
}

- (void)setRectValue:(CGRect)value forKey:(id)key {
    [self setObject:[NSValue valueWithCGRect:value] forKey:key];
}

- (void)setPointValue:(CGPoint)value forKey:(id)key {
    [self setObject:[NSValue valueWithCGPoint:value] forKey:key];
}

@end

@implementation NSDictionary (NNURLExtension)

+ (nullable NSDictionary *)queryDictionaryForURL:(nonnull NSURL *)URL {
    
    if (!URL) { return nil; }
    NSURLComponents *components = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    NSMutableDictionary *queryParams = [NSMutableDictionary dictionaryWithCapacity:components.queryItems.count];
    [components.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        queryParams[obj.name] = obj.value ? : @"";
    }];
    return [queryParams copy];
}

@end

