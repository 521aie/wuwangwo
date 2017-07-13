//
//  OrderInfoVo.h
//  retailapp
//
//  Created by Jianyong Duan on 15/11/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstanceVo.h"

@interface OrderInfoVo : NSObject

//ID
@property (nonatomic, copy) NSString *orderId;

//原始单据Id
@property (nonatomic, copy) NSString *orignId;

//所属实体
@property (nonatomic, copy) NSString *entityId;

//全局单号
@property (nonatomic, copy) NSString *globalCode;

//订单来源
@property (nonatomic, copy) NSString *outType;

//订单类型 1,收银下单;2.店家配送 3:退货单; 4:上门自提
@property (nonatomic) NSInteger orderKind;

//单号
@property (nonatomic, copy) NSString *code;

//原始单据Id 0是整单  1是分单
@property (nonatomic) NSInteger isDivide;
@property (nonatomic) NSString *divideId;

//店铺Id
@property (nonatomic, copy) NSString *shopId;

//备注
@property (nonatomic, copy) NSString *memo;

//下单时间
@property (nonatomic) long long openTime;

//结单时间
@property (nonatomic) NSInteger endTime;

//支付申请时间
@property (nonatomic) long long applyPayTime;

//支付成功时间payDate
@property (nonatomic) long long  payTime;
@property (nonatomic) long long  payDate;


//会员卡ID
@property (nonatomic, copy) NSString *cardId;

//收货人的姓名
@property (nonatomic, copy) NSString *receiverName;

//收货人手机
@property (nonatomic, copy) NSString *mobile;

//送货地址
@property (nonatomic, copy) NSString *address;

//支付方式
@property (nonatomic) NSInteger payMode;

//送货费
@property (nonatomic) double outFee;

//配送模式
@property (nonatomic) NSInteger distributionMod;

//原始费用
@property (nonatomic) double sourceAmount;

//折后费用
@property (nonatomic) double discountAmount;

//应付总额
@property (nonatomic) double resultAmount;

//实收总额
@property (nonatomic) double recieveAmount;

//订单状态
@property (nonatomic) NSInteger status;

//拒绝接单原因
@property (nonatomic, copy) NSString *rejReason;

//扩展字段
@property (nonatomic, copy) NSString *expansion;
@property (nonatomic, copy) NSString *divideExpansion;

//记录生成时间
@property (nonatomic) long long  createTime;

//订单状态 orderKind 2配送时间  orderKind 4预约时间
@property (nonatomic) NSInteger sendTime;
@property (nonatomic, copy) NSString *sendTimeRange;

@property (nonatomic) NSInteger lastVer;
@property (nonatomic, copy) NSString *employeeId;
@property (nonatomic ,copy) NSString *salesInfo;
//营销信息
@property (nonatomic) double reducePrice;

//积分兑换订单配送费
@property (nonatomic) double shopFreight;

//@property (nonatomic, copy) NSString *divideShopId;
//@property (nonatomic, copy) NSString *divideCode;
//@property (nonatomic) NSInteger divideCount;
//@property (nonatomic) NSInteger divideLastVer;
//@property (nonatomic) NSString *divideCode;

//营业手续费
@property (nonatomic, copy) NSString *service_charge;

//消费积分
@property (nonatomic, copy) NSString *consume_points;

//整单折扣
@property (nonatomic, copy) NSString *whole_discount_fee;

//确认收货时间
@property (nonatomic, copy) NSString *receiving_time;

//是否货到付款
@property (nonatomic, copy) NSString *is_cash_on_delivery;

//物流公司
@property (nonatomic, copy) NSString *logisticsName;

//物流单号
@property (nonatomic, copy) NSString *logisticsNo;

//配送员
@property (nonatomic, copy) NSString *sendMan;

@property (nonatomic, strong) NSMutableDictionary *expansionDic;

@property (nonatomic, copy) NSString *shopName;
/**自提门店名称*/
@property (nonatomic, copy) NSString *isPickUpShopName;

/**订单处理门店*/
@property (nonatomic, copy) NSString *dealShopName;
/** 订单处理门店Id */
@property (nonatomic, copy) NSString *dealShopId;

/**会员名*/
@property (nonatomic, copy) NSString *customerName;
/**会员手机号*/
@property (nonatomic, copy) NSString *customerMobile;


+ (OrderInfoVo*)converToVo:(NSDictionary*)dic;
+ (NSMutableArray*)converToArr:(NSArray*)sourceList;

@end
