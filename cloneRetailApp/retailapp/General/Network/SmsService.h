//
//  SmsService.h
//  retailapp
//
//  Created by hm on 15/9/6.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Notice.h"

@interface SmsService : NSObject
//查询消息公告列表
- (void)selectSmsList:(NSString*)noticeShopId currentPage:(NSInteger)currentPage completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
//查询消息详情
- (void)selectSmsDetail:(NSString*)detailId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
//添加消息
- (void)saveSms:(Notice*)notice operateType:(NSString*)operateType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//过期提醒
- (void)selectDueAlertList:(NSString*)shopId currentPage:(NSInteger)currentPage completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
//库存预警
- (void)selectStoreList:(NSString*)shopId currentPage:(NSInteger)currentPage completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
//公告通知列表
- (void)selectNoticeList:(NSString*)noticeShopId startTime:(long long)noticeStartTime endTime:(long long)noticeEndTime currentPage:(NSInteger)currentPage completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
//公告通知详情
- (void)selectNoticeDetail:(NSString*)noticeId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
@end
