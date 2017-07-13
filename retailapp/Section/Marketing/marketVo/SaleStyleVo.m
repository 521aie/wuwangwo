//
//  SaleStyleVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/11/13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SaleStyleVo.h"

@implementation SaleStyleVo

+(SaleStyleVo*)convertToSaleStyleVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        SaleStyleVo* saleStyleVo = [[SaleStyleVo alloc] init];
        saleStyleVo.styleId = [ObjectUtil getStringValue:dic key:@"styleId"];
        saleStyleVo.styleName = [ObjectUtil getStringValue:dic key:@"styleName"];
        saleStyleVo.styleCode = [ObjectUtil getStringValue:dic key:@"styleCode"];
        saleStyleVo.stylePic = [ObjectUtil getStringValue:dic key:@"stylePic"];
        saleStyleVo.createTime = [ObjectUtil getIntegerValue:dic key:@"createTime"];
        
        return saleStyleVo;
    }
    
    return nil;
}

+(NSDictionary*)getDictionaryData:(SaleStyleVo *)saleStyleVo
{
    if ([ObjectUtil isNotNull:saleStyleVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"styleId" val:saleStyleVo.styleId];
        [ObjectUtil setStringValue:data key:@"styleName" val:saleStyleVo.styleName];
        [ObjectUtil setStringValue:data key:@"styleCode" val:saleStyleVo.styleCode];
        [ObjectUtil setStringValue:data key:@"stylePic" val:saleStyleVo.stylePic];
        [ObjectUtil setIntegerValue:data key:@"createTime" val:saleStyleVo.createTime];
      
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
            SaleStyleVo* vo = [SaleStyleVo convertToSaleStyleVo:dic];
            [datas addObject:vo];
        }
    }
    return datas;
}

@end
