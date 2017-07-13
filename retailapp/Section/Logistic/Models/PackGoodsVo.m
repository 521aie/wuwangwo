//
//  PackGoodsVo.m
//  retailapp
//
//  Created by hm on 15/10/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PackGoodsVo.h"

@implementation PackGoodsVo
+ (PackGoodsVo *)converToVo:(NSDictionary*)dic
{
    PackGoodsVo *vo = [[PackGoodsVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        vo.packGoodsId = [ObjectUtil getStringValue:dic key:@"packGoodsId"];
        vo.packCode = [ObjectUtil getStringValue:dic key:@"packCode"];
        vo.boxCode = [ObjectUtil getStringValue:dic key:@"boxCode"];
        vo.billStatus = [ObjectUtil getShortValue:dic key:@"billStatus"];
        vo.billStatusName = [ObjectUtil getStringValue:dic key:@"billStatusName"];
        vo.packTimeL = [ObjectUtil getLonglongValue:dic key:@"packTimeL"];
        vo.checkVal = NO;
    }
    return vo;
}
+ (NSMutableArray *)converToArr:(NSMutableArray*)sourceList
{
    if ([ObjectUtil isNotEmpty:sourceList]) {
        NSMutableArray *datas = [NSMutableArray arrayWithCapacity:sourceList.count];
        for (NSDictionary *dic in sourceList) {
            PackGoodsVo *vo = [PackGoodsVo converToVo:dic];
            [datas addObject:vo];
        }
        return datas;
    }
    return [NSMutableArray array];
}

-(NSString*) obtainItemId
{
    return self.packGoodsId;
}
-(NSString*) obtainItemName
{
    return self.boxCode;
}
-(NSString*) obtainItemValue
{
    return self.packCode;
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
