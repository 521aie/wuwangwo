//
//  MicroStyleVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/12.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MicroStyleVo.h"
#import "MicroStyleImageVo.h"

@implementation MicroStyleVo

+(MicroStyleVo*)convertToMicroStyleVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        MicroStyleVo* microStyleVo = [[MicroStyleVo alloc] init];
        microStyleVo.styleId = [ObjectUtil getStringValue:dic key:@"styleId"];
        microStyleVo.styleName = [ObjectUtil getStringValue:dic key:@"styleName"];
        microStyleVo.brandName = [ObjectUtil getStringValue:dic key:@"brandName"];
        microStyleVo.hangTagPrice = [ObjectUtil getDoubleValue:dic key:@"hangTagPrice"];
        microStyleVo.styleCode = [ObjectUtil getStringValue:dic key:@"styleCode"];
        microStyleVo.retailPrice = [ObjectUtil getDoubleValue:dic key:@"retailPrice"];
        microStyleVo.mainImageVoList = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:[dic objectForKey:@"mainImageVoList"]]) {
            NSMutableArray* list = [dic objectForKey:@"mainImageVoList"];
            if (list.count > 0) {
                for (NSDictionary* dic1 in list) {
                    [microStyleVo.mainImageVoList addObject:[MicroStyleImageVo convertToMicroStyleImageVo:dic1]];
                }
            }
        }
        
        return microStyleVo;
    }
    
    return nil;

}

+(NSDictionary*)getDictionaryData:(MicroStyleVo *)microStyleVo
{
    if ([ObjectUtil isNotNull:microStyleVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"styleId" val:microStyleVo.styleId];
        [ObjectUtil setStringValue:data key:@"styleName" val:microStyleVo.styleName];
        [ObjectUtil setStringValue:data key:@"brandName" val:microStyleVo.brandName];
        [ObjectUtil setDoubleValue:data key:@"hangTagPrice" val:microStyleVo.hangTagPrice];
        [ObjectUtil setStringValue:data key:@"styleCode" val:microStyleVo.styleCode];
        [ObjectUtil setDoubleValue:data key:@"retailPrice" val:microStyleVo.retailPrice];
        
        if (microStyleVo.mainImageVoList != nil && microStyleVo.mainImageVoList.count > 0) {
            NSMutableArray* list = [[NSMutableArray alloc] init];
            for (MicroStyleImageVo* vo in microStyleVo.mainImageVoList) {
                [list addObject:[MicroStyleImageVo getDictionaryData:vo]];
            }
            [data setValue:list forKey:@"mainImageVoList"];
        } else {
            microStyleVo.mainImageVoList = [[NSMutableArray alloc] init];
            [data setValue:microStyleVo.mainImageVoList forKey:@"mainImageVoList"];
        }
        
        return data;
    }
    return nil;
}

@end
