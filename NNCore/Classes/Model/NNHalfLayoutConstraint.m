//
//  WMOnePixelConstraint.m
//  
//
//  Created by XMFraker on 16/8/26.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "NNHalfLayoutConstraint.h"

@implementation NNHalfLayoutConstraint
@synthesize constant = _constant;
- (instancetype)init {
    
    if (self = [super init]) {

        _constant = 1.f / 2.f;
    }
    return self;
}

#pragma mark - Setter

- (void)setHalfConstant:(NSInteger)halfConstant {
    
    self.constant = halfConstant/2.f;
}

- (NSInteger)halfConstant {
    
    return self.constant * 2.f;
}

@end
