//
//  ReasonVo.h
//  retailapp
//
//  Created by hm on 15/10/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameValueItem.h"

@interface ReasonVo : NSObject<INameValueItem>
@property (nonatomic,copy) NSString *dicItemId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) NSInteger val;

+ (ReasonVo*)converToVo:(NSDictionary*)dic;
+ (NSMutableArray*)converToArr:(NSArray*)sourceList;
@end
