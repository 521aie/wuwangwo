//
//  LSGoodsModuleController.m
//  retailapp
//
//  Created by guozhi on 2016/11/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSGoodsModuleController.h"
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "ServiceFactory.h"


#import "GoodsCategoryListView.h"
#import "LSGoodsInfoSelectViewController.h"
#import "GoodsStyleInfoView.h"
#import "GoodsAttributeListView.h"
#import "GoodsInnerCodeRegulationSettingView.h"
#import "GoodsOperationList.h"

@interface LSGoodsModuleController ()

@end

@implementation LSGoodsModuleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTitle:@"商品管理"];
    [self createDatas];
}

- (void)createDatas {
    self.datas = [NSMutableArray array];
    LSModuleModel *model = nil;
    //101服鞋 102商超
    if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
        model = [LSModuleModel moduleModelWithName:@"商品品类" detail:@"商品品类管理" path:@"ico_nav_goods_sort" code:ACTION_CATEGORY_MANAGE];
        [self.datas addObject:model];
    } else {
        model = [LSModuleModel moduleModelWithName:@"商品分类" detail:@"商品分类管理" path:@"ico_nav_goods_sort" code:ACTION_CATEGORY_MANAGE];
        [self.datas addObject:model];
    }
    
    
    if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 102) {
        model = [LSModuleModel moduleModelWithName:@"商品信息" detail:@"商品信息管理" path:@"ico_nav_goods_inf" code:GOODS_INFO_MANAGE];
        [self.datas addObject:model];
        model = [LSModuleModel moduleModelWithName:@"商品拆分" detail:@"将大件商品拆分成小件商品出售" path:@"ico_nav_shangpinchaifen" code:ACTION_GOODS_SPLIT];
        [self.datas addObject:model];
        model = [LSModuleModel moduleModelWithName:@"商品组装" detail:@"将小件商品组装成大件商品出售" path:@"ico_nav_shangpinzhuzhuang" code:ACTION_GOODS_PACKAGE];
        [self.datas addObject:model];
        model = [LSModuleModel moduleModelWithName:@"商品加工" detail:@"将原料商品加工成另外一件商品出售" path:@"ico_nav_shangpinjiagong" code:ACTION_GOODS_PROCESS];
        [self.datas addObject:model];
    }
    
    
    if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
        model = [LSModuleModel moduleModelWithName:@"商品属性" detail:@"商品属性管理" path:@"ico_nav_goods_attribute" code:ACTION_GOODS_ATTRIBUTE_MANAGE];
        [self.datas addObject:model];
        model = [LSModuleModel moduleModelWithName:@"款式信息" detail:@"款式信息管理" path:@"ico_nav_style_info" code:GOODS_STYLE_MANAGE];
        [self.datas addObject:model];
        model = [LSModuleModel moduleModelWithName:@"店内码规则设置" detail:@"设置店内码生成规则" path:@"ico_nav_innercode_set" code:ACTION_INNERCODE_SET];
        [self.datas addObject:model];

    }
}

//点击单元格调用
- (void)showActionCode:(NSString *)code {
    if ([code isEqualToString:ACTION_CATEGORY_MANAGE])
    {
        GoodsCategoryListView* goodsCategoryListView = [[GoodsCategoryListView alloc] initWithTag: GOODS_SECOND_VIEW];
        [self.navigationController pushViewController:goodsCategoryListView animated:NO];
        
    }
    else if ([code isEqualToString:GOODS_INFO_MANAGE])
    {
        if ([[Platform Instance] lockAct:ACTION_GOODS_SEARCH]) {
            [AlertBox show:@"您没有[商品查询]的权限！"];
            return;
        }
        LSGoodsInfoSelectViewController *vc = [[LSGoodsInfoSelectViewController alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
    }
    else if ([code isEqualToString:GOODS_STYLE_MANAGE])
    {
        if ([[Platform Instance] lockAct:ACTION_GOODS_STYLE_SEARCH]) {
            [AlertBox show:@"您没有[款式查询]的权限！"];
            return;
        }
        GoodsStyleInfoView* goodsStyleInfoView = [[GoodsStyleInfoView alloc] init];
        [self.navigationController pushViewController:goodsStyleInfoView animated:NO];
    }
    else if ([code isEqualToString:ACTION_GOODS_ATTRIBUTE_MANAGE])
    {
        GoodsAttributeListView* goodsAttributeListView = [[GoodsAttributeListView alloc] init];
        [self.navigationController pushViewController:goodsAttributeListView animated:NO];
    }
    else if ([code isEqualToString:ACTION_INNERCODE_SET])
    {
        GoodsInnerCodeRegulationSettingView* goodsInnerCodeRegulationSettingView = [[GoodsInnerCodeRegulationSettingView alloc] init];
        [self.navigationController pushViewController:goodsInnerCodeRegulationSettingView animated:NO];
    }
    else if ([code isEqualToString:ACTION_GOODS_SPLIT]||[code isEqualToString:ACTION_GOODS_PACKAGE]||[code isEqualToString:ACTION_GOODS_PROCESS])
    {
        NSString *title = nil;
        if ([code isEqualToString:ACTION_GOODS_SPLIT]) {
            title = @"商品拆分";
        }
        if ([code isEqualToString:ACTION_GOODS_PACKAGE]) {
            title = @"商品组装";
        }
        if ([code isEqualToString:ACTION_GOODS_PROCESS]) {
            title = @"商品加工管理";
        }
        GoodsOperationList* goodsOperationList = [[GoodsOperationList alloc] initWithTitle:title];
        [self.navigationController pushViewController:goodsOperationList animated:NO];
    }
    
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}



@end
