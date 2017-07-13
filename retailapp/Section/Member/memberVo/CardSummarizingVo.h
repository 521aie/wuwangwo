//
//  CardSummarizingVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import "INameValueItem.h"

@interface CardSummarizingVo : Jastor<INameValueItem>

//我的会员
@property (nonatomic) int myMemberNum;

//会员总数
@property (nonatomic) int memberSum;

//当月会员申请数
@property (nonatomic) int sumPerMonth;

//按会员卡类型统计会员数
@property (nonatomic) NSMutableDictionary *cardTypeSumMap;

//卡类型名称
@property (nonatomic, strong) NSString *cardTypeName;

//每个卡类型的会员数
@property (nonatomic) int everyCardTypeMemberNum;

@end
