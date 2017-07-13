//
//  ServiceFactory.h
//  retailapp
//
//  Created by hm on 15/6/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LoginService.h"
#import "SettingService.h"
#import "LogisticService.h"
#import "CommonService.h"
#import "GoodsService.h"
#import "SystemService.h"
#import "MarketService.h"
#import "SmsService.h"
#import "MemberService.h"
#import "EmployeeService.h"
#import "ReportService.h"
#import "WechatService.h"
#import "StockService.h"
#import "CommentService.h"
#import "OtherService.h"
#import "SellReturnService.h"
#import "MicroDistributeService.h"
#import "ScanService.h"
#import "BaseService.h"

@interface ServiceFactory : NSObject
@property (nonatomic,strong) CommonService* commonService;
@property (nonatomic,strong) LoginService* loginService;
@property (nonatomic,strong) SettingService* settingService;
@property (nonatomic,strong) SystemService* systemService;
@property (nonatomic,strong) GoodsService* goodsService;
@property (nonatomic,strong) MarketService* marketService;
@property (nonatomic,strong) SmsService* smsService;
@property (nonatomic,strong) MemberService* memberService;
@property (nonatomic,strong) LogisticService* logisticService;
@property (nonatomic,strong) EmployeeService *employeeService;
@property (nonatomic, strong) ReportService *reportService;
@property (nonatomic,strong) WechatService *wechatService;
@property (nonatomic, strong) StockService *stockService;
@property (nonatomic, strong) CommentService *commentService;
@property (nonatomic, strong) OtherService *otherService;
@property (nonatomic,strong) SellReturnService *sellReturnService;
@property (nonatomic,strong) MicroDistributeService *microDistributeService;
@property (nonatomic, strong) ScanService *scanService;
@property (nonatomic, strong) BaseService *baseService;


+(ServiceFactory *) shareInstance;

- (void)initService;

@end
