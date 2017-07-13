//
//  LSPurchaseRecordController.m
//  retailapp
//
//  Created by guozhi on 2017/1/16.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSPurchaseRecordController.h"
#import "XHAnimalUtil.h"
#import "LSPurchaseRecordHeaderView.h"
#import "LSPurchaseRecordDetailCell.h"
#import "LSGoodsPurchaseVo.h"

@interface LSPurchaseRecordController ()< UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
/** 头部View */
@property (nonatomic, strong) LSPurchaseRecordHeaderView *viewHeader;
@property (nonatomic, strong) UIView *viewFooter;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation LSPurchaseRecordController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self configTitle:@"采购记录" leftPath:Head_ICON_BACK rightPath:nil];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //TableView 中的 cell 自适应
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableHeaderView = self.viewHeader;
    self.tableView.tableFooterView = self.viewFooter;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}


//- (void)loadData {
//    __weak typeof(self) wself = self;
//    NSString *url = @"goodsPurchase/detail";
//    [self.param setValue:@(self.currentPage) forKey:@"currPage"];
//    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
//        [wself.tableView headerEndRefreshing];
//        [wself.tableView footerEndRefreshing];
//        if (wself.currentPage == 1) {
////            [wself.datas removeAllObjects];
//        }
//        NSArray *list = json[@"goodsPurchaseDetail"];
//        if ([ObjectUtil isNotNull:list]) {
//            NSArray *objs = [LSGoodsPurchaseVo mj_objectArrayWithKeyValuesArray:list];
////            [wself.datas addObjectsFromArray:objs];
//        }
//        wself.tableView.tableHeaderView = wself.viewHeader;
//        [wself.tableView reloadData];
//        wself.tableView.ls_show = YES;
//    } errorHandler:^(id json) {
//        wself.currentPage--;
//        [wself.tableView headerEndRefreshing];
//        [wself.tableView footerEndRefreshing];
//        [LSAlertHelper showAlert:json];
//    }];
//}

#pragma mark - 头部View
- (LSPurchaseRecordHeaderView *)viewHeader {
    if (_viewHeader == nil) {
        _viewHeader = [LSPurchaseRecordHeaderView purchaseRecordHeaderView : self.obj];
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
    UILabel *lblGoodsNum = [[UILabel alloc] init];
    lblGoodsNum.font = [UIFont systemFontOfSize:13];
    lblGoodsNum.textColor = [ColorHelper getTipColor6];
    [self.viewFooter addSubview:lblGoodsNum];
    [lblGoodsNum makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewFooter).offset(margin);
        make.top.bottom.equalTo(self.viewFooter);
        make.width.equalTo(SCREEN_W/2-margin);
    }];
    
    //进货/退货价
    UILabel *lblGoodsPrice = [[UILabel alloc] init];
    lblGoodsPrice.font = [UIFont systemFontOfSize:13];
    lblGoodsPrice.textColor = [ColorHelper getRedColor];
    lblGoodsPrice.textAlignment = NSTextAlignmentRight;
    [self.viewFooter addSubview:lblGoodsPrice];
    [lblGoodsPrice makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.viewFooter).offset(-margin);
        make.top.bottom.equalTo(self.viewFooter);
        make.width.equalTo(lblGoodsNum);
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
                lblGoodsNum.attributedText = goodsNumAttr;
                lblGoodsPrice.text = [NSString stringWithFormat:@"¥%.2f", self.obj.stockAmount.doubleValue];
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
                lblGoodsNum.attributedText = goodsNumAttr;
                lblGoodsPrice.text = [NSString stringWithFormat:@"¥%.2f", self.obj.returnAmount.doubleValue];
            }
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSPurchaseRecordDetailCell *cell = [LSPurchaseRecordDetailCell purchaseRecordDetailCellWithTableView:tableView];
    LSGoodsPurchaseVo *obj = self.obj;
    obj.goodsName = [self.param objectForKey:@"goodsName"];
    obj.barCode = [self.param objectForKey:@"barCode"];
    cell.obj = obj;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LSGoodsPurchaseVo *obj = self.obj;
    obj.goodsName = [self.param objectForKey:@"goodsName"];
    obj.barCode = [self.param objectForKey:@"barCode"];
    CGFloat nameHeight = [LSPurchaseRecordDetailCell heightForContent:obj.goodsName];
    CGFloat codeHeight = [LSPurchaseRecordDetailCell heightForContent:obj.barCode];    
    return  20 + nameHeight+codeHeight;
}

@end
