//
//  LSGoodsEditView.h
//  retailapp
//
//  Created by wuwangwo on 2017/3/16.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
typedef void(^GoodsEditBack) (BOOL flg);
@class LSEditItemList;
@class GoodsVo;

@interface LSGoodsEditView : LSRootViewController
//分类
@property (nonatomic, strong) LSEditItemList *lsCategory;
//商品品牌
@property (nonatomic, strong) LSEditItemList *lsBrand;

@property (nonatomic, strong) GoodsVo *goodsVo;
@property (nonatomic, strong) GoodsVo* addGoodsVo;
@property (nonatomic) int action;
@property (nonatomic) int viewTag;
@property (nonatomic, strong) NSNumber *searchStatus;//int
@property (nonatomic, strong) NSString* goodsId;
@property (nonatomic, strong) NSString* shopId;
@property (nonatomic, strong) NSString* synShopId;
@property (nonatomic, strong) NSString* synShopName;
// 从商超商品批量选择页面跳转
-(void) loaddatas:(NSString*) shopId shopName:(NSString*) shopName callBack:(GoodsEditBack)callBack;
-(void) loaddatas;
@end
