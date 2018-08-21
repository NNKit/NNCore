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
@property (assign, nonatomic) IBInspectable BOOL perferredBarHidden;
/** determind navigationBar.shadowImage hidden. Default NO */
@property (assign, nonatomic) IBInspectable BOOL perferredBarShadowHidden;
/** set backgroundColor of navigationBar. Default nil */
@property (copy, nonatomic) IBInspectable UIColor *perferredBarBackgroundColor;

@end
