//
//  LogisticService.h
//  retailapp
//
//  Created by hm on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogisticService : NSObject

/**
 *  叫货商品校验
 *
 *  @param supplyId        供应商id
 *  @param goodsList       商品列表
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)checkOrderGoodsById:(NSString *)supplyId withGoodsList:(NSMutableArray *)goodsList completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

/**
 *  查询单据状态
 *  @param dicCode         单据diccode
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectPaperStatusList:(NSString*)dicCode completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;
/**
 *  查询叫货单列表
 *
 *  @param shopId          门店/仓库id
 *  @param billStatus      单据状态
 *  @param supplyId        供应商id
 *  @param sendEndTime     日期
 *  @param currentPage     分页
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectOrderPaperList:(NSString*)shopId
                      status:(short)billStatus
                    supplyId:(NSString*)supplyId
                        date:(NSNumber*)sendEndTime
                        page:(NSInteger)currentPage
                        type:(short)type
                   isNeedDel:(NSString *)isNeedDel
           completionHandler:(HttpResponseBlock)completionBlock
                errorHandler:(HttpErrorBlock)errorBlock;
/**
 *  查询叫货单详情
 *  @param orderGoodsId    单据id
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectOrderPaperDetail:(NSString*)orderGoodsId withType:(short)type isNeedDel:(NSString *)isNeedDel completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

/**
 *  添加商品时保存（客户叫货单添加商品的时候不需要调用）
 *  @param param           参数集合
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)saveForAddGoods:(NSDictionary*)param completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

/**
 *  历史叫货单导入
 *
 *  @param historyId       历史叫货单id
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)importOrderPaperById:(NSString *)historyId completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

/**
 *  重新提交叫货单
 *
 *  @param param           叫货单id、版本号
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)resubmitOrderPaperByParam:(NSMutableDictionary *)param completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;


/**
 *  选择商品列表
 *  @param shopId          用户所属店铺/组织id
 *  @param searchCode      搜索关键词
 *  @param createTime      分页时间
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectGoodsList:(NSString*)shopId
         withSearchCode:(NSString*)searchCode
         withCreateTime:(NSInteger)createTime
      completionHandler:(HttpResponseBlock)completionBlock
           errorHandler:(HttpErrorBlock)errorBlock;



/**
 物流相关单子(采购，入库，退货，调拨，库存调整)提交时进行check，判断单子中涉及的商品提交时是否被删除

 @param url 接口
 @param param 参数，包含所有的商品id即可
 @param completionBlock 成功后回调
 @param errorBlock 失败回调
 @param message 加载时显示信息
 */
- (void)checkPaperDetailGoods:(NSString *)url params:(NSDictionary *)param completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock withMessage:(NSString*)message;



/**
 *  操作单据详情
 *
 *  @param param           参数
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 *  @param message         加载显示信息
 */
- (void)operatePaperDetail:(NSMutableDictionary*)param withUrl:(NSString*)url completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock withMessage:(NSString*)message;

/**
 *  服鞋款式详情
 *
 *  @param styleCode       款号
 *  @param shopId          商户id
 *  @param entityId        实体id
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectShoesCloGoodsDetailByStyleCode:(NSString*)styleCode
                                  withShopId:(NSString*)shopId
                                withEntityId:(NSString*)entityId
                           completionHandler:(HttpResponseBlock)completionBlock
                                errorHandler:(HttpErrorBlock)errorBlock;

/**
 *  查询收货单列表
 *
 *  @param shopId          门店/仓库id
 *  @param billStatus      单据状态
 *  @param supplyId        供应商id
 *  @param sendEndTime     日期
 *  @param currentPage     分页
 *  @param isHistory       是否是历史收货单
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectPurchasePaperList:(NSString*)shopId
                         status:(short)billStatus
                       supplyId:(NSString*)supplyId
                           date:(NSNumber*)sendEndTime
                           page:(NSInteger)currentPage
                      isHistory:(short)isHistory
              completionHandler:(HttpResponseBlock) completionBlock
                   errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  查询收货单详情
 *
 *  @param stockInId       收货单id
 *  @param recordType      类型：“o”叫货 “p”收货
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectPurchasePaperDetail:(NSString*)stockInId recordType:(NSString*)recordType isNeedDel:(NSString *)isNeedDel completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  历史收货单导入
 *
 *  @param historyId       历史收货单id
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)importPurchasePaperById:(NSString *)historyId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;



/**
 *  退货单/客户退货单一览
 *
 *  @param supplyId        供应商id（退货单/历史退货单使用）
 *  @param billStatus      状态
 *  @param shopId          门店/仓库id
 *  @param sendEndTime     退货时间
 *  @param currentPage     分页
 *  @param dicCode         客户退货单：DIC_CUSTOMER_RETURN_STATUS 退货单：DIC_CHAIN_RETURN_STATUS
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectReturnPaperList:(NSString *)supplyId
                   withStatus:(short)billStatus
                   withShopId:(NSString *)shopId
                     withDate:(NSNumber *)sendEndTime
                     withPage:(NSInteger)currentPage
                  withDicCode:(NSString *)dicCode
                         type:(short)type
            completionHandler:(HttpResponseBlock) completionBlock
                 errorHandler:(HttpErrorBlock) errorBlock;


/**
 *  查询退货单详情
 *
 *  @param returnGoodsId   退货单id
 *  @param type            单据类型
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectReturnPaperDetail:(NSString *)returnGoodsId type:(short)type isNeedDel:(NSString *)isNeedDel completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  导入历史退货单
 *
 *  @param historyId       历史退货单id
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)importReturnPaperById:(NSString *)historyId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  退货量验证
 *
 *  @param param           shopId、supplyId、退货类型val、款式列表
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)checkReturnGoods:(NSMutableDictionary *)param completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;


/**
 *  查询调拨单一览
 *
 *  @param sendEndTime     调拨查询起始时间
 *  @param outShopId       调出门店
 *  @param inShopId        调入门店
 *  @param currentPage     分页
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectAllocatePaperList:(short)billStatus
                      sendEndTime:(NSNumber*)sendEndTime
                      outShopId:(NSString*)outShopId
                       inShopId:(NSString*)inShopId
                           page:(NSInteger)currentPage
              completionHandler:(HttpResponseBlock) completionBlock
                   errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  查询调拨单详情
 *
 *  @param allocateId      调拨单id
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectAllocatePaperDetail:(NSString*)allocateId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  查询物流记录一览
 *
 *  @param param           参数
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectLogisticRecordList:(NSMutableDictionary*)param completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  查询物流记录详情
 *
 *  @param logisticsId     物流id
 *  @param recordType      单据类型
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectLogisticRecordDetail:(NSString*)logisticsId recordType:(NSString*)recordType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;


/**
 *  装箱单列表
 *
 *  @param billStatus      状态
 *  @param packTime        装箱时间
 *  @param currentPage     当前页
 *  @param returnGoodsId   退货单id
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectPackBoxList:(short)billStatus withPackTime:(NSNumber *)packTime withPage:(NSInteger)currentPage withId:(NSString *)returnGoodsId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  装箱单详情
 *
 *  @param packGoodsId     装箱单id
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectPackBoxDetailById:(NSString *)packGoodsId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  装箱单（增、删、改）
 *
 *  @param packGoodsId         装箱单id
 *  @param boxCode             箱号
 *  @param packTime            装箱时间（日期+时间）
 *  @param memo                备注
 *  @param lastVer             版本
 *  @param packGoodsDetailList 商品列表
 *  @param message             信息
 *  @param completionBlock     成功回调
 *  @param errorBlock          失败回调
 */
- (void)operatePackBoxDetailById:(NSMutableDictionary *)param withMessage:(NSString *)message completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
/**退货指导主页*/
- (void)guideList:(NSMutableDictionary*)param completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

/**
 *  装箱单导入
 *
 *  @param returnGoodsId   退货单id
 *  @param packIdList      装箱单id列表
 *  @param message         信息
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)addPackToReturn:(NSString *)returnGoodsId withIds:(NSMutableArray *)packIdList withMessage:(NSString *)message completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  从退货单中批量删除装箱单
 *
 *  @param returnGoodsId   退货单id
 *  @param packGoodsIdList 装箱单id列表
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)deletePackFromReturnById:(NSString *)returnGoodsId withPackIdList:(NSMutableArray *)packGoodsIdList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  按款查看商品装箱记录
 *
 *  @param styleId         款式id
 *  @param returnGoodsId   退货单id
 *  @param message         信息
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectPackGoodsRecordById:(NSString *)styleId withReturnId:(NSString *)returnGoodsId withMessage:(NSString *)message completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  修改商品装箱数量
 *
 *  @param goodsPackRecordList 商品list
  *  @param goodsPackRecordList 商品list
  *  @param goodsPackRecordList 商品list
 *  @param message             信息
 *  @param completionBlock     成功回调
 *  @param errorBlock          失败回调
 */
- (void)editPackGoods:(NSMutableArray *)goodsPackRecordList withStyleId:(NSString *)styleId withReturnId:(NSString *)returnId withToken:(NSString *)token withMessage:(NSString *)message completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**退货指导详情页*/
- (void)guideDetail:(NSMutableDictionary*)param completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

/**
 *  查询供应商列表
 *
 *  @param keyWord         手机号/名称
 *  @param currentPage     分页码
 *  @param supplyTypeId    供应商类别id
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectSupplyListWithKeyWord:(NSString *)keyWord
                    withCurrentPage:(NSInteger)currentPage
                   withSupplyTypeId:(NSString *)supplyTypeId
                  completionHandler:(HttpResponseBlock)completionBlock
                       errorHandler:(HttpErrorBlock)errorBlock;


/**
 *  添加供应商
 *
 *  @param supply          供应商vo
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)addSupplyByDic:(NSMutableDictionary *)supply completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

/**
 *  修改供应商
 *
 *  @param supply          供应商vo
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)updateSupplyByDic:(NSMutableDictionary *)supply completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

/**
 *  查询供应商详情
 *
 *  @param supplyId        供应商id
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectSupplyDetailById:(NSString *)supplyId completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

/**
 *  删除供应商
 *
 *  @param supplyId        供应商id
 *  @param lastver         版本
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)deleteSupplyById:(NSString *)supplyId withLastver:(NSInteger)lastver completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

/**
 *  查询退货类别一览）
 *
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectReturnTypeList:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

/**
 *  查询退货类别详情
 *
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectReturnTypeDetailById:(NSString *)returnTypeId completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

/**
 *  新增、修改、删除退货类别
 *
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)operateReturnTypeByParam:(NSMutableDictionary *)param completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

/**
 *  单据类型
 *
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectBillTypeByCode:(NSString *)dicCode completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;
@end
