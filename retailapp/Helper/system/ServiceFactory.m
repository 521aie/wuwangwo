//
//  ServiceFactory.m
//  retailapp
//
//  Created by hm on 15/6/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ServiceFactory.h"

@implementation ServiceFactory

+(ServiceFactory *) shareInstance
{
    static ServiceFactory *instance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        instance = [[self alloc] init];
        [instance initService];
    });
    return instance;
}


- (void)initService
{
    _commonService = [[CommonService alloc] init];
     _loginService = [[LoginService alloc] init];
    _settingService = [[SettingService alloc] init];
    _logisticService = [[LogisticService alloc] init];
    _goodsService = [[GoodsService alloc] init];
    _systemService = [[SystemService alloc] init];
    _marketService = [[MarketService alloc] init];
    _smsService = [[SmsService alloc] init];
    _memberService = [[MemberService alloc] init];
    _employeeService = [[EmployeeService alloc]init];
    _reportService = [[ReportService alloc] init];
    _wechatService = [[WechatService alloc] init];
    _stockService = [[StockService alloc] init];
    _commentService = [[CommentService alloc] init];
    _otherService = [[OtherService alloc] init];
    _sellReturnService = [[SellReturnService alloc] init];
    _microDistributeService = [[MicroDistributeService alloc] init];
    _scanService = [[ScanService alloc] init];
    _baseService = [[BaseService alloc] init];
}

@end
