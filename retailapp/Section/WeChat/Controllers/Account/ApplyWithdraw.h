//
//  ApplyWithdrawView.h
//  retailapp
//
//  Created by Jianyong Duan on 16/1/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "UserBankVo.h"

@interface ApplyWithdraw : BaseViewController

//input
@property (nonatomic) double maxBalance;
@property (nonatomic) double smallCompanionWithdraw;
@property (nonatomic, strong) UserBankVo *userBank;
@property (nonatomic) NavigateTitle2 *titleBox;
@property (weak, nonatomic) IBOutlet UIView *titleDiv;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;

@property (weak, nonatomic) IBOutlet EditItemList *lstAccount;
@property (weak, nonatomic) IBOutlet EditItemText *txtBalance;
@property (weak, nonatomic) IBOutlet UILabel *lblSmallCompanionWithdraw;
@property (weak, nonatomic) IBOutlet UIView *smallCompanionWithdrawView;

//确认提现
- (IBAction)withdrawClick:(id)sender;

@end
