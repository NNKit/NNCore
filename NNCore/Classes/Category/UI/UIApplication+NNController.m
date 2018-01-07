//  UIApplication+NNController.m
//  Pods
//
//  Created by  XMFraker on 2017/12/14
//  Copyright © XMFraker All rights reserved. (https://github.com/ws00801526)
//  @class      UIApplication_NNController
//  @version    <#class version#>
//  @abstract   <#class description#>

#import "UIApplication+NNController.h"

@implementation UIApplication (NNController)

- (__kindof UINavigationController *)nn_navigationController {
    if (self.nn_topViewController.navigationController) return self.nn_topViewController.navigationController;
    if ([self.keyWindow.rootViewController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)self.keyWindow.rootViewController;
    }
    return nil;
}

- (__kindof UIViewController *)nn_topViewController {
    
    UIViewController *viewController = self.keyWindow.rootViewController;
    
    while (viewController) {
        if ([viewController isKindOfClass:[UITabBarController class]]) {
            viewController = [(UITabBarController *)viewController selectedViewController];
        } else if ([viewController isKindOfClass:[UINavigationController class]]) {
            viewController = [(UINavigationController *)viewController topViewController];
        } else if ([viewController isKindOfClass:[UISplitViewController class]]) {
            viewController = [(UISplitViewController *)viewController viewControllers].lastObject;
        } else if (viewController.presentedViewController) {
            viewController = viewController.presentedViewController;
        } else {
            return viewController;
        }
    }
    return viewController;
}

@end
