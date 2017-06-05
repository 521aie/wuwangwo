//
//  ShopType.h
//  retailapp
//
//  Created by hm on 15/9/18.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameItem.h"

@interface ShopType : NSObject
@property (nonatomic,copy) NSString* name;
@property (nonatomic) NSInteger val;

+ (ShopType*)converToVo:(NSDictionary*)dic;
+ (NSMutableArray*)converToArr:(NSArray*)sourceList;
@end
