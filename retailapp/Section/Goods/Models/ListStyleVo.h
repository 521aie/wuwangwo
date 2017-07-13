//
//  ListStyleVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/10/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface ListStyleVo : Jastor

/**
 * <code>主键</code>.
 */
@property (nonatomic, strong) NSString *styleId;

/**
 * <code>款式名称</code>.
 */
@property (nonatomic, strong) NSString *styleName;

/**
 * <code>款号</code>.
 */
@property (nonatomic, strong) NSString *styleCode;

/**
 * <code>主图附件名</code>.
 */
@property (nonatomic, strong) NSString *fileName;

/**
 * <code>主图服务器地址</code>.
 */
@property (nonatomic, strong) NSString *filePath;

/**
 * <code>创建时间</code>.
 */
@property (nonatomic) long long createTime;

@property (nonatomic, assign) short upDownStatus;

/**
 * <code>是否选中</code>.
 */
@property (nonatomic, strong) NSString *isCheck;

+(ListStyleVo*)convertToListStyleVo:(NSDictionary*)dic;

+ (NSDictionary*)converToDic:(ListStyleVo*)vo;

@end
