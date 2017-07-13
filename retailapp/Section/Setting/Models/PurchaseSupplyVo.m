//
//  PurchaseSupplyVo.m
//  retailapp
//
//  Created by hm on 16/1/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "PurchaseSupplyVo.h"

@implementation PurchaseSupplyVo
- (instancetype)initWithDictionary:(NSDictionary *)json {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:json];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (NSMutableArray *)converToArr:(NSArray *)arr
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    if ([ObjectUtil isNotEmpty:arr]) {
        for (NSDictionary *dic in arr) {
            PurchaseSupplyVo *vo = [[PurchaseSupplyVo alloc] initWithDictionary:dic];
            [list addObject:vo];
        }
    }
    return list;
}

+ (NSMutableArray *)converToDicArr:(NSMutableArray *)arr
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    if ([ObjectUtil isNotEmpty:arr]) {
        for (PurchaseSupplyVo *vo  in arr) {
            NSMutableDictionary *dic = [PurchaseSupplyVo converVoToDic:vo];
            [list addObject:dic];
        }
    }
    return list;
}

+ (NSMutableDictionary *)converVoToDic:(PurchaseSupplyVo*)vo
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if ([ObjectUtil isNotNull:vo]) {
        [ObjectUtil setStringValue:dic key:@"purchaseSupplyId" val:vo.purchaseSupplyId];
        [ObjectUtil setStringValue:dic key:@"entityId" val:vo.entityId];
        [ObjectUtil setStringValue:dic key:@"purchaseOrgId" val:vo.purchaseOrgId];
        [ObjectUtil setStringValue:dic key:@"supplyOrgId" val:vo.supplyOrgId];
        [ObjectUtil setStringValue:dic key:@"isValid" val:vo.isValid];
        [ObjectUtil setStringValue:dic key:@"operateType" val:vo.operateType];
        [ObjectUtil setStringValue:dic key:@"supplyName" val:vo.supplyName];
        [ObjectUtil setStringValue:dic key:@"supplyCode" val:vo.supplyCode];
        [ObjectUtil setStringValue:dic key:@"linkMan" val:vo.linkMan];
        [ObjectUtil setStringValue:dic key:@"phone" val:vo.phone];
    }
    return dic;
}

-(NSString*) obtainItemId
{
    return self.supplyOrgId;
}
-(NSString*) obtainItemName
{
    return self.supplyName;
}
-(NSString*) obtainItemCode
{
    return self.supplyCode;
}
@end
