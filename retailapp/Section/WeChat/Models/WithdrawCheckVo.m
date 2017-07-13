//
//  WithdrawCheckVo.m
//  retailapp
//
//  Created by Jianyong Duan on 16/3/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "WithdrawCheckVo.h"
#import "ImageVo.h"

@implementation WithdrawCheckVo

+ (WithdrawCheckVo*)converToVo:(NSDictionary*)dic
{
    WithdrawCheckVo *checkVo = [[WithdrawCheckVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic]) {
        
        checkVo.withdrawCheckId = [ObjectUtil getIntegerValue:dic key:@"withdrawCheckId"];
        checkVo.entityId = [ObjectUtil getStringValue:dic key:@"entityId"];
        checkVo.proposerId = [ObjectUtil getStringValue:dic key:@"proposerId"];
        checkVo.proposerType = [ObjectUtil getShortValue:dic key:@"proposerType"];
        checkVo.parentId = [ObjectUtil getIntegerValue:dic key:@"parentId"];
        checkVo.action = [ObjectUtil getShortValue:dic key:@"action"];
        checkVo.checkResult = [ObjectUtil getShortValue:dic key:@"checkResult"];
        checkVo.actionAmount = [ObjectUtil getDoubleValue:dic key:@"actionAmount"];
        checkVo.isValid = [ObjectUtil getShortValue:dic key:@"isValid"];
        checkVo.createTime = [ObjectUtil getLonglongValue:dic key:@"createTime"];
        checkVo.opTime = [ObjectUtil getLonglongValue:dic key:@"opTime"];
        checkVo.lastVer = [ObjectUtil getIntegerValue:dic key:@"lastVer"];
        checkVo.opUserId = [ObjectUtil getStringValue:dic key:@"opUserId"];
        checkVo.checkUserId = [ObjectUtil getStringValue:dic key:@"checkUserId"];
        checkVo.withdrawalType = [ObjectUtil getStringValue:dic key:@"withdrawalType"];
        checkVo.bankName = [ObjectUtil getStringValue:dic key:@"bankName"];
        checkVo.accountName = [ObjectUtil getStringValue:dic key:@"accountName"];
        checkVo.accountNumber = [ObjectUtil getStringValue:dic key:@"accountNumber"];
        checkVo.opUserName = [ObjectUtil getStringValue:dic key:@"opUserName"];
        checkVo.checkUserName = [ObjectUtil getStringValue:dic key:@"checkUserName"];
        checkVo.refuseReason = [ObjectUtil getStringValue:dic key:@"refuseReason"];
        checkVo.userId = [ObjectUtil getStringValue:dic key:@"userId"];
        checkVo.userName = [ObjectUtil getStringValue:dic key:@"userName"];
        checkVo.mobile = [ObjectUtil getStringValue:dic key:@"mobile"];
        checkVo.mobileFour = [ObjectUtil getStringValue:dic key:@"mobileFour"];
        checkVo.imageList = [ImageVo converToArr:dic[@"imageList"]];
        checkVo.certificateId = [ObjectUtil getStringValue:dic key:@"certificateId"];
        checkVo.identityTypeId = [ObjectUtil getIntegerValue:dic key:@"identityTypeId"];
        
        checkVo.lastFourNum = [ObjectUtil getStringValue:dic key:@"lastFourNum"];
        if ([NSString isBlank:checkVo.lastFourNum]) {
            if (checkVo.accountNumber.length > 4) {
                checkVo.lastFourNum = [checkVo.accountNumber substringFromIndex:checkVo.accountNumber.length - 4];
            }
        }
    }
    
    return checkVo;
}

+ (NSMutableArray*)converToArr:(NSArray*)sourceList
{
    if ([ObjectUtil isEmpty:sourceList]) {
        return nil;
    }
    NSMutableArray* dataList = [NSMutableArray arrayWithCapacity:sourceList.count];
    if ([ObjectUtil isNotEmpty:sourceList]) {
        for (NSDictionary* dic in sourceList) {
            WithdrawCheckVo *checkVo = [WithdrawCheckVo converToVo:dic];
            [dataList addObject:checkVo];
        }
    }
    return dataList;
}


- (NSDictionary *)converToDic {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (self.withdrawCheckId > 0) {
        [dic setValue:[NSNumber numberWithInteger:self.withdrawCheckId] forKey:@"withdrawCheckId"];
    }

    [dic setValue:[NSString stringForObject:self.entityId] forKey:@"entityId"];
    [dic setValue:[NSString stringForObject:self.proposerId] forKey:@"proposerId"];
    [dic setValue:[NSNumber numberWithShort:self.proposerType] forKey:@"proposerType"];
    [dic setValue:[NSNumber numberWithInteger:self.parentId] forKey:@"parentId"];
    [dic setValue:[NSNumber numberWithShort:self.action] forKey:@"action"];
    [dic setValue:[NSNumber numberWithShort:self.checkResult] forKey:@"checkResult"];
    [dic setValue:[NSNumber numberWithDouble:self.actionAmount] forKey:@"actionAmount"];
    [dic setValue:[NSNumber numberWithShort:self.isValid] forKey:@"isValid"];
    [dic setValue:[NSNumber numberWithLongLong:self.createTime] forKey:@"createTime"];
    [dic setValue:[NSNumber numberWithLongLong:self.opTime] forKey:@"opTime"];
    [dic setValue:[NSNumber numberWithInteger:self.lastVer] forKey:@"lastVer"];
    [dic setValue:[NSString stringForObject:self.opUserId] forKey:@"opUserId"];
    [dic setValue:[NSString stringForObject:self.checkUserId] forKey:@"checkUserId"];
    [dic setValue:[NSString stringForObject:self.withdrawalType] forKey:@"withdrawalType"];
    [dic setValue:[NSString stringForObject:self.bankName] forKey:@"bankName"];
    [dic setValue:[NSString stringForObject:self.accountName] forKey:@"accountName"];
    [dic setValue:[NSString stringForObject:self.accountNumber] forKey:@"accountNumber"];
    [dic setValue:[NSString stringForObject:self.opUserName] forKey:@"opUserName"];
    [dic setValue:[NSString stringForObject:self.checkUserName] forKey:@"checkUserName"];
    [dic setValue:[NSString stringForObject:self.refuseReason] forKey:@"refuseReason"];
    [dic setValue:[NSString stringForObject:self.userId] forKey:@"userId"];
    [dic setValue:[NSString stringForObject:self.userName] forKey:@"userName"];
    [dic setValue:[NSString stringForObject:self.mobile] forKey:@"mobile"];
    [dic setValue:[NSString stringForObject:self.mobileFour] forKey:@"mobileFour"];
    [dic setValue:[NSString stringForObject:self.certificateId] forKey:@"certificateId"];
    [dic setValue:[NSNumber numberWithShort:self.identityTypeId] forKey:@"identityTypeId"];
    
    return dic;
}

@end
