//
//  LSMemberSaveDetailViewController.m
//  retailapp
//
//  Created by taihangju on 16/10/7.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberSaveDetailViewController.h"
#import "NavigateTitle2.h"
#import "SMHeaderItem.h"
#import "LSRightSelectPanel.h"
#import "LSMemberSaveDetailCell.h"
#import "LSMemberCardVo.h"
#import "LSAlertHelper.h"
#import "LSMemberDetaileVo.h"
#import "LSMemberConst.h"

static NSString *saveDetailCellId = @"LSMemberSaveDetailCell";
static NSString *saveDetailCellId1 = @"LSMemberSaveDetailCell1";
@interface LSMemberSaveDetailViewController ()<INavigateEvent ,UITableViewDelegate ,UITableViewDataSource ,LSRightSelectPanelDelegate>

@property (nonatomic ,strong) NavigateTitle2 *titleBox;/*<>*/
@property (nonatomic ,strong) UITableView *tableView;/*<>*/
@property (nonatomic ,strong) LSRightSelectPanel *rightPanel;/*<右侧选择view>*/
@property (nonatomic ,assign) MBDetailType type;/*<积分明细/储值明细>*/
@property (nonatomic ,strong) NSArray *cardList;/*<会员卡列表>*/
@property (nonatomic ,strong) NSArray *cardTypeItemList;/*<会员卡对应的INameItem>*/
@property (nonatomic ,strong) LSMemberCardVo *currentCard;/*<当前查询的card>*/
@property (nonatomic ,assign) NSInteger page;/*<当前页>*/
@property (nonatomic ,strong) NSMutableArray *dataSource;/*<数据源>*/
@end

@implementation LSMemberSaveDetailViewController

- (instancetype)init:(MBDetailType)type cards:(NSArray *)cardVoList selectCard:(id)cardVo {
    
    self = [super init];
    if (self) {
        self.type = type;
        self.cardList = cardVoList;
        if (!cardVo) {
            self.currentCard = cardVoList.firstObject;
        }
        else {
            self.currentCard = (LSMemberCardVo *)cardVo;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    [self configSubViews];
//    [self.tableView headerBeginRefreshing]; 
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray *)cardTypeItemList {
    
    if (!_cardTypeItemList) {
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.cardList.count];
        [self.cardList enumerateObjectsUsingBlock:^(LSMemberCardVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NameItemVO *item = [[NameItemVO alloc] initWithVal:obj.kindCardName andId:obj.sId andSortCode:idx];
            [array addObject:item];
        }];
        _cardTypeItemList = [array copy];
    }
    return _cardTypeItemList;
}

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


- (void)configSubViews {
    
    // TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.0, SCREEN_W, SCREEN_H-64.0) style:UITableViewStylePlain];
    [self.tableView registerClass:[LSMemberSaveDetailCell class] forCellReuseIdentifier:saveDetailCellId];
    [self.tableView registerClass:[LSMemberSaveDetailCell class] forCellReuseIdentifier:saveDetailCellId1];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorColor = [ColorHelper getTipColor3];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 88.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.sectionHeaderHeight = 30.0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    [weakSelf.tableView ls_addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf getDetailList];
    }];
    
    [weakSelf.tableView ls_addFooterWithCallback:^{
        [weakSelf getDetailList];
    }];
    
    if (self.cardList.count > 1) {
        self.rightPanel = [LSRightSelectPanel rightSelectPanel:@"卡类型" delegate:self];
        [self.rightPanel loadDataList:self.cardTypeItemList];
        [self.rightPanel addToView:self.view];
    }
}

#pragma mark - NavigateTitle2 代理

- (void)initNavigate {
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
    if (self.type == MBDetailSavingType) {
        [self.titleBox initWithName:@"储值明细" backImg:Head_ICON_BACK moreImg:nil];
    }
    else if (self.type == MBDetailIntegralType) {
        [self.titleBox initWithName:@"积分明细" backImg:Head_ICON_BACK moreImg:nil];
    }
    [self.view addSubview:self.titleBox];
}

//导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        [self popToLatestViewController:kCATransitionFromLeft];
    }
}

//LSRightSelectPanelDelegate
- (void)rightSelectPanel:(LSRightSelectPanel *)panel select:(id<INameItem>)obj {
    
    NameItemVO *item = (NameItemVO *)obj;
    self.currentCard = [self.cardList objectAtIndex:item.itemSortCode];
    if (self.currentCard) {
        [self.tableView headerBeginRefreshing];
    }
}

#pragma mark - UITableView

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    LSMemberSaveDetailCell *cell = nil;
    if (self.type == MBDetailSavingType) {
        cell = [tableView dequeueReusableCellWithIdentifier:saveDetailCellId];
    }else
        cell = [tableView dequeueReusableCellWithIdentifier:saveDetailCellId1];
    cell.callBack = ^{
        
        LSMemberDetaileVo *vo = [weakSelf.dataSource objectAtIndex:indexPath.row];
        if (weakSelf.type == MBDetailSavingType) {
           
            if ([weakSelf.currentCard isLost]) {
                [LSAlertHelper showAlert:@"当前会员卡已挂失，不支持充值红冲！" block:nil];
                return ;
            }
            if ([((LSMemberMoneyFlowVo *)vo).payMode intValue] == 6 || [((LSMemberMoneyFlowVo *)vo).payMode intValue] == 7) {
                [LSAlertHelper showAlert:@"提示" message:@"用[微信]、[支付宝]充值的金额在红冲后无法以原支付方式退回给顾客,需要商家线下自行协商退款事宜。确定进行红冲吗？" cancle:@"取消" block:nil ensure:@"确认" block:^{
                    [weakSelf cancelMemberCharge:vo.sId];
                }];
            }else{
                [LSAlertHelper showAlert:@"提示" message:SaveDetailNoticeString cancle:@"取消" block:nil ensure:@"确认" block:^{
                    [weakSelf cancelMemberCharge:vo.sId];
                }];
            }
        }
        else if (weakSelf.type == MBDetailIntegralType) {
            
            if ([weakSelf.currentCard isLost]) {
                [LSAlertHelper showAlert:@"当前会员卡已挂失，不支持赠分红冲！" block:nil];
                return ;
            }
            [LSAlertHelper showAlert:@"提示" message:SaveDetailNoticeString cancle:@"取消" block:nil ensure:@"确认" block:^{
                [weakSelf changeMemberDegree:vo.sId];
            }];
        }
    };
    
    if (self.type == MBDetailSavingType) {
        [cell fillSaveDetailData:self.dataSource[indexPath.row]];
    }
    else if (self.type == MBDetailIntegralType) {
        [cell fillIntegralDetailData:self.dataSource[indexPath.row]];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
//    NSString *string = self.type == MBDetailIntegralType ? [NSString stringWithFormat:@"%@积分明细", self.currentCard.kindCardName] :[NSString stringWithFormat:@"%@储值明细", self.currentCard.kindCardName] ;
    return [self getHeader:self.currentCard.kindCardName];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - 网络请求

// 获取明细列表
- (void)getDetailList {
    
    if (self.type == MBDetailIntegralType) {
        // 请求积分明细
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:self.currentCard.sId forKey:@"card_id"];
        [param setValue:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
        [param setValue:@(self.page) forKey:@"page"];
        [param setValue:@(10) forKey:@"page_size"];
        
        [BaseService getRemoteLSOutDataWithUrl:@"card/v1/get_degree_flow" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
            if ([json[@"code"] boolValue]) {
                if (self.dataSource.count > 0 && self.page == 1) {
                    [self.dataSource removeAllObjects];
                }
                NSArray *records = [json[@"data"] valueForKey:@"records"];
                if ([ObjectUtil isNotEmpty:records]) {
                    NSArray *array = [LSMemberDegreeFlowVo getDegreeFlowVoVoList:records];
                    [self.dataSource addObjectsFromArray:array];
                    self.page += 1;
                }
            }
            [self endRefresh];
            [self.tableView reloadData];
        } errorHandler:^(id json) {
            [LSAlertHelper showAlert:json block:nil];
            [self endRefresh];
        }];
    }
    else if (self.type == MBDetailSavingType) {
        // 请求储值明
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:self.currentCard.sId forKey:@"cardId"];
        [param setValue:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
        [param setValue:[[Platform Instance] getkey:USER_ID] forKey:@"operatorId"];
        [param setValue:@(self.page).stringValue forKey:@"page"];
        [param setValue:@(10).stringValue forKey:@"pageSize"];
        
        [BaseService getRemoteLSDataWithUrl:@"customer/getMoneyFlow" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
            if ([json[@"returnCode"] isEqualToString:@"success"]) {
                if (self.dataSource.count > 0 && self.page == 1) {
                    [self.dataSource removeAllObjects];
                }
                NSArray *records = json[@"list"];
                if ([ObjectUtil isNotEmpty:records]) {
                    NSArray *array = [LSMemberMoneyFlowVo getMoneyFlowVoList:records];
                    [self.dataSource addObjectsFromArray:array];
                    self.page += 1;
                }
            }
            [self endRefresh];
            [self.tableView reloadData];
        } errorHandler:^(id json) {
            [LSAlertHelper showAlert:json block:nil];
            [self endRefresh];
        }];
    }
}

// 会员充值金额-红冲
//url : http://ip:port/retail-api/card/cancelChargeCard
- (void)cancelMemberCharge:(NSString *)moneyFlowId {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:moneyFlowId forKey:@"moneyFlowId"];
    [param setValue:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
    [param setValue:[[Platform Instance] getkey:USER_ID] forKey:@"operatorId"];
    [param setValue:[[Platform Instance] getkey:EMPLOYEE_NAME] forKey:@"operatorName"];
    // shop 实体店id
    [param setValue:[[Platform Instance] getkey:RELEVANCE_ENTITY_ID] forKey:@"shopEntityId"];
    
    [BaseService getRemoteLSOutDataWithUrl:@"card/cancelChargeCard"  param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([json[@"code"] boolValue]) {
            self.page = 1;
            [self getDetailList];
        }

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}


//  会员赠送积分-红冲
//url : http://ip:port/retail-api/card/degreeChange
- (void)changeMemberDegree:(NSString *)degreeFlowId {
   
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:degreeFlowId forKey:@"degreeFlowId"];
    [param setValue:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
    [param setValue:[[Platform Instance] getkey:USER_ID] forKey:@"operatorId"];
    [param setValue:[[Platform Instance] getkey:RELEVANCE_ENTITY_ID] forKey:@"shopEntityId"];
    [param setValue:[[Platform Instance] getkey:EMPLOYEE_NAME] forKey:@"operatorName"];
    
    [BaseService getRemoteLSOutDataWithUrl:@"card/v2/degree_change" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([json[@"code"] boolValue]) {
            self.page = 1;
            [self getDetailList];
        }
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}

@end
