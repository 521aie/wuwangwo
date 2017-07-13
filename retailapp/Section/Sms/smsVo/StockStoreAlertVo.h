//
//  StockStoreAlertVo.h
//  retailapp
//
//  Created by hm on 15/11/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockStoreAlertVo : NSObject

@property (nonatomic, copy) NSString *goodsName;
    
@property (nonatomic, copy) NSString *nowStore;
    
@property (nonatomic, copy) NSString *baseStore;
    
@property (nonatomic, copy) NSString *barCode;

+ (StockStoreAlertVo *)converToVo:(NSDictionary *)dic;

+ (NSMutableArray *)converToArr:(NSArray *)arr;

@end
