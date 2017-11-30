//
//  NSTimer+NNExtension.h
//  NNCore
//
//  Created by XMFraker on 2017/11/10.
//

#import <Foundation/Foundation.h>

@interface NSTimer (NNExtension)

/**
 执行timer handler
 
 @param seconds        间隔时间
 @param handler        回调handler
 @param repeats        是否重复执行
 @return NSTimer       实例
 */
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds
                           repeats:(BOOL)repeats
                           handler:(void(^)(NSTimer * timer))handler;

/**
 执行timer handler
 
 @param seconds        间隔时间
 @param repeats        是否重复执行
 @param handler        回调handler
 @return NSTimer       实例
 */
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds
                                    repeats:(BOOL)repeats

                                    handler:(void(^)(NSTimer * timer))handler;

@end
