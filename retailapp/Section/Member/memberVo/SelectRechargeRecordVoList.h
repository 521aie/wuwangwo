//
//  SelectRechargeRecordVoList.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface SelectRechargeRecordVoList : Jastor

//会员名
@property (nonatomic, strong) NSString *customerName;

//手机号
@property (nonatomic, strong) NSString *mobile;

//充值金额
@property (nonatomic)  double payMoney;

//充值时间
@property (nonatomic)  long long moneyFlowCreatetime;

//支付方式
@property (nonatomic, strong) NSString *payMode;

//操作
@property (nonatomic)  short action;

//充值类型
@property (nonatomic)  int payType;

//状态
@property (nonatomic)  short status;

@end
