//
//  LSShopCollectionDetailListController.m
//  retailapp
//
//  Created by guozhi on 2016/11/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSShopCollectionDetailListController.h"
#import "ServiceFactory.h"
#import "ViewFactory.h"
#import "XHAnimalUtil.h"
#import "LSShopColllectionDetailListCell.h"
#import "AlertBox.h"
#import "LSStaffHandoverPayTypeVo.h"
#import "ColorHelper.h"
#import "DateUtils.h"
#import "HeaderItem.h"
@interface LSShopCollectionDetailListController ()<UITableViewDelegate, UITableViewDataSource>
/** 表格 */
@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
/** 用来分页 */
@property (nonatomic, strong) NSNumber *lastSortId;

/** <#注释#> */
@property (nonatomic, strong) NSNumber *totalSalesAmount;
@end

@implementation LSShopCollectionDetailListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self loadData];
}

- (void)configViews {
    self.datas = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor clearColor];
    //标题
    [self configTitle:self.titleName leftPath:Head_ICON_BACK rightPath:nil];
    //表格
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 88;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
    [self.view addSubview:self.tableView];
    __weak typeof(self) wself = self;
    [self.tableView ls_addHeaderWithCallback:^{
        wself.lastSortId = nil;
        [wself loadData];
    }];
    [self.tableView ls_addFooterWithCallback:^{
        [wself loadData];
    }];

    
}


#pragma mark - 加载数据
- (void)loadData
{
    __weak typeof(self) wself = self;
    NSString *url = @"shopCashierReport/v1/detail";
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        if (wself.lastSortId == nil) {
            [wself.datas removeAllObjects];
        }
        if ([ObjectUtil isNotNull:json[@"totalSalesAmount"]]) {
            wself.totalSalesAmount = json[@"totalSalesAmount"];
        }
        NSArray *map = [json objectForKey:@"staffHandoverPayTypeVos"];
        if ([ObjectUtil isNotEmpty:map]) {
            wself.datas = [LSStaffHandoverPayTypeVo mj_objectArrayWithKeyValuesArray:map];
        }
        [wself.tableView reloadData];
        wself.tableView.ls_show = YES;
        wself.lastSortId = [json objectForKey:@"lastSortId"];
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
    }];
    
}
- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [NSMutableDictionary dictionary];
    }
    if (self.lastSortId == nil) {
        [_param removeObjectForKey:@"lastSortId"];
    } else {
        [_param setValue:self.lastSortId forKey:@"lastSortId"];
    }
    return _param;
}



#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSShopColllectionDetailListCell *cell = [LSShopColllectionDetailListCell shopColllectionDetailListCellWithTableView:tableView];
    cell.staffHandoverPayTypeVo = self.datas[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderItem *headItem = [HeaderItem headerItem];
    NSString *titleVal = [NSString stringWithFormat:@"%@  合计：￥%.2f",[DateUtils formateTime5:self.currDate.longLongValue], self.totalSalesAmount.doubleValue];
    [headItem initWithName:titleVal];
    return headItem;
}

@end
