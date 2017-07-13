//
//  ShopReatedManInfoView.h
//  retailapp
//
//  Created by taihangju on 16/6/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopReatedManInfoView : UIView

+ (ShopReatedManInfoView *)userInfoView:(CGFloat)topY user:(NSString *)userName;
+ (ShopReatedManInfoView *)shopSaleInfoView:(CGFloat)topY backBlock:(void(^)())shopSalePerfomance;
@end
