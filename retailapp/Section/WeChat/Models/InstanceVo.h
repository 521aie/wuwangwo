//
//  InstanceVo.h
//  retailapp
//
//  Created by Jianyong Duan on 15/12/7.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstanceVo : NSObject

//ID
@property (nonatomic ,copy) NSString *instanceId;

//实体id
@property (nonatomic ,copy) NSString *entityId;

//店铺id
@property (nonatomic ,copy) NSString *shopId;

//商品id
@property (nonatomic ,copy) NSString *goodsId;

//订单id
@property (nonatomic ,copy) NSString *orderId;

//类别id
@property (nonatomic ,copy) NSString *categoryId;

//商品名
@property (nonatomic ,copy) NSString *originalGoodsName;

//进价
@property (nonatomic) double originalPurchasePrice;

//销售数量
@property (nonatomic) double accountNum;

//单价
@property (nonatomic) double price;


@property (nonatomic) double sales_price;

//供货单价
@property (nonatomic) double supplyPrice;

//最终折扣价
@property (nonatomic) double finalRatioFee;

//最终折扣率
@property (nonatomic) double finalRatio;

//折前总额
@property (nonatomic) double fee;
@property (nonatomic) double ratioFee;

//扩展字段
// 确认收货时间
@property (nonatomic ,copy) NSString *receiving_time;
// 消费积分
@property (nonatomic ,copy) NSString *consumePoints;
// 条形码
@property (nonatomic ,copy) NSString *innerCode;
/** 条形码 */
@property (nonatomic, copy) NSString *barCode;
@property (nonatomic ,copy) NSString *sku;
//这件商品的订单处理门店
@property (nonatomic, copy) NSString *shopName;

@property (nonatomic,assign) int sortCode;
/**折扣区分*///1：第N件打折 2：满送 3：优惠券出券 4：优惠券用券
@property (nonatomic, assign) int discountType;
/** 折扣率 */
@property (nonatomic, assign) double ratio;
/** 单元格高度 */
@property (nonatomic, assign) CGFloat cellHeight;


+ (InstanceVo*)converToVo:(NSDictionary*)dic;
+ (NSMutableArray*)converToArr:(NSArray*)sourceList;


@end
