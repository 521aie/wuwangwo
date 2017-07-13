//
//  MemberRechargeSalesEditView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/6.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IEditItemListEvent.h"
#import "NavigateTitle2.h"
#import "DatePickerBox.h"
#import "SymbolNumberInputBox.h"

@class EditItemText, EditItemRadio, EditItemList;
@class SaleRechargeVo;
@interface MemberRechargeSalesEditView : BaseViewController<INavigateEvent, IEditItemListEvent, DatePickerClient, SymbolNumberInputClient>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;

@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) IBOutlet UIButton *btnDel;

//活动名称
@property (nonatomic, strong) IBOutlet EditItemText *txtName;
//开始时间
@property (nonatomic, strong) IBOutlet EditItemList *lsStartTime;
//结束时间
@property (nonatomic, strong) IBOutlet EditItemList *lsEndTime;
//充值金额
@property (nonatomic, strong) IBOutlet EditItemList *lsRechargeThreshold;
//赠送金额
@property (nonatomic, strong) IBOutlet EditItemList *lsMoney;
//赠送积分
@property (nonatomic, strong) IBOutlet EditItemList *lsPoint;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil saleRechargeId:(NSString *)saleRechargeId action:(int)action;

@end
