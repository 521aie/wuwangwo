//
//  WechatModule.m
//  retailapp
//
//  Created by diwangxie on 16/4/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberModule.h"
#import "NavigateTitle2.h"
#import "HeaderItem.h"
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "ServiceFactory.h"
#import "JsonHelper.h"
#import "MemberTypeListView.h"
#import "MemberRechargeSalesView.h"
#import "MemberInfoListView.h"
#import "MemberSelectListView.h"
#import "DegreeGoodsListView.h"
#import "LSSmsMarketingViewController.h"
#import "LSBrithdayReminderViewController.h"

#define REPORT_TYPE1 @"基础设置"
#define REPORT_TYPE2 @"会员管理"
#define REPORT_TYPE3 @"会员短信管理"

@interface MemberModule ()<INavigateEvent,UITableViewDataSource,UITableViewDelegate>
@end

@implementation MemberModule

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.titleBox.lblTitle.text = @"会员管理";
//    [self loadData];
//    [self createDatas];
}

//- (void)loadData {
//    NSString *url = @"kindCard/list";
//    [BaseService getRemoteLSDataWithUrl:url param:nil withMessage:nil show:NO CompletionHandler:^(id json) {
//        NSMutableArray* list= [JsonHelper transList:[json objectForKey:@"kindCardList"] objName:@"KindCardVo"];
//        if (list != nil && list.count > 0) {
//            [[Platform Instance] setKindCardList:list];
//        }
//    } errorHandler:^(id json) {
//        [AlertBox show:json];
//    }];
//}
//- (void)createDatas {
//    self.map = [NSMutableDictionary dictionary];
//    self.datas = [NSMutableArray array];
//    
//    NSMutableArray *list = [NSMutableArray array];
//    LSModuleModel *model = [LSModuleModel moduleModelWithName:@"会员类型" detail:@"管理会员类型" path:@"ico_nav_huiyuanleixing" code:ACTION_CARD_CATEGORY];
//    [list addObject:model];
//    model = [LSModuleModel moduleModelWithName:@"兑换设置" detail:@"设置不同的兑换规则" path:@"ico_nav_duihuanshezhi" code:ACTION_POINT_EXCHANGE_SET];
//    [list addObject:model];
//    
//    model = [LSModuleModel moduleModelWithName:@"充值促销" detail:@"设置会员充值的规则" path:@"ico_nav_chongzhicuxiao" code:ACTION_CARD_CHARGE_PROMOTION];
//    [list addObject:model];
//    [self.map setObject:list forKey:REPORT_TYPE1];
//    [self.datas addObject:REPORT_TYPE1];
//    
//    list=[NSMutableArray array];
//    model = [LSModuleModel moduleModelWithName:@"会员信息" detail:@"会员个人详细信息" path:@"icon_huiyuanxinxi" code:ACTION_CARD_SEARCH];
//    [list addObject:model];
//    model = [LSModuleModel moduleModelWithName:@"会员卡挂失" detail:@"会员卡挂失" path:@"icon_huiyuanguashi" code:ACTION_CARD_REPORT_LOSS];
//    [list addObject:model];
//    model = [LSModuleModel moduleModelWithName:@"会员充值" detail:@"管理会员充值" path:@"ico_nav_huiyuanchongzhi" code:ACTION_CARD_CHARGE];
//    [list addObject:model];
//    model = [LSModuleModel moduleModelWithName:@"会员红冲" detail:@"会员充值金额的红冲处理" path:@"ico_nav_huiyuanhongchong" code:ACTION_CARD_UNDO_CHARGE];
//    [list addObject:model];
//    model = [LSModuleModel moduleModelWithName:@"会员退卡" detail:@"管理会员退卡" path:@"ico_nav_huiyuantuika" code:ACTION_CARD_CLOSE];
//    [list addObject:model];
//    model = [LSModuleModel moduleModelWithName:@"积分兑换" detail:@"管理会员积分兑换" path:@"ico_nav_jifenduihuan" code:ACTION_POINT_EXCHANGE];
//    [list addObject:model];
//    [self.map setObject:list forKey:REPORT_TYPE2];
//    [self.datas addObject:REPORT_TYPE2];
//
//    
//    list = [NSMutableArray array];
//
//    action = [[UIMenuAction alloc] init:@"短信营销" detail:@"给会员发送短信" img:@"icon_member_sms" code:ACTION_SMS_SEND];
//    [list addObject:action];
//    
//    action = [[UIMenuAction alloc] init:@"生日提醒" detail:@"设置会员生日提醒" img:@"ico_member_birthday" code:ACTION_BIRTHDAY_REMIND];
//    [list addObject:action];
//    [_detailMap setObject:list forKey:REPORT_TYPE3];
//    [_headList addObject:REPORT_TYPE3];
//}
//
//
//#pragma mark - UITableView Delegate DataSource
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSString *head = [self.headList objectAtIndex:section];
//    NSMutableArray *array = [self.detailMap objectForKey:head];
//    return array.count;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return (self.headList!=nil?self.headList.count:0);
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NavigatorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    NSString *head = [self.headList objectAtIndex:indexPath.section];
//    if ([ObjectUtil isNotNull:head]) {
//        NSMutableArray *details = [self.detailMap objectForKey:head];
//        [cell initWithData:details[indexPath.row]];
//    }
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSString *head = [self.headList objectAtIndex:indexPath.section];
//    if ([ObjectUtil isNotNull:head]) {
//        NSMutableArray *details = [self.detailMap objectForKey:head];
//        UIMenuAction* item=[details objectAtIndex:indexPath.row];
//        BOOL isLockFlag = [[Platform Instance] lockAct:item.code];
//        if (isLockFlag) {
//            [AlertBox show:[NSString stringWithFormat:@"您没有[%@]的权限",item.name]];
//            return;
//        }
//        [self showActionCode:item.code];
//    }
//
//    model = [LSModuleModel moduleModelWithName:@"短信营销" detail:@"给会员发送短信" path:@"icon_member_sms" code:ACTION_SMS_SEND];
//    [list addObject:model];
//    model = [LSModuleModel moduleModelWithName:@"生日提醒" detail:@"设置会员生日提醒" path:@"ico_member_birthday" code:ACTION_BIRTHDAY_REMIND];
//    [list addObject:model];
//    [self.map setObject:list forKey:REPORT_TYPE3];
//    [self.datas addObject:REPORT_TYPE3];
//}
//
//
////点击单元格调用
//- (void)showActionCode:(NSString *)code {
//    if ([code isEqualToString:ACTION_CARD_CATEGORY]){
//        // 会员类型
//        MemberTypeListView* memberTypeListView = [[MemberTypeListView alloc] initWithNibName:[SystemUtil getXibName:@"SampleListView"] bundle:nil];
//        [self.navigationController pushViewController:memberTypeListView animated:NO];
//    }else if ([code isEqualToString:ACTION_CARD_CHARGE_PROMOTION]){
//        // 会员充值促销
//        MemberRechargeSalesView* memberRechargeSalesView = [[MemberRechargeSalesView alloc] initWithNibName:[SystemUtil getXibName:@"SampleListView"] bundle:nil];
//        [self.navigationController pushViewController:memberRechargeSalesView animated:NO];
//    }else if([code isEqualToString:ACTION_CARD_SEARCH]){
//        // 会员信息
//        MemberInfoListView* vc = [[MemberInfoListView alloc] initWithNibName:[SystemUtil getXibName:@"MemberInfoListView"] bundle:nil];
//        [self.navigationController pushViewController:vc animated:NO];
//    }else if([code isEqualToString:ACTION_CARD_REPORT_LOSS]){
//        // 会员挂失
//        MemberSelectListView* memberSelectListView = [[MemberSelectListView alloc] initWithNibName:[SystemUtil getXibName:@"MemberSelectListView"] bundle:nil action:CARD_LOSS_EDIT_VIEW];
//        [self.navigationController pushViewController:memberSelectListView animated:NO];
//    }else if([code isEqualToString:ACTION_CARD_UNDO_CHARGE]){
//        // 会员红冲
//        MemberSelectListView* memberSelectListView = [[MemberSelectListView alloc] initWithNibName:[SystemUtil getXibName:@"MemberSelectListView"] bundle:nil action:MEMBER_CHARGE_RECORD_VIEW];
//        [self.navigationController pushViewController:memberSelectListView animated:NO];
//    }else if([code isEqualToString:ACTION_CARD_CLOSE]){
//        // 会员退卡
//        MemberSelectListView* memberSelectListView = [[MemberSelectListView alloc] initWithNibName:[SystemUtil getXibName:@"MemberSelectListView"] bundle:nil action:CARD_CANCEL_EDIT_VIEW];
//        [self.navigationController pushViewController:memberSelectListView animated:NO];
//    }else if([code isEqualToString:ACTION_CARD_CHARGE]){
//        // 会员充值
//        MemberSelectListView* memberSelectListView = [[MemberSelectListView alloc] initWithNibName:[SystemUtil getXibName:@"MemberSelectListView"] bundle:nil action:MEMBER_RECHARGE_EDIT_VIEW];
//        [self.navigationController pushViewController:memberSelectListView animated:NO];
//    }else if([code isEqualToString:ACTION_POINT_EXCHANGE]){
//        // 积分兑换
//        MemberSelectListView* memberSelectListView = [[MemberSelectListView alloc] initWithNibName:[SystemUtil getXibName:@"MemberSelectListView"] bundle:nil action:MEMBER_PONIT_EXCHANGE_EDIT_VIEW];
//        [self.navigationController pushViewController:memberSelectListView animated:NO];
//    }else if ([code isEqualToString:ACTION_POINT_EXCHANGE_SET]){
//        // 积分兑换设置
//        DegreeGoodsListView* degreeGoodsListView = [[DegreeGoodsListView alloc] initWithNibName:[SystemUtil getXibName:@"DegreeGoodsListView"] bundle:nil];
//        [self.navigationController pushViewController:degreeGoodsListView animated:NO];
//    } else if ([code isEqualToString:ACTION_SMS_SEND]){
//        // 短信营销
//        LSSmsMarketingViewController *vc = [[LSSmsMarketingViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:NO];
//    } else if ([code isEqualToString:ACTION_BIRTHDAY_REMIND]){
//        // 生日提醒
//        LSBrithdayReminderViewController *vc = [[LSBrithdayReminderViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:NO];
//    }
//    
//    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
//}


@end
