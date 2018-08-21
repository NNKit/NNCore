//  UIViewController+NNTransition.h
//  Pods
//
//  Created by  XMFraker on 2017/12/14
//  Copyright © XMFraker All rights reserved. (https://github.com/ws00801526)
//  @class      UIViewController_NNTransition
//  @version    <#class version#>
//  @abstract   <#class description#>

#import <UIKit/UIKit.h>

@interface UIViewController (NNTransition)

/** determind navigationBar.hidden. Default NO */
@property (assign, nonatomic) IBInspectable BOOL perfersBarHidden;
/** determind navigationBar.shadowImage hidden. Default NO */
@property (assign, nonatomic) IBInspectable BOOL perfersBarShadowHidden;
/** set backgroundColor of navigationBar. Default nil */
@property (copy, nonatomic) IBInspectable UIColor *perfersBarBackgroundColor;

@end
