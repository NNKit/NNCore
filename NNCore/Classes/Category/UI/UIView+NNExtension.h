//
//  UIView+NNExtension.h
//  
//
//  Created by XMFraker on 17/2/27.
//  Copyright © 2017年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NNExtension)

/** Shortcut for frame.origin.x */
@property (assign, nonatomic) CGFloat left;
/** Shortcut for frame.origin.y */
@property (assign, nonatomic) CGFloat top;
/** Shortcut for frame.origin.x + frame.size.width */
@property (assign, nonatomic) CGFloat right;
/** Shortcut for frame.origin.y + frame.size.height */
@property (assign, nonatomic) CGFloat bottom;
/** Shortcut for frame.size.width */
@property (assign, nonatomic) CGFloat width;
/** Shortcut for frame.size.height */
@property (assign, nonatomic) CGFloat height;
/** Shortcut for center.x */
@property (assign, nonatomic) CGFloat centerX;
/** Shortcut for center.y */
@property (assign, nonatomic) CGFloat centerY;
/** Shortcut for frame.origin */
@property (assign, nonatomic) CGPoint origin;
/** Shortcut for frame.size */
@property (assign, nonatomic) CGSize  size;

@end

@interface UIView (NNLayerExtension)
/** Shortcut for layer.borderWidth */
@property (assign, nonatomic) IBInspectable CGFloat borderWidth;
/** Shortcut for layer.borderColor */
@property (strong, nonatomic, nullable) IBInspectable UIColor  *borderColor;
/** Shortcut for layer.cornerRadius */
@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;
/** Shortcut for layer.shadowColor */
@property (strong, nonatomic, nullable) IBInspectable UIColor  *shadowColor;
/** Shortcut for layer.shadowOffset */
@property (assign, nonatomic) IBInspectable CGSize shadowOffset;
/** Shortcut for layer.shadowRadius */
@property (assign, nonatomic) IBInspectable CGFloat shadowRadius;
/** Shortcut for layer.shadowOpacity */
@property (assign, nonatomic) IBInspectable CGFloat shadowOpacity;

@end

@interface UIView (NNSnapshotExtension)

/** 获取当前UIView的截图图片 */
@property (strong, nonatomic, readonly, nullable) UIImage *snapshot;

/** 获取当前UIView 所属的viewController */
@property (strong, nonatomic, readonly, nullable) UIViewController *viewController;

/**
 获取当前view的屏幕截图
 比直接调用snapshot速度更快
 See -[UIView drawViewHierarchyInRect:afterScreenUpdates:] for more information.

 @param updates 是否更新屏幕
 @return UIImage or nil
 */
- (nullable UIImage *)snapshotAfterScreenUpdates:(BOOL)updates;

@end
