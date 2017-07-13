//
//  MemberIntegralDetailVo.h
//  retailapp
//
//  Created by 叶在义 on 15/10/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberIntegralDetailVo : NSObject

//@property (nonatomic, copy) NSString *batchNo; //兑换流水
@property (nonatomic, copy) NSString *shopName; //兑换门店
@property (nonatomic, strong) NSNumber *createtime; //兑换时间 Long
@property (nonatomic, strong) NSNumber *totalGiftNumber; //总件数 Integer
@property (nonatomic, strong) NSNumber *totalPoint; //总积分 Integer
@property (nonatomic, copy) NSString *exchangeType; //兑换类型
@property (nonatomic ,strong) NSArray *operater;/*<操作人>*/
@property (nonatomic ,strong) NSNumber *type;/*<1: 兑换商品 2: 对换卡余额>*/
// 缺少字段，,,,
@property (nonatomic ,strong) NSString *name;/*< 商品名称>*/
@property (nonatomic ,strong) NSString *barCode;/*<商品条码>*/
@property (nonatomic ,strong) NSString *color;/*<商品颜色>*/
@property (nonatomic ,strong) NSString *size;/*<商品尺寸>*/

//@property (nonatomic, strong) NSMutableArray *memberIntegralDetailCellVos;
//- (instancetype)initWithDictionary:(NSDictionary *)json;
+ (instancetype)memberIntegralDetailVo:(NSDictionary *)json;
@end
