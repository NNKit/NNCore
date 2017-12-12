//
//  NNFPS.h
//  
//
//  Created by XMFraker on 16/12/23.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 提供一个实时监控FPS变化的动态显示控件
 fpsLabel 会被添加在keyWindow上
 */
@interface NNFPS : NSObject

/** 显示fps的lable,可以定制起文字,颜色等 */
@property (strong, nonatomic, readonly) UILabel *fpsLabel;

+ (instancetype)sharedFPS;

/**
 开启FPS
 */
- (void)open;

/**
 停止FPS统计
 */
- (void)close;

@end
