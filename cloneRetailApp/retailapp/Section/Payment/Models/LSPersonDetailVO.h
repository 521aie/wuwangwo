//
//  LSPersonDetailVO.h
//  retailapp
//
//  Created by guozhi on 16/5/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSPersonDetailVO : NSObject
/**
 *付款人
 */
@property (nonatomic, copy) NSString *payName;
/**
 *付款人手机号
 */
@property (nonatomic, copy) NSString *mobile;
/**
 *付款人会员卡类型
 */
@property (nonatomic, copy) NSString *kindCardName;
/**
 *优惠方式
 */
@property (nonatomic, copy) NSString *Ratioway;
/**
 *积分
 */
@property (nonatomic, assign) NSNumber *degree;
/**
 *会员卡余额
 */
@property (nonatomic, assign) NSNumber *balance;
/**
 *头像
 */
@property (nonatomic, copy) NSString *picPath;

+ (instancetype)personDetailVOWithMap:(NSDictionary *)map;
@end
