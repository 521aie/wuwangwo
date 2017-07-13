//
//  PaperGoodsVo.m
//  retailapp
//
//  Created by hm on 15/10/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PaperGoodsVo.h"

@implementation PaperGoodsVo
+ (PaperGoodsVo*)converToVo:(NSDictionary*)dic
{
    PaperGoodsVo* vo = [[PaperGoodsVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        vo.goodsId = [ObjectUtil getStringValue:dic key:@"goodsId"];
        vo.goodsName = [ObjectUtil getStringValue:dic key:@"goodsName"];
        vo.barCode = [ObjectUtil getStringValue:dic key:@"barCode"];
        vo.purchasePrice = [ObjectUtil getDoubleValue:dic key:@"purchasePrice"];
        vo.retailPrice = [ObjectUtil getDoubleValue:dic key:@"retailPrice"];
        vo.shortCode = [ObjectUtil getStringValue:dic key:@"shortCode"];
        vo.type = [ObjectUtil getIntegerValue:dic key:@"type"];
        vo.nowStore = [ObjectUtil getDoubleValue:dic key:@"nowStore"];
        vo.checkVal = NO;
    }
    return vo;
}
+ (NSMutableArray*)converToArr:(NSArray*)sourceList
{
    NSMutableArray* dataList = [NSMutableArray arrayWithCapacity:sourceList.count];
    if ([ObjectUtil isNotEmpty:sourceList]) {
        for (NSDictionary* dic in sourceList) {
            PaperGoodsVo* vo = [PaperGoodsVo converToVo:dic];
            [dataList addObject:vo];
        }
    }
    return dataList;
}

-(NSString*) obtainItemId
{
    return self.goodsId;
}
-(NSString*) obtainItemName
{
    return self.goodsName;
}

-(NSString*) obtainItemValue
{
    return self.barCode;
}
-(BOOL) obtainCheckVal
{
    return self.checkVal;
}
-(void) mCheckVal:(BOOL)check
{
    self.checkVal = check;
}
@end
