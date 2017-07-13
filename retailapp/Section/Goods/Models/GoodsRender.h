//
//  GoodsRender.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/5.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttributeGroupVo.h"

@interface GoodsRender : NSObject

+(NSMutableArray*) listGoodsBrand;

+(NSMutableArray*) listSex:(BOOL) isShow;

+(NSMutableArray*) listAttributeVal:(NSMutableArray*) attributeValVoList isShow:(BOOL) isShow;

+(NSMutableArray*) listMicroSaleStrategy;

+(NSMutableArray*) listBatchMicroSaleStrategy;

+(NSMutableArray*) listMicroSaleType;

+(NSMutableArray*) listParentCategoryList:(NSMutableArray*) parentCategoryList;

+(NSMutableArray*) listBrandList:(NSMutableArray*) brandList;

+(NSMutableArray*) listAttributeGroup:(NSMutableArray*) attributeGroupList;

+(NSString*) obtainSex:(NSString*)sexId;

+(AttributeGroupVo*) obtainAttributeGroup:(NSString*)attributeGroupId attributeGroupList:(NSMutableArray *)attributeGroupList;

+(NSString*) obtainMicroSaleStrategy:(short)microSaleStrategyId;

+(NSMutableArray*) listCategoryList:(NSMutableArray*) categoryList isShow:(BOOL) isShow;
+(NSMutableArray*) listMicroCategoryList:(NSMutableArray*) categoryList isShow:(BOOL) isShow;

+(NSString*) obtainMicroReduceStockWay:(short)microReduceStockWayId;

+(NSMutableArray*) listMicroReduceStockWay;

+(NSString*) obtainMicroSaleType:(short)microSaleType;

+(NSString*) obtainCategoryName:(NSString*) categoryId categoryList:(NSMutableArray*) categoryList;
+(NSString*) obtainMicCategoryName:(NSString*) categoryId categoryList:(NSMutableArray*) categoryList;

+(NSString*) obtainAttributeVal:(NSString*) attributeValId attributeValList:(NSMutableArray*) attributeValList;
@end
