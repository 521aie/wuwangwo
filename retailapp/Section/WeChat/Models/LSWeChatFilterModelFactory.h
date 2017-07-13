//
//  LSWeChatFilterModelFactory.h
//  retailapp
//
//  Created by taihangju on 2017/2/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDFFilterMoel;
@interface LSWeChatFilterModelFactory : NSObject


/**
 微店销售订单页面(WechatOrderListView)筛选需要数据
 */
+ (NSArray<TDFFilterMoel *> *)wechatSellOrderListViewFilterModels;


/**
 微店积分兑换订单页面(PointExOrderListView)筛选需要的数据
 */
+ (NSArray<TDFFilterMoel *> *)wechatIntegralExchangeOrderListViewFilterModels;


/**
 微店退货管理列表页(SellRetrunListView)筛选需要数据
 */
+ (NSArray<TDFFilterMoel *> *)wechatSellReturnListViewFilterModels;

/**
 微店退款管理列表页(WeChatReturnMoneyManager)筛选需要数据
 */
+ (NSArray<TDFFilterMoel *> *)wechatReturnMoneyListViewFilterModels;


/**
 微店可销售数量设置页面(VirtualStockManagementView)筛选需要的数据
 */
+ (NSArray<TDFFilterMoel *> *)wechatVirtualStockSetListViewFilterModels;
@end
