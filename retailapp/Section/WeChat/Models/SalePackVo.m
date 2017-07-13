//
//  SalePackVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SalePackVo.h"

@implementation SalePackVo

+(SalePackVo*)convertToSalePackVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        SalePackVo* salePackVo = [[SalePackVo alloc] init];
        salePackVo.salePackId = [ObjectUtil getNumberValue:dic key:@"salePackId"];
        salePackVo.packCode = [ObjectUtil getStringValue:dic key:@"packCode"];
        salePackVo.packName = [ObjectUtil getStringValue:dic key:@"packName"];
        salePackVo.applyYear = [ObjectUtil getIntegerValue:dic key:@"applyYear"];
        salePackVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        
        return salePackVo;
    }
    return nil;
}

+(NSDictionary*)getDictionaryData:(SalePackVo *)salePackVo
{
    if ([ObjectUtil isNotNull:salePackVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setNumberValue:data key:@"salePackId" val:salePackVo.salePackId];
        [ObjectUtil setStringValue:data key:@"packCode" val:salePackVo.packCode];
        [ObjectUtil setStringValue:data key:@"packName" val:salePackVo.packName];
        [ObjectUtil setIntegerValue:data key:@"applyYear" val:salePackVo.applyYear];
        [ObjectUtil setIntegerValue:data key:@"lastVer" val:salePackVo.lastVer];
        
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
            SalePackVo* vo = [SalePackVo convertToSalePackVo:dic];
            [datas addObject:vo];
        }
    }
    return datas;
}

-(BOOL) obtainCheckVal
{
    return self.checkVal;
}

-(NSString*) obtainItemId
{
    return self.salePackId.stringValue;
}

-(NSString*) obtainItemYear
{
    return [NSString stringWithFormat:@"%ld",(long)self.applyYear];
}

-(void) mCheckVal:(BOOL)check
{
    self.checkVal = check;
}

@end
