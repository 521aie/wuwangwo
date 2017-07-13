//
//  TDFLogger.h
//  TDFLogger
//
//  Created by tripleCC on 1/17/17.
//  Copyright © 2017 tripleCC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

//====================================
//    运行时更改（比如关闭debug日志）：
//    命令行输入：
//    expr TDFLogDebugEnable = NO
//====================================
CF_EXPORT BOOL TDFLogDebugEnable;
CF_EXPORT BOOL TDFLogInfoEnable;
CF_EXPORT BOOL TDFLogWarnEnable;
CF_EXPORT BOOL TDFLogErrorEnable;

#ifdef DEBUG
static const int ddLogLevel = DDLogLevelVerbose;
#else
static const int ddLogLevel = DDLogLevelError;
#endif

#if DEBUG
#define TDFLogDebug(frmt, ...) if (TDFLogDebugEnable) { DDLogDebug(frmt, ##__VA_ARGS__); }
#define TDFLogInfo(frmt, ...)  if (TDFLogInfoEnable) { DDLogInfo(frmt, ##__VA_ARGS__); }
#define TDFLogWarn(frmt, ...)  if (TDFLogWarnEnable) { DDLogWarn(frmt, ##__VA_ARGS__); }
#define TDFLogError(frmt, ...)  if (TDFLogErrorEnable) { DDLogError(frmt, ##__VA_ARGS__); }
#define TDFLogVerbose(frmt, ...)  if (TDFLogWarnEnable) { DDLogVerbose(frmt, ##__VA_ARGS__); }
#else
#define TDFLogDebug(frmt, ...) DDLogDebug(frmt, ##__VA_ARGS__)
#define TDFLogInfo(frmt, ...)  DDLogInfo(frmt, ##__VA_ARGS__)
#define TDFLogWarn(frmt, ...)  DDLogWarn(frmt, ##__VA_ARGS__)
#define TDFLogError(frmt, ...)  DDLogError(frmt, ##__VA_ARGS__)
#define TDFLogVerbose(frmt, ...)  DDLogVerbose(frmt, ##__VA_ARGS__)
#endif

@interface TDFLogger: NSObject
+ (void)configureLogger;
@end
