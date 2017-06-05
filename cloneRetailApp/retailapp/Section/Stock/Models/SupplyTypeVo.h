//
//  SupplyTypeVo.h
//  retailapp
//
//  Created by hm on 15/10/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameValue.h"
@interface SupplyTypeVo : NSObject<INameValue>
@property (copy, nonatomic) NSString *dicItemId;
@property (copy, nonatomic) NSString *typeName;
@property (copy, nonatomic) NSString *typeVal;

+ (SupplyTypeVo *)converToVo:(NSDictionary *)dic;
+ (NSMutableArray *)converToArr:(NSArray *)sourceList;
@end
