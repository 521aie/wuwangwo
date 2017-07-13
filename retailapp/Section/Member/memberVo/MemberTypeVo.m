//
//  MemberTypeVo.m
//  RestApp
//
//  Created by zhangzhiliang on 15/6/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//
#import "MemberTypeVo.h"

@implementation MemberTypeVo

-(NSString*) obtainItemValue
{
    return self.cardTypeDiscount;
}

-(NSString*)obtainItemId
{
    return [NSString stringWithFormat:@"%d", self.priceSchemeId];
}

-(NSString*) obtainItemName
{
    return self.priceScheme;
    
}

-(NSString*) obtainOrignName
{
    return self.priceScheme;
    
}

@end