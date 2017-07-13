//
//  LSMemberListViewController.m
//  retailapp
//
//  Created by taihangju on 16/9/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberListViewController.h"
#import "LSMemberElectronicCardSendViewController.h"
#import "LSMemberListViewController.h"
#import "LSMemberChangeCardViewController.h"
#import "LSMemberChangePwdViewController.h"
#import "LSMemberRescindCardViewController.h"
#import "LSMemberCardLossHandViewController.h"
#import "LSMemberRechargeViewController.h"
#import "LSMemberIntegralExchangeViewController.h"
#import "LSMemberBestowIntegralViewController.h"
#import "LSMemberDetailViewController.h"

#import "NavigateTitle2.h"
#import "LSExpandItem.h"
#import "LSMemberInfoCell.h"
#import "LSMemberConst.h"
#import "LSMemberInfoVo.h"
#import "LSMemberNewAddedVo.h"
#import "LSAlertHelper.h"

static NSString *memberInoCellId = @"LSMemberInfoCell";
@interface LSMemberListViewController ()<INavigateEvent ,UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic ,strong) NavigateTitle2 *titleBox;/*<>*/
@property (nonatomic ,strong) UITableView *tableView;/*<<#说明#>>*/
@property (nonatomic ,strong) NSMutableArray *datas;/*<数据源>*/
@property (nonatomic ,assign) MemberSubModuleType type;/*<子模块类型>*/
@property (nonatomic ,assign) NSInteger page;/*<当前页>*/
@property (nonatomic ,strong) NSString *checkDate;/*<具体日期>*/
@end

@implementation LSMemberListViewController

- (instancetype)init:(NSInteger)type packVos:(NSArray *)array {
    
    self = [super init];
    if (self) {
        self.datas = [array mutableCopy];
        self.type = type;
    }
    return self;
}

- (instancetype)initWithCheckDate:(NSString *)checkDate {
    self = [super init];
    if (self) {
        self.datas = [[NSMutableArray alloc] init];
        self.checkDate = checkDate;
        self.type = MBSubModule_SummaryInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubviews];
    if (self.type == MBSubModule_SummaryInfo) {
        [self.tableView headerBeginRefreshing];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)configSubviews {
    
    CGFloat topY = 0.0;
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, topY, SCREEN_W, 64.0);
    if (self.type == MBSubModule_SummaryInfo) {
        [self.titleBox initWithName:@"会员信息汇总" backImg:Head_ICON_BACK moreImg:nil];
    }
    else {
        [self.titleBox initWithName:@"选择会员" backImg:Head_ICON_BACK moreImg:nil];
    }
    [self.view addSubview:self.titleBox];
    topY = 64.0f;
    
    if (self.type == MBSubModule_SummaryInfo) {
        LSExpandItem *expandItem = [LSExpandItem expandItem:self selector:@selector(back)];
        expandItem.arrowImageView.image = [UIImage imageNamed:@"ico_next_up_w"];
        expandItem.rightLabel.text = @"收起";
        [self.view addSubview:expandItem];
        expandItem.ls_top = topY+5.0;
        topY = expandItem.ls_bottom;
    }
    
    // TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topY+5.0, SCREEN_W, SCREEN_H-topY-5.0) style:UITableViewStylePlain];
    [self.tableView registerClass:[LSMemberInfoCell class] forCellReuseIdentifier:memberInoCellId];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorColor = [ColorHelper getTipColor3];
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.rowHeight = 88.0;
    self.tableView.sectionHeaderHeight = 30.0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    if (self.type == MBSubModule_SummaryInfo) {
        
        __weak typeof(self) weakSelf = self;
        [self.tableView ls_addHeaderWithCallback:^{
            weakSelf.page = 1;
            [weakSelf getMemberListByDay];
        }];
        
        [self.tableView ls_addFooterWithCallback:^{
            weakSelf.page ++ ;
            [weakSelf getMemberListByDay];
        }];
    }
}

#pragma mark - delegate

- (void)back {
    [self onNavigateEvent:DIRECT_LEFT];
}

// INavigateEvent 导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        if (self.type == MBSubModule_SummaryInfo) {
            [self popToLatestViewController:kCATransitionFromBottom];
        }
        else {
            [self popToLatestViewController:kCATransitionFromLeft];
        }
    }
}


#pragma mark - UITableViewDelegate、UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LSMemberInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:memberInoCellId];
    if (self.type == MBSubModule_SummaryInfo) {
        [cell fillMemberNewAddedVo:self.datas[indexPath.row]];
    }
    else {
        [cell fillMemberPackVo:self.datas[indexPath.row]];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.type == MBSubModule_SummaryInfo) {
        LSMemberNewAddedVo *vo = self.datas[indexPath.row];
        [self queryMemberInfo:vo];
    }
    else {
        LSMemberPackVo *memberPackVo = self.datas[indexPath.row];
        // 存在该会员但未领卡时，弹出提示框(适用于：会员换卡、会员充值、积分兑换、挂失与解挂、会员退卡、改卡密码)
        if (memberPackVo.customer && [ObjectUtil isEmpty:memberPackVo.cardNames]) {
            
            //只要不是去发卡，其他模块操作前提都需要有会员卡，所以提示用户先给该会员发卡
            if (self.type != MBSubModule_SendCard) {
                [LSAlertHelper showAlert:@"提示" message:@"此会员还没有领本店会员卡，需要为会员发卡吗？" cancle:@"取消" block:nil ensure:@"发卡" block:^{
                    [self toSendCardPage:memberPackVo];
                }];
            }
            return ;
        }
        else {
            
            if (self.type == MBSubModule_ChangeCard) {
                
                [self toChangeCardPage:memberPackVo];
            }
            else if (self.type == MBSubModule_ChangePwd) {
                [self toChangePwdPage:memberPackVo];
            }
            else if (self.type == MBSubModule_ReturnCard) {
                [self toRescindCardPage:memberPackVo];
            }
            else if (self.type == MBSubModule_CardReport) {
                [self toLossCardPage:memberPackVo];
            }
            else if (self.type == MBSubModule_Recharge) {
                [self toMemberRechargePage:memberPackVo];
            }
            else if (self.type == MBSubModule_Integral) {
                [self toMemberIntegralExchangePage:memberPackVo];
            }
            else if (self.type == MBSubModule_BestowIntegral) {
                [self toMemberBestowIntegralPage:memberPackVo];
            }
            else if (self.type == MBSubModule_HomePage) {
                [self toMemberDetailPage:memberPackVo];
            }
        }
    }
}

#pragma mark - network

- (void)endRefresh {
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
}

// 按天查看会员列表
- (void)getMemberListByDay {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:2];
    [param setValue:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
    [param setValue:self.checkDate forKey:@"customKey"];
    [param setValue:@(self.page) forKey:@"pageIndex"];
    [param setValue:@(20) forKey:@"pageSize"];
    [BaseService crossDomanRequestWithUrl:@"memberstat/v1/getMemberInfo" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        NSArray *datas = json[@"data"];
        NSArray *array = [LSMemberNewAddedVo memberNewAddedVoList:datas];
        if (self.page == 1) {
            [self.datas removeAllObjects];
        }
        [self.datas addObjectsFromArray:array];
        
        if ([ObjectUtil isEmpty:datas]) {
            self.page -= 1;
        }
        
        [self endRefresh];
        [self.tableView reloadData];

    } errorHandler:^(id json) {
        [self endRefresh];
        [LSAlertHelper showAlert:json block:nil];
    }];
}


// 查询会员基本信息，判断该会员是否被删除
- (void)queryMemberInfo:(LSMemberNewAddedVo *)vo{
    
    __weak typeof(self) wself = self;
    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    NSString *phoneNo = [NSString isNotBlank:vo.mobile]?vo.mobile:@"";
    NSDictionary *param = @{@"entityId":entityId ,@"keyword":phoneNo ,@"isOnlySearchMobile":@(YES)};
    
    [BaseService getRemoteLSOutDataWithUrl:@"card/v2/queryCustomerInfoByMobileOrCode" param:[param mutableCopy] withMessage:@"" show:YES CompletionHandler:^(id json) {
        NSArray *array = [LSMemberPackVo getMemberPackVoList:json[@"data"][@"customerList"]];
        if ([ObjectUtil isNotEmpty:array]) {
            
            if (array.count == 1) {
                [wself toMemberDetailPage:array.firstObject];
            } else {
                [array enumerateObjectsUsingBlock:^(LSMemberPackVo*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([vo.customerId isEqualToString:obj.customerId]) {
                        *stop = YES;
                        [wself toMemberDetailPage:obj];
                    }
                }];
            }
            
            
        } else {
            [LSAlertHelper showAlert:@"该会员已被删除！"];
        }
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}

#pragma mark - 页面跳转
// 跳转到会员发卡页面
- (void)toSendCardPage:(LSMemberPackVo *)vo {
    
    LSMemberElectronicCardSendViewController *vc = [[LSMemberElectronicCardSendViewController alloc] init:[vo getMemberPhoneNum] member:vo fromPage:NO];
    [self pushController:vc from:kCATransitionFromRight];
}

// 跳转到会员换卡页面
- (void)toChangeCardPage:(LSMemberPackVo *)vo {
    
    LSMemberChangeCardViewController *vc = [[LSMemberChangeCardViewController alloc] init:[vo getMemberPhoneNum] member:vo selectCard:nil];
    [self pushController:vc from:kCATransitionFromRight];
}

// 跳转到会员卡更改密码页面
- (void)toChangePwdPage:(LSMemberPackVo *)vo {
    
    LSMemberChangePwdViewController *vc = [[LSMemberChangePwdViewController alloc] init:vo cardId:nil];
    [self pushController:vc from:kCATransitionFromRight];
}

// 跳转到会员卡退卡界面
- (void)toRescindCardPage:(LSMemberPackVo *)vo {
    
    LSMemberRescindCardViewController *vc = [[LSMemberRescindCardViewController alloc] init:vo cardId:nil];
    [self pushController:vc from:kCATransitionFromRight];
}

// 跳转到卡挂失解挂界面
- (void)toLossCardPage:(LSMemberPackVo *)vo {
    
    LSMemberCardLossHandViewController *vc = [[LSMemberCardLossHandViewController alloc] init:vo];
    [self pushController:vc from:kCATransitionFromRight];
}

// 跳转到会员充值界面
- (void)toMemberRechargePage:(LSMemberPackVo *)vo {
    
    LSMemberRechargeViewController *vc = [[LSMemberRechargeViewController alloc] init:vo phone:@"" selectCard:nil];
    [self pushController:vc from:kCATransitionFromRight];
}

// 跳转到积分兑换界面
- (void)toMemberIntegralExchangePage:(LSMemberPackVo *)vo {
    
    LSMemberIntegralExchangeViewController *vc = [[LSMemberIntegralExchangeViewController alloc] init:vo cardId:nil];
    [self pushController:vc from:kCATransitionFromRight];
}

// 跳转到会员赠分界面
- (void)toMemberBestowIntegralPage:(LSMemberPackVo *)vo {
    LSMemberBestowIntegralViewController *vc = [[LSMemberBestowIntegralViewController alloc] init:vo cardId:nil];
    [self pushController:vc from:kCATransitionFromRight];
}

// 跳转到会员详情页面
- (void)toMemberDetailPage:(LSMemberPackVo *)vo {
    LSMemberDetailViewController *vc = [[LSMemberDetailViewController alloc] initWithMemberVo:vo];
    [self pushController:vc from:kCATransitionFromRight];
}

@end
