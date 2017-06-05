//
//  LSMemberMeterGoodsVo.h
//  retailapp
//
//  Created by wuwangwo on 2017/3/28.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSMemberMeterGoodsVo : NSObject
//计次卡商品名称
@property (nonatomic, copy) NSString *goodsName;
//计次卡商品id
@property (nonatomic, copy) NSString *goodsId;
//计次卡商品条形码
@property (nonatomic, copy) NSString *barCode;
//list数量
@property (nonatomic, assign) int consumeTime;
//已销售
@property (nonatomic, strong) NSNumber *salesNum;
//计次卡id
@property (nonatomic, copy) NSString *ID;
/**操作类型*/
@property (nonatomic, strong) NSString *operateType;
/**
 * 1.普通商品 2.拆分商品 3.组装商品 4.散装商品 5.原料商品 6:加工商品
 *   目前5 没有用，4类型goodsSum 是小数，其他是整数
 */
@property (nonatomic, strong) NSNumber *goodsType;
@property (nonatomic,assign) short changeFlag;

+ (instancetype)meterGoodsVoWithDict:(NSDictionary *)dict;
@end
