//
//  CommonService.h
//  retailapp
//
//  Created by hm on 15/10/12.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonService : NSObject

/**
 *  添加查看服鞋商品详情
 *
 *  @param styleCode       款号
 *  @param sourceFrom      单据类型
 *  @param styleId         款式id
 *  @param sourceId        单据id
 *  @param sourceId        门店id
 *  @param sourceId        供应商id
 *  @param sourceId        调入门店id
 *  @param sourceId        是否第三方供应商
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectCloShoes:(NSString *)styleCode
        withSourceFrom:(NSString *)sourceFrom
          withSourceId:(NSString *)sourceId
          withShopId:(NSString *)shopId
          withSupplyId:(NSString *)supplyId
          withInShopId:(NSString *)inShopId
          withIsThird:(BOOL)isThird
        withGoodsPrice:(double)goodsPrice
     completionHandler:(HttpResponseBlock)completionBlock
          errorHandler:(HttpErrorBlock)errorBlock;

/**
 *  选择供应商列表
 *
 *  @param keyWord         检索关键词
 *  @param currentPage     分页
 *  @param keyWord         供应商取得区分
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectSupplyList:(NSString*)keyWord shopId:(NSString *)shopId page:(NSInteger)currentPage supplyFlag:(NSString *)supplyFlag completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

/**
 *  选择门店/仓库列表
 *
 *  @param orgId           机构id
 *  @param keyWord         检索关键词
 *  @param currentPage     分页
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectShopStoreList:(NSString*)orgId keyWord:(NSString*)keyWord page:(NSInteger)currentPage lastCreateTime:(long)lastCreateTime notInclude:(BOOL)notInclude completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

/**
 *  选择仓库
 *
 *  @param param           机构id、关键字、分页、是否是自己仓库
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectStoreListByParams:(NSMutableDictionary *)param completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

/**
 *  选择下一级门店仓库
 *
 *  @param param           查询参数
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectNextLevelShopStoreByParam:(NSMutableDictionary *)param completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

/**
 *  导出
 *
 *  @param param 参数
 *  @param url   api地址
 */
- (void)exportInfo:(NSMutableDictionary*)param withUrl:(NSString*)url;

/**
 *  供应商类别一览
 *
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectSupplyTypeList:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  添加供应商类别
 *
 *  @param typeName        类别名称
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)saveSupplyType:(NSString *)typeName completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  删除供应商类别
 *
 *  @param dicItenmId      类别id
 *  @param supplyType      类别名称
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)deleteSupplyType:(NSString *)dicItemId withSupplyType:(NSString *)supplyType completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  原因一览
 *
 *  @param dicCode         code
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectReasonListByCode:(NSString *)dicCode completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  添加原因
 *
 *  @param dicCode         code
 *  @param reasonName      原因名称
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)addReasonByCode:(NSString *)dicCode withReasonName:(NSString *)reasonName completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  删除原因
 *
 *  @param dicItemId       id
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)deleteReasonById:(NSString *)dicItemId withCode:(NSString *)dicCode completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  商品最末子节点分类
 *
 *  @param hasNoCategory   @"1"带未分类
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectGoodsLastCategoryInfo:(NSString *)hasNoCategory completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

/**
 *  选择调拨商品列表
 *
 *  @param searchType      检索类型
 *  @param shopId          调出门店id
 *  @param toShopId        调入门店id
 *  @param searchCode      检索关键词
 *  @param barCode         条形码
 *  @param categoryId      分类id
 *  @param createTime      分页时间
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
-(void) selectAllocateGoodsList:(NSString *)searchType shopId:(NSString *)shopId toShopId:(NSString *)toShopId searchCode:(NSString *)searchCode barCode:(NSString *)barCode categoryId:(NSString *)categoryId createTime:(NSString *)createTime completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

/**
 *  选择商品列表
 *
 *  @param params          参数
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectGoodsList:(NSMutableDictionary *)params completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

/**
 *  查询系统参数
 *
 *  @param params          参数code
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectMultiConfigListStatus:(NSMutableDictionary *)params  completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;

/**
 *  查询上级机构（一个分支上的）
 *
 *  @param params          参数code
 *  @param completionBlock 成功回调
 *  @param errorBlock      失败回调
 */
- (void)selectParentOrgList:(NSMutableDictionary *)params completionHandler:(HttpResponseBlock)completionBlock errorHandler:(HttpErrorBlock)errorBlock;



@end
