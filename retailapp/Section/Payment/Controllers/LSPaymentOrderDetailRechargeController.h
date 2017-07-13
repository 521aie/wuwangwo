//
//  LSPaymentOrderDetailRechargeController.h
//  retailapp
//
//  Created by wuwangwo on 2017/4/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface LSPaymentOrderDetailRechargeController : LSRootViewController

/**会员ID*/
@property (nonatomic, copy) NSString *customerId;
/**第三方会员ID*/
@property (nonatomic, copy) NSString *customerRegisterId;
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *entityId;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *payMsgTag;
@end
