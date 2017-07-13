//
//  GlobalRender.h
//  retailapp
//
//  Created by hm on 15/6/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalRender : NSObject


+(NSString*) obtainItem:(NSArray *)list itemId:(NSString *)itemId;

+(NSMutableArray*) convertStrs:(NSArray *)souces;

//+(NSString*) convertToTimeString:(int)timeVal;
//
//+(int) convertToTimeValue:(NSString*)timeStr;

+(int) getPos:(NSArray*)list itemId:(NSString*)itemId;

/**
 *  省市区拼接成详细地址
 *
 *  @param addressList 地址列表
 *  @param provinceId  省id
 *  @param cityId      市id
 *  @param districtId  区id
 *
 *  @return 省市区
 */
+ (NSString*)getAddress:(NSArray*)addressList PId:(NSString*)provinceId CId:(NSString*)cityId  DId:(NSString*)districtId;

+(NSMutableArray *)listYears;
@end
