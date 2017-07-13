//
//  LSGoodsPurchaseVo.m
//  retailapp
//
//  Created by guozhi on 2017/1/13.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSGoodsPurchaseVo.h"
#import "MJExtension.h"

@implementation LSGoodsPurchaseVo

+ (NSArray *)objectArrayFromKeyValueArray:(NSArray *)keyValueArray {
    
    return [[self mj_objectArrayWithKeyValuesArray:keyValueArray] copy];
}
@end
