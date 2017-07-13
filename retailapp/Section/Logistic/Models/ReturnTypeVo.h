//
//  ReturnTypeVo.h
//  retailapp
//
//  Created by hm on 16/2/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameValue.h"
#import "INameItem.h"

@interface ReturnTypeVo : NSObject<INameValue,INameItem>
@property (nonatomic, copy) NSString *dicItemId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *val;

- (instancetype)initWithDictionary:(NSDictionary *)json;
+ (NSMutableArray *)converToArr:(NSArray *)sourceList;
@end
