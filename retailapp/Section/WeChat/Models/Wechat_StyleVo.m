//
//  Wechat_StyleVo.m
//  retailapp
//
//  Created by zhangzt on 15/10/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Wechat_StyleVo.h"
#import "ObjectUtil.h"

@implementation Wechat_StyleVo

+(Wechat_StyleVo*)convertToListStyleVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        Wechat_StyleVo* wechatStyleList = [[Wechat_StyleVo alloc] init];
        wechatStyleList.styleId = [ObjectUtil getStringValue:dic key:@"styleId"];
        wechatStyleList.styleName = [ObjectUtil getStringValue:dic key:@"styleName"];
        wechatStyleList.styleCode = [ObjectUtil getStringValue:dic key:@"styleCode"];
//        wechatStyleList.microShelveStatus = [ObjectUtil getStringValue:dic key:@"microShelveStatus"];
        wechatStyleList.filePath = [ObjectUtil getStringValue:dic key:@"filePath"];
        wechatStyleList.createTime = [ObjectUtil getIntegerValue:dic key:@"createTime"];
        wechatStyleList.fileName=[ObjectUtil getStringValue:dic key:@"fileName"];
        return wechatStyleList;
    }
    return nil;
}

+(NSDictionary*)getDictionary:(Wechat_StyleVo*)vo{
    if ([ObjectUtil isNotNull:vo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        
        [ObjectUtil setStringValue:data key:@"styleId" val:vo.styleId];
        [ObjectUtil setStringValue:data key:@"styleName" val:vo.styleName];
        [ObjectUtil setStringValue:data key:@"styleCode" val:vo.styleCode];
//        [ObjectUtil setStringValue:data key:@"microShelveStatus" val:vo.microShelveStatus];
        [ObjectUtil setStringValue:data key:@"filePath" val:vo.filePath];
        [ObjectUtil setIntegerValue:data key:@"createTime" val:vo.createTime];
        [ObjectUtil setStringValue:data key:@"fileName" val:vo.fileName];
        return data;
    }
    return nil;
}
@end
