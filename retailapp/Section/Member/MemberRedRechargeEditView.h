//
//  MemberRedRechargeEditView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"

@class EditItemText;
@class MemberModule, RechargeRecordDetailsVo;
@interface MemberRedRechargeEditView : BaseViewController<INavigateEvent>

@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;

//会员卡号
@property (nonatomic, strong) IBOutlet EditItemText *txtCardCode;
//会员名
@property (nonatomic, strong) IBOutlet EditItemText *txtMemberName;
//手机号
@property (nonatomic, strong) IBOutlet EditItemText *txtmobile;
//充值金额
@property (nonatomic, strong) IBOutlet EditItemText *txtPayMoney;
//赠送金额
@property (nonatomic, strong) IBOutlet EditItemText *txtGiftMoney;
//充值后余额
@property (nonatomic, strong) IBOutlet EditItemText *txtBalance;
//赠送积分
@property (nonatomic, strong) IBOutlet EditItemText *txtGiftIntegral;
//充值方式
@property (nonatomic, strong) IBOutlet EditItemText *txtPayType;
//充值门店
@property (nonatomic, strong) IBOutlet EditItemText *txtShopName;
//支付方式
@property (nonatomic, strong) IBOutlet EditItemText *txtPayMode;
//操作人∫
@property (nonatomic, strong) IBOutlet EditItemText *txtOperatePerson;
//充值时间
@property (nonatomic, strong) IBOutlet EditItemText *txtTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil moneyFlowId:(NSString *) moneyFlowId customerId:(NSString *) customerId status:(short) status action:(int) action;

@end
