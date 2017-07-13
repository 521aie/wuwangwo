//
//  SalePackStyleVo.h
//  retailapp
//
//  Created by Jianyong Duan on 15/10/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface SalePackStyleVo : Jastor

/**
 * <code>款式id</code>.
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
 * <code>创建时间</code>.
 */
@property (nonatomic) long long createTime;

/**
 * <code>主图服务器路径</code>.
 */
@property (nonatomic, strong) NSString *filePath;

+(SalePackStyleVo*)convertToSalePackStyleVo:(NSDictionary*)dic;
+(NSDictionary*)getDictionaryData:(SalePackStyleVo *)salePackStyleVo;

@end
