//
//  LSAddShopInfoController.h
//  retailapp
//
//  Created by guozhi on 2017/2/23.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
@class ShopVo;
@interface LSAddShopInfoController : LSRootViewController
- (instancetype)initWithShopVo:(ShopVo *)shopVo adressList:(NSArray *)adressList professionList:(NSArray *)professionList;
- (void)loadData;
@end
