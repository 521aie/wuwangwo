//
//  LSSettingModuleController.m
//  retailapp
//
//  Created by guozhi on 2016/11/9.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#define kBaseSetting @"基础设置"
#define kCashSetting @"收银设置"
#define kOtherSetting @"其它设置"
#import "LSSettingModuleController.h"
#import "XHAnimalUtil.h"
#import "NavigateTitle2.h"
#import "NameItemVO.h"
#import "UIMenuAction.h"
#import "DHHeadItem.h"
#import "ObjectUtil.h"
#import "AlertBox.h"
#import "ViewFactory.h"
#import "LSSystemParameterController.h"
#import "SubOrgShopListView.h"
#import "OrgBranchListView.h"
#import "SelectOrgListView.h"
#import "SelectOrgShopListView.h"
#import "SelectShopListView.h"
#import "EnterCircleListView.h"
#import "SmsSetController.h"

#import "LSDataClearController.h"
#import "SettingModuleEvent.h"
#import "LSKindPayListController.h"
#import "GuestNoteListView.h"
#import "TicketSetViewController.h"
#import "LSScreenAdvertisingController.h"
#import "LSShopInfoSetController.h"
#import "LSChainShopInfoController.h"
#import "LSOrgInfoController.h"

@interface LSSettingModuleController ()
@end

@implementation LSSettingModuleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleBox.lblTitle.text = @"营业设置";
    [self createDatas];
}

- (void)createDatas {
    self.map = [NSMutableDictionary dictionary];
    LSModuleModel *model = nil;
    NSMutableArray *list = [NSMutableArray array];
    //基础设置
    model = [LSModuleModel moduleModelWithName:@"系统参数" detail:@"收银使用基础设置" path:@"icon_system_setting" code:ACTION_SYS_CONFIG_SETTING];
    [list addObject:model];
    model = [LSModuleModel moduleModelWithName:@"店家信息" detail:@"设置店家基础信息" path:@"icon_shop_info" code:ACTION_SHOP_INFO];
    [list addObject:model];
    
    if ([[Platform Instance] getShopMode] != 3) {
        model = [LSModuleModel moduleModelWithName:@"支付方式" detail:@"设置收银时使用的支付方式" path:@"icon_payment_method" code:ACTION_PAYMENT_TYPE];
        [list addObject:model];
    }
    [self.map setObject:list forKey:kBaseSetting];
    
    //收银设置
    list = [NSMutableArray array];
    model = [LSModuleModel moduleModelWithName:@"小票设置" detail:@"管理收银小票的打印格式" path:@"icon_small_ticket_set" code:ACTION_RECEIPT_SETTING];
    [list addObject:model];
    model = [LSModuleModel moduleModelWithName:@"客单备注" detail:@"管理客单备注信息" path:@"icon_guest_list" code:ACTION_ORDER_MEMO];
    [list addObject:model];
    [self.map setObject:list forKey:kCashSetting];
    
    //其他设置
    list = [NSMutableArray array];
    model = [LSModuleModel moduleModelWithName:@"短信设置" detail:@"设置短信发送规则" path:@"icon_sms_setting" code:ACTION_SMS_SET];
    [list addObject:model];
    if ([[[Platform Instance] getkey:USER_NAME] isEqualToString:@"ADMIN"]) {
        model = [LSModuleModel moduleModelWithName:@"营业数据清理" detail:@"清理账单,报表等营业数据" path:@"icon_data_cleaning" code:ACTION_CLEAN_DATA];
        [list addObject:model];
    }
    model = [LSModuleModel moduleModelWithName:@"店内屏幕广告" detail:@"设置收银机客显应用的图片广告" path:@"ico_screen_advertising" code:ACTION_SCREEN_ADVERTISING];
    [list addObject:model];
    if ([[Platform Instance] getScanPayStatus] == 1) {
        model = [LSModuleModel moduleModelWithName:@"入驻商圈" detail:@"管理商圈入驻" path:@"icon_setting_setMall" code:ACTION_SETTLED_MALL];
        [list addObject:model];
    }
    [self.map setObject:list forKey:kOtherSetting];
    
    self.datas = [NSMutableArray arrayWithArray:@[kBaseSetting, kCashSetting, kOtherSetting]];
}
- (void)showActionCode:(NSString*)actCode
{
    if ([actCode isEqualToString:ACTION_SYS_CONFIG_SETTING]) {
        //系统参数
        LSSystemParameterController *vc = [[LSSystemParameterController alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
    }else if ([actCode isEqualToString:ACTION_SHOP_INFO]) {
        
        if ([[Platform Instance] getShopMode]==1) {
            //单店店家信息
            LSShopInfoSetController *shopInfoSetView = [[LSShopInfoSetController alloc] init];
            [self.navigationController pushViewController:shopInfoSetView animated:NO];
            shopInfoSetView = nil;
        }else if ([[Platform Instance] getShopMode]==2) {
            //门店店家信息
            LSChainShopInfoController *chainShopInfoView = [[LSChainShopInfoController alloc] init];
            chainShopInfoView.isLogin = YES;
            chainShopInfoView.action = ACTION_CONSTANTS_EDIT;
            chainShopInfoView.shopId = [[Platform Instance] getkey:SHOP_ID];
            [self.navigationController pushViewController:chainShopInfoView animated:NO];
            chainShopInfoView = nil;
        }else{
            //机构信息
            LSOrgInfoController *orgInfoView = [[LSOrgInfoController alloc] init];
            orgInfoView.isLogin = YES;
            orgInfoView.action = ACTION_CONSTANTS_EDIT;
            orgInfoView.organizationId = [[Platform Instance] getkey:ORG_ID];
            [self.navigationController pushViewController:orgInfoView animated:NO];
            orgInfoView = nil;
        }
    }else if ([actCode isEqualToString:ACTION_RECEIPT_SETTING]) {
        //小票设置
        //        NoteSetView* noteSetView = [[NoteSetView alloc] initWithNibName:[SystemUtil getXibName:@"NoteSetView"] bundle:nil];
        TicketSetViewController *noteSetView = [[TicketSetViewController alloc] init];
        [self.navigationController pushViewController:noteSetView animated:NO];
        noteSetView = nil;
    }else if ([actCode isEqualToString:ACTION_ORDER_MEMO]) {
        //客单备注
        GuestNoteListView* guestNoteListView = [[GuestNoteListView alloc] initWithNibName:[SystemUtil getXibName:@"GuestNoteListView"] bundle:nil];
        [self.navigationController pushViewController:guestNoteListView animated:NO];
        guestNoteListView = nil;
    }else if ([actCode isEqualToString:ACTION_SMS_SET]) {
        //短信设置
        SmsSetController* smsSetView = [[SmsSetController alloc] init];
//        SmsSetView* smsSetView = [[SmsSetView alloc] initWithNibName:[SystemUtil getXibName:@"SmsSetView"] bundle:nil];
        [self.navigationController pushViewController:smsSetView animated:NO];
        smsSetView = nil;
    }else if ([actCode isEqualToString:ACTION_CLEAN_DATA]) {
        //数据清理
        LSDataClearController *vc = [[LSDataClearController alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
    } else if ([actCode isEqualToString:ACTION_PAYMENT_TYPE]) {
        //支付方式
        LSKindPayListController *vc = [[LSKindPayListController alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
    } else if ([actCode isEqualToString:ACTION_SETTLED_MALL]){
        //入驻商圈
        EnterCircleListView *enterCircleListView = [[EnterCircleListView alloc]initWithNibName:[SystemUtil getXibName:@"EnterCircleListView"] bundle:nil parent:self];
        [self.navigationController pushViewController:enterCircleListView animated:NO];
        enterCircleListView = nil;
    } else if ([actCode isEqualToString:ACTION_SCREEN_ADVERTISING]) {
        //店内屏幕广告
        LSScreenAdvertisingController *vc = [[LSScreenAdvertisingController alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
    }
    
    
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}



@end
