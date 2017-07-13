//
//  SetRender.m
//  retailapp
//
//  Created by hm on 15/8/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SetRender.h"
#import "NameItemVO.h"

@implementation SetRender

+ (NSMutableArray*)listZero
{
    NSMutableArray* vos = [NSMutableArray arrayWithCapacity:5];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"不抹零" andId:@"0"];
    [vos addObject:item];
    item = [[NameItemVO alloc] initWithVal:@"抹掉分" andId:@"1"];
    [vos addObject:item];
    item = [[NameItemVO alloc] initWithVal:@"抹掉角" andId:@"2"];
    [vos addObject:item];
    item = [[NameItemVO alloc] initWithVal:@"四舍五入到角" andId:@"3"];
    [vos addObject:item];
    item = [[NameItemVO alloc] initWithVal:@"四舍五入到元" andId:@"4"];
    [vos addObject:item];
    return vos;
}

+ (NSMutableArray*)listPayWay
{
    NSMutableArray* vos = [NSMutableArray arrayWithCapacity:7];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"现金" andId:@"0"];
    [vos addObject:item];
    item = [[NameItemVO alloc] initWithVal:@"支付宝" andId:@"1"];
    [vos addObject:item];
    item = [[NameItemVO alloc] initWithVal:@"会员卡" andId:@"2"];
    [vos addObject:item];
    item = [[NameItemVO alloc] initWithVal:@"优惠券" andId:@"3"];
    [vos addObject:item];
    item = [[NameItemVO alloc] initWithVal:@"银行卡" andId:@"4"];
    [vos addObject:item];
    item = [[NameItemVO alloc] initWithVal:@"微支付" andId:@"5"];
    [vos addObject:item];
    item = [[NameItemVO alloc] initWithVal:@"其他" andId:@"6"];
    [vos addObject:item];
    return vos;
}

+ (NSMutableArray*)listOrgType
{
    NSMutableArray* vos = [NSMutableArray arrayWithCapacity:7];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"公司" andId:@"0"];
    [vos addObject:item];
    item=[[NameItemVO alloc] initWithVal:@"部门" andId:@"1"];
    [vos addObject:item];
    item=[[NameItemVO alloc] initWithVal:@"门店" andId:@"2"];
    [vos addObject:item];
    return vos;
}

+ (NSMutableArray*)listSync
{
    NSMutableArray* vos = [NSMutableArray arrayWithCapacity:7];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"同步所有" andId:@"0"];
    [vos addObject:item];
    item=[[NameItemVO alloc] initWithVal:@"不同步" andId:@"1"];
    [vos addObject:item];
    return vos;
}

@end
