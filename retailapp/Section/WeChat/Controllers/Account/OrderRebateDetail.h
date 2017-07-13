//
//  WeChatRebateOrderDetail.h
//  retailapp
//
//  Created by diwangxie on 16/5/11.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"

@interface OrderRebateDetail : BaseViewController<INavigateEvent>
@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *leftRightScrollView;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *content;
@property (nonatomic) NSInteger     orderRebateId;

@property (nonatomic,strong) NSString *accountInfoId;
@property (nonatomic,strong) NSString *orderId;

@property (weak, nonatomic) IBOutlet UILabel *lblFee;
@property (weak, nonatomic) IBOutlet UILabel *lblRebateDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderCode;
@property (weak, nonatomic) IBOutlet UILabel *lblOutFee;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalFee;
@property (weak, nonatomic) IBOutlet UILabel *lblOutType;
@property (weak, nonatomic) IBOutlet UILabel *lblSendType;
@property (weak, nonatomic) IBOutlet UILabel *lblPayMode;
@property (weak, nonatomic) IBOutlet UILabel *lblCreateTime;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderState;
@property (weak, nonatomic) IBOutlet UILabel *lblRebateOrderState;
@property (nonatomic, assign) short   rebateState;

@property (weak, nonatomic) IBOutlet UIView *footer;

@end
