//
//  StockInfoVo.h
//  retailapp
//
//  Created by guozhi on 15/10/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockInfoVo : NSObject
@property (nonatomic, copy) NSString *goodsId; //商品id 商超
@property (nonatomic, copy) NSString *goodsName; //商品名字 商超
@property (nonatomic, copy) NSString *barCode; //商品条码 商超
@property (nonatomic, copy) NSString *styleId; //款式id 服鞋
@property (nonatomic, copy) NSString *styleName; //款式名称 服鞋
@property (nonatomic, copy) NSString *styleCode; //款号 服鞋
@property (nonatomic, copy) NSString *innerCode; //店内码 服鞋
@property (nonatomic, copy) NSString *shopId; //商户ID
@property (nonatomic, copy) NSString *fileName; //商品 路径
@property (nonatomic, strong) NSNumber *nowStore; //库存数  BigDecimal
@property (nonatomic, strong) NSNumber *currPrice; //最新进货单价 BigDecimal 门店
@property (nonatomic, strong) NSNumber *sumMoney; //库存金额  BigDecimal (吊牌价or零售价or进货价) * 库存数量
@property (nonatomic, strong) NSNumber *powerSumMoney; //库存金额  BigDecimal (吊牌价or零售价or进货价) * 库存数量
@property (nonatomic, strong) NSNumber *purchasePrice; //进货价  BigDecimal 进货价 单店
@property (nonatomic, strong) NSNumber *retailPrice; //零售价   BigDecimal 商超+连锁
@property (nonatomic, strong) NSNumber *hangTagPrice; //吊牌价  BigDecimal 服鞋+连锁
@property (nonatomic, strong) NSNumber *powerPrice; //平均进货单价  BigDecimal成本价
@property (nonatomic, strong) NSNumber *fallDueNum; //临期库存数  BigDecimal
@property (nonatomic, strong) NSNumber *isAlert; //是否库存警戒  Short
@property (nonatomic, strong) NSNumber *minStore; //最低库存  BigDecimal
@property (nonatomic, strong) NSNumber *aheadDays; //到期提醒提前天数  Integer
@property (nonatomic, strong) NSNumber *isExpireAlert; //是否到期警戒 Short
@property (nonatomic, strong) NSNumber *virtualStoreStatus; //虚拟库存状态 Byte 1.无虚拟库存 2.虚拟库存正常 3.虚拟库存异常
@property (nonatomic, strong) NSNumber *virtualStore; //虚拟库存 BigDecimal
@property (nonatomic, strong) NSNumber *supplyPrice; //供货价 BigDecimal
@property (nonatomic, strong) NSNumber *shopWeeksales; //门店周销量 BigDecimal
@property (nonatomic, strong) NSNumber *microShopWeekSales; //微店周销量 BigDecimal
@property (nonatomic, strong) NSNumber *maxValidVirtualStore; //最高可分配虚拟库存数 BigDecimal
@property (nonatomic, strong) NSNumber *maxValidSupplyPriceRate; //最高可选供货折扣率 BigDecimal
@property (nonatomic, strong) NSNumber *supplyDiscountRate;  //最高可选供货折扣率 BigDecimal
@property (nonatomic, strong) NSNumber *weixinPrice;/**<微店价>*/
@property (nonatomic, assign) BOOL isSelected; //是否选择了 YES选择 NO 不选择

//冻结库存数
@property (nonatomic, strong) NSNumber *lockStore;
/**
 1.普通商品
 2.拆分商品
 3.组装商品
 4.散装商品
 5.原料商品
 6:加工商品
 */
@property (nonatomic, strong) NSNumber *goodsType;
- (instancetype)initWithDictionary:(NSDictionary *)json;
+ (NSMutableArray *)converToArr:(NSArray *)sourceList;
// 获取商品类型对应的图片名称
- (NSString *)goodTypeImageString;
@end
