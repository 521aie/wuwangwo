//
//  MarketService.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MarketService.h"
#import "JsonHelper.h"

@implementation MarketService
// 特价商品列表
- (void)selectSpecialOfferGoodsList:(NSString *)shopId fitRange:(NSString*) fitRange lastDateTime:(NSString*) lastDateTime completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesPrice/goodsList"];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [param setValue:shopId forKey:@"shopId"];
    
    [param setValue:fitRange forKey:@"fitRange"];
    
    if ([NSString isNotBlank:lastDateTime]) {
        [param setValue:lastDateTime forKey:@"lastDateTime"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectSpecialOfferStylesList:(NSString *)shopId fitRange:(NSString*) fitRange lastDateTime:(NSString*) lastDateTime completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesPrice/stylesList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    [param setValue:shopId forKey:@"shopId"];
    
    [param setValue:fitRange forKey:@"fitRange"];
    
    if ([NSString isNotBlank:lastDateTime]) {
        [param setValue:lastDateTime forKey:@"lastDateTime"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) saveGoods:(NSDictionary*) priceRuleVo goodsIdList:(NSMutableArray*) goodsIdList shopsIdList:(NSMutableArray*) shopsIdList operateType:(NSString*) operateType shopFlag:(NSString*) shopFlag completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesPrice/saveGoods"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:5];
    
    [param setValue:priceRuleVo forKey:@"priceRuleVo"];
    
    [param setValue:goodsIdList forKey:@"goodsIdList"];
    
    if (shopsIdList != nil) {
        [param setValue:shopsIdList forKey:@"shopsIdList"];
    }
    
    if (shopFlag != nil) {
        [param setValue:shopFlag forKey:@"shopFlag"];
    }
    
    [param setValue:operateType forKey:@"operateType"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) saveStyles:(NSDictionary*) priceRuleVo styleIdList:(NSMutableArray*) styleIdList shopsIdList:(NSMutableArray*) shopsIdList operateType:(NSString*) operateType shopFlag:(NSString*) shopFlag completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesPrice/saveStyles"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:5];
    
    [param setValue:priceRuleVo forKey:@"priceRuleVo"];
    
    if (shopsIdList != nil) {
        [param setValue:shopsIdList forKey:@"shopsIdList"];
    }
    
    if (shopFlag != nil) {
        [param setValue:shopFlag forKey:@"shopFlag"];
    }
    [param setValue:styleIdList forKey:@"styleIdList"];
    
    [param setValue:operateType forKey:@"operateType"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectSpecialOfferGoodsDetail:(NSString *)priceId completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesPrice/goodsDetail"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:priceId forKey:@"priceId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectSpecialOfferStylesDetail:(NSString *)priceId completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesPrice/stylesDetail"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:priceId forKey:@"priceId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

- (void) deleteGoods:(NSString*) priceId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesPrice/deleteGood"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:priceId forKey:@"priceId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

- (void) deleteStyle:(NSString*) priceId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesPrice/deleteStyle"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:priceId forKey:@"priceId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectSalesCouponList:(NSString*) shopId fitRange:(NSString*) fitRange completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesCoupon/list"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:shopId forKey:@"shopId"];
    
    [param setValue:fitRange forKey:@"fitRange"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectSalesCouponDetail:(NSString*) couponRuleId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesCoupon/detail"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:couponRuleId forKey:@"couponRuleId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) saveCouponDetail:(NSDictionary*) salesCouponVo operateType:(NSString*) operateType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesCoupon/save"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:salesCouponVo forKey:@"salesCouponVo"];
    
    [param setValue:operateType forKey:@"operateType"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) deleteSalesCouponDetail:(NSString*) couponRuleId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesCoupon/delete"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:couponRuleId forKey:@"couponRuleId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectSalesNpDiscountList:(NSString*) shopId fitRange:(NSString*) fitRange completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesNpDiscount/list"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:shopId forKey:@"shopId"];
    
    [param setValue:fitRange forKey:@"fitRange"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectSalesNpDiscountDetail:(NSString*) npDiscountId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesNpDiscount/detail"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:npDiscountId forKey:@"npDiscountId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) saveSalesNpDiscountDetail:(NSDictionary*) salesNpDiscountVo discountGoodsVoList:(NSMutableArray*) discountGoodsVoList operateType:(NSString*) operateType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesNpDiscount/save"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [param setValue:salesNpDiscountVo forKey:@"salesNpDiscountVo"];
    
    [param setValue:discountGoodsVoList forKey:@"discountGoodsVoList"];
    
    [param setValue:operateType forKey:@"operateType"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) deleteSalesNpDiscountDetail:(NSString*) npDiscountId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesNpDiscount/delete"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:npDiscountId forKey:@"npDiscountId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectSalesBindingDiscountList:(NSString*) shopId fitRange:(NSString*) fitRange completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesBindDiscount/list"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:shopId forKey:@"shopId"];
    
    [param setValue:fitRange forKey:@"fitRange"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectSalesBindingDiscountDetail:(NSString*) bindDiscountId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesBindDiscount/detail"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:bindDiscountId forKey:@"bindDiscountId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) saveSalesBindingDiscountDetail:(NSDictionary*) salesBindDiscountVo discountGoodsVoList:(NSMutableArray*) discountGoodsVoList operateType:(NSString*) operateType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesBindDiscount/save"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [param setValue:salesBindDiscountVo forKey:@"salesBindDiscountVo"];
    
    [param setValue:discountGoodsVoList forKey:@"discountGoodsVoList"];
    
    [param setValue:operateType forKey:@"operateType"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) deleteSalesBindingDiscountDetail:(NSString*) bindDiscountId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesBindDiscount/delete"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:bindDiscountId forKey:@"bindDiscountId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//满减活动列表
-(void) selectSalesMatchRuleMinusList:(NSString*) shopId fitRange:(NSString*) fitRange completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesMatchRuleMinus/list"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:shopId forKey:@"shopId"];
    
    [param setValue:fitRange forKey:@"fitRange"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//满减规则详情
-(void) selectSalesMatchRuleMinusDetail:(NSString*) minusRuleId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesMatchRuleMinus/detail"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:minusRuleId forKey:@"minusRuleId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//满减规则新增or修改
-(void) saveSalesMatchRuleMinusDetail:(NSDictionary*) salesMatchRuleMinusVo operateType:(NSString*) operateType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesMatchRuleMinus/save"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:salesMatchRuleMinusVo forKey:@"salesMatchRuleMinusVo"];
    
    [param setValue:operateType forKey:@"operateType"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//满减规则删除
-(void) deleteSalesMatchRuleMinusDetail:(NSString*) minusRuleId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesMatchRuleMinus/delete"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:minusRuleId forKey:@"minusRuleId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//满送换购活动列表
-(void) selectSalesMatchRuleSendList:(NSString*) shopId fitRange:(NSString*) fitRange completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesMatchRuleSend/list"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:shopId forKey:@"shopId"];
    
    [param setValue:fitRange forKey:@"fitRange"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//满送换购规则详情
-(void) selectSalesMatchRuleSendDetail:(NSString*) fullSendId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesMatchRuleSend/detail"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:fullSendId forKey:@"fullSendId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//满送换购规则新增or修改
-(void) saveSalesMatchRuleSendDetail:(NSDictionary*) salesMatchRuleSendVo operateType:(NSString*) operateType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesMatchRuleSend/save"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:salesMatchRuleSendVo forKey:@"salesMatchRuleSendVo"];
    
    [param setValue:operateType forKey:@"operateType"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//满送换购规则删除
-(void) deleteSalesMatchRuleSendDetail:(NSString*) fullSendId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salesMatchRuleSend/delete"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:fullSendId forKey:@"fullSendId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectStyleList:(NSString*) keyWord discountId:(NSString*) discountId discountType:(NSString*) discountType lastDateTime:(NSString*) lastDateTime completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salePublic/selectStyleList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:4];
    
    if ([NSString isNotBlank:keyWord]) {
        [param setValue:keyWord forKey:@"keyWord"];
    }
    
    [param setValue:discountId forKey:@"discountId"];
    
    [param setValue:discountType forKey:@"discountType"];
    
    if ([NSString isNotBlank:lastDateTime]) {
        [param setValue:lastDateTime forKey:@"lastDateTime"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}


-(void) addSaleStyleList:(NSString*) discountId discountType:(NSString*) discountType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salePublic/addDiscountStyleScore"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:discountId forKey:@"discountId"];
    
    [param setValue:discountType forKey:@"discountType"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) saveStyleByCondition:(NSString*) shopId discountId:(NSString*) discountId categoryId:(NSString*) categoryId applySex:(NSString*) applySex year:(NSString*) year seasonValId:(NSString*) seasonValId minHangTagPrice:(NSString*) minHangTagPrice maxHangTagPrice:(NSString*) maxHangTagPrice discountType:(NSString*) discountType prototypeValId:(NSString*) prototypeValId auxiliaryValId:(NSString*) auxiliaryValId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salePublic/saveStyleByCondition"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:10];
    
    if ([NSString isNotBlank:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    
    [param setValue:discountId forKey:@"discountId"];
    
    if ([NSString isNotBlank:categoryId]) {
        [param setValue:categoryId forKey:@"categoryId"];
    }
    
    if ([NSString isNotBlank:applySex]) {
        [param setValue:applySex forKey:@"applySex"];
    }
    
    if ([NSString isNotBlank:year]) {
        [param setValue:year forKey:@"year"];
    }
    
    if ([NSString isNotBlank:seasonValId]) {
        [param setValue:seasonValId forKey:@"seasonValId"];
    }
    
    if ([NSString isNotBlank:minHangTagPrice]) {
        [param setValue:minHangTagPrice forKey:@"minHangTagPrice"];
    }
    
    if ([NSString isNotBlank:maxHangTagPrice]) {
        [param setValue:maxHangTagPrice forKey:@"maxHangTagPrice"];
    }
    
    if ([NSString isNotBlank:prototypeValId]) {
        [param setValue:prototypeValId forKey:@"prototypeValId"];
    }
    
    if ([NSString isNotBlank:auxiliaryValId]) {
        [param setValue:auxiliaryValId forKey:@"auxiliaryValId"];
    }
    
    [param setValue:discountType forKey:@"discountType"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) saveSalesStyleBySearch:(NSMutableArray*) saleStyleVoList discountId:(NSString*) discountId discountType:(NSString*) discountType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salePublic/saveStyle"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:saleStyleVoList forKey:@"saleStyleVoList"];
    
    [param setValue:discountId forKey:@"discountId"];
    
    [param setValue:discountType forKey:@"discountType"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) deleteSalesStyle:(NSMutableArray*) styleIdList discountId:(NSString*) discountId discountType:(NSString*) discountType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salePublic/deleteStyleRange"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    

    [param setValue:styleIdList forKey:@"styleIdList"];
    
    [param setValue:discountId forKey:@"discountId"];
    
    [param setValue:discountType forKey:@"discountType"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectGoodsList:(NSString*) keyWord discountId:(NSString*) discountId discountType:(NSString*) discountType lastDateTime:(NSString*) lastDateTime searchType:(NSString*) searchType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salePublic/selectGoodList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:4];
    
    if ([NSString isNotBlank:keyWord]) {
        [param setValue:keyWord forKey:@"keyWord"];
    }
    
    [param setValue:discountId forKey:@"discountId"];
    
    [param setValue:discountType forKey:@"discountType"];
    
    if ([NSString isNotBlank:lastDateTime]) {
        [param setValue:lastDateTime forKey:@"lastDateTime"];
    }
    
    if ([NSString isNotBlank:searchType]) {
        [param setValue:searchType forKey:@"searchType"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) addSaleGoodsList:(NSString*) discountId discountType:(NSString*) discountType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salePublic/addDiscountGoodScore"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:discountId forKey:@"discountId"];
    
    [param setValue:discountType forKey:@"discountType"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) saveSalesGoodsBySearch:(NSMutableArray*) saleGoodVoList discountId:(NSString*) discountId discountType:(NSString*) discountType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salePublic/saveGood"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [param setValue:saleGoodVoList forKey:@"saleGoodVoList"];
    
    [param setValue:discountId forKey:@"discountId"];
    
    [param setValue:discountType forKey:@"discountType"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) deleteSalesGoods:(NSMutableArray*) goodIdList discountId:(NSString*) discountId discountType:(NSString*) discountType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salePublic/deleteGoodRange"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:discountId forKey:@"discountId"];
    
    [param setValue:discountType forKey:@"discountType"];
    
    [param setValue:goodIdList forKey:@"goodIdList"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) saveSaleAct:(NSDictionary*) saleActVo shopIdList:(NSMutableArray*) shopIdList operateType:(NSString*) operateType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salePublic/saveSaleAct"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    [param setValue:saleActVo forKey:@"saleActVo"];
    
    // 默认开微店 添加新老版本区分：requestVersion=1
    [param setValue:@"1" forKey:@"requestVersion"];
    
    if (shopIdList != nil) {
        [param setValue:shopIdList forKey:@"shopIdList"];
    }
    
    [param setValue:operateType forKey:@"operateType"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//查询促销活动详情
-(void) selectSaleActDetail:(NSString*)saleActId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salePublic/saleActDetail"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:saleActId forKey:@"saleActId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//删除促销活动详情
-(void) deleteSaleActDetail:(NSString*)saleActId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"salePublic/deleteSaleAct"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:saleActId forKey:@"saleActId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectMemberBirthdaySales:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"memberBirSale/detail"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];

}

-(void) saveMemberBirthdaySales:(NSDictionary *)memberBirSaleVo operateType:(NSString *)operateType completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"memberBirSale/save"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:operateType forKey:@"operateType"];
    [param setValue:memberBirSaleVo forKey:@"memberBirSaleVo"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
@end
