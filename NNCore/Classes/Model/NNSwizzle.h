//  NNSwizzle.h
//  Pods
//
//  Created by  XMFraker on 2017/12/13
//  Copyright © XMFraker All rights reserved. (https://github.com/ws00801526)
//  @class      NNSwizzle
//  @version    <#class version#>
//  @abstract   <#class description#>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  A workaround for issues related to key-value observing the `state` of an `NSURLSessionTask`.
 *
 *  See:
 *  - https://github.com/AFNetworking/AFNetworking/issues/1477
 *  - https://github.com/AFNetworking/AFNetworking/issues/2638
 *  - https://github.com/AFNetworking/AFNetworking/pull/2702
 */
FOUNDATION_EXPORT void NNSwizzleMethod(Class theClass, SEL originalSelector, Class theSwizzledClass, SEL swizzledSelector);

FOUNDATION_EXPORT BOOL NNAddMethod(Class theClass, SEL selector);

NS_ASSUME_NONNULL_END
