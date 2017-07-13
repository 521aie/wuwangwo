//
//  AlertDetailVo.h
//  retailapp
//
//  Created by guozhi on 15/11/7.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertDetailVo : NSObject
/**商品ID*/
@property (nonatomic, copy) NSString *goodsId;
/**预警天数  Integer*/
@property (nonatomic, strong) NSNumber *alertDay;
/**是否设置预警天数 1：是 0：否*/
@property (nonatomic, strong) NSNumber *isAlertDay;
/**预警数量*/
@property (nonatomic, strong) NSNumber *alertNum;
/**是否设置预警数量 1：是 0：否*/
@property (nonatomic, strong) NSNumber *isAlertNum;
/**版本号 Long*/
@property (nonatomic, strong) NSNumber *lastVer;
- (instancetype)initWithDictionary:(NSDictionary *)json;
@end
