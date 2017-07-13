//
//  ReasonListView.m
//  retailapp
//
//  Created by hm on 15/8/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ReasonListView.h"
#import "LSFooterView.h"
#import "GridCell.h"
#import "ServiceFactory.h"
#import "ViewFactory.h"
#import "AlertBox.h"
#import "ReasonVo.h"
#import "UIHelper.h"
#import "ReasonEditView.h"
#import "XHAnimalUtil.h"

@interface ReasonListView ()<LSFooterViewDelegate,GridCellDelegate, UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) CommonService *commonService;
/**原因数据列表*/
@property (nonatomic, strong) NSMutableArray* reasonList;
/**回调block*/
@property (nonatomic, copy) ReasonHangler reasonHandler;
/**原因code*/
@property (nonatomic, copy) NSString *dicCode;
/**标题名称*/
@property (nonatomic, copy) NSString *titleName;
/**原因模型*/
@property (nonatomic, strong) ReasonVo *reasonVo;
@property (strong, nonatomic) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) LSFooterView *footView;

@end

@implementation ReasonListView


- (void)viewDidLoad {
    [super viewDidLoad];
     self.commonService = [ServiceFactory shareInstance].commonService;
    [self initNavigate];
    [self configViews];
    self.tableView.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
    [self loadData];
}

- (void)configViews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootAdd]];
    [self.view addSubview:self.footView];
    self.footView.ls_bottom = SCREEN_H;
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    }
}

#pragma mark - 初始化导航
- (void)initNavigate
{
    [self configTitle:[NSString stringWithFormat:@"%@管理",self.titleName] leftPath:Head_ICON_CANCEL rightPath:nil];
     [self configNavigationBar:LSNavigationBarButtonDirectLeft title:@"关闭" filePath:Head_ICON_CANCEL];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        if (self.reasonHandler) {
            self.reasonHandler(self.reasonList);
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
    
}

- (void)loadDataWithCode:(NSString*)dicCode titleName:(NSString *)titleName CallBack:(ReasonHangler)handler
{
    self.reasonHandler = handler;
    self.dicCode = dicCode;
    self.titleName = titleName;
}

#pragma mark - 获取原因列表
- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    [self.commonService selectReasonListByCode:self.dicCode completionHandler:^(id json) {
        weakSelf.reasonList = [ReasonVo converToArr:[json objectForKey:@"returnResonList"]];
        [weakSelf.tableView reloadData];
         weakSelf.tableView.ls_show = YES;
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];

}

#pragma mark - 添加原因
- (void)showAddEvent
{
    ReasonEditView *reasonEditView = [[ReasonEditView alloc] init];
    __weak typeof(self) weakSelf = self;
    [reasonEditView loadDataWithCode:self.dicCode callBack:^{
        [weakSelf loadData];
    }];
    [self.navigationController pushViewController:reasonEditView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    reasonEditView = nil;
}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reasonList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    GridCell* detailItem = (GridCell*)cell;
    if (self.reasonList!=nil&&self.reasonList.count>0) {
        ReasonVo *vo = [self.reasonList objectAtIndex:indexPath.row];
        detailItem.lblName.text = vo.name;
        detailItem.delegate = self;
        detailItem.index = indexPath.row;
    }
}

#pragma mark - 删除原因
- (void)deleteGridCell:(GridCell *)cell
{
    self.reasonVo = [self.reasonList objectAtIndex:cell.index];
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"确认要删除[%@]吗?",self.reasonVo.name]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        __weak typeof(self) weakSelf = self;
        [self.commonService deleteReasonById:self.reasonVo.dicItemId withCode:self.dicCode completionHandler:^(id json) {
            [weakSelf.reasonList removeObject:weakSelf.reasonVo];
            [weakSelf.tableView reloadData];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

@end
