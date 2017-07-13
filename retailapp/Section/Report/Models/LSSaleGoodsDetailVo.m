//
//  LSSaleGoodsDetailVo.m
//  retailapp
//
//  Created by taihangju on 2016/12/5.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSaleGoodsDetailVo.h"
#import "MJExtension.h"

@implementation LSSaleGoodsDetailVo

+ (NSArray *)saleGoodsDetailVoList:(NSArray *)keyValuesArray {
    return [self mj_objectArrayWithKeyValuesArray:keyValuesArray];
}
@end
