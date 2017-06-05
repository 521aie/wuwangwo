//
//  PointExOrderDetailView.h
//  retailapp
//
//  Created by Jianyong Duan on 15/12/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"

@interface PointExOrderDetailView : BaseViewController

//input
// 订单ID
@property (nonatomic, copy) NSString *orderId;
// 门店ID
@property (nonatomic, copy) NSString *shopId;

@property (nonatomic, copy) NSString *receiverName;

//outlet
@property (nonatomic,weak) IBOutlet UIView* titleDiv;
@property (nonatomic, strong) NavigateTitle2* titleBox;

@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *viewOper;

- (IBAction)sellOrderOperateClick:(UIButton *)sender;

@end
