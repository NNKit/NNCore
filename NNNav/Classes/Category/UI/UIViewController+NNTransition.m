//  UIViewController+NNTransition.m
//  Pods
//
//  Created by  XMFraker on 2017/12/14
//  Copyright © XMFraker All rights reserved. (https://github.com/ws00801526)
//  @class      UIViewController_NNTransition
//  @version    <#class version#>
//  @abstract   <#class description#>

#import "UIViewController+NNTransition.h"

#import <objc/runtime.h>

#import <NNCore/NNCore.h>

@interface UINavigationBar (NNTransitionInternal)
@property (assign, nonatomic, getter=isUsedForTransition) BOOL usedForTransition;

- (UINavigationBar *)nn_transitionBar;
@end

@interface UIScrollView (NNTransitionInternal)

@property (assign, nonatomic) UIScrollViewContentInsetAdjustmentBehavior nn_originalContentInsetAdjustmentBehavior NS_AVAILABLE_IOS(11_0);
@property (assign, nonatomic) BOOL nn_shouldRestoreContentInsetAdjustmentBehavior NS_AVAILABLE_IOS(11_0);

@end

@interface UIViewController (NNTransitionInternal)
@property (strong, nonatomic) UINavigationBar *nn_transitionBar;
@property (strong, nonatomic, nullable) UIScrollView *nn_scrollView;
- (void)nn_insertTransitionBarIfNeeded;
@end

@interface UINavigationController (NNTransitionInternal)

@property (assign, nonatomic) BOOL nn_backgroundViewHidden;

- (UIColor *)nn_containerViewBackgroundColor;
@end


@implementation NSObject (NNTransitionInternal)

+ (void)load {
    
    NNSwizzleMethod(objc_getClass("_UIBarBackground"),
                    @selector(setHidden:),
                    [self class],
                    @selector(nn_transitionSetHidden:));
}

- (void)nn_transitionSetHidden:(BOOL)hidden {
    
    UIResponder *responder = (UIResponder *)self;
    while (responder) {
        if ([responder isKindOfClass:[UINavigationBar class]] && ((UINavigationBar *)responder).isUsedForTransition) return;

        if ([responder isKindOfClass:[UINavigationController class]]) {
            [self nn_transitionSetHidden:((UINavigationController *)responder).nn_backgroundViewHidden];
            return;
        }
        responder = responder.nextResponder;
    }
    [self nn_transitionSetHidden:hidden];
}

@end

@implementation UINavigationBar (NNTransitionInternal)

#pragma mark - Life Cycle

+ (void)load {
    NNSwizzleMethod([self class],
                    @selector(layoutSubviews),
                    [self class],
                    @selector(nn_transitionLayoutSubviews));
}

#pragma mark - Swizzle

- (void)nn_transitionLayoutSubviews {
    
    [self nn_transitionLayoutSubviews];
    UIView *backgroundView = [self valueForKey:@"_backgroundView"];
    backgroundView.height = self.height + fabs(backgroundView.top);
}

#pragma mark - Public

- (UINavigationBar *)nn_transitionBar {
    
    UINavigationBar *bar = [[UINavigationBar alloc] init];
    bar.usedForTransition = YES;
    bar.barStyle = self.barStyle;
    bar.barTintColor = self.barTintColor;
    bar.shadowImage = self.shadowImage;
    bar.titleTextAttributes = self.titleTextAttributes;
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) bar.largeTitleTextAttributes = self.largeTitleTextAttributes;
#endif
    
    if (bar.isTranslucent != self.isTranslucent) bar.translucent = self.translucent;
    [bar setBackgroundImage:[self backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
//    [bar setBackgroundImage:[self backgroundImageForBarMetrics:UIBarMetricsCompact] forBarMetrics:UIBarMetricsCompact];
//    [bar setBackgroundImage:[self backgroundImageForBarMetrics:UIBarMetricsCompactPrompt] forBarMetrics:UIBarMetricsCompactPrompt];
//    [bar setBackgroundImage:[self backgroundImageForBarMetrics:UIBarMetricsDefaultPrompt] forBarMetrics:UIBarMetricsDefaultPrompt];
    return bar;
}

#pragma mark - Setter

- (void)setUsedForTransition:(BOOL)transitionBar {
    objc_setAssociatedObject(self, @selector(isUsedForTransition), @(transitionBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getter

- (BOOL)isUsedForTransition {
    NSNumber *number = objc_getAssociatedObject(self, @selector(isUsedForTransition));
    return number ? number.boolValue : NO;
}
@end

@implementation UIScrollView (NNTransitionInternal)

#pragma mark - Setter
- (void)setNn_shouldRestoreContentInsetAdjustmentBehavior:(BOOL)restore {
    objc_setAssociatedObject(self, @selector(nn_shouldRestoreContentInsetAdjustmentBehavior), @(restore), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setNn_originalContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentBehavior)behavior {
    objc_setAssociatedObject(self, @selector(nn_originalContentInsetAdjustmentBehavior), @(behavior), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getter

- (BOOL)nn_shouldRestoreContentInsetAdjustmentBehavior {
    
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return number ? number.boolValue : NO;
}

- (UIScrollViewContentInsetAdjustmentBehavior)nn_originalContentInsetAdjustmentBehavior {
    
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return number ? number.integerValue : UIScrollViewContentInsetAdjustmentNever;
}

@end

@implementation UIViewController (NNTransitionInternal)

#pragma mark - Life Cycle

+ (void)load {
    NNSwizzleMethod(self, @selector(viewWillAppear:), [self class], @selector(nn_transitionViewWillAppear:));
    NNSwizzleMethod(self, @selector(viewDidAppear:), [self class], @selector(nn_transitionViewDidAppear:));
    NNSwizzleMethod(self, @selector(viewWillLayoutSubviews), [self class], @selector(nn_transitionViewWillLayoutSubviews));
}

#pragma mark - Swizzle

- (void)nn_transitionViewWillAppear:(BOOL)animated {
    
    id<UIViewControllerTransitionCoordinator> tc = self.transitionCoordinator;
    UIViewController *toViewController = [tc viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if ([self isEqual:self.navigationController.viewControllers.lastObject]
        && [toViewController isEqual:self]
        && tc.presentationStyle == UIModalPresentationNone) {
        
        [self nn_adjustScrollViewContentInsetAdjustmentBehaviorIfNeeded];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.navigationController.navigationBarHidden) [self nn_restoreScrollViewContentInsetAdjustmentBehaviorIfNeeded];
        });
    }

    [self.navigationController setNavigationBarHidden:self.nn_perfersNavigationBarHidden animated:animated];

    [self nn_transitionViewWillAppear:animated];
}

- (void)nn_transitionViewDidAppear:(BOOL)animated {
    
    [self nn_restoreScrollViewContentInsetAdjustmentBehaviorIfNeeded];
    
    if (self.nn_transitionBar) {
        self.navigationController.navigationBar.barTintColor = self.nn_transitionBar.barTintColor;
        [self.navigationController.navigationBar setBackgroundImage:[self.nn_transitionBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:self.nn_transitionBar.shadowImage];

        [self.nn_transitionBar removeFromSuperview];
        self.nn_transitionBar = nil;
    }

    self.navigationController.nn_backgroundViewHidden = NO;

    [self nn_transitionViewDidAppear:animated];
}

- (void)nn_transitionViewWillLayoutSubviews {
    
    id<UIViewControllerTransitionCoordinator> tc = self.transitionCoordinator;
    UIViewController *fromViewController = [tc viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [tc viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if ([self isEqual:self.navigationController.viewControllers.lastObject]
        && [toViewController isEqual:self]
        && tc.presentationStyle == UIModalPresentationNone) {
        
        if (self.navigationController.navigationBar.translucent) {
            [tc containerView].backgroundColor = [self.navigationController nn_containerViewBackgroundColor];
        }
        fromViewController.view.clipsToBounds = NO;
        toViewController.view.clipsToBounds = NO;

        if (!self.nn_transitionBar) {
            [self nn_insertTransitionBarIfNeeded];
            self.navigationController.nn_backgroundViewHidden = YES;
        }
        [self nn_layoutTransitionBarFrame];
    }
    if (self.nn_transitionBar) [self.view bringSubviewToFront:self.nn_transitionBar];
    
    [self nn_transitionViewWillLayoutSubviews];
}

#pragma mark - Public

- (void)nn_insertTransitionBarIfNeeded {
    
    if (!self.isViewLoaded || !self.view.window) return;
    if (!self.navigationController.navigationBar) return;
    
    [self nn_adjustScrollViewContentOffsetIfNeeded];
    
    if (self.nn_transitionBar) [self.nn_transitionBar removeFromSuperview];
    if (!self.navigationController.isNavigationBarHidden && !self.navigationController.navigationBar.isHidden) {
        self.nn_transitionBar = [self.navigationController.navigationBar nn_transitionBar];
        [self nn_layoutTransitionBarFrame];
        [self.view addSubview:self.nn_transitionBar];
    }
}

#pragma mark - Private

- (void)nn_layoutTransitionBarFrame {
    
    if (!self.view.window) return;
    UIView *backgroundView = [self.navigationController.navigationBar valueForKey:@"_backgroundView"];
    CGRect rect = [backgroundView.superview convertRect:backgroundView.frame toView:self.view];
    self.nn_transitionBar.frame = rect;
}

- (void)nn_adjustScrollViewContentOffsetIfNeeded {

    if (self.nn_scrollView) {
        UIEdgeInsets contentInset = self.nn_scrollView.contentInset;
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            contentInset = self.nn_scrollView.adjustedContentInset;
        }
#endif
        const CGFloat topContentOffsetY = -contentInset.top;
        const CGFloat bottomContentOffsetY = self.nn_scrollView.contentSize.height - (CGRectGetHeight(self.nn_scrollView.bounds) - contentInset.bottom);
        
        CGPoint adjustedContentOffset = self.nn_scrollView.contentOffset;
        adjustedContentOffset.y = MIN(adjustedContentOffset.y, bottomContentOffsetY);
        adjustedContentOffset.y = MAX(adjustedContentOffset.y, topContentOffsetY);
        [self.nn_scrollView setContentOffset:adjustedContentOffset animated:NO];
    }
}

- (void)nn_adjustScrollViewContentInsetAdjustmentBehaviorIfNeeded {
    
#ifdef __IPHONE_11_0
    if (self.navigationController.navigationBar.translucent) return;
    
    if (@available(iOS 11.0, *)) {

        if (self.nn_scrollView) {
            UIScrollViewContentInsetAdjustmentBehavior contentInsetAdjustmentBehavior = self.nn_scrollView.contentInsetAdjustmentBehavior;
            if (contentInsetAdjustmentBehavior != UIScrollViewContentInsetAdjustmentNever) {
                self.nn_scrollView.nn_originalContentInsetAdjustmentBehavior = contentInsetAdjustmentBehavior;
                self.nn_scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
                self.nn_scrollView.nn_shouldRestoreContentInsetAdjustmentBehavior = YES;
            }
        }
    }
#endif
}

- (void)nn_restoreScrollViewContentInsetAdjustmentBehaviorIfNeeded {
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {

        if (self.nn_scrollView && self.nn_scrollView.nn_shouldRestoreContentInsetAdjustmentBehavior) {
            self.nn_scrollView.contentInsetAdjustmentBehavior = self.nn_scrollView.nn_originalContentInsetAdjustmentBehavior;
            self.nn_scrollView.nn_shouldRestoreContentInsetAdjustmentBehavior = NO;
        }
    }
#endif
}


#pragma mark - Setter

- (void)setNn_transitionBar:(UINavigationBar *)transitionBar {
    objc_setAssociatedObject(self, @selector(nn_transitionBar), transitionBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setNn_scrollView:(UIScrollView *)nn_scrollView {
    objc_setAssociatedObject(self, @selector(nn_scrollView), nn_scrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getter

- (UINavigationBar *)nn_transitionBar {
    
    UINavigationBar *bar = objc_getAssociatedObject(self, @selector(nn_transitionBar));
    if (bar && bar.isUsedForTransition) return bar;
    return nil;
}

- (UIScrollView *)nn_scrollView {
    
    UIScrollView *scrollView = objc_getAssociatedObject(self, @selector(nn_scrollView));
    if (!scrollView && [self.view isKindOfClass:[UIScrollView class]]) return (UIScrollView *)self.view;
    return nil;
}

@end

@implementation UINavigationController (NNTransitionInternal)

#pragma mark - Life Cycle

+ (void)load {
    
    NNSwizzleMethod([self class],
                    @selector(pushViewController:animated:),
                    [self class],
                    @selector(nn_transitionPushViewController:animated:));
    
    NNSwizzleMethod([self class],
                    @selector(popViewControllerAnimated:),
                    [self class],
                    @selector(nn_transitionPopViewControllerAnimated:));
    
    NNSwizzleMethod([self class],
                    @selector(popToViewController:animated:),
                    [self class],
                    @selector(nn_transitionPopToViewController:animated:));
    
    NNSwizzleMethod([self class],
                    @selector(popToRootViewControllerAnimated:),
                    [self class],
                    @selector(nn_transitionPopToRootViewControllerAnimated:));
    
    NNSwizzleMethod([self class],
                    @selector(setViewControllers:animated:),
                    [self class],
                    @selector(nn_transitionSetViewControllers:animated:));

}
#pragma mark - Swizzle

- (void)nn_transitionPushViewController:(UIViewController *)controller animated:(BOOL)animated {
    
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    if (disappearingViewController && !disappearingViewController.nn_transitionBar) {
        [disappearingViewController nn_insertTransitionBarIfNeeded];
    }
    
    if (animated && disappearingViewController.nn_transitionBar) {
        disappearingViewController.navigationController.nn_backgroundViewHidden = YES;
    }

    [self nn_transitionPushViewController:controller animated:animated];
}

- (UIViewController *)nn_transitionPopViewControllerAnimated:(BOOL)animated {
    
    if (self.viewControllers.count <= 1) [self nn_transitionPopViewControllerAnimated:animated];
    
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    UIViewController *appearingViewController = self.viewControllers[self.viewControllers.count - 2];
    
    [self nn_updateNavigationBarStyleWhileTransition:appearingViewController
                              disappearingController:disappearingViewController
                                            animated:animated];
    return [self nn_transitionPopViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)nn_transitionPopToViewController:(UIViewController *)controller
                                                         animated:(BOOL)animated {
 
    if (![self.viewControllers containsObject:controller] || self.viewControllers.count <= 1)
        return [self nn_transitionPopToViewController:controller animated:animated];
    
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    [self nn_updateNavigationBarStyleWhileTransition:controller
                              disappearingController:disappearingViewController
                                            animated:animated];
    return [self nn_transitionPopToViewController:controller animated:animated];
}

- (NSArray<UIViewController *> *)nn_transitionPopToRootViewControllerAnimated:(BOOL)animated {
    
    if (self.viewControllers.count <= 1) [self nn_transitionPopViewControllerAnimated:animated];
    
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    UIViewController *appearingViewController = self.viewControllers.firstObject;
    [self nn_updateNavigationBarStyleWhileTransition:appearingViewController
                              disappearingController:disappearingViewController
                                            animated:animated];
    return [self nn_transitionPopToRootViewControllerAnimated:animated];
}

- (void)nn_transitionSetViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    if (animated && disappearingViewController && ![disappearingViewController isEqual:viewControllers.lastObject]) {
        [disappearingViewController nn_insertTransitionBarIfNeeded];
        if (disappearingViewController.nn_transitionBar) disappearingViewController.navigationController.nn_backgroundViewHidden = YES;
    }
    [self nn_transitionSetViewControllers:viewControllers animated:animated];
}

#pragma mark - Private

- (void)nn_updateNavigationBarStyleWhileTransition:(UIViewController *)appearingController
                            disappearingController:(UIViewController *)disappearingController
                                          animated:(BOOL)animated {
    
    [disappearingController nn_insertTransitionBarIfNeeded];
    if (appearingController) {
        UINavigationBar *appearingBar = appearingController.nn_transitionBar;
        self.navigationBar.barTintColor = appearingBar.barTintColor;
        [self.navigationBar setBackgroundImage:[appearingBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.shadowImage = appearingBar.shadowImage;
    }
    if (animated) disappearingController.navigationController.nn_backgroundViewHidden = YES;
}

#pragma mark - Setter

- (void)setNn_backgroundViewHidden:(BOOL)hidden {
    
    objc_setAssociatedObject(self, @selector(nn_backgroundViewHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [[self.navigationBar valueForKey:@"_backgroundView"] setHidden:hidden];
}

#pragma mark - Getter

- (BOOL)nn_backgroundViewHidden {
    
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return number ? number.boolValue : NO;
}

- (UIColor *)nn_containerViewBackgroundColor {
    return [UIColor whiteColor];
}

@end


@implementation UIViewController (NNTransition)

#pragma mark - Setter

- (void)setNn_perfersNavigationBarHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, @selector(nn_perfersNavigationBarHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getter

- (BOOL)nn_perfersNavigationBarHidden {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return number ? number.boolValue : NO;
}

@end
