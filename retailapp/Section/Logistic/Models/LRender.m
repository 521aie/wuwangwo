//
//  LRender.m
//  retailapp
//
//  Created by hm on 15/7/27.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LRender.h"
#import "NameItemVO.h"

@implementation LRender

+(NSMutableArray*) listCondition
{
    NSMutableArray* vos = [NSMutableArray arrayWithCapacity:2];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"数量" andId:@"0"];
    [vos addObject:item];
    item = [[NameItemVO alloc] initWithVal:@"单价" andId:@"1"];
    [vos addObject:item];
    return vos;
}

+(NSMutableArray*)listOrderStatus
{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"全部" andId:@"0"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"未提交" andId:@"4"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"待确认" andId:@"1"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"已确认" andId:@"2"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"已拒绝" andId:@"3"];
    [vos addObject:item];

    return vos;
}

+(NSMutableArray*)listClientOrderStatus
{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"全部" andId:@"0"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"待确认" andId:@"1"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"已确认" andId:@"2"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"已拒绝" andId:@"3"];
    [vos addObject:item];
    
    return vos;
}

+(NSMutableArray*)listStockInStatus
{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"全部" andId:@"0"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"未提交" andId:@"4"];
    [vos addObject:item];
    
    if ([[Platform Instance] getShopMode] == 1) {
        
        item=[[NameItemVO alloc] initWithVal:@"已收货" andId:@"2"];
        [vos addObject:item];
        
        // 商超单店没有该项
        if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == CLOTHESHOES_MODE) {
            item=[[NameItemVO alloc] initWithVal:@"已拒绝" andId:@"3"];
            [vos addObject:item];
        }
        
    }else{
    
        item=[[NameItemVO alloc] initWithVal:@"配送中" andId:@"1"];
        [vos addObject:item];
        
        item=[[NameItemVO alloc] initWithVal:@"已收货" andId:@"2"];
        [vos addObject:item];
        
        item=[[NameItemVO alloc] initWithVal:@"已拒绝" andId:@"3"];
        [vos addObject:item];
    }
    
    return vos;
}

+(NSMutableArray*)listReturnStatus
{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"全部" andId:@"0"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"未提交" andId:@"4"];
    [vos addObject:item];
    
    if ([[Platform Instance] getShopMode]==1) {
        
        item=[[NameItemVO alloc] initWithVal:@"已退货" andId:@"2"];
        [vos addObject:item];
        
    }else{
    
        item=[[NameItemVO alloc] initWithVal:@"待确认" andId:@"1"];
        [vos addObject:item];
        
        item=[[NameItemVO alloc] initWithVal:@"已退货" andId:@"2"];
        [vos addObject:item];
        
        item=[[NameItemVO alloc] initWithVal:@"已拒绝" andId:@"3"];
        [vos addObject:item];
    }
    
    return vos;
}

+(NSMutableArray*)listClientReturnStatus
{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"全部" andId:@"0"];
    [vos addObject:item];

    item=[[NameItemVO alloc] initWithVal:@"待确认" andId:@"1"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"已退货" andId:@"2"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"已拒绝" andId:@"3"];
    [vos addObject:item];
    
    return vos;
}

+(NSMutableArray*)listAllocateStatus
{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"全部" andId:@"0"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"未提交" andId:@"5"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"待确认" andId:@"4"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"调拨中" andId:@"1"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"已收货" andId:@"2"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"已拒绝" andId:@"3"];
    [vos addObject:item];
    
    return vos;
}

+(NSMutableArray*)listPackBoxStatus
{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"全部" andId:@"0"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"已装箱" andId:@"1"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"待发货" andId:@"2"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"已发货" andId:@"3"];
    [vos addObject:item];
    
    return vos;
}

+(NSMutableArray*)listPaperType
{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"全部" andId:@""];
    [vos addObject:item];
    if ([[Platform Instance] getShopMode]==1) {
        item=[[NameItemVO alloc] initWithVal:@"收货单" andId:@"1"];
        [vos addObject:item];
        
        item=[[NameItemVO alloc] initWithVal:@"退货单" andId:@"2"];
        [vos addObject:item];
        
    }else{
    
        if ([[[Platform Instance] getkey:SHOP_MODE] integerValue]==CLOTHESHOES_MODE) {
            item=[[NameItemVO alloc] initWithVal:@"采购单" andId:@"3"];
        }else{
            item=[[NameItemVO alloc] initWithVal:@"叫货单" andId:@"3"];
        }
        [vos addObject:item];
        
        item=[[NameItemVO alloc] initWithVal:@"收货单" andId:@"1"];
        [vos addObject:item];
        
        item=[[NameItemVO alloc] initWithVal:@"退货单" andId:@"2"];
        [vos addObject:item];
        
        item=[[NameItemVO alloc] initWithVal:@"调拨单" andId:@"4"];
        [vos addObject:item];
    }

    return vos;
}

+(NSMutableArray*)listDate
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"今天" andId:@"0"];
    [vos addObject:item];
    item=[[NameItemVO alloc] initWithVal:@"昨天" andId:@"1"];
    [vos addObject:item];
    item=[[NameItemVO alloc] initWithVal:@"最近三天" andId:@"2"];
    [vos addObject:item];
    item=[[NameItemVO alloc] initWithVal:@"本周" andId:@"3"];
    [vos addObject:item];
    item=[[NameItemVO alloc] initWithVal:@"本月" andId:@"4"];
    [vos addObject:item];
    item=[[NameItemVO alloc] initWithVal:@"自定义" andId:@"5"];
    [vos addObject:item];
    return vos;
}

+(NSMutableArray*)listSupplierType
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"内部供应商" andId:@"self"];
    [vos addObject:item];
    item=[[NameItemVO alloc] initWithVal:@"外部供应商" andId:@"third"];
    [vos addObject:item];
    return vos;
}
@end
