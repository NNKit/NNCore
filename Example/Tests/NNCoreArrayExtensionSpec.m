//
//  NNCoreArrayExtensionSpec.m
//  NNCore
//
//  Created by XMFraker on 2017/11/10.
//  Copyright 2017年 ws00801526. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <NNCore/NNCore.h>


SPEC_BEGIN(NNCoreArrayExtensionSpec)

describe(@"NNCoreArrayExtension", ^{
    
    context(@"test core NSArray+NNExtension", ^{
        
        __block NSArray *objects;
        beforeEach(^{
            objects = @[@1,@2,@3,@4,@5];
        });
        
        it(@"test execute block", ^{
            
            [[theValue([objects respondsToSelector:@selector(execute:)]) should] beYes];
            [[[objects should] have:5] items];
            
            __block NSUInteger totalValue = 0;
            [objects execute:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                totalValue += ([obj integerValue] * 100);
                *stop = (idx >= 2);
            }];
            [[theValue(totalValue) should] equal:@600];
        });
        
        it(@"test map block", ^{
            
            [[theValue([objects respondsToSelector:@selector(map:)]) should] beYes];
            NSArray *afterObjects = [objects map:^id _Nonnull(id  _Nonnull obj, NSInteger index) {
                return @([obj integerValue] * 100);
            }];
            [[[afterObjects should] have:5] items];
            
            __block NSUInteger totalValue = 0;
            [afterObjects execute:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                totalValue += ([obj integerValue]);
            }];
            [[theValue(totalValue) should] equal:@1500];
        });
        
        it(@"test filter block", ^{
            
            [[theValue([objects respondsToSelector:@selector(filter:)]) should] beYes];
            [[theValue([objects respondsToSelector:@selector(fetchOneObject:)]) should] beYes];
            NSArray *afterObjects = [objects filter:^BOOL(id  _Nonnull obj) {
                return [obj integerValue] <= 3;
            }];
            [[[afterObjects should] have:2] items];
            
            id object = [objects fetchOneObject:^BOOL(id  _Nonnull obj) {
                return [obj integerValue] >= 4;
            }];
            [[object should] equal:@4];
        });
        
        it(@"test safe block", ^{
            [[theValue([objects respondsToSelector:@selector(safeObjectAtIndex:)]) should] beYes];
            [[theValue([objects respondsToSelector:@selector(safeIndexOfObject:)]) should] beYes];
            
            [[theValue([objects safeIndexOfObject:@3]) should] equal:@2];
            [[[objects safeObjectAtIndex:3] should] equal:@4];
        });
        
        it(@"test other block", ^{
            
            [[theValue([objects respondsToSelector:@selector(any:)]) should] beYes];
            [[theValue([objects respondsToSelector:@selector(isEmpty)]) should] beYes];
            
            [[theValue([objects isEmpty]) should] beNo];
            [[theValue([[objects filter:^BOOL(id  _Nonnull obj) {
                return [obj integerValue] >= 6;
            }] isEmpty]) should] beNo];
            
            [[theValue([objects any:^BOOL(id  _Nonnull obj) {
                return [obj integerValue] == 3;
            }]) should] beYes];
            
            [[theValue([objects any:^BOOL(id  _Nonnull obj) {
                return [obj integerValue] < 10;
            }]) should] beYes];
            
            [[theValue([objects any:^BOOL(id  _Nonnull obj) {
                return [obj integerValue] >= 6;
            }]) should] beNo];
        });
        
        
        it(@"test NSArray Utils", ^{
            
            NSArray *testArray = @[@"1",@"2",@(3),@"4",@"5",NNColorHex(0xCCCCCC)];
            
            [[[testArray filter:^BOOL (id  _Nonnull obj) {
                return [obj isKindOfClass:[UIColor class]];
            }] should] equal:@[@"1",@"2",@(3),@"4",@"5"]];
            
            
            [[[testArray map:^id _Nonnull(id  _Nonnull obj, NSInteger index) {
                
                return [obj isKindOfClass:[NSString class]] ? @([obj integerValue]) : obj;
            }] should] equal:@[@(1),@(2),@(3),@(4),@(5), NNColorHex(0xCCCCCC)]];
            
            /** 存在一个@(10) */
            [[theValue([testArray any:^BOOL(id  _Nonnull obj) {
                
                return  [obj isEqual:@(10)];
            }]) should] beNo];
            
            /** 存在一个字符串 或NSNumber 并且数值<=1 */
            [[theValue([testArray any:^BOOL(id  _Nonnull obj) {
                
                return  [obj respondsToSelector:@selector(integerValue)] && [obj integerValue] <= 1;
            }]) should] beYes];
            
            [[[testArray safeObjectAtIndex:10] should] beNil];
            [[[testArray safeObjectAtIndex:4] should] equal:@"5"];
            [[theValue([testArray safeIndexOfObject:@"5"]) should] equal:@(4)];
            [[theValue([testArray safeIndexOfObject:@(20)]) should] equal:@(NSNotFound)];
        });
        
    });

});

SPEC_END
