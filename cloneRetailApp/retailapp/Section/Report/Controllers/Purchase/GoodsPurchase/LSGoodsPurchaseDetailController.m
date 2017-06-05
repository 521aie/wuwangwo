//
//  LSGoodsPurchaseDetailController.m
//  retailapp
//
//  Created by guozhi on 2017/1/14.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSGoodsPurchaseDetailController.h"
#import "XHAnimalUtil.h"
#import "LSGoodsPurchaseDetailCell.h"
#import "LSGoodsPurchaseDetailHeaderView.h"
#import "LSPurchaseRecordController.h"
#import "LSGoodsPurchaseVo.h"

@interface LSGoodsPurchaseDetailController ()< UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas; /**<数据源>*/
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) LSGoodsPurchaseDetailHeaderView *viewHeader;
@property (nonatomic,copy) NSString *imgUrl;
@end

@implementation LSGoodsPurchaseDetailController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDatas];
    [self configViews];
    [self loadData];
}

- (void)configDatas {
    self.currentPage = 1;
    self.datas = [NSMutableArray array];
}

- (void)configViews {
    [self configTitle:@"商品采购流水" leftPath:Head_ICON_BACK rightPath:nil];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    __strong typeof(self) wself = self;
    self.tableView.rowHeight = 88.0f;
    [self.tableView ls_addHeaderWithCallback:^{
        wself.currentPage = 1;
        [wself loadData];
    }];
    [self.tableView ls_addFooterWithCallback:^{
        wself.currentPage++;
        [wself loadData];
    }];
    self.tableView.tableFooterView = [ViewFactory generateFooter:60.0];
    [self.view addSubview:self.tableView];
}



- (void)loadData {
     __weak typeof(self) wself = self;
    NSString *url = @"goodsPurchase/detail";
    [self.param setValue:@(self.currentPage) forKey:@"currPage"];
    
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        if (wself.currentPage == 1) {
            [wself.datas removeAllObjects];
        }
        NSArray *list = json[@"goodsPurchaseDetail"];
        self.imgUrl = json[@"imgUrl"];
        if ([ObjectUtil isNotNull:list]) {
            NSArray *objs = [LSGoodsPurchaseVo objectArrayFromKeyValueArray:list];
            [wself.datas addObjectsFromArray:objs];
        }
        wself.tableView.tableHeaderView = wself.viewHeader;
        [wself.tableView reloadData];
        wself.tableView.ls_show = YES;        
    } errorHandler:^(id json) {
        wself.currentPage--;
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [LSAlertHelper showAlert:json];
    }];
}

- (LSGoodsPurchaseDetailHeaderView *)viewHeader {
    if (_viewHeader == nil) {
        _viewHeader = [LSGoodsPurchaseDetailHeaderView goodsPurchaseDetailHeaderView];
        [_viewHeader setObj:self.obj time:self.time imgUrl:self.imgUrl];
    }
    return _viewHeader;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSGoodsPurchaseDetailCell *cell = [LSGoodsPurchaseDetailCell goodsPurchaseDetailCellWithTableView:tableView];
    LSGoodsPurchaseVo *obj = self.datas[indexPath.row];
    cell.obj = obj;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //存cell显示数据
    LSGoodsPurchaseVo *obj = self.datas[indexPath.row];
   
    //存商品名称，编码
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.obj.goodsName forKey:@"goodsName"];
    [param setValue:self.obj.barCode forKey:@"barCode"];
    
    LSPurchaseRecordController *vc = [[LSPurchaseRecordController alloc] init];
    vc.param = param;
    vc.obj = obj;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

@end
