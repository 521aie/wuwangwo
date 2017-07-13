//
//  LSMemberOrderRecordVo.m
//  retailapp
//
//  Created by taihangju on 16/9/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberOrderRecordVo.h"
#import "Masonry.h"

@implementation LSMemberOrderRecordVo

//+ (LSMemberOrderRecordVo *)getMemberOrderRecordVo:(NSDictionary *)dic {
//    
//    return [self mj_objectWithKeyValues:dic];
//}

+ (NSArray *)getMemberOrderRecordVoList:(NSArray *)array {
    
    return [self mj_objectArrayWithKeyValuesArray:array];
}
@end
