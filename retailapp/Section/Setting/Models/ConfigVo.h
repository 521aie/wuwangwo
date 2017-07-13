//
//  ConfigVo.h
//  retailapp
//
//  Created by hm on 15/9/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigVo : NSObject

@property (nonatomic,copy) NSString* value;

@property (nonatomic,copy) NSString* code;

@property (nonatomic,strong) NSMutableArray* configItemOptionVoList;


+ (NSMutableArray*)converToArr:(NSArray*)sourceList;

+ (NSDictionary*)converToDic:(ConfigVo*)vo;

@end
