//
//  LSMemberCardTypeViewController.m
//  retailapp
//
//  Created by taihangju on 16/9/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberCardTypeListViewController.h"
#import "LSMemberCardTypeViewController.h"
#import "GridColHead.h"
#import "NavigateTitle2.h"
//#import "FooterListView.h"
#import "LSFooterView.h"
#import "MemberTypeCell.h"
#import "HttpEngine.h"
#import "BaseService.h"
#import "LSMemberTypeVo.h"

static NSString *memberTypeCellId = @"MemberTypeCellIndentifier";
@interface LSMemberCardTypeListViewController ()<INavigateEvent ,LSFooterViewDelegate ,UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic ,strong) NavigateTitle2 *titleBox;/*<>*/
@property (nonatomic ,strong) LSFooterView *footerView;/*<>*/
@property (nonatomic ,strong) UITableView *tableView;/*<>*/
@property (nonatomic ,strong) NSArray *dataSource;/* <会员类型列表*/
@end

@implementation LSMemberCardTypeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getMemberCardTypeList];
    [self initNavigate];
    [self configSubViews];
    [self configHelpButton:HELP_MEMBER_CARD_TYPE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
}

#pragma mark - NavigateTitle2 代理
//初始化导航栏
- (void)initNavigate {
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
    [self.titleBox initWithName:@"会员卡类型" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:self.titleBox];
}

//导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        [self popToLatestViewController:kCATransitionFromLeft];
    }
}


- (void)configSubViews {
    
    // tableView headerView
    GridColHead *headItem = [[NSBundle mainBundle] loadNibNamed:@"GridColHead" owner:self options:nil].lastObject;
    [headItem initColHead:@"会员卡名称" col2:@"优惠方式"];
    [headItem initColLeft:10 col2:140];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 44.0)];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.0, SCREEN_W, SCREEN_H - 64.0) style:UITableViewStylePlain];
    [self.tableView registerNib:[UINib nibWithNibName:@"MemberTypeCell" bundle:nil] forCellReuseIdentifier:memberTypeCellId];
    self.tableView.tableFooterView = footerView;
    self.tableView.separatorColor = [ColorHelper getTipColor3];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = 88.0f;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = headItem;
    [self.view addSubview:self.tableView];
    
    self.footerView = [LSFooterView footerView];
    [self.footerView initDelegate:self btnsArray:@[kFootAdd]];
    [self.view addSubview:self.footerView];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView ls_addHeaderWithCallback:^{
        
        [weakSelf getMemberCardTypeList];
    }];
}

#pragma mark -  LSFooterViewDelegate

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootAdd]) {
         [self cardTypeAction:ACTION_CONSTANTS_ADD model:nil];
    }
}

// -> 添加新卡类型页面
- (void)cardTypeAction:(NSInteger)type model:(LSMemberTypeVo *)editVo {
    __weak typeof(self) weakSelf = self;
    LSMemberCardTypeViewController *vc = [[LSMemberCardTypeViewController alloc] initWithType:type typeVo:editVo cardTypes:self.dataSource block:^{
        
        [weakSelf popToLatestViewController:kCATransitionFromLeft];
        [weakSelf.tableView headerBeginRefreshing];
    }];
    [self pushController:vc from:kCATransitionFromRight];
}

#pragma mark UITableView无section列表
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberTypeCell *detailItem = (MemberTypeCell *)[tableView dequeueReusableCellWithIdentifier:memberTypeCellId];
    LSMemberTypeVo *vo = nil;
    if (indexPath.row < _dataSource.count) {
        vo = [_dataSource objectAtIndex:indexPath.row];
        [detailItem setCardName:vo.name primedRate:[vo getModeStringShowRatio]];
    }
    return detailItem;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    LSMemberTypeVo *vo = self.dataSource[indexPath.row];
    [self cardTypeAction:ACTION_CONSTANTS_EDIT model:vo];
}

#pragma mark - 网络请求
- (void)endRefreshing {
    
    [self.tableView headerEndRefreshing];
}

- (void)getMemberCardTypeList {
    
    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    NSDictionary *param = @{@"entityId":entityId};
    
    [BaseService getRemoteLSOutDataWithUrl:@"kindCard/v2/list" param:[param mutableCopy] withMessage:@"" show:YES CompletionHandler:^(id json) {
        [self endRefreshing];
        self.dataSource = [LSMemberTypeVo getMemberTypeVos:json[@"data"]];
        [self.tableView reloadData];
        self.tableView.ls_show = YES;
    } errorHandler:^(id json) {
        [self endRefreshing];
    }];
}
@end
