//
//  AdjustReasonListView.m
//  retailapp
//
//  Created by hm on 15/9/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "AdjustReasonListView.h"
#import "ServiceFactory.h"
#import "LSFooterView.h"
#import "GridColHead.h"
#import "GridCell.h"
#import "XHAnimalUtil.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "AdjustReasonEditView.h"
#import "AdjustReasonVo.h"

@interface AdjustReasonListView ()<LSFooterViewDelegate,GridCellDelegate, UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) StockService *stockService;
/**调整原因数据模型*/
@property (nonatomic, strong) AdjustReasonVo *reasonVo;

/** <#注释#> */
@property (nonatomic, strong) UITableView *mainGrid;
/** <#注释#> */
@property (nonatomic, strong) LSFooterView *footView;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *datas;
/** <#注释#> */
@property (nonatomic, assign) AdjustReasonListViewType type;
@end

@implementation AdjustReasonListView
- (instancetype)initWithType:(AdjustReasonListViewType)type {
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadReasonList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stockService = [ServiceFactory shareInstance].stockService;
    [self configViews];
}
- (void)configViews {
    NSString *title = @"";
    if (self.type == AdjustReasonListViewTypeCostAdjust) {
        title = @"成本价调整原因";
    } else if (self.type == AdjustReasonListViewTypeStockAdjust) {
        title = @"库存调整原因";
    }
    [self configTitle:title];
    [self configNavigationBar:LSNavigationBarButtonDirectLeft title:@"关闭" filePath:Head_ICON_CANCEL];
    
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH) style:UITableViewStylePlain];
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:HEIGHT_CONTENT_BOTTOM];
    [self.view addSubview:self.mainGrid];
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootAdd]];
    self.footView.ls_bottom = SCREEN_H;
    [self.view addSubview:self.footView];
}

#pragma mark - 设置页面回调block
- (void)loadData:(ReasonBack)callBack
{
    self.reasonBack = callBack;
}

#pragma mark - 页面跳转
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event == LSNavigationBarButtonDirectLeft) {
        self.reasonBack(self.datas);
        [self popViewController];
    }
}

#pragma mark - 查询原因一览
- (void)loadReasonList
{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:@"" forKey:@"adjustReason"];
    NSString *url = @"";
    if (self.type == AdjustReasonListViewTypeCostAdjust) {
        url = @"costPriceOpBills/costReasonList";
    } else if (self.type == AdjustReasonListViewTypeStockAdjust) {
        url = @"stockAdjust/adjustReasonList";
    }
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        weakSelf.datas = [AdjustReasonVo converToArr:[json objectForKey:@"reasonList"]];
        [weakSelf.mainGrid reloadData];
        weakSelf.mainGrid.ls_show = YES;

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];

}

#pragma mark - 添加调整原因

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    }
}
- (void)showAddEvent
{
    AdjustReasonEditViewType type = 0;
    if (self.type == AdjustReasonListViewTypeStockAdjust) {
        type = AdjustReasonEditViewTypeStockAdjust;
    } else if (self.type == AdjustReasonListViewTypeCostAdjust) {
        type = AdjustReasonEditViewTypeCostAdjust;
    }
    AdjustReasonEditView *vc = [[AdjustReasonEditView alloc] initWithType:type];
    [self pushViewController:vc direct:AnimationDirectionH];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* gridCellId = @"GridCell";
    GridCell* cell = [tableView dequeueReusableCellWithIdentifier:gridCellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"GridCell" bundle:nil] forCellReuseIdentifier:gridCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:gridCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas.count>0) {
        self.reasonVo = [self.datas objectAtIndex:indexPath.row];
        GridCell* detailItem = (GridCell*)cell;
        detailItem.index = indexPath.row;
        detailItem.lblName.text = self.reasonVo.typeName;
        detailItem.delegate = self;
    }
}


#pragma mark - 删除指定的调整原因
- (void)deleteGridCell:(GridCell *)cell
{
    self.reasonVo = [self.datas objectAtIndex:cell.index];
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"删除[%@]吗?",self.reasonVo.typeName]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
        [param setValue:self.reasonVo.typeVal forKey:@"adjustReasonId"];
        NSString *url = @"";
        if (self.type == AdjustReasonListViewTypeCostAdjust) {
            url = @"costPriceOpBills/deleteCostReason";
        } else if (self.type == AdjustReasonListViewTypeStockAdjust) {
            url = @"stockAdjust/deleteAdjustReason";
        }
        __weak typeof(self) weakSelf = self;
        [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
            [weakSelf.datas removeObject:weakSelf.reasonVo];
            [weakSelf.mainGrid reloadData];
            weakSelf.mainGrid.ls_show = YES;

        } errorHandler:^(id json) {
            [LSAlertHelper showAlert:json];
        }];

    }
}

@end
