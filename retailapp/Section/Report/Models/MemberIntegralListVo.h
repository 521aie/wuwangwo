//
//  MemberIntegralListVo.h
//  retailapp
//
//  Created by 叶在义 on 15/10/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberIntegralListVo : NSObject
@property (nonatomic, copy) NSString *customername; //会员姓名
@property (nonatomic ,strong) NSString *kindCardName;/*<会员卡类型名称>*/
@property (nonatomic ,strong) NSString *cardCode;/*<会员卡号>*/
@property (nonatomic ,strong) NSString *name;/*<兑换商品名称>*/
@property (nonatomic ,strong) NSString *goodsId;/*<兑换商品id>*/
@property (nonatomic ,strong) NSString *typeName;/*<类型名称：eg 兑换商品、兑换余额>*/
@property (nonatomic ,strong) NSNumber *type;/*<兑换类型>*/
@property (nonatomic, copy) NSString *mobile; //会员手机号码
@property (nonatomic, copy) NSString *giftexchangeid; //积分兑换记录ID
@property (nonatomic, copy) NSString *exchangetype; //兑换方式
@property (nonatomic, strong) NSNumber *totalpoint; //兑换积分
@property (nonatomic, strong) NSNumber *createtime; //兑换时间
- (instancetype)initWithDictionary:(NSDictionary *)json;
@end
