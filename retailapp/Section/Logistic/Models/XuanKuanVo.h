//
//  XuanKuanVo.h
//  retailapp
//
//  Created by hm on 15/10/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XuanKuanVo : NSObject
@property (nonatomic, copy) NSString *colorId;
@property (nonatomic, copy) NSString *colorName;
@property (nonatomic, assign) NSInteger recCount;

+ (XuanKuanVo *)convertFromDic:(NSDictionary *)dictionary;
+ (NSArray *)convertFromArr:(NSArray *)array;

//订货信息
@property (nonatomic, strong) UILabel *labelCount;
@property (nonatomic, strong) NSMutableArray *tfDhList;
@property (nonatomic, strong) NSMutableArray *oldDhList;  //原来的订货量，比较用
@property (nonatomic, strong) UILabel *labelPrice;
@end
