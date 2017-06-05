//
//  LSGoodsUnitVo.h
//  retailapp
//
//  Created by guozhi on 16/7/15.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSGoodsUnitVo : NSObject
/**
 *  商品单位ID
 */
@property (nonatomic, copy) NSString *goodsUnitId;
/**
 *  商品单位名字
 */
@property (nonatomic, copy) NSString *unitName;
/**
 *  Integer 顺序码
 */
@property (nonatomic, strong) NSNumber *sortcode;
/**
 *  单位拼音
 */
@property (nonatomic, copy) NSString *spell;
/**
 *  备注
 */
@property (nonatomic, strong) NSString *memo;
/**
 *  版本号 Long
 */
@property (nonatomic,strong) NSNumber *lastVer;



+ (instancetype)goodsUnitVoWithMap:(NSDictionary *)map;
@end
