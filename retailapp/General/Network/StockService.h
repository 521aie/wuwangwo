//
//  StockService.h
//  retailapp
//
//  Created by guozhi on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WareHouseVo;
@interface StockService : NSObject
//虚拟库存一览
- (void)virtualStoreList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//获取登陆门店的供货仓库
- (void)wareHouseCompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//虚拟库存详情
- (void)storeDetail:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;


//新增修改虚拟库存设置
- (void)saveVirtualStore:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//删除虚拟库存
- (void)deleteVirtualStore:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//批量库存or折扣率范围
- (void)virtualStoreRange:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;


//积分商品库存一览
- (void)integralList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//积分商品库存详情
- (void)integralDetail:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**获取到期提醒商品列表	*/
- (void)alertList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/** 提醒详情*/
- (void)alertDetail:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/** 提醒添加*/
- (void)alertEdit:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;


//------------------------------------------------------
/**
 *  库存查询
 *
 *  @param param           参数：门店/仓库id、分类id、年度、季度、检索关键词
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)queryStockInfoList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  款式库存信息详情
 *
 *  @param shopId          门店或仓库id
 *  @param styleId         款式id
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)queryStockInfoDetailById:(NSString *)shopId withStyleId:(NSString *)styleId CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;


/**
 *  库存调整单一览
 *
 *  @param shopId          门店/仓库id
 *  @param billStatus      状态
 *  @param opUserId        操作人id
 *  @param adjustDate      调整日期
 *  @param currentPage     分页
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectStockAdjustPaperList:(NSString *)shopId
                        withStatus:(short)billStatus
                      withOpUserId:(NSString *)opUserId
                    withAdjustDate:(NSString *)adjustDate
                          withPage:(NSInteger)currentPage
                 CompletionHandler:(HttpResponseBlock) completionBlock
                      errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  调整单详情
 *
 *  @param adjustCode      调整单号
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectStockAdjustDetailByCode:(NSString *)adjustCode CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  新增调整单
 *
 *  @param shopId          商户id
 *  @param adjustTime      调整时间
 *  @param memo            备注
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)addAdjustPaperByShopId:(NSString *)shopId withAdjustTime:(long long)adjustTime withMemo:(NSString *)memo withCode:(NSString *)adjustCode withLastVer:(long)lastVer withToken:(NSString *)token CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;




/**
 库存调整单提交时进行对单子内的商品check，查看商品的删除状态

 @param url 请求地址
 @param param 参数
 @param completionBlock 完成回调
 @param errorBlock 失败回调
 @param message 请求是的提示信息
 */
- (void)checkStockAdjustPaperGoods:(NSString *)url params:(NSDictionary *)param completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock withMessage:(NSString*)message;


/**
 *  新增修改调整单商品
 *
 *  @param adjustCode            调整单编号
 *  @param opType                1：保存 2：提交 3：确认 4：拒绝
 *  @param modifyStatusOnly      0：商品列表以当前上传为准 1：仅改变状态（商品列表不变）
 *  @param laster                版本号
 *  @param stockAdjustDetailList 商品列表
 *  @param message               显示信息
 *  @param completionBlock       成功回调
 *  @param errorBlock            失败回调
 */
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
                         errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  款式调整详情
 *
 *  @param shopId          门店或仓库id
 *  @param adjustCode      调整单code
 *  @param styleId         款式id
 *  @param styleId         款式code
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectStyleAdjustDetail:(NSString *)shopId withAdjustCode:(NSString *)adjustCode withStyleId:(NSString *)styleId withStyleCode:(NSString *)styleCode CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  删除调整单
 *
 *  @param adjustCode      调整单code
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)deleteAdjustPaperByCode:(NSString *)adjustCode withToken:(NSString *)token CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
/**
 *  调整原因
 *
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectAdjustReasonListWithCallBack:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  添加调整原因
 *
 *  @param adjustReason    名称
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)addAdjustReasonByName:(NSString *)adjustReason CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  删除调整原因
 *
 *  @param adjustReasonId  原因id
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)deleteAdjustReasonById:(NSString *)adjustReasonId CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  查询仓库列表
 *
 *  @param orgId           登录机构id
 *  @param keyWord         检索关键词
 *  @param currentPage     分页
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectWarehouseListById:(NSString *)orgId withKeyWord:(NSString *)keyWord withPage:(NSInteger)currentPage CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  查询仓库详情
 *
 *  @param warehouseId     仓库id
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectWarehouseDetailById:(NSString *)warehouseId CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  新增修改仓库
 *
 *  @param operateType     操作类型（add edit）
 *  @param wareHouse       仓库对象
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)operateWarehouse:(NSString *)operateType
           withWareHouse:(WareHouseVo *)wareHouse
       CompletionHandler:(HttpResponseBlock) completionBlock
            errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  删除仓库
 *
 *  @param wareHouseId     仓库id
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)deleteWareHouse:(NSString *)wareHouseId CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  删除仓库验证
 *
 *  @param wareHouseId     仓库id
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)checkWareHouse:(NSString *)wareHouseId CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  省市区列表
 *
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selelctAddressList:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *
 库存汇总查询
 *
 *  @param param           参数：门店/仓库id、汇总类型
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)storeSummaryList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
/**查询下属订单处理机构*/
- (void)getMicroOrderDealList:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
//查询登陆关联的订单处理机构
- (void)getSelfOpOrderShop:(NSMutableDictionary *)param CompletionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

@end
