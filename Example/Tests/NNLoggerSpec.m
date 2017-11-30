//
//  NNLoggerSpec.m
//  NNCore
//
//  Created by XMFraker on 2017/11/10.
//  Copyright 2017年 ws00801526. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <NNCore/NNCore.h>

SPEC_BEGIN(NNLoggerSpec)

describe(@"NNLogger", ^{

    context(@"test logger", ^{
        
        it(@"test level logger", ^{
            
            NNLogV(@"WMLog Test");
            NNLogD(@"WMLog Test");
            NNLogI(@"WMLog Test");
            NNLogW(@"WMLog Test");
            NNLogE(@"WMLog Test");
            
            DDLogVerbose(@"DDLog Test Verbose");
            DDLogDebug(@"DDLog Test Debug");
            DDLogInfo(@"DDLog TestInfo");
            DDLogWarn(@"DDLog Test Warnings");
            DDLogError(@"DDLog Test Error");
            
            [NNLogger configLogLevel:DDLogLevelWarning];
            
            NNLogV(@"WMLog Test");
            NNLogD(@"WMLog Test");
            NNLogI(@"WMLog Test");
            NNLogW(@"WMLog Test");
            NNLogE(@"WMLog Test");
            
            DDLogVerbose(@"DDLog Test Verbose");
            DDLogDebug(@"DDLog Test Debug");
            DDLogInfo(@"DDLog TestInfo");
            DDLogWarn(@"DDLog Test Warnings");
            DDLogError(@"DDLog Test Error");
        });
    });

});

SPEC_END
