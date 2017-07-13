//
//  ListStyleVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/10/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ListStyleVo.h"

@implementation ListStyleVo

+(ListStyleVo*)convertToListStyleVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        ListStyleVo* listStyleVo = [[ListStyleVo alloc] init];
        listStyleVo.styleId = [ObjectUtil getStringValue:dic key:@"styleId"];
        listStyleVo.styleName = [ObjectUtil getStringValue:dic key:@"styleName"];
        listStyleVo.styleCode = [ObjectUtil getStringValue:dic key:@"styleCode"];
        listStyleVo.fileName = [ObjectUtil getStringValue:dic key:@"fileName"];
        listStyleVo.filePath = [ObjectUtil getStringValue:dic key:@"filePath"];
        listStyleVo.createTime = [ObjectUtil getLonglongValue:dic key:@"createTime"];
        listStyleVo.upDownStatus = [ObjectUtil getShortValue:dic key:@"upDownStatus"];
        
        return listStyleVo;
    }
    
    return nil;
}

+ (NSDictionary*)converToDic:(ListStyleVo*)vo;
{
    NSMutableDictionary* data=[NSMutableDictionary dictionary];
    if ([ObjectUtil isNotNull:vo]) {
        [ObjectUtil setStringValue:data key:@"styleId" val:vo.styleId];
        [ObjectUtil setStringValue:data key:@"styleName" val:vo.styleName];
        [ObjectUtil setStringValue:data key:@"styleCode" val:vo.styleCode];
        [ObjectUtil setStringValue:data key:@"fileName" val:vo.fileName];
        [ObjectUtil setStringValue:data key:@"filePath" val:vo.filePath];
        [ObjectUtil setStringValue:data key:@"createTime" val:[NSString stringWithFormat:@"%lld",vo.createTime]];
        [ObjectUtil setStringValue:data key:@"isCheck" val:vo.isCheck];
    }
    return data;
}

@end
