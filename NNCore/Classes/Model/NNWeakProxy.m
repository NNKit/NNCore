//  NNWeakProxy.m
//  Pods
//
//  Created by  XMFraker on 2017/12/13
//  Copyright © XMFraker All rights reserved. (https://github.com/ws00801526)
//  @class      NNWeakProxy
//  @version    <#class version#>
//  @abstract   <#class description#>

#import "NNWeakProxy.h"

@implementation NNWeakProxy
@synthesize target = _target;
#pragma mark - Life Cycle

- (instancetype)initWithTarget:(id)target {
    
    if (self = [super init]) {
        _target = target;
    }
    return self;
}

+ (instancetype)proxyWithTarget:(id)target {
    
    return [[NNWeakProxy alloc] initWithTarget:target];
}

#pragma mark - Override NSObject

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.target;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    void *null = NULL;
    [anInvocation setReturnValue:&null];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [self.target respondsToSelector:aSelector];
}

- (BOOL)isEqual:(id)object {
    return [self.target isEqual:object];
}

- (NSUInteger)hash {
    return [self.target hash];
}

- (Class)superclass {
    return [self.target superclass];
}

- (Class)class {
    return [self.target class];
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [self.target isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    return [self.target isMemberOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [self.target conformsToProtocol:aProtocol];
}

- (BOOL)isProxy {
    return YES;
}

- (NSString *)description {
    return [self.target description];
}

- (NSString *)debugDescription {
    return [self.target debugDescription];
}


@end
