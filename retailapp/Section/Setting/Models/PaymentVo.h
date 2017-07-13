//
//  PaymentVo.h
//  retailapp
//
//  Created by 果汁 on 15/9/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import "INameValueItem.h"
@interface PaymentVo : Jastor<INameValueItem>
@property (nonatomic, copy) NSString *payTyleId;//支付类型值
@property (nonatomic, copy) NSString *payTyleVal;//支付类型值
@property (nonatomic, copy) NSString *payId; //支付id
@property (nonatomic, copy) NSString *payTyleName; //支付类型名称
@property (nonatomic, copy) NSString *payMentName; //支付方式名称
@property (nonatomic, strong) NSNumber *joinSalesMoney; //是否计入销售额 1:是，0：否
@property (nonatomic, assign) short isAutoOpenCashBox; //支付完成后是否自动打开钱箱
@property (nonatomic, assign) long lastVer;
@end
