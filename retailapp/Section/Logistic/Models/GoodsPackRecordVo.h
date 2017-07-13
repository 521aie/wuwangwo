//
//  GoodsPackRecordVo.h
//  retailapp
//
//  Created by hm on 15/11/6.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameValueItem.h"

@interface GoodsPackRecordVo : NSObject<INameValueItem>

@property (nonatomic, copy) NSString *returnGoodsDetailId;
@property (nonatomic, copy) NSString *packGoodsId;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *boxCode;
@property (nonatomic, copy) NSString *goodsColor;
@property (nonatomic, copy) NSString *goodsSize;
@property (nonatomic, strong) NSNumber *realSum;
@property (nonatomic, strong) NSNumber *goodsPrice;
@property (nonatomic, copy) NSString *operateType;
@property (nonatomic, strong) NSNumber *oldSum;
@property (nonatomic, assign) short changeFlag;
+ (GoodsPackRecordVo *)converToVo:(NSDictionary *)dic;
+ (NSMutableArray *)converToArr:(NSArray *)sourceList;
+ (NSMutableDictionary *)converToDic:(GoodsPackRecordVo *)vo;
+ (NSMutableArray *)converToDicArr:(NSMutableArray *)sourceList;
@end
