//
//  LSMenuLeftView.m
//  retailapp
//
//  Created by guozhi on 2017/2/25.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define kSectionBase @"基础信息"
#define kSectionOther @"其他工具"
const CGFloat kTolBarH = 50;
#import "LSMenuLeftView.h"
#import "LSModuleModel.h"
#import "LSMenuLeftCell.h"

@interface LSMenuLeftView()<UITableViewDelegate, UITableViewDataSource>
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *datas;
/** <#注释#> */
@property (nonatomic, strong) NSMutableDictionary *map;
@end

@implementation LSMenuLeftView


- (void)configViews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //店家设置
    CGFloat y = 20;
    CGFloat w = self.bounds.size.width;
    CGFloat h = 43;
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, y, w, h)];
    lbl.font = [UIFont boldSystemFontOfSize:20];
    lbl.textColor = [ColorHelper getWhiteColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = @"店家设置";
    [self addSubview:lbl];
    y = y + lbl.ls_height;
    //白线
    y = [self addWhiteLine:self y:y margin:0];
    //表格
    h = self.bounds.size.height - y - kTolBarH - 1;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, w, h) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = 40;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    y = y + h;
    if ([[Platform Instance] getShopMode] == 1 && [[[Platform Instance] getkey:SHOP_MODE] intValue] == 102) {//商超单店
        //白线
        y = [self addWhiteLine:self y:y margin:0];
        //帮助视频按钮
        w = self.ls_width/2;
        h = kTolBarH;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, y, w, h);
        [btn setImage:[UIImage imageNamed:@"help_video"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"help_video"] forState:UIControlStateHighlighted];
        [btn setTitle:@"帮助视频" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 1, 0);
        btn.titleLabel.textColor = [ColorHelper getWhiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:btn];
        
        //常见问题按钮
        CGFloat x = self.ls_width/2;
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(x, y, w, h);
        [btn setImage:[UIImage imageNamed:@"help_question"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"help_question"] forState:UIControlStateHighlighted];
        [btn setTitle:@"常见问题" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 2;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        btn.titleLabel.textColor = [ColorHelper getWhiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:btn];

    } else {
        y = [self addWhiteLine:self y:y margin:0];
        //帮助视频按钮
        w = self.ls_width/2;
        h = kTolBarH;
        //常见问题按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, y, w, h);
        [btn setImage:[UIImage imageNamed:@"help_question"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"help_question"] forState:UIControlStateHighlighted];
        [btn setTitle:@"常见问题" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 2;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        btn.titleLabel.textColor = [ColorHelper getWhiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:btn];
    }
    
}

- (void)createDatas {
    self.map = [NSMutableDictionary dictionary];
    self.datas = [NSMutableArray array];
    NSMutableArray *list = [NSMutableArray array];
    //基础信息
    LSModuleModel *model = [LSModuleModel moduleModelWithName:@"店家信息" detail:nil path:@"setting_shop_info" code:ACTION_SHOP_INFO];
    [list addObject:model];
    model = [LSModuleModel moduleModelWithName:@"系统参数" detail:nil path:@"setting_system_param" code:ACTION_SYS_CONFIG_SETTING];
    [list addObject:model];
    if ([[Platform Instance] getShopMode] != 3) {
        model = [LSModuleModel moduleModelWithName:@"支付方式" detail:nil path:@"setting_kind_pay" code:ACTION_PAYMENT_TYPE];
        [list addObject:model];
    }
    model = [LSModuleModel moduleModelWithName:@"小票设置" detail:nil path:@"setting_ticket_setting" code:ACTION_RECEIPT_SETTING];
    [list addObject:model];
    model = [LSModuleModel moduleModelWithName:@"客单备注" detail:nil path:@"setting_guest_note" code:ACTION_ORDER_MEMO];
    [list addObject:model];
    model = [LSModuleModel moduleModelWithName:@"短信设置" detail:nil path:@"setting_sms_setting" code:ACTION_SMS_SET];
    [list addObject:model];
    model = [LSModuleModel moduleModelWithName:@"主页显示设置" detail:nil path:@"setting_home_display" code:ACTION_HOMEPAGE_SET];
    [list addObject:model];
    model = [LSModuleModel moduleModelWithName:@"店内屏幕广告" detail:nil path:@"setting_store_screen_advertising" code:ACTION_SCREEN_ADVERTISING];
    [list addObject:model];
    if ([[Platform Instance] getScanPayStatus] == 1) {
        model = [LSModuleModel moduleModelWithName:@"入驻商圈" detail:nil path:@"setting_occupancy_area" code:ACTION_SETTLED_MALL];
        [list addObject:model];
    }
    [self.map setValue:list forKey:kSectionBase];
    [self.datas addObject:kSectionBase];
    
    //其他工具
    list = [NSMutableArray array];
    if ([[[Platform Instance] getkey:USER_NAME] isEqualToString:@"ADMIN"]) {
        model = [LSModuleModel moduleModelWithName:@"营业数据清理" detail:nil path:@"setting_left_data_clear" code:ACTION_CLEAN_DATA];
        [list addObject:model];

    }
    model = [LSModuleModel moduleModelWithName:@"发布公告" detail:nil path:@"setting_announcement" code:ACTION_NOTICE_INFO];
    [list addObject:model];
    [self.map setValue:list forKey:kSectionOther];
    [self.datas addObject:kSectionOther];
}

- (CGFloat)addWhiteLine:(UIView *)view y:(CGFloat)y margin:(CGFloat)margin{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(margin, y, self.bounds.size.width - 2 * margin , 1)];
    y = y + 1;
    line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    [view addSubview:line];
    return y;
}



- (void)btnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(menuLeftView:didSelectType:)]) {
        if (btn.tag == 1) {//点击了帮助视频
            [self.delegate menuLeftView:self didSelectType:LSMenuLeftViewTypeHelpVideo];
        } else if (btn.tag == 2) {//点击了常见问题
            [self.delegate menuLeftView:self didSelectType:LSMenuLeftViewTypeCommonProblem];
        }
    }
    
}

- (void)reloadData {
    [self configViews];
    [self createDatas];
    [self.tableView reloadData];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.map[self.datas[section]] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSMenuLeftCell *cell = [LSMenuLeftCell menuLeftCellWithTableView:tableView];
    LSModuleModel *obj = self.map[self.datas[indexPath.section]][indexPath.row];
    cell.obj = obj;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 42;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.ls_width, 42)];
    //设置标题
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 17, self.ls_width - 40, 15)];
    lbl.font = [UIFont boldSystemFontOfSize:15];
    lbl.textColor = [ColorHelper getWhiteColor];
    lbl.text = self.datas[section];
    [view addSubview:lbl];
    //横线
    [self addWhiteLine:view y:41 margin:20];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSModuleModel *obj = self.map[self.datas[indexPath.section]][indexPath.row];
    BOOL isLockFlag = [[Platform Instance] lockAct:obj.code];
    if (isLockFlag) {
        [LSAlertHelper showAlert:[NSString stringWithFormat:@"您没有[%@]的权限",obj.name]];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(menuLeftView:didSelectobj:)]) {
        [self.delegate menuLeftView:self didSelectobj:obj];
    }
}


@end




