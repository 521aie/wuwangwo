//
//  SizeRefer.h
//  retailapp
//
//  Created by hm on 15/9/14.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SizeRefer : NSObject
@property (nonatomic) short sizetype;
@property (nonatomic, copy) NSString* sizeid;
@property (nonatomic, copy) NSString* sizevalue;
@property (nonatomic, copy) NSString* type;

+ (SizeRefer *)convertFromDic:(NSDictionary *)dictionary;
+ (NSArray *)convertFromArr:(NSArray *)array;
@end
