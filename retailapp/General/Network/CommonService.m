//
//  CommonService.m
//  retailapp
//
//  Created by hm on 15/10/12.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "CommonService.h"

@implementation CommonService
//添加查看服鞋商品详情
- (void)selectCloShoes:(NSString *)styleCode
        withSourceFrom:(NSString *)sourceFrom
          withSourceId:(NSString *)sourceId
            withShopId:(NSString *)shopId
          withSupplyId:(NSString *)supplyId
          withInShopId:(NSString *)inShopId
           withIsThird:(BOOL)isThird
        withGoodsPrice:(double)goodsPrice
     completionHandler:(HttpResponseBlock)completionBlock
          errorHandler:(HttpErrorBlock)errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:6];
    [param setValue:styleCode forKey:@"styleCode"];
    [param setValue:sourceFrom forKey:@"sourceFrom"];
    [param setValue:sourceId forKey:@"sourceId"];
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:supplyId forKey:@"supplyId"];
    [param setValue:inShopId forKey:@"inShopId"];
    [param setValue:[NSNumber numberWithBool:isThird] forKey:@"isThird"];
    [param setValue:[NSNumber numberWithDouble:goodsPrice] forKey:@"goodsPrice"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"logisticsStock/shoesCloGoodsDetail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在加载..."];
}

- (void)selectSupplyList:(NSString*)keyWord shopId:(NSString *)shopId page:(NSInteger)currentPage supplyFlag:(NSString *)supplyFlag completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    if ([NSString isNotBlank:keyWord]) {
        [param setValue:keyWord forKey:@"keyWord"];
    }
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:[NSNumber numberWithInteger:currentPage] forKey:@"currentPage"];
    [param setValue:supplyFlag forKey:@"supplyFlg"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"supplyinfoManage/selectSupply"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在加载..."];
}

//选择门店/仓库
- (void)selectShopStoreList:(NSString*)orgId keyWord:(NSString*)keyWord page:(NSInteger)currentPage lastCreateTime:(long)lastCreateTime notInclude:(BOOL)notInclude completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:5];
    [param setValue:orgId forKey:@"orgId"];
    if ([NSString isNotBlank:keyWord]) {
        [param setValue:keyWord forKey:@"keyWord"];
    }
    [param setValue:[NSNumber numberWithInteger:currentPage] forKey:@"currentPage"];
    [param setValue:[NSNumber numberWithLong:lastCreateTime] forKey:@"lastCreateTime"];
    [param setValue:[NSNumber numberWithBool:notInclude] forKey:@"notInclude"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"shop/getShopAndWareHouse"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在加载"];
}

//选择仓库
- (void)selectStoreListByParams:(NSMutableDictionary *)param completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"wareHouse/getWareHouseList"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在加载"];
}

//选择下级门店仓库
- (void)selectNextLevelShopStoreByParam:(NSMutableDictionary *)param completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"shop/getNextLevelShopWareHouse"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在加载..."];
}


- (void)exportInfo:(NSMutableDictionary*)param withUrl:(NSString*)url
{
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:nil errorHandler:nil];
}

- (void)selectSupplyTypeList:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"supplyinfoManage/getSupplyType"];
    [[HttpEngine sharedEngine] postUrl:url params:nil completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在加载..."];
}

- (void)saveSupplyType:(NSString *)typeName completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:typeName forKey:@"typeName"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"supplyinfoManage/addSupplyType"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在保存..."];
}

- (void)deleteSupplyType:(NSString *)dicItemId withSupplyType:(NSString *)supplyType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:dicItemId forKey:@"dicItemId"];
    [param setValue:supplyType forKey:@"supplyType"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"supplyinfoManage/deleteSupplyType"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在删除..."];
}

- (void)selectReasonListByCode:(NSString *)dicCode completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:dicCode forKey:@"code"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"logisticsReson/resonList"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在加载..."];
}

- (void)addReasonByCode:(NSString *)dicCode withReasonName:(NSString *)reasonName completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:dicCode forKey:@"code"];
    [param setValue:reasonName forKey:@"resonName"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"logisticsReson/resonAdd"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在保存..."];
}

- (void)deleteReasonById:(NSString *)dicItemId withCode:(NSString *)dicCode completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:dicItemId forKey:@"dicItemId"];
    [param setValue:dicCode forKey:@"code"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"logisticsReson/resonDel"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在删除..."];
}

- (void)selectGoodsLastCategoryInfo:(NSString *)hasNoCategory completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:@"1" forKey:@"hasNoCategory"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"category/lastCategoryInfo"];
   [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//选择调拨商品
-(void) selectAllocateGoodsList:(NSString *)searchType shopId:(NSString *)shopId toShopId:(NSString *)toShopId searchCode:(NSString *)searchCode barCode:(NSString *)barCode categoryId:(NSString *)categoryId createTime:(NSString *)createTime completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"goods/listCallInGoods"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:7];
    
    [param setValue:searchType forKey:@"searchType"];
    
    if ([NSString isNotBlank:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    
    if ([NSString isNotBlank:toShopId]) {
        [param setValue:toShopId forKey:@"toShopId"];
    }
    
    if ([NSString isNotBlank:searchCode]) {
        [param setValue:searchCode forKey:@"searchCode"];
    }
    if ([NSString isNotBlank:barCode]) {
        [param setValue:barCode forKey:@"barCode"];
    }
    if ([NSString isNotBlank:categoryId]) {
        [param setValue:categoryId forKey:@"categoryId"];
    }
    if ([NSString isNotBlank:createTime]) {
        [param setValue:createTime forKey:@"createTime"];
    }
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];

}

//选择商品列表
- (void)selectGoodsList:(NSMutableDictionary *)params completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"goods/list"];
    [[HttpEngine sharedEngine] postUrl:url params:params completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在加载..."];
}

//获取系统参数值
- (void)selectMultiConfigListStatus:(NSMutableDictionary *)params  completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"config/multiConfigListStatus"];
    [[HttpEngine sharedEngine] postUrl:url params:params completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在加载..."];
}

//查询上级机构
- (void)selectParentOrgList:(NSMutableDictionary *)params completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"organization/selectParentListOpenAllowSupply"];
    [[HttpEngine sharedEngine] postUrl:url params:params completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在加载..."];
}

@end
