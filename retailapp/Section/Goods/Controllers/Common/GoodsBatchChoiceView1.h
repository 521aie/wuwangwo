//
//  GoodsBatchChoiceView1.h
//  retailapp
//
//  Created by zhangzhiliang on 15/11/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

//商超版商品选择批量页面
typedef void(^SelectGoodsBatchBack)(NSMutableArray* goodsList);
@interface GoodsBatchChoiceView1 : LSRootViewController

@property (nonatomic, strong) NSString *searchType;
@property (nonatomic, strong) NSString *searchCode;
@property (nonatomic, strong) NSString *barCode;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *datas;

//supplyId  isReturn 只限物流模块

/** 物流单查询商品时传入 */
@property (nonatomic, strong) NSString *supplyId;
/** 标示当前是否获取退货价 1为获取 2 不获取 退货单时传入1，其他单传2 */
@property (nonatomic, strong) NSString *isReturn;

/**
 商超采购单、收货单商品选择时为 1
 */
@property (nonatomic, strong) NSString *viewType;

/**
 商超采购单、收货单商品选择时必传
 */
@property (nonatomic, strong) NSString *shopName;

//调入门店id
@property (nonatomic, strong) NSString *inShopId;
//1 实体关联商品
//2 实体关联且有库存信息的商品
@property (nonatomic, assign) NSInteger mode;
//是否查询库存
@property (nonatomic, assign) BOOL getStockFlg;
//机构指定仓库
@property (nonatomic, strong) NSString *warehouseId;
//1.普通商品,2.拆分商品,3.组装商品,4.称重商品,5.原料商品,6:加工商品
@property (nonatomic, strong) NSMutableArray *validTypeList;
@property (nonatomic, strong) NSDictionary *alertGoodListParam;/*<获取可做库存提醒商品列表所需参数>*/

@property (nonatomic, copy) SelectGoodsBatchBack selectGoodsBatchBack;

// 批量选择页面入口
- (void)loaddatas:(NSString *)shopId callBack:(SelectGoodsBatchBack)callBack;
// 商品选择页面跳转到批量页面
- (void)loaddatas:(NSString *)shopId condition:(NSMutableDictionary *)condition goodsList:(NSMutableArray *)goodsList callBack:(SelectGoodsBatchBack)callBack;
- (void)showView:(int)viewTag;
- (void)clearCheckStatus;
@end
