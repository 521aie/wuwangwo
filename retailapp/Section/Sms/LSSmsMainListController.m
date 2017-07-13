//
//  LSSmsMainListController.m
//  retailapp
//
//  Created by wuwangwo on 2017/2/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSmsMainListController.h"
#import "IEditItemListEvent.h"
#import "EditItemList.h"
#import "XHAnimalUtil.h"
#import "ViewFactory.h"
#import "GridColHead.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "ColorHelper.h"
#import "Notice.h"
#import "DateUtils.h"
#import "UIView+Sizes.h"
#import "SelectOrgShopListView.h"
#import "LSFooterView.h"
#import "LSSmsMainCell.h"
#import "SmsDetailController.h"
#import "LSEditItemList.h"

@interface LSSmsMainListController ()<UITableViewDataSource,UITableViewDelegate,IEditItemListEvent,LSFooterViewDelegate>

@property (nonatomic,strong) SmsService *service;
@property (nonatomic,strong) LSFooterView* footView;
/**消息公告数据源*/
@property (nonatomic,strong) NSMutableArray* datas;
/**分页标志*/
@property (nonatomic) NSInteger currentPage;
@end

@implementation LSSmsMainListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.service = [ServiceFactory shareInstance].smsService;

    __strong typeof(self) wself = self;
    
    self.lsShop = [LSEditItemList editItemList];
    self.lsShop.backgroundColor =  [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:self.lsShop];
    [self.lsShop makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.view);
        make.top.equalTo(wself.view).offset(kNavH);
        make.height.equalTo(50);
    }];
    
    self.mainGrid = [[UITableView alloc] init];
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    [self.view addSubview:self.mainGrid];
    [self.mainGrid makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.lsShop.bottom);
        make.left.right.bottom.equalTo(wself.view);
    }];
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootAdd]];
    [self.view addSubview:self.footView];
    [self.footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.height.equalTo(60);
    }];
    
    [self initNavigate];
    [self initMainView];
    [self initMainGrid];
    [self loadData];
}

#pragma mark - 初始化导航栏
- (void)initNavigate
{
    [self configTitle:@"发布公告" leftPath:Head_ICON_BACK rightPath:nil];
}

#pragma mark - 初始化页面
- (void)initMainView
{
    self.datas = [NSMutableArray array];
    [self.lsShop initLabel:@"接收门店" withHit:nil delegate:self];
    self.lsShop.line.hidden = YES;
    self.lsShop.imgMore.image = [UIImage imageNamed:@"ico_next"];
    if ([[Platform Instance] getShopMode]==3) {
        [self.lsShop initData:[[Platform Instance] getkey:ORG_NAME] withVal:[[Platform Instance] getkey:ORG_ID]];
        [self.mainGrid makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lsShop.bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    } else {
        [self.lsShop initData:[[Platform Instance] getkey:SHOP_NAME] withVal:[[Platform Instance] getkey:SHOP_ID]];
        [self.lsShop visibal:NO];
        [self.mainGrid makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(kNavH);
            make.left.right.bottom.equalTo(self.view);
        }];
    }
}

#pragma mark - 初始化表格
- (void)initMainGrid
{
    self.currentPage = 1;
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
    __weak typeof(self) weakSelf = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.currentPage =1;
        [weakSelf loadData];
    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadData];
    }];
}

#pragma mark - 加载消息公告列表
- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    [self.service selectSmsList:[self.lsShop getStrVal] currentPage:self.currentPage completionHandler:^(id json) {
        NSMutableArray* noticeList = [Notice converToArr:[json objectForKey:@"noticeList"]];
        if (weakSelf.currentPage==1) {
            [weakSelf.datas removeAllObjects];
        }
        [weakSelf.datas addObjectsFromArray:noticeList];
        [weakSelf.mainGrid reloadData];
        weakSelf.mainGrid.ls_show = YES;
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
        [AlertBox show:json];
    }];
}

#pragma mark - 加载机构门店
- (void)onItemListClick:(EditItemList *)obj
{
    SelectOrgShopListView *vc = [[SelectOrgShopListView alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    __weak typeof(self) weakSelf = self;
    [vc loadData:[obj getStrVal] withModuleType:3 withCheckMode:SINGLE_CHECK callBack:^(NSMutableArray *selectArr, id<ITreeItem> item) {
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [weakSelf.navigationController popViewControllerAnimated:NO];
        if (item) {
            [weakSelf.lsShop initData:[item obtainItemName] withVal:[item obtainItemId]];
            [weakSelf.mainGrid headerBeginRefreshing];
        }
    }];
}

#pragma mark - 添加事件
-(void)footViewdidClickAtFooterType:(NSString *)footerType{
    [self showAddEvent];
}

- (void)showAddEvent
{
    SmsDetailController *vc = [[SmsDetailController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    vc.action = ACTION_CONSTANTS_ADD;
}

#pragma mark - 帮助事件
- (void)showHelpEvent {
    
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    static NSString* gridColHeadId = @"GridColHead";
    GridColHead* headItem = [tableView dequeueReusableCellWithIdentifier:gridColHeadId];
    if (!headItem) {
        [tableView registerNib:[UINib nibWithNibName:@"GridColHead" bundle:nil] forCellReuseIdentifier:gridColHeadId];
        headItem= [tableView dequeueReusableCellWithIdentifier:gridColHeadId];
    }
    [headItem initColHead:@"公告标题" col2:@"发布状态"];
    [headItem initColLeft:15 col2:137];
    return headItem;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSSmsMainCell *cell = [LSSmsMainCell smsMainCellWithTableView:tableView];
    Notice* notice = [self.datas objectAtIndex:indexPath.row];
    cell.obj = notice;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Notice* notice = [self.datas objectAtIndex:indexPath.row];
    SmsDetailController *vc = [[SmsDetailController alloc] init];
    vc.noticeId = notice.noticeId;
    vc.action = ACTION_CONSTANTS_EDIT;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

@end
