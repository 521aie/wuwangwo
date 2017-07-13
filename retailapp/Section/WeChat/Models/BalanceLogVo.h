//
//  BalanceLogVo.h
//  retailapp
//
//  Created by Jianyong Duan on 15/12/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BalanceLogVo : NSObject

//id
@property (nonatomic) NSInteger moneyFlowId;
//操作类型
@property (nonatomic, copy) NSString *opName;

//操作金额
@property (nonatomic) double fee;

//操作时间
@property (nonatomic, copy) NSString *opTime;

@property (nonatomic) NSInteger action;

+ (BalanceLogVo *)converToVo:(NSDictionary*)dic;
+ (NSMutableArray*)converToArr:(NSArray*)sourceList;

@end
