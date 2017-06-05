//
//  TDFNetworkHttpieLogger.m
//  TDFNetworkActivityLogger
//
//  Created by 於卓慧 on 16/7/15.
//  Copyright © 2016年 2dfire. All rights reserved.
//

#import "TDFNetworkHttpieLogger.h"
#import <AFNetworking/AFURLSessionManager.h>

#import <objc/runtime.h>

static NSURLRequest * TDFNetworkRequestFromNotification(NSNotification *notification) {
    NSURLRequest *request = nil;
    
    NSURLSessionTask *task = notification.object;
    
    request = task.originalRequest?: task.currentRequest;
    
    return request;
}

static NSError *TDFNetworkErrorFromNotification(NSNotification *notification) {
    NSError *error = nil;
    
    NSURLSessionTask *task = notification.object;
    
    error = [task error];
    if (!error) {
        error = notification.userInfo[AFNetworkingTaskDidCompleteErrorKey];
    }
    
    return error;
}

static NSURLResponse * TDFNetworkResponseFromNotification(NSNotification *notification) {
    NSURLResponse *response = nil;
    
    NSURLSessionTask *task = notification.object;
    
    response = task.response;
    
    return response;
}

@implementation TDFNetworkHttpieLogger

+ (instancetype)sharedLogger {
    static TDFNetworkHttpieLogger *_sharedLogger = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedLogger = [[self alloc] init];
    });
    
    return _sharedLogger;
}

- (id)init {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.level = TDFLoggerLevelInfo;
    
    return self;
}

- (void)startLogging {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReqeustDidStart:) name:AFNetworkingTaskDidResumeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidFinish:) name:AFNetworkingTaskDidCompleteNotification object:nil];
}

- (void)stopLogging {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

static void * TDFNetworkRequestStartDate = &TDFNetworkRequestStartDate;

- (void)networkReqeustDidStart:(NSNotification *)notification {
    NSURLRequest *request = TDFNetworkRequestFromNotification(notification);
    
    if (!request) {
        return;
    }
    
    if (request && self.filterPredicate && ![self.filterPredicate evaluateWithObject:request]) {
        return;
    }
    
    objc_setAssociatedObject(notification.object, TDFNetworkRequestStartDate, [NSDate date], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSString *body = nil;
    
    if ([request HTTPBody]) {
        body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    }
    
    switch (self.level) {
        case TDFLoggerLevelDebug: {
            
            NSMutableString *commandLineString = [@"http --form " mutableCopy];
            [commandLineString appendFormat:@"%@ '%@' ", request.HTTPMethod, [[request URL] absoluteString]];
            
            
            [request.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                [commandLineString appendFormat:@"'%@':'%@' ", key, obj];
            }];
            
            if (body.length) {
                NSArray *parts = [body componentsSeparatedByString:@"&"];
                
                [parts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSArray *pair = [obj componentsSeparatedByString:@"="];
                    NSString *key = nil;
                    
                    if ([pair.firstObject respondsToSelector:@selector(stringByRemovingPercentEncoding)]) {
                        key = [pair.firstObject stringByRemovingPercentEncoding];
                    }else {
                        key = [pair.firstObject stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    }
                    
                    NSString *value = nil;
                    
                    if ([pair.lastObject respondsToSelector:@selector(stringByRemovingPercentEncoding)]) {
                        value = [pair.lastObject stringByRemovingPercentEncoding];
                    }else {
                        value = [pair.lastObject stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    }
                    
                    value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
                    
                    [commandLineString appendFormat:@"'%@'=$'%@' ", key, value];
                }];
                
            }
            
            NSLog(@"%@", commandLineString);
        }
            
            break;
            
        case TDFLoggerLevelInfo:
            NSLog(@"%@ '%@'", [request HTTPMethod], [[request URL] absoluteString]);
            break;
            
        default:
            break;
    }
    
    
}

- (void)networkRequestDidFinish:(NSNotification *)notification {
    NSURLRequest *request = TDFNetworkRequestFromNotification(notification);
    NSURLResponse *response = TDFNetworkResponseFromNotification(notification);
    NSError *error = TDFNetworkErrorFromNotification(notification);
    
    if (!request && !response) {
        return;
    }
    
    if (request && self.filterPredicate && ![self.filterPredicate evaluateWithObject:request]) {
        return;
    }
    
    NSUInteger responseStatusCode = 0;
    NSDictionary *responseHeaderFields = nil;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        responseStatusCode = (NSUInteger)[(NSHTTPURLResponse *)response statusCode];
        responseHeaderFields = [(NSHTTPURLResponse *)response allHeaderFields];
    }
    
    
    id responseObject = notification.userInfo[AFNetworkingTaskDidCompleteSerializedResponseKey];
    
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:objc_getAssociatedObject(notification.object, TDFNetworkRequestStartDate)];
    
    if (error) {
        switch (self.level) {
            case TDFLoggerLevelDebug:
            case TDFLoggerLevelInfo:
            case TDFLoggerLevelWarn:
            case TDFLoggerLevelError:
                NSLog(@"[Error] %@ '%@' (%ld) [%.04f s]: %@", [request HTTPMethod], [[response URL] absoluteString], (long)responseStatusCode, elapsedTime, error);
            default:
                break;
        }
    } else {
        switch (self.level) {
            case TDFLoggerLevelDebug:
                NSLog(@"%ld '%@' [%.04f s]: %@ %@", (long)responseStatusCode, [[response URL] absoluteString], elapsedTime, responseHeaderFields, responseObject);
                break;
            case TDFLoggerLevelInfo:
                NSLog(@"%ld '%@' [%.04f s]", (long)responseStatusCode, [[response URL] absoluteString], elapsedTime);
                break;
            default:
                break;
        }
    }
}

@end
