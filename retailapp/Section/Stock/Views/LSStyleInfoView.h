//
//  LSStyleInfoView.h
//  retailapp
//
//  Created by guozhi on 2017/2/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSStyleInfoView : UIView
/** 商品图片 */
@property (nonatomic, strong) UIImageView *imgViewGoods;
/** 商品名字 */
@property (nonatomic, strong) UILabel *lblGoodsName;
/** 款号 */
@property (nonatomic, strong) UILabel *lblGoodsCode;
/** 价格 */
@property (nonatomic, strong) UILabel *lblPrice;
/** 是否显示价格 */
@property (nonatomic, assign) BOOL isShowPrice;
/**
 实例化一个商品信息

 @return
 */
+ (instancetype)styleInfoView;

/**
 设置商品信息

 @param filePath 商品图片路径
 @param goodsName 商品名称
 @param styleCode 款号
 @param updownStatus 1 上架  2下架
 @param goodsPrice 商品价格
 @param showPrice 是否显示价格
 */
- (void)setStyleInfo:(NSString *)filePath goodsName:(NSString *)goodsName styleCode:(NSString *)styleCode upDownStatus:(int)updownStatus goodsPrice:(NSString *)goodsPrice showPrice:(BOOL)showPrice;
@end
