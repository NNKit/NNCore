//
//  NNViewController.h
//  NNCore
//
//  Created by ws00801526 on 11/14/2017.
//  Copyright (c) 2017 ws00801526. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSUInteger, NNViewControllerStyle) {
    
    NNViewControllerStyleDefault,
    NNViewControllerStyleBarHidden,
    NNViewControllerStyleDisablePop,
    NNViewControllerStyleEnablePopOffset
};

typedef NS_ENUM(NSUInteger, NNViewControllerColorMode) {
    NNViewControllerColorModeDefault,
    NNViewControllerColorModeLightGray,
    NNViewControllerColorModeCyan,
    NNViewControllerColorModeRed,
    NNViewControllerColorModeYellow,
    NNViewControllerColorModeOrange,
    NNViewControllerColorModeMask
};

@interface NNViewControllerStyleModel : NSObject

@property (assign, nonatomic) NNViewControllerStyle style;
@property (assign, nonatomic, getter=isBarHidden) BOOL barHidden;
@property (assign, nonatomic) NNViewControllerColorMode barTintColorMode;
@property (assign, nonatomic) NNViewControllerColorMode barBackgroundColorMode;

@property (assign, nonatomic, getter=isPopGestureDisabled) BOOL popGestureDisabled;
@property (assign, nonatomic) CGFloat popGestureOffset;
@property (assign, nonatomic, getter=isBarShadowHidden) BOOL barShadowHidden;
@property (assign, nonatomic, getter=isTranslucent) BOOL translucent;


@property (strong, nonatomic, readonly) UIColor *barTintColor;
@property (strong, nonatomic, readonly) UIColor *barBackgroundColor;

- (instancetype)initWithStyle:(NNViewControllerStyle)style;

+ (UIColor *)colorFormColorMode:(NNViewControllerColorMode)mode;
+ (NSString *)colorTitleFormColorMode:(NNViewControllerColorMode)mode;
@end

@interface NNViewController : UITableViewController

@property (strong, nonatomic) NNViewControllerStyleModel *styleModel;

@end
