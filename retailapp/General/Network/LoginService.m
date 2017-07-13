//
//  LoginService.m
//  retailapp
//
//  Created by hm on 15/8/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LoginService.h"
#import "SignUtil.h"
#import "ObjectUtil.h"

@implementation LoginService

- (void)login:(NSString*)entityCode username:(NSString*)username password:(NSString*)password completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"login"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    [param setValue:entityCode forKey:@"entityCode"];
    [param setValue:username forKey:@"username"];
    [param setValue:[SignUtil convertPassword:password] forKey:@"password"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

- (void)loginOutWithCompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"logout"];
    [[HttpEngine sharedEngine] postUrl:url params:nil completionHandler:nil errorHandler:nil];
    
}

//省市区列表
- (void)selectAddressListCallBack:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"addressList"];
    [[HttpEngine sharedEngine] postUrl:url params:nil completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//- (void)selectMicroShopStatus:(NSString*)shopId withEntityId:(NSString*)entityId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
//{
//    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microShop/selectStauts"];
//    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
//    [param setValue:shopId forKey:@"shopId"];
//    [param setValue:entityId forKey:@"entityId"];
//    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock];
//}

- (void)getLoginWareHouse:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"wareHouse/getOrgWareHouse"];
    [[HttpEngine sharedEngine] postUrl:url params:nil completionHandler:completionBlock errorHandler:errorBlock];
}

/**主页数据统计*/
- (void)incomeMsg:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[[Platform Instance] getkey:ROLE_ID] forKey:@"roleId"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"income/msg"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**营业汇总按天查询*/
- (void)businessSummaryWithParam:(NSMutableDictionary *)param completionBlock:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"summaryControl/listOfDate"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
/**营业汇总按月查询*/
- (void)businessMonthWithParam:(NSMutableDictionary *)param completionBlock:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"summaryControl/listOfMonth"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}



@end
