//
//  LSLogisticModuleController.m
//  retailapp
//
//  Created by guozhi on 2016/11/9.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

// 启用装箱单
#define CONFIG_OPEN_PACKAGE_STATUS @"CONFIG_OPEN_PACKAGE_STATUS"
//允许拒绝配送中的收货单
#define CONFIG_ALLOW_SENDING_REFUSE @"CONFIG_ALLOW_SENDING_REFUSE"
//允许对配送中的收货单进行修改
#define CONFIG_ALLOW_SENDING_UPDATE @"CONFIG_ALLOW_SENDING_UPDATE"
//查看同级店铺库存 1:关闭 2:开启（默认）
#define CONFIG_SEE_BROTHER_STORE @"CONFIG_SEE_BROTHER_STORE"
#import "LSLogisticModuleController.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "SupplierListView.h"
#import "LogisticQueryView.h"
#import "PackBoxListView.h"
#import "ReturnTypeListView.h"
#import "ReturnGuideList.h"
#import "PaperListView.h"


@implementation LSLogisticModuleController

- (void)viewDidLoad {
    [super viewDidLoad];
     [[Platform Instance] saveKeyWithVal:PACK_BOX_FLAG withVal:@"0"];
    [self configTitle:@"出入库管理"];
    [self createDatas];
    [self loadData];
    
}
- (void)createDatas {
    self.datas = [NSMutableArray array];
    LSModuleModel *model = nil;
    if ([[Platform Instance] getShopMode]!= 1 && ![[Platform Instance] isTopOrg]) {
        //连锁模式显示
        model = [LSModuleModel moduleModelWithName:@"采购单" detail:@"采购、补货" path:@"ico_nav_paper" code:ACTION_STOCK_ORDER];
        [self.datas addObject:model];
    }
    model = [LSModuleModel moduleModelWithName:@"收货入库单" detail:@"收货、入库" path:@"ico_nav_paper" code:ACTION_STOCK_IN];
    [self.datas addObject:model];
    
    if ([[[Platform Instance] getkey:PACK_BOX_FLAG] integerValue]==1&&[[Platform Instance] getShopMode]!=1) {
        //系统参数设置启用装箱单开关打开显示
         model = [LSModuleModel moduleModelWithName:@"装箱单" detail:@"装箱单" path:@"ico_nav_paper" code:ACTION_STOCK_PACK];
        [self.datas addObject:model];
    }
    
    if ([[Platform Instance] isTopOrg] && [[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) { //	服鞋版连锁总部用户登录时表示，以外情况非表示
        //总部用户登录显示退货类型
        model = [LSModuleModel moduleModelWithName:@"退货类型" detail:@"管理退货类型" path:@"ico_nav_paper" code:MATERIAL_RETURN_TYPE];
        [self.datas addObject:model];
    }
    
//    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue]==CLOTHESHOES_MODE && [[Platform Instance] isTopOrg]) {
//            //连锁模式，服鞋版显示
//     model = [LSModuleModel moduleModelWithName:@"退货指导" detail:@"退货指导" path:@"ico_nav_paperr" code:ACTION_STOCK_RETURN_GUIDE];
//    [self.datas addObject:model];
//        }
    model = [LSModuleModel moduleModelWithName:@"退货出库单" detail:@"退货、出库" path:@"ico_nav_paper" code:ACTION_STOCK_RETURN];
    [self.datas addObject:model];
    if ([[Platform Instance] getShopMode]!=1) {
        //单店模式不显示调拨单
        model = [LSModuleModel moduleModelWithName:@"门店调拨单" detail:@"门店调拨" path:@"ico_nav_paper" code: ACTION_STOCK_ALLOCATE];
        [self.datas addObject:model];
    }
    if ([[Platform Instance] getShopMode]==3) {
        //机构登录显示客户叫货单、客户退货单
        model = [LSModuleModel moduleModelWithName:@"客户采购单" detail:@"查询、审核客户的采购单" path:@"ico_nav_paper" code:ACTION_STOCK_ORDER_SEARCH];
        [self.datas addObject:model];
        model = [LSModuleModel moduleModelWithName:@"客户退货单" detail:@"查询、审核客户的退货单" path:@"ico_nav_paper" code:ACTION_STOCK_RETURN_SEARCH];
        [self.datas addObject:model];
    }
    model = [LSModuleModel moduleModelWithName:@"出入库记录" detail:@"查询出入库记录" path:@"ico_nav_query" code:ACTION_MATERIAL_FLOW];
    [self.datas addObject:model];
    model = [LSModuleModel moduleModelWithName:@"供应商" detail:@"供应商信息管理" path:@"ico_gongyingshang" code:ACTION_SUPPLIER_MANAGE];
    [self.datas addObject:model];
    
}

- (void)loadData {
    //系统参数设置
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:CONFIG_OPEN_PACKAGE_STATUS];
    [arr addObject:CONFIG_ALLOW_SENDING_REFUSE];
    [arr addObject:CONFIG_ALLOW_SENDING_UPDATE];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:arr forKey:@"codeList"];
    NSString *url = @"config/multiConfigListStatus";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:NO CompletionHandler:^(id json) {
        //是否启用装箱单 1 开 2 关
        NSDictionary *map = [json objectForKey:@"statusMaps"];
        NSString *flg = [ObjectUtil isNotNull:[map objectForKey:CONFIG_OPEN_PACKAGE_STATUS]]&&[[map objectForKey:CONFIG_OPEN_PACKAGE_STATUS] isEqualToString:@"1"]?@"1":@"0";
        [[Platform Instance] saveKeyWithVal:PACK_BOX_FLAG withVal:flg];
        //拒绝配送中的收货单
        flg = [ObjectUtil isNotNull:[map objectForKey:CONFIG_ALLOW_SENDING_REFUSE]]&&[[map objectForKey:CONFIG_ALLOW_SENDING_REFUSE] isEqualToString:@"1"]?@"1":@"0";
        [[Platform Instance] saveKeyWithVal:DISTRIBUTION_REFUSE_FLAG withVal:flg];
        //修改配送中的收货单
        flg = [ObjectUtil isNotNull:[map objectForKey:CONFIG_ALLOW_SENDING_UPDATE]]&&[[map objectForKey:CONFIG_ALLOW_SENDING_UPDATE] isEqualToString:@"1"]?@"1":@"0";
        [[Platform Instance] saveKeyWithVal:DISTRIBUTION_EDIT_FLAG withVal:flg];
        [wself createDatas];
        [wself.tableView reloadData];

    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

//点击单元格调用
- (void)showActionCode:(NSString *)code {
    UIViewController *vc = nil;
    if ([code isEqualToString:ACTION_SUPPLIER_MANAGE]) {
        //供应商管理
        vc = [[SupplierListView alloc] init];
    }else if ([code isEqualToString:ACTION_MATERIAL_FLOW]) {
        //出入库查询
        vc = [[LogisticQueryView alloc] init];
    }else if ([code isEqualToString:ACTION_STOCK_PACK]){
        //装箱单一览
        vc = [[PackBoxListView alloc] init];
    }else if ([code isEqualToString:MATERIAL_RETURN_TYPE]){
        //退货类型一览
        vc = [[ReturnTypeListView alloc] init];
    }
        else if ([code isEqualToString:ACTION_STOCK_RETURN_GUIDE]) {
            //退货指导
            ReturnGuideList *vc = [[ReturnGuideList alloc] init];
            [self.navigationController pushViewController:vc animated:NO];
        }
    else {
        PaperListView *paperVc = [[PaperListView alloc] init];
        vc = paperVc;
        if ([code isEqualToString:ACTION_STOCK_ORDER]) {
            // -> 采购叫货单
            paperVc.paperType = ORDER_PAPER_TYPE;
        }else if ([code isEqualToString:ACTION_STOCK_IN]){
            // -> 收货入库单
            paperVc.paperType = PURCHASE_PAPER_TYPE;
        }else if ([code isEqualToString:ACTION_STOCK_RETURN]){
            // -> 退货出库单
            paperVc.paperType = RETURN_PAPER_TYPE;
        }else if ([code isEqualToString:ACTION_STOCK_ALLOCATE]){
            // -> 门店调拨单
            paperVc.paperType = ALLOCATE_PAPER_TYPE;
        }else if ([code isEqualToString:ACTION_STOCK_ORDER_SEARCH]) {
            // -> 客户采购单
            paperVc.paperType = CLIENT_ORDER_PAPER_TYPE;
        }else if ([code isEqualToString:ACTION_STOCK_RETURN_SEARCH]) {
            // -> 客户退货单
            paperVc.paperType = CLIENT_RETURN_PAPER_TYPE;
        }
    }
    [self pushViewController:vc];
    
    
}

@end
