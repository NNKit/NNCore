//
//  NNDataExtensionSpec.m
//  NNCore
//
//  Created by XMFraker on 2017/11/14.
//  Copyright 2017年 ws00801526. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <NNCore/NNCore.h>

SPEC_BEGIN(NNDataExtensionSpec)

describe(@"NNDataExtension", ^{
    
    context(@"test NNDataExtension", ^{
       
        __block NSString *randomString = nil;
        __block NSData *randomData = nil;
        beforeAll(^{
            randomString = @"这是一段简要的文本测试, 主要用于NSData+NNExtension中NSData加密算法测试功能";
            randomData = [randomString dataValue];
        });
        
        it(@"test gzip inflate deflate", ^{

            NSData *deflateData = [randomData gzipDeflate];
            NSData *inflateData = [deflateData gzipInflate];
        
            [[randomData should] equal:inflateData];
            [[randomData shouldNot] equal:deflateData];
            [[[randomData utf8String] should] equal:[inflateData utf8String]];
        });
        
        it(@"test zib inflate deflate", ^{
           
            NSData *deflateData = [randomData zlibDeflate];
            NSData *inflateData = [deflateData zlibInflate];
            
            [[randomData should] equal:inflateData];
            [[randomData shouldNot] equal:deflateData];
            [[[randomData utf8String] should] equal:[inflateData utf8String]];
        });
        
        it(@"test data hash", ^{
            
            [[[randomData md2String] should] equal:@"0421b86b994a50986236547f3df20176"];
            [[[randomData md4String] should] equal:@"25e525abefaf5bfceed87f1bfa5d16cb"];
            [[[randomData md5String] should] equal:@"a177d3579bc2184e19ac74356f27975a"];

            [[[randomString crc32String] should] equal:[randomData crc32String]];
        });
        
        it(@"test data encrypt", ^{
            
            NSData *enData = [randomData aes256EncryptWithKey:[@"XMFrakerXMFraker" dataValue] iv:nil];
            NSData *deData = [enData aes256DecryptWithkey:[@"XMFrakerXMFraker" dataValue] iv:nil];
            
            [[deData should] equal:randomData];
            [[[deData utf8String] should] equal:randomString];
        });
        
        it(@"test data decode", ^{

            NSString *expectEncodedString = @"6L+Z5piv5LiA5q61566A6KaB55qE5paH5pys5rWL6K+VLCDkuLvopoHnlKjkuo5OU0RhdGErTk5FeHRlbnNpb27kuK1OU0RhdGHliqDlr4bnrpfms5XmtYvor5Xlip/og70=";
            
            [[[randomData base64EncodedString] should] equal:expectEncodedString];
            [[[randomString base64EncodedString] should] equal:[randomData base64EncodedString]];
            [[[NSString stringWithBase64EncodedString:expectEncodedString] should] equal:randomString];
            [[[NSData dataWithBase64EncodedString:expectEncodedString] should] equal:randomData];
        });
    });
});

SPEC_END
