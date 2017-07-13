//
//  LogisticsVo.h
//  retailapp
//
//  Created by hm on 15/10/12.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogisticsVo : NSObject
@property (nonatomic,copy) NSString* logisticsId;
@property (nonatomic,copy) NSString* recordType;
@property (nonatomic,copy) NSString* logisticsNo;
@property (nonatomic,copy) NSString* supplyName;
@property (nonatomic,copy) NSString* typeName;
@property (nonatomic,copy) NSString* billStatusName;
@property (nonatomic,assign) long long sendEndTime;
@property (nonatomic,assign) NSInteger billStatus;
@property (nonatomic,assign) double goodsTotalSum;
@property (nonatomic,assign) double goodsTotalPrice;

+ (LogisticsVo*)converToVo:(NSDictionary*)dic;
+ (NSMutableArray*)converToArr:(NSArray*)sourceList;
@end
