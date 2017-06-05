//
//  SaleStyleVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/11/13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"

@interface SaleStyleVo : Jastor

/**
 * <code>主键</code>.
 */
@property (nonatomic, strong) NSString *styleId;

/**
 * <code>款式No</code>.
 */
@property (nonatomic, strong) NSString *styleCode;

/**
 * <code>款式名称</code>.
 */
@property (nonatomic, strong) NSString *styleName;

/**
 * <code>款式图片</code>.
 */
@property (nonatomic, strong) NSString *stylePic;

/**
 * <code>创建时间</code>.
 */
@property (nonatomic) NSInteger createTime;

/**
 * <code>是否选中</code>.
 */
@property (nonatomic, strong) NSString *isCheck;

+(SaleStyleVo*)convertToSaleStyleVo:(NSDictionary*)dic;
+(NSDictionary*)getDictionaryData:(SaleStyleVo *)saleStyleVo;

+ (NSMutableArray*)converToArr:(NSArray*)sourceList;

@end
