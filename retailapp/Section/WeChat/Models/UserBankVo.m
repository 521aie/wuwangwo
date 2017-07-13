//
//  UserBankVo.m
//  retailapp
//
//  Created by Jianyong Duan on 16/1/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "UserBankVo.h"

@implementation UserBankVo

+ (UserBankVo*)converToVo:(NSDictionary*)dic
{
    UserBankVo *bank = [[UserBankVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        bank.userBankId = [ObjectUtil getIntegerValue:dic key:@"userBankId"];
        bank.entityId = [ObjectUtil getStringValue:dic key:@"entityId"];
        bank.userId = [ObjectUtil getStringValue:dic key:@"userId"];
        bank.userType = [ObjectUtil getShortValue:dic key:@"userType"];
        bank.bankName = [ObjectUtil getStringValue:dic key:@"bankName"];
        bank.accountName = [ObjectUtil getStringValue:dic key:@"accountName"];
        bank.accountNumber = [ObjectUtil getStringValue:dic key:@"accountNumber"];
        bank.provinceId = [ObjectUtil getStringValue:dic key:@"provinceId"];
        bank.cityId = [ObjectUtil getStringValue:dic key:@"cityId"];
        bank.branchName = [ObjectUtil getStringValue:dic key:@"branchName"];
        bank.createTime = [ObjectUtil getLonglongValue:dic key:@"createTime"];
        bank.opTime = [ObjectUtil getLonglongValue:dic key:@"opTime"];
        bank.isValid = [ObjectUtil getShortValue:dic key:@"isValid"];
        bank.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        bank.opUserId = [ObjectUtil getStringValue:dic key:@"opUserId"];
        bank.lastFourNum = [ObjectUtil getStringValue:dic key:@"lastFourNum"];
    }
    
    return bank;
}

+ (NSMutableArray*)converToArr:(NSArray*)sourceList
{
    if ([ObjectUtil isEmpty:sourceList]) {
        return nil;
    }
    NSMutableArray* dataList = [NSMutableArray arrayWithCapacity:sourceList.count];
    if ([ObjectUtil isNotEmpty:sourceList]) {
        for (NSDictionary* dic in sourceList) {
            UserBankVo* bank = [UserBankVo converToVo:dic];
            [dataList addObject:bank];
        }
    }
    return dataList;
}

- (NSString *)userBankIdString {
    return [NSString stringWithFormat:@"%ld", self.userBankId];
}

@end
