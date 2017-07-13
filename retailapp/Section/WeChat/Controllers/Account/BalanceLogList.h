//
//  WeChatBalanceLog.h
//  retailapp
//
//  Created by diwangxie on 16/4/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"
#import "BalanceLogDetail.h"
#import "EditItemList.h"
#import "OptionPickerBox.h"
#import "DatePickerBox.h"

@interface BalanceLogList : BaseViewController<INavigateEvent,IEditItemListEvent,OptionPickerClient,DatePickerClient>
@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (weak, nonatomic) IBOutlet UITableView *mainGrid;


@property (strong, nonatomic) IBOutlet UIControl *viewFilter;
@property (weak, nonatomic) IBOutlet UIView *filterView;

@property (weak, nonatomic) IBOutlet EditItemList *lstType;

@property (weak, nonatomic) IBOutlet EditItemList *lstDate;



@end
