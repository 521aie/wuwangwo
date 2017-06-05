//
//  LSMemberByTimeRechargeNotesListController.m
//  retailapp
//
//  Created by taihangju on 2017/3/30.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberByTimeRechargeNotesListController.h"
#import "LSByTimeRechargeRecordDetailController.h"
#import "NavigateTitle2.h"
//#import "LSFooterView.h"
#import "SMHeaderItem.h"
#import "LSByTimeRechargeRecordCell.h"
#import "LSByTimeRechargeRecordVo.h"
#import "DateUtils.h"

static NSString *tableCellReuseIdentifier = @"tableCellReuseIdentifier";
@interface LSMemberByTimeRechargeNotesListController ()<INavigateEvent, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NavigateTitle2 *titleBox;/**<>*/
@property (nonatomic, strong) UITableView *tableView;/**<>*/
@property (nonatomic, strong) NSNumber *lastTime;/**<分页标识>*/
@property (nonatomic, strong) NSMutableDictionary *datasDic;/**<按时间分组>*/
@property (nonatomic, strong) NSArray *sectionsArray;/**<sections：按yyyy-MM降序排列>*/
@property (nonatomic, strong) NSNumber *memberCardId;/**<会员卡id>*/
@end

@implementation LSMemberByTimeRechargeNotesListController

- (instancetype)initWithMemberCardId:(id)cardId {
    self = [super init];
    if (self) {
        _memberCardId = cardId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubviews];
    [self.tableView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSMutableDictionary *)datasDic {
    
    if (!_datasDic) {
        _datasDic = [[NSMutableDictionary alloc] init];
    }
    return _datasDic;
}

- (void)configSubviews {
    
    _titleBox = [NavigateTitle2 navigateTitle:self];
    [_titleBox initWithName:@"计次充值记录" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:_titleBox];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _titleBox.ls_bottom, SCREEN_W, SCREEN_H-_titleBox.ls_bottom) style:UITableViewStylePlain];
    [_tableView registerNib:[UINib nibWithNibName:@"LSByTimeRechargeRecordCell" bundle:nil] forCellReuseIdentifier:tableCellReuseIdentifier];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [ViewFactory generateFooter:88];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 88.0f;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.sectionHeaderHeight = 30.0f;
    
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    [weakSelf.tableView ls_addHeaderWithCallback:^{
        weakSelf.lastTime = nil;
        [weakSelf byTimeRechargeRecordList];
    }];
    
    [weakSelf.tableView ls_addFooterWithCallback:^{
        [weakSelf byTimeRechargeRecordList];
    }];
}

#pragma mark - delegate methods -

// INavigateEvent
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        [self popToLatestViewController:kCATransitionFromLeft];
    }
}


// UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
     return _sectionsArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[_datasDic valueForKey:_sectionsArray[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LSByTimeRechargeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellReuseIdentifier];
    NSArray *voGroupArray = [self.datasDic valueForKey:_sectionsArray[indexPath.section]];
    [cell fillMemberByTimeRechargeVo:voGroupArray[indexPath.row]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
    SMHeaderItem *header = [SMHeaderItem loadFromNib];
    header.lblVal.text = _sectionsArray[section];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *voGroupArray = [self.datasDic valueForKey:_sectionsArray[indexPath.section]];
    LSByTimeRechargeRecordVo *vo = voGroupArray[indexPath.row];
    LSByTimeRechargeRecordDetailController *vc = [[LSByTimeRechargeRecordDetailController alloc] initWith:vo.accountCardId memberCardId:_memberCardId];
    [self pushController:vc from:kCATransitionFromRight];
}


#pragma mark - 网络请求 -

// 计次充值记录列表
- (void)byTimeRechargeRecordList {
    
    // @{@"cardId":@"213213223",@"lastDateTime":@(231323)};
    NSDictionary *param = @{@"cardId":@"99928347592525410159252590500003"};
    NSString *url = @"accountcard/memberRachargeList";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        
        if (wself.lastTime == nil) {
            [wself.datasDic removeAllObjects];
             wself.sectionsArray = nil;
        }
        
        wself.lastTime = json[@"lastDateTime"];
        [wself dealResponseDataByTime:json[@"sortedTimeAccountFlowVos"]];
        
    } errorHandler:^(id json) {
        
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [LSAlertHelper showAlert:json];
    }];
}

// 根据计次充值记录的生成时间来整理分组
- (void)dealResponseDataByTime:(NSArray *)sortedTimeAccountFlowVos {
    
    if (sortedTimeAccountFlowVos.count > 0) {
        
        [sortedTimeAccountFlowVos enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        
            NSArray *voList = [LSByTimeRechargeRecordVo byTimeRechargeRecordVoList:[dic valueForKey:@"accountFlowList"]];
            NSArray *keyArray = [dic[@"sortedTime"] componentsSeparatedByString:@"-"];
            NSString *timeKey = [NSString stringWithFormat:@"%@年%@月", keyArray.firstObject,keyArray.lastObject];
            NSMutableArray *array = [self.datasDic valueForKey:timeKey];
            if (!array) {
                array = [[NSMutableArray alloc] init];
                [self.datasDic setObject:array forKey:timeKey];
            }
            [array addObjectsFromArray:voList];
            
        }];

        NSArray *allKeys = [[self.datasDic allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        self.sectionsArray = [[allKeys reverseObjectEnumerator] allObjects];
//        self.sectionsArray = [self.datasDic allKeys];
        [self.tableView reloadData];
    }
}

@end
