//  UINavigationController+NNFullScreenPopGesture.h
//  Pods
//
//  Created by  XMFraker on 2017/12/14
//  Copyright © XMFraker All rights reserved. (https://github.com/ws00801526)
//  @class      UINavigationController_NNFullScreenPopGesture
//  @version    <#class version#>
//  @abstract   <#class description#>

#import <UIKit/UIKit.h>

@interface UINavigationController (NNFullScreenPopGesture)

/** pop gesture */
@property (assign, nonatomic, readonly) UIPanGestureRecognizer *popGestrue;
/** determind pop ges is disabled. Default NO */
@property (assign, nonatomic) IBInspectable BOOL perfersPopGestureDisabled;

@end

@interface UIViewController (NNFullScreenPopGesture)

/** determind pop action is disabled. Default NO */
@property (assign, nonatomic) IBInspectable BOOL interactivePopDisabled;
/** determind pop ges available offset from left edge. Default 0 full screen */
@property (assign, nonatomic) IBInspectable CGFloat interactivePopOffset;

@end
