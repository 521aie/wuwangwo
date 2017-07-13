//
//  LSGoodsChangeListController.m
//  retailapp
//
//  Created by guozhi on 2017/1/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define CELL_HEIGHT 88
#define HEADER_HEIGHT 40
#import "LSGoodsChangeListController.h"
#import "XHAnimalUtil.h"
#import "MemberListCell.h"
#import "SMHeaderItem.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "MemberTransactionListVo.h"
#import "SVProgressHUD.h"
#import "DateUtils.h"
#import "SystemUtil.h"
#import "ExportView.h"
#import "LSFooterView.h"
#import "RecordChangeDetailCell.h"
#import "StockChangeLogVo.h"
#import "LSGoodsChangeDetailController.h"
#import "GridColHead.h"
#import "LSStockChangeRecordHeaderView.h"


@interface LSGoodsChangeListController ()<UITableViewDataSource,UITableViewDelegate,LSFooterViewDelegate>
@property (nonatomic, strong) UITableView          *tableView;  //tableView
@property (nonatomic, strong) LSFooterView  *footView;  //页脚
@property (nonatomic, strong) NSMutableArray                *dates;     //tabelView数据
@property (nonatomic, strong) NSMutableDictionary *exportParam;
@property (nonatomic, strong) NSMutableArray *selfStockChangeLogVoList;
/** <#注释#> */
@property (nonatomic, strong) NSNumber *lastTime;

@end

@implementation LSGoodsChangeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selfStockChangeLogVoList = [NSMutableArray array];
    [self configViews];
    [self configConstraints];
    [self loadData];
}
- (void)configViews {
    self.view.backgroundColor = [UIColor clearColor];
    [self configTitle:self.parentStockChangeLogVo.goodsName leftPath:Head_ICON_BACK rightPath:nil];
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    __weak typeof(self) wself = self;
    [self.tableView ls_addHeaderWithCallback:^{
        wself.lastTime = nil;
        [wself loadData];
    }];
    [self.tableView ls_addFooterWithCallback:^{
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
    [self.navigationController pushViewController:vc animated:NO];
    [vc loadData:self.exportParam withPath:@"stockChangeLog/getStockLogReport" withIsPush:YES callBack:^{
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    }];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

//导出参数
- (NSMutableDictionary *)exportParam{
    if (_exportParam == nil) {
        _exportParam = [NSMutableDictionary dictionary];
    }
    [_exportParam setValue:[_param objectForKey:@"starttime"] forKey:@"starttime"];
    [_exportParam setValue:[_param objectForKey:@"endtime"] forKey:@"endtime"];
    [_exportParam setValue:[_param objectForKey:@"goodsId"] forKey:@"goodsId"];
    [_exportParam setValue:[_param objectForKey:@"shopId"] forKey:@"shopId"];
    return _exportParam;
}
#pragma mark - netWork
//加载数据
- (void)loadData{
    __weak typeof(self) wself = self;
    NSString *url = @"stockChangeLog/getStockLogGoodsDetail";
    [self.param setValue:self.lastTime forKey:@"lastTime"];
      [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        
        NSArray *list = json[@"stockChangeLogGoods"];
        NSDictionary *goods = json[@"goods"];
          if ([ObjectUtil isNotNull:goods]) {
              //设置表头商品信息
              LSStockChangeRecordHeaderView *headerView = [LSStockChangeRecordHeaderView stockChangeRecordHeaderView];
              NSString *startTime = [DateUtils formateTime2:[self.param[@"starttime"] longLongValue]];
              NSString *endTime = [DateUtils formateTime2:[self.param[@"endtime"] longLongValue]];
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
          if (wself.lastTime == nil) {
              [wself.selfStockChangeLogVoList removeAllObjects];
          }
        if (![list isEqual:[NSNull null]]) {
            for (NSDictionary *dict in list) {
                StockChangeLogVo *changeVo = [[StockChangeLogVo alloc] initWithDictionary:dict];
                [wself.selfStockChangeLogVoList addObject:changeVo];
            }
            
        }
          wself.lastTime = json[@"lastTime"];
        [wself.tableView reloadData];
        wself.tableView.ls_show = YES;
        
    } errorHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [AlertBox show:json];
    }];
}


#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _selfStockChangeLogVoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    RecordChangeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [RecordChangeDetailCell getInstance];
    }
    // fix 线上数组越界bug
    StockChangeLogVo *vo = nil;
    if (indexPath.row < _selfStockChangeLogVoList.count) {
        vo = _selfStockChangeLogVoList[indexPath.row];
    }
    [cell loadCell:vo];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StockChangeLogVo *memberTransactionListVo = self.selfStockChangeLogVoList[indexPath.row];
    LSGoodsChangeDetailController *vc = [[LSGoodsChangeDetailController alloc] init];
    vc.stockChangeLogVo1 = self.parentStockChangeLogVo;
    vc.stockChangeLogVo2 = memberTransactionListVo;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}



@end
