//
//  SmsService.m
//  retailapp
//
//  Created by hm on 15/9/6.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SmsService.h"

@implementation SmsService

- (void)selectSmsList:(NSString*)noticeShopId currentPage:(NSInteger)currentPage completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    [param setValue:noticeShopId forKey:@"noticeShopId"];
    [param setValue:[NSNumber numberWithInteger:currentPage] forKey:@"currentPage"];
    [param setValue:@1 forKey:@"noticeType"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"notice/list"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

- (void)selectSmsDetail:(NSString*)detailId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:detailId forKey:@"noticeId"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"notice/detail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];

}

- (void)saveSms:(Notice*)notice operateType:(NSString*)operateType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    [param setValue:[Notice converToDic:notice] forKey:@"notice"];
    [param setValue:operateType forKey:@"operateType"];
    [param setValue:[NSString stringWithFormat:@"%d",1] forKey:@"noticeType"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"notice/save"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//过期提醒
- (void)selectDueAlertList:(NSString*)shopId currentPage:(NSInteger)currentPage completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:[NSString stringWithFormat:@"%tu",currentPage] forKey:@"currentPage"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockInfoAlert/dueAlertList"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
//库存预警
- (void)selectStoreList:(NSString*)shopId currentPage:(NSInteger)currentPage completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:[NSString stringWithFormat:@"%tu",currentPage] forKey:@"currentPage"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockInfoAlert/storeAlertList"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
//公告通知列表
- (void)selectNoticeList:(NSString*)noticeShopId startTime:(long long)noticeStartTime endTime:(long long)noticeEndTime currentPage:(NSInteger)currentPage completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:4];
    [param setValue:noticeShopId forKey:@"noticeShopId"];
    [param setValue:[NSString stringWithFormat:@"%lld",noticeStartTime] forKey:@"noticeStartTime"];
    [param setValue:[NSString stringWithFormat:@"%lld",noticeEndTime] forKey:@"noticeEndTime"];
    [param setValue:[NSString stringWithFormat:@"%tu",currentPage] forKey:@"currentPage"];
    [param setValue:@"0" forKey:@"showAlert"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"notice/listShop"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];

}
//公告通知详情
- (void)selectNoticeDetail:(NSString*)noticeId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:noticeId forKey:@"noticeId"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"notice/listShopDetail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];

}

@end
