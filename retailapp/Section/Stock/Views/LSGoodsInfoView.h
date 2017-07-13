//
//  LSGoodsInfoView.h
//  retailapp
//
//  Created by guozhi on 2017/2/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSGoodsInfoView : UIView
+ (instancetype)goodsInfoView;

/**
 设置商品信息

 @param name 商品名称
 @param barCode 条形码
 @param retailPrice 零售价
 @param filePath 图片路径
 @param goodsStatus 上下架状态
 @param type 商品类型
 */
- (void)setGoodsName:(NSString *)name barCode:(NSString *)barCode retailPrice:(double)retailPrice filePath:(NSString *)filePath goodsStatus:(short)goodsStatus type:(short)type;
@end
