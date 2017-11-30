//
//  WMOnePixelConstraint.h
//  
//
//  Created by XMFraker on 16/8/26.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface NNHalfLayoutConstraint : NSLayoutConstraint
/** 设置约束的值, self.constant = halfConstant/2.f 默认1.0 */
@property (nonatomic) IBInspectable NSInteger halfConstant;

@end
