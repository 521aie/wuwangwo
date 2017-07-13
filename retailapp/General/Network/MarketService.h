//
//  MarketService.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpEngine.h"
#import "MemberBirSaleVo.h"

@interface MarketService : NSObject

//特价商品一览
- (void)selectSpecialOfferGoodsList:(NSString*) shopId fitRange:(NSString*) fitRange lastDateTime:(NSString*) lastDateTime completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//特价款式一览
- (void)selectSpecialOfferStylesList:(NSString*) shopId fitRange:(NSString*) fitRange lastDateTime:(NSString*) lastDateTime completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//特价商品规则保存
-(void) saveGoods:(NSDictionary*) priceRuleVo goodsIdList:(NSMutableArray*) goodsIdList shopsIdList:(NSMutableArray*) shopsIdList operateType:(NSString*) operateType shopFlag:(NSString*) shopFlag completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//特价款式规则保存
-(void) saveStyles:(NSDictionary*) priceRuleVo styleIdList:(NSMutableArray*) styleIdList shopsIdList:(NSMutableArray*) shopsIdList operateType:(NSString*) operateType shopFlag:(NSString*) shopFlag completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//特价商品详情
- (void)selectSpecialOfferGoodsDetail:(NSString*) priceId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//特价款式详情
- (void)selectSpecialOfferStylesDetail:(NSString*) priceId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//特价商品规则删除
- (void) deleteGoods:(NSString*) priceId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//特价款式规则删除
- (void) deleteStyle:(NSString*) priceId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//优惠券活动列表
-(void) selectSalesCouponList:(NSString*) shopId fitRange:(NSString*) fitRange completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//优惠券规则详情
-(void) selectSalesCouponDetail:(NSString*) couponRuleId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//优惠券规则保存
-(void) saveCouponDetail:(NSDictionary*) salesCouponVo operateType:(NSString*) operateType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//优惠券规则删除
-(void) deleteSalesCouponDetail:(NSString*) couponRuleId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//第N件打折活动列表
-(void) selectSalesNpDiscountList:(NSString*) shopId fitRange:(NSString*) fitRange completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//第N件打折规则详情
-(void) selectSalesNpDiscountDetail:(NSString*) npDiscountId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//第N件打折规则新增or修改
-(void) saveSalesNpDiscountDetail:(NSDictionary*) salesNpDiscountVo discountGoodsVoList:(NSMutableArray*) discountGoodsVoList operateType:(NSString*) operateType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//第N件打折规则删除
-(void) deleteSalesNpDiscountDetail:(NSString*) npDiscountId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//捆绑打折活动列表
-(void) selectSalesBindingDiscountList:(NSString*) shopId fitRange:(NSString*) fitRange completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//捆绑打折规则详情
-(void) selectSalesBindingDiscountDetail:(NSString*) bindDiscountId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//捆绑打折规则新增or修改
-(void) saveSalesBindingDiscountDetail:(NSDictionary*) salesBindDiscountVo discountGoodsVoList:(NSMutableArray*) discountGoodsVoList operateType:(NSString*) operateType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//捆绑打折规则删除
-(void) deleteSalesBindingDiscountDetail:(NSString*) bindDiscountId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//满减活动列表
-(void) selectSalesMatchRuleMinusList:(NSString*) shopId fitRange:(NSString*) fitRange completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//满减规则详情
-(void) selectSalesMatchRuleMinusDetail:(NSString*) minusRuleId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//满减规则新增or修改
-(void) saveSalesMatchRuleMinusDetail:(NSDictionary*) salesMatchRuleMinusVo operateType:(NSString*) operateType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//满减规则删除
-(void) deleteSalesMatchRuleMinusDetail:(NSString*) minusRuleId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//满送换购活动列表
-(void) selectSalesMatchRuleSendList:(NSString*) shopId fitRange:(NSString*) fitRange completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//满送换购规则详情
-(void) selectSalesMatchRuleSendDetail:(NSString*) fullSendId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//满送换购规则新增or修改
-(void) saveSalesMatchRuleSendDetail:(NSDictionary*) salesMatchRuleSendVo operateType:(NSString*) operateType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//满送换购规则删除
-(void) deleteSalesMatchRuleSendDetail:(NSString*) fullSendId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//促销款式列表
-(void) selectStyleList:(NSString*) keyWord discountId:(NSString*) discountId discountType:(NSString*) discountType lastDateTime:(NSString*) lastDateTime completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//添加促销款式
-(void) addSaleStyleList:(NSString*) discountId discountType:(NSString*) discountType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//按条件选择添加款式
-(void) saveStyleByCondition:(NSString*) shopId discountId:(NSString*) discountId categoryId:(NSString*) categoryId applySex:(NSString*) applySex year:(NSString*) year seasonValId:(NSString*) seasonValId minHangTagPrice:(NSString*) minHangTagPrice maxHangTagPrice:(NSString*) maxHangTagPrice discountType:(NSString*) discountType prototypeValId:(NSString*) prototypeValId auxiliaryValId:(NSString*) auxiliaryValId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//选择款式添加
-(void) saveSalesStyleBySearch:(NSMutableArray*) saleStyleVoList discountId:(NSString*) discountId discountType:(NSString*) discountType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//促销款式范围批量删除
-(void) deleteSalesStyle:(NSMutableArray*) styleIdList discountId:(NSString*) discountId discountType:(NSString*) discountType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//促销商品列表
-(void) selectGoodsList:(NSString*) keyWord discountId:(NSString*) discountId discountType:(NSString*) discountType lastDateTime:(NSString*) lastDateTime searchType:(NSString*) searchType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//添加促销商品
-(void) addSaleGoodsList:(NSString*) discountId discountType:(NSString*) discountType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//促销商品选择添加
-(void) saveSalesGoodsBySearch:(NSMutableArray*) saleGoodVoList discountId:(NSString*) discountId discountType:(NSString*) discountType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//促销商品范围批量删除
-(void) deleteSalesGoods:(NSMutableArray*) goodIdList discountId:(NSString*) discountId discountType:(NSString*) discountType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//促销活动保存
-(void) saveSaleAct:(NSDictionary*) saleActVo shopIdList:(NSMutableArray*) shopIdList operateType:(NSString*) operateType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//查询促销活动详情
-(void) selectSaleActDetail:(NSString*)saleActId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//删除促销活动详情
-(void) deleteSaleActDetail:(NSString*)saleActId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//会员生日促销查询
-(void) selectMemberBirthdaySales:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//会员生日促销保存
-(void) saveMemberBirthdaySales:(NSDictionary*) memberBirSaleVo operateType:(NSString*) operateType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

@end
