//
//  MarketRender.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MarketRender.h"
#import "NameItemVO.h"

@implementation MarketRender

+(NSMutableArray*) listSaleScheme
{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"设置折扣率" andId:[NSString stringWithFormat:@"%d",1]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"设置特价" andId:[NSString stringWithFormat:@"%d",2]];
    [vos addObject:item];
    
    return vos;
}

+(NSMutableArray*) listShopPriceScheme
{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"在零售价基础上打折" andId:[NSString stringWithFormat:@"%d",1]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"在吊牌价基础上打折" andId:[NSString stringWithFormat:@"%d",2]];
    [vos addObject:item];
    
    return vos;
}

+(NSMutableArray*) listBirShopPriceScheme:(BOOL) isShow
{
    //isShow为true时，为服鞋模式；isShow为false时，为商超模式
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item= nil;
    
    if (isShow) {
        item=[[NameItemVO alloc] initWithVal:@"在吊牌价基础上打折" andId:[NSString stringWithFormat:@"%d",2]];
        [vos addObject:item];
    }
    
    item=[[NameItemVO alloc] initWithVal:@"在零售价基础上打折" andId:[NSString stringWithFormat:@"%d",1]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"在会员价基础上打折" andId:[NSString stringWithFormat:@"%d",3]];
    [vos addObject:item];
    
    return vos;
}

+(NSMutableArray*) listBirDate
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item= nil;
    for (int count = 0; count < 8; count ++) {
        item=[[NameItemVO alloc] initWithVal:[NSString stringWithFormat:@"%d天",count] andId:[NSString stringWithFormat:@"%d",count]];
        [vos addObject:item];
    }
    
    return vos;
}

+(NSMutableArray*) listWeixinPriceScheme
{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"在微店价基础上打折" andId:[NSString stringWithFormat:@"%d",1]];
    [vos addObject:item];
    
    return vos;
}

+(NSMutableArray*) listGroupType
{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"任意购买" andId:[NSString stringWithFormat:@"%d",1]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"必须购买同款" andId:[NSString stringWithFormat:@"%d",2]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"必须购买不同款" andId:[NSString stringWithFormat:@"%d",3]];
    [vos addObject:item];
    
    return vos;
}

+(NSMutableArray*) listUsedArea
{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"全部" andId:@"1"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"适用实体门店" andId:@"2"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"适用微店" andId:@"3"];
    [vos addObject:item];
    
    return vos;
}

+(NSString*) obtainGroupType:(short)groupTyp
{
    NSMutableArray *list = [self listGroupType];
    for (NameItemVO *vo in list) {
        if (vo.itemId.intValue == groupTyp) {
            return vo.itemName;
        }
    }
    return nil;
}

+(NSString*) obtainWeixinPriceScheme:(short)weixinPriceScheme
{
    NSMutableArray *list = [self listWeixinPriceScheme];
    for (NameItemVO *vo in list) {
        if (vo.itemId.intValue == weixinPriceScheme) {
            return vo.itemName;
        }
    }
    return nil;
}


+(NSString*) obtainSaleScheme:(short)saleSchemeId
{
    NSMutableArray *list = [self listSaleScheme];
    for (NameItemVO *vo in list) {
        if (vo.itemId.intValue == saleSchemeId) {
            return vo.itemName;
        }
    }
    return nil;
}

+(NSString*) obtainShopPriceScheme:(short)shopPriceScheme
{
    NSMutableArray *list = [self listShopPriceScheme];
    for (NameItemVO *vo in list) {
        if (vo.itemId.intValue == shopPriceScheme) {
            return vo.itemName;
        }
    }
    return nil;
}

+(NSString*) obtainBirShopPriceScheme:(short)shopPriceScheme isShow:(BOOL) isShow
{
    NSMutableArray *list = [self listBirShopPriceScheme:isShow];
    for (NameItemVO *vo in list) {
        if (vo.itemId.intValue == shopPriceScheme) {
            return vo.itemName;
        }
    }
    return nil;
}

@end
