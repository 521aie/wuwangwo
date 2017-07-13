//
//  CardCancelEditView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"
#import "IEditItemListEvent.h"
#import "SymbolNumberInputBox.h"

@class EditItemText, EditItemList;
@class MemberModule, CardCancelVo;
@interface CardCancelEditView : BaseViewController<INavigateEvent, IEditItemListEvent, SymbolNumberInputClient>

@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;

@property (nonatomic, strong) IBOutlet UIButton *btnDel;

//会员卡号
@property (nonatomic, strong) IBOutlet EditItemText *txtCardCode;
//会员名
@property (nonatomic, strong) IBOutlet EditItemText *txtMemberName;
//手机号
@property (nonatomic, strong) IBOutlet EditItemText *txtmobile;
//卡类名称
@property (nonatomic, strong) IBOutlet EditItemText *txtKindCardName;
//累计充值
@property (nonatomic, strong) IBOutlet EditItemText *txtRealBalance;
//累计赠送
@property (nonatomic, strong) IBOutlet EditItemText *txtGiftBalance;
//累计消费
@property (nonatomic, strong) IBOutlet EditItemText *txtConsumeAmount;
//卡内余额
@property (nonatomic, strong) IBOutlet EditItemText *txtBalance;
//卡内积分
@property (nonatomic, strong) IBOutlet EditItemText *txtDegreeAmount;
//实退金额
@property (nonatomic, strong) IBOutlet EditItemList *lsAmount;
//备注
@property (nonatomic, strong) IBOutlet EditItemText *txtMemo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil customerId:(NSString *) customerId;

@end
