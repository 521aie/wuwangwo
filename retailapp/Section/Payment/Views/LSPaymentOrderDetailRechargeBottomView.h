//
//  LSPaymentOrderDetailRechargeBottomView.h
//  retailapp
//
//  Created by wuwangwo on 2017/4/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OnlineChargeVo,OrderInfoVo;

@interface LSPaymentOrderDetailRechargeBottomView : UIView

+ (instancetype)paymentOrderDetailRechargeBottomView;
- (void)setRechargeOnlineChargeVo:(OnlineChargeVo *)onlineChargeVo settlements:(NSDictionary *)settlements;
@end
