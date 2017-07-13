//
//  ShopType.m
//  retailapp
//
//  Created by hm on 15/9/18.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopType.h"
#import "ObjectUtil.h"

@implementation ShopType
+ (ShopType*)converToVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        ShopType* shopType = [[ShopType alloc] init];
        shopType.name = [ObjectUtil getStringValue:dic key:@"name"];
        shopType.val = [ObjectUtil getIntegerValue:dic key:@"val"];
        return shopType;
    }
    return nil;
}

+ (NSMutableArray*)converToArr:(NSArray*)sourceList
{
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:sourceList.count];
    if ([ObjectUtil isNotEmpty:sourceList]) {
        for (NSDictionary* dic in sourceList) {
            ShopType* shopType = [ShopType converToVo:dic];
            [arr addObject:shopType];
        }
    }
    return arr;
}

-(NSString*) obtainItemId
{
    return [NSString stringWithFormat:@"%tu",self.val];
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
