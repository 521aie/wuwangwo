//
//  GoodsSalesReportVo.h
//  retailapp
//
//  Created by zhangzhiliang on 16/1/12.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface GoodsSalesReportVo : Jastor

/**商品名称or款式名称*/
@property (nonatomic, strong) NSString *name;

/**零售价or吊牌价*/
@property (nonatomic) double price;

/**净销量*/
@property (nonatomic, strong) NSNumber *netSales;

/**折前金额*/
@property (nonatomic) double originalAmount;

/**净销售额*/
@property (nonatomic) double netAmount;

/**款号*/
@property (nonatomic, strong) NSString *styleCode;

/**条形码*/
@property (nonatomic, strong) NSString *barCode;

/**商品Id*/
@property (nonatomic, strong) NSString *goodsId;

/**款式Id*/
@property (nonatomic, strong) NSString *styleId;

+(GoodsSalesReportVo*)convertToGoodsSalesReportVo:(NSDictionary*)dic;
+(NSDictionary*)getDictionaryData:(GoodsSalesReportVo *)goodsSalesReportVo;
+ (NSMutableArray*)converToArr:(NSArray*)sourceList;

@end
