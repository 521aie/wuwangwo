//
//  CustomerVo.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/14.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "CustomerVo.h"
#import "ObjectUtil.h"

@implementation CustomerVo

+(id) card_class{
    return NSClassFromString(@"CardVo");
}

+ (CustomerVo*)convertToCustomer:(NSDictionary*)dic
{
    if ([ObjectUtil isNotEmpty:dic]) {
        CustomerVo* customerVo = [[CustomerVo alloc] init];
        customerVo.customerId = [ObjectUtil getStringValue:dic key:@"customerId"];
        customerVo.name = [ObjectUtil getStringValue:dic key:@"name"];
        customerVo.sex = [ObjectUtil getIntegerValue:dic key:@"sex"];
        customerVo.mobile = [ObjectUtil getStringValue:dic key:@"mobile"];
        customerVo.certificate = [ObjectUtil getStringValue:dic key:@"certificate"];
        customerVo.birthday = [ObjectUtil getNumberValue:dic key:@"birthday"];
        customerVo.weixin = [ObjectUtil getStringValue:dic key:@"weixin"];
        customerVo.address = [ObjectUtil getStringValue:dic key:@"address"];
        customerVo.email = [ObjectUtil getStringValue:dic key:@"email"];
        customerVo.zipcode = [ObjectUtil getStringValue:dic key:@"zipcode"];
        customerVo.job = [ObjectUtil getStringValue:dic key:@"job"];
        customerVo.memo = [ObjectUtil getStringValue:dic key:@"memo"];
        customerVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        customerVo.fileName = [ObjectUtil getStringValue:dic key:@"fileName"];
        customerVo.fileOperate = [ObjectUtil getShortValue:dic key:@"fileOperate"];
        customerVo.file = [ObjectUtil getStringValue:dic key:@"file"];
        customerVo.card = [CardVo convertToCard:[dic objectForKey:@"card"]];
        customerVo.giftbalance = [ObjectUtil getDoubleValue:dic key:@"giftbalance"];
        customerVo.company = [ObjectUtil getStringValue:dic key:@"company"];
        customerVo.pos = [ObjectUtil getStringValue:dic key:@"pos"];
        customerVo.licenseplateno = [ObjectUtil getStringValue:dic key:@"licenseplateno"];
        customerVo.cardCode = [ObjectUtil getStringValue:dic key:@"cardCode"];
        customerVo.pwd = [ObjectUtil getStringValue:dic key:@"pwd"];
        
        return customerVo;
    }
    return nil;
}

+ (NSDictionary*)getDictionaryData:(CustomerVo*)customerVo
{
    if ([ObjectUtil isNotNull:customerVo]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionary];
        [ObjectUtil setStringValue:data key:@"customerId" val:customerVo.customerId];
        [ObjectUtil setStringValue:data key:@"name" val:customerVo.name];
        [ObjectUtil setIntegerValue:data key:@"sex" val:customerVo.sex];
        [ObjectUtil setStringValue:data key:@"mobile" val:customerVo.mobile];
        [ObjectUtil setStringValue:data key:@"certificate" val:customerVo.certificate];
        if (customerVo.birthday != nil) {
            [ObjectUtil setNumberValue:data key:@"birthday" val:customerVo.birthday];
        } else {
            [data setValue:customerVo.birthday forKey:@"birthday"];
        }
        [ObjectUtil setStringValue:data key:@"weixin" val:customerVo.weixin];
        [ObjectUtil setStringValue:data key:@"address" val:customerVo.address];
        [ObjectUtil setStringValue:data key:@"email" val:customerVo.email];
        [ObjectUtil setStringValue:data key:@"zipcode" val:customerVo.zipcode];
        [ObjectUtil setStringValue:data key:@"job" val:customerVo.job];
        [ObjectUtil setStringValue:data key:@"memo" val:customerVo.memo];
        [ObjectUtil setIntegerValue:data key:@"lastVer" val:customerVo.lastVer];
        [ObjectUtil setStringValue:data key:@"fileName" val:customerVo.fileName];
        [ObjectUtil setShortValue:data key:@"fileOperate" val:customerVo.fileOperate];
        [ObjectUtil setStringValue:data key:@"file" val:customerVo.file];
        [data setObject:[CardVo getDictionaryData:customerVo.card] forKey:@"card"];
        [ObjectUtil setDoubleValue:data key:@"giftbalance" val:customerVo.giftbalance];
        [ObjectUtil setStringValue:data key:@"company" val:customerVo.company];
        [ObjectUtil setStringValue:data key:@"pos" val:customerVo.pos];
        [ObjectUtil setStringValue:data key:@"licenseplateno" val:customerVo.licenseplateno];
        [ObjectUtil setStringValue:data key:@"cardCode" val:customerVo.cardCode];
        [ObjectUtil setStringValue:data key:@"pwd" val:customerVo.pwd];

        
        return data;
    }
    return nil;
}

@end
