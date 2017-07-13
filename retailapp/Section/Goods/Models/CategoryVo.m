//
//  CategoryVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/27.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "CategoryVo.h"

@implementation CategoryVo

+(id) categoryVoList_class{
    return NSClassFromString(@"CategoryVo");
}

+(CategoryVo*)convertToCategoryVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        CategoryVo* categoryVo = [[CategoryVo alloc] init];
        categoryVo.categoryId = [ObjectUtil getStringValue:dic key:@"categoryId"];
        categoryVo.code = [ObjectUtil getStringValue:dic key:@"code"];
        categoryVo.sortCode = [ObjectUtil getShortValue:dic key:@"sortCode"];
        categoryVo.name = [ObjectUtil getStringValue:dic key:@"name"];
        categoryVo.microname = [ObjectUtil getStringValue:dic key:@"microname"];
        categoryVo.spell = [ObjectUtil getStringValue:dic key:@"spell"];
        categoryVo.parentName = [ObjectUtil getStringValue:dic key:@"parentName"];
        categoryVo.memo = [ObjectUtil getStringValue:dic key:@"memo"];
        categoryVo.hasGoods = [ObjectUtil getStringValue:dic key:@"hasGoods"];
        categoryVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        categoryVo.goodsSum = [ObjectUtil getIntegerValue:dic key:@"goodsSum"];
        
        return categoryVo;
    }
    
    return nil;
}

+ (NSMutableArray *)converToArr:(NSArray*)sourceList
{
    if ([ObjectUtil isNotEmpty:sourceList]) {
        NSMutableArray *datas = [NSMutableArray arrayWithCapacity:sourceList.count];
        for (NSDictionary *dic in sourceList) {
            CategoryVo *vo =[CategoryVo convertToCategoryVo:dic];
            [datas addObject:vo];
        }
        return datas;
    }
    return [NSMutableArray array];
}

-(NSString*) obtainItemId
{
    return self.categoryId;
}
-(NSString*) obtainItemName
{
    return self.name;
}
-(NSString*) obtainOrignName
{
    return self.name;
}

@end
