//
//  LSPaymentOrderDetailFooterView.h
//  retailapp
//
//  Created by guozhi on 2016/12/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfoVo.h"
#import "OnlineChargeVo.h"
@interface LSPaymentOrderDetailFooterView : UIView
+ (instancetype)paymentOrderDetailFooterView;
- (void)setOrderInfoVo:(OrderInfoVo *)orderInfoVo onlineChargeVo:(OnlineChargeVo *)onlineChargeVo settlements:(NSDictionary *)settlements;
@end
