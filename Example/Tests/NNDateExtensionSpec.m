//
//  NNDateExtensionSpec.m
//  NNCore
//
//  Created by XMFraker on 2017/11/10.
//  Copyright 2017年 ws00801526. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <NNCore/NNCore.h>


SPEC_BEGIN(NNDateExtensionSpec)

describe(@"NNDateExtension", ^{
    context(@"test NSDate+NNExtension", ^{
        
        __block NSDate *leapDate = nil;
        beforeEach(^{
            leapDate = [NSDate dateFromString:@"2020-11-11 11:11:11"];
        });
        
        it(@"test date commpontents", ^{
            
            NSDate *today = [NSDate date];
            [[theValue([today isToday]) should] beYes];
            [[theValue([today isYesterday]) should] beNo];
            
            NSDate *yesterday = [today yesterday];
            [[theValue([yesterday isYesterday]) should] beYes];
            [[theValue([yesterday isToday]) should] beNo];
            
            NSDate *tomorrow = [today tomorrow];
            [[theValue([tomorrow isYesterday]) should] beNo];
            [[theValue([tomorrow isToday]) should] beNo];
            
            [[theValue([leapDate year]) should] equal:@2020];
            [[theValue([leapDate month]) should] equal:@11];
            [[theValue([leapDate day]) should] equal:@11];
            [[theValue([leapDate hour]) should] equal:@11];
            [[theValue([leapDate minute]) should] equal:@11];
            [[theValue([leapDate second]) should] equal:@11];
            
            [[theValue([leapDate weekday]) should] equal:@4];
            [[theValue([leapDate weekdayOrdinal]) should] equal:@2];
            [[theValue([leapDate weekOfMonth]) should] equal:@2];
            [[theValue([leapDate weekOfYear]) should] equal:@46];
            
            [[theValue([leapDate isLeapYear]) should] beYes];
            [[theValue([today isLeapYear]) should] beNo];
            
            [[theValue([leapDate isLeapMonth]) should] beNo];
        });
        
        it(@"test date format", ^{
            
            NSString *string = @"2020-11-11 11:11:11";
            NSDate *theDate = [NSDate dateFromString:string];
            
            NSDate *localDate = [NSDate dateFromString:string
                                                format:kNNDefaultDateFormat
                                              timeZone:nil
                                                 local:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
            
            NSDate *timeZoneDate = [NSDate dateFromString:string
                                                   format:kNNDefaultDateFormat
                                                 timeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]
                                                    local:nil];
            
            NSDate *fullDate = [NSDate dateFromString:string
                                               format:kNNDefaultDateFormat
                                             timeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]
                                                local:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
            
            
            NSString *theDateString = [theDate stringWithFormat:kNNDefaultDateFormat];
            NSString *localDateString = [theDate stringWithFormat:kNNDefaultDateFormat
                                                         timeZone:nil
                                                            local:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
            NSString *timeZoneDateString = [theDate stringWithFormat:kNNDefaultDateFormat
                                                            timeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]
                                                               local:nil];
            NSString *fullDateString = [theDate stringWithFormat:kNNDefaultDateFormat
                                                        timeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]
                                                           local:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
            
            NSString *theDateISO = [theDate stringWithISOFormat];
            NSString *localDateISO = [localDate stringWithISOFormat];
            NSString *timeZoneISO = [timeZoneDate stringWithISOFormat];
            NSString *fullDateISO = [fullDate stringWithISOFormat];

            [[theDate should] equal:localDate];
            [[theDate shouldNot] equal:timeZoneDate];
            [[timeZoneDate should] equal:fullDate];
            
            [[theDateString should] equal:localDateString];
            [[theDateString shouldNot] equal:timeZoneDateString];
            [[timeZoneDateString should] equal:fullDateString];

            [[theDateISO should] equal:localDateISO];
            [[theDateISO shouldNot] equal:timeZoneISO];
            [[timeZoneISO should] equal:fullDateISO];
        });
        
        it(@"test date calculator", ^{
            
            NSDate *theDate = leapDate;
            [[theValue([[theDate tomorrow] day]) should] equal:@12];
            [[theValue([[theDate yesterday] day]) should] equal:@10];
            
            [[theValue([[theDate dateByAddingDays:2] day]) should] equal:@13];
            [[theValue([[theDate dateByAddingDays:-2] day]) should] equal:@9];
            
            [[theValue([[theDate dateByAddingHours:2] hour]) should] equal:@13];
            [[theValue([[theDate dateByAddingHours:-2] hour]) should] equal:@9];
            
            [[theValue([[theDate dateByAddingMinutes:2] minute]) should] equal:@13];
            [[theValue([[theDate dateByAddingMinutes:-2] minute]) should] equal:@9];
            
            [[theValue([[theDate dateByAddingSeconds:2] second]) should] equal:@13];
            [[theValue([[theDate dateByAddingSeconds:-2] second]) should] equal:@9];
            
            [[theValue([[theDate dateByAddingWeeks:1] day]) should] equal:@18];
            [[theValue([[theDate dateByAddingWeeks:-1] day]) should] equal:@4];
            
            [[theValue([[theDate dateByAddingMonths:-1] month]) should] equal:@10];
            [[theValue([[theDate dateByAddingMonths:1] month]) should] equal:@12];
            [[theValue([[theDate dateByAddingMonths:-12] month]) should] equal:@11];
            [[theValue([[theDate dateByAddingMonths:-12] year]) should] equal:@2019];
            [[theValue([[theDate dateByAddingMonths:2] month]) should] equal:@1];
            [[theValue([[theDate dateByAddingMonths:2] year]) should] equal:@2021];
            
            [[theValue([[theDate dateByAddingYears:-1] year]) should] equal:@2019];
            [[theValue([[theDate dateByAddingYears:1] year]) should] equal:@2021];
        });
        
        it(@"test NSDate NNExtension", ^{
            [[[NSDate dateFromatter] shouldNot] beNil];
            
            NSDate *date = [NSDate dateFromString:@"2017-05-12" format:kNNShortDateFormat];
            
            [[[date stringWithFormat:kNNShortDateFormat] should] equal:@"2017-05-12"];
            [[[[date tomorrow] stringWithFormat:kNNShortDateFormat] should] equal:@"2017-05-13"];
            [[[[date yesterday] stringWithFormat:kNNShortDateFormat] should] equal:@"2017-05-11"];
            
            NSString *dateString = @"2017-05-05 12:12:12";
            NSDate *date2 = [NSDate dateFromString:dateString];
            NSString *date2String = [date2 stringWithFormat:kNNDefaultDateFormat];
            [[dateString should] equal:date2String];
            
            // 切换本地时区为中文
            [[NSDate dateFromatter] setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
            
            [[[date2 stringWithFormat:@"ccc" timeZone:nil local:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]] should] equal:@"周五"];
            [[[[date2 yesterday] stringWithFormat:@"ccc" timeZone:nil local:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]] should] equal:@"周四"];
            [[[[date2 tomorrow] stringWithFormat:@"ccc" timeZone:nil local:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]] should] equal:@"周六"];
        });
        
    });
    
});

SPEC_END

