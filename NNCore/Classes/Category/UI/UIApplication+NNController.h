//  UIApplication+NNController.h
//  Pods
//
//  Created by  XMFraker on 2017/12/14
//  Copyright © XMFraker All rights reserved. (https://github.com/ws00801526)
//  @class      UIApplication_NNController
//  @version    <#class version#>
//  @abstract   <#class description#>

#import <UIKit/UIKit.h>

@interface UIApplication (NNController)

/** topViewController is displayed */
@property (strong, nonatomic, readonly, nullable) __kindof UIViewController *nn_topViewController;
/** shortstruct of nn_topViewController.navigationController or keyWindow.rootViewController or nil */
@property (strong, nonatomic, readonly, nullable) __kindof UINavigationController *nn_navigationController;

@end
