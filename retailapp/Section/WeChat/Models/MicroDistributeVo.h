//
//  MicroDistributeVo.h
//  retailapp
//
//  Created by Jianyong Duan on 15/12/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MicroDistributeVo : Jastor

//参数配置id
@property (nonatomic, copy) NSString *configId;

//参数配置名称
@property (nonatomic, copy) NSString *name;

//参数配置值
@property (nonatomic, copy) NSString *value;

//参数配置编号
@property (nonatomic, copy) NSString *code;

//参数配置描述
@property (nonatomic, copy) NSString *detail;

+ (MicroDistributeVo*)converToVo:(NSDictionary*)dic;
+ (NSMutableArray*)converToArr:(NSArray*)sourceList;

@end
