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
    
    if ([NSString isNotBlank:_mobile]) {
        return _mobile;
    }
    
    if ([NSString isNotBlank:_customer.mobile]) {
        return _customer.mobile;
    }
    
    
    if ([NSString isNotBlank:_customer.phone]) {
        return _customer.phone;
    }
    
    return @"-";
}

- (NSString *)customerId {
    
    if ([NSString isNotBlank:_customer.sId]) {
        return _customer.sId;
    }
    
    if ([NSString isNotBlank:_customerId]) {
        return _customerId;
    }
    return @"";
}

@end
