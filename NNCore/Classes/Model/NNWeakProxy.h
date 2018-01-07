//  NNWeakProxy.h
//  Pods
//
//  Created by  XMFraker on 2017/12/13
//  Copyright © XMFraker All rights reserved. (https://github.com/ws00801526)
//  @class      NNWeakProxy
//  @version    0.0.1
//  @abstract   See more https://github.com/ibireme/YYKit/blob/master/YYKit/Utility/YYWeakProxy.h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 使用代理持有弱引用对象, 有效解决循环引用问题. 例如 NSTimer, CADisplayLink
 
 @code
 
 @implementation NNView {
     NSTimer *_timer;
 }
 
 - (void)setupTimer {
     NNWeakProxy *proxy = [[NNWeakProxy alloc] initWithTarget:self];
     _timer = [NSTimer timerWithTimeInterval:0.1 target:proxy selector:@selector(tick:) userInfo:nil repeats:YES];
 }
 
 - (void)handleTimerTick { ... }
 
 @endcode
 */
@interface NNWeakProxy : NSObject

/** the proxy target */
@property (weak, nonatomic, readonly, nullable) id target;

- (instancetype)init NS_UNAVAILABLE;

/**
 Create And return a proxy

 @param target       The proxy target
 @return a new NNWeakProxy
 */
- (instancetype)initWithTarget:(id)target NS_DESIGNATED_INITIALIZER;

/**
 Create And return a proxy
 
 @param target       The proxy target
 @return a new NNWeakProxy
 */
+ (instancetype)proxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
