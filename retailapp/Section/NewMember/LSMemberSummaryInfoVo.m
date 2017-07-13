//
//  LSMemberSummaryInfoVo.m
//  retailapp
//
//  Created by taihangju on 2016/10/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberSummaryInfoVo.h"
#import "Masonry.h"

@implementation LSMemberSummaryInfoVo

- (instancetype)init {
    self = [super init];
    if (self) {
    
        // 这里附上初始值为了使用方法 valueForKeyPath:@"@max.customerNumDay" 获取最大值时崩溃
        self.customerNum = @(0);
        self.freshCardNum = @(0);
        self.cardBalance = @(0.00);
        self.cardNum = @(0.00);
        
        self.date = @"";
        self.customerNumDay = @(0);
        self.custormerOldNumDay = @(0);
        self.customerPayMoneyDay = @(0.00);
        self.rechargeMoneyDay = @(0.00);
        
        self.month = @"";
        self.customerNumMonth = @(0);
        self.customerOldNumMonth = @(0);
        self.customerPayMoneyMonth = @(0.00);
        self.rechargeMoneyMonth = @(0.00);
    }
    return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"freshCardNum":@"newCardNum"};
}

+ (instancetype)getMembberSummaryInfoVo:(NSDictionary *)dict {
    return [self mj_objectWithKeyValues:dict];
}

+ (NSArray *)getMemberSummaryInfoVoList:(NSArray *)keyValuesArray {
    return [self mj_objectArrayWithKeyValuesArray:keyValuesArray];
}
@end
