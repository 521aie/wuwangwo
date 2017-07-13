//
//  LSMemberMeterVo.h
//  retailapp
//
//  Created by wuwangwo on 2017/3/28.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSMemberMeterGoodsVo.h"
#import "GoodsOperationVo.h"

@interface LSMemberMeterVo : NSObject
//售价
@property (nonatomic, strong) NSNumber *price;
//计次卡id
@property (nonatomic, copy) NSString *id;
//计次卡名称
@property (nonatomic, copy) NSString *accountCardName;
//有效期（天）：“不限期”或N天
@property (nonatomic, strong) NSNumber *expiryDate;
//有效期开始日期
@property (nonatomic, strong) NSNumber *startDate;
//有效期结束日期
@property (nonatomic, strong) NSNumber *endDate;
//计次商品（个）：计次商品的种类数量
@property (nonatomic, strong) NSNumber *goodsKindCount;
//已销售（张）：收银端充值计次卡之后+1
@property (nonatomic, strong) NSNumber *salesNum;
//	是否失效（0=失效 1=有效）
@property (nonatomic, strong) NSNumber *isExpiry;
//是否可退
@property (nonatomic, strong) NSNumber *isReturn;
//充值几天可退
@property (nonatomic, strong) NSNumber *returnDays;
//状态（1:正常 2:已用完 3:已退款）
@property (nonatomic, strong) NSNumber *status;

//计次商品
@property (nonatomic, strong) NSMutableArray *goodsList;
@property (nonatomic, strong) LSMemberMeterGoodsVo *meterGoodsVo;
@property (nonatomic, strong) GoodsOperationVo *goodsVo;

+ (instancetype)meterVoWithDict:(NSDictionary *)dict;
@end
