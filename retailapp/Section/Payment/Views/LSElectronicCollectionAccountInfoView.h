//
//  LSElectronicCollectionAccountInfoView.h
//  retailapp
//
//  Created by guozhi on 2016/12/2.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopInfoVO.h"
@interface LSElectronicCollectionAccountInfoView : UIView
/** 绑卡按钮 */
@property (nonatomic, strong) UIButton *btn;
+ (instancetype)electronicCollectionAccountInfoView;

/**
 设置电子收款信息

 @param shopInfoVo   门店信息
 @param name         电子/微信/支付宝
 @param date         某一天的数据
 @param account      电子收款未到账总额
 @param monthAccount 本月累计电子收款收入
 @param monthIncome  本月累计电子已到账
 @param dayAccount   某天累计电子收款已到账
 @param dayIncome    某天累计电子收款收入
 */
- (void)setShopInfoVo:(ShopInfoVO *)shopInfoVo name:(NSString *)name date:(NSString *)date unAccount:(NSString *)account monthAccount:(NSString *)monthAccount monthIncome:(NSString *)monthIncome dayAccount:(NSString *)dayAccount dayIncome:(NSString *)dayIncome;
@end
