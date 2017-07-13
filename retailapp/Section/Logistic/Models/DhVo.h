//
//  DhVo.h
//  retailapp
//
//  Created by hm on 15/10/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DhVo : NSObject

@property (nonatomic,copy) NSString *styleId;//产品ID
@property (nonatomic,copy) NSString *colorId;//款色ID
@property (nonatomic) NSInteger sumCount;//总数量
@property (nonatomic) NSInteger sumMoney;//总订货金额
@property (nonatomic) NSInteger s24;//尺码数量
@property (nonatomic) NSInteger s25;//尺码数量
@property (nonatomic) NSInteger s26;//尺码数量
@property (nonatomic) NSInteger s27;//尺码数量
@property (nonatomic) NSInteger s28;//尺码数量
@property (nonatomic) NSInteger s29;//尺码数量
@property (nonatomic) NSInteger s30;//尺码数量
@property (nonatomic) NSInteger s31;//尺码数量
@property (nonatomic) NSInteger s32;//尺码数量
@property (nonatomic) NSInteger s33;//尺码数量
@property (nonatomic) NSInteger s34;//尺码数量
@property (nonatomic) NSInteger s35;//尺码数量
@property (nonatomic) NSInteger s36;//尺码数量
@property (nonatomic) NSInteger s37;//尺码数量
@property (nonatomic) NSInteger s38;//尺码数量
@property (nonatomic) NSInteger s39;//尺码数量
@property (nonatomic) NSInteger s40;//尺码数量

+ (DhVo *)convertFromDic:(NSDictionary *)dictionary;
+ (NSArray *)convertFromArr:(NSArray *)array;
+ (NSDictionary *)getDictionaryData:(DhVo *)dhVo;
+ (NSArray *)getArrayData:(NSArray *)array;
+ (NSInteger)getAllDhl:(NSArray *)dhVoList;

@end
