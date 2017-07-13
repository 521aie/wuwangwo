//
//  WeChatRebateOrders.h
//  retailapp
//
//  Created by diwangxie on 16/4/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"
#import "EditItemList.h"
#import "OptionPickerBox.h"

@interface OrdersRebateList : BaseViewController<INavigateEvent,IEditItemListEvent,OptionPickerClient>
@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (weak, nonatomic) IBOutlet UITableView *mainGrid;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *container;

@property (weak, nonatomic) IBOutlet UILabel *lblAllGains;
@property (weak, nonatomic) IBOutlet UIView *headView;

@property (strong, nonatomic) IBOutlet UIControl *viewFilter;
@property (weak, nonatomic) IBOutlet UIView *filterView;

@property (weak, nonatomic) IBOutlet EditItemList *lstRebateState;

@property (nonatomic) double accumulatedAmount;
@end
