//
//  LSByTimeServiceVo.h
//  retailapp
//
//  Created by taihangju on 2017/4/5.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSByTimeServiceVo : NSObject

@property (nonatomic, strong) NSString *id;/**<计次卡id>*/
@property (nonatomic, strong) NSString *entityId;/**<<#说明#>>*/
@property (nonatomic, strong) NSString *cardId;/**<<#说明#>>*/
@property (nonatomic, strong) NSString *accountCardId;/**<>*/
@property (nonatomic, strong) NSString *accountCardName;/**<计次卡名称>*/
@property (nonatomic, strong) NSNumber *expiryDate;/**<有效期（天）0 标示不限期限>*/
@property (nonatomic, strong) NSNumber *startDate;/**<有效期开始日期>*/
@property (nonatomic, strong) NSNumber *endDate;/**<有效期结束日期>*/
@property (nonatomic, strong) NSNumber *returnDate;/**<<#说明#>>*/
@property (nonatomic, strong) NSNumber *createTime;/**<<#说明#>>*/
@property (nonatomic, strong) NSNumber *opTime;/**<<#说明#>>*/
@property (nonatomic, strong) NSNumber *goodsKindCount;/**<计次服务包含的计次商品种类数>*/
@property (nonatomic, strong) NSNumber *isExpiry;/**<是否失效（0=失效 1=有效）>*/
@property (nonatomic, strong) NSNumber *isReturn;/**<是否可退>*/
@property (nonatomic, strong) NSNumber *price;/**<售价>*/
@property (nonatomic, strong) NSNumber *returnDays;/**<充值后几天可退>*/
@property (nonatomic, strong) NSNumber *salesNum;/**<销售数量	>*/
@property (nonatomic, strong) NSNumber *status;/**<状态（1:正常 2:已用完 3:已退款）>*/
@property (nonatomic, assign) BOOL isExpand;/**<展开>*/
@property (nonatomic, strong) NSArray *goodsArray;/**<计次卡包含的商品类型>*/

+ (NSArray *)byTimeServiceVoListFromKeyValuesArray:(NSArray *)keyValuesArray;
- (NSString *)statusString;
- (NSString *)validTimeString;
- (NSString *)goodNumberString;
@end


@interface LSByTimeGoodVo : NSObject

@property (nonatomic, strong) NSString *barCode;/**<计次商品条码>*/
@property (nonatomic, strong) NSNumber *consumeResidueTime;/**<剩余消费次数>*/
@property (nonatomic, strong) NSNumber *consumeTime;/**<总消费次数>*/
@property (nonatomic, strong) NSString *goodsName;/**<计次商品名>*/

+ (NSArray *)byTimeGoodVoListFromKeyValuesArray:(NSArray *)keyValuesArray;
@end
