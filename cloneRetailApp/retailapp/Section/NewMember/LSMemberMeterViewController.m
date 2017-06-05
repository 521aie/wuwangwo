//
//  LSMemberMeterViewController.m
//  retailapp
//
//  Created by wuwangwo on 2017/3/28.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberMeterViewController.h"
#import "LSFooterView.h"
#import "LSMemberMeterListCell.h"
#import "LSMemberMeterVo.h"
#import "LSMemberMeterDetailViewController.h"
#import "MobClick.h"

@interface LSMemberMeterViewController ()<UITableViewDelegate,UITableViewDataSource,LSFooterViewDelegate>

/** 表格 */
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LSFooterView *footerView;
@property (nonatomic, strong) NSMutableArray *datas;
/** 当前页 */
//@property (nonatomic, strong) NSNumber *lastDateTime;
@end

@implementation LSMemberMeterViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configTitle:@"计次服务设置" leftPath:Head_ICON_BACK rightPath:nil];
    [self creatView];
    [self loadData];
}

- (void)creatView{
    
    self.datas = [NSMutableArray array];
    self.lastDateTime = nil;
    self.param = [[NSMutableDictionary alloc] init];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 130.0f;
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) wself = self;
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.view).offset(64);
        make.left.right.bottom.equalTo(wself.view);
    }];
    
    [self.tableView ls_addHeaderWithCallback:^{
        wself.lastDateTime = nil;
        [wself loadData];
    }];
    [self.tableView ls_addFooterWithCallback:^{
        [wself loadData];
    }];
    
    self.footerView = [LSFooterView footerView];
    [self.footerView initDelegate:self btnsArray:@[kFootAdd]];
    [self.view addSubview:self.footerView];
}

- (void)loadData {
    
    __weak typeof(self) wself = self;
    NSString *url = @"accountcard/entityAccountCardList";
    
    [self.param setValue:_lastDateTime forKey:@"lastDateTime"];
    
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:@"" show:YES CompletionHandler:^(id json) {
        
        if (wself.lastDateTime == nil) {
            [wself.datas removeAllObjects];
        }
        
        if ([ObjectUtil isNotNull:json[@"lastDateTime"]]) {
            wself.lastDateTime = [json valueForKey:@"lastDateTime"];
        }
        
        NSArray *list = json[@"accountCardList"];
        if ([ObjectUtil isNotNull:list]) {
            
            NSArray *objs = [LSMemberMeterVo mj_objectArrayWithKeyValuesArray:list];
            [wself.datas addObjectsFromArray:objs];
        }
        
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [wself.tableView reloadData];
        wself.tableView.ls_show = YES;
        
    } errorHandler:^(id json) {
        
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [LSAlertHelper showAlert:json];
    }];
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    
    if ([footerType isEqualToString:kFootAdd]) {
        
        [self showAddEvent];
    }
}

- (void)showAddEvent {
    
    [MobClick event:@"Member_ByTimeService_Add"];
    
    LSMemberMeterDetailViewController *vc = [[LSMemberMeterDetailViewController alloc] initWith:nil action:ACTION_CONSTANTS_ADD];
    [self pushViewController:vc direct:AnimationDirectionV];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LSMemberMeterListCell *cell = [LSMemberMeterListCell memberMeteringListCellWithTableView:tableView];
    LSMemberMeterVo*obj = self.datas[indexPath.row];
    cell.obj = obj;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LSMemberMeterVo *obj = self.datas[indexPath.row];
    LSMemberMeterDetailViewController *vc = [[LSMemberMeterDetailViewController alloc] initWith:obj action:ACTION_CONSTANTS_EDIT];
    [self pushViewController:vc];
}

@end
