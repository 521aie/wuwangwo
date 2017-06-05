//
//  SRender.m
//  retailapp
//
//  Created by hm on 15/10/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SRender.h"
#import "NameItemVO.h"

@implementation SRender
+ (NSMutableArray *)listStockAdjustStatus
{
    NSMutableArray* vos = [NSMutableArray arrayWithCapacity:5];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"全部" andId:@"0"];
    [vos addObject:item];
    if ([[Platform Instance] getShopMode]==1) {
        item = [[NameItemVO alloc] initWithVal:@"未提交" andId:@"1"];
        [vos addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"已调整" andId:@"3"];
        [vos addObject:item];
    }else{
        item = [[NameItemVO alloc] initWithVal:@"未提交" andId:@"1"];
        [vos addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"待确认" andId:@"2"];
        [vos addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"已调整" andId:@"3"];
        [vos addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"已拒绝" andId:@"4"];
        [vos addObject:item];
    }
    return vos;
}

+ (NSMutableArray *)listSex
{
    NSMutableArray* vos = [NSMutableArray arrayWithCapacity:5];
    
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"全部" andId:@""];
    [vos addObject:item];
    item=[[NameItemVO alloc] initWithVal:@"男" andId:@"1"];
    [vos addObject:item];
    item=[[NameItemVO alloc] initWithVal:@"女" andId:@"2"];
    [vos addObject:item];
    item=[[NameItemVO alloc] initWithVal:@"中性" andId:@"3"];
    [vos addObject:item];
    
    return vos;

}

@end
