//
//  LSMemberRechargeReportListController.m
//  retailapp
//
//  Created by guozhi on 2017/1/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define CELL_HEIGHT 88.0
#define HEADER_HEIGHT 40
#import "LSMemberRechargeReportListController.h"
#import "FooterListEvent.h"
#import "XHAnimalUtil.h"
#import "MemberListCell.h"
#import "HeaderItem.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "SVProgressHUD.h"
#import "DateUtils.h"
#import "LSMemberRechargeDetailReportController.h"
#import "SystemUtil.h"
#import "ExportView.h"
#import "MemberRechargeListVo.h"
#import "LSFooterView.h"
@interface LSMemberRechargeReportListController ()<UITableViewDataSource,UITableViewDelegate,LSFooterViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
/**分页标志*/
@property (nonatomic, assign) NSInteger pageNum;
/**查询会员充值记录总数*/
//@property (nonatomic, strong) NSMutableArray *memberRechargeListVos;
/**查询会员充值记录日期数*/
@property (nonatomic, strong) NSMutableArray *dates;
/**查询会员充值记录列表数据源*/
@property (nonatomic, strong) NSMutableDictionary *dict;
/**获得会员充植记录日期*/
//@property (nonatomic, strong) NSMutableDictionary *dateDict;
@property (strong, nonatomic) LSFooterView *footView;
@end

@implementation LSMemberRechargeReportListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNum = 1;
    [self configViews];
    [self configConstraints];
    [self loadData];
}

- (void)configViews {
    self.view.backgroundColor = [UIColor clearColor];
    [self configTitle:@"储值充值记录" leftPath:Head_ICON_BACK rightPath:nil];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    __weak typeof(self) wself = self;
    self.tableView.tableFooterView = [ViewFactory generateFooter:HEIGHT_CONTENT_BOTTOM];
    [self.tableView registerNib:[UINib nibWithNibName:@"MemberListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView ls_addHeaderWithCallback:^{
        wself.pageNum = 1;
        wself.startNum = nil;
        wself.isFromSolr = nil;
        [wself loadData];
    }];
    [self.tableView ls_addFooterWithCallback:^{
        wself.pageNum += 1;
        [wself loadData];
    }];

    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootExport]];
    [self.view addSubview:self.footView];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.top.equalTo(wself.view.top).offset(kNavH);
    }];
    
    [self.footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.height.equalTo(60);
    }];
}


- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootExport]) {
        [self showExportEvent];
    }
}


#pragma mark - 点击导出事件
- (void)showExportEvent {
    ExportView *vc = [[ExportView alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    [vc loadData:self.exportParam withPath:@"RechargeRecord/export" withIsPush:YES callBack:^{
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    }];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    
}


#pragma mark - 查询会员充值所需要的参数
- (NSMutableDictionary *)param {
    
    [_param setValue:@(_pageNum) forKey:@"pageNum"];
    [_param setValue:self.startNum forKey:@"startNum"];
    [_param setValue:self.isFromSolr forKey:@"isFromSolr"];

    
    return _param;
}


#pragma mark - 加载数据
- (void)loadData {
    NSString *url = @"RechargeRecord/selectRechargeRecordList";
    __weak typeof(self) strongSelf = self;
   [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [strongSelf.tableView headerEndRefreshing];
        [strongSelf.tableView footerEndRefreshing];
       strongSelf.startNum = json[@"startNum"];
       strongSelf.isFromSolr = json[@"isFromSolr"];
        
        if (strongSelf.pageNum == 1) {
            strongSelf.dates = nil;
            [strongSelf.dict removeAllObjects];
        }
        NSArray *map = json[@"selectRechargeRecordVoList"];
        if (!(map == nil || [map isEqual:[NSNull null]] || [map count]) == 0) {
            
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in map) {
                MemberRechargeListVo *memberRechargeListVo = [[MemberRechargeListVo alloc] initWithDictionary:dict];
                [tempArray addObject:memberRechargeListVo];
            }
            
            if (!strongSelf.dict) {
                strongSelf.dict = [[NSMutableDictionary alloc] init];
            }
            
            if (!strongSelf.dates) {
                strongSelf.dates = [NSMutableArray arrayWithCapacity:4];
            }
            
            for (MemberRechargeListVo *memberRechargeListVo in tempArray) {
                NSString *time = [DateUtils getTimeStringFromCreaateTime:memberRechargeListVo.moneyFlowCreatetime.stringValue format:@"yyyy年MM月"];
                NSMutableArray *arr1 = [strongSelf.dict objectForKey:time];
                if (!arr1) {
                    arr1 = [[NSMutableArray alloc] init];
                    [strongSelf.dict setValue:arr1 forKey:time];
                    [strongSelf.dates addObject:time];
                }
                [arr1 addObject:memberRechargeListVo];
            }
        }
        else {
            strongSelf.pageNum = MAX(1, --strongSelf.pageNum);
        }
        [strongSelf.tableView reloadData];
        strongSelf.tableView.ls_show = YES;
        
    } errorHandler:^(id json) {
        [strongSelf.tableView headerEndRefreshing];
        [strongSelf.tableView footerEndRefreshing];
        strongSelf.pageNum = MAX(1, --strongSelf.pageNum);
        [AlertBox show:json];
    }];
    
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dates.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = [self.dict objectForKey:self.dates[section]];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSArray *memberRechargeVos = [self.dict objectForKey:self.dates[indexPath.section]];
    [cell initDataWithMemberRechargeListVo:memberRechargeVos[indexPath.row]];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderItem *headItem = [HeaderItem headerItem];
    [headItem initWithName:self.dates[section]];
    return headItem;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    return CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HEADER_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberRechargeListVo *memberRechargeListVo = [self.dict objectForKey:self.dates[indexPath.section]][indexPath.row];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:memberRechargeListVo.orderId forKey:@"rechargeId"];
    [param setValue:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
    LSMemberRechargeDetailReportController *vc = [[LSMemberRechargeDetailReportController alloc] init];
    vc.param = param;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    
}

// 后台已经做好了排序
//#pragma mark - 日期排序
//- (NSArray *)sortArray:(NSArray *)arr {
//
//    if (arr && arr.count > 0) {
//        NSArray *sortArray = [arr sortedArrayUsingSelector:@selector(compare:)];
//        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
//        for (NSInteger i = sortArray.count-1; i >= 0; i--) {
//            NSString *date = [sortArray objectAtIndex:i];
//            [tempArray addObject:[DateUtils getDateString:[DateUtils getDate:date format:@"yyyyMM"] format:@"yyyy年MM月"]];
//        }
//        return [tempArray copy];
//    }
//    return nil;
//}


@end
