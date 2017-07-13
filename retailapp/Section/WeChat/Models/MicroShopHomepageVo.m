//
//  MicroShopHomepageVo.m
//  retailapp
//
//  Created by diwangxie on 16/4/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "MicroShopHomepageVo.h"
#import "MicroShopHomepageDetailVo.h"
#import "MJExtension.h"

@implementation MicroShopHomepageVo


+ (NSMutableArray *)getMicroShopHomepageVos:(NSArray *)arr {
    return [self mj_objectArrayWithKeyValuesArray:arr];
}

+ (MicroShopHomepageVo *)convertToMicroGoodsVo:(NSDictionary *)dic {
    return [self mj_objectWithKeyValues:dic];
}

- (NSDictionary *)convertToDictionary {
    return self.mj_keyValues;
}


+ (NSDictionary *)mj_objectClassInArray {
    return @{@"microShopHomepageDetailVoArr":@"MicroShopHomepageDetailVo"};
}

+ (id)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"microShopHomepageDetailVoArr"]) {
        return @"microShopHomepageDetail";
    }
    return propertyName;
}

@end
