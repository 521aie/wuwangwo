//
//  LSMarketModuleController.m
//  retailapp
//
//  Created by guozhi on 2016/10/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMarketModuleController.h"
#import "NavigateTitle2.h"
#import "AlertBox.h"
#import "LSMarketListController.h"
#import "SelectOrgShopListView.h"
#import "BirthdaySalesView.h"
#import "XHAnimalUtil.h"


@implementation LSMarketModuleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTitle:@"营销管理"];
    [self createDatas];
}
- (void)createDatas {
    LSModuleModel *model = nil;
    self.datas = [NSMutableArray array];
    model = [LSModuleModel moduleModelWithName:@"特价管理" detail:@"管理特价活动及商品" path:@"icon_yingxiao_tejia" code:ACTION_SPECIAL_PRICE];
    [self.datas addObject:model];
    model = [LSModuleModel moduleModelWithName:@"满送/换购" detail:@"每满X件/元加N元送Y件商品，最多送Z件" path:@"icon_yingxiao_mansong" code:ACTION_MATCH_SWAP];
    [self.datas addObject:model];
    model = [LSModuleModel moduleModelWithName:@"满减" detail:@"每满X件/元减N元，最多减M元" path:@"icon_yingxiao_manjian" code:ACTION_MATCH_DECREASE];
    [self.datas addObject:model];
    model = [LSModuleModel moduleModelWithName:@"捆绑打折" detail:@"满1件X折，满2件Y折，满3件Z折..." path:@"icon_yingxiao_kunbang" code:ACTION_SALES_BINDING];
    [self.datas addObject:model];
    model = [LSModuleModel moduleModelWithName:@"第N件打折" detail:@"第1件X折，第2件Y折，第3件Z折..." path:@"icon_yingxiao_Njiandazhe" code:ACTION_SALES_N_DISCOUNT];
    [self.datas addObject:model];
    
    model = [LSModuleModel moduleModelWithName:@"优惠券" detail:@"管理优惠券" path:@"icon_yingxiao_youhuiquan" code:ACTION_SALES_COUPON];
    [self.datas addObject:model];
    model = [LSModuleModel moduleModelWithName:@"生日促销" detail:@"针对会员生日设置的促销活动" path:@"icon_yingxiao_shengri" code:ACTION_SALES_BIRTHDAY];
    [self.datas addObject:model];
}

#pragma mark -  点击单元格时调用
- (void)showActionCode:(NSString *)code {
    UIViewController *vc = nil;
    if ([code isEqualToString:ACTION_SPECIAL_PRICE]) {
         vc = [[LSMarketListController alloc] initWithAction:SPECIAL_OFFER_LIST_VIEW];
    } else if ([code isEqualToString:ACTION_SALES_N_DISCOUNT]) {
        vc = [[LSMarketListController alloc] initWithAction:PIECES_DISCOUNT_LIST_VIEW];
    } else if ([code isEqualToString:ACTION_SALES_BIRTHDAY]) {
        vc = [[BirthdaySalesView alloc] initWithNibName:[SystemUtil getXibName:@"BirthdaySalesView"] bundle:nil];
    } else if ([code isEqualToString:ACTION_SALES_BINDING]) {
        vc = [[LSMarketListController alloc] initWithAction:BINDING_DISCOUNT_LIST_VIEW];
    } else if ([code isEqualToString:ACTION_MATCH_SWAP]) {
        vc = [[LSMarketListController alloc] initWithAction:SALES_SEND_OR_SWAP_LIST_VIEW];
    } else if ([code isEqualToString:ACTION_MATCH_DECREASE]) {
        vc = [[LSMarketListController alloc] initWithAction:SALES_MINUS_LIST_VIEW];
    } else if ([code isEqualToString:ACTION_SALES_COUPON]) {
        vc = [[LSMarketListController alloc] initWithAction:SALES_COUPON_LIST_VIEW];
    }
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}


@end
