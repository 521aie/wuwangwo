//
//  MemberService.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberService.h"
#import "JsonHelper.h"
#import "Platform.h"

@implementation MemberService

-(void) selectMemberInfo:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"customer/summarizing"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectKindCardList:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"kindCard/list"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

- (void)selectKindCardDetail:(NSString*) kindCardId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"kindCard/detail"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:kindCardId forKey:@"kindCardId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//-(void) saveKindCard:(NSString *)operateType kindCard:(KindCardVo *)kindCard completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
//{
//    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"kindCard/save"];
//    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
//    
//    [param setValue:operateType forKey:@"operateType"];
//    [param setValue:[JsonHelper getObjectData:kindCard] forKey:@"kindCard"];
//    
//    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
//}

-(void) delKindCard:(NSString *)kindCardId lastVer:(NSString *)lastVer completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"kindCard/delete"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:kindCardId forKey:@"kindCardId"];
    [param setValue:lastVer forKey:@"lastVer"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
    
}

-(void) selectMemberInfoList:(NSString *)keywords keywordsKind:(NSString *)keywordsKind kindCardId:(NSString *)kindCardId statusCondition:(NSString *)statusCondition startActiveTime:(NSString *)startActiveTime endActiveTime:(NSString *)endActiveTime lastDateTime:(NSString *)lastDateTime disposeName:(NSString *)disposeName completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"customer/listPageByTime"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:11];
    
    if ([NSString isNotBlank:keywords]) {
        [param setValue:keywords forKey:@"keywords"];
    }
    
    [param setValue:keywordsKind forKey:@"keywordsKind"];
    [param setValue:kindCardId forKey:@"kindCardId"];
    
    if (![statusCondition isEqualToString:@""]) {
        [param setValue:statusCondition forKey:@"statusCondition"];
    }
    if ([NSString isNotBlank:disposeName]) {
        [param setValue:disposeName forKey:@"disposeName"];
    }
    
    
    if (![startActiveTime isEqualToString:@""]) {
        [param setValue:startActiveTime forKey:@"startActiveTime"];
        [param setValue:endActiveTime forKey:@"endActiveTime"];
    }
    
    [param setValue:lastDateTime forKey:@"lastDateTime"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) exportMemberInfo:(NSString *)keywords kindCardId:(NSString *)kindCardId statusCondition:(NSString *)statusCondition startActiveTime:(NSString *)startActiveTime endActiveTime:(NSString *)endActiveTime createWay:(NSString *)createWay shopId:(NSString *)shopId disposeName:(NSString *)disposeName birthdayTime:(NSString *)birthdayTime email:(NSString *)email completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"customer/exportExcel"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:9];
    
    [param setValue:keywords forKey:@"keywords"];
    [param setValue:kindCardId forKey:@"kindCardId"];
    
    if (![statusCondition isEqualToString:@""]) {
        [param setValue:statusCondition forKey:@"statusCondition"];
    }
    
    if (![startActiveTime isEqualToString:@""]) {
        [param setValue:startActiveTime forKey:@"startActiveTime"];
        [param setValue:endActiveTime forKey:@"endActiveTime"];
    }
    
    if (![createWay isEqualToString:@""]) {
        [param setValue:createWay forKey:@"createWay"];
    }
    
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:disposeName forKey:@"disposeName"];
    
    if (![birthdayTime isEqualToString:@""]) {
        [param setValue:birthdayTime forKey:@"birthdayTime"];
    }
    
    [param setValue:email forKey:@"email"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
    
}

- (void)selectMemberInfoDetail:(NSString*) customerId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"customer/findById"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:customerId forKey:@"customerId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectMemberChargeRecord:(NSString *)customerId chargeStartDate:(NSString *)chargeStartDate chargeEndDate:(NSString *)chargeEndDate lastDateTime:(NSString *)lastDateTime completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"customerRed/chargeRecordSelect"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [param setValue:customerId forKey:@"customerId"];
    
    if ([NSString isNotBlank:chargeStartDate]) {
        [param setValue:chargeStartDate forKey:@"chargeStartDate"];
        [param setValue:chargeEndDate forKey:@"chargeEndDate"];
    }
    
    if ([NSString isNotBlank:lastDateTime]) {
        [param setValue:lastDateTime forKey:@"lastDateTime"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//-(void) saveMemberInfo:(NSString *)operateType passwordFlg:(NSString *)passwordFlg doCheck:(NSString *)doCheck customer:(CustomerVo *)customer completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
//{
//    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"customer/save"];
//    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:4];
//    
//    [param setValue:operateType forKey:@"operateType"];
//    [param setValue:passwordFlg forKey:@"passwordFlg"];
//    [param setValue:doCheck forKey:@"doCheck"];
//    [param setValue:[CustomerVo getDictionaryData:customer] forKey:@"customer"];
//    
//    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
//}

-(void) delMemberInfo:(NSString *)customerId cardId:(NSString*) cardId completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"customer/deleteById"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:customerId forKey:@"customerId"];
    [param setValue:cardId forKey:@"cardId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectCardCancelDetail:(NSString *)customerId completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"cardCancel/cardDetailSelect"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:customerId forKey:@"customerId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
    
}

-(void) doCardCancel:(NSString *)cardId lastVer:(NSString *)lastVer amount:(NSString *)amount mobile:(NSString *)mobile customerName:(NSString *)customerName comments:(NSString*) comments token:(NSString*) token completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"cardCancel/cancelOperate"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:5];
    
    [param setValue:cardId forKey:@"cardId"];
    [param setValue:lastVer forKey:@"lastVer"];
    [param setValue:amount forKey:@"amount"];
    [param setValue:mobile forKey:@"mobile"];
    [param setValue:customerName forKey:@"customerName"];
    [param setValue:comments forKey:@"comments"];
    [param setValue:token forKey:@"token"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void)doCardLoss:(NSString *)cardId lastVer:(NSString *)lastVer operate:(NSString *)operate code:(NSString *)code mobile:(NSString *)mobile completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"customer/operate"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:5];
    
    [param setValue:cardId forKey:@"cardId"];
    [param setValue:lastVer forKey:@"lastVer"];
    [param setValue:operate forKey:@"operate"];
    [param setValue:code forKey:@"code"];
    [param setValue:mobile forKey:@"mobile"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
    
}

-(void) selectRechargeSalesList:(NSString *)showDateRange completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"saleRecharge/list"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:showDateRange forKey:@"showDateRange"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectRechargeSalesDetail:(NSString *)saleRechargeId completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"saleRecharge/detail"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:saleRechargeId forKey:@"saleRechargeId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//-(void) saveRechargeSales:(NSString *)operateType saleRecharge:(SaleRechargeVo *)saleRecharge completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
//{
//    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"saleRecharge/save"];
//    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
//    
//    [param setValue:operateType forKey:@"operateType"];
//    [param setValue:[SaleRechargeVo getDictionaryData:saleRecharge] forKey:@"saleRecharge"];
//    
//    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
//}

-(void) delRechargeSales:(NSString *)saleRechargeId lastVer:(NSString *)lastVer completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"saleRecharge/delete"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:saleRechargeId forKey:@"saleRechargeId"];
    [param setValue:lastVer forKey:@"lastVer"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) doRecharge:(NSString *)cardId lastVer:(NSString *)lastVer amount:(NSString *)amount presentAmount:(NSString *)presentAmount presentPoint:(NSString *)presentPoint rechargeRuleId:(NSString *)rechargeRuleId chargeTime:(NSString *)chargeTime payMode:(NSString *)payMode token:(NSString*) token completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"customer/recharge"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:8];
    
    [param setValue:cardId forKey:@"cardId"];
    [param setValue:lastVer forKey:@"lastVer"];
    [param setValue:amount forKey:@"amount"];
    [param setValue:presentAmount forKey:@"presentAmount"];
    [param setValue:presentPoint forKey:@"presentPoint"];
    [param setValue:rechargeRuleId forKey:@"rechargeRuleId"];
    [param setValue:chargeTime forKey:@"chargeTime"];
    [param setValue:payMode forKey:@"payMode"];
    [param setValue:token forKey:@"token"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectMemberRedRecharge:(NSString *)moneyFlowId completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"customerRed/chargeRecordDetailSelect"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:moneyFlowId forKey:@"moneyFlowId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) doMemberRedRecharge:(NSString *)moneyFlowId lastVer:(NSString *)lastVer completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"customerRed/redOperate"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:moneyFlowId forKey:@"moneyFlowId"];
    [param setValue:lastVer forKey:@"lastVer"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectDegreeGoodsList:(NSString *)searchType searchCode:(NSString *)searchCode completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"customer/v1/goodsGiftList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    if (![searchType isEqualToString:@""]) {
        [param setValue:searchType forKey:@"searchType"];
    }
    
    if (![searchCode isEqualToString:@""]) {
        [param setValue:searchCode forKey:@"searchCode"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

- (void)saveDegreeGoodsWith:(NSDictionary *)param completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"gift/giftSet"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) cancelDegreeGoods:(NSString *)goodsId completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"customer/v1/cancelGiftSet"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:goodsId forKey:@"goodsId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void)selectGiftGoodsList:(NSString *)point completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"customer/giftList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:point forKey:@"point"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) doExchangeGiftGoods:(NSString *)cardId shopId:(NSString *)shopId lastVer:(NSString *)lastVer goodsGiftList:(NSMutableArray *)goodsGiftList token:(NSString*) token completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"customer/v1/exchange"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:cardId forKey:@"cardId"];
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:lastVer forKey:@"lastVer"];
    [param setValue:goodsGiftList forKey:@"goodsGiftList"];
    [param setValue:token forKey:@"token"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
@end
