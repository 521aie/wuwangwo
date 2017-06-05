//
//  LSStockSummaryListController.m
//  retailapp
//
//  Created by guozhi on 2017/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSStockSummaryListController.h"
#import "ServiceFactory.h"
#import "XHAnimalUtil.h"
#import "ExportView.h"
#import "StockSummaryCell.h"
#import "AlertBox.h"
#import "StockCollectVo.h"
#import "DateUtils.h"
#import "LSFooterView.h"
#import "HeaderItem.h"
@interface LSStockSummaryListController ()<UITableViewDataSource,UITableViewDelegate,LSFooterViewDelegate>
@property (nonatomic, strong) UITableView *mainGrid;



@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, assign) short count;

@property (nonatomic, assign) int stockCollectSum;
/** <#注释#> */
@property (nonatomic, strong) LSFooterView *footView;

@property (nonatomic, assign) BOOL hasUnknown;
@end

@implementation LSStockSummaryListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _datas = [NSMutableArray array];
    [self configViews];
    [self configConstraints];
    [self addHeaderAndFooter];
    [self loadDatas];
    // Do any additional setup after loading the view from its nib.
}

- (void)configViews {
    //标题
    [self configTitle:@"库存汇总查询" leftPath:Head_ICON_BACK rightPath:nil];
    //表格
    self.mainGrid = [[UITableView alloc] init];
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:HEIGHT_CONTENT_BOTTOM];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mainGrid];
    
    //底部工具栏
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootExport]];
    [self.view addSubview:self.footView];
}



- (void)configConstraints {
    //配置约束
    __weak typeof(self) wself = self;
    [wself.mainGrid makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.view);
        make.top.equalTo(wself.view.top).offset(kNavH);
        make.bottom.equalTo(wself.view.bottom);
    }];
    [wself.footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.view);
        make.bottom.equalTo(wself.view.bottom);
        make.height.equalTo(60);
    }];
    
    
}



- (void)addHeaderAndFooter
{
    __weak typeof(self) wself = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        [wself.datas removeAllObjects];
        [wself.param setValue:[NSString stringWithFormat:@"%lld", [DateUtils formateDateTime2:[DateUtils formateDate3:[NSDate date]]]] forKey:@"lastTime"];
        _hasUnknown = NO;
        if ([[wself.param objectForKey:@"findType"] isEqualToString:@"YEAR"]) {
            [wself.param setValue:@"9999" forKey:@"yearSort"];
        }
        [wself selectStockSummary];
    }];
    [wself.mainGrid ls_addFooterWithCallback:^{
        [wself selectStockSummary];
    }];
    wself.mainGrid.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
}

-(void) loadDatas
{
    [self selectStockSummary];
}

#pragma mark 查询商品销售报表一览
-(void) selectStockSummary
{
    if (_count == 0) {
        [_param setValue:@"1" forKey:@"isFirst"];
    } else {
        [_param setValue:@"0" forKey:@"isFirst"];
    }
    
    [_param setValue:[NSNumber numberWithBool:_hasUnknown] forKey:@"hasUnknown"];
     NSString *url = @"stockCollect/list";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:_param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself responseSuccess:json];
        [wself.mainGrid headerEndRefreshing];
        [wself.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [wself.mainGrid headerEndRefreshing];
        [wself.mainGrid footerEndRefreshing];
    }];
}

- (void)responseSuccess:(id)json
{
    NSMutableArray* array = [StockCollectVo converToArr:[json objectForKey:@"stockCollectList"]];
    
    if (array != nil && array.count > 0) {
        for (StockCollectVo* vo in array) {
            [_datas addObject:vo];
        }
    }
    if ([ObjectUtil isNotNull:[json objectForKey:@"lastTime"]]) {
        [_param setValue:[json objectForKey:@"lastTime"] forKey:@"lastTime"];
    }
    
    _hasUnknown = [[json objectForKey:@"hasUnknown"] boolValue];
    
    if (_count == 0) {
        _stockCollectSum = [[json objectForKey:@"stockCollectSum"] intValue];
        _count = 1;
    }
    
    if ([[_param objectForKey:@"findType"] isEqualToString:@"YEAR"] && [ObjectUtil isNotNull:[json objectForKey:@"yearSort"]]) {
        [_param setValue:[json objectForKey:@"yearSort"] forKey:@"yearSort"];
    }
    
    [self.mainGrid reloadData];
    self.mainGrid.ls_show = YES;
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootExport]) {
        [self showExportEvent];
    }
}
- (void)showExportEvent {
    ExportView *vc = [[ExportView alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    [vc loadData:_param withPath:@"stockCollect/export" withIsPush:YES callBack:^{
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    }];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datas.count>0?1:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderItem *headItem = [HeaderItem headerItem];
    NSString *title = [NSString stringWithFormat:@"合计%d件",_stockCollectSum];
    [headItem initWithName:title];
    return headItem;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *stockSummaryCell = @"StockSummaryCell";
    StockSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:stockSummaryCell];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"StockSummaryCell" bundle:nil] forCellReuseIdentifier:stockSummaryCell];
        cell = [tableView dequeueReusableCellWithIdentifier:stockSummaryCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    StockSummaryCell *detailItem = (StockSummaryCell *)cell;
    if (self.datas.count > 0) {
        StockCollectVo* item = self.datas[indexPath.row];
        detailItem.lblName.text = item.name;
        detailItem.lblNowStore.text = [NSString stringWithFormat:@"库存数：%@", [item.num stringValue]];
    }
}


@end
