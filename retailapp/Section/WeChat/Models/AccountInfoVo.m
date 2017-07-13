//
//  AccountInfoVo.m
//  retailapp
//
//  Created by diwangxie on 16/5/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "AccountInfoVo.h"

@implementation AccountInfoVo
+(AccountInfoVo *)convertToAccountInfoVo:(NSDictionary*)dic{
    if ([ObjectUtil isNotEmpty:dic]) {
        AccountInfoVo *vo=[[AccountInfoVo alloc] init];
        vo.id=[ObjectUtil getLonglongValue:dic key:@"rebateFee"];
        
        vo.companionAccountId=[ObjectUtil getStringValue:dic key:@"rebateFee"];
        
        vo.companionAccountType=[ObjectUtil getShortValue:dic key:@"companionAccountType"];
        
        vo.balanceTemp=[ObjectUtil getDoubleValue:dic key:@"balanceTemp"];
        
        vo.balanceFormal=[ObjectUtil getDoubleValue:dic key:@"balanceFormal"];
        
        vo.pointsTemp=[ObjectUtil getIntegerValue:dic key:@"pointsTemp"];
        
        vo.pointsFormal=[ObjectUtil getIntegerValue:dic key:@"pointsFormal"];
        
        vo.totalWithdraw=[ObjectUtil getDoubleValue:dic key:@"totalWithdraw"];
        
        vo.subApplyWithdraw=[ObjectUtil getDoubleValue:dic key:@"subApplyWithdraw"];
        
        vo.subTotalWithdraw=[ObjectUtil getDoubleValue:dic key:@"subTotalWithdraw"];
        
        vo.totalTurnover=[ObjectUtil getDoubleValue:dic key:@"totalTurnover"];
        
        vo.memberCount=[ObjectUtil getIntegerValue:dic key:@"memberCount"];
        
        vo.orderCount=[ObjectUtil getIntegerValue:dic key:@"orderCount"];
        
        vo.totalMemberRebate=[ObjectUtil getDoubleValue:dic key:@"totalMemberRebate"];
        
        vo.lastVer=[ObjectUtil getIntegerValue:dic key:@"lastVer"];
        
        vo.isValid=[ObjectUtil getShortValue:dic key:@"isValid"];
        
        vo.createTime=[ObjectUtil getIntegerValue:dic key:@"createTime"];
        
        vo.opTime=[ObjectUtil getIntegerValue:dic key:@"opTime"];
        
        vo.opUserId=[ObjectUtil getStringValue:dic key:@"opUserId"];;

        return vo;
    }
    return nil;
}
@end
