//
//  ShopCommnetView.h
//  retailapp
//
//  Created by Jianyong Duan on 15/11/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSRootViewController.h"

#import "NavigateTitle2.h"
#import "EditItemList.h"

typedef NS_ENUM(NSInteger ,LSShopType) {
    LSShop_Entity, // 实体门店
    LSShop_Wechat, // 微店
};

@interface ShopCommnetView : LSRootViewController

-(instancetype)initWithType:(LSShopType)type;

@end
