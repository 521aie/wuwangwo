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
    
    NSMutableArray *vos = [self mj_objectArrayWithKeyValuesArray:array];
    [vos enumerateObjectsUsingBlock:^(LSMemberRechargeSetVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *ruleVos = obj.moneyRuleList;
        [ruleVos enumerateObjectsUsingBlock:^(LSMemberRechargeRuleVo*  _Nonnull ruleVo, NSUInteger idx, BOOL * _Nonnull stop) {
            ruleVo.condition = @(ruleVo.condition.floatValue/100.0);
            ruleVo.rule = @(ruleVo.rule.floatValue/100.0);
            ruleVo.kindCardName = obj.kindCardName;
        }];
    }];
    return vos;
}

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"moneyRuleList":@"LSMemberRechargeRuleVo"};
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
    NSMutableArray *vos = [self mj_objectArrayWithKeyValuesArray:keyValueArray];
    [vos enumerateObjectsUsingBlock:^(LSMemberRechargeRuleVo*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.condition = @(obj.condition.floatValue/100.0);
        obj.rule = @(obj.rule.floatValue/100.0);
    }];
    return vos;
}
@end
