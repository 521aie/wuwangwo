//
//  LSPaymentOrderDetailController.h
//  retailapp
//
//  Created by guozhi on 2016/12/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    TypeConsume,//消费 消费是有商品信息的
    TypeRecharge//充值 充值是没有商品信息的
}Type;
@interface LSPaymentOrderDetailController : UIViewController
/**会员ID*/
@property (nonatomic, copy) NSString *customerId;
/**第三方会员ID*/
@property (nonatomic, copy) NSString *customerRegisterId;
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *entityId;
@property (nonatomic, copy) NSString *orderId;
/** 1 实体 2微店充值 */
@property (nonatomic, strong) NSNumber *channelType;
/** <#注释#> */
@property (nonatomic, assign) Type type;
@end
