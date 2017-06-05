//
//  LSMemberQueryViewController.m
//  retailapp
//
//  Created by byAlex on 16/9/13.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberQueryViewController.h"
#import "LSMemberDetailViewController.h" // 会员详情页面
#import "LSMemberElectronicCardSendViewController.h"
#import "LSMemberInfoCell.h"
#import "LSMemberSearchBar.h"
#import "NavigateTitle2.h"
#import "UIView+Sizes.h"
#import "SMHeaderItem.h"
#import "LSMemberInfoVo.h"
#import "LSAlertHelper.h"
#import "LSFooterView.h"
#import "ExportView.h"

static NSString *memberInoCellId = @"LSMemberInfoCell";
@interface LSMemberQueryViewController ()<INavigateEvent ,UITableViewDelegate ,UITableViewDataSource ,LSFooterViewDelegate>

@property (nonatomic ,strong) LSMemberSearchBar *mbSearchBar;/*<搜索框>*/
@property (nonatomic ,strong) NavigateTitle2 *titleBox;/*<>*/
@property (nonatomic ,strong) UITableView *tableView;/* <会员列表*/
@property (nonatomic ,strong) NSString *queryString;/*<首页和本页面搜索框输入内容 可以为空>*/
@property (nonatomic ,assign) NSInteger currentPage;/*<当前页>*/
@property (nonatomic ,strong) NSMutableDictionary *groupDatas;/*<数据源>*/
@property (nonatomic ,strong) NSArray *allKeys;/*<groupDatas 对应的keys>*/
@property (nonatomic ,strong) NSString *keyWord;/*<查询关键词，前一个界面传过来的>*/
@property (nonatomic ,strong) LSFooterView *footerView;/* <底部工具栏*/
@end

@implementation LSMemberQueryViewController

- (instancetype)init:(NSString *)queryString {
    self = [super init];
    if (self) {
        self.queryString = queryString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.currentPage = 1;
    [self queryMemberInfo:self.queryString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configSubViews {
    
    // 导航
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
    [self.titleBox initWithName:@"会员查询" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:self.titleBox];
    
    // 搜索框
    __weak typeof(self) weakSelf = self;
    self.mbSearchBar = [LSMemberSearchBar memberSearchBar:^(NSString *queryString) {
        weakSelf.currentPage = 1;
        weakSelf.queryString = queryString;
        [weakSelf queryMemberInfo:queryString];
    }];
    [self.mbSearchBar setSearchWord:self.keyWord];
    self.mbSearchBar.ls_top = self.titleBox.ls_bottom;
    [self.view addSubview:self.mbSearchBar];
    
    // TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.mbSearchBar.ls_bottom, SCREEN_W, SCREEN_H-self.mbSearchBar.ls_bottom) style:UITableViewStylePlain];
    [self.tableView registerClass:[LSMemberInfoCell class] forCellReuseIdentifier:memberInoCellId];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorColor = [ColorHelper getTipColor3];
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.rowHeight = 88.0;
    self.tableView.sectionHeaderHeight = 30.0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    [self.tableView ls_addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf queryMemberInfo:nil];
    }];
    
    [self.tableView ls_addFooterWithCallback:^{
        weakSelf.currentPage += 1;
        [weakSelf queryMemberInfo:nil];
    }];
    
    //底部工具栏
    self.footerView = [LSFooterView footerView];
    [self.footerView initDelegate:self btnsArray:@[kFootExport]];
    [self.view addSubview:self.footerView];
}

- (void)endRefresh {
    
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
}

// 生成sectionHeader
- (SMHeaderItem *)getHeader:(NSString *)string {
    
    SMHeaderItem *item = [SMHeaderItem loadFromNib];
    item.lblVal.text = string ? :@"";
    return item;
}

#pragma mark - INavigateEvent
//导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        [self popToLatestViewController:kCATransitionFromLeft];
    }
}

// LSFooterViewDelegate
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootExport]) {
        
        NSString *keyWord = [NSString isBlank:self.queryString]?@"":self.queryString;
        ExportView *vc = [[ExportView alloc] init];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:keyWord,@"keyWord", nil];
        [vc loadData:params withPath:@"customer/export" withIsPush:NO callBack:^{
            [self popToLatestViewController:kCATransitionFromBottom];
        }];
        [self pushController:vc from:kCATransitionFromTop];
    }
}

#pragma mark - UITableViewDelegate、UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groupDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[self.groupDatas valueForKey:self.allKeys[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LSMemberInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:memberInoCellId];
    LSMemberPackVo *vo = [self.groupDatas valueForKey:self.allKeys[indexPath.section]][indexPath.row];
    [cell fillMemberPackVo:vo];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [self getHeader:self.allKeys[section]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LSMemberPackVo *vo = [self.groupDatas valueForKey:self.allKeys[indexPath.section]][indexPath.row];
     NSString *mobile = [vo getMemberPhoneNum];
//    if (vo.customer && [ObjectUtil isEmpty:vo.cardNames]) {
//
//        // 去会员详情页需要先有会员卡，所以提示用户先给该会员发卡
//        [LSAlertHelper showAlert:@"提示" message:@"此会员还没有领本店会员卡，需要为会员发卡吗？" cancle:@"取消" block:nil ensure:@"发卡" block:^{
//            LSMemberElectronicCardSendViewController *vc = [[LSMemberElectronicCardSendViewController alloc] init:mobile member:vo];
//            [self pushController:vc from:kCATransitionFromRight];
//        }];
//        return ;
//    }
//    else {
        LSMemberDetailViewController *vc = [[LSMemberDetailViewController alloc] initWithPhoneNum:mobile];
        [self pushController:vc from:kCATransitionFromRight];
//    }
}

#pragma mark - 网络请求

// 查询指定的会员，根据手机号
- (void)queryMemberInfo:(NSString *)queryString {
    
    if ([NSString isNotBlank:queryString]) {

        [self swithSearchModel:YES];
        NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
        NSDictionary *param = @{@"entityId":entityId ,@"keyword":queryString ,@"isOnlySearchMobile":@(NO)};
        
        [BaseService getRemoteLSOutDataWithUrl:@"card/queryCustomerInfo" param:[param mutableCopy] withMessage:@"" show:YES CompletionHandler:^(id json) {
            if ([json[@"code"] boolValue]) {
                
                NSArray *customerList = json[@"data"][@"customerList"];
                if ([ObjectUtil isNotEmpty:customerList]) {
                    
                    NSArray *packVoList = [LSMemberPackVo getMemberPackVoList:customerList];
                    [self resultProcess:packVoList];
                }
                else {
                    [self.groupDatas removeAllObjects];
                    self.allKeys = nil;
                    [self.tableView reloadData];
//                    [LSAlertHelper showAlert:@"抱歉，没有查询到该会员信息！" block:nil];
                }
            }
        } errorHandler:^(id json) {
            [self.groupDatas removeAllObjects];
            self.allKeys = nil;
            [self.tableView reloadData];
            [LSAlertHelper showAlert:json block:nil];
        }];
    }
    else {
        [self swithSearchModel:NO];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:3];
        [param setValue:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
        [param setValue:@(self.currentPage) forKey:@"page"];
        [param setValue:@(10) forKey:@"pageSize"];
        
        [BaseService getRemoteLSOutDataWithUrl:@"card/queryCustomerList" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
            [self endRefresh];
            NSArray *customerList = json[@"data"][@"customerList"];
            if ([ObjectUtil isNotEmpty:customerList]) {
                NSArray *packVoList = [LSMemberPackVo getMemberPackVoList:customerList];
                [self resultProcess:packVoList];
            }
            else {
                // 查询所有未查到数据
                self.currentPage = MAX((--self.currentPage), 1);
            }

        } errorHandler:^(id json) {
            [self endRefresh];
            self.currentPage = MAX((--self.currentPage), 1);
            [self.groupDatas removeAllObjects];
            self.allKeys = nil;
            [self.tableView reloadData];
            [LSAlertHelper showAlert:json block:nil];
        }];
    }
}

// 切换查询模式，指定会员卡号或者手机号，不分页隐藏刷新；不指定查询信息默认查询所有，分页，显示刷新
- (void)swithSearchModel:(BOOL)hidden {
    
    [self.tableView setHeaderHidden:hidden];
    [self.tableView setFooterHidden:hidden];
    if (hidden) {
        self.currentPage = 1;
    }
}

#pragma mark - 数据处理
// 处理数据， 按会员的createTime 进行归类，分为不同的section显示分组
- (void)resultProcess:(NSArray<LSMemberPackVo *> *)list {
    
    if (!self.groupDatas) {
        self.groupDatas = [[NSMutableDictionary alloc] init];
    }
    
    if (self.currentPage == 1 && self.groupDatas.count) {
        [self.groupDatas removeAllObjects];
        self.allKeys = nil;
    }
    
    for (LSMemberPackVo *vo in list) {
        
        NSString *str1 = [vo.createTime substringWithRange:NSMakeRange(0, 4)];
        NSString *str2 = [vo.createTime substringWithRange:NSMakeRange(5, 2)];
        NSString *timeKey = [NSString stringWithFormat:@"%@年%@月",str1,str2];
        
        NSMutableArray *tempArr = self.groupDatas[timeKey];
        if (tempArr == nil) {
            tempArr = [[NSMutableArray alloc] init];
            [self.groupDatas setValue:tempArr forKey:timeKey];
        }
        
        [tempArr addObject:vo];
    }
    
    // 获取升序数组，然后逆序
    NSArray *tempArray = [self.groupDatas.allKeys sortedArrayUsingSelector:@selector(compare:)];
    self.allKeys = [[tempArray reverseObjectEnumerator] allObjects];
    [self.tableView reloadData];
    self.tableView.ls_show = YES;
}
@end
