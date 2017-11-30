//
//  NNCoreDictionaryExtensionSpec.m
//  NNCore
//
//  Created by XMFraker on 2017/11/10.
//  Copyright 2017年 ws00801526. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <NNCore/NNCore.h>

SPEC_BEGIN(NNCoreDictionaryExtensionSpec)

describe(@"NNCoreDictionaryExtension", ^{

    context(@"test NSDicitonary+NNExtension", ^{
        
        it(@"test NSDictionary Utils", ^{
            
            NSDictionary *testDictionary = @{@"1" : @"x1",
                                             @"2" : @"x2",
                                             @(3) : NNColorHex(0xCCCCCC),
                                             NNColorHex(0xDDDDDD) : [NNColorHex(0xDDDDDD) hex]};
            
            [[theValue([testDictionary anyKeyExists:NNColorHex(0xCCCCCC)]) should] beNo];
            [[theValue([testDictionary anyKeyExists:@(2)]) should] beNo];
            [[theValue([testDictionary anyKeyExists:@"2"]) should] beYes];
            
            [[[testDictionary safeObjectForKey:@"2"] should] equal:@"x2"];
            [[[testDictionary safeObjectForKey:@"2" defaultValue:@"x22"] should] equal:@"x2"];
            [[[testDictionary safeObjectForKey:@(2) defaultValue:@"xxx22"] should] equal:@"xxx22"];
            [[[testDictionary safeObjectForKey:NNColorHex(0xDDDDDD)] should] equal:@"dddddd"];
            [[[testDictionary safeKeyOfObject:@"dddddd"] should] equal:NNColorHex(0xDDDDDD)];
            [[theValue([testDictionary anyObjectExists:@"dddddd"]) should] beYes];
            
            // test filter method
            NSDictionary *filterDictionary = [testDictionary filterKeys:@[]];
            [[testDictionary should] equal:filterDictionary];
            filterDictionary = [testDictionary filterKeys:@[@"1",@"2"]];
            [[[filterDictionary safeObjectForKey:@"1"] should] beNil];
            [[theValue([filterDictionary anyKeyExists:@"2"]) should] beNo];
        });
        
        it(@"test NSDictionary Struct Utils", ^{
            
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            [dictionary setBoolValue:YES forKey:@"bool"];
            [[theValue([dictionary boolValueForKey:@"bool"]) should] beYes];
            
            [dictionary setRectValue:CGRectMake(0, 0, 200, 200) forKey:@"rect"];
            [[theValue(CGRectEqualToRect(CGRectMake(0, 0, 200, 200), [dictionary rectValueForKey:@"rect"])) should] beYes];
            
            [dictionary setSizeValue:CGSizeMake(200, 200) forKey:@"size"];
            [[theValue(CGSizeEqualToSize(CGSizeMake(200, 200), [dictionary sizeValueForKey:@"size"])) should] beYes];
            
            [dictionary setPointValue:CGPointMake(100, 100) forKey:@"point"];
            [[theValue(CGPointEqualToPoint(CGPointMake(100, 100), [dictionary pointValueForKey:@"point"])) should] beYes];
            
            [dictionary setFloatValue:.35f forKey:@"float"];
            [[@([dictionary floatValueForKey:@"float"]) should] equal:@.35f];
            
            [dictionary setFloatValue:.7f forKey:@"number"];
            [[[dictionary numberValueForKey:@"number"] should] equal:@.7f];
        });
        
        
        it(@"test NSDictioanry NSURLUtils", ^{
            
            NSDictionary *dict = [NSDictionary queryDictionaryForURL:[NSURL URLWithString:@"https://www.baidu.com/dsadsa/dsada.html?name=XMFraker&age=23"]];
            [[[dict safeObjectForKey:@"name"] should] equal:@"XMFraker"];
        });
    });
});

SPEC_END
