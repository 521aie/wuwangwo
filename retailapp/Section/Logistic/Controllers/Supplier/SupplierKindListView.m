//
//  SupplierKindListView.m
//  retailapp
//
//  Created by hm on 15/10/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SupplierKindListView.h"
#import "LSFooterView.h"
#import "GridCell.h"
#import "ServiceFactory.h"
#import "ViewFactory.h"
#import "AlertBox.h"
#import "SupplyTypeVo.h"
#import "XHAnimalUtil.h"
#import "SupplierTypeEditView.h"
#import "UIHelper.h"

@interface SupplierKindListView ()<GridCellDelegate,LSFooterViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CommonService *commonService;

@property (copy, nonatomic) SupplyTypeHandler supplyTypeHandler;
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) LSFooterView *footView;

@property (weak, nonatomic) id<INameValue> item;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation SupplierKindListView


- (void)viewDidLoad {
    [super viewDidLoad];
    self.commonService = [ServiceFactory shareInstance].commonService;
    [self configTitle:@"供应商类别" leftPath:Head_ICON_CANCEL rightPath:nil];
    [self configNavigationBar:LSNavigationBarButtonDirectLeft title:@"关闭" filePath:Head_ICON_CANCEL];
    CGFloat y = kNavH;
   
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_W, SCREEN_H - y)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView =  [ViewFactory generateFooter:BOTTOM_HEIGHT];
    [self.view addSubview:self.tableView];
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootAdd]];
    [self.view addSubview:self.footView];
    self.footView.ls_bottom = SCREEN_H;
    [self selectSupplyTypeList];
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    }
}
- (void)loadDataWithCallBack:(SupplyTypeHandler)handler
{
    self.supplyTypeHandler = handler;
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        if (self.supplyTypeHandler) {
            self.supplyTypeHandler(self.datas);
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - 获取供应商类别列表
- (void)selectSupplyTypeList
{
    __weak typeof(self) weakSelf = self;
    [self.commonService selectSupplyTypeList:^(id json) {
        weakSelf.datas = [SupplyTypeVo converToArr:[json objectForKey:@"listMap"]];
        [weakSelf.tableView reloadData];
        weakSelf.tableView.ls_show = YES;
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}
#pragma mark - 添加供应商类别
- (void)showAddEvent
{
    SupplierTypeEditView *editView = [[SupplierTypeEditView alloc] init];
    __weak typeof(self) weakSelf = self;
    [editView loadDataWithCallBack:^{
        [weakSelf selectSupplyTypeList];
    }];
    [self.navigationController pushViewController:editView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    editView = nil;
}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *gridCellId = @"GridCell";
    GridCell* gridCell = (GridCell*)[tableView dequeueReusableCellWithIdentifier:gridCellId];
    if (!gridCell) {
        [tableView registerNib:[UINib nibWithNibName:@"GridCell" bundle:nil] forCellReuseIdentifier:gridCellId];
        gridCell = (GridCell*)[tableView dequeueReusableCellWithIdentifier:gridCellId];
    }
    gridCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [gridCell setNeedsDisplay];
    return gridCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    GridCell* gridCell = (GridCell*)cell;
    if (self.datas.count>0) {
        id<INameValue> item = [self.datas objectAtIndex:indexPath.row];
        gridCell.delegate = self;
        gridCell.index = indexPath.row;
        gridCell.delPic.hidden = [[item obtainItemValue] isEqualToString:@"-1"];
        gridCell.delBtn.hidden = [[item obtainItemValue] isEqualToString:@"-1"];
        gridCell.lblName.text = [item obtainItemName];
    }
}

#pragma mark - 删除供应商类别
- (void)deleteGridCell:(GridCell *)cell
{
    self.item = [self.datas objectAtIndex:cell.index];
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"删除[%@]吗?",[self.item obtainItemName]]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        __weak typeof(self) weakSelf = self;
        [self.commonService deleteSupplyType:[self.item obtainItemId] withSupplyType:[self.item obtainItemValue] completionHandler:^(id json) {
            
            [weakSelf.datas removeObject:weakSelf.item];
            [weakSelf.tableView reloadData];
        
        } errorHandler:^(id json) {
            
            [AlertBox show:json];
        }];
    }
}


@end
