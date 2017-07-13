//
//  LoginService.h
//  retailapp
//
//  Created by hm on 15/8/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpEngine.h"
@interface LoginService : NSObject
/**
 *  登录
 *
 *  @param entityCode      实体编码
 *  @param username        员工号
 *  @param password        密码
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)login:(NSString*)entityCode username:(NSString*)username password:(NSString*)password completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  退出登录
 *
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)loginOutWithCompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  获取省市区地址列表
 *
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
//省市区列表
- (void)selectAddressListCallBack:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  查询微店状态
 *
 *  @param shopId          商户id
 *  @param entityId        实体id
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
//- (void)selectMicroShopStatus:(NSString*)shopId withEntityId:(NSString*)entityId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  获取机构下仓库
 *
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)getLoginWareHouse:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
/**主页数据统计*/
- (void)incomeMsg:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
/**营业汇总按日查询*/
- (void)businessSummaryWithParam:(NSMutableDictionary *)param completionBlock:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
/**营业汇总按月查询*/
- (void)businessMonthWithParam:(NSMutableDictionary *)param completionBlock:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
@end
