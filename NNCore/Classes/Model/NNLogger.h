//
//  NNLogger.h
//  Pods
//
//  Created by XMFraker on 2017/6/6.
//
//

#import <CocoaLumberjack/CocoaLumberjack.h>

FOUNDATION_EXPORT DDLogLevel ddLogLevel;

#define NNLogE(frmt, ...) LOG_MAYBE(NO,                LOG_LEVEL_DEF, DDLogFlagError,   0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define NNLogW(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagWarning, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define NNLogI(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagInfo,    0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define NNLogD(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagDebug,   0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define NNLogV(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagVerbose, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

@interface NNLogger : NSObject

/**
 配置当前全局日志级别

 @param logLevel 需要配置的logLevel
 */
+ (void)configLogLevel:(DDLogLevel)logLevel;

@end
