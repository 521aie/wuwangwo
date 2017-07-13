//
//  WeChatBalanceLogDetail.h
//  retailapp
//
//  Created by diwangxie on 16/5/9.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "OrderRebateDetail.h"
@interface BalanceLogDetail : BaseViewController<INavigateEvent,IEditItemListEvent>
@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet EditItemText *lstOne;
@property (weak, nonatomic) IBOutlet EditItemText *lstTree;
@property (weak, nonatomic) IBOutlet EditItemText *txtTwo;
@property (weak, nonatomic) IBOutlet EditItemList *lstTwo;
@property (weak, nonatomic) IBOutlet EditItemText *lstFour;
@property (weak, nonatomic) IBOutlet EditItemText *lstFive;
@property (weak, nonatomic) IBOutlet UILabel *lblState;

@property (weak, nonatomic) IBOutlet UILabel *lblMoney;


@property (nonatomic) NSInteger actionType;

@property (nonatomic) NSInteger moneyFlow;
@end
