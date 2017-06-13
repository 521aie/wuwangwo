//
//  LSMemberMeterCardListController.m
//  retailapp
//
//  Created by wuwangwo on 2017/4/1.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberMeterCardListController.h"
#import "LSMemberMeterCardDetailController.h"
#import "LSMemberMeterCardListCell.h"
#import "LSMemberMeterCardListVo.h"
#import "SMHeaderItem.h"
#import "DHHeadItem.h"
#import "HeaderItem.h"
#import "LSFooterView.h"
#import "ExportView.h"
#import "DateUtils.h"
#import "MobClick.h"

@interface LSMemberMeterCardListController ()<UITableViewDataSource,UITableViewDelegate, LSFooterViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LSFooterView *footView;
/**<按时间分组>*/
@property (nonatomic, strong) NSMutableDictionary *datasDic;
/**<sections：按yyyy-MM降序排列>*/
@property (nonatomic, strong) NSArray *sectionsArray;
@property (nonatomic, strong) NSNumber *lastDateTime;
/**<分页标识>*/
@property (nonatomic, assign) NSInteger lastTime;
@end

@implementation LSMemberMeterCardListController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.lastTime = 1;
    [self configViews];
    [self configConstraints];
    [self loadData];
}

- (NSMutableDictionary *)datasDic {
    
    if (!_datasDic) {
        _datasDic = [[NSMutableDictionary alloc] init];
    }
    return _datasDic;
}

- (void)configViews {
    
    self.view.backgroundColor = [UIColor clearColor];
    [self configTitle:@"计次充值记录" leftPath:Head_ICON_BACK rightPath:nil];

    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 44.0;
    [self.view addSubview:self.tableView];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight= 86.0f;
    
    __weak typeof(self) wself = self;
    [self.tableView ls_addHeaderWithCallback:^{
        
        wself.lastTime = 1;
        wself.lastDateTime = nil;
        [wself loadData];
    }];
    
    [self.tableView ls_addFooterWithCallback:^{
        
        wself.lastTime += 1;
        [wself loadData];
    }];
    
    self.tableView.tableFooterView = [ViewFactory generateFooter:HEIGHT_CONTENT_BOTTOM];
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootExport]];
    [self.view addSubview:self.footView];
}

- (void)configConstraints {
    
    __weak typeof(self) wself = self;
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.top.equalTo(wself.view).offset(64);
    }];
    
    [self.footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.height.equalTo(60);
    }];
}

#pragma mark - 导航栏点击事件
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)direct {
    
    if (direct == LSNavigationBarButtonDirectLeft) {
        
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self popViewController];
    }
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    
    if ([footerType isEqualToString:kFootExport]) {
        
        [self showExportEvent];
    }
}

#pragma mark - 点击导出事件
- (void)showExportEvent {
    
    [MobClick event:@"Report_ByTimeRechargeRecords_Export"];
    
    ExportView *vc = [[ExportView alloc] init];
    [self pushViewController:vc]; 
    
    [vc loadData:self.exportParam withPath:@"accountcard/export" withIsPush:YES callBack:^{
        
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self popViewController];
    }];
    
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

#pragma mark - 加载数据
- (void)loadData {
    
    __weak typeof(self) wself = self;
    [_param setValue:self.lastDateTime forKey:@"lastDateTime"];
    NSString *url = @"accountcard/shopRachargeList";
    
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:@"" show:YES CompletionHandler:^(id json) {
        
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        
        if ([ObjectUtil isNotNull:[json valueForKey:@"lastDateTime"]]) {
            self.lastDateTime = [json valueForKey:@"lastDateTime"];
        }
        
        if (wself.lastTime == 1) {

            [wself.datasDic removeAllObjects];
            wself.sectionsArray = nil;
        }
        
        wself.lastDateTime = json[@"lastDateTime"];
        NSArray *map = json[@"sortedTimeAccountFlowVos"];
        
        [wself dealResponseDataByTime:map];
        
        [wself.tableView reloadData];
        wself.tableView.ls_show = YES;
        
    } errorHandler:^(id json) {
        
        wself.lastTime = MAX(1, --wself.lastTime);
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [LSAlertHelper showAlert:json];
    }];
}

// 根据计次充值记录的生成时间来整理分组
- (void)dealResponseDataByTime:(NSArray *)sortedTimeAccountFlowVos {
    
    if (sortedTimeAccountFlowVos.count > 0) {
        
        [sortedTimeAccountFlowVos enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSArray *voList = [LSMemberMeterCardListVo byTimeRechargeRecordVoList:[dic valueForKey:@"accountFlowList"]];
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
        
        [self.tableView reloadData];
    }
}

#pragma mark - UItableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[_datasDic valueForKey:_sectionsArray[section]] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    SMHeaderItem *header = [SMHeaderItem loadFromNib];
    header.lblVal.text = _sectionsArray[section];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *operateListVos = [self.datasDic valueForKey:_sectionsArray[indexPath.section]];
    
    LSMemberMeterCardListCell *cell = [LSMemberMeterCardListCell memberMeterCardListCellWithTableView:tableView];
    LSMemberMeterCardListVo *vo = operateListVos[indexPath.row];
    [cell setObj:vo];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    LSMemberMeterCardDetailController *vc = [[LSMemberMeterCardDetailController alloc] init];
    
    NSArray *listVos = [self.datasDic valueForKey:_sectionsArray[indexPath.section]];
    LSMemberMeterCardListVo *list = listVos[indexPath.row];
    [param setValue:list.id forKey:@"id"];
    vc.param = param;
    
    [self pushViewController:vc];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

@end
