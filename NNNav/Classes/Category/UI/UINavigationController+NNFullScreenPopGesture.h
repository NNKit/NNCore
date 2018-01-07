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

/** 全屏返回手势 */
@property (assign, nonatomic, readonly) UIPanGestureRecognizer *nn_popGestrue;
/** 是否禁止全局返回手势 默认为 NO */
@property (assign, nonatomic) IBInspectable BOOL nn_perfersPopGestureDisabled;

@end

@interface UIViewController (NNFullScreenPopGesture)

/** 是否关闭全屏返回手势 默认 NO */
@property (assign, nonatomic) IBInspectable BOOL nn_interactivePopDisabled;
/** 全屏手势触发offset 默认 0 */
@property (assign, nonatomic) IBInspectable CGFloat nn_interactivePopOffset;

@end
