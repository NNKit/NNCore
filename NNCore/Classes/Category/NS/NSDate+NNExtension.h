//
//  NSDate+NNExtension.h
//  NNCore
//
//  Created by XMFraker on 2017/11/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *const kNNDefaultDateFormat;
FOUNDATION_EXTERN NSString *const kNNShortDateFormat;
FOUNDATION_EXTERN NSString *const kNNShortTimeFormat;

@interface NSDate (NNExtension)

/** Year component */
@property (nonatomic, readonly) NSInteger year;
/** Month component (1~12) */
@property (nonatomic, readonly) NSInteger month;
/** Day component (1~31) */
@property (nonatomic, readonly) NSInteger day;
/** Hour component (0~23) */
@property (nonatomic, readonly) NSInteger hour;
/** Minute component (0~59) */
@property (nonatomic, readonly) NSInteger minute;
/** Second component (0~59) */
@property (nonatomic, readonly) NSInteger second;
/** Nanosecond component */
@property (nonatomic, readonly) NSInteger nanosecond;
/** Weekday component (1~7, first day is based on user setting) */
@property (nonatomic, readonly) NSInteger weekday;
/** WeekdayOrdinal component */
@property (nonatomic, readonly) NSInteger weekdayOrdinal;
/** WeekOfMonth component (1~5) */
@property (nonatomic, readonly) NSInteger weekOfMonth;
/** WeekOfYear component (1~53) */
@property (nonatomic, readonly) NSInteger weekOfYear;
/** YearForWeekOfYear component */
@property (nonatomic, readonly) NSInteger yearForWeekOfYear;
/** Quarter component */
@property (nonatomic, readonly) NSInteger quarter;
/** whether the month is leap month */
@property (nonatomic, readonly) BOOL isLeapMonth;
/** whether the year is leap year */
@property (nonatomic, readonly) BOOL isLeapYear;
/** whether date is today (based on current locale) */
@property (nonatomic, readonly) BOOL isToday;
/** whether date is yesterday (based on current locale) */
@property (nonatomic, readonly) BOOL isYesterday;
/** the date after today */
@property (copy, nonatomic, readonly)   NSDate *tomorrow;
/** the date before today */
@property (copy, nonatomic, readonly)   NSDate *yesterday;

#pragma mark - Public Methods

/**
 Returns a date representing the receiver date shifted later by the provided number of years.
 
 @param years  Number of years to add.
 @return Date modified by the number of desired years.
 */
- (nullable NSDate *)dateByAddingYears:(NSInteger)years;

/**
 Returns a date representing the receiver date shifted later by the provided number of months.
 
 @param months  Number of months to add.
 @return Date modified by the number of desired months.
 */
- (nullable NSDate *)dateByAddingMonths:(NSInteger)months;

/**
 Returns a date representing the receiver date shifted later by the provided number of weeks.
 
 @param weeks  Number of weeks to add.
 @return Date modified by the number of desired weeks.
 */
- (nullable NSDate *)dateByAddingWeeks:(NSInteger)weeks;

/**
 Returns a date representing the receiver date shifted later by the provided number of days.
 
 @param days  Number of days to add.
 @return Date modified by the number of desired days.
 */
- (nullable NSDate *)dateByAddingDays:(NSInteger)days;

/**
 Returns a date representing the receiver date shifted later by the provided number of hours.
 
 @param hours  Number of hours to add.
 @return Date modified by the number of desired hours.
 */
- (nullable NSDate *)dateByAddingHours:(NSInteger)hours;

/**
 Returns a date representing the receiver date shifted later by the provided number of minutes.
 
 @param minutes  Number of minutes to add.
 @return Date modified by the number of desired minutes.
 */
- (nullable NSDate *)dateByAddingMinutes:(NSInteger)minutes;

/**
 Returns a date representing the receiver date shifted later by the provided number of seconds.
 
 @param seconds  Number of seconds to add.
 @return Date modified by the number of desired seconds.
 */
- (nullable NSDate *)dateByAddingSeconds:(NSInteger)seconds;


@end

@interface NSDate (NNFormatExtension)

/**
 将时间日期生成指定ISOFormat格式字符串
 'yyyy-MM-dd'T'HH:mm:ssZ'
 
 @return NSString or nil
 */
- (nullable NSString *)stringWithISOFormat;

/**
 获取当前日期对应的时间字符串
 
 @param format 指定的格式
 @return NSString or nil
 */
- (nullable NSString *)stringWithFormat:(NSString *)format;

/**
 获取当前日期对应的时间字符串
 
 @param format 指定的格式
 @param timeZone 指定时区
 @param local 指定本地化
 @return NSString or nil
 */
- (nullable NSString *)stringWithFormat:(NSString *)format
                               timeZone:(nullable NSTimeZone *)timeZone
                                  local:(nullable NSLocale *)local;

#pragma mark - Class Methods

/**
 获取一个单例模式的NSDateFormatter 对象
 
 @return NSDateFormatter 对象
 */
+ (NSDateFormatter *)dateFromatter;

/**
 从指定的ISOFormat格式解析时间
 'yyyy-MM-dd'T'HH:mm:ssZ'
 
 @param dateString 时间的字符串
 @return NSDate or nil
 */
+ (nullable NSDate *)dateWithISOFormatString:(NSString *)dateString;

/**
 从字符串中 获取NSDate
 
 @param string date的字符串
 
 @return NSDate or nil
 */
+ (nullable NSDate *)dateFromString:(NSString *)string;

/**
 从字符串中 获取NSDate
 
 @param string date的字符串
 @param format 字符串日期格式 默认 yyyy-MM-dd HH:mm:ss
 
 @return NSDate or nil
 */
+ (nullable NSDate *)dateFromString:(NSString *)string format:(NSString *)format;

/**
 从字符串中获取NSDate
 
 @param string 日期字符串
 @param format 指定的格式
 @param timeZone 指定时区
 @param local 指定本地化
 @return NSDate or nil
 */
+ (nullable NSDate *)dateFromString:(NSString *)string
                             format:(NSString *)format
                           timeZone:(nullable NSTimeZone *)timeZone
                              local:(nullable NSLocale *)local;

@end

NS_ASSUME_NONNULL_END
