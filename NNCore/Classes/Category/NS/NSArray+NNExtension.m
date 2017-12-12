//
//  NSArray+NNExtension.m
//  NNCore
//
//  Created by XMFraker on 2017/11/10.
//

#import "NSArray+NNExtension.h"

@implementation NSArray (NNExtension)

- (void)execute:(void(^)(id obj, NSUInteger idx, BOOL *stop))block {
    
    if (!block) { return; }
    [self enumerateObjectsUsingBlock:block];
}

- (NSArray *)map:(id(^)(id obj, NSInteger index))block {
    
    if (!block) { return [self copy]; }
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [array addObject:block(obj,idx)];
    }];
    return [NSArray arrayWithArray:array];
}

- (NSArray *)filter:(BOOL(^)(id obj))filterBlock {
    
    if (!filterBlock) { return [self copy]; }
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return !filterBlock(evaluatedObject);
    }]];
}

- (id)fetchOneObject:(BOOL(^)(id obj))handler {

    if (!handler) { return [self firstObject]; }
    __block id ret = nil;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (handler(obj)) {
            ret = obj;
            *stop = YES;
        }
    }];
    return ret;
}

- (BOOL)any:(BOOL(^)(id obj))block {
    
    if (!block || !self.count) { return NO; }
    __block BOOL ret = NO;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (block(obj)) {
            ret = YES;
            *stop = YES;
        }
    }];
    return ret;
}

- (id)safeObjectAtIndex:(NSUInteger)index {
    
    if (!self || ![self isKindOfClass:[NSArray class]] || !self.count) { return nil; }
    if (self && index < self.count) { return [self objectAtIndex:index]; }
    return nil;
}

- (NSUInteger)safeIndexOfObject:(id)object {
    
    if (!object) { return NSNotFound; }
    if (!self || ![self isKindOfClass:[NSArray class]] || !self.count) { return NSNotFound; }
    if (![self containsObject:object]) { return NSNotFound; }
    return [self indexOfObject:object];
}

- (BOOL)isEmpty {
    return ![self isKindOfClass:[NSArray class]] || self.count == 0;
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
