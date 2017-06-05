//
//  LSKindPayListController.m
//  retailapp
//
//  Created by guozhi on 2016/11/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSKindPayListController.h"
#import "LSFooterView.h"
#import "XHAnimalUtil.h"
#import "KindPayEditView.h"
#import "SortTableView.h"
#import "AlertBox.h"
#import "PaymentVo.h"
#import "LSKindPayListCell.h"
#import "NameItemVO.h"
#import "GridColHead.h"
@interface LSKindPayListController ()<UITableViewDataSource, UITableViewDelegate, LSFooterViewDelegate>
/** 表格 */
@property (nonatomic, strong) UITableView *tableView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *datas;
/** <#注释#> */
@property (nonatomic, strong) LSFooterView *footView;
/**支付方式添加页面点击支付类型弹出框的值*/
@property (nonatomic,strong) NSMutableArray *payList;
/**请求的参数用来区分是不是排序请求的*/
@property (nonatomic,strong) NSMutableArray *list;
@end

@implementation LSKindPayListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configConstraints];
    [self loadData];
    [self configHelpButton:HELP_SETTING_PAYMENT_METHOD];
}
- (void)configViews {
    self.datas = [[NSMutableArray alloc] init];
    self.list = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor clearColor];
    //标题栏
    [self configTitle:@"支付方式" leftPath:Head_ICON_BACK rightPath:nil];
    
    //表格
    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 88;
    self.tableView.tableFooterView = [ViewFactory generateFooter:60];
    [self.view addSubview:self.tableView];
    __weak typeof(self) wself = self;
    [self.tableView ls_addHeaderWithCallback:^{
        [wself loadData];
    }];
    
    //工具栏
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootAdd, kFootSort]];
    [self.view addSubview:self.footView];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    //配置表格
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.top.equalTo(wself.view.top).offset(kNavH);
    }];
    
    //工具栏
    [self.footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.height.equalTo(60);
    }];
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    } else if ([footerType isEqualToString:kFootSort]) {
        [self showSortEvent];
    }
}
- (void)showAddEvent {
    KindPayEditView *vc = [[KindPayEditView alloc] initWithAction:ACTION_CONSTANTS_ADD paymentVo:nil payList:self.payList];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];}

- (void)showSortEvent {
    if (self.datas.count < 2) {
        [AlertBox show:@"请至少添加两条内容，才能进行排序。"];
        return;
    }
    __weak typeof(self) weakself = self;
    SortTableView *vc = [[SortTableView alloc] initWithDatas:self.datas onRightBtnClick:^(NSMutableArray *datas) {
        NSMutableArray *list = [NSMutableArray array];
        for (PaymentVo *vo in datas) {
            [list addObject:vo.payId];
        }
        NSString *url = @"payMent/list";
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:list forKey:@"payIdList"];
        [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
            [weakself loadData];
            weakself.payList = [[NSMutableArray alloc] init];
        } errorHandler:^(id json) {
             [AlertBox show:json];
        }];
    } setCellContext:^(SortTableViewCell *cell, id obj) {
        PaymentVo *vo = (PaymentVo *)obj;
        [cell setTitle:vo.payMentName];
    }];
    [weakself.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:weakself.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    
}

#pragma mark - 加载数据
- (void)loadData {
    NSString *url = @"payMent/list";
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:self.list forKey:@"payIdList"];
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        if ([ObjectUtil isNotNull:json]) {
            NSArray *list = json[@"payMentVoList"];
            wself.datas = [PaymentVo mj_objectArrayWithKeyValuesArray:list];
            [wself.tableView reloadData];
            NSArray *payList = json[@"payVoList"];
            wself.payList = [[NSMutableArray alloc] init];
            if ([ObjectUtil isNotNull:payList]) {
                for (NSDictionary *obj in payList) {
                    NameItemVO *itemVo = [[NameItemVO alloc] initWithVal:obj[@"name"] andId:obj[@"typeId"]];
                    [wself.payList addObject:itemVo];
                }
                
            }
        }

    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}
#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSKindPayListCell *cell = [LSKindPayListCell kindPayListCellWithTableView:tableView];
    cell.paymentVo = self.datas[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GridColHead *headItem = [[NSBundle mainBundle] loadNibNamed:@"GridColHead" owner:self options:nil].lastObject;
    [headItem initColHead:@"名称" col2:@"支付类型"];
    [headItem initColLeft:10 col2:140];
    return headItem;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PaymentVo *vo = [self.datas objectAtIndex:indexPath.row];
    KindPayEditView *vc = [[KindPayEditView alloc] initWithAction:ACTION_CONSTANTS_EDIT paymentVo:vo payList:self.payList];
    vc.count = self.datas.count;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    
}

@end
