//
//  MessageCenterListView.m
//  retailapp
//
//  Created by hm on 15/9/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MessageCenterListView.h"
#import "UIMenuAction.h"
#import "SecondMenuCell.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "SmsGoodsListView.h"
#import "SmsNoticeListView.h"
#import "LSSystemNotificationViewController.h"

@interface MessageCenterListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *datas;/*<<#说明#>>*/
@property (nonatomic, strong) IBOutlet UITableView *tableView;/*<<#说明#>>*/
@end

@implementation MessageCenterListView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNotification];
    [self initNavigate];
    self.tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavigate
{
    [self configTitle:@"消息" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messagePushed:) name:Notification_Message_Push object:nil];
}

- (void)messagePushed:(NSNotification *)notification
{
    [self.tableView reloadData];
}

//创建列表项
- (NSMutableArray *)datas
{
    if (!_datas) {
        _datas = [NSMutableArray array];
        if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 102) {
            [_datas addObject:[[UIMenuAction alloc] init:@"库存预警" detail:@"显示库存变化信息" img:@"icon_call_kucun" code:ACTION_STOCK_WARNING]];
            [_datas addObject:[[UIMenuAction alloc] init:@"过期提醒" detail:@"提示过期商品与临期商品" img:@"icon_call_guoqi" code:ACTION_OVERDUE]];
        }
        [_datas addObject: [[UIMenuAction alloc] init:@"操作通知" detail:@"提示各个操作的状态更新信息" img:@"icon_system_notification" code:ACTION_SYSTEM_NOTIFICATION]];
        [_datas addObject:[[UIMenuAction alloc] init:@"公告通知" detail:@"显示公告、通知等信息" img:@"icon_call_gonggao" code:ACTION_MESSAGE]];
    }
    return _datas;
}


//权限控制
- (void)reload{
    for (UIMenuAction* menu in self.datas) {
        menu.isLock=[[Platform Instance] lockAct:menu.code];
    }
    [self.tableView reloadData];
}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* secondMenuCellIdentifier = @"SecondMenuCell";
    SecondMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:secondMenuCellIdentifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SecondMenuCell" bundle:nil] forCellReuseIdentifier:secondMenuCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:secondMenuCellIdentifier];
    }
    cell.imgBg.hidden = YES;
    UIMenuAction * f = [self.datas objectAtIndex:indexPath.row];
    cell.lblName.text= f.name;
    [cell.lblName sizeToFit];
    cell.lblDetail.text = f.detail;
    [cell.lblName sizeToFit];
    [cell.imgLock setHidden:!f.isLock];
    cell.icoNotification.ls_centerY = cell.lblName.ls_centerY;
    cell.icoNotification.ls_left = cell.lblName.ls_right + 13;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([f.code isEqualToString:ACTION_STOCK_WARNING]) {
        cell.icoNotification.hidden = ![[[Platform Instance] getkey:STOCK_WARNNING] isEqualToString:@"1"];
    }
    if ([f.code isEqualToString:ACTION_OVERDUE]) {
        cell.icoNotification.hidden = ![[[Platform Instance] getkey:OVERDUE_ALERT] isEqualToString:@"1"];
    }
    if ([f.code isEqualToString:ACTION_MESSAGE]) {
        cell.icoNotification.hidden = ![[[Platform Instance] getkey:NOTICE_SMS] isEqualToString:@"1"];
    }
    if ([f.code isEqualToString:ACTION_SYSTEM_NOTIFICATION]) {
        cell.icoNotification.hidden = ![[[Platform Instance] getkey:NOTICE_SYSTEM] isEqualToString:@"1"];
    }
    
    if ([NSString isNotBlank:f.img]) {
        UIImage *img=[UIImage imageNamed:f.img];
        cell.imgMenu.image=img;
    }else{
        cell.imgMenu.image=nil;
    }
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = [indexPath row];
    if (row >= self.datas.count)
    {
        [self reload];
    }else{
        UIMenuAction * f= [self.datas objectAtIndex: row];
        [self onMenuSelectHandle:f];
    }
}

//选择列表项
- (void)onMenuSelectHandle:(UIMenuAction*)action
{
    UIViewController *vc = nil;
    if ([action.code isEqualToString:ACTION_STOCK_WARNING]) {
        //库存预警
        [[Platform Instance] saveKeyWithVal:STOCK_WARNNING withVal:@"0"];
        vc = [[SmsGoodsListView alloc] init];
        [(SmsGoodsListView *)vc setType:STOCK_TYPE];
    }else if ([action.code isEqualToString:ACTION_OVERDUE]) {
        //过期预警
        [[Platform Instance] saveKeyWithVal:OVERDUE_ALERT withVal:@"0"];
        vc = [[SmsGoodsListView alloc] init];
        [(SmsGoodsListView *)vc setType:DATED_TYPE];
    }else if ([action.code isEqualToString:ACTION_MESSAGE]) {
        //公告通知
        [[Platform Instance] saveKeyWithVal:NOTICE_SMS withVal:@"0"];
        vc = [[SmsNoticeListView alloc] init];
    } else if ([action.code isEqualToString:ACTION_SYSTEM_NOTIFICATION]) {
        //系统通知
         [[Platform Instance] saveKeyWithVal:NOTICE_SYSTEM withVal:@"0"];
        vc = [[LSSystemNotificationViewController alloc] init];
    }
    [self pushViewController:vc];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Message_Push object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
