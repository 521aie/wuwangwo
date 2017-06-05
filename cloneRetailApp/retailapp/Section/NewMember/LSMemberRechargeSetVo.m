//
//  LSMemberRechargeSetVo.m
//  retailapp
//
//  Created by taihangju on 16/10/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberRechargeSetVo.h"
#import "MJExtension.h"

@implementation LSMemberRechargeSetVo

+ (NSArray *)getMemberRechargeSetVoList:(NSArray *)array {
    
    return [self mj_objectArrayWithKeyValuesArray:array];
}

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"moneyRules":@"LSMemberRechargeRuleVo"};
}

@end


@implementation LSMemberRechargeRuleVo

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.giftDegree = @(0);
        self.condition = @(0);
        self.rule = @(0.0);
    }
    return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"sId":@"id"};
}

- (NSString *)rechargeRuleVoJsonString {
    
    return self.mj_JSONString;
}

+ (NSArray *)getRechargeRuleVoList:(NSArray *)keyValueArray {
    return [self mj_objectArrayWithKeyValuesArray:keyValueArray];
}
@end
