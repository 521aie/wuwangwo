//
//  TDFLogger.m
//  TDFLogger
//
//  Created by tripleCC on 1/17/17.
//  Copyright © 2017 tripleCC. All rights reserved.
//

#import "TDFLogFormatter.h"
#import "TDFLogger.h"

BOOL TDFLogDebugEnable  = YES;
BOOL TDFLogInfoEnable   = YES;
BOOL TDFLogWarnEnable   = YES;
BOOL TDFLogErrorEnable  = YES;

@implementation TDFLogger
+ (void)configureLogger {
    // formatter
    TDFLogFormatter *loggerFormatter = [[TDFLogFormatter alloc] init];
    [[DDTTYLogger sharedInstance] setLogFormatter:loggerFormatter];
    
    // fileLogger
    DDFileLogger* fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    fileLogger.logFormatter = loggerFormatter;
    [DDLog addLogger:fileLogger];
    
    // ttylogger
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    /* XcodeColors
     * 1、In Xcode bring up the Scheme Editor (Product -> Edit Scheme...)
     * 2、Select "Run" (on the left), and then the "Arguments" tab
     * 3、Add a new Environment Variable named "XcodeColors", with a value of "YES"
     */
    [DDTTYLogger sharedInstance].colorsEnabled = YES;
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor redColor]
                                     backgroundColor:nil
                                             forFlag:DDLogFlagInfo];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor orangeColor]
                                     backgroundColor:nil
                                             forFlag:DDLogFlagWarning];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor greenColor]
                                     backgroundColor:nil
                                             forFlag:DDLogFlagInfo];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor cyanColor]
                                     backgroundColor:nil
                                             forFlag:DDLogFlagDebug];
}
@end
