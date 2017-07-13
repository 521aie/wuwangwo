//
//  MenuList.h
//  retailapp
//
//  Created by 果汁 on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuList : NSObject
+ (NSMutableArray *)listFromArray:(NSArray *)array;
+ (NSMutableArray *)list1FromArray:(NSArray *)array;//itemid 从0开始
+ (NSMutableArray *)list2FromArray:(NSArray *)array;//itemid 从1开始
@end
