//
//  AccountInfoVo.h
//  retailapp
//
//  Created by diwangxie on 16/5/17.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountInfoVo : NSObject

@property (nonatomic) long long id;

@property (nonatomic,copy) NSString* companionAccountId;

@property (nonatomic) short companionAccountType;

@property (nonatomic) double balanceTemp;

@property (nonatomic) double balanceFormal;

@property (nonatomic) NSInteger pointsTemp;

@property (nonatomic) NSInteger pointsFormal;

@property (nonatomic) double totalWithdraw;

@property (nonatomic) double subApplyWithdraw;

@property (nonatomic) double subTotalWithdraw;

@property (nonatomic) double totalTurnover;

@property (nonatomic) NSInteger memberCount;

@property (nonatomic) NSInteger orderCount;

@property (nonatomic) double totalMemberRebate;

@property (nonatomic) NSInteger lastVer;

@property (nonatomic) short isValid;

@property (nonatomic) NSInteger createTime;

@property (nonatomic) NSInteger opTime;

@property (nonatomic,copy) NSString* opUserId;


+(AccountInfoVo *)convertToAccountInfoVo:(NSDictionary*)dic;

@end
