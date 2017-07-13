//
//  WechatService.h  微店管理
//  retailapp
//
//  Created by Jianyong Duan on 15/10/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MicroShopVo.h"
#import "ExpressVo.h"
//#import "OrderDivideVo.h"
#import "UserOrderOptVo.h"

@interface WechatService : NSObject

//款式检索
- (void)selectMicroStyleListWithCompletionHandler:(HttpResponseBlock) completionBlock
                                     errorHandler:(HttpErrorBlock) errorBlock;

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
                errorHandler:(HttpErrorBlock) errorBlock;


//查询微店申请记录
- (void)selectMicroShop:(NSString *)shopId
               entityId:(NSString *)entityId
      completionHandler:(HttpResponseBlock) completionBlock
           errorHandler:(HttpErrorBlock) errorBlock;

//申请开通微店
- (void)saveMicroShop:(MicroShopVo *)microShopVo
          operateType:(NSString *)operateType
    completionHandler:(HttpResponseBlock) completionBlock
         errorHandler:(HttpErrorBlock) errorBlock;

//获取微店配送信息
- (void)selectExpress:(NSString *)shopId
    completionHandler:(HttpResponseBlock) completionBlock
         errorHandler:(HttpErrorBlock) errorBlock;

//获取微店字典信息
- (void)selectDicList:(NSString *)shopId
    completionHandler:(HttpResponseBlock) completionBlock
         errorHandler:(HttpErrorBlock) errorBlock;

//更新微店配送信息
- (void)editExpress:(ExpressVo *)express
  completionHandler:(HttpResponseBlock) completionBlock
       errorHandler:(HttpErrorBlock) errorBlock;

//微店订单处理
- (void)selectMicroOrderDeal:(NSString *)keyWord
                lastDateTime:(long)lastDateTime
           completionHandler:(HttpResponseBlock) completionBlock
                errorHandler:(HttpErrorBlock) errorBlock;

//保存微店订单处理
- (void)saveMicroOrderDeal:(NSArray *)microOrderDealVoList
         completionHandler:(HttpResponseBlock) completionBlock
              errorHandler:(HttpErrorBlock) errorBlock;

//删除微店订单处理
- (void)deleteMicroOrderDeal:(int)orderDealId
           completionHandler:(HttpResponseBlock) completionBlock
                errorHandler:(HttpErrorBlock) errorBlock;

//商品评价列表
- (void)selectCommentReport:(NSInteger)startTime
                    endTime:(NSInteger)endTime
                   lastTime:(NSInteger)lastTime
                     shopId:(NSString *)shopId
                    keyWord:(NSString *)keyWord
                    barCode:(NSString *)barCode
          completionHandler:(HttpResponseBlock) completionBlock
               errorHandler:(HttpErrorBlock) errorBlock;

//会员评价列表
- (void)selectCustomerComment:(NSInteger)startTime
                      endTime:(NSInteger)endTime
                     lastTime:(NSInteger)lastTime
                 commentLevel:(NSInteger)commentLevel
                      goodsId:(NSString *)goodsId
                       shopId:(NSString *)shopId
            completionHandler:(HttpResponseBlock) completionBlock
                 errorHandler:(HttpErrorBlock) errorBlock;
//微店基本设置
- (void)WechatBaseSetcompletionHandler:(HttpResponseBlock) completionBlock
                          errorHandler:(HttpErrorBlock) errorBlock ;
//保存微店基本设置
- (void)SaveWechatBaseSet:(NSDictionary *)param completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//更具code查找微店设置
- (void)SelectCode:(NSString*)code completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//微店商品管理（款式）在售款式数量
-(void) selectStyleCount:(NSString*) shopId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//微店商品管理（款式）详情
-(void) selectWechatGoodsStyleDetail:(NSString*) shopId StyleId:(NSString*) StyleId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//微店商品管理（款式）详情保存
//-(void) SaveWechatGoodsStyleDetail:(NSString*) shopId microStyleVo:(NSDictionary*) microStyleVo token:(NSString *)token completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//微店商品管理（款式）详情图片列表
-(void) selectInfoImageList:(NSString*) styleId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//微店商品管理（款式）详情图片保存
-(void) saveMicroStylePictures:(NSString*) shopId MicroStyleVo:(NSDictionary*) microStyleVo completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//微店商品管理（款式）颜色图片列表
-(void) selectInfoImageColorList:(NSString*) styleId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//微店商品管理（款式）颜色图片保存
-(void) saveMicroStyleColorPictures:(NSString*) shopId MicroStyleVo:(NSDictionary*) microStyleVo completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//微店商品管理（款式）批量更新微店款式上下架状态
-(void) setMicroStyleUpDownStatus:(NSMutableArray*) styleIdList shopId:(NSString*) shopId status:(NSString *) status completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//微店商品管理（款式）批量设置微店款式不销售
-(void) setNotSaleMicroStyle:(NSMutableArray*) StyleIdList shopId:(NSString*) shopId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
//微店商品分类
- (void)selectCategoryList:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;


//微店商品管理（商品）在售商品数量
-(void) selectGoodsCount:(NSString*) shopId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//微店商品管理（商品）商品一览
-(void) selectGoodsList:(NSString*) searchType shopId:(NSString*) shopId searchCode:(NSString*) searchCode categoryId:(NSString*) categoryId createTime:(NSString*) createTime completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;


//微店商品管理（商品）商品详情
-(void) selectWechatGoodsDetail:(NSString*) shopId goodsId:(NSString*) goodsId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
//微店商品管理（商品）价格检查
-(void) checkPrice:(NSString*) shopId goodsId:(NSString*) goodsId microPrice:(NSString *) microPrice completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//微店商品管理（商品）添加或更新微店商品
-(void) selectWechatGoodsSaveOrUpdate:(NSDictionary*) microGoodsVo completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//微店商品管理（商品）详情图片列表
-(void) selectWechatGoodsPictureList:(NSString*) goodsId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//微店商品管理（商品）详情图片保存
-(void) updateOrAddWechatGoods:(NSString*) shopId microGoodsVo:(NSDictionary*) microGoodsVo completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;


//微店商品管理（商品）批量更新微店款式上下架状态
-(void) setMicroGoodsUpDownStatus:(NSMutableArray*) goodsIdList shopId:(NSString*) shopId isShelve:(NSString *) isShelve completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//微店商品管理（商品）批量设置微店款式不销售
-(void) setNotSaleMicroGoods:(NSMutableArray*) goodsIdList shopId:(NSString*) shopId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//叶子节点的类别一览
- (void) selectLastCategoryInfo:(NSString*) hasNoCategory completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//添加销售包到微店销售
-(void) addSalePacksToSale:(NSMutableArray*) styleIdList shopId:(NSString*) shopId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;


//保存or更新销售包款式列表
-(void) saveSalePackStyleList:(NSString*) salePackId styleIdList:(NSMutableArray*) styleIdList lastVer:(NSString*) lastVer completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//批量添加微店商品
-(void) batchAddWechatGoods:(NSString *)shopId goodsIdList:(NSMutableArray*) goodsIdList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//批量添加微店商品
-(void) batchAddWechatGoodsStyles:(NSString *)shopId styleIdList:(NSMutableArray*) styleIdList token:(NSString *)token completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//商品一览
-(void) selectGoodsList:(NSString*) searchType shopId:(NSString*) shopId searchCode:(NSString*) searchCode barCode:(NSString*) barCode categoryId:(NSString*) categoryId createTime:(NSString*) createTime completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//按条件选择添加销售包款式
-(void) addStylesToSalePackByCondition:(NSString*) shopId salePackId:(NSString*) salePackId categoryId:(NSString*) categoryId applySex:(NSString*) applySex year:(NSString*) year season:(NSString*) season minHangTagPrice:(NSString*) minHangTagPrice maxHangTagPrice:(NSString*) maxHangTagPrice prototypeValId:(NSString*) prototypeValId auxiliaryValId:(NSString*) auxiliaryValId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

-(void) selectStyleImageInfo:(NSString*) styleId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

-(void) saveMainImageList:(NSDictionary*) microStyleVo completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

-(void) addSelectStylesToSalePack:(NSString*) salePackId styleVoList:(NSMutableArray*) styleVoList completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

-(void) deleteTempSelectStyles:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

-(void) selectSalePackDetail:(NSString*) salePackId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

-(void) saveSalePackDetail:(NSDictionary*) salePackVo completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

-(void) delSalePack:(NSString*) salePackId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

-(void) selectSalePackStyleList:(NSString*) salePackId completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

-(void) searchStyleInSalePack:(NSString*) salePackId searchCode:(NSString*) searchCode createTime:(NSString*) createTime completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

-(void) deleteSelectStylesFromPack:(NSString*) salePackId styleIdList:(NSMutableArray*) styleIdList lastVer:(NSString*) lastVer completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

-(void) selectSalePackList:(NSString*) searchCode completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

//商品一览
-(void) selectWechatCommonGoods:(NSString*) searchType shopId:(NSString*) shopId searchCode:(NSString*) searchCode barCode:(NSString*) barCode categoryId:(NSString*) categoryId createTime:(NSString*) createTime completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;

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
           errorHandler:(HttpErrorBlock) errorBlock;

//订单详情
- (void)selectOrderDetail:(NSString *)orderId
                orderType:(int)orderType
                   shopId:(NSString *)shopId
        completionHandler:(HttpResponseBlock) completionBlock
             errorHandler:(HttpErrorBlock) errorBlock;

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
            errorHandler:(HttpErrorBlock) errorBlock;

//供货订单操作
//- (void)divideOrderOperate:(NSString *)orderId
//                  divideId:(NSInteger)divideId
//               operateType:(NSString *)operateType
//                 rejReason:(NSString *)rejReason
//                      code:(NSString *)code
//           divideExpansion:(NSString *)divideExpansion
//                   lastVer:(long)lastVer
//             divideLastVer:(long)divideLastVer
//               divideCount:(NSInteger)divideCount
//               orderShopId:(NSString *)orderShopId
//                    shopId:(NSString *)shopId
//              userOrderOpt:(NSDictionary *) userOrderOpt
//                 expansion:(NSDictionary *)expansion
//         completionHandler:(HttpResponseBlock) completionBlock
//              errorHandler:(HttpErrorBlock) errorBlock;

//- (void)divideOrderOperate:(NSString *)orderId
//                  divideId:(NSString*)divideId
//               operateType:(NSString *)operateType
//                 rejReason:(NSString *)rejReason
//                      code:(NSString *)code
//           divideExpansion:(NSString *)divideExpansion
//                   lastVer:(long)lastVer
//             divideLastVer:(long)divideLastVer
//                divideCode:(NSString *)divideCode
//               divideCount:(NSInteger)divideCount
//               orderShopId:(NSString *)orderShopId
//                    shopId:(NSString *)shopId
//              userOrderOpt:(NSDictionary *) userOrderOpt
//                divideCode:(NSString *)newCode
//                 expansion:(NSDictionary *)expansion
//         completionHandler:(HttpResponseBlock) completionBlock
//              errorHandler:(HttpErrorBlock) errorBlock;

//- (void)divideOrderOperate:(NSString *)orderId
//                  divideId:(NSString *)divideId
//               operateType:(NSString *)operateType
//                 rejReason:(NSString *)rejReason
//                      code:(NSString *)code
//           divideExpansion:(NSString *)divideExpansion
//                   lastVer:(long)lastVer
//             divideLastVer:(long)divideLastVer
//                divideCode:(NSString *)divideCode
//               divideCount:(NSInteger)divideCount
//               orderShopId:(NSString *)orderShopId
//                    shopId:(NSString *)shopId
//              userOrderOpt:(NSDictionary *) userOrderOpt
//                divideCode:(NSString *)newCode
//                 expansion:(NSDictionary *)expansion
//         completionHandler:(HttpResponseBlock) completionBlock
//              errorHandler:(HttpErrorBlock) errorBlock;


//积分兑换订单管理列表
- (void)selectIntegralOrderList:(NSMutableDictionary *)param completionHandler:(HttpResponseBlock) completionBlock
                   errorHandler:(HttpErrorBlock) errorBlock;

//拒绝原因
- (void)selectRefuseReson:(NSString *)entityId
        completionHandler:(HttpResponseBlock) completionBlock
             errorHandler:(HttpErrorBlock) errorBlock;

//添加拒绝原因
- (void)addRefuseReson:(NSString *)entityId
                reason:(NSString *)reason
     completionHandler:(HttpResponseBlock) completionBlock
          errorHandler:(HttpErrorBlock) errorBlock;

//订单处理门店仓库一览
//- (void)selectOpShopWareList:(NSString *)goodsId
//                     keyword:(NSString *)keyword
//              lastCreateTime:(long long)lastCreateTime
//           completionHandler:(HttpResponseBlock) completionBlock
//                errorHandler:(HttpErrorBlock) errorBlock;

//手动分单
//- (void)manualSplit:(NSString *)orderId
//     showTypeVoList:(NSArray *)showTypeVoList
//  completionHandler:(HttpResponseBlock) completionBlock
//       errorHandler:(HttpErrorBlock) errorBlock;

//重新分单
//- (void)reSplitOrder:(NSString *)orderId
//      showTypeVoList:(NSArray *)showTypeVoList
//         goodsIdList:(NSArray *)goodsIdList
//        divideIdList:(NSArray *)divideIdList
//   completionHandler:(HttpResponseBlock) completionBlock
//        errorHandler:(HttpErrorBlock) errorBlock;

//查询包裹详情，选择分单信息
//- (void)selectPackageInfo:(NSString *)orderId
//        completionHandler:(HttpResponseBlock) completionBlock
//             errorHandler:(HttpErrorBlock) errorBlock;

//微店整单订单处理列表
//- (void)selectShopWareList:(NSString *)keyword
//              lastDateTime:(long long)lastDateTime
//         completionHandler:(HttpResponseBlock) completionBlock
//              errorHandler:(HttpErrorBlock) errorBlock;

//微店整单订单库存信息
//- (void)getStockInfoList:(NSString *)shopId
//             goodsIdList:(NSArray *)goodsIdList
//       completionHandler:(HttpResponseBlock) completionBlock
//            errorHandler:(HttpErrorBlock) errorBlock;

//根据分单Id列表查询商品详情
- (void)selectInstanceListByDivideIdList:(NSArray *)divideIdList
                       completionHandler:(HttpResponseBlock) completionBlock
                            errorHandler:(HttpErrorBlock) errorBlock;

//根据商品Id列表和门店Id查询库存信息
- (void)selectStockInfoList:(NSString *)shopId
                goodsIdList:(NSArray *)goodsIdList
          completionHandler:(HttpResponseBlock) completionBlock
               errorHandler:(HttpErrorBlock) errorBlock;

//上门自提待分配时确认接单
//- (void)orderManagement:(NSMutableDictionary *)param completionHandler:(HttpResponseBlock) completionBlock errorHandler:(HttpErrorBlock) errorBlock;
@end
