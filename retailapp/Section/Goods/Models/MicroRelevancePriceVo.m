//
//  MicroRelevancePriceVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/10/13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MicroRelevancePriceVo.h"
#import "ObjectUtil.h"
@implementation MicroRelevancePriceVo

+(MicroRelevancePriceVo*)convertToMicroRelevancePriceVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        MicroRelevancePriceVo* microRelevancePriceVo = [[MicroRelevancePriceVo alloc] init];
        microRelevancePriceVo.goodsId = [ObjectUtil getStringValue:dic key:@"goodsId"];
        microRelevancePriceVo.minSaleDiscountRate = [ObjectUtil getNumberValue:dic key:@"minSaleDiscountRate"];
        microRelevancePriceVo.maxSupplyDiscountRate = [ObjectUtil getNumberValue:dic key:@"maxSupplyDiscountRate"];
        microRelevancePriceVo.styleName = [ObjectUtil getStringValue:dic key:@"styleName"];
        microRelevancePriceVo.styleCode = [ObjectUtil getStringValue:dic key:@"styleCode"];
        microRelevancePriceVo.innerCode = [ObjectUtil getStringValue:dic key:@"innerCode"];
        
        return microRelevancePriceVo;
    }
    
    return nil;
}

@end
