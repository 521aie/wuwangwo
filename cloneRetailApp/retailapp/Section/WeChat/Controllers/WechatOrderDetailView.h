//
//  WechatOrderDetailView.h
//  retailapp
//
//  Created by Jianyong Duan on 15/11/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"

@interface WechatOrderDetailView : BaseViewController

/**
 *  区分是从销售订单列表还是从退货审核的原订单详情进入 默认是0 从退货审核的原订单详情传1
 *  此区分是因为从退货审核的原订单详情进入不显示下方的操作按钮(客服已提货等)
 */
@property (nonatomic, assign) int type;
//input
// 订单ID
@property (nonatomic, copy) NSString *orderId;
//订单类型 1：销售订单，2：供货订单 // 默认开微店后：没有分单和供货订单了，这个地方以后要优化下
@property (nonatomic) int orderType;
// 门店ID
@property (nonatomic, copy) NSString *shopId;

@property (nonatomic, copy) NSString *receiverName;

//outlet
@property (nonatomic,weak) IBOutlet UIView* titleDiv;
@property (nonatomic, strong) NavigateTitle2* titleBox;

@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *viewOper;
@property (weak, nonatomic) IBOutlet UIButton *btnRed;
@property (weak, nonatomic) IBOutlet UIButton *btnGreen;
@property (weak, nonatomic) IBOutlet UIButton *btnSplitOrder;
@property (weak, nonatomic) IBOutlet UIButton *btnPicking;
@property (weak, nonatomic) IBOutlet UIButton *btnComplete;

- (IBAction)sellOrderOperateClick:(UIButton *)sender;
- (void)loadData;

@end
