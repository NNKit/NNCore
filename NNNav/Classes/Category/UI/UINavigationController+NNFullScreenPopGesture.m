//  UINavigationController+NNFullScreenPopGesture.m
//  Pods
//
//  Created by  XMFraker on 2017/12/14
//  Copyright © XMFraker All rights reserved. (https://github.com/ws00801526)
//  @class      UINavigationController_NNFullScreenPopGesture
//  @version    <#class version#>
//  @abstract   <#class description#>

#import "UINavigationController+NNFullScreenPopGesture.h"

#import <objc/runtime.h>
#import <NNCore/NNCore.h>

@implementation UINavigationController (NNFullScreenPopGesture)

+ (void)load {
    NNSwizzleMethod([self class],
                    @selector(pushViewController:animated:),
                    [self class],
                    @selector(nn_fullScreenPopGesture_pushViewController:animated:));
}

#pragma mark - Swizzle

- (void)nn_fullScreenPopGesture_pushViewController:(__kindof UIViewController *)viewController
                                          animated:(BOOL)animated {
    
    if (!self.nn_perfersPopGestureDisabled && ![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.nn_popGestrue]) {
        
        /** 给系统返回手势触发view上添加自定义返回手势 */
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.nn_popGestrue];
        
        /** 解析系统自带返回手势 target,action, 转发到自定义panGes */
        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        self.nn_popGestrue.delegate = (id<UIGestureRecognizerDelegate>)self;
        [self.nn_popGestrue addTarget:internalTarget action:internalAction];
        
        /** 禁止系统自带的手势返回 */
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [self nn_fullScreenPopGesture_pushViewController:viewController animated:animated];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    
    // Ignore when no view controller is pushed into navigation stack
    if (self.viewControllers.count <= 1) return NO;
   
    // Ignore global navigation disable pop gesture
    if (self.nn_perfersPopGestureDisabled) return NO;
    
    // Ignore top view controller disable pop gesture
    UIViewController *visibleController = self.viewControllers.lastObject;
    if (visibleController.nn_interactivePopDisabled) return NO;
    
    // Ignore translation.x > pop gesture offset
    const CGPoint location = [gestureRecognizer locationInView:visibleController.view];
    const CGFloat offset = visibleController.nn_interactivePopOffset;
    const CGFloat availableOffsetX = (SCREEN_WIDTH - offset);
    if (offset > 0 && (location.x > availableOffsetX))
        return NO;

    // Ignore pan gestrue is transitioning
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) return NO;
    
    //
    const CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    const BOOL isLeftToRight = [UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionLeftToRight;
    const CGFloat multiplier = isLeftToRight ? 1 : - 1;
    if ((translation.x * multiplier) <= 0) return NO;
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
    shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if (gestureRecognizer == self.nn_popGestrue) {
        if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
            return [(UIScrollView *)otherGestureRecognizer.view contentOffset].x <= 0;
        } else if ([otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Setter

- (void)setNn_perfersPopGestureDisabled:(BOOL)disabled {
    objc_setAssociatedObject(self, @selector(nn_perfersPopGestureDisabled), @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getter

- (UIPanGestureRecognizer *)nn_popGestrue {
    
    UIPanGestureRecognizer *panGes = objc_getAssociatedObject(self, _cmd);
    if (!panGes) {
        panGes = [[UIPanGestureRecognizer alloc] init];
        panGes.maximumNumberOfTouches = 1;
        objc_setAssociatedObject(self, _cmd, panGes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGes;
}

- (BOOL)nn_perfersPopGestureDisabled {
    return objc_getAssociatedObject(self, @selector(nn_perfersPopGestureDisabled));
}

@end

@implementation UIViewController (NNFullScreenPopGesture)

#pragma mark - Setter

- (void)setNn_interactivePopDisabled:(BOOL)disabled {
    objc_setAssociatedObject(self, @selector(nn_interactivePopDisabled), @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setNn_interactivePopOffset:(CGFloat)offset {
    objc_setAssociatedObject(self, @selector(nn_interactivePopOffset), @(offset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getter

- (BOOL)nn_interactivePopDisabled {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return number ? [number boolValue] : NO;
}

- (CGFloat)nn_interactivePopOffset {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return number ? [number floatValue] : CGFLOAT_MIN;
}

@end
