//
//  LSPaymentOrderDetailHeaderView.h
//  retailapp
//
//  Created by guozhi on 2016/12/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfoVo.h"
#import "LSPersonDetailVO.h"
@interface LSPaymentOrderDetailHeaderView : UIView
+ (instancetype)paymentOrderDetailHeaderView;
- (void)setOrderInfoVo:(OrderInfoVo *)orderInfoVo memberInfo:(LSPersonDetailVO *)memberInfo orderCode:(NSString *)orderCode;
@end
