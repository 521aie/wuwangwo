//
//  MemberRechargeEditView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

/**
 *  会员充值页面
 */

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "OptionPickerClient.h"
#import "NavigateTitle2.h"
#import "IEditItemListEvent.h"
#import "SymbolNumberInputBox.h"


@class EditItemText, EditItemRadio, EditItemList;
@class MemberModule, CustomerVo, SaleRechargeVo;
@interface MemberRechargeEditView : BaseViewController<INavigateEvent, OptionPickerClient, IEditItemListEvent, SymbolNumberInputClient>

@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;

//会员卡号
@property (nonatomic, strong) IBOutlet EditItemText *txtCardCode;
//会员名
@property (nonatomic, strong) IBOutlet EditItemText *txtMemberName;
//手机号码
@property (nonatomic, strong) IBOutlet EditItemText *txtMobile;
//卡类型
@property (nonatomic, strong) IBOutlet EditItemText *txtKindCardName;
//卡内余额
@property (nonatomic, strong) IBOutlet EditItemText *txtBalance;
//卡内积分
@property (nonatomic, strong) IBOutlet EditItemText *txtDegree;
//充值类型
@property (nonatomic, strong) IBOutlet EditItemList *lsRechargeKind;
//充值金额
@property (nonatomic, strong) IBOutlet EditItemList *lsRechargeMoney;
//赠送金额
@property (nonatomic, strong) IBOutlet EditItemText *txtPresentMoney;
//赠送积分
@property (nonatomic, strong) IBOutlet EditItemText *txtPresentPoint;

//支付方式
@property (nonatomic, strong) IBOutlet EditItemList *lsPayMode;

@property (nonatomic, strong) IBOutlet UIButton *btnRec;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil customerId:(NSString *) customerId;

@end
