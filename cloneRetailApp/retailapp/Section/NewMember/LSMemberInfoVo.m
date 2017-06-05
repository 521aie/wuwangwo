//
//  LSMemberInfoVo.m
//  retailapp
//
//  Created by byAlex on 16/9/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberInfoVo.h"
#import "MJExtension.h"

@implementation LSMemberRegisterVo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"sId" : @"id"};
}

+ (LSMemberRegisterVo *)getMemberRegisterVo:(NSDictionary *)dic {
    
    return [self mj_objectWithKeyValues:dic];
}

@end

@implementation LSMemberInfoVo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"sId" : @"id" ,@"s_Id" : @"_id"};
}

+ (LSMemberInfoVo *)getMemberVo:(NSDictionary *)dic {
    
   return [self mj_objectWithKeyValues:dic];
}

- (NSString *)memberInfoJsonString {
    return [self mj_JSONString];
}

@end

@implementation LSMemberRegisterPojo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"sId" : @"id"};
}

@end


@implementation LSMemberRegisterThirdPartyPojo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"sId" : @"id"};
}
@end


@implementation LSMemberPackVo

+ (LSMemberPackVo *)getMemberPackVo:(NSDictionary *)dic {
    
    return [self mj_objectWithKeyValues:dic];
}

+ (NSArray *)getMemberPackVoList:(NSArray *)array {
    
    return [[self mj_objectArrayWithKeyValuesArray:array] copy];
}

- (NSString *)getMemberPhoneNum {
    
    NSString *mobile = nil;
    if ([NSString isNotBlank:self.customerRegisterThirdPartyPojo.customerRegisterId] && [NSString isNotBlank:self.customerRegisterThirdPartyPojo.sId]) {
        mobile = self.customerRegisterThirdPartyPojo.customerRegisterPojo.mobile?:@"";
    }
    
    if ([NSString isNotBlank:mobile]) {
        return mobile;
    }
    else if ([NSString isNotBlank:self.customer.mobile]) {
        return self.customer.mobile;
    }
    
    return @"";
}
@end
