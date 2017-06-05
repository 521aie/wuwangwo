//
//  StockDueAlertVo.h
//  retailapp
//
//  Created by hm on 15/11/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockDueAlertVo : NSObject

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *nowStore;

@property (nonatomic, assign) long long expiredDate;

@property (nonatomic, copy) NSString *barCode;

+ (StockDueAlertVo *)convetToVo:(NSDictionary *)dic;
+ (NSMutableArray *)converToArr:(NSArray *)arr;
@end
