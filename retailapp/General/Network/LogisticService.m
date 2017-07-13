//
//  LogisticService.m
//  retailapp
//
//  Created by hm on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LogisticService.h"
@implementation LogisticService
//校验叫货商品
- (void)checkOrderGoodsById:(NSString *)supplyId withGoodsList:(NSMutableArray *)goodsList completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:supplyId forKey:@"supplyId"];
    [param setValue:goodsList forKey:@"goodsList"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderGoods/checkGoods"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在校验..."];
}

- (void)selectPaperStatusList:(NSString*)dicCode completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:dicCode forKey:@"code"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"logisticsStock/sheetStatus"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//查询叫货单列表
- (void)selectOrderPaperList:(NSString*)shopId
                 status:(short)billStatus
                 supplyId:(NSString*)supplyId
                 date:(NSNumber*)sendEndTime
                 page:(NSInteger)currentPage
                 type:(short)type
                   isNeedDel:(NSString *)isNeedDel
                 completionHandler:(HttpResponseBlock)completionBlock
                 errorHandler:(HttpErrorBlock)errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:[NSNumber numberWithShort:billStatus] forKey:@"billStatus"];
    [param setValue:supplyId forKey:@"supplyId"];
    [param setValue:[NSNumber numberWithInteger:currentPage] forKey:@"currentPage"];
    [param setValue:sendEndTime forKey:@"sendEndTime"];
    [param setValue:isNeedDel forKey:@"isNeedDel"];
    [param setValue:[NSNumber numberWithShort:type] forKey:@"type"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderGoods/list"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
//查询叫货单详情
- (void)selectOrderPaperDetail:(NSString*)orderGoodsId withType:(short)type isNeedDel:(NSString *)isNeedDel completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:orderGoodsId forKey:@"orderGoodsId"];
    [param setValue:[NSNumber numberWithShort:type] forKey:@"type"];
    [param setValue:isNeedDel forKey:@"isNeedDel"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderGoods/detail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//第一次保存单据信息
- (void)saveForAddGoods:(NSDictionary*)param completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{

    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderGoods/saveForAddGoods"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在保存..."];
}

//历史叫货单导入
- (void)importOrderPaperById:(NSString *)historyId completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:historyId forKey:@"historyId"];
    [param setValue:@"1" forKey:@"isNeedDel"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderGoods/import"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在导入..."];
}

//重新提交叫货单
- (void)resubmitOrderPaperByParam:(NSMutableDictionary *)param completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderGoods/reset"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在提交..."];
}

- (void)selectGoodsList:(NSString*)shopId
         withSearchCode:(NSString*)searchCode
         withCreateTime:(NSInteger)createTime
      completionHandler:(HttpResponseBlock)completionBlock
           errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"goods/list"];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:4];
    [param setValue:[NSNumber numberWithInteger:1] forKey:@"searchType"];
    [param setValue:shopId forKey:@"shopId"];
    if ([NSString isNotBlank:searchCode]) {
        [param setValue:searchCode forKey:@"searchCode"];
    }
    if (createTime>0) {
        [param setValue:[NSNumber numberWithInteger:createTime] forKey:@"createTime"];
    }
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}


- (void)checkPaperDetailGoods:(NSString *)url params:(NSDictionary *)param completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock withMessage:(NSString*)message {
    
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:message];
}


- (void)operatePaperDetail:(NSMutableDictionary*)param withUrl:(NSString*)url completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock withMessage:(NSString*)message
{
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:message];
}
//查询服鞋款式详情
- (void)selectShoesCloGoodsDetailByStyleCode:(NSString*)styleCode
                                  withShopId:(NSString*)shopId
                                withEntityId:(NSString*)entityId
                           completionHandler:(HttpResponseBlock)completionBlock
                                errorHandler:(HttpErrorBlock)errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:3];
    [param setValue:entityId forKey:@"entityId"];
    [param setValue:shopId forKey:@"shopId"];
    if ([NSString isNotBlank:styleCode]) {
        [param setValue:styleCode forKey:@"styleCode"];
    }
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"logisticsStock/shoesCloGoodsDetail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}
//查询收货单列表
- (void)selectPurchasePaperList:(NSString*)shopId
                         status:(short)billStatus
                       supplyId:(NSString*)supplyId
                           date:(NSNumber*)sendEndTime
                           page:(NSInteger)currentPage
                      isHistory:(short)isHistory
              completionHandler:(HttpResponseBlock) completionBlock
                   errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:6];
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:[NSNumber numberWithShort:billStatus] forKey:@"billStatus"];
    [param setValue:supplyId forKey:@"supplyId"];
    [param setValue:[NSNumber numberWithInteger:currentPage] forKey:@"currentPage"];
    [param setValue:sendEndTime forKey:@"sendEndTime"];
    [param setValue:[NSNumber numberWithShort:isHistory] forKey:@"isHistory"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"purchase/list"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//查询收货单详情
- (void)selectPurchasePaperDetail:(NSString*)stockInId recordType:(NSString*)recordType isNeedDel:(NSString *)isNeedDel completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:stockInId forKey:@"stockInId"];
    [param setValue:recordType forKey:@"recordType"];
    //是否获取入库仓库出库仓库删除信息 0 不获取 1获取
    [param setValue:isNeedDel forKey:@"isNeedDel"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"purchase/detail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//历史收货单导入
- (void)importPurchasePaperById:(NSString *)historyId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:historyId forKey:@"historyId"];
    [param setValue:@"1" forKey:@"isNeedDel"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"purchase/import"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在导入..."];
}

//查询退货单列表
- (void)selectReturnPaperList:(NSString *)supplyId
                   withStatus:(short)billStatus
                   withShopId:(NSString *)shopId
                     withDate:(NSNumber *)sendEndTime
                     withPage:(NSInteger)currentPage
                  withDicCode:(NSString *)dicCode
                         type:(short)type
            completionHandler:(HttpResponseBlock) completionBlock
                 errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:7];
    [param setValue:shopId forKey:@"shopId"];
    [param setValue:[NSNumber numberWithShort:billStatus] forKey:@"billStatus"];
    [param setValue:supplyId forKey:@"supplyId"];
    [param setValue:[NSNumber numberWithInteger:currentPage] forKey:@"currentPage"];
    [param setValue:sendEndTime forKey:@"sendendtime"];
    [param setValue:dicCode forKey:@"dicCode"];
    [param setValue:[NSNumber numberWithShort:type] forKey:@"type"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"returnGoods/list"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//查询退货单详情
- (void)selectReturnPaperDetail:(NSString *)returnGoodsId type:(short)type isNeedDel:(NSString *)isNeedDel completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:3];
    [param setValue:returnGoodsId forKey:@"returnGoodsId"];
    [param setValue:[NSNumber numberWithShort:type] forKey:@"type"];
    [param setValue:isNeedDel forKey:@"isNeedDel"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"returnGoods/detail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//验证退货量
- (void)checkReturnGoods:(NSMutableDictionary *)param completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"returnGoods/returnGuideCheck"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在验证..."];
}

//导入历史退货单
- (void)importReturnPaperById:(NSString *)historyId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:historyId forKey:@"historyId"];
    [param setValue:@"1" forKey:@"isNeedDel"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"returnGoods/importReturnGoods"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在导入..."];
}


- (void)selectAllocatePaperList:(short)billStatus
                    sendEndTime:(NSNumber*)sendEndTime
                      outShopId:(NSString*)outShopId
                       inShopId:(NSString*)inShopId
                           page:(NSInteger)currentPage
              completionHandler:(HttpResponseBlock) completionBlock
                   errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:5];
    [param setValue:[NSNumber numberWithShort:billStatus] forKey:@"billStatus"];
    [param setValue:sendEndTime forKey:@"sendendtime"];
    [param setValue:outShopId forKey:@"outShopId"];
    [param setValue:inShopId forKey:@"inShopId"];
    [param setValue:[NSNumber numberWithInteger:currentPage] forKey:@"currentPage"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"allocate/list"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

- (void)selectAllocatePaperDetail:(NSString*)allocateId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:allocateId forKey:@"allocateId"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"allocate/detail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

- (void)selectLogisticRecordList:(NSMutableDictionary*)param completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"logistics/list"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

- (void)selectLogisticRecordDetail:(NSString*)logisticsId recordType:(NSString*)recordType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:logisticsId forKey:@"logisticsId"];
    [param setValue:recordType forKey:@"recordType"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"logistics/detail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

- (void)selectPackBoxList:(short)billStatus withPackTime:(NSNumber *)packTime withPage:(NSInteger)currentPage withId:(NSString *)returnGoodsId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:3];
    [param setValue:[NSNumber numberWithShort:billStatus] forKey:@"billStatus"];
    [param setValue:packTime forKey:@"packTime"];
    [param setValue:[NSNumber numberWithInteger:currentPage] forKey:@"currentPage"];
    [param setValue:returnGoodsId forKey:@"returnGoodsId"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"packGoods/list"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

- (void)selectPackBoxDetailById:(NSString *)packGoodsId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:packGoodsId forKey:@"packGoodsId"];
    NSString *url =[NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"packGoods/detail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

- (void)operatePackBoxDetailById:(NSMutableDictionary *)param withMessage:(NSString *)message completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"packGoods/save"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:message];
}

//装箱单导入
- (void)addPackToReturn:(NSString *)returnGoodsId withIds:(NSMutableArray *)packIdList withMessage:(NSString *)message completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
     NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:returnGoodsId forKey:@"returnGoodsId"];
    [param setValue:packIdList forKey:@"packGoodsIdList"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"packGoods/addPackToReturn"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:message];
}

//按款查看装箱单记录
- (void)selectPackGoodsRecordById:(NSString *)styleId withReturnId:(NSString *)returnGoodsId withMessage:(NSString *)message completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:styleId forKey:@"styleId"];
    [param setValue:returnGoodsId forKey:@"returnGoodsId"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"packGoods/goodsPackRecord"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:message];
}

//修改商品装箱数量
- (void)editPackGoods:(NSMutableArray *)goodsPackRecordList withStyleId:(NSString *)styleId withReturnId:(NSString *)returnId withToken:(NSString *)token withMessage:(NSString *)message completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:4];
    [param setValue:goodsPackRecordList forKey:@"goodsPackRecordList"];
    [param setValue:styleId forKey:@"styleId"];
    [param setValue:returnId forKey:@"returnGoodsId"];
    [param setValue:token forKey:@"token"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"packGoods/changePackGoods"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:message];
}

//从退货单中批量删除装箱单
- (void)deletePackFromReturnById:(NSString *)returnGoodsId withPackIdList:(NSMutableArray *)packGoodsIdList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:returnGoodsId forKey:@"returnGoodsId"];
    [param setValue:packGoodsIdList forKey:@"packGoodsIdList"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"packGoods/delPackFromReturn"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在删除..."];
}

/**退货指导主页*/
- (void)guideList:(NSMutableDictionary*)param completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"guide/list"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

/**退货指导详情页*/
- (void)guideDetail:(NSMutableDictionary*)param completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"guide/guideDetail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//查询供应商列表
- (void)selectSupplyListWithKeyWord:(NSString *)keyWord
                    withCurrentPage:(NSInteger)currentPage
                   withSupplyTypeId:(NSString *)supplyTypeId
                  completionHandler:(HttpResponseBlock)completionBlock
                       errorHandler:(HttpErrorBlock)errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:3];
    [param setValue:keyWord forKey:@"keyWord"];
    [param setValue:[NSNumber numberWithInteger:currentPage] forKey:@"currentPage"];
    [param setValue:supplyTypeId forKey:@"supplyTypeId"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"supplyinfoManage/list"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//查询供应商详情
- (void)selectSupplyDetailById:(NSString *)supplyId completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:supplyId forKey:@"id"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"supplyinfoManage/supplyDetail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//添加供应商
- (void)addSupplyByDic:(NSMutableDictionary *)supply completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:supply forKey:@"supply"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"supplyinfoManage/addSaveSupply"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在保存..."];
}

//修改供应商
- (void)updateSupplyByDic:(NSMutableDictionary *)supply completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:supply forKey:@"supply"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"supplyinfoManage/updateSaveSupply"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在保存..."];
}

//删除供应商
- (void)deleteSupplyById:(NSString *)supplyId withLastver:(NSInteger)lastver completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:supplyId forKey:@"id"];
    [param setValue:[NSNumber numberWithInteger:lastver] forKey:@"lastver"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"supplyinfoManage/delSupply"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:@"正在删除..."];
}


//查询退货类别一览
- (void)selectReturnTypeList:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"returnGoods/returnTypeList"];
    [[HttpEngine sharedEngine] postUrl:url params:nil completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//查询退货类别详情
- (void)selectReturnTypeDetailById:(NSString *)returnTypeId completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:returnTypeId forKey:@"returnTypeId"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"returnGoods/returnTypeDetail"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//新增、修改、删除退货类别
- (void)operateReturnTypeByParam:(NSMutableDictionary *)param completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"returnGoods/opReturnType"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

//查询物流单据类型
- (void)selectBillTypeByCode:(NSString *)dicCode completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:dicCode forKey:@"code"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"logistics/billType"];
    [[HttpEngine sharedEngine] postUrl:url params:param completionHandler:completionBlock errorHandler:errorBlock withMessage:nil];
}

@end
