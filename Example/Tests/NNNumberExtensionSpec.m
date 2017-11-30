//
//  NNNumberExtensionSpec.m
//  NNCore
//
//  Created by XMFraker on 2017/11/14.
//  Copyright 2017年 ws00801526. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <NNCore/NNCore.h>

SPEC_BEGIN(NNNumberExtensionSpec)

describe(@"NNNumberExtension", ^{

    context(@"test NSNumber+NNExtension", ^{
    
        
        it(@"test bool", ^{
           
            [[[NSNumber numberWithString:@"true"] should] equal:@1];
            [[[NSNumber numberWithString:@"false"] should] equal:@0];
            [[[NSNumber numberWithString:@"yes"] should] equal:@1];
            [[[NSNumber numberWithString:@"1"] should] equal:@1];
            [[[NSNumber numberWithString:@"nil"] should] beNil];
            [[[NSNumber numberWithString:@"NULL"] should] beNil];
            [[[NSNumber numberWithString:@"null"] should] beNil];

            [[[NSNumber numberWithString:@"2.53"] should] equal:@2.53];
            [[[NSNumber numberWithString:@"-2.53"] should] equal:@(-2.53)];
            [[[NSNumber numberWithString:@"0x10"] should] equal:@16];

        });
        
    });
    
});

SPEC_END
