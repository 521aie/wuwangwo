//
//  ShopIncomeView.h
//  retailapp
//
//  Created by taihangju on 16/6/8.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShopIncomeViewDelegate;

@protocol ShopIncomeViewDelegate <NSObject>

@optional
// 代理方法，回调给代理通知显示进入详情页面
-(void)showShopIncomeView;
@end

@interface ShopIncomeView : UIView

@property (nonatomic, weak) id<ShopIncomeViewDelegate> delegate;/*<代理为了响应>*/

/**
 *  初始化ShowShopIncomeView对象
 *
 *  @param showDetail 是否显示进入收入详情界面的指示view
 *  @param topY       初始化的对象frame的orgin.y
 *  @param items      要展示的收入项
 *  @param agent      代理对象，遵循了ShopIncomeViewDelegate
 *
 *  @return 初始化ShowShopIncomeView对象
 */
+ (ShopIncomeView *)shopIncomeView:(BOOL)showDetail top:(CGFloat)topY displayItems:(NSArray *)items owner:(id)agent;
@end


