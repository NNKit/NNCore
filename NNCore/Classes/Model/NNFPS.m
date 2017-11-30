//
//  NNFPS.m
//  
//
//  Created by XMFraker on 16/12/23.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "NNFPS.h"

static NNFPS *fps;
static NSInteger kNNFPSLabelTap = 101;

@interface NNFPS ()

@property (strong, nonatomic) CADisplayLink *displayLink;
@property (assign, nonatomic) NSTimeInterval lastUpdateTime;
@property (assign, nonatomic) NSUInteger     updateCount;

@property (copy, nonatomic)   void(^handler)(NSInteger fps);
@property (strong, nonatomic) UILabel *fpsLabel;

@end

@implementation NNFPS

#pragma mark - Life Cylce

+ (instancetype)sharedFPS {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fps = [[NNFPS alloc] init];
    });
    return fps;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLinkUpdate:)];
        [self.displayLink setPaused:YES];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
        self.fpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width-50)/2+50, 0, 50, 20)];
        self.fpsLabel.font=[UIFont boldSystemFontOfSize:12];
        self.fpsLabel.textColor=[UIColor colorWithRed:0.33 green:0.84 blue:0.43 alpha:1.00];
        self.fpsLabel.backgroundColor=[UIColor clearColor];
        self.fpsLabel.textAlignment=NSTextAlignmentRight;
        self.fpsLabel.tag = kNNFPSLabelTap;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleApplicationDidBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleApplicationWillResignActive)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
    }
    return self;
}


- (void)dealloc {
    [self.displayLink invalidate];
}


#pragma mark - Method

- (void)open {
    
    [self openWithHandler:nil];
}

- (void)openWithHandler:(void (^)(NSInteger))handler {
    
    self.handler = [handler copy];
    if ([[[UIApplication sharedApplication] keyWindow] viewWithTag:kNNFPSLabelTap]) {
        return;
    }

    [self.displayLink setPaused:NO];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.fpsLabel];
}

- (void)close {
    
    if ([[[UIApplication sharedApplication] keyWindow] viewWithTag:kNNFPSLabelTap]) {
        [self.fpsLabel removeFromSuperview];
    }
    [self.displayLink setPaused:YES];
    self.lastUpdateTime = 0;
    self.updateCount = 0;
}

#pragma mark - Events

- (void)handleDisplayLinkUpdate:(CADisplayLink *)link {
    
    if (self.lastUpdateTime == 0) {
        self.lastUpdateTime = link.timestamp;
        return;
    }
    
    self.updateCount++;
    NSTimeInterval interval = link.timestamp - self.lastUpdateTime;
    if (interval < 1) return;
    self.lastUpdateTime = link.timestamp;
    float fps = self.updateCount / interval;
    self.updateCount = 0;
    
    NSString *text = [NSString stringWithFormat:@"%d FPS",(int)round(fps)];
    [self.fpsLabel setText: text];
    
    if ((int)round(fps) <= 20) {
        
        self.fpsLabel.textColor = [UIColor redColor];
    }else if ((int)round(fps) <= 40){
        
        self.fpsLabel.textColor = [UIColor yellowColor];
    }else {
        
        self.fpsLabel.textColor = [UIColor greenColor];
    }
    
    self.handler ? self.handler(fps) : nil;
}

- (void)handleApplicationDidBecomeActive {
    
    [self.displayLink setPaused:NO];
}

- (void)handleApplicationWillResignActive {
    
    [self.displayLink setPaused:YES];
}

@end
