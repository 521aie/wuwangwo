//
//  OrderLogisticsInfoView.h
//  retailapp
//
//  Created by Jianyong Duan on 16/1/12.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"
@class EditItemView,OrderInfoVo,EditItemList;
@interface OrderLogisticsInfoView : BaseViewController

//input
// 物流公司
@property (nonatomic, copy) NSString *logisticsName;
// 物流单号
@property (nonatomic, copy) NSString *logisticsNo;
// 配送员
@property (nonatomic, copy) NSString *sendMan;
// 运费
@property (nonatomic, copy) NSString *sendFee;
//订单类型 1：销售订单，2：供货订单
@property (nonatomic) int orderType;
@property (nonatomic, copy) NSString *dealShop;
//Outlet
@property (nonatomic,weak) IBOutlet UIView* titleDiv;
@property (nonatomic, strong) NavigateTitle2* titleBox;
/**type  1 代表退货审核的物流点击事件*/
@property (nonatomic, assign) int type;

@property (weak, nonatomic) IBOutlet EditItemView *vewDealShop;
@property (weak, nonatomic) IBOutlet EditItemView *vewLogisticName;
@property (weak, nonatomic) IBOutlet EditItemView *vewOutType;
@property (weak, nonatomic) IBOutlet EditItemView *vewLogisticNo;
@property (weak, nonatomic) IBOutlet EditItemView *vewOutFee;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet EditItemView *vewSendMan;
@property (weak, nonatomic) IBOutlet UIView *viewMain;

@end
