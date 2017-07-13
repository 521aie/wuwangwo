//
//  TDFLogFormatter.m
//  RestApp
//
//  Created by 黄河 on 2017/1/16.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFLogFormatter.h"

@implementation TDFLogFormatter
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel = nil;
    switch (logMessage.flag)
    {
        case DDLogFlagError:
            logLevel = @"<ERROR> ";
            break;
        case DDLogFlagWarning:
            logLevel = @"<WARN>  ";
            break;
        case DDLogFlagInfo:
            logLevel = @"<INFO>  ";
            break;
        case DDLogFlagDebug:
            logLevel = @"<DEBUG> ";
            break;
        case DDLogFlagVerbose:
            logLevel = @"<VBOSE> ";
            break;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *formatStr = [NSString stringWithFormat:@"%@ %@ %@[%d]: %@",currentDate,
                           logLevel, logMessage.fileName,
                           (int)logMessage.line, logMessage.message];
    return formatStr;
}
@end
