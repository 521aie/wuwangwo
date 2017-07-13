//
//  LSSuppilerPurchaseVo.m
//  retailapp
//
//  Created by wuwangwo on 2017/2/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSuppilerPurchaseVo.h"
#import "MJExtension.h"

@implementation LSSuppilerPurchaseVo

+ (NSArray *)objectArrayFromKeyValueArray:(NSArray *)keyValueArray {
   return [[self mj_objectArrayWithKeyValuesArray:keyValueArray] copy];
}
@end
