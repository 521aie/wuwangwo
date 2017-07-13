//
//  SmsGoodsListView.m
//  retailapp
//
//  Created by hm on 15/9/7.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SmsGoodsListView.h"
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "GoodsInfoCell.h"
#import "ServiceFactory.h"
#import "DateUtils.h"
#import "StockDueAlertVo.h"
#import "StockStoreAlertVo.h"

@interface SmsGoodsListView ()

@property (nonatomic,strong) SmsService* service;
//数据源
@property (nonatomic,strong) NSMutableArray* dataList;

@property (nonatomic) NSInteger currentPage;
//登录者所属门店或机构id
@property (nonatomic,copy) NSString* searchId;

@end

@implementation SmsGoodsListView
@synthesize service;


- (void)viewDidLoad {
    [super viewDidLoad];
    service = [ServiceFactory shareInstance].smsService;
    [self configTitle:@"" leftPath:Head_ICON_BACK rightPath:nil];
    self.mainGrid.tableHeaderView = self.headerView;
    [self showWithType];
}

#pragma mark - 初始化导航

//显示页面
- (void)showWithType {
    [self configTitle:(self.type==DATED_TYPE)?@"过期预警":@"库存预警"];
    self.lblName.text = (self.type==DATED_TYPE)?@"过期提醒!":@"库存预警!";
    self.lblDetail.text = (self.type==DATED_TYPE)?@"仓库中的下列商品快要过期，请及时处理!":@"仓库中的下列商品已达库存下限，请及时补货!";
    self.searchId = [[Platform Instance] getShopMode]==3?[[Platform Instance] getkey:ORG_ID]:[[Platform Instance] getkey:SHOP_ID];
    self.currentPage = 1;
    self.dataList = [NSMutableArray array];
    if (self.type==DATED_TYPE) {
        [self selectDueAlertList];
    }else{
        [self selectStoreAlertList];
    }
    [self.mainGrid ls_addHeaderWithCallback:^{
        self.currentPage = 1;
        if (self.type==DATED_TYPE) {
            [self selectDueAlertList];
        }else{
            [self selectStoreAlertList];
        }

    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        self.currentPage ++;
        if (self.type==DATED_TYPE) {
            [self selectDueAlertList];
        }else{
            [self selectStoreAlertList];
        }

    }];
}

#pragma mark - 网络请求
//过期提醒
- (void)selectDueAlertList
{
    __weak typeof(self) weakSelf = self;
    [service selectDueAlertList:self.searchId currentPage:self.currentPage completionHandler:^(id json) {
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
        if (weakSelf.currentPage == 1) {
            [weakSelf.dataList removeAllObjects];
        }
        NSArray *list = [StockDueAlertVo converToArr:[json objectForKey:@"resultList"]];        if ([ObjectUtil isNotNull:list]) {
            [weakSelf.dataList addObjectsFromArray:list];
        }
        long count = [[json objectForKey:@"resultCount"] longValue];
        weakSelf.lblTotalAmount.text = [NSString stringWithFormat:@"(合计%ld项)",count];
        weakSelf.mainGrid.hidden = !(weakSelf.dataList.count>0);
        weakSelf.bgView.hidden = !(weakSelf.dataList.count>0);
        weakSelf.spaceView.hidden = (weakSelf.dataList.count>0);
        [weakSelf.mainGrid reloadData];
    } errorHandler:^(id json) {
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];

        weakSelf.currentPage --;
        [AlertBox show:json];
    }];

}

//库存预警
- (void)selectStoreAlertList
{
    __weak typeof(self) weakSelf = self;
    [service selectStoreList:self.searchId currentPage:self.currentPage completionHandler:^(id json) {
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];

        if (weakSelf.currentPage == 1) {
            [weakSelf.dataList removeAllObjects];
        }
        NSArray *list = [StockStoreAlertVo converToArr:[json objectForKey:@"resultList"]];
        if ([ObjectUtil isNotNull:list]) {
            [weakSelf.dataList addObjectsFromArray:list];
        }
        long count = [[json objectForKey:@"resultCount"] longValue];
        weakSelf.lblTotalAmount.text = [NSString stringWithFormat:@"(合计%ld项)",count];
        weakSelf.mainGrid.hidden = !(weakSelf.dataList.count>0);
        weakSelf.bgView.hidden = !(weakSelf.dataList.count>0);
        weakSelf.spaceView.hidden = (weakSelf.dataList.count>0);
        [weakSelf.mainGrid reloadData];
    } errorHandler:^(id json) {
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
        weakSelf.currentPage --;
        [AlertBox show:json];
    }];

}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* goodsInfoCellId = @"GoodsInfoCell";
    GoodsInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:goodsInfoCellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"GoodsInfoCell" bundle:nil] forCellReuseIdentifier:goodsInfoCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:goodsInfoCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataList!=nil&&self.dataList.count>0) {
        GoodsInfoCell* detailItem = (GoodsInfoCell*)cell;
        detailItem.lblRgtAmount.hidden = (self.type==DATED_TYPE);
        detailItem.lblLftAmount.hidden = !(self.type==DATED_TYPE);
        detailItem.lblDate.hidden = !(self.type==DATED_TYPE);
        if (self.type==DATED_TYPE) {
            //过期预警
            StockDueAlertVo *dueAlertVo = [self.dataList objectAtIndex:indexPath.row];
            detailItem.lblName.text = dueAlertVo.goodsName;
            detailItem.lblCode.text = dueAlertVo.barCode;
            detailItem.lblLftAmount.text = [NSString stringWithFormat:@"库存数:%@",dueAlertVo.nowStore];
            detailItem.lblDate.text = [NSString stringWithFormat:@"过期时间:%@",[DateUtils formateTime2:dueAlertVo.expiredDate]];
        }else{
            //库存预警
            StockStoreAlertVo *storeAlertVo = [self.dataList objectAtIndex:indexPath.row];
            detailItem.lblName.text = storeAlertVo.goodsName;
            detailItem.lblCode.text = storeAlertVo.barCode;
            detailItem.lblRgtAmount.text = [NSString stringWithFormat:@"库存数:%@",storeAlertVo.nowStore];
        }
    }

}

@end
