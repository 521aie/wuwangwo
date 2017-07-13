//
//  StockService.m
//  retailapp
//
//  Created by guozhi on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "StockService.h"
#import "WareHouseVo.h"
#import "AllShopVo.h"
#import "StockAdjustDetailVo.h"
@implementation StockService
/*------------------虚拟库存管理---------*/
//虚拟库存一览
- (void)virtualStoreList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockInfo/virtualStoreList"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}


//库存查询
- (void)queryStockInfoList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockInfo/list"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在加载..."];
}

//款式库存信息查询
- (void)queryStockInfoDetailById:(NSString *)shopId withStyleId:(NSString *)styleId CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:styleId forKey:@"styleId"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockInfo/styleStockDetail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在加载..."];
}

//获取登陆门店的供货仓库
- (void)wareHouseCompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"wareHouse/getOrgWareHouse"];
   
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}



//库存调整一览
- (void)selectStockAdjustPaperList:(NSString *)shopId
                        withStatus:(short)billStatus
                      withOpUserId:(NSString *)opUserId
                    withAdjustDate:(NSString *)adjustDate
                          withPage:(NSInteger)currentPage
                 CompletionHandler:(HttpResponseBlock) completionBlock
                      errorHandler:(HttpErrorBlock) errorBlock
{
   NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:[NSNumber numberWithShort:billStatus] forKey:@"billStatus"];
    [param setValue:opUserId forKey:@"opUserId"];
    [param setValue:adjustDate forKey:@"adjustDate"];
    [param setValue:[NSNumber numberWithInteger:currentPage] forKey:@"currentPage"];
    NSString *url =[NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockAdjust/list"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在加载..."];
}

//库存调整单详情
- (void)selectStockAdjustDetailByCode:(NSString *)adjustCode CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:adjustCode forKey:@"adjustCode"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockAdjust/stockAdjustDetailList"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在加载..."];
}

//新增调整单
- (void)addAdjustPaperByShopId:(NSString *)shopId withAdjustTime:(long long)adjustTime withMemo:(NSString *)memo withCode:(NSString *)adjustCode withLastVer:(long)lastVer withToken:(NSString *)token CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:6];
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:[NSNumber numberWithLongLong:adjustTime] forKey:@"adjustTime"];
    [param setValue:memo forKey:@"memo"];
    [param setValue:adjustCode forKey:@"adjustCode"];
    [param setValue:[NSNumber numberWithLong:lastVer] forKey:@"lastVer"];
    [param setValue:token forKey:@"token"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockAdjust/save"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在保存..."];
}

- (void)checkStockAdjustPaperGoods:(NSString *)url params:(NSDictionary *)param completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock withMessage:(NSString*)message {
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:message];
}

//修改调整单商品
- (void)operateStockAdjustPaperByCode:(NSString *)adjustCode
                           withOpType:(short)opType
                 withModifyStatusOnly:(short)modifyStatusOnly
                          withLastVer:(long)lastVer
                 withAdjustTime:(long long)adjustTime
                          withMemo:(NSString *)memo
                       withDetailList:(NSMutableArray *)stockAdjustDetailList shopId:(NSString *)shopId
                            withToken:(NSString *)token
                          withMessage:(NSString *)message
                    CompletionHandler:(HttpResponseBlock) completionBlock
                         errorHandler:(HttpErrorBlock) errorBlock

{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:8];
    [param setValue:adjustCode forKey:@"adjustCode"];
    [param setValue:[NSNumber numberWithShort:opType] forKey:@"opType"];
    [param setValue:[NSNumber numberWithShort:modifyStatusOnly] forKey:@"modifyStatusOnly"];
    [param setValue:[NSNumber numberWithLong:lastVer] forKey:@"lastver"];
    [param setValue:[NSNumber numberWithLongLong:adjustTime] forKey:@"adjustTime"];
    [param setValue:memo forKey:@"memo"];
    [param setValue:[StockAdjustDetailVo converArrToDicArr:stockAdjustDetailList] forKey:@"stockAdjustDetailList"];
    [param setValue:token forKey:@"token"];
    [param setValue:shopId forKey:@"shopOrOrgId"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockAdjust/saveStockAdjustDetail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:message];
}

//款式调整详情
- (void)selectStyleAdjustDetail:(NSString *)shopId withAdjustCode:(NSString *)adjustCode withStyleId:(NSString *)styleId withStyleCode:(NSString *)styleCode CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:4];
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:adjustCode forKey:@"adjustCode"];
    [param setValue:styleId forKey:@"styleId"];
    [param setValue:styleCode forKey:@"styleCode"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockAdjust/styleAdjustDetail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在加载..."];
}

//删除调整单
- (void)deleteAdjustPaperByCode:(NSString *)adjustCode withToken:(NSString *)token CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:adjustCode forKey:@"adjustCode"];
    [param setValue:token forKey:@"token"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockAdjust/delete"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在删除..."];
}

//调整单原因一览
- (void)selectAdjustReasonListWithCallBack:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:@"" forKey:@"adjustReason"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockAdjust/adjustReasonList"];
    [[HttpEngine sharedEngine] postUrl:url params:nil completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在加载..."];
}

//添加调整原因
- (void)addAdjustReasonByName:(NSString *)adjustReason CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:adjustReason forKey:@"adjustReason"];
    NSString *url =[NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockAdjust/addAdjustReason"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在保存..."];
}

//删除调整原因
- (void)deleteAdjustReasonById:(NSString *)adjustReasonId CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:adjustReasonId forKey:@"adjustReasonId"];
    NSString *url =[NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockAdjust/deleteAdjustReason"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在删除..."];

}

//虚拟库存详情
- (void)storeDetail:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
 {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockInfo/virtualStoreDetail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//新增修改虚拟库存设置
- (void)saveVirtualStore:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockInfo/saveVirtualStore"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//删除虚拟库存
- (void)deleteVirtualStore:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockInfo/deleteVirtualStore"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

// 获取选择设置商品中的商品的最小实际库存：所有选中商品中实际库存最小的值
- (void)virtualStoreRange:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockInfo/batchVirtualStoreRange"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}


//积分商品库存一览
- (void)integralList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"degreeGoodsStore/list"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//积分商品库存详情
- (void)integralDetail:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"degreeGoodsStore/set"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}





//仓库一览
- (void)selectWarehouseListById:(NSString *)orgId withKeyWord:(NSString *)keyWord withPage:(NSInteger)currentPage CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    [param setValue:orgId forKey:@"orgId"];
    [param setValue:keyWord forKey:@"keyWord"];
    [param setValue:[NSNumber numberWithInteger:currentPage] forKey:@"currentPage"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"wareHouse/getWareHouseList"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在加载..."];
}

//仓库详情
- (void)selectWarehouseDetailById:(NSString *)warehouseId CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:warehouseId forKey:@"wareHouseId"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"wareHouse/detail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在加载..."];
}


//新增修改仓库详情
- (void)operateWarehouse:(NSString *)operateType
           withWareHouse:(WareHouseVo *)wareHouse
       CompletionHandler:(HttpResponseBlock) completionBlock
            errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:4];
    [param setValue:operateType forKey:@"operateType"];
    [param setValue:[WareHouseVo converToDic:wareHouse] forKey:@"wareHouse"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"wareHouse/save"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在保存..."];
}

//删除仓库验证
- (void)checkWareHouse:(NSString *)wareHouseId CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:wareHouseId forKey:@"wareHouseId"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"wareHouse/wareHouseExistLogistics"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在验证..."];
}

//删除仓库
- (void)deleteWareHouse:(NSString *)wareHouseId CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:wareHouseId forKey:@"wareHouseId"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"wareHouse/delete"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在删除..."];
}
//省市区列表
- (void)selelctAddressList:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"addressList"];
    [[HttpEngine sharedEngine] postUrl:url params:nil completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}


/**获取到期提醒商品列表	*/
- (void)alertList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockInfoAlert/getGoodsList"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在加载..."];
}

/** 提醒详情*/
- (void)alertDetail:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockInfoAlert/getAlert"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock ];
}

/** 提醒添加*/
- (void)alertEdit:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockInfoAlert/setAlert"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock];
}


/**
 *
 库存汇总查询
 */
- (void)storeSummaryList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockCollect/list"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在加载..."];
}

/**查询下属订单处理机构*/
- (void)getMicroOrderDealList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microOrderDeal/list4Choice"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock];
}

//查询登陆关联的订单处理机构
- (void)getSelfOpOrderShop:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
 {
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"microOrderDeal/getSelfOpOrderShop"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}


@end
