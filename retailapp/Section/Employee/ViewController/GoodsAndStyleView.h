//
//  GoodsAndStyleView.h
//  retailapp
//
//  Created by qingmei on 15/10/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
@class RoleCommissionVo;

typedef void(^CommissionRatioBack)(NSString* item);

/**
 点击右上角保存

 @param list  编辑的商品列表
 @param isDel 是否删除
 */
typedef void (^SaveBlock)(NSArray *list, BOOL isDel);
@interface GoodsAndStyleView : LSRootViewController

@property (nonatomic, copy) NSString *roleCommissionId;

//页面初始化
- (id)initWithParent:(id)parentTemp;
- (void)setisGood:(BOOL)isGood;//是商品模式还是款式
- (void)reflashUI;//刷新UI

//根据goodsOrStyleList加载页面
- (void)loadWithGoodsOrStyleList:(NSArray *)goodsOrStyleList CommissionVo:(RoleCommissionVo *)roleCommission isAdd:(BOOL)isAdd;
- (void)onRightSavebBlock:(SaveBlock)saveBlcok;


@end
