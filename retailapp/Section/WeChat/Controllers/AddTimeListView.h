//
//  AddTimeListView.h
//  retailapp
//
//  Created by Jianyong Duan on 15/10/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddTimeCallBack)(NSString *starttime, NSString *endtime);
typedef void(^CancelTimeCallBack)();

@class NavigateTitle2,EditItemList;

@interface AddTimeListView : BaseViewController

@property (nonatomic) NavigateTitle2 *titleBox;
@property (weak, nonatomic) IBOutlet UIView *titleDiv;

@property (weak, nonatomic) IBOutlet EditItemList *lstStartTime;
@property (weak, nonatomic) IBOutlet EditItemList *lstEndTime;
@property (nonatomic, strong) NSMutableArray *arrSendTime;
- (void)addTimeCallBack:(AddTimeCallBack)addTimeCallBack cancelTime:(CancelTimeCallBack)cancelTimeCallBack;

@end