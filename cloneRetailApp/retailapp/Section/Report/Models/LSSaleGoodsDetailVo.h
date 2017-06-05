//
//  LSSaleGoodsDetailVo.h
//  retailapp
//
//  Created by taihangju on 2016/12/5.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSSaleGoodsDetailVo : NSObject

@property (nonatomic ,strong) NSString *styleCode;/*<款号>*/
@property (nonatomic ,strong) NSString *styleName;/*<款式名称>*/
@property (nonatomic ,strong) NSString *goodsName;/*<商品名称>*/
@property (nonatomic ,strong) NSString *barCode;/*<条形码>*/
@property (nonatomic ,strong) NSNumber *netSales;/*<净销量>*/
@property (nonatomic ,strong) NSNumber *netAmount;/*<净销售额>*/
@property (nonatomic ,strong) NSNumber *sellCost;/*<销售成本>*/
@property (nonatomic ,strong) NSNumber *averagePrice;/*<销售均价>*/
@property (nonatomic ,strong) NSNumber *sellProfit;/*<销售毛利>*/
@property (nonatomic ,strong) NSNumber *profitRatio;/*<毛利率>*/
@property (nonatomic ,strong) NSNumber *profit;/*<毛利比重>*/
@property (nonatomic ,strong) NSNumber *returnNum;/*<退货数量>*/
@property (nonatomic ,strong) NSNumber *returnAmount;/*<退货金额>*/
@property (nonatomic ,strong) NSNumber *returnRate;/*<退货率>*/
@property (nonatomic ,strong) NSString *categoryName;/*<分类名称>*/
@property (nonatomic ,strong) NSString *brandName;/*<品牌名称>*/

+ (NSArray *)saleGoodsDetailVoList:(NSArray *)keyValuesArray;
@end
