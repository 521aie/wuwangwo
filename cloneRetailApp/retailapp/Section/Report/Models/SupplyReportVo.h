//
//  SupplyReportVo.h
//  retailapp
//
//  Created by guozhi on 16/2/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupplyReportVo : NSObject
/**实体id*/
@property (nonatomic, copy) NSString *entityId;
/**商户id*/
@property (nonatomic, copy) NSString *shopId;
/**门店区分  Byte*/
@property (nonatomic, strong) NSNumber *shopType;
/**供货金额 BigDecimal*/
@property (nonatomic, strong) NSNumber *supplyAmount;
/**供货单数 Integer*/
@property (nonatomic, strong) NSNumber *supplyOrderNumber;
/**配送费 BigDecimal*/
@property (nonatomic, strong) NSNumber *freight;
/**总金额 BigDecimal*/
@property (nonatomic, strong) NSNumber *totalSupplyAmount;
/**总利润 BigDecimal*/
@property (nonatomic, strong) NSNumber *totalProfit;
/**扩展属性*/
@property (nonatomic, copy) NSString *extendFields;
/**商户名称*/
@property (nonatomic, copy) NSString *shopName;
/**供货开始时间 Long*/
@property (nonatomic, strong) NSNumber *startTime;
/**供货结束时间 Long*/
@property (nonatomic, strong) NSNumber *endTime;


- (instancetype)initWIthDictionary:(NSDictionary *)json;
@end
