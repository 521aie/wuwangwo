//
//  GoodsRender.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/5.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsRender.h"
#import "NameItemVO.h"
#import "CategoryVo.h"
#import "AttributeGroupVo.h"
#import "GoodsBrandVo.h"
#import "AttributeValVo.h"
#import "Platform.h"

@implementation GoodsRender

+(NSMutableArray*) listGoodsBrand
{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"唐狮" andId:[NSString stringWithFormat:@"%d",1]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"森马" andId:[NSString stringWithFormat:@"%d",2]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"以纯" andId:[NSString stringWithFormat:@"%d",3]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"美特斯邦威" andId:[NSString stringWithFormat:@"%d",4]];
    [vos addObject:item];
    
    return vos;
}

+(NSMutableArray*) listSex:(BOOL) isShow
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item = nil;
    if (isShow) {
        item=[[NameItemVO alloc] initWithVal:@"全部" andId:@""];
        [vos addObject:item];
    }
    item=[[NameItemVO alloc] initWithVal:@"男" andId:@"1"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"女" andId:@"2"];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"中性" andId:@"3"];
    [vos addObject:item];
    
    return vos;
}

+(NSMutableArray*) listAttributeVal:(NSMutableArray*) attributeValVoList isShow:(BOOL) isShow
{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item = nil;
    
    if (isShow) {
        item=[[NameItemVO alloc] initWithVal:@"全部" andId:@""];
        [vos addObject:item];
    }
    
    if (attributeValVoList != nil && attributeValVoList.count > 0) {
        for (AttributeValVo* vo in attributeValVoList) {
            item=[[NameItemVO alloc] initWithVal:vo.attributeVal andId:vo.attributeValId];
            [vos addObject:item];
        }
    }
    
    return vos;
}

+(NSMutableArray*) listMicroSaleStrategy
{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"与零售价相同" andId:[NSString stringWithFormat:@"%d",1]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"按零售价打折" andId:[NSString stringWithFormat:@"%d",2]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"自定义价格" andId:[NSString stringWithFormat:@"%d",3]];
    [vos addObject:item];
    
    return vos;
}


+(NSMutableArray*) listBatchMicroSaleStrategy
{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"与零售价相同" andId:[NSString stringWithFormat:@"%d",1]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"按零售价打折" andId:[NSString stringWithFormat:@"%d",2]];
    [vos addObject:item];
    
    return vos;
}


+(NSMutableArray*) listMicroSaleType
{
    NSMutableArray* vos=[NSMutableArray array];
    
//    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"统一款式价格（零售价）" andId:[NSString stringWithFormat:@"%d",1]];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"按款式统一价格" andId:[NSString stringWithFormat:@"%d",1]];
    [vos addObject:item];
    
    //item=[[NameItemVO alloc] initWithVal:@"统一SKC价格" andId:[NSString stringWithFormat:@"%d",2]];
    item=[[NameItemVO alloc] initWithVal:@"按颜色统一价格" andId:[NSString stringWithFormat:@"%d",2]];
    [vos addObject:item];
    
    return vos;
}

+(NSMutableArray*) listMicroReduceStockWay
{
    NSMutableArray* vos=[NSMutableArray array];
    
    NameItemVO *item=[[NameItemVO alloc] initWithVal:@"拍下减库存" andId:[NSString stringWithFormat:@"%d",1]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:@"付款减库存" andId:[NSString stringWithFormat:@"%d",2]];
    [vos addObject:item];
    
    return vos;
}

+(NSMutableArray*) listAttributeGroup:(NSMutableArray *)attributeGroupList
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item = nil;
    for (AttributeGroupVo* vo in attributeGroupList) {
        item=[[NameItemVO alloc] initWithVal:vo.attributeGroupName andId:vo.attributeGroupId andSortCode:vo.sortCode];
        [vos addObject:item];
    }
    return vos;
}

+(NSString*) obtainSex:(NSString*)sexId
{
    NSMutableArray *list = [self listSex:YES];
    for (NameItemVO *vo in list) {
        if ([[vo obtainItemId] isEqualToString:sexId]) {
            return [vo obtainItemName];
        }
    }
    return nil;
}

+(NSString*) obtainMicroSaleStrategy:(short)microSaleStrategyId
{
    NSMutableArray *list = [self listMicroSaleStrategy];
    for (NameItemVO *vo in list) {
        if ([vo obtainItemId].intValue == microSaleStrategyId) {
            return [vo obtainItemName];
        }
    }
    return nil;
}

+(NSString*) obtainMicroReduceStockWay:(short)microReduceStockWayId
{
    NSMutableArray *list = [self listMicroReduceStockWay];
    for (NameItemVO *vo in list) {
        if ([vo obtainItemId].intValue == microReduceStockWayId) {
            return [vo obtainItemName];
        }
    }
    return nil;
}

+(NSString*) obtainMicroSaleType:(short)microSaleType{
    NSMutableArray *list = [self listMicroSaleType];
    for (NameItemVO *vo in list) {
        if ([vo obtainItemId].intValue == microSaleType) {
            return [vo obtainItemName];
        }
    }
    return nil;
}


+(AttributeGroupVo*) obtainAttributeGroup:(NSString*)attributeGroupId attributeGroupList:(NSMutableArray *)attributeGroupList
{
    NSMutableArray *list = [self listAttributeGroup:attributeGroupList];
    for (AttributeGroupVo *vo in list) {
        if ([[vo obtainItemId] isEqualToString:attributeGroupId]) {
            return vo;
        }
    }
    return nil;
}

+(NSMutableArray*) listParentCategoryList:(NSMutableArray*) parentCategoryList
{
    NSMutableArray* vos=[NSMutableArray array];
    if (parentCategoryList != nil && parentCategoryList.count > 0) {
        for (CategoryVo* vo in parentCategoryList) {
            NSString *name = nil;
            if (vo.step == 4) {
                name = [NSString stringWithFormat:@"▪︎ ▪︎ ▪︎ %@", vo.name];
            }else if (vo.step == 2){
                name = [NSString stringWithFormat:@"▪︎ %@", vo.name];
            }else if (vo.step == 3){
                name = [NSString stringWithFormat:@"▪︎ ▪︎ %@", vo.name];
            }else{
                name = vo.name;
            }
            NameItemVO *item=[[NameItemVO alloc] initWithVal:name andId:vo.categoryId];
            [vos addObject:item];
        }
    }
    
    return vos;
}

+(NSMutableArray*) listCategoryList:(NSMutableArray*) categoryList isShow:(BOOL) isShow
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item = nil;
    
    if (isShow) {
        item=[[NameItemVO alloc] initWithVal:@"全部" andId:@""];
        [vos addObject:item];
    }
    if (categoryList != nil && categoryList.count > 0) {
        for (CategoryVo* vo in categoryList) {
            NSString *name = vo.name;
//            if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {//服鞋
//                name = vo.microname;
//            } else {
//                name = vo.name;
//            }
            NameItemVO *item=[[NameItemVO alloc] initWithVal:name andId:vo.categoryId];
            [vos addObject:item];
        }
    }
    
    return vos;
}

+(NSMutableArray*) listMicroCategoryList:(NSMutableArray*) categoryList isShow:(BOOL) isShow
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item = nil;
    
    if (isShow) {
        item=[[NameItemVO alloc] initWithVal:@"全部" andId:@""];
        [vos addObject:item];
    }
    if (categoryList != nil && categoryList.count > 0) {
        for (CategoryVo* vo in categoryList) {
            NameItemVO *item=[[NameItemVO alloc] initWithVal:vo.microname andId:vo.categoryId];
            [vos addObject:item];
        }
    }
    
    return vos;
}


+(NSString*) obtainCategoryName:(NSString*) categoryId categoryList:(NSMutableArray*) categoryList
{
    for (CategoryVo* vo in categoryList) {
        if ([vo.categoryId isEqualToString:categoryId]) {
            return vo.name;
        }
    }
    
    return nil;
}

+(NSString*) obtainMicCategoryName:(NSString*) categoryId categoryList:(NSMutableArray*) categoryList
{
    for (CategoryVo* vo in categoryList) {
        if ([vo.categoryId isEqualToString:categoryId]) {
            return vo.microname;
        }
    }
    
    return nil;
}

+(NSString*) obtainAttributeVal:(NSString*) attributeValId attributeValList:(NSMutableArray*) attributeValList
{
    for (AttributeValVo* vo in attributeValList) {
        if ([vo.attributeValId isEqualToString:attributeValId]) {
            return vo.attributeVal;
        }
    }
    
    return nil;
}

+(NSMutableArray*) listBrandList:(NSMutableArray*) brandList
{
    NSMutableArray* vos=[NSMutableArray array];
    if (brandList != nil && brandList.count > 0) {
        for (GoodsBrandVo* vo in brandList) {
            NameItemVO *item=[[NameItemVO alloc] initWithVal:vo.name andId:vo.goodsBrandId];
            [vos addObject:item];
        }
    }
    
    return vos;
}

@end
