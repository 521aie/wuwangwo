//
//  LSCostChangeRecordDetailListController.m
//  retailapp
//
//  Created by guozhi on 2017/1/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define CELL_HEIGHT 88
#define HEADER_HEIGHT 40
#import "LSCostChangeRecordDetailListController.h"
#import "DateUtils.h"
#import "SystemUtil.h"
#import "ExportView.h"
#import "LSFooterView.h"
#import "LSCostChangeRecordVo.h"
#import "LSCostChangeRecordDetailController.h"
#import "LSStockChangeRecordHeaderView.h"
#import "LSCostChangeRecordDetailListCell.h"


@interface LSCostChangeRecordDetailListController ()<UITableViewDataSource,UITableViewDelegate,LSFooterViewDelegate>
@property (nonatomic, strong) UITableView          *tableView;  //tableView
@property (nonatomic, strong) LSFooterView  *footView;  //页脚
@property (nonatomic, strong) NSMutableArray                *dates;     //tabelView数据
@property (nonatomic, strong) NSMutableDictionary *exportParam;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation LSCostChangeRecordDetailListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    self.datas = [NSMutableArray array];
    [self configViews];
    [self configConstraints];
    [self loadData];
}
- (void)configViews {
    self.view.backgroundColor = [UIColor clearColor];
    [self configTitle:@"成本价变更记录" leftPath:Head_ICON_BACK rightPath:nil];
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    __weak typeof(self) wself = self;
    [self.tableView ls_addHeaderWithCallback:^{
        wself.currentPage = 1;
        [wself loadData];
    }];
    [self.tableView ls_addFooterWithCallback:^{
        wself.currentPage++;
        [wself loadData];
    }];
    self.tableView.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootExport]];
    [self.view addSubview:self.footView];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.top.equalTo(wself.view.top).offset(kNavH);
    }];
    
    [self.footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.height.equalTo(60);
    }];
}



- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootExport]) {
        [self showExportEvent];
    }
}
- (void)showExportEvent{
    ExportView *vc = [[ExportView alloc] init];
    [self pushViewController:vc];
    [vc loadData:self.exportParam withPath:@"costPriceChangeLog/export" withIsPush:YES callBack:^{
        [self popViewController];
    }];
}

//导出参数
- (NSMutableDictionary *)exportParam{
    if (_exportParam == nil) {
        _exportParam = [NSMutableDictionary dictionary];
    }
    [_exportParam setValue:[_param objectForKey:@"startTime"] forKey:@"startTime"];
    [_exportParam setValue:[_param objectForKey:@"endTime"] forKey:@"endTime"];
    [_exportParam setValue:[_param objectForKey:@"goodsId"] forKey:@"goodsId"];
    [_exportParam setValue:[_param objectForKey:@"shopId"] forKey:@"shopId"];
    return _exportParam;
}
#pragma mark - netWork
//加载数据
- (void)loadData{
    __weak typeof(self) wself = self;
    NSString *url = @"costPriceChangeLog/detail";
     [self.param setValue:@(self.currentPage) forKey:@"currentPage"];
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        if (wself.currentPage == 1) {
            [wself.datas removeAllObjects];
        }
        
        NSArray *list = json[@"detailList"];
        NSDictionary *goods = json[@"goods"];
          if ([ObjectUtil isNotNull:goods]) {
              //设置表头商品信息
              LSStockChangeRecordHeaderView *headerView = [LSStockChangeRecordHeaderView stockChangeRecordHeaderView];
              NSString *startTime = [DateUtils formateTime2:[self.param[@"startTime"] longLongValue]];
              NSString *endTime = [DateUtils formateTime2:[self.param[@"endTime"] longLongValue]];
              NSString *time = nil;
              if ([startTime isEqualToString:endTime]) {
                  time = startTime;
              } else {
                  time = [NSString stringWithFormat:@"%@~%@", startTime, endTime];
              }
              if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {//服鞋
                  [headerView setName:goods[@"name"] code:goods[@"innercode"] colorAndsSize:[NSString stringWithFormat:@"%@ %@", goods[@"colorName"], goods[@"sizeName"]] time:time filePath:goods[@"filePath"]];
              } else {
                  [headerView setName:goods[@"name"] code:goods[@"barcode"] colorAndsSize:nil time:time filePath:goods[@"filePath"]];
              }
              wself.tableView.tableHeaderView = headerView;
              
          }
        if ([ObjectUtil isNotNull:list]) {
            NSArray *objs = [LSCostChangeRecordVo ls_objectArrayWithKeyValuesArray:list];
            [wself.datas addObjectsFromArray:objs];
        }
        [wself.tableView reloadData];
        wself.tableView.ls_show = YES;
    } errorHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [LSAlertHelper showAlert:json];
    }];
}


#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSCostChangeRecordDetailListCell *cell = [LSCostChangeRecordDetailListCell costChangeRecordDetaolListCellWithTableView:tableView];
    LSCostChangeRecordVo *obj = self.datas[indexPath.row];
    cell.obj = obj;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    LSCostChangeRecordDetailController *vc = [[LSCostChangeRecordDetailController alloc] init];
    LSCostChangeRecordVo *obj = self.datas[indexPath.row];
    vc.obj = obj;
    [self pushViewController:vc];
    
}



@end
