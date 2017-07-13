//
//  HttpEngine.m
//  retailapp
//
//  Created by hm on 15/7/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "HttpEngine.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "SignUtil.h"
#import "MyMD5.h"
#import "Platform.h"
#import "ReailAppDefine.h"

@implementation HttpEngine

+(HttpEngine *)sharedEngine {
    static HttpEngine *util = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        util = [[self alloc] init];
    });
    return util;
}
/**
 *  共通参数
 */
-(NSMutableDictionary *)createCommonDictionary {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:VERSION forKey:@"version"];
    [params setObject:APP_KEY forKey:@"appKey"];
    [params setObject:SYS_VERSION forKey:@"sys_version"];
    [params setObject:[self getSystemCurrTime] forKey:@"timestamp"];
    NSString* signVal = [MyMD5 HMACMD5WithString:[params objectForKey:@"timestamp"] WithKey:APP_SECRET];
    [params setValue:signVal forKey:@"sign"];
    
    return params;
}

- (NSString *)getSystemCurrTime {
    NSDate *dat = [NSDate date];
    NSTimeInterval a = [dat timeIntervalSince1970]*1000;
    return [NSString stringWithFormat:@"%lld", (long long)a];
}


- (void)postUrl:(NSString *)path
         params:(NSDictionary *)params
completionHandler:(HttpResponseBlock)completionBlock
   errorHandler:(HttpErrorBlock)errorBlock {
    [BaseService getRemoteLSDataWithUrl:path param:params withMessage:nil show:NO CompletionHandler:completionBlock errorHandler:errorBlock];
}


- (void)postUrl:(NSString *)path
         params:(NSDictionary *)params
        completionHandler:(HttpResponseBlock)completionBlock
        errorHandler:(HttpErrorBlock)errorBlock
        withMessage:(NSString*)message {
    [BaseService getRemoteLSDataWithUrl:path param:params withMessage:message show:YES CompletionHandler:completionBlock errorHandler:errorBlock];
}

@end
