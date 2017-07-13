//
//  LogisticsDetailVo.h
//  retailapp
//
//  Created by hm on 15/10/12.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogisticsDetailVo : NSObject

@property (nonatomic,copy) NSString* goodsId;
@property (nonatomic,copy) NSString* goodsName;
@property (nonatomic,assign) double goodsPrice;
@property (nonatomic,assign) double retailPrice;
@property (nonatomic,assign) double hangTagPrice;
@property (nonatomic,assign) double goodsSum;
@property (nonatomic,assign) NSInteger goodsType;
@property (nonatomic,assign) double goodsTotalSum;
@property (nonatomic,assign) double goodsTotalPrice;
@property (nonatomic,copy) NSString* goodsBarcode;
@property (nonatomic,copy) NSString* goodsInnerCode;
@property (nonatomic,copy) NSString* color;
@property (nonatomic,copy) NSString* size;
@property (nonatomic,copy) NSString* styleCode;
/** 总进货价 */
@property (nonatomic, assign) double goodsPurchaseTotalPrice;
/** 总零售价 */
@property (nonatomic, assign) double goodsRetailTotalPrice;
/** 总吊牌价 */
@property (nonatomic, assign) double goodsHangTagTotalPrice;
@property (nonatomic,assign) short type;
+ (LogisticsDetailVo*)converToVo:(NSDictionary*)dic;
+ (NSMutableArray*)converToArr:(NSArray*)sourceList;
@end
