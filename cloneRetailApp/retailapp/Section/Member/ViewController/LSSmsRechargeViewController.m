//
//  LSSmsRechargeViewController.m
//  retailapp
//
//  Created by guozhi on 16/9/2.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSmsRechargeViewController.h"
#import "XHAnimalUtil.h"
#import "UIView+Sizes.h"
#import "LSEditItemView.h"
#import "LSSmsRechargeCell.h"
#import "AlertBox.h"
#import "MJExtension.h"
#import "LSOrderSureViewController.h"

@interface LSSmsRechargeViewController ()<UITableViewDelegate, UITableViewDataSource>
/*
 *  表格
 */
@property (nonatomic, strong) UITableView *tableView;
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray *datas;

/**
 *  区头
 */
@property (nonatomic, strong) UIView *headerView;
/**
 *  区尾
 */
@property (nonatomic, strong) UIView *footerView;
/**
 *  当前选中的充值套餐对象
 */
@property (nonatomic, strong) LSSmsPackageVo *smsPackageVo;

@end

@implementation LSSmsRechargeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTitle];
    [self configViews];
    [self loadData];
}

- (void)configTitle {
    [self configTitle:@"短信充值" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)configViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, self.view.ls_width, self.view.ls_height - kNavH) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:_tableView];
    
}
#pragma mark - 网络请求
#pragma mark 加载短信套餐列表数据
- (void)loadData {
    NSString *url = @"sms/v1/selectSmsPackage";
    [BaseService getRemoteLSDataWithUrl:url param:nil withMessage:nil show:YES CompletionHandler:^(id json) {
        NSMutableArray *smsPackageVoList = json[@"smsPackageVoList"];
        self.datas = [LSSmsPackageVo mj_objectArrayWithKeyValuesArray:smsPackageVoList];
        LSSmsPackageVo *smsPackageVo = self.datas[0];
        //默认第一个选中
        self.smsPackageVo = smsPackageVo;
        smsPackageVo.isSelect = YES;
        [self.tableView reloadData];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}


#pragma mark - 确认充值事件
- (void)btnClick:(UIButton *)btn {
    LSOrderSureViewController *vc = [[LSOrderSureViewController alloc] init];
    vc.smsPackageVo = self.smsPackageVo;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

#pragma mark - delegate 
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSSmsRechargeCell *cell = [LSSmsRechargeCell smsRechargeCellWithTableView:tableView];
    LSSmsPackageVo *smsPackageVo = self.datas[indexPath.row];
    cell.smsPackageVo = smsPackageVo;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.headerView.ls_height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.footerView.ls_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.smsPackageVo.isSelect = NO;
    self.smsPackageVo = self.datas[indexPath.row];
    self.smsPackageVo.isSelect = YES;
    [self.tableView reloadData];
}



#pragma mark - setup


- (UIView *)headerView {
    if (!_headerView) {
        CGFloat y = 0;
        _headerView = [[UIView alloc] init];
        //剩余短信条数
        LSEditItemView *vewSms = [LSEditItemView editItemView];
        [vewSms initLabel:@"剩余短信条数" withHit:nil];
        [vewSms initData:[NSString stringWithFormat:@"%d条", self.smsCount]];
        vewSms.ls_top = y;
        [_headerView addSubview:vewSms];
        //选择套餐
         y = y + vewSms.ls_height;
        LSEditItemView *vewSelectSet = [LSEditItemView editItemView];
        [vewSelectSet initLabel:@"选择套餐" withHit:nil];
        vewSelectSet.ls_top = y;
        [_headerView addSubview:vewSelectSet];
        
        CGFloat headerViewH = y + vewSelectSet.ls_height;
        _headerView.bounds = CGRectMake(0, 0, self.view.ls_width,headerViewH);
        
    }
    return _headerView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.ls_width, 64)];
        CGFloat margin = 10;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        CGFloat btnX = margin;
        CGFloat btnY = 10;
        CGFloat btnW = _footerView.ls_width - 2 * margin;
        CGFloat btnH = 44;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_full_g"] forState:UIControlStateNormal];
        [btn setTitle:@"确认" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:btn];
        _footerView.ls_height = btnH + 2 * margin;
    }
    return _footerView;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
@end
