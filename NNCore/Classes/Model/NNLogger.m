//
//  NNLogger.m
//  Pods
//
//  Created by XMFraker on 2017/6/6.
//
//

#import <NNCore/NNLogger.h>
#import <libkern/OSAtomic.h>

#if DEBUG
    DDLogLevel ddLogLevel = DDLogLevelAll;
#else
    DDLogLevel ddLogLevel = DDLogLevelInfo;
#endif

@interface NNLoggerFormatter : NSObject <DDLogFormatter> {
    int atomicLoggerCount;
    NSDateFormatter *threadUnsafeDateFormatter;
}

@end

@implementation NNLoggerFormatter

- (NSString *)stringFromDate:(NSDate *)date {
    int32_t loggerCount = OSAtomicAdd32(0, &atomicLoggerCount);
    
    if (loggerCount <= 1) {
        // Single-threaded mode.
        
        if (threadUnsafeDateFormatter == nil) {
            threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
            [threadUnsafeDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        }
        
        return [threadUnsafeDateFormatter stringFromDate:date];
    } else {
        // Multi-threaded mode.
        // NSDateFormatter is NOT thread-safe.
        
        NSString *key = @"MyCustomFormatter_NSDateFormatter";
        
        NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
        NSDateFormatter *dateFormatter = [threadDictionary objectForKey:key];
        
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
            
            [threadDictionary setObject:dateFormatter forKey:key];
        }
        return [dateFormatter stringFromDate:date];
    }
}


- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel;
    switch (logMessage->_flag) {
        case DDLogFlagError    : logLevel = @"E"; break;
        case DDLogFlagWarning  : logLevel = @"W"; break;
        case DDLogFlagInfo     : logLevel = @"I"; break;
        case DDLogFlagDebug    : logLevel = @"D"; break;
        default                : logLevel = @"V"; break;
    }
    
    NSString *dateAndTime = [self stringFromDate:(logMessage.timestamp)];
    NSString *fileMsg = [NSString stringWithFormat:@"%@[%lu]", logMessage->_fileName, (unsigned long)logMessage->_line];
    NSString *logMsg = logMessage->_message;
    
    return [NSString stringWithFormat:@"%@ %@ %@: %@",dateAndTime, logLevel, fileMsg, logMsg];
}


- (void)didAddToLogger:(id <DDLogger>)logger {
    OSAtomicIncrement32(&atomicLoggerCount);
}

- (void)willRemoveFromLogger:(id <DDLogger>)logger {
    OSAtomicDecrement32(&atomicLoggerCount);
}

@end

@implementation NNLogger

+ (void)load {
    
    NNLoggerFormatter *formatter = [[NNLoggerFormatter alloc] init];
    [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 1000;
    fileLogger.logFormatter = formatter;
    [fileLogger setLogFormatter:formatter];
    [DDLog addLogger:fileLogger withLevel:DDLogLevelInfo];
    DDLogInfo(@"DDLog setup success");
}

+ (void)configLogLevel:(DDLogLevel)newLogLevel {
    
    ddLogLevel = newLogLevel;
}

@end
