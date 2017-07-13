//
//  ShopCommentReportVo.h
//  retailapp
//
//  Created by Jianyong Duan on 15/11/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCommentReportVo : Jastor

//commentReportid			门店评论Id			Integer
@property (nonatomic) NSInteger commentReportid;

//shopId			店铺Id			String
@property (nonatomic, copy) NSString *shopId;

//reportTime			统计时间			String
@property (nonatomic, copy) NSString *reportTime;

//weixinAttitudeScore			微店态度分数			BigDecimal
@property (nonatomic) float attitudeScore;

//weixinAttitudeScoreIncreace			微店态度分数相比上个月			int
@property (nonatomic) NSInteger attitudeCompare;

//门店购物环境分数
@property (nonatomic) float shoppingScore;

//门店购物环境与上个月比较
@property (nonatomic) NSInteger shoppingCompare;

//门店售后服务分数
@property (nonatomic) float serviceScore;

//门店售后服务分数相比上个月
@property (nonatomic) NSInteger serviceCompare;

//descriptionScore			描述相符分数			BigDecimal
@property (nonatomic) float descriptionScore;

//descriptionScoreIncreace			描述相符分数相比上个月			int
@property (nonatomic) NSInteger descriptionCompare;

//shippingScore			是否有效			BigDecimal
@property (nonatomic) float shippingScore;

//shippingScoreIncreace			创建时间			int
@property (nonatomic) NSInteger shippingCompare;

//goodCount			好评数			Integer
@property (nonatomic) NSInteger goodCount;

//goodCountIncreace			好评数相比上个月			int
@property (nonatomic) NSInteger goodCountCompare;

//mediumCount			中评数			Integer
@property (nonatomic) NSInteger mediumCount;

//mediumCountIncreace			中评数相比上个月			int
@property (nonatomic) NSInteger mediumCountCompare;

//badCount			差评数			Integer
@property (nonatomic) NSInteger badCount;

//badCountIncreace			差评数相比上个月			int
@property (nonatomic) NSInteger badCountCompare;

//feedbackRate			好评率
@property (nonatomic, copy) NSString *feedbackRate;

//等级
- (NSInteger)levelTotal;

//购物环境 描述相符
- (float)shoppingOrDescriptionScore:(NSInteger)type;
- (NSInteger)shoppingOrDescriptionCompare:(NSInteger)type;

//售后服务 物流服务
- (float)servicOrshippingScore:(NSInteger)type;
- (NSInteger)servicOrshippingCompare:(NSInteger)type;

@end
