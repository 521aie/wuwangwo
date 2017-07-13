//
//  LSReportSaleStatisticController.m
//  retailapp
//
//  Created by taihangju on 2016/12/2.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSReportSaleStatisticController.h"
#import "LSGoodsSaleListController.h"
#import "LSFooterView.h"
#import "AlertBox.h"
#import "LSSaleGoodsSummaryVo.h"
#import "LSGoodsCategorySaleCell.h"
#import "ExportView.h"
#import "HeaderItem.h"

@interface LSReportSaleStatisticController ()<LSFooterViewDelegate ,UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;/*<>*/
@property (nonatomic ,strong) LSFooterView *footView;
@property (nonatomic ,strong) NSMutableDictionary *param;/*<请求分类，品牌一览需要的参数>*/
@property (nonatomic ,strong) NSNumber *totalProfit;/*<所有商品销售毛利之和>*/
@property (nonatomic ,strong) NSNumber *totalNetSales;/*<合计净销量>*/
@property (nonatomic ,strong) NSNumber *totalNetAmount;/*<合计净销售额>*/
@property (nonatomic ,strong) NSMutableArray <LSSaleGoodsSummaryVo *>*dataSource;/*<数据源>*/
@property (nonatomic ,assign) NSInteger currentPage;/*<分页：当前页>*/
@property (nonatomic, strong) NSNumber *goodsSum;
@property (nonatomic, assign) double amount;
@end



@implementation LSReportSaleStatisticController

- (instancetype)initWithParams:(NSDictionary *)param {
    
    self = [super init];
    if (self) {
        self.param = [NSMutableDictionary dictionaryWithDictionary:param];
        self.currentPage = 1;
    }
    return self;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubviews];
    [self getCategoryList];
}

- (void)configSubviews {
    [self configTitle:@"商品销售报表" leftPath:Head_ICON_BACK rightPath:nil];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H-kNavH)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 88.0;
    self.tableView.sectionHeaderHeight = 44.0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    [weakSelf.tableView ls_addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf getCategoryList];
    }];
    
    [weakSelf.tableView ls_addFooterWithCallback:^{
        weakSelf.currentPage ++ ;
        [weakSelf getCategoryList];
    }];
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootExport]];
    [self.view addSubview:self.footView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count > 0 ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LSGoodsCategorySaleCell *cell = [LSGoodsCategorySaleCell goodsCategorySaleCellWithTableView:tableView];
    [cell fillSaleGoodsSummaryVo:self.dataSource[indexPath.row]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
 
    HeaderItem *headItem = [HeaderItem headerItem];
    NSString *goodsSum = nil;
    if ([_goodsSum.stringValue containsString:@"."]) {
        goodsSum = [NSString stringWithFormat:@"%.3f", _goodsSum.doubleValue];
    } else {
        goodsSum = [NSString stringWithFormat:@"%.f", _goodsSum.doubleValue];

    }
    [headItem initWithName:[NSString stringWithFormat:@"合计%@件，￥%.2f", goodsSum  , _amount]];
    return headItem;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 去具体的分类/品类或者品牌页
    LSSaleGoodsSummaryVo *vo = self.dataSource[indexPath.row];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:self.param];
    NSString *titleName = nil;
    if ([NSString isNotBlank:vo.brandId]) {
        [param setValue:vo.brandId forKey:@"brandId"];
        titleName = vo.brandName;
    } else {
        [param setValue:[NSNull null] forKey:@"brandId"];
    }
    
    if ([NSString isNotBlank:vo.categoryId]) {
        [param setValue:vo.categoryId forKey:@"categoryId"];
        titleName = vo.categoryName;
    } else {
        [param setValue:[NSNull null] forKey:@"categoryId"];
    }
    [param setValue:_totalProfit forKey:@"totalProfit"];
    LSGoodsSaleListController *vc = [[LSGoodsSaleListController alloc] init];
    vc.param = param;
    vc.titleName = titleName;
    [self pushController:vc from:kCATransitionFromRight];
}

#pragma mark - 相关协议回调

// LSFooterViewDelegate ,导出/
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    long long startTime = [self.param[@"startTime"] longLongValue];
    long long endTime = [self.param[@"endTime"] longLongValue];
    if ((endTime- startTime)/(24*60*60) >=31) {
        [AlertBox show:@"导出商品销售报表的时间区间不能超过31天！"];
        return;
    }
    
    if ([footerType isEqualToString:kFootExport]) {
        ExportView *vc = [[ExportView alloc] init];
        __weak typeof(self) weakSelf = self;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self.param];
        [dic setValue:_totalProfit forKey:@"totalProfit"];
        [vc reportExport:[dic copy] type:0 callBack:^{
            [weakSelf popToLatestViewController:kCATransitionFromLeft];
        }];
        [weakSelf pushController:vc from:kCATransitionFromTop];
    }
}

#pragma mark - 网络请求
// 获取分类列表
- (void)getCategoryList {
    
    [self.param setValue:@(self.currentPage) forKey:@"currentPage"];
    [BaseService getRemoteLSDataWithUrl:@"goodsSalesReport/v1/list" param:[self.param mutableCopy] withMessage:@"" show:YES CompletionHandler:^(id json) {
        _goodsSum = [json objectForKey:@"totalNetSales"];
        _amount = [[json objectForKey:@"totalNetAmount"] doubleValue];
        _totalProfit = [json objectForKey:@"totalSellProfit"]; // 所有商品销售毛利之和，按品牌或者品类查询时再传给后端
        if (self.currentPage == 1) {
            [self.dataSource removeAllObjects];
        }
        NSArray *saleGoodsSummaryVoList = [json valueForKey:@"saleGoodsSummaryVoList"];
        if ([ObjectUtil isNotEmpty:saleGoodsSummaryVoList]) {
            [self.dataSource addObjectsFromArray:[LSSaleGoodsSummaryVo saleGoodsSummaryVoList:saleGoodsSummaryVoList]];
        } else {
            self.currentPage --;
        }
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        [self.tableView reloadData];
        self.tableView.ls_show = YES;
    } errorHandler:^(id json) {
        self.currentPage -- ;
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        [AlertBox show:json];
    }];
}

@end
