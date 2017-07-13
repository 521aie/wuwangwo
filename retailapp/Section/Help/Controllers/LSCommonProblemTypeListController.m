//
//  LSCommonProblemTypeListController.m
//  retailapp
//
//  Created by guozhi on 2017/3/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSCommonProblemTypeListController.h"
#import "LSCommonProblemTypeListCell.h"
#import "LSCommonProblemListController.h"
#import "LSCommonProblemTypeListVo.h"
@interface LSCommonProblemTypeListController ()<UITableViewDelegate, UITableViewDataSource>
/** 表格 */
@property (nonatomic, strong) UITableView *tableView;
/** 当前页 */
@property (nonatomic, assign) int currentPage;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation LSCommonProblemTypeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTitle:@"常见问题类型" leftPath:Head_ICON_BACK rightPath:nil];
    [self setupTableView];
    [self loadData];
}

- (void)setupTableView {
    self.datas = [NSMutableArray array];
    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 48;
    [self.view addSubview:self.tableView];
    __weak typeof(self) wself = self;
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.view).offset(64);
        make.left.right.bottom.equalTo(wself.view);
    }];
    self.currentPage = 1;
    [self.tableView ls_addHeaderWithCallback:^{
        wself.currentPage = 1;
        [wself loadData];
    }];
    [self.tableView ls_addFooterWithCallback:^{
        wself.currentPage ++;
        [wself loadData];
    }];

}
- (void)loadData {
    NSString *url = @"problem/v1/problem_types";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@(self.currentPage) forKey:@"pageIndex"];
    //商超单店=1，商超连锁=2，服鞋单店=3，服鞋连锁=4
    int shopKind = 0;
    if ([[Platform Instance] getShopMode] == 1) {
        if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
            shopKind = 3;
        } else {
            shopKind = 1;
        }
    } else {
        if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
            shopKind = 4;
        } else {
            shopKind = 2;
        }
    }
    [param setValue:@(shopKind) forKey:@"shopType"];
    [param setValue:@(20) forKey:@"pageSize"];
    __weak typeof(self) wself = self;
    [BaseService crossDomanRequestWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        if (wself.currentPage == 1) {
            [wself.datas removeAllObjects];
        }
        NSArray *list = [LSCommonProblemTypeListVo ls_objectArrayWithKeyValuesArray:json[@"data"]];
        [wself.datas addObjectsFromArray:list];
        [wself.tableView reloadData];
        
    } errorHandler:^(id json) {
        wself.currentPage--;
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [LSAlertHelper showAlert:json];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSCommonProblemTypeListCell *cell = [LSCommonProblemTypeListCell commonProblemTypeListCellWithTableView:tableView];
    LSCommonProblemTypeListVo *obj = self.datas[indexPath.row];
    cell.obj = obj;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSCommonProblemTypeListVo *obj = self.datas[indexPath.row];
    LSCommonProblemListController *vc = [[LSCommonProblemListController alloc] initWithTypeId:obj.id titleName:obj.typeName];
    [self pushViewController:vc];
}
@end
