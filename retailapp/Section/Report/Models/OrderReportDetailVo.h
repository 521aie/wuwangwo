//
//  OrderReportDetailVo.h
//  retailapp
//
//  Created by qingmei on 15/11/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderReportDetailVo : NSObject
/**商品条码*/
@property (nonatomic, strong) NSString *goodsCode;
/**店内码*/
@property (nonatomic, strong) NSString *goodsInnerCode;
/**商品名*/
@property (nonatomic, strong) NSString *goodsName;
/**优惠金额*/
@property (nonatomic, strong) NSNumber *reduceMoney;
/**单价金额*/
@property (nonatomic, strong) NSNumber *price;
/**应收金额*/
@property (nonatomic, strong) NSNumber *shouldMoney;
/**优惠后单价*/
@property (nonatomic, strong) NSNumber *salesPrice;
/**购买数量*/
@property (nonatomic, strong) NSNumber *buyNum;
/**折扣区分*///1：第N件打折 2：满送 3：优惠券出券 4：优惠券用券
@property (nonatomic, strong) NSNumber *discountType;
/**商品颜色*/
//@property (nonatomic, strong) NSString *goodsColor;
/**商品尺码*/
//@property (nonatomic, strong) NSString *goodsSize;
/**颜色尺码*/
@property (nonatomic, strong) NSString *goodsSku;
/**折扣率*/
@property (nonatomic, strong) NSNumber *ratio;


- (instancetype)initWithDictionary:(NSDictionary *)json;
@end
