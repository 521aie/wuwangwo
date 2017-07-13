//
//  MemberIntegralDetailCellVo.h
//  retailapp
//
//  Created by 叶在义 on 15/10/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberIntegralDetailCellVo : NSObject
@property (nonatomic, copy) NSString *goodsname; //商品名称
@property (nonatomic, copy) NSString *innercode; //商品店内码
@property (nonatomic, copy) NSString *goodscolor; //商品颜色
@property (nonatomic, copy) NSString *goodssize; //商品尺码
@property (nonatomic, strong) NSNumber *conditonpoint; //兑换积分
@property (nonatomic, strong) NSNumber *giftnumber; //兑换数量
- (instancetype)initWIthDictionary:(NSDictionary *)json;
@end
