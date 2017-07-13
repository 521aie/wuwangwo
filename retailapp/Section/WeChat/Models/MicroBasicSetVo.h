//
//  MicroBasicSetVo.h
//  retailapp
//
//  Created by zhangzt on 15/10/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface MicroBasicSetVo : Jastor

/**
 * <code>参数配置id</code>.
 */
@property (nonatomic, copy) NSString *configId;

/**
 * <code>参数配置名称</code>.
 */
@property (nonatomic, copy) NSString *name;

/**
 * <code>参数配置值</code>.
 */
@property (nonatomic, copy) NSString *value;

/**
 * <code>参数配置编号</code>.
 */
@property (nonatomic, copy) NSString *code;

/**
 * <code>参数配置描述</code>.
 */
@property (nonatomic, copy) NSString *detail;


+ (MicroBasicSetVo*)converToVo:(NSDictionary*)dic;

+ (NSMutableArray*)converToArr:(NSArray*)arrList;

+ (NSDictionary*)converToDic:(MicroBasicSetVo*)vo;

@end
