//
//  LSMemberConsumeDetailController.m
//  retailapp
//
//  Created by guozhi on 2016/12/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberConsumeDetailController.h"
#import "XHAnimalUtil.h"
#import "LSGoodsTransactionFlowMemberView.h"
#import "LSGoodsTransactionFlowHeaderView.h"
#import "LSGoodsTransactionFlowDetailCell.h"
#import "LSGoodsTransactionFlowFooterView.h"
#import "AlertBox.h"
#import "LSOrderDetailReportVo.h"
#import "LSOrderReportVo.h"
#import "DateUtils.h"

@interface LSMemberConsumeDetailController ()<UITableViewDelegate, UITableViewDataSource>
/** 表格 */
@property (nonatomic, strong)  UITableView *tableView;
/** 单号 */
@property (nonatomic, strong) UILabel *lblOrderNumber;
/** 订单时间 */
@property (nonatomic, strong) UILabel *lblOrderTime;
/** 表头 */
@property (nonatomic, strong) LSGoodsTransactionFlowHeaderView *viewHeader;
/** headerView */
@property (nonatomic, strong) UIView *viewMember;
/** footerView */
@property (nonatomic, strong) LSGoodsTransactionFlowFooterView *viewFooter;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *datas;
/** <#注释#> */
@property (nonatomic, strong) LSOrderReportVo *orderReportVo;
/** //根据流水号判断是订货单还是退货单 YES是订货单 NO是退货单 */
@property (nonatomic, assign) BOOL isOrder;

@end

@implementation LSMemberConsumeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self loadData];
}

- (void)configViews {
    self.view.backgroundColor = [UIColor clearColor];
    self.datas = [NSMutableArray array];
    //标题
    [self configTitle:@"会员消费详情" leftPath:Head_ICON_BACK rightPath:nil];
    //表格
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 88;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}


- (void)loadData {
    __weak typeof(self) wself = self;
    NSString *url = @"customerDeal/dealDetail";
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        id orderReportVo = json[@"orderReportVo"];
        NSArray *settlements = json[@"settlements"];
        NSArray *userorderopt = json[@"userorderopt"];
        if ([ObjectUtil isNotNull:orderReportVo]) {
            wself.orderReportVo = [LSOrderReportVo mj_objectWithKeyValues:orderReportVo];
            //销售时间 订单类型 自己获取
            wself.orderReportVo.salesTime = [DateUtils formateTime1:[wself.orderReportVo.payTime longLongValue]/1000];
            //YES 是销售单  NO是退货单这个值要在表格刷新的前面 因为表格刷新的时候需要这个值
            wself.isOrder =  [wself isOrder:wself.orderReportVo.waternumber];;
            if (wself.isOrder) {//销售单
                wself.orderReportVo.orderKind = @1;
            } else {//退货单
                wself.orderReportVo.orderKind = @2;
            }
            wself.tableView.tableFooterView = wself.viewFooter;
            wself.tableView.tableHeaderView = wself.viewHeader;
            wself.viewHeader.orderReportVo = wself.orderReportVo;
            [wself.viewFooter setOrderReportVo:wself.orderReportVo settlements:settlements userorderopt:userorderopt];
        }
        id orderDetailReportVoList = json[@"orderDetailReportVoList"];
        if ([ObjectUtil isNotNull:orderDetailReportVoList]) {
            wself.datas = [LSOrderDetailReportVo mj_objectArrayWithKeyValuesArray:orderDetailReportVoList];
            [wself.tableView reloadData];
        }

    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

//根据流水号判断是订货单还是退货单
- (BOOL)isOrder:(NSString *)waterNumber{
    NSString *begin = [waterNumber substringToIndex:1];
    NSString *beginThree = [waterNumber substringToIndex:3];
    if ([begin isEqualToString:@"2"] || [beginThree isEqualToString:@"RBW"]) {
        return NO;//退货单
    }else{
        return YES;//订货单
    }
}

#pragma mark - header View
- (UIView *)viewHeader {
    if (_viewHeader == nil) {
        LSGoodsTransactionFlowHeaderView *headerView = [LSGoodsTransactionFlowHeaderView goodsTransactionFlowHeaderView];
        headerView.frame = CGRectMake(0, 0, SCREEN_W, headerView.ls_height);
        _viewHeader = headerView;
    }
    return _viewHeader;
}
#pragma mark - footer View
- (LSGoodsTransactionFlowFooterView *)viewFooter {
    if (_viewFooter == nil) {
        _viewFooter = [LSGoodsTransactionFlowFooterView goodsTransactionFlowFooterView];
    }
    return _viewFooter;
}
#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSGoodsTransactionFlowDetailCell *cell = [LSGoodsTransactionFlowDetailCell goodsTransactionFlowDetailCellWithTable:tableView];
    LSOrderDetailReportVo *goodsInfo = self.datas[indexPath.row];
    [cell setGoodsInfo:goodsInfo isOrder:self.isOrder];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSOrderDetailReportVo *goodsInfo = self.datas[indexPath.row];
    return goodsInfo.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}



@end
