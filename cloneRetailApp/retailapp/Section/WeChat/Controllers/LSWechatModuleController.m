//
//  LSWechatModuleController.m
//  retailapp
//
//  Created by guozhi on 2016/11/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#define REPORT_TYPE1 @"基础设置"
#define REPORT_TYPE2 @"订单管理"
#define REPORT_TYPE3 @"提现管理"
#define REPORT_TYPE4 @"我的微店管理"
#import "LSWechatModuleController.h"
#import "NavigateTitle2.h"
#import "HeaderItem.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "MicroDistributeService.h"
#import "MicroDistributeVo.h"
#import "ServiceFactory.h"
#import "WechatSetView.h"
#import "OrderDealView.h"
#import "DistributionView.h"
#import "WechatSalePackManageListView.h"
#import "WechatOrderListView.h"
#import "PointExOrderListView.h"
#import "SellRetrunListView.h"
#import "WithdrawListView.h"
#import "VirtualStockManagementView.h"
#import "LSWechatStyleManageViewController.h"
#import "HomePagePreview.h"
#import "WeChatReturnMoneyManager.h"
#import "AccountInfo.h"
#import "MicroBasicSetVo.h"
#import "JsonHelper.h"
#import "LSWechatGoodManageViewController.h"
//#import "UIViewController+Extension.h"

//<<<<<<< HEAD
//=======
#import "WechatApplyView.h"
//
//>>>>>>> dev
@interface LSWechatModuleController ()
/**判断登陆门店是不是订单处理机构门店*/
//@property (nonatomic,assign) BOOL isOrderShop;
/**判断是否可以进入积分商品库存*/
@property (nonatomic, assign) BOOL isRoot;
/**保存微店设置中-"微店交易需判断可销售数量"的开关状态*/
@property (nonatomic, assign) BOOL isVirtualRoot;
@property (nonatomic, strong) MicroBasicSetVo *microBasicSetVo;
@end

@implementation LSWechatModuleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTitle:@"微店管理"];
    self.map = [NSMutableDictionary dictionary];
    self.datas = [NSMutableArray array];
    [self loadData];
    [self createDatas];
}

- (void)createDatas {
    [self.map removeAllObjects];
    [self.datas removeAllObjects];
    
    NSMutableArray *list = [NSMutableArray array];
    LSModuleModel *model = nil;
    if ([[Platform Instance] getMicroShopStatus] != 2) {
        
    } else {//商户开通微店
//        if ([[Platform Instance] getShopMode] != 3) {
//            model = [LSModuleModel moduleModelWithName:@"微店信息" detail:@"设置微店基本信息" path:@"ico_nav_wechat_basic" code:ACTION_WEISHOP];
//            [list addObject:model];
            model = [LSModuleModel moduleModelWithName:@"店铺二维码" detail:@"店铺二维码下载及分享" path:@"ico_wechat_qrcode" code:ACTION_WEIDIAN_QR_CODE];
            [list addObject:model];

            model = [LSModuleModel moduleModelWithName:@"微店设置" detail:@"微店相关的偏好设置" path:@"ico_nav_wechat_setting" code:ACTION_WEISHOP_SET];
            [list addObject:model];

            model = [LSModuleModel moduleModelWithName:@"配送管理" detail:@"设置配送费用等" path:@"ico_nav_wechat_distribution" code:ACTION_WEISHOP_DISTRIBUTION_SET];
            [list addObject:model];
        }
    
        [self.map setValue:list forKey:REPORT_TYPE1];
        if (list.count > 0) {
            [self.datas addObject:REPORT_TYPE1];
        }
        
        list = [NSMutableArray array];
        model = [LSModuleModel moduleModelWithName:@"销售订单" detail:@"查看待处理、已完成等订单详情" path:@"ico_nav_wechat_order" code:ACTION_WEISHOP_ORDER];
        [list addObject:model];
    
        model = [LSModuleModel moduleModelWithName:@"积分兑换订单" detail:@"查看待处理、已完成的积分兑换订单" path:@"ico_nav_wechat_point" code:ACTION_WEISHOP_POINT_EXCHANGE];
        [list addObject:model];
    
        // 单店，连锁总部，门店 可见
        if ([[[Platform Instance] getkey:PARENT_ID] isEqualToString:@"0"] || [[Platform Instance] getShopMode] == 2) {
            model = [LSModuleModel moduleModelWithName:@"退货审核" detail:@"管理退货单及退货商品" path:@"ico_nav_wechat_return" code:ACTION_WEISHOP_RETURN_GOODS];
            [list addObject:model];
        }
    
        model = [LSModuleModel moduleModelWithName:@"退款管理" detail:@"管理退款明细" path:@"ico_return_money_manager" code:ACTION_REFUND_MANAGE];
        [list addObject:model];
    
        [self.map setValue:list forKey:REPORT_TYPE2];
        if (list.count > 0) {
            [self.datas addObject:REPORT_TYPE2];
        }
    
        list = [NSMutableArray array];
        model = [LSModuleModel moduleModelWithName:@"微店主页设置" detail:@"设置微店主页的图片、链接等" path:@"ico_wechat_home_set" code:ACTION_WEISHOP_HOMEPAGE_MANAGE];
        [list addObject:model];
    
        model = [LSModuleModel moduleModelWithName:@"微店商品信息" detail:@"设置微店商品上下架、是否销售等" path:@"ico_nav_wechat_goods" code:ACTION_WEISHOP_GOODS];
        [list addObject:model];

        model = [LSModuleModel moduleModelWithName:@"微店可销售数量设置" detail:@"查看及设置微店商品可销售数量" path:@"ico_nav_virtualstock" code:ACTION_VIRTUAL_STOCK_MANAGE];
        [list addObject:model];

        [self.map setValue:list forKey:REPORT_TYPE4];
        if (list.count > 0) {
            [self.datas addObject:REPORT_TYPE4];
        }
    
    [self.tableView reloadData];
}

- (void)loadData {
    NSString *url = @"microBasicSet/v1/list";
    __weak typeof(self) wself = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];

    // 获取微店设置模块中-“微店交易需判断可销售数量”开关的状态
    url = @"microBasicSet/selectMicroValByCode";
    [param removeAllObjects];
    [param setValue:@"CONFIG_START_VIRTURL_STOCK" forKey:@"code"];
    [param setValue:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:NO CompletionHandler:^(id json) {
        //1是开 2是关
        wself.isVirtualRoot = [[json objectForKey:@"val"] intValue] == 1;
        [wself createDatas];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

//点击单元格调用
- (void)showActionCode:(NSString *)code {
    UIViewController *vc=nil;
//<<<<<<< HEAD
//
//    if ([code isEqualToString:ACTION_WEISHOP]) {
//=======
    if ([code isEqualToString:ACTION_WEIDIAN_QR_CODE]) {
//        vc = [[WechatApplyView alloc] initWithNibName:[SystemUtil getXibName:@"WechatApplyView"] bundle:nil];
        vc = [[WechatApplyView alloc] init];
    } else if ([code isEqualToString:ACTION_WEISHOP_SET]) {
//        vc = [[WechatSetView alloc] initWithNibName:[SystemUtil getXibName:@"WechatSetView"] bundle:nil];
        vc = [[WechatSetView alloc] init];
    }else if ([code isEqualToString:ACTION_WEISHOP_DISTRIBUTION_SET]){
        vc = [[DistributionView alloc] init];
    }else if ([code isEqualToString:ACTION_WEISHOP_ORDER]){
        vc = [[WechatOrderListView alloc] init];
    }else if ([code isEqualToString:ACTION_WEISHOP_POINT_EXCHANGE]){
        vc = [[PointExOrderListView alloc] init];
    }else if ([code isEqualToString:ACTION_WEISHOP_RETURN_GOODS]){
        vc = [[SellRetrunListView alloc] init];
    }else if ([code isEqualToString:ACTION_WEISHOP_GOODS]){
        // 101服鞋、 102商超
        if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {
            // 微店商品信息 - > 微店款式
            vc = [[LSWechatStyleManageViewController alloc] init];
        }else if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 102) {
            //            vc=[[WechatGoodsManagementView alloc] initWithNibName:[SystemUtil getXibName:@"WechatGoodsManagementView"] bundle:nil];
            vc = [[LSWechatGoodManageViewController alloc] init];
        }
    }else if ([code isEqualToString:ACTION_VIRTUAL_STOCK_MANAGE]){
        // 微店可销售数量设置
        if (!self.isVirtualRoot) {
            [LSAlertHelper showAlert:@"只有开启了微店-微店设置中的“微店交易需判断可销售数量”开关，才能设置微店可销售数量！"];
            return;
        }        
        // 点击菜单中的
        vc = [[VirtualStockManagementView alloc] init];
    }else if([code isEqualToString:ACTION_WEISHOP_HOMEPAGE_MANAGE]){
        //微店主页设置
        vc = [[HomePagePreview alloc] init];
    }else if ([code isEqualToString:ACTION_REFUND_MANAGE]){
        //退款管理
        vc = [[WeChatReturnMoneyManager alloc] init];
    }
    
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

@end
