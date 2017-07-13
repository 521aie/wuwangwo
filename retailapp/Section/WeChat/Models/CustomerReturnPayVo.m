//
//  CustomerReturnPayVo.m
//  retailapp
//
//  Created by diwangxie on 16/5/13.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "CustomerReturnPayVo.h"
#import "ObjectUtil.h"

@implementation CustomerReturnPayVo
+(CustomerReturnPayVo *)convertToCustomerReturnPayVo:(NSDictionary*)dic{
    if ([ObjectUtil isNotEmpty:dic]) {
        CustomerReturnPayVo *vo=[[CustomerReturnPayVo alloc] init];
        vo.payType=[ObjectUtil getShortValue:dic key:@"payType"];
        vo.payTypeName=[ObjectUtil getStringValue:dic key:@"payTypeName"];
        vo.payAccount=[ObjectUtil getStringValue:dic key:@"payAccount"];
        vo.bankProvince=[ObjectUtil getStringValue:dic key:@"bankProvince"];
        vo.bankCity=[ObjectUtil getStringValue:dic key:@"bankCity"];
        vo.accountName=[ObjectUtil getStringValue:dic key:@"accountName"];
        vo.bankName=[ObjectUtil getStringValue:dic key:@"bankName"];
        vo.branchName=[ObjectUtil getStringValue:dic key:@"branchName"];
        return vo;
    }
    return nil;
}

+(NSDictionary*)getDictionaryData:(CustomerReturnPayVo *)customerReturnPayVo{
    if ([ObjectUtil isNotNull:customerReturnPayVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setShortValue:data key:@"payType" val:customerReturnPayVo.payType];
        [ObjectUtil setStringValue:data key:@"payTypeName" val:customerReturnPayVo.payTypeName];
        [ObjectUtil setStringValue:data key:@"payAccount" val:customerReturnPayVo.payAccount];
        
        [ObjectUtil setStringValue:data key:@"bankProvince" val:customerReturnPayVo.bankProvince];
        [ObjectUtil setStringValue:data key:@"bankCity" val:customerReturnPayVo.bankCity];
        
        [ObjectUtil setStringValue:data key:@"accountName" val:customerReturnPayVo.accountName];
        [ObjectUtil setStringValue:data key:@"bankName" val:customerReturnPayVo.bankName];
        [ObjectUtil setStringValue:data key:@"branchName" val:customerReturnPayVo.branchName];
        return data;
    }
    return nil;
}
@end
