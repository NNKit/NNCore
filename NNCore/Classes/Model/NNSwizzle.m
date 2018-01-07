//  NNSwizzle.m
//  Pods
//
//  Created by  XMFraker on 2017/12/13
//  Copyright © XMFraker All rights reserved. (https://github.com/ws00801526)
//  @class      NNSwizzle
//  @version    <#class version#>
//  @abstract   <#class description#>


#import "NNSwizzle.h"
#import <objc/runtime.h>

void NNSwizzleMethod(Class theClass, SEL originalSelector, Class theSwizzledClass, SEL swizzledSelector) {
    
    Method originalMethod = class_getInstanceMethod(theClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(theSwizzledClass, swizzledSelector);
    
    BOOL isAddedMethod = NNAddMethod(theClass, originalSelector);
    if (isAddedMethod) {
        class_replaceMethod(theClass,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

BOOL NNAddMethod(Class theClass, SEL selector) {
    
    Method method = class_getInstanceMethod(theClass, selector);
    return class_addMethod(theClass, selector,  method_getImplementation(method),  method_getTypeEncoding(method));
}

