//
//  GoodsPackRecordVo.m
//  retailapp
//
//  Created by hm on 15/11/6.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsPackRecordVo.h"

@implementation GoodsPackRecordVo
+ (GoodsPackRecordVo *)converToVo:(NSDictionary *)dic
{
    GoodsPackRecordVo *vo = [[GoodsPackRecordVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        vo.returnGoodsDetailId = [ObjectUtil getStringValue:dic key:@"returnGoodsDetailId"];
        vo.packGoodsId = [ObjectUtil getStringValue:dic key:@"packGoodsId"];
        vo.goodsId = [ObjectUtil getStringValue:dic key:@"goodsId"];
        vo.boxCode = [ObjectUtil getStringValue:dic key:@"boxCode"];
        vo.goodsColor = [ObjectUtil getStringValue:dic key:@"goodsColor"];
        vo.goodsSize = [ObjectUtil getStringValue:dic key:@"goodsSize"];
        vo.operateType = @"";
        vo.realSum = [ObjectUtil getNumberValue:dic key:@"realSum"];
        vo.goodsPrice = [ObjectUtil getNumberValue:dic key:@"goodsPrice"];
        vo.oldSum = [ObjectUtil getNumberValue:dic key:@"realSum"];
        vo.changeFlag = 0;
    }
    return vo;
}
+ (NSMutableArray *)converToArr:(NSArray *)sourceList
{
    if ([ObjectUtil isNotEmpty:sourceList]) {
       NSMutableArray *datas = [NSMutableArray arrayWithCapacity:sourceList.count];
        for (NSDictionary *dic in sourceList) {
            GoodsPackRecordVo *vo = [GoodsPackRecordVo converToVo:dic];
            [datas addObject:vo];
        }
        return datas;
    }
    return [NSMutableArray array];
}

+ (NSMutableDictionary *)converToDic:(GoodsPackRecordVo *)vo
{
    NSMutableDictionary *datas = [NSMutableDictionary dictionary];
    if ([ObjectUtil isNotNull:vo]) {
        [ObjectUtil setStringValue:datas key:@"returnGoodsDetailId" val:vo.returnGoodsDetailId];
        [ObjectUtil setStringValue:datas key:@"packGoodsId" val:vo.packGoodsId];
        [ObjectUtil setStringValue:datas key:@"goodsId" val:vo.goodsId];
        [ObjectUtil setStringValue:datas key:@"boxCode" val:vo.boxCode];
        [ObjectUtil setStringValue:datas key:@"goodsColor" val:vo.goodsColor];
        [ObjectUtil setStringValue:datas key:@"goodsSize" val:vo.goodsSize];
        [ObjectUtil setStringValue:datas key:@"operateType" val:vo.operateType];
        [ObjectUtil setNumberValue:datas key:@"realSum" val:vo.realSum];
        [ObjectUtil setNumberValue:datas key:@"goodsPrice" val:vo.goodsPrice];
    }
    return datas;
}

+ (NSMutableArray *)converToDicArr:(NSMutableArray *)sourceList
{
    if ([ObjectUtil isNotEmpty:sourceList]) {
        NSMutableArray *datas = [NSMutableArray arrayWithCapacity:sourceList.count];
        for (GoodsPackRecordVo *vo  in sourceList) {
            NSMutableDictionary *dic = [GoodsPackRecordVo converToDic:vo];
            [datas addObject:dic];
        }
        return datas;
    }
    return [NSMutableArray array];
}

-(NSString*) obtainItemId
{
    return self.returnGoodsDetailId;
}
-(NSString*) obtainItemName
{
    return [NSString stringWithFormat:@"%@ %@",self.goodsColor,self.goodsSize];
}
-(NSString*) obtainOrignName
{
    return [NSString stringWithFormat:@"%@ %@",self.goodsColor,self.goodsSize];
}

-(NSString*) obtainItemValue
{
    return [NSString stringWithFormat:@"%tu",[self.realSum integerValue]];
}

@end
