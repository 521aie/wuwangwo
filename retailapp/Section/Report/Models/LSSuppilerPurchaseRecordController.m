//
//  LSSuppilerPurchaseRecordController.m
//  retailapp
//
//  Created by wuwangwo on 2017/2/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSuppilerPurchaseRecordController.h"
#import "XHAnimalUtil.h"
#import "LSSuppilerPurchaseRecordHeaderView.h"
#import "LSSuppilerPurchaseRecordCell.h"
#import "LSSuppilerPurchaseVo.h"

@interface LSSuppilerPurchaseRecordController ()< UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
/** 头部View */
@property (nonatomic, strong) LSSuppilerPurchaseRecordHeaderView *viewHeader;
@property (nonatomic, strong) UIView *viewFooter;
/**<数据源>*/
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation LSSuppilerPurchaseRecordController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDatas];
    [self configViews];
    [self configConstraints];
    [self loadData];
}

- (void)configDatas {
    self.currentPage = 1;
    self.datas = [NSMutableArray array];
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self configTitle:@"采购记录" leftPath:Head_ICON_BACK rightPath:nil];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableHeaderView = self.viewHeader;
    self.tableView.tableFooterView = self.viewFooter;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    __strong typeof(self) wself = self;
    [self.tableView ls_addHeaderWithCallback:^{
        wself.currentPage = 1;
        [wself loadData];
    }];
    [self.tableView ls_addFooterWithCallback:^{
        wself.currentPage++;
        [wself loadData];
    }];
    [self.view addSubview:self.tableView];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.top.equalTo(wself.view.top).offset(kNavH);
    }];
}

- (void)loadData {
    __weak typeof(self) wself = self;
    NSString *url = @"goodsPurchase/detail";
    
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        if (wself.currentPage == 1) {
            [wself.datas removeAllObjects];
        }
        NSArray *list = json[@"goodsPurchaseDetail"];
        if ([ObjectUtil isNotNull:list]) {
            NSArray *objs = [LSSuppilerPurchaseVo mj_objectArrayWithKeyValuesArray:list];
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

#pragma mark - 头部View
- (LSSuppilerPurchaseRecordHeaderView *)viewHeader {
    if (_viewHeader == nil) {
        _viewHeader = [LSSuppilerPurchaseRecordHeaderView suppilerPurchaseRecordHeaderView:self.obj];
    }
    return _viewHeader;
}

#pragma mark - 底部View
- (UIView *)viewFooter{
    if (_viewFooter == nil) {
        [self makeViewFooter];
    }
    return _viewFooter;
}

- (void)makeViewFooter{
    CGFloat margin = 10;
    _viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_W-20), 30)];
    _viewFooter.backgroundColor = [UIColor clearColor];
    
    //数量
    UILabel *lblTotalNum = [[UILabel alloc] init];
    lblTotalNum.font = [UIFont systemFontOfSize:13];
    lblTotalNum.textColor = [ColorHelper getTipColor6];
    [self.viewFooter addSubview:lblTotalNum];
    [lblTotalNum makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewFooter).offset(margin);
        make.top.bottom.equalTo(self.viewFooter);
        make.width.equalTo(SCREEN_W/2-margin);
    }];
    
    //进货/退货价
    UILabel *lblTotalCount = [[UILabel alloc] init];
    lblTotalCount.font = [UIFont systemFontOfSize:13];
    lblTotalCount.textColor = [ColorHelper getRedColor];
    lblTotalCount.textAlignment = NSTextAlignmentRight;
    [self.viewFooter addSubview:lblTotalCount];
    [lblTotalCount makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.viewFooter).offset(-margin);
        make.top.bottom.equalTo(self.viewFooter);
        make.width.equalTo(lblTotalNum);
    }];

    //进/退货量、进/退货量金额
    NSString *goodsNum = nil;
    if ([ObjectUtil isNotNull:self.obj.invoiceFlag]) {
        if (self.obj.invoiceFlag.intValue == 1) {//进货
            if ([ObjectUtil isNotNull:self.obj.stockNum]) {
                if ([self.obj.stockNum.stringValue containsString:@"."]) {
                    goodsNum = [NSString stringWithFormat:@"合计 %.3f 件", self.obj.stockNum.doubleValue];
                } else {
                    goodsNum = [NSString stringWithFormat:@"合计 %.f 件", self.obj.stockNum.doubleValue];
                }
                NSMutableAttributedString *goodsNumAttr = [[NSMutableAttributedString alloc] initWithString:goodsNum];
                [goodsNumAttr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getRedColor] range:NSMakeRange(3, (goodsNumAttr.length-4))];
                lblTotalNum.attributedText = goodsNumAttr;
                lblTotalCount.text = [NSString stringWithFormat:@"¥%.2f", self.obj.stockAmount.doubleValue];
            }
        } else {
            if ([ObjectUtil isNotNull:self.obj.returnNum]) {
                if ([self.obj.returnNum.stringValue containsString:@"."]) {
                    goodsNum = [NSString stringWithFormat:@"合计 %.3f 件", self.obj.returnNum.doubleValue];
                } else {
                    goodsNum = [NSString stringWithFormat:@"合计 %.f 件", self.obj.returnNum.doubleValue];
                }
                NSMutableAttributedString *goodsNumAttr = [[NSMutableAttributedString alloc] initWithString:goodsNum];
                [goodsNumAttr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getRedColor] range:NSMakeRange(3, (goodsNumAttr.length-4))];
                lblTotalNum.attributedText = goodsNumAttr;
                lblTotalCount.text = [NSString stringWithFormat:@"¥%.2f", self.obj.returnAmount.doubleValue];
            }
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSSuppilerPurchaseRecordCell *cell = [LSSuppilerPurchaseRecordCell suppilerPurchaseDetailCellWithTableView:tableView];
    LSSuppilerPurchaseVo *obj = self.datas[indexPath.row];
    cell.obj = obj;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LSSuppilerPurchaseVo *obj = self.datas[indexPath.row];
    CGFloat nameHeight = [LSSuppilerPurchaseRecordCell heightForContent:obj.goodsName];
    CGFloat codeHeight = [LSSuppilerPurchaseRecordCell heightForContent:obj.barCode];
    return  20 + nameHeight+codeHeight;
}

@end
