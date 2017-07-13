//
//  ScanService.h
//  retailapp
//
//  Created by guozhi on 16/1/21.
//  Copyright (c) 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScanService : NSObject
//获得顾客信息
- (void)getCustomerInfo:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//收款请求
- (void)getPayInfo:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
@end
