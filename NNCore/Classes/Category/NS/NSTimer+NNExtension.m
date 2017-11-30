//
//  NSTimer+NNExtension.m
//  NNCore
//
//  Created by XMFraker on 2017/11/10.
//

#import "NSTimer+NNExtension.h"

@implementation NSTimer (NNExtension)

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds
                              repeats:(BOOL)repeats
                           handler:(void(^)(NSTimer * timer))handler {
    
    if ([NSTimer respondsToSelector:@selector(timerWithTimeInterval:repeats:block:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Weverything"
        return [NSTimer timerWithTimeInterval:seconds repeats:repeats block:handler];
#pragma clang diagnostic pop
    } else {
        return [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(globalTimerHandler:) userInfo:[handler copy] repeats:repeats];
    }
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds
                                    repeats:(BOOL)repeats
                                    handler:(void(^)(NSTimer * timer))handler {
    
    if ([NSTimer respondsToSelector:@selector(scheduledTimerWithTimeInterval:repeats:block:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Weverything"
        return [NSTimer scheduledTimerWithTimeInterval:seconds repeats:repeats block:handler];
#pragma clang diagnostic pop
    } else {
        return [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(globalTimerHandler:) userInfo:[handler copy] repeats:repeats];
    }
}

+ (void)globalTimerHandler:(NSTimer *)timer {
    
    void(^handler)(NSTimer *) = timer.userInfo;
    handler ? handler(timer) : nil;
}

@end
