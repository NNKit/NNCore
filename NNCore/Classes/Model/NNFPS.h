//
//  NNFPS.h
//  
//
//  Created by XMFraker on 16/12/23.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NNFPS : NSObject

/** 显示fps的lable,可以定制起文字,颜色等 */
@property (strong, nonatomic, readonly) UILabel *fpsLabel;

+ (instancetype)sharedFPS;

/**
 开启FPS
 */
- (void)open;

/**
 开启FPS

 @param handler fps变化时,会回调handler
 */
- (void)openWithHandler:(void(^)(NSInteger fps))handler;

/**
 停止FPS统计
 */
- (void)close;

@end
