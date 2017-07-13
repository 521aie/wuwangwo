//
//  AdjustReasonVo.h
//  retailapp
//
//  Created by hm on 15/10/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameItem.h"

@interface AdjustReasonVo : NSObject
/**原因id*/
@property (nonatomic, copy) NSString *typeVal;
/**原因名称*/
@property (nonatomic, copy) NSString *typeName;

+ (AdjustReasonVo *)converToVo:(NSDictionary *)dic;
+ (NSMutableArray *)converToArr:(NSArray *)sourceList;
@end
