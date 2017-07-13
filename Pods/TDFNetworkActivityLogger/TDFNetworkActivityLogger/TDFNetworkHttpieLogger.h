//
//  TDFNetworkHttpieLogger.h
//  TDFNetworkActivityLogger
//
//  Created by 於卓慧 on 16/7/15.
//  Copyright © 2016年 2dfire. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TDFHTTPRequestLoggerLevel) {
    TDFLoggerLevelOff,
    TDFLoggerLevelDebug,
    TDFLoggerLevelInfo,
    TDFLoggerLevelWarn,
    TDFLoggerLevelError,
    TDFLoggerLevelFatal = TDFLoggerLevelOff,
};

@interface TDFNetworkHttpieLogger : NSObject

@property (nonatomic, assign) TDFHTTPRequestLoggerLevel level;

@property (nonatomic, strong) NSPredicate *filterPredicate;

+ (instancetype)sharedLogger;

- (void)startLogging;

- (void)stopLogging;

@end
