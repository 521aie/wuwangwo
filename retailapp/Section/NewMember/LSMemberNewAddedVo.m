//
//  LSMemberNewAddedVo.m
//  retailapp
//
//  Created by taihangju on 2016/11/9.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberNewAddedVo.h"
#import "MJExtension.h"

@implementation LSMemberNewAddedVo

+ (NSArray *)memberNewAddedVoList:(NSArray *)keyValuesArray {
    return [self mj_objectArrayWithKeyValuesArray:keyValuesArray];
}

@end
