//
//  NNCoreSpec.m
//  NNCore
//
//  Created by XMFraker on 2017/11/10.
//  Copyright 2017年 ws00801526. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <NNCore/NNCore.h>


SPEC_BEGIN(NNCoreSpec)

describe(@"NNCore", ^{
    
    
    
    beforeAll(^{
        NNTick
    });
    
    
    afterAll(^{
        NNTock
    });
    
    context(@"test NNCore Defines", ^{
       
        it(@"test NSTimer Global Handler ", ^{
            [[theValue([NSTimer respondsToSelector:@selector(timerWithTimeInterval:repeats:block:)]) should] beYes];
            [[theValue([NSTimer respondsToSelector:@selector(timerWithTimeInterval:repeats:handler:)]) should] beYes];
            [[theValue([NSTimer instancesRespondToSelector:@selector(timerWithTimeInterval:repeats:handler:)]) should] beNo];
        });
        
        it(@"test SCREEN Defines", ^{ // 使用iPhone8 11.0 模拟器
           
            [[theValue(SCREEN_WIDTH) should] equal:@375];
            [[theValue(SCREEN_HEIGHT) should] equal:@667];
           
            [[theValue(iOS7Later) should] beYes];
            [[theValue(iOS8Later) should] beYes];
            [[theValue(iOS9Later) should] beYes];
            [[theValue(iOS10Later) should] beYes];
            [[theValue(iOS11Later) should] beYes];
            
            [[theValue(iPhoneX) should] beNo];
            [[theValue(iPhone4s) should] beNo];
            [[theValue(iPhone5s) should] beNo];
            [[theValue(iPhone6s) should] beYes];
            [[theValue(iPhonePlus) should] beNo];
        });
        
        it(@"test Bundle Defines", ^{
            
            [[NNMainBundle shouldNot] equal:NNLocalBundle];
            [[NNBundle([self class]) should] equal:NNLocalBundle];
            [[NNMainBundle should] equal:[NSBundle mainBundle]];
        });
    });
    
});

SPEC_END
