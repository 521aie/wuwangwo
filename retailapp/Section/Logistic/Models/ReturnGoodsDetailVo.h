//
//  ReturnGoodsDetailVo.h
//  retailapp
//
//  Created by hm on 15/10/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReturnGoodsDetailVo : NSObject
@property (nonatomic,copy) NSString* returnGoodsDetailId;
@property (nonatomic,copy) NSString* goodsId;
@property (nonatomic,copy) NSString* goodsName;
@property (nonatomic,assign) double goodsPrice;
@property (nonatomic,assign) NSInteger goodsSum;
@property (nonatomic,assign) double goodsTotalPrice;
@property (nonatomic,copy) NSString* goodsBarcode;
@property (nonatomic,copy) NSString* goodsInnercode;
@property (nonatomic,copy) NSString* styleCode;
@property (nonatomic,copy) NSString* operateType;
@property (nonatomic,assign) double oldGoodsPrice;
@property (nonatomic,assign) double oldGoodsSum;
@property (nonatomic,assign) short changeFlag;
@property (nonatomic,strong) NSNumber *predictSum;

+ (ReturnGoodsDetailVo *)converToVo:(NSDictionary *)dic;
+ (NSMutableArray *)converToArr:(NSArray *)sourceList;
+ (NSMutableDictionary *)converToDic:(ReturnGoodsDetailVo *)vo;
+ (NSMutableArray *)converToArrDic:(NSMutableArray *)dataList;
@end
