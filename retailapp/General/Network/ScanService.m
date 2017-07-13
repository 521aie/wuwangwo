//
//  ScanService.m
//  retailapp
//
//  Created by guozhi on 16/1/21.
//  Copyright (c) 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ScanService.h"

@implementation ScanService
//获得顾客信息
- (void)getCustomerInfo:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"mall/customer/findCustomerInfo"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//收款请求
- (void)getPayInfo:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"mall/customer/payByBarCode"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
@end
