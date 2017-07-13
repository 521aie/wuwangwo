//
//  PaperGoodsVo.h
//  retailapp
//
//  Created by hm on 15/10/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMultiNameValueItem.h"

@interface PaperGoodsVo : NSObject<IMultiNameValueItem>

@property (nonatomic,copy) NSString* goodsId;
@property (nonatomic,copy) NSString* barCode;
@property (nonatomic,copy) NSString* goodsName;
@property (nonatomic,assign) double purchasePrice;
@property (nonatomic,assign) double retailPrice;
@property (nonatomic,assign) double goodsCount;
@property (nonatomic,copy) NSString* shortCode;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) double nowStore;
@property (nonatomic,assign) BOOL checkVal;

+ (PaperGoodsVo*)converToVo:(NSDictionary*)dic;
+ (NSMutableArray*)converToArr:(NSArray*)sourceList;
@end
