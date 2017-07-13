//
//  WDRelatedGoodType.m
//  retailapp
//
//  Created by byAlex on 16/7/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "WDRelatedGoodType.h"
#import "MJExtension.h"


@implementation WDRelatedGoodType

+ (NSArray *)getRelatedGoodTypeList:(NSArray *)arr {
    return [WDRelatedGoodType mj_objectArrayWithKeyValuesArray:arr];
}


// INameItem 协议方法
- (NSString *)obtainItemName {
    return self.microname;
}

- (NSString *)obtainItemId {
    return self.categoryId;
}

- (NSString *)obtainOrignName {
    return self.microname;
}

@end
