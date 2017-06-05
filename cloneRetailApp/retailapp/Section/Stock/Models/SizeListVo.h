//
//  SizeListVo.h
//  retailapp
//
//  Created by guozhi on 15/10/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SizeListVo : NSObject
@property (nonatomic, copy) NSString *detailId; 
@property (nonatomic, copy) NSString *goodsId; //商品ID
@property (nonatomic, copy) NSString *sizeVal; //尺码值
@property (nonatomic, strong) NSNumber *virtualStore; //虚拟库存 BigDecimal
@property (nonatomic, strong) NSNumber *maxValidVirtualStore; //最高可分配虚拟库存数 BigDecimal
@property (nonatomic, strong) NSNumber *virtualStoreStatus; //虚拟库存状态 Byte 1：无虚拟库存 2：虚拟库存正常 3：虚拟库存异常
@property (nonatomic, strong) NSNumber *nowStore; //库存 BigDecimal
@property (nonatomic, assign) BOOL isChange;
@property (nonatomic, strong) NSNumber *count; //商品数量 BigDecimal
@property (nonatomic, strong) NSNumber *adjustCount; //商品数量 BigDecimal
@property (nonatomic, strong) NSNumber *totalStore; //调整后库存 BigDecimal
@property (nonatomic, copy) NSString *operateType; //操作类型
@property (nonatomic, strong) NSNumber *hasStore; //0.无库存信息 1.有库存信息
@property (nonatomic, strong) NSString *isValid;   //0 无效 1有效
@property (nonatomic, strong) NSNumber *goodsHangTagPrice;  //商品价格
/** 成本价 */
@property (nonatomic, strong) NSNumber *goodsPowerPrice;
@property (nonatomic, strong) NSNumber *predictSum;  //预计数量

@property (nonatomic, strong) NSNumber *lockStore; //冻结库存数

/** 调整前成本价 */
@property (nonatomic, strong) NSNumber *beforeCostPrice;
/** 调整后成本价 */
@property (nonatomic, strong) NSNumber *laterCostPrice;
@end
