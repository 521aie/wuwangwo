//
//  ConfigItemOptionVo.h
//  retailapp
//
//  Created by hm on 15/9/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameItem.h"

@interface ConfigItemOptionVo : NSObject<INameItem>

@property (nonatomic,copy) NSString* value;

@property (nonatomic,copy) NSString* name;

+ (ConfigItemOptionVo*)converToVo:(NSDictionary*)dic;

+ (NSMutableArray*)converToArr:(NSArray*)arrList;

+ (NSDictionary*)converToDic:(ConfigItemOptionVo*)vo;

@end
