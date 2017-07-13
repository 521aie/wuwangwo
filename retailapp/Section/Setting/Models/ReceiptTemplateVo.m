//
//  ReceiptTemplateVo.m
//  retailapp
//
//  Created by hm on 15/9/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ReceiptTemplateVo.h"
#import "ObjectUtil.h"

@implementation ReceiptTemplateVo

-(NSString*) obtainItemId
{
    return self.templateCode;
}
-(NSString*) obtainItemName
{
    return self.templateName;
}
-(NSString*) obtainOrignName
{
    return self.templateName;
}

+ (ReceiptTemplateVo*)converToVo:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        ReceiptTemplateVo* vo = [ReceiptTemplateVo new];
        vo.templateName = [ObjectUtil getStringValue:dic key:@"templateName"];
        vo.templateCode = [ObjectUtil getStringValue:dic key:@"templateCode"];
        return vo;
    }
    return nil;
}

+ (NSMutableArray*)converToArr:(NSArray*)sourceList
{
    NSMutableArray* data = [NSMutableArray arrayWithCapacity:sourceList.count];
    if ([ObjectUtil isNotEmpty:sourceList]) {
        for (NSDictionary* dic in sourceList) {
            ReceiptTemplateVo* vo = [ReceiptTemplateVo converToVo:dic];
            [data addObject:vo];
        }
    }
    return data;
}

@end
