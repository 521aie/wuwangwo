//
//  StockAdjustDetailVo.h
//  retailapp
//
//  Created by hm on 15/10/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMultiNameValueItem.h"
@interface StockAdjustDetailVo : NSObject<IMultiNameValueItem>
@property (nonatomic , copy) NSString *goodsId;
@property (nonatomic , copy) NSString *barCode;
@property (nonatomic , copy) NSString *goodsName;
/**吊牌价*/
@property (nonatomic , strong) NSNumber *hangTagPrice;
/**进货价*/
@property (nonatomic , strong) NSNumber *purchasePrice;
/**成本价*/
@property (nonatomic , strong) NSNumber *powerPrice;
/**零售价*/
@property (nonatomic , strong) NSNumber *retailPrice;
/**盈亏金额*/
@property (nonatomic , strong) NSNumber *resultPrice;
@property (nonatomic , strong) NSNumber *adjustStore;
@property (nonatomic , strong) NSNumber *nowStore;
//调整后库存
@property (nonatomic , strong) NSNumber *totalStore;
@property (nonatomic , strong) NSNumber *oldAdjustStore;
@property (nonatomic , strong) NSNumber *oldTotalStore;
/**商品类型 散装4  非散装*/
@property (nonatomic , assign) short type;
@property (nonatomic , assign) short changeFlag;
@property (nonatomic , assign) short reasonFlag;
@property (nonatomic , copy) NSString *operateType;
@property (nonatomic , copy) NSString *adjustReasonId;
@property (nonatomic , copy) NSString *adjustReason;
@property (nonatomic , copy) NSString *oldReasonId;
@property (nonatomic , copy) NSString *styleId;
@property (nonatomic , copy) NSString *styleName;
@property (nonatomic , copy) NSString *styleCode;
@property (nonatomic , strong) NSNumber *sumAdjustMoney;
/** 图片路径 */
@property (nonatomic, copy) NSString *filePath;
/** 上下架状态 */
@property (nonatomic, assign) NSInteger goodsStatus;
/** 商品类型 */
@property (nonatomic, assign) NSInteger goodsType;
- (instancetype)initWithDictionary:(NSDictionary *)json;
+ (StockAdjustDetailVo *)converToVo:(NSDictionary *)dic;
+ (NSMutableArray *)converToArr:(NSArray *)sourceList;

+ (NSMutableDictionary *)converToDic:(StockAdjustDetailVo *)vo;
+ (NSMutableArray *)converArrToDicArr:(NSMutableArray *)sourceList;

@end
