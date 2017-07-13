//
//  LSCommentModuleController.m
//  retailapp
//
//  Created by guozhi on 2016/11/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSCommentModuleController.h"
#import "NavigateTitle2.h"
#import "UIMenuAction.h"
#import "ActionConstants.h"
#import "Platform.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"
#import "SystemUtil.h"
#import "MicroBasicSetVo.h"
#import "ShopCommnetView.h"
#import "GoodsCommentView.h"

@implementation LSCommentModuleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTitle:@"顾客评价"];
    self.datas = [NSMutableArray array];
    [self createMenus];
    [self configHelpButton:HELP_COMMENT];
}

/**
 *  注意：
 *  请结合ModuleConfigView 文件中首页的权限配置统一调整该出的子模块配置
 *  目前默认开启微店才会显示顾客评价，而且微店只在服鞋模式有
 *  微分销只是开通微店的总部用户，大伙伴是没有微分销的
 */
- (void)createMenus {
    [self.datas removeAllObjects];
    LSModuleModel *model = nil;
    // 单店开通微店同样显示微店相关的评价项
//    if ([[Platform Instance] isTopOrg] || [[Platform Instance] getShopMode] == 1) {
        model = [LSModuleModel moduleModelWithName:@"店铺评价(实体)" detail:nil path:@"ico_comment_shop" code:ACTION_SHOP_COMMENT];
        [self.datas addObject:model];
        model = [LSModuleModel moduleModelWithName:@"店铺评价(微店)" detail:nil path:@"ico_comment_shop" code:ACTION_WEISHOP_COMMENT];
        [self.datas addObject:model];
        model = [LSModuleModel moduleModelWithName:@"商品评价(实体)" detail:nil path:@"ico_comment_goods" code:ACTION_GOODS_COMMENT];
        [self.datas addObject:model];
        model = [LSModuleModel moduleModelWithName:@"商品评价(微店)" detail:nil path:@"ico_comment_goods" code:ACTION_WEISHOP_GOODS_COMMENT];
        [self.datas addObject:model];
//    }
//    else if(![[Platform Instance] isTopOrg] || [[Platform Instance] getShopMode] == 2) {
//        model = [LSModuleModel moduleModelWithName:@"店铺评价(实体)" detail:nil path:@"ico_comment_shop" code:ACTION_SHOP_COMMENT];
//        [self.datas addObject:model];
//        model = [LSModuleModel moduleModelWithName:@"商品评价(实体)" detail:nil path:@"ico_comment_goods" code:ACTION_GOODS_COMMENT];
//        [self.datas addObject:model];
//    }
}

//点击单元格调用
- (void)showActionCode:(NSString *)code {
    UIViewController *vc;
    if ([code isEqualToString:ACTION_SHOP_COMMENT]) {
        // 店铺评价(实体)
//        vc = [[ShopCommnetView alloc] initWithNibName:[SystemUtil getXibName:@"ShopCommnetView"] bundle:nil type:0];
        vc = [[ShopCommnetView alloc] initWithType:0];
    } else if ([code isEqualToString:ACTION_WEISHOP_COMMENT]) {
        // 店铺评价(微店)
//        vc = [[ShopCommnetView alloc] initWithNibName:[SystemUtil getXibName:@"ShopCommnetView"] bundle:nil type:1];
        vc = [[ShopCommnetView alloc] initWithType:1];
    } else if ([code isEqualToString:ACTION_GOODS_COMMENT]) {
        // 商品评价(实体)
//        vc = [[GoodsCommentView alloc] initWithNibName:[SystemUtil getXibName:@"GoodsCommentView"] bundle:nil type:0];
        vc = [[GoodsCommentView alloc] initWithType:0];
    }  else if ([code isEqualToString:ACTION_WEISHOP_GOODS_COMMENT]) {
        // 商品评价(微店)
//        vc = [[GoodsCommentView alloc] initWithNibName:[SystemUtil getXibName:@"GoodsCommentView"] bundle:nil type:1];
        vc = [[GoodsCommentView alloc] initWithType:1];
    }
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    [self.navigationController pushViewController:vc animated:NO];
}

@end
