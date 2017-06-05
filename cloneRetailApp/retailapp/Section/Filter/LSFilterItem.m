//
//  LSFilterItem.m
//  retailapp
//
//  Created by guozhi on 2016/10/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSFilterItem.h"

@implementation LSFilterItem
+ (instancetype)filterItem:(NSString *)itemName itemId:(NSString *)itemId {
    LSFilterItem *item = [[LSFilterItem alloc] init];
    item.itemName = itemName;
    item.itemId = itemId;
    return item;
}
@end
