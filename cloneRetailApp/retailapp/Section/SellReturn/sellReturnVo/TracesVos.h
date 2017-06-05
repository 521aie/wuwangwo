//
//  TracesVos.h
//  retailapp
//
//  Created by Jianyong Duan on 15/12/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TracesVo.h"

@interface TracesVos : NSObject

//订单编号
@property (nonatomic, copy) NSString *billCode;

//跟踪信息
@property (nonatomic, strong) NSArray *traces;

+ (TracesVos *)converToVo:(NSDictionary*)dic;
+ (NSMutableArray*)converToArr:(NSArray*)sourceList;

@end
