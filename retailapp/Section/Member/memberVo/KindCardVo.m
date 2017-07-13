//
//  KindCardVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/11.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "KindCardVo.h"

@implementation KindCardVo

+ (KindCardVo*)convertToKindCard:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        KindCardVo* kindCardVo = [[KindCardVo alloc] init];
        kindCardVo.kindCardId = [ObjectUtil getStringValue:dic key:@"kindCardId"];
        kindCardVo.kindCardName = [ObjectUtil getStringValue:dic key:@"kindCardName"];
        kindCardVo.canUpgrade = [ObjectUtil getIntegerValue:dic key:@"canUpgrade"];
        kindCardVo.upKindCardId = [ObjectUtil getStringValue:dic key:@"upKindCardId"];
        kindCardVo.upPoint = [ObjectUtil getIntegerValue:dic key:@"upPoint"];
        kindCardVo.ratioExchangeDegree = [ObjectUtil getDoubleValue:dic key:@"ratioExchangeDegree"];
        kindCardVo.mode = [ObjectUtil getShortValue:dic key:@"mode"];
        kindCardVo.ratio = [ObjectUtil getDoubleValue:dic key:@"ratio"];
        kindCardVo.code = [ObjectUtil getStringValue:dic key:@"code"];
        kindCardVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        kindCardVo.memo = [ObjectUtil getStringValue:dic key:@"memo"];
        
        return kindCardVo;
    }
    return nil;
}

@end
