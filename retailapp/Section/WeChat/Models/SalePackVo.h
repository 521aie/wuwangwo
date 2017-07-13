//
//  SalePackVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import "INameCode.h"
#import "IMultiNameValueItem.h"

@protocol IMultiNameValueItem;
@interface SalePackVo : Jastor

/**
 * <code>销售包编号</code>.
 */
@property (nonatomic, strong) NSString *packCode;

/**
 * <code>销售包名称</code>.
 */
@property (nonatomic, strong) NSString *packName;

/**
 * <code>销售包id</code>.
 */
@property (nonatomic, strong) NSNumber* salePackId;

/**
 * <code>适用年度</code>.
 */
@property (nonatomic) NSInteger applyYear;

/**
 * <code>版本号</code>.
 */
@property (nonatomic) NSInteger lastVer;

@property (nonatomic,assign) BOOL checkVal;


+(SalePackVo*)convertToSalePackVo:(NSDictionary*)dic;
+(NSDictionary*)getDictionaryData:(SalePackVo *)salePackVo;

+ (NSMutableArray*)converToArr:(NSArray*)sourceList;

@end
