//
//  MenuList.m
//  retailapp
//
//  Created by 果汁 on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuList.h"
#import "NameItemVO.h"
#import "MenuListCell.h"
@implementation MenuList
+ (NSMutableArray *)listFromArray:(NSArray *)array {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (MenuListCell *cell in array) {
        NameItemVO *item = [[NameItemVO alloc] initWithVal:cell.name andId:cell.val];
        [arr addObject:item];
    }
    return arr;
}
+ (NSMutableArray *)list1FromArray:(NSArray *)array {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    int count = 0;
    for (NSString *str in array) {
        NameItemVO *item = [[NameItemVO alloc] initWithVal:str andId:[NSString stringWithFormat:@"%d",count]];
        [arr addObject:item];
        count ++;
    }
    return arr;
}
+ (NSMutableArray *)list2FromArray:(NSArray *)array{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    int count = 1;
    for (NSString *str in array) {
        NameItemVO *item = [[NameItemVO alloc] initWithVal:str andId:[NSString stringWithFormat:@"%d",count]];
        [arr addObject:item];
        count ++;
    }
    return arr;
}
@end
