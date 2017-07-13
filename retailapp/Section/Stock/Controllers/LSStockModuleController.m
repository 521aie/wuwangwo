//
//  LSStockModuleController.m
//  retailapp
//
//  Created by guozhi on 2016/11/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSStockModuleController.h"
#import "SystemUtil.h"
#import "XHAnimalUtil.h"
#import "LSStockQueryViewController.h"
#import "LSStockAdjustListController.h"
#import "AdjustReasonListView.h"
#import "AdjustReasonEditView.h"
#import "WarehouseListView.h"
#import "WarehouseEditView.h"
#import "SelectOrgListView.h"
#import "SelectShopStoreListView.h"
#import "AlertSettingView.h"
#import "AlertBox.h"
#import "DicItemConstants.h"
#import "LSStockSummaryViewController.h"
#import "StockService.h"
#import "ServiceFactory.h"
//#import "AFHTTPRequestOperation.h"
#import "NavigateTitle2.h"
#import "LSStockChangeViewController.h"
#import "LSCostAdjustListController.h"
#import "LSCostChangeRecordViewController.h"
//#import "UIViewController+Extension.h"

@interface LSStockModuleController ()
/**判断是否可以进入积分商品库存*/
@property (nonatomic, assign) BOOL isRoot;
@end

@implementation LSStockModuleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self selectSystemParam];
    [self configTitle:@"库存管理"];
    [self createDats];
}

- (void)createDats {
    self.datas = [NSMutableArray array];
    LSModuleModel *model = [LSModuleModel moduleModelWithName:@"库存查询" detail:@"查询商品剩余库存数" path:@"ico_nav_query" code:ACTION_STOCK_SEARCH];
    [self.datas addObject:model];
    
    
    // 服鞋
    if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
        model = [LSModuleModel moduleModelWithName:@"库存汇总查询" detail:@"库存汇总查询" path:@"ico_nav_stocksummary" code:ACTION_STOCK_SUMMARIZE_SEARCH];
        [self.datas addObject:model];
    }
    
    model = [LSModuleModel moduleModelWithName:@"库存调整" detail:@"调整商品库存数" path:@"ico_nav_stockadjust" code:ACTION_STOCK_ADJUST];
    [self.datas addObject:model];
    
    model = [LSModuleModel moduleModelWithName:@"成本价调整" detail:@"调整商品库存成本价" path:@"ico_nav_cost_adjust_record" code:ACTION_COST_PRICE_BILLS];
    [self.datas addObject:model];
    
    model = [LSModuleModel moduleModelWithName:@"库存变更记录" detail:@"查询商品的库存变更记录" path:@"ico_report_stockChange" code:ACTION_STOCK_CHANGE_SEARCH];
    [self.datas addObject:model];
    
    model = [LSModuleModel moduleModelWithName:@"成本价变更记录" detail:@"查询商品的成本价变更记录" path:@"ico_nav_cost_adjust" code:ACTION_COST_PRICE_CHANGELOG];
    [self.datas addObject:model];

    
    // 商超才有提醒设置
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 102) {
        model = [LSModuleModel moduleModelWithName:@"提醒设置" detail:@"提醒设置" path:@"ico_nav_alertset" code:ACTION_REMIND_SETTING];
        [self.datas addObject:model];
    }
    
    // 组织机构才有"仓库管理"
    if ([[Platform Instance] getShopMode] == 3) {
        model = [LSModuleModel moduleModelWithName:@"仓库管理" detail:@"仓库管理" path:@"ico_nav_warehouse" code:ACTION_WARE_HOUSE_MANAGE];
        [self.datas addObject:model];
    }
}

- (void)selectSystemParam {
    //系统参数设置
    NSDictionary *param = @{@"codeList":@[CONFIG_SEE_BROTHER_STORE]};
    NSString *url = @"config/multiConfigListStatus";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:NO CompletionHandler:^(id json) {
        //查看同级店铺库存，"CONFIG_SEE_BROTHER_STORE" = 2 表示关闭 = 1 表示开启
        NSDictionary *map = [json objectForKey:@"statusMaps"];
        NSString *flg = [ObjectUtil isNotNull:[map objectForKey:CONFIG_SEE_BROTHER_STORE]] &&[[map objectForKey:CONFIG_SEE_BROTHER_STORE] isEqualToString:@"1"]?@"1":@"0";
        [[Platform Instance] saveKeyWithVal:STORE_CHECK_FLAG withVal:flg];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
    //判断是否启用实体门店积分商品库存
    url = @"config/singleDetail";
    param = @{@"code":@"CONFIG_POINTS_GOODS_STOCK",
              @"entityId":[[Platform Instance] getkey:ENTITY_ID]};
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:NO CompletionHandler:^(id json) {
        //1是开 2是关
        wself.isRoot = [[json objectForKey:@"val"] intValue] == 1;
    } errorHandler:^(id json) {
         [AlertBox show:json];
    }];
}

#pragma mark - 处理跳转关系
//点击单元格调用
- (void)showActionCode:(NSString *)code {
    UIViewController *vc = nil;
    if ([code isEqualToString:ACTION_STOCK_SEARCH]) {
        // -> 库存查询
        vc = [[LSStockQueryViewController alloc] init];
    } else if ([code isEqualToString:ACTION_STOCK_CHANGE_SEARCH]){ //库存变更记录
        vc = [[LSStockChangeViewController alloc] init];
    } else if ([code isEqualToString:ACTION_STOCK_SUMMARIZE_SEARCH]) {
        // -> 库存汇总查询
        vc = [[LSStockSummaryViewController alloc] init];
    } else if ([code isEqualToString:ACTION_STOCK_ADJUST]) {
        // -> 库存调整
        vc = [[LSStockAdjustListController alloc] init];
       
    } else if ([code isEqualToString:ACTION_STOCK_CHECK]) {
        // -> 库存盘点
        
    } else if ([code isEqualToString:ACTION_STOCK_CHECK_SEARCH]){
        // -> 盘点记录查询
        
    } else if ([code isEqualToString:ACTION_REMIND_SETTING]) {
        // -> 提醒设置
        vc = [[AlertSettingView alloc] init];
       
        
    } else if ([code isEqualToString:ACTION_WARE_HOUSE_MANAGE]) {
        // -> 仓库管理
        vc = [[WarehouseListView alloc] init];
       
    } else if ([code isEqualToString:ACTION_COST_PRICE_CHANGELOG]) {
        // -> 成本价变更记录
        vc = [[LSCostChangeRecordViewController alloc] init];
        
    } else if ([code isEqualToString:ACTION_COST_PRICE_BILLS]) {
        // -> 成本价调整
        vc = [[LSCostAdjustListController alloc] init];
        
    }
    [self pushViewController:vc];
}

@end
