//
//  Wechat_StyleVo.h
//  retailapp
//
//  Created by zhangzt on 15/10/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface Wechat_StyleVo : Jastor

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
 * <code>微店上下架状态</code>.
 */
//@property (nonatomic, strong) NSString *microShelveStatus;

/**
 * <code>主图服务器地址</code>.
 */
@property (nonatomic, strong) NSString *filePath;

/**
 * <code>主图名称</code>.
 */
@property (nonatomic, strong) NSString *fileName;

/**
 * <code>创建时间</code>.
 */
@property (nonatomic) NSInteger createTime;

/**
 * <code>是否选中</code>.
 */
@property (nonatomic, strong) NSString *isCheck;


//@property (nonatomic) double 

+(Wechat_StyleVo*)convertToListStyleVo:(NSDictionary*)dic;

+(NSDictionary*)getDictionary:(Wechat_StyleVo*)vo;

@end
