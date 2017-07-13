//
//  KindPayListView.m
//  retailapp
//
//  Created by 果汁 on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GuestNoteListView.h"
#import "SettingService.h"
#import "ServiceFactory.h"
#import "XHAnimalUtil.h"
#import "GuestNoteEditView.h"
#import "SystemUtil.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "GuestNoteCell.h"
#import "LSFooterView.h"
#import "ColorHelper.h"
#import "GuestNoteVo.h"
#import "UIHelper.h"
#import "SortTableView.h"

@interface GuestNoteListView()<GuestNoteCellDelegate,UITableViewDataSource,UITableViewDelegate,LSFooterViewDelegate>
@property  (nonatomic, strong) SettingService *service;
@property  (nonatomic, strong) UITableView *mainGrid;
@property (nonatomic, strong) LSFooterView *footView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) GuestNoteVo *guestNoteVo;
@end

@implementation GuestNoteListView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.service = [ServiceFactory shareInstance].settingService;
    self.datas = [[NSMutableArray alloc] init];
    [self configViews];
    [self configConstraints];
    [self initNavigate];
    [self initMainGrid];
    [self loadData];
    [self configHelpButton:HELP_SETTING_GUEST_MEMO];
}

- (void)configViews{
    self.mainGrid = [[UITableView alloc] init];
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:60.0];
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    [self.view addSubview:self.mainGrid];
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootAdd,kFootSort]];
    [self.view addSubview:self.footView];
}

- (void)configConstraints{
    
    [self.mainGrid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.top).offset(kNavH);
    }];
    
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(60);
    }];
}

#pragma mark - 初始化工具栏
- (void)initNavigate
{
    [self configTitle:@"客单备注" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)initMainGrid {
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
    __weak typeof(self) weakSelf = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        [weakSelf loadData];
    }];
}

#pragma mark - 加载数据
- (void)loadData {
    NSString *path = @"billNote/list";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [self.service getBillNoteInfo:path param:param completionHandler:^(id json) {
        [ weakSelf.mainGrid headerEndRefreshing];
        [ weakSelf.datas removeAllObjects];
    if ([ObjectUtil isNotNull:json]) {
        NSArray *dicItemList = [json objectForKey:@"dicItemList"];
        if ([ObjectUtil isNotNull:dicItemList]) {
            for (NSDictionary *obj in dicItemList) {
                GuestNoteVo *vo = [[GuestNoteVo alloc] initWithDictionary:obj];
                [ weakSelf.datas addObject:vo];
            }
        }
    }
        [ weakSelf.mainGrid reloadData];
          weakSelf.mainGrid.ls_show = YES;
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    } else if ([footerType isEqualToString:kFootSort]) {
        [self showSortEvent];
    }
}

-(void) showAddEvent {
    GuestNoteEditView *vc = [[GuestNoteEditView alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

-(void) showSortEvent {
    if (self.datas.count < 2) {
        [AlertBox show:@"请至少添加两条内容，才能进行排序。"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    SortTableView *vc = [[SortTableView alloc] initWithDatas:self.datas onRightBtnClick:^(NSMutableArray *datas) {
        NSMutableArray *list = [NSMutableArray array];
        for (GuestNoteVo *vo in datas) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:vo.name forKey:@"name"];
            [dict setValue:vo.val forKey:@"val"];
            [dict setValue:vo.dicItemId forKey:@"dicItemId"];
            [dict setValue:vo.sortCode forKey:@"sortCode"];
            [dict setValue:vo.lastVer forKey:@"lastVer"];
            [list addObject:dict];
        }
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:list forKey:@"DicItemVoList"];
        NSString *path = @"billNote/sortBillNotes";
        [self.service getBillNoteInfo:path param:param completionHandler:^(id json) {
             [ weakSelf loadData];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    } setCellContext:^(SortTableViewCell *cell, id obj) {
        GuestNoteVo *vo = (GuestNoteVo *)obj;
        [cell setTitle:vo.name];
    }];
    [ weakSelf.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal: weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

- (void)showHelpEvent:(NSString *)event {
    
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GuestNoteCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"GuestNoteCell" owner:self options:nil].lastObject;
    }
    
    GuestNoteVo *vo = [self.datas objectAtIndex:indexPath.row];
    cell.lblName.text= vo.name;
    cell.lblName.textColor = [ColorHelper getTipColor3];
    cell.lblName.font = [UIFont systemFontOfSize:15];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

//点击删除按钮
- (void)onClick:(UITableViewCell *)item {
    GuestNoteCell *cell = (GuestNoteCell *)item;
    NSIndexPath *indexPath = [self.mainGrid indexPathForCell:cell];
    self.guestNoteVo = [self.datas objectAtIndex:indexPath.row];
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"确认要删除[%@]吗？",self.guestNoteVo.name]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSString *path = @"billNote/del";
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:self.guestNoteVo.dicItemId forKey:@"dicItemId"];
        [param setValue:self.guestNoteVo.lastVer forKey:@"lastVer"];
        __weak typeof(self) weakSelf = self;
        [self.service getBillNoteInfo:path param:param completionHandler:^(id json) {
            [ weakSelf loadData];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

@end
