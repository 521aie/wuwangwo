//
//  CardLossEditView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"
#import "CustomerVo.h"

@class EditItemText;
@interface CardLossEditView : BaseViewController<INavigateEvent>

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
//卡状态
@property (nonatomic, strong) IBOutlet EditItemText *txtStatus;
//余额
@property (nonatomic, strong) IBOutlet EditItemText *txtBalance;
//卡内积分
@property (nonatomic, strong) IBOutlet EditItemText *txtPoint;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil customerId:(NSString *) customerId;

@end
