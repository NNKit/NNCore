//
//  NNRouterSpecSpec.m
//  NNCore
//
//  Created by XMFraker on 2017/11/10.
//  Copyright 2017年 ws00801526. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <NNCore/NNCore.h>

SPEC_BEGIN(NNRouterSpecSpec)

describe(@"NNRouterSpec", ^{
    context(@"test Router Generate", ^{
        
        it(@"test NNRouter Generate URL", ^{
            
            NSString *URLPattern = [NNRouter generateURLWithPattern:@"icare://name/:age/:sex" parameters:@{@"sex":@"1",@"age":@"28",@"city":@"shanghai"}];
            [[URLPattern should] equal:@"icare://name/28/1?city=shanghai"];
            
            [[[NNRouter generateURLWithPattern:@"icare://name/:age/:sex?country=china" parameters:@{@"sex":@"1",@"age":@"28",@"city":@"shanghai"}] should] equal:@"icare://name/28/1?country=china&city=shanghai"];
            
            [[[NNRouter generateURLWithPattern:@"icare://name/:age/:sex?country=china" parameters:@{@"sex":@"1",@"age":@"28",@"city":@"shanghai",@"address":@"ymyl"}] should] equal:@"icare://name/28/1?country=china&city=shanghai&address=ymyl"];
            
            [[[NNRouter generateURLWithPattern:@"icare://name/:age/:sex?country=china" parameters:nil] should] equal:@"icare://name/:age/:sex?country=china"];
        });
        
    });
    
    context(@"test Router Host", ^{
        
        it(@"test global", ^{
            
            [NNRouter registerURLPattern:@"icare" toHandler:^(NSDictionary * _Nonnull parameter) {
                
                NSLog(@"this is global handler :%@",parameter);
            }];
            
            [NNRouter registerURLPattern:@"icare://com.yuanbao.welfaremall/name/age" toHandler:^(NSDictionary * _Nonnull parameter) {
                
                NSLog(@"this is parameter :%@",parameter);
            }];
            
            [NNRouter openURL:@"icare://com.yuanbao.welfaremall/name/age"];
            [NNRouter openURL:@"icare://name/age"];
        });
        
        it(@"test no scheme", ^{
            
            
            [NNRouter registerURLPattern:@"name/age" toHandler:^(NSDictionary * _Nonnull parameter) {
                
                NSLog(@"this is name/age");
            }];
            
            [NNRouter registerURLPattern:@"/name/age" toHandler:^(NSDictionary * _Nonnull parameter) {
                
                NSLog(@"this is /name/age");
            }];
            
            [NNRouter openURL:@"icare://name/age"];
            [NNRouter openURL:@"name/age"];
            [NNRouter openURL:@"/name/age"];
        });
        
        it(@"test WMRouoter With Chinese", ^{
            
            [NNRouter registerURLPattern:@"icare://chinese" toHandler:^(NSDictionary * _Nonnull parameter) {
                
                NSLog(@"this is test chinese parameter :%@",parameter);
                
                void(^completionHandler)(id result) = parameter[NNRouterParameterCompletionHandler];
                completionHandler ? completionHandler([parameter[@"name"] isEqualToString:@"陈茂磊"] ? @YES : @NO) : nil;
            }];
            
            [NNRouter openURL:@"icare://chinese?name=陈茂磊" completionHandler:^(id  _Nullable result) {
                
                [[result should] beYes];
            }];
            
        });
        
        afterAll(^{
            
            [NNRouter deregisterURLPattern:@"icare"];
            [NNRouter deregisterURLPattern:@"icare://name/age"];
        });
    });
    
    context(@"test Router Register", ^{
        
        it(@"test NNRouter", ^{
            [[[NNRouter class]  shouldNot] beNil];
            
            [NNRouter registerURLPattern:@"icare://do/it" toHandler:^(NSDictionary *parameter){
                
                NSLog(@"it will do it ");
                NNRouterCompletionHandler completionHandler = parameter[NNRouterParameterCompletionHandler];
                completionHandler ? completionHandler(parameter) : nil;
            }];
            
            
            [NNRouter registerURLPattern:@"icare://name" toObjectHandler:^id _Nonnull(NSDictionary * _Nonnull parameter) {
                
                NSLog(@"whats parameter :%@",parameter);
                return [parameter[NNRouterParameterUserInfo] boolValueForKey:@"sayHello"] ? @"Hello, my name is Jhon Smith" : @"Jhon Smith";
            }];
            
            [[theValue([NNRouter canOpenURL:@"icare://name"]) should] beYes];
            [[theValue([NNRouter canOpenURL:@"icare://"]) shouldNot] beYes];
            [[theValue([NNRouter canOpenURL:@"icare"]) shouldNot] beYes];
            
            [[[NNRouter objectForURL:@"icare://name"] should] equal:@"Jhon Smith"];
            [[[NNRouter objectForURL:@"icare://name" withUserInfo:@{@"sayHello" : @1}] should] equal:@"Hello, my name is Jhon Smith"];
            
            [NNRouter openURL:@"icare://do/it?name=XMFraker&age=28" withUserInfo:@{@"sex":@0} completionHandler:^(id  _Nullable result) {
                
                [[result[NNRouterParameterURL] should] equal:@"icare://do/it?name=XMFraker&age=28"];
                [[result[NNRouterParameterUserInfo] should] equal:@{@"sex":@0}];
            }];
            
            [[theValue([NNRouter canOpenURL:@"icare://do/it"]) should] beYes];
            
            /** 测试删除协议匹配 */
            [NNRouter deregisterURLPattern:@"icare://name"];
            [[theValue([NNRouter canOpenURL:@"icare://name"]) shouldNot] beYes];
        });
    });

});

SPEC_END
