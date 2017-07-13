//
//  StockChangeLogVo.h
//  retailapp
//
//  Created by qingmei on 15/11/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockChangeLogVo : NSObject
/**商户ID*/
@property (nonatomic, strong) NSString *shopId;
/**商品名字*/
@property (nonatomic, strong) NSString *goodsName;
/**商品id*/
@property (nonatomic, strong) NSString *goodsId;
/**商品条码*/
@property (nonatomic, strong) NSString *barCode;
/**店内码*/
@property (nonatomic, strong) NSString *innerCode;
/**商品颜色*/
@property (nonatomic, strong) NSString *goodsColor;
/**商品尺码*/
@property (nonatomic, strong) NSString *goodsSize;
/**库存数*/
@property (nonatomic, strong) NSNumber *adjustNum;
/**操作类型*/
@property (nonatomic, strong) NSString *operationType;
/**操作时间*/
@property (nonatomic, strong) NSString *opTime;
/**现在库存*/
@property (nonatomic, strong) NSNumber *nowStore;
/**变更后库存*/
@property (nonatomic, strong) NSNumber *stockBalance;
/**操作人*/
@property (nonatomic, strong) NSString *opUser;
/**库存记录表id*/
@property (nonatomic, strong) NSString *stockInfoId;
/**序号*/
@property (nonatomic, strong) NSNumber *identyCode;
/**员工号*/
@property (nonatomic, strong) NSString *staffId;

/** 单号 */
@property (nonatomic, copy) NSString *businessCode;
/** 单据时间 */
@property (nonatomic, strong) NSNumber *businessTime;

- (instancetype)initWithDictionary:(NSDictionary *)json;
@end
