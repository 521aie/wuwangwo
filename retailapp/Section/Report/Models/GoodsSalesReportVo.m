//
//  GoodsSalesReportVo.m
//  retailapp
//
//  Created by zhangzhiliang on 16/1/12.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsSalesReportVo.h"

@implementation GoodsSalesReportVo

+(GoodsSalesReportVo*)convertToGoodsSalesReportVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        GoodsSalesReportVo* goodsSalesReportVo = [[GoodsSalesReportVo alloc] init];
        goodsSalesReportVo.name = [ObjectUtil getStringValue:dic key:@"name"];
        goodsSalesReportVo.price = [ObjectUtil getDoubleValue:dic key:@"price"];
        goodsSalesReportVo.netSales = [ObjectUtil getNumberValue:dic key:@"netSales"];
        goodsSalesReportVo.originalAmount = [ObjectUtil getDoubleValue:dic key:@"originalAmount"];
        goodsSalesReportVo.netAmount = [ObjectUtil getDoubleValue:dic key:@"netAmount"];
        goodsSalesReportVo.styleCode = [ObjectUtil getStringValue:dic key:@"styleCode"];
        goodsSalesReportVo.barCode = [ObjectUtil getStringValue:dic key:@"barCode"];
        goodsSalesReportVo.goodsId = [ObjectUtil getStringValue:dic key:@"goodsId"];
        goodsSalesReportVo.styleId = [ObjectUtil getStringValue:dic key:@"styleId"];
        return goodsSalesReportVo;
    }
    
    return nil;
}

+(NSDictionary*)getDictionaryData:(GoodsSalesReportVo *)goodsSalesReportVo
{
    if ([ObjectUtil isNotNull:goodsSalesReportVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"name" val:goodsSalesReportVo.name];
        [ObjectUtil setDoubleValue:data key:@"price" val:goodsSalesReportVo.price];
        [ObjectUtil setNumberValue:data key:@"netSales" val:goodsSalesReportVo.netSales];
        [ObjectUtil setDoubleValue:data key:@"originalAmount" val:goodsSalesReportVo.originalAmount];
        [ObjectUtil setDoubleValue:data key:@"originalAmount" val:goodsSalesReportVo.originalAmount];
        [ObjectUtil setStringValue:data key:@"styleCode" val:goodsSalesReportVo.styleCode];
        [ObjectUtil setStringValue:data key:@"barCode" val:goodsSalesReportVo.barCode];
        [ObjectUtil setStringValue:data key:@"goodsId" val:goodsSalesReportVo.goodsId];
        [ObjectUtil setStringValue:data key:@"styleId" val:goodsSalesReportVo.styleId];
        
        return data;
    }
    return nil;
}

+ (NSMutableArray*)converToArr:(NSArray*)sourceList
{
    NSMutableArray* datas = nil;
    if ([ObjectUtil isNotEmpty:sourceList]) {
        datas = [NSMutableArray arrayWithCapacity:sourceList.count];
        for (NSDictionary* dic in sourceList) {
            GoodsSalesReportVo* vo = [GoodsSalesReportVo convertToGoodsSalesReportVo:dic];
            [datas addObject:vo];
        }
    }
    return datas;
}

@end
