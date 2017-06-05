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
#import "DHHeadItem.h"
#import "HeaderItem.h"
#import "LSFooterView.h"
#import "ExportView.h"
#import "DateUtils.h"
#import "MobClick.h"

@interface LSMemberMeterCardListController ()<UITableViewDataSource,UITableViewDelegate, LSFooterViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LSFooterView *footView;
/**数据源*/
@property (nonatomic, strong) NSMutableDictionary *dict;
/**记录日期数*/
@property (nonatomic, strong) NSMutableArray *dates;
@property (nonatomic, strong) NSNumber *lastDateTime;
@end

@implementation LSMemberMeterCardListController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configViews];
    [self configConstraints];
    [self loadData];
}

- (void)configViews {
    
    self.view.backgroundColor = [UIColor clearColor];
    [self configTitle:@"计次充值记录" leftPath:Head_ICON_BACK rightPath:nil];
    
    self.dict = [[NSMutableDictionary alloc] init];
    self.dates = [[NSMutableArray alloc] init];

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
        
        wself.lastDateTime = nil;
        [wself loadData];
    }];
    
    [self.tableView ls_addFooterWithCallback:^{
        
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

- (NSMutableDictionary *)param {
    
    [_param removeObjectForKey:@"lastDateTime"];
    
    if ([ObjectUtil isNotNull:self.lastDateTime]) {
        
        [_param setValue:self.lastDateTime forKey:@"lastDateTime"];
    }
    
    return _param;
}

#pragma mark - 加载数据
- (void)loadData {
    
    NSString *url = @"accountcard/shopRachargeList";
    __weak typeof(self) wself = self;
    
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:@"" show:YES CompletionHandler:^(id json) {
        
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        
        if (wself.lastDateTime == nil) {
            
            [wself.dict removeAllObjects];
            [wself.dates removeAllObjects];
        }
        
        wself.lastDateTime = json[@"lastDateTime"];
        
        NSArray *map = json[@"sortedTimeAccountFlowVos"];
        
        if ([ObjectUtil isNotEmpty:map]) {
            
            for (NSDictionary *obj in map) {
                
                NSMutableArray *arr = [obj objectForKey:@"accountFlowList"];
                NSString *time = [obj objectForKey:@"sortedTime"];
                
                NSMutableArray *tempArray = [NSMutableArray array];
                for (NSDictionary *list in arr) {
                    
                    LSMemberMeterCardListVo *meterCardListVo = [[LSMemberMeterCardListVo alloc] initWithDictionary:list];
                    [tempArray addObject:meterCardListVo];
                }
                
                [wself.dict setValue:tempArray forKey:time];
                [self.dates addObject:time];
                
            }
        }
        
        [wself.tableView reloadData];
        wself.tableView.ls_show = YES;
        
    } errorHandler:^(id json) {
        
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [LSAlertHelper showAlert:json];
    }];
}

#pragma mark - UItableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dates.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arr = [self.dict objectForKey:self.dates[section]];
    return arr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    HeaderItem* headItem = [HeaderItem headerItem];
    NSString *time = self.dates[section];
    NSString *strTemp = [time stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
    NSMutableString* strTime=[[NSMutableString alloc]initWithString:strTemp];
    [strTime insertString:@"月"atIndex:7];
    [headItem initWithName:strTime];
    
    return headItem;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *operateListVos = [self.dict objectForKey:self.dates[indexPath.section]];
    
    LSMemberMeterCardListCell *cell = [LSMemberMeterCardListCell memberMeterCardListCellWithTableView:tableView];
    LSMemberMeterCardListVo *vo = operateListVos[indexPath.row];
    [cell setObj:vo];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    LSMemberMeterCardDetailController *vc = [[LSMemberMeterCardDetailController alloc] init];
    NSArray *listVos = [self.dict objectForKey:self.dates[indexPath.section]];
    LSMemberMeterCardListVo *list = listVos[indexPath.row];
    [param setValue:list.id forKey:@"id"];
    vc.param = param;
    
    [self pushViewController:vc];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

@end
