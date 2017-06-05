//
//  ReceiptStyleVo.m
//  retailapp
//
//  Created by hm on 15/9/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ReceiptStyleVo.h"
#import "ObjectUtil.h"
#import "MJExtension.h"

@implementation ReceiptStyleVo

+ (ReceiptStyleVo *)converToVo:(NSDictionary *)dic {
    
    ReceiptStyleVo *vo = [ReceiptStyleVo mj_objectWithKeyValues:dic];
    // 默认值为2， 标示居中
    if (vo.bottomLocation == 0 || vo.bottomLocation > 3) {
        vo.bottomLocation = 2;
    }
    if (vo.bottomContentList == nil || ![vo.bottomContentList isKindOfClass:[NSArray class]]) {
        vo.bottomContentList = [NSMutableArray arrayWithCapacity:10];
    }
    return vo;
}

- (NSDictionary *)converToDic {
    
    return self.mj_keyValues;
}

@end
