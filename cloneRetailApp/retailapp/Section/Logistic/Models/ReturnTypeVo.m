//
//  ReturnTypeVo.m
//  retailapp
//
//  Created by hm on 16/2/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ReturnTypeVo.h"

@implementation ReturnTypeVo
- (instancetype)initWithDictionary:(NSDictionary *)json {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:json];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (NSMutableArray *)converToArr:(NSArray *)sourceList
{
    if ([ObjectUtil isNotEmpty:sourceList]) {
        NSMutableArray *datas = [NSMutableArray arrayWithCapacity:sourceList.count];
        for (NSDictionary *dic in sourceList) {
            ReturnTypeVo *vo = [[ReturnTypeVo alloc] initWithDictionary:dic];
            [datas addObject:vo];
        }
        return datas;
    }
    return [NSMutableArray array];
}

-(NSString*) obtainItemId
{
    return [self.val stringValue];
}
-(NSString*) obtainItemName
{
    return self.name;
}
-(NSString*) obtainItemValue
{
    return [self.val stringValue];
}

- (void)mItemName:(NSString *)name
{
    self.name = name;
}

-(NSString*) obtainOrignName
{
    return self.name;
}

@end
