//  NNDispatchQueuePool.h
//  Pods
//
//  Created by  XMFraker on 2017/12/13
//  Copyright © XMFraker All rights reserved. (https://github.com/ws00801526)
//  @class      NNDispatchQueuePool
//  @version    0.0.1
//  @abstract   <#class description#>

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A dispatch queue pool holds multiple serial queues.
 Use this class to control queue's thread count (instead of concurrent queue).
 */
@interface NNDispatchQueuePool : NSObject

/** queuepool.name */
@property (copy, nonatomic, readonly, nullable)   NSString *name;

/**
 Create and return a dispatch queue pool.

 @param name       The name of queue pool.
 @param queueCount The max queue count of queue pool, should in range [1,32].
 @param qos        Queue quality of service (QOS).
 @return A new queue pool, or nil when error occurs
 */
- (nullable instancetype)initWithName:(nullable NSString *)name
                           queueCount:(NSUInteger)queueCount
                                  qos:(NSQualityOfService)qos;

/**
 Create and return a dispatch queue pool

 @param qos     Queue quality of service (QOS).
 @return A new queue pool, or nil when error occurs
 */
+ (nullable instancetype)defaultPoolForQOS:(NSQualityOfService)qos;

/** get a serial queue from pool */
- (dispatch_queue_t)queue;

@end


@interface NNDispatchQueuePool (Deprecated)
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end

/** get a serial queue from pool with special QOS */
FOUNDATION_EXTERN dispatch_queue_t NNDispatchQueueGetForQOS(NSQualityOfService qos);

NS_ASSUME_NONNULL_END
