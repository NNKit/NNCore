//
//  NNCoreColorExtensionSpec.m
//  NNCore
//
//  Created by XMFraker on 2017/11/10.
//  Copyright 2017年 ws00801526. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <NNCore/NNCore.h>

SPEC_BEGIN(NNCoreColorExtensionSpec)

describe(@"NNCoreColorExtension", ^{
    context(@"test UIColor+NNExtension", ^{
        
        it(@"test UIColor HEXColor", ^{
            
            UIColor *hexColor = [UIColor colorWithHexString:@"0xBBCCFF"];
            UIColor *hexColor2 = [UIColor colorWithHexString:@"#BBCCFF"];
            UIColor *hexColor3 = [UIColor colorWithHexString:@"#BCF"];
            UIColor *hexColor4 = [UIColor colorWithHexString:@"BCF"];
            
            [[hexColor2 should] equal:hexColor];
            [[hexColor3 should] equal:hexColor2];
            [[hexColor4 should] equal:hexColor3];

            [[theValue([hexColor rgbValue]) should] equal:theValue([hexColor2 rgbValue])];
            [[theValue([hexColor hex]) should] equal:theValue([hexColor2 hex])];
            
            
            UIColor *hexAlphaColor = NNColorHex(0xBBCCFFDD);
            [[[hexAlphaColor hex] should] equal:@"bbccff"];
        });
        
    });

});

SPEC_END
