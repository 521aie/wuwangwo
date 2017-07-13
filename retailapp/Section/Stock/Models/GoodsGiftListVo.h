//
//  GoodsGiftListVo.h
//  retailapp
//
//  Created by guozhi on 15/10/27.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsGiftListVo : NSObject

@property (nonatomic, copy) NSString *goodsId; //商品ID
@property (nonatomic, copy) NSString *name; //商品名称
@property (nonatomic, copy) NSString *barCode; //商品条码
@property (nonatomic, copy) NSString *innerCode; //店内码
@property (nonatomic, copy) NSString *goodsColor; //商品颜色
@property (nonatomic, copy) NSString *goodsSize; //商品尺码
@property (nonatomic, strong) NSNumber *point; //所需积分 Integer
@property (nonatomic, strong) NSNumber *number; //积分商品数量 Integer
@property (nonatomic, strong) NSNumber *giftGoodsNumber; //积分商品库存 BigDecimal
@property (nonatomic, strong) NSNumber *canDistributeNumber; //可分配数量 BigDecimal
@property (nonatomic, strong) NSNumber *goodsNumber; //总数量 BigDecimal
@property (nonatomic, strong) NSNumber *price; //商品价格 BigDecimal
@property (nonatomic, strong) NSNumber *goodsStatus;/**<标示商品上下架状态：1上架 2 下架>*/
@property (nonatomic, strong) NSNumber *goodsType;/**<1-普通商品 2-拆分商品 3-组装商品 4-散装商品 5-原料商品 6-加工商品>*/
@property (nonatomic, copy) NSString *picture;
//@property (nonatomic ,assign) NSInteger type;/*<2：服鞋 1：商超>*/
@property (nonatomic, assign) BOOL isSelected; //记录是否选择

- (NSString *)goodTypeImageString;
- (instancetype)initWithDictionary:(NSDictionary *)json;
+ (NSArray *)getGoodsGiftListVoArray:(NSArray *)keyValuesArray;
@end
