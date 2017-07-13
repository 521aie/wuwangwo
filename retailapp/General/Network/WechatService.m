//
//  WechatService.m
//  retailapp
//
//  Created by Jianyong Duan on 15/10/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "WechatService.h"
#import "MicroOrderDealVo.h"
#import "UserOrderOptVo.h"

@implementation WechatService

- (void)selectMicroStyleListWithCompletionHandler:(HttpResponseBlock) completionBlock
                                     errorHandler:(HttpErrorBlock) errorBlock {
    [self selectMicroStyleList:@1 shopId:nil searchCode:nil categoryId:nil applySex:nil year:nil seasonValId:nil minHangTagPrice:nil maxHangTagPrice:nil createTime:nil completionHandler:completionBlock errorHandler:errorBlock];
}

- (void)selectMicroStyleList:(NSNumber *)searchType
                      shopId:(NSString *)shopId
                  searchCode:(NSString *)searchCode
                  categoryId:(NSString *)categoryId
                    applySex:(NSNumber *)applySex
                        year:(NSString *)year
                 seasonValId:(NSString *)seasonValId
             minHangTagPrice:(NSNumber *)minHangTagPrice
             maxHangTagPrice:(NSNumber *)maxHangTagPrice
                  createTime:(NSNumber *)createTime
           completionHandler:(HttpResponseBlock) completionBlock
                errorHandler:(HttpErrorBlock) errorBlock {
    
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microStyle/list"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:10];
    if ([ObjectUtil isNotNull:searchType]) {
        [param setValue:searchType forKey:@"searchType"];
    }
    if (shopId && [ObjectUtil isNotNull:shopId]&&![shopId isEqual:@""]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    if (searchCode && [ObjectUtil isNotNull:searchCode] && ![searchCode isEqual:@""]) {
        [param setValue:searchCode forKey:@"searchCode"];
    }
    if (categoryId && [ObjectUtil isNotNull:categoryId] && ![categoryId isEqual:@""]) {
        [param setValue:categoryId forKey:@"categoryId"];
    }
    if (applySex && [ObjectUtil isNotNull:applySex] && ![applySex isEqual:@""]) {
        [param setValue:applySex forKey:@"applySex"];
    }
    if (year && [ObjectUtil isNotNull:year] && ![year isEqual:@""]) {
        [param setValue:year forKey:@"year"];
    }
    if (seasonValId && [ObjectUtil isNotNull:seasonValId] && ![seasonValId isEqual:@""]) {
        [param setValue:seasonValId forKey:@"seasonValId"];
    }
    if (minHangTagPrice && [ObjectUtil isNotNull:minHangTagPrice] && ![minHangTagPrice isEqual:@""]) {
        [param setValue:minHangTagPrice forKey:@"minHangTagPrice"];
    }
    if (maxHangTagPrice && [ObjectUtil isNotNull:maxHangTagPrice] && ![maxHangTagPrice isEqual:@""]) {
        [param setValue:maxHangTagPrice forKey:@"maxHangTagPrice"];
    }
    if (createTime && [ObjectUtil isNotNull:createTime] && ![createTime isEqual:@""]) {
        [param setValue:createTime forKey:@"createTime"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//查询微店申请记录
- (void)selectMicroShop:(NSString *)shopId
               entityId:(NSString *)entityId
      completionHandler:(HttpResponseBlock) completionBlock
           errorHandler:(HttpErrorBlock) errorBlock {
    
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microShop/select"];
    
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    if ([ObjectUtil isNotNull:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    if ([ObjectUtil isNotNull:entityId]) {
        [param setValue:entityId forKey:@"entityId"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//申请开通微店
- (void)saveMicroShop:(MicroShopVo *)microShopVo
          operateType:(NSString *)operateType
    completionHandler:(HttpResponseBlock) completionBlock
         errorHandler:(HttpErrorBlock) errorBlock {
    
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microShop/save"];
    
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:[microShopVo toDictionary] forKey:@"microShop"];
    [param setValue:operateType forKey:@"operateType"];
    
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//获取微店配送信息
- (void)selectExpress:(NSString *)shopId
    completionHandler:(HttpResponseBlock) completionBlock
         errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microShop/selectExpress"];
    
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    if ([ObjectUtil isNotNull:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
//获取微店配送字典信息
- (void)selectDicList:(NSString *) shopId
    completionHandler:(HttpResponseBlock) completionBlock
         errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microShop/selectDicList"];
             
    [[HttpEngine sharedEngine] postUrl:url params:nil completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
//更新微店配送信息
- (void)editExpress:(ExpressVo *)express
  completionHandler:(HttpResponseBlock) completionBlock
       errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microShop/editExpress"];
    
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:[express toDictionary] forKey:@"express"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//微店订单处理
- (void)selectMicroOrderDeal:(NSString *)keyWord
                lastDateTime:(long)lastDateTime
           completionHandler:(HttpResponseBlock) completionBlock
                errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microOrderDeal/list"];
    
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    if ([NSString isNotBlank:keyWord]) {
        [param setValue:keyWord forKey:@"keyWord"];
    }
    if (lastDateTime > 0) {
        [param setValue:[NSString stringWithFormat:@"%ld", lastDateTime] forKey:@"lastDateTime"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//保存微店订单处理
- (void)saveMicroOrderDeal:(NSArray *)microOrderDealVoList
         completionHandler:(HttpResponseBlock) completionBlock
              errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microOrderDeal/save"];
    
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSMutableArray *list = [NSMutableArray array];
    for (MicroOrderDealVo *deal in microOrderDealVoList) {
        
        
        [list addObject:@{@"shopId":deal.shopId, @"shopType":[NSNumber numberWithInt:deal.shopType], @"name":deal.name, @"code":deal.code}];
    }
    
    [param setValue:list forKey:@"microOrderDealVoList"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//删除微店订单处理
- (void)deleteMicroOrderDeal:(int)orderDealId
           completionHandler:(HttpResponseBlock) completionBlock
                errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microOrderDeal/delete"];
    
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:[NSString stringWithFormat:@"%d", orderDealId] forKey:@"orderDealId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//商品评价列表
- (void)selectCommentReport:(NSInteger)startTime
                    endTime:(NSInteger)endTime
                   lastTime:(NSInteger)lastTime
                     shopId:(NSString *)shopId
                    keyWord:(NSString *)keyWord
                    barCode:(NSString *)barCode
          completionHandler:(HttpResponseBlock) completionBlock
               errorHandler:(HttpErrorBlock) errorBlock {
    
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"commentReport/list"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:6];
    if (startTime > 0) {
        [param setValue:[NSNumber numberWithInteger:startTime] forKey:@"startTime"];
    }
    if (endTime > 0) {
        [param setValue:[NSNumber numberWithInteger:endTime] forKey:@"endTime"];
    }
    if (lastTime > 0) {
        [param setValue:[NSNumber numberWithInteger:lastTime] forKey:@"lastTime"];
    }
    if ([ObjectUtil isNotNull:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    if ([ObjectUtil isNotNull:keyWord]) {
        [param setValue:keyWord forKey:@"keyWord"];
    }
    if ([ObjectUtil isNotNull:barCode]) {
        [param setValue:barCode forKey:@"barCode"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//会员评价列表
- (void)selectCustomerComment:(NSInteger)startTime
                      endTime:(NSInteger)endTime
                     lastTime:(NSInteger)lastTime
                 commentLevel:(NSInteger)commentLevel
                      goodsId:(NSString *)goodsId
                       shopId:(NSString *)shopId
            completionHandler:(HttpResponseBlock) completionBlock
                 errorHandler:(HttpErrorBlock) errorBlock {
    
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"customerComment/list"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:6];
    if (startTime > 0) {
        [param setValue:[NSNumber numberWithInteger:startTime] forKey:@"startTime"];
    }
    if (endTime > 0) {
        [param setValue:[NSNumber numberWithInteger:endTime] forKey:@"endTime"];
    }
    if (lastTime > 0) {
        [param setValue:[NSNumber numberWithInteger:lastTime] forKey:@"lastTime"];
    }
    if (commentLevel > 0) {
        [param setValue:[NSNumber numberWithInteger:commentLevel] forKey:@"commentLevel"];
    }
    if ([ObjectUtil isNotNull:goodsId]) {
        [param setValue:goodsId forKey:@"goodsId"];
    }
    if ([ObjectUtil isNotNull:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//获取微店基本设置
- (void)WechatBaseSetcompletionHandler:(HttpResponseBlock) completionBlock
                          errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microBasicSet/v1/list"];
    [[HttpEngine sharedEngine] postUrl:url params:nil completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//保存微店基本设置
- (void)SaveWechatBaseSet:(NSDictionary *)param completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microBasicSet/v1/save"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock];
}

//更具code查找微店设置
- (void)SelectCode:(NSString*)code completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microBasicSet/selectByCode"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:code forKey:@"code"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//微店商品管理（款式）在售款式数量
-(void) selectStyleCount:(NSString*) shopId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microStyle/saleCount"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if ([NSString isNotBlank:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//微店商品管理（款式）详情

-(void) selectWechatGoodsStyleDetail:(NSString*) shopId StyleId:(NSString*) StyleId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microStyle/styleDetail"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:StyleId forKey:@"styleId"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//微店商品管理（款式）详情保存
//-(void) SaveWechatGoodsStyleDetail:(NSString*) shopId microStyleVo:(NSDictionary*) microStyleVo token:(NSString *)token completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
//{
//    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microStyle/save"];
//    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
//    
//    [param setValue:shopId forKey:@"shopId"];
//    [param setValue:microStyleVo forKey:@"microStyleVo"];
//    [param setValue:token forKey:@"token"];
//    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
//}

//微店商品管理（款式）详情图片列表
-(void) selectInfoImageList:(NSString*) styleId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microStyle/infoImageList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:styleId forKey:@"styleId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//微店商品管理（款式）详情图片保存
-(void) saveMicroStylePictures:(NSString*) shopId MicroStyleVo:(NSDictionary*) microStyleVo completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microStyle/saveInfoImageList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:microStyleVo forKey:@"microStyleVo"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//微店商品管理（款式）颜色图片列表
-(void) selectInfoImageColorList:(NSString*) styleId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microStyle/colorImageList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:styleId forKey:@"styleId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//微店商品管理（款式）颜色图片保存
-(void) saveMicroStyleColorPictures:(NSString*) shopId MicroStyleVo:(NSDictionary*) microStyleVo completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microStyle/saveColorImageList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:microStyleVo forKey:@"microStyleVo"];
    
    //新接口加的参数标志 以后有可能被遗弃新接口传2 老接口传1
    [param setValue:@2 forKey:@"interface_version"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//微店商品管理（款式）批量更新微店款式上下架状态
-(void) setMicroStyleUpDownStatus:(NSMutableArray*) styleIdList shopId:(NSString*) shopId status:(NSString *) status completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microStyle/setUpDownStatus"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:styleIdList forKey:@"styleIdList"];
    [param setValue:status forKey:@"isShelve"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//微店商品管理（款式）批量设置微店款式不销售
-(void) setNotSaleMicroStyle:(NSMutableArray*) StyleIdList shopId:(NSString*) shopId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microStyle/setNotSale"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:shopId forKey:@"shopId"];
    // [param setValue:StyleIdList forKey:@"goodsIdList"];
    [param setValue:StyleIdList forKey:@"styleIdList"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}


//商品数量
-(void) selectGoodsCount:(NSString*) shopId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microGoods/saleCount"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:shopId forKey:@"shopId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
//微店商品详情一览
-(void) selectGoodsList:(NSString *)searchType shopId:(NSString *)shopId searchCode:(NSString *)searchCode categoryId:(NSString *)categoryId createTime:(NSString *)createTime completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microGoods/list"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:5];
    if ([NSString isNotBlank:searchType]) {
        [param setValue:searchType forKey:@"searchType"];
    }
    
    if ([NSString isNotBlank:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    if ([NSString isNotBlank:searchCode]) {
        [param setValue:searchCode forKey:@"searchCode"];
    }
    if ([NSString isNotBlank:categoryId]) {
       [param setValue:categoryId forKey:@"categoryId"];
    }
    if ([NSString isNotBlank:createTime]) {
        [param setValue:createTime forKey:@"createTime"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//商品分类
-(void) selectCategoryList:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"category/list"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:0];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//微店商品管理（商品）详情
-(void) selectWechatGoodsDetail:(NSString*) shopId goodsId:(NSString*) goodsId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString *url=[NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microGoods/goodsDetail"];
    NSMutableDictionary *param=[NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:goodsId forKey:@"goodsId"];
    [[HttpEngine  sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
//微店商品管理（商品）价格检查
-(void) checkPrice:(NSString*) shopId goodsId:(NSString*) goodsId microPrice:(NSString *) microPrice completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString *url=[NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microGoods/checkPrice"];
    NSMutableDictionary *param=[NSMutableDictionary dictionaryWithCapacity:3];
    [param setValue:goodsId forKey:@"goodsId"];
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:microPrice forKey:@"microPrice"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
//更新或添加微店商品
-(void) selectWechatGoodsSaveOrUpdate:(NSDictionary*) microGoodsVo completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString *url=[NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microGoods/save"];
    NSMutableDictionary *param=[NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:microGoodsVo forKey:@"microGoodsVo"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock
                           withMessage:nil];
    
}
//微店商品管理（商品）详情图片列表
-(void) selectWechatGoodsPictureList:(NSString*) goodsId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microGoods/infoImageList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:goodsId forKey:@"goodsId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//微店商品管理（商品）详情图片保存
-(void) updateOrAddWechatGoods:(NSString*) shopId microGoodsVo:(NSDictionary*) microGoodsVo completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microGoods/saveInfoImageList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:microGoodsVo forKey:@"microGoodsVo"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
    
}
//微店商品管理（商品）批量更新微店款式上下架状态
-(void) setMicroGoodsUpDownStatus:(NSMutableArray*) goodsIdList shopId:(NSString*) shopId isShelve:(NSString *) isShelve completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microGoods/setUpDownStatus"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [param setValue:goodsIdList forKey:@"goodsIdList"];
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:isShelve forKey:@"isShelve"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}



//微店商品管理（商品）批量设置微店款式不销售
-(void) setNotSaleMicroGoods:(NSMutableArray*) goodsIdList shopId:(NSString*) shopId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microGoods/setNotSale"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:goodsIdList forKey:@"goodsIdList"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}


- (void) selectLastCategoryInfo:(NSString*) hasNoCategory completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"category/lastCategoryInfo"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:hasNoCategory forKey:@"hasNoCategory"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//批量添加微店商品
-(void) batchAddWechatGoods:(NSString *)shopId goodsIdList:(NSMutableArray*) goodsIdList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString *url=[NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microGoods/saveBatch"];
    NSLog(@"batchAddWechatGoods");
    NSMutableDictionary *param=[NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:goodsIdList forKey:@"goodsIdList"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock];
}

//批量添加微店商品款式
-(void) batchAddWechatGoodsStyles:(NSString *)shopId styleIdList:(NSMutableArray*) styleIdList token:(NSString *)token completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString *url=[NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microStyle/saveBatch"];
    NSLog(@"batchAddWechatGoods");
    NSMutableDictionary *param=[NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:styleIdList forKey:@"styleIdList"];
    [param setValue:token forKey:@"token"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock];
}


-(void) selectGoodsList:(NSString *)searchType shopId:(NSString *)shopId searchCode:(NSString *)searchCode barCode:(NSString *)barCode categoryId:(NSString *)categoryId createTime:(NSString *)createTime completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microGoods/list"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:6];
    
    [param setValue:searchType forKey:@"searchType"];
    
    if (![NSString isBlank:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    if (![NSString isBlank:searchCode]) {
        [param setValue:searchCode forKey:@"searchCode"];
    }
    if (![NSString isBlank:barCode]) {
        [param setValue:barCode forKey:@"barCode"];
    }
    if (![NSString isBlank:categoryId]) {
        [param setValue:categoryId forKey:@"categoryId"];
    }
    if (![NSString isBlank:createTime]) {
        [param setValue:createTime forKey:@"createTime"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) deleteSelectStylesFromPack:(NSString*) salePackId styleIdList:(NSMutableArray*) styleIdList lastVer:(NSString*) lastVer completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microStyle/deleteSelectStylesFromSalePack"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [param setValue:salePackId forKey:@"salePackId"];
    
    [param setValue:styleIdList forKey:@"styleIdList"];
    
    [param setValue:lastVer forKey:@"lastVer"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectStyleImageInfo:(NSString*) styleId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microStyle/styleImageInfo"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:styleId forKey:@"styleId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) saveMainImageList:(NSDictionary*) microStyleVo completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microStyle/saveMainImageList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:microStyleVo forKey:@"microStyleVo"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) saveSalePackStyleList:(NSString*) salePackId styleIdList:(NSMutableArray*) styleIdList lastVer:(NSString*) lastVer completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microStyle/saveSalePackStyleList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:salePackId forKey:@"salePackId"];
    
    [param setValue:styleIdList forKey:@"styleIdList"];
    
    [param setValue:lastVer forKey:@"lastVer"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) addStylesToSalePackByCondition:(NSString*) shopId salePackId:(NSString*) salePackId categoryId:(NSString*) categoryId applySex:(NSString*) applySex year:(NSString*) year season:(NSString*) season minHangTagPrice:(NSString*) minHangTagPrice maxHangTagPrice:(NSString*) maxHangTagPrice prototypeValId:(NSString*) prototypeValId auxiliaryValId:(NSString*) auxiliaryValId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microStyle/addStylesToSalePackByCondition"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:8];
    
    if ([NSString isNotBlank:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    
    [param setValue:salePackId forKey:@"salePackId"];
    
    if ([NSString isNotBlank:categoryId]) {
        [param setValue:categoryId forKey:@"categoryId"];
    }
    
    if ([NSString isNotBlank:applySex]) {
        [param setValue:applySex forKey:@"applySex"];
    }
    
    if ([NSString isNotBlank:year]) {
        [param setValue:year forKey:@"year"];
    }
    
    if ([NSString isNotBlank:season]) {
        [param setValue:season forKey:@"season"];
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
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) addSelectStylesToSalePack:(NSString*) salePackId styleVoList:(NSMutableArray*) styleVoList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microStyle/addSelectStylesToSalePack"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:salePackId forKey:@"salePackId"];
    
    [param setValue:styleVoList forKey:@"styleVoList"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) deleteTempSelectStyles:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microStyle/deleteTempSelectStyles"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectSalePackDetail:(NSString*) salePackId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microStyle/salePackDetail"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:salePackId forKey:@"salePackId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) saveSalePackDetail:(NSDictionary*) salePackVo completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microStyle/saveSalePack"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:salePackVo forKey:@"salePackVo"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) delSalePack:(NSString*) salePackId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microStyle/deleteSalePack"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:salePackId forKey:@"salePackId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectSalePackStyleList:(NSString*) salePackId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microStyle/salePackStyleList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:salePackId forKey:@"salePackId"];
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) searchStyleInSalePack:(NSString*) salePackId searchCode:(NSString*) searchCode createTime:(NSString*) createTime completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microStyle/searchStyleInSalePack"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [param setValue:salePackId forKey:@"salePackId"];
    
    if ([NSString isNotBlank:searchCode]) {
        [param setValue:searchCode forKey:@"searchCode"];
    }
    
    if ([NSString isNotBlank:createTime]) {
        [param setValue:createTime forKey:@"createTime"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) selectSalePackList:(NSString*) searchCode completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microStyle/salePackList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if ([NSString isBlank:searchCode]) {
        [param setValue:@"" forKey:@"searchCode"];
    }else{
        [param setValue:searchCode forKey:@"searchCode"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

-(void) addSalePacksToSale:(NSMutableArray*) styleIdList shopId:(NSString*) shopId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microStyle/addSalePacksToSale"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:styleIdList forKey:@"salePackIdList"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}


-(void) selectWechatCommonGoods:(NSString *)searchType shopId:(NSString *)shopId searchCode:(NSString *)searchCode barCode:(NSString *)barCode categoryId:(NSString *)categoryId createTime:(NSString *)createTime completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"goods/list"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:6];
    
    [param setValue:searchType forKey:@"searchType"];
    
    if (![NSString isBlank:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    if (![NSString isBlank:searchCode]) {
        [param setValue:searchCode forKey:@"searchCode"];
    }
    if (![NSString isBlank:barCode]) {
        [param setValue:barCode forKey:@"barCode"];
    }
    if (![NSString isBlank:categoryId]) {
        [param setValue:categoryId forKey:@"categoryId"];
    }
    if (![NSString isBlank:createTime]) {
        [param setValue:createTime forKey:@"createTime"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

#pragma mark - 微店订单管理
//订单一览
- (void)selectOrderList:(NSString *)shopId
              searchKey:(NSString *)searchKey
             searchType:(int)searchType
                 status:(int)status
              orderType:(int)orderType
           lessDateTime:(long long)lessDateTime
           lastDateTime:(long long)lastDateTime
               shopType:(int)shopType
      completionHandler:(HttpResponseBlock) completionBlock
           errorHandler:(HttpErrorBlock) errorBlock {
    
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderManagement/orderList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:7];
    
    [param setValue:shopId forKey:@"shopId"];
    
    if ([NSString isNotBlank:searchKey]) {
        [param setValue:searchKey forKey:@"searchKey"];
        [param setValue:[NSNumber numberWithInt:searchType] forKey:@"searchType"];
    }
    if (status > 0) {
        [param setValue:[NSNumber numberWithInt:status] forKey:@"status"];
    }
    if (orderType > 0) {
        [param setValue:[NSNumber numberWithInt:orderType] forKey:@"orderType"];
    }
    if (lessDateTime > 0) {
        [param setValue:[NSNumber numberWithLongLong:lessDateTime] forKey:@"lessDateTime"];
    }
    if (lastDateTime > 0) {
        [param setValue:[NSNumber numberWithLongLong:lastDateTime] forKey:@"lastDateTime"];
    }
    if (shopType > 0) {
        [param setValue:[NSNumber numberWithInt:shopType] forKey:@"shopType"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//订单详情
- (void)selectOrderDetail:(NSString *)orderId
                orderType:(int)orderType
                   shopId:(NSString *)shopId
        completionHandler:(HttpResponseBlock) completionBlock
             errorHandler:(HttpErrorBlock) errorBlock {
    
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderManagement/orderDetail"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    
    if (orderId) {
        [param setValue:orderId forKey:@"orderId"];
    }
    
    if (orderType > 0) {
        [param setValue:[NSNumber numberWithInt:orderType] forKey:@"orderType"];
    }
    
    if (shopId) {
        [param setValue:shopId forKey:@"shopId"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//销售订单操作
- (void)sellOrderOperate:(NSString *)orderId
                  shopId:(NSString *)shopId
             operateType:(NSString *)operateType
               rejReason:(NSString *)rejReason
                    code:(NSString *)code
               expansion:(NSString *)expansion
              employeeId:(NSString *)employeeId
                 lastVer:(long)lastVer
                  outFee:(NSString *)outFee
            userOrderOpt:(NSDictionary *) userOrderOpt
       completionHandler:(HttpResponseBlock) completionBlock
            errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderManagement/sellOrderOperate"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:8];
    
    if (orderId) {
        [param setValue:orderId forKey:@"orderId"];
    }
    if (operateType) {
        [param setValue:operateType forKey:@"operateType"];
    }
    if (rejReason) {
        [param setValue:rejReason forKey:@"rejReason"];
    }
    if (code) {
        [param setValue:code forKey:@"code"];
    }
    if (expansion) {
        [param setValue:expansion forKey:@"expansion"];
    }
    if (employeeId) {
        [param setValue:employeeId forKey:@"employeeId"];
    }
    if ([NSString isBlank:outFee]) {
        [param setValue:@"0" forKey:@"outFee"];
    }else{
        [param setValue:outFee forKey:@"outFee"];
    }
    [param setValue:shopId forKey:@"shopId"];
    
    [param setValue:[NSNumber numberWithLong:lastVer] forKey:@"lastVer"];
    if(userOrderOpt!=nil){
        [param setValue:userOrderOpt forKey:@"userOrderOpt"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//供货订单操作
//- (void)divideOrderOperate:(NSString *)orderId
//                  divideId:(NSString*)divideId
//               operateType:(NSString *)operateType
//                 rejReason:(NSString *)rejReason
//                      code:(NSString *)code
//           divideExpansion:(NSString *)divideExpansion
//                   lastVer:(long)lastVer
//             divideLastVer:(long)divideLastVer
//            divideCode:(NSString *)divideCode
//               divideCount:(NSInteger)divideCount
//               orderShopId:(NSString *)orderShopId
//                    shopId:(NSString *)shopId
//              userOrderOpt:(NSDictionary *) userOrderOpt
//                divideCode:(NSString *)newCode
//                 expansion:(NSDictionary *)expansion
//         completionHandler:(HttpResponseBlock) completionBlock
//              errorHandler:(HttpErrorBlock) errorBlock {
//    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderManagement/divideOrderOperate"];
//    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:11];
//    
//    if (orderId) {
//        [param setValue:orderId forKey:@"orderId"];
//    }
////    [param setValue:divideId forKey:@"divideId"];
//    if (operateType) {
//        [param setValue:operateType forKey:@"operateType"];
//    }
//    if (rejReason) {
//        [param setValue:rejReason forKey:@"rejReason"];
//    }
//    if (code) {
//        [param setValue:code forKey:@"code"];
//    }
//    
//    if (divideExpansion) {
//        [param setValue:divideExpansion forKey:@"divideExpansion"];
//    }
//    id outFee = expansion[@"outFee"];
//    double freight = [outFee doubleValue];
//    [param setValue:@(freight) forKey:@"freight"];
//    if ([ObjectUtil isNull:outFee]) {//店家配送传1 第三方物流传2
//        [param setValue:@1 forKey:@"sendType"];
//    } else {
//        [param setValue:@2 forKey:@"sendType"];
//    }
//    
//    [param setValue:[NSNumber numberWithLong:lastVer] forKey:@"lastVer"];
////    [param setValue:[NSNumber numberWithLong:divideLastVer] forKey:@"divideLastVer"];
////    [param setValue:[NSNumber numberWithLong:divideCount] forKey:@"divideCount"];
//    if (orderShopId) {
//        [param setValue:orderShopId forKey:@"orderShopId"];
//    }
//    if (shopId) {
//        [param setValue:shopId forKey:@"shopId"];
//    }
//    if(userOrderOpt!=nil){
//         [param setValue:userOrderOpt forKey:@"userOrderOpt"];
//    }
////    if (divideCode) {
////        [param setValue:divideCode forKey:@"divideCode"];
////    }
//    for (NSString*str in [expansion allKeys]) {
//        if ([str isEqualToString:@"employeeId"]) {
//             [param setValue:expansion[@"employeeId"] forKey:@"employeeId"];
//        }
//    }
//   
//    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
//}

//积分兑换订单管理列表
- (void)selectIntegralOrderList:(NSMutableDictionary *)param completionHandler:(HttpResponseBlock) completionBlock
                   errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderManagement/integralNewOrderList"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//拒绝原因
- (void)selectRefuseReson:(NSString *)entityId
        completionHandler:(HttpResponseBlock) completionBlock
             errorHandler:(HttpErrorBlock) errorBlock {
    
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microShop/selectRefuseReson"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if (entityId) {
        [param setValue:entityId forKey:@"entityId"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//添加拒绝原因
- (void)addRefuseReson:(NSString *)entityId
                reason:(NSString *)reason
     completionHandler:(HttpResponseBlock) completionBlock
          errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microShop/addRefuseReson"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    if (entityId) {
        [param setValue:entityId forKey:@"entityId"];
    }
    if (reason) {
        [param setValue:reason forKey:@"resonName"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//订单处理门店仓库一览
//- (void)selectOpShopWareList:(NSString *)goodsId
//                     keyword:(NSString *)keyword
//              lastCreateTime:(long long)lastCreateTime
//           completionHandler:(HttpResponseBlock) completionBlock
//                errorHandler:(HttpErrorBlock) errorBlock {
//    
//    if ([NSString isBlank:goodsId]) {
//        //调用整单配送订单处理列表
//        [self selectShopWareList:keyword lastDateTime:lastCreateTime completionHandler:completionBlock errorHandler:errorBlock];
//        return;
//    }
//    
//    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderManagement/opShopWareList"];
//    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
//    
//    if (goodsId) {
//        [param setValue:goodsId forKey:@"goodsId"];
//    }
//    if (keyword) {
//        [param setValue:keyword forKey:@"searchKey"];
//    }
//    if (lastCreateTime > 0) {
//        [param setValue:[NSNumber numberWithLongLong:lastCreateTime] forKey:@"lastCreateTime"];
//    }
//    
//    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
//}

//手动分单
//- (void)manualSplit:(NSString *)orderId
//     showTypeVoList:(NSArray *)showTypeVoList
//  completionHandler:(HttpResponseBlock) completionBlock
//       errorHandler:(HttpErrorBlock) errorBlock {
//    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderManagement/manualSplit"];
//    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
//    
//    if (orderId) {
//        [param setValue:orderId forKey:@"orderId"];
//    }
//    //OrderDivideVo
//    if ([ObjectUtil isNotEmpty:showTypeVoList]) {
//        NSMutableArray *array = [NSMutableArray arrayWithCapacity:showTypeVoList.count];
//        for (OrderDivideVo *orderDivideVo in showTypeVoList) {
//            [array addObject:[orderDivideVo toDictionary]];
//        }
//        [param setValue:array forKey:@"showTypeVoList"];
//    }
//    
//    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
//}

//重新分单
//- (void)reSplitOrder:(NSString *)orderId
//      showTypeVoList:(NSArray *)showTypeVoList
//         goodsIdList:(NSArray *)goodsIdList
//        divideIdList:(NSArray *)divideIdList
//   completionHandler:(HttpResponseBlock) completionBlock
//        errorHandler:(HttpErrorBlock) errorBlock {
//    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderManagement/reSplitOrder"];
//    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:4];
//    
//    if (orderId) {
//        [param setValue:orderId forKey:@"orderId"];
//    }
//    
//    NSMutableArray *array = [NSMutableArray arrayWithCapacity:showTypeVoList.count];
//    for (OrderDivideVo *orderDivideVo in showTypeVoList) {
//        [array addObject:[orderDivideVo toDictionary]];
//    }
//    [param setValue:array forKey:@"showTypeVoList"];
//    
//    if (goodsIdList) {
//        [param setValue:goodsIdList forKey:@"goodsIdList"];
//    }
//    if (divideIdList) {
//        [param setValue:divideIdList forKey:@"divideIdList"];
//    }
//    
//    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
//}

//查询包裹详情，选择分单信息
//- (void)selectPackageInfo:(NSString *)orderId
//        completionHandler:(HttpResponseBlock) completionBlock
//             errorHandler:(HttpErrorBlock) errorBlock {
//    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderManagement/selectPackageInfo"];
//    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
//    
//    if (orderId) {
//        [param setValue:orderId forKey:@"orderId"];
//    }
//    
//    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
//}

//微店整单订单处理列表
//- (void)selectShopWareList:(NSString *)keyword
//              lastDateTime:(long long)lastDateTime
//         completionHandler:(HttpResponseBlock) completionBlock
//              errorHandler:(HttpErrorBlock) errorBlock {
//    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderManagement/shopWareList"];
//    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
//    
//    if ([NSString isNotBlank:keyword]) {
//        [param setValue:keyword forKey:@"keyWord"];
//    }
//    
//    if (lastDateTime > 0) {
//        [param setValue:[NSNumber numberWithLongLong:lastDateTime] forKey:@"lastDateTime"];
//    }
//    
//    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
//}

//微店整单订单库存信息
//- (void)getStockInfoList:(NSString *)shopId
//             goodsIdList:(NSArray *)goodsIdList
//       completionHandler:(HttpResponseBlock) completionBlock
//            errorHandler:(HttpErrorBlock) errorBlock {
//    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderManagement/getStockInfoList"];
//    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
//    
//    if ([NSString isNotBlank:shopId]) {
//        [param setValue:shopId forKey:@"shopId"];
//    }
//    
//    if ([ObjectUtil isNotEmpty:goodsIdList]) {
//        [param setValue:goodsIdList forKey:@"goodsIdList"];
//    }
//    
//    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
//}

//根据分单Id列表查询商品详情
- (void)selectInstanceListByDivideIdList:(NSArray *)divideIdList
                       completionHandler:(HttpResponseBlock) completionBlock
                            errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microOrderDeal/selectInstanceListByDivideIdList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if ([ObjectUtil isNotEmpty:divideIdList]) {
        [param setValue:divideIdList forKey:@"divideIdList"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//根据商品Id列表和门店Id查询库存信息
- (void)selectStockInfoList:(NSString *)shopId
                goodsIdList:(NSArray *)goodsIdList
          completionHandler:(HttpResponseBlock) completionBlock
               errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microOrderDeal/selectStockInfoList"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    if ([NSString isNotBlank:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    
    if ([ObjectUtil isNotEmpty:goodsIdList]) {
        [param setValue:goodsIdList forKey:@"goodsIdList"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//上门自提待分配时确认接单
//- (void)orderManagement:(NSMutableDictionary *)param completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
//  NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderManagement/dealIsPickOrder"];
//    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
//}
@end
