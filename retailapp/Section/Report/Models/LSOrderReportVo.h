//
//  LSOrderReportVo.h
//  retailapp
//
//  Created by guozhi on 2016/12/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSOrderReportVo : NSObject
/**订单号*/
@property (nonatomic, strong) NSString *id;
/** 1.销售单  2.退货单 */
@property (nonatomic, strong) NSNumber *orderKind;
/**处理人*/
@property (nonatomic, strong) NSString *name;
/**流水单号*/
@property (nonatomic, strong) NSString *waternumber;
/**配送费*/
@property (nonatomic, strong) NSNumber *outFee;
/**数量*/
@property (nonatomic, strong) NSNumber *totalcount;
/**该单所值总金额(实收费用)*/
@property (nonatomic, strong) NSNumber *totalmoney;
/**处理人工号*/
@property (nonatomic, strong) NSString *staffid;
/**门店ID*/
@property (nonatomic, strong) NSString *shopId;
/**门店名称*/
@property (nonatomic, strong) NSString *shopName;
/**应收*/
@property (nonatomic, strong) NSNumber *resultMoney;
/**销售时间*/
@property (nonatomic, strong) NSString *salesTime;
/**订单生成时间*/
@property (nonatomic, strong) NSNumber *lastTime;
/**优惠金额*/
@property (nonatomic, strong) NSNumber *reduceMoney;
/**原始费用*/
@property (nonatomic, strong) NSNumber *shouldMoney;
/**商品总价*/
@property (nonatomic, strong) NSNumber *goodsMoney;
/**会员姓名*/
@property (nonatomic, strong) NSString *memberName;
/** 不计入销售额 */
@property (nonatomic, strong) NSNumber *includedSalesAmount;
/** 损益 */
@property (nonatomic, strong) NSNumber *loss;

/**会员积分*/
@property (nonatomic, strong) NSNumber *memberCredits;
/**支付时间*/
@property (nonatomic, strong) NSNumber *payTime;
/**满减金额*/
@property (nonatomic, strong) NSNumber *reducePrice;
/**备注*/
@property (nonatomic, strong) NSString *memo;
//备注
@property (nonatomic, copy  ) NSString *salesInfo;
/**订单来源*/
@property (nonatomic, copy) NSString *outType;
/** 是否是会员 */
@property (nonatomic, assign) BOOL isMember;
/** 会员头像 */
@property (nonatomic, copy) NSString *memberHeaderImg;
/** 会员卡类型 */
@property (nonatomic, copy) NSString *cardKind;
/**会员卡号*/
@property (nonatomic, strong) NSString *cardId;
/** 余额 */
@property (nonatomic, strong) NSNumber *balance;
/** 整单折扣 */
@property (nonatomic, strong) NSNumber *wholeDiscountFee;
/** 实收金额实退金额 */
@property (nonatomic, strong) NSNumber *discountAmount;
@end
