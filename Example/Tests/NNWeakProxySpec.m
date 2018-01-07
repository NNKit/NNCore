//
//  NNWeakProxySpec.m
//  NNCore
//
//  Created by XMFraker on 2017/12/13.
//  Copyright 2017年 ws00801526. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <NNCore/NNCore.h>


SPEC_BEGIN(NNWeakProxySpec)

describe(@"NNWeakProxy", ^{
    
    it(@"test NNWeakProxy Methods", ^{
        
        NSArray *mockObject = [NSArray mock];
        NNWeakProxy *proxy = [NNWeakProxy proxyWithTarget:mockObject];
        [[proxy should] beMemberOfClass:[NSArray class]];
        [[theValue([proxy respondsToSelector:@selector(objectAtIndex:)]) should] beYes];
        [[[proxy description] should] equal:[mockObject description]];
        [[proxy should] equal:mockObject];
    });
});

SPEC_END
