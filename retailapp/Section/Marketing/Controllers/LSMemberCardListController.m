//
//  LSMemberCardListController.m
//  retailapp
//
//  Created by guozhi on 2016/10/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberCardListController.h"
#import "NavigateTitle2.h"
#import "LSFooterView.h"
#import "XHAnimalUtil.h"
#import "LSSelectMemberCell.h"
#import "AlertBox.h"
#import "LSMemberTypeVo.h"

@interface LSMemberCardListController ()<INavigateEvent, LSFooterViewDelegate,UITableViewDelegate, UITableViewDataSource>
/** 标题栏 */
@property (nonatomic, strong) NavigateTitle2 *navigateTitle;
/** 表格 */
@property (nonatomic, strong) UITableView *tableView;
/** 底部工具栏 */
@property (nonatomic, strong) LSFooterView *footView;
/** 回调 */
@property (nonatomic, copy) CallBlock callBlock;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *datas;
@end

@implementation LSMemberCardListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configConstraints];
}

- (void)loadData:(NSMutableArray *)datas callBlock:(CallBlock)callBlock {
    self.datas = datas;
    self.callBlock = callBlock;
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //标题栏
    self.navigateTitle = [NavigateTitle2 navigateTitle:self];
    [self.navigateTitle initWithName:@"选择会员卡" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.navigateTitle.lblRight.text = @"确认";
    [self.view addSubview:self.navigateTitle];
    //配置表格
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60.0, 0);
    [self.view addSubview:self.tableView];
    
    //配置底部工具栏
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootSelectAll, kFootSelectNo]];
    [self.view addSubview:self.footView];
}

- (void)configConstraints {
    //配置标题栏约束
    __weak typeof(self) wself = self;
    [self.navigateTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(wself.view);
        make.height.equalTo(64);
    }];
    //配置表格约束
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(wself.navigateTitle.bottom);
        make.bottom.equalTo(wself.view);
    }];
    //配置底部工具栏约束
    [self.footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.height.equalTo(60);
    }];
    
}

#pragma mark - Delegate
#pragma mark INavigateEvent
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        NSMutableArray *datas = [NSMutableArray array];
        for (LSMemberTypeVo *cardVo in self.datas) {
            if (cardVo.isSelect) {
                [datas addObject:cardVo];
            }
        }
        if (datas.count == 0) {
            [AlertBox show:@"请先选择会员卡！"];
        } else {
            if (self.callBlock) {
                self.callBlock(datas);
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                [self.navigationController popViewControllerAnimated:NO];
            }
        }
    }
}
#pragma mark LSFooterViewDelegate
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootSelectNo]) {//全不选
        for (LSMemberTypeVo *cardVo in self.datas) {
            cardVo.isSelect = NO;
        }
    } else {//全选
        for (LSMemberTypeVo *cardVo in self.datas) {
            cardVo.isSelect = YES;
        }
    }
    [self.tableView reloadData];
}
#pragma merk UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSSelectMemberCell *cell = [LSSelectMemberCell selectMemberCellWithTableView:tableView];
    cell.cardVo = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSMemberTypeVo *cardVo = self.datas[indexPath.row];
    cardVo.isSelect = !cardVo.isSelect;
    [self.tableView reloadData];
}



@end
