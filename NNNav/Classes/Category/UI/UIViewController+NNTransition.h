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
/** 是否隐藏navigationBar 默认NO */
@property (assign, nonatomic) IBInspectable BOOL nn_perfersNavigationBarHidden;
@end
