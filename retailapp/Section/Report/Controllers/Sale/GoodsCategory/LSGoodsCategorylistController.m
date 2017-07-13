//
//  LSGoodsCategorylistController.m
//  retailapp
//
//  Created by guozhi on 2016/11/23.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSGoodsCategorylistController.h"
#import "XHAnimalUtil.h"
#import "LSGoodsCategorySaleCell.h"
#import "LSFooterView.h"
#import "AlertBox.h"
#import "LSGoodsSalesReportVo.h"
#import "HeaderItem.h"
#import "ExportView.h"
#import "DatePickerBox.h"
#import "DateUtils.h"
@interface LSGoodsCategorylistController ()< UITableViewDelegate, UITableViewDataSource, LSFooterViewDelegate, DatePickerClient>
/** 表格 */
@property (nonatomic, strong)  UITableView *tableView;
/** 分页标志 */
@property (nonatomic, assign) int currentPage;
/** 底部工具栏 */
@property (nonatomic, strong) LSFooterView *footerView;
/** 合计净销售额 */
@property (nonatomic, strong) NSNumber *totalAmount;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation LSGoodsCategorylistController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.totalAmount = @0.0;
    [self configViews];
    [self configConatraints];
    [self loadData];
    [self loadManualTimer];
}

- (void)configViews {
    self.view.backgroundColor = [UIColor clearColor];
    //数据源
    self.datas = [NSMutableArray array];
    //标题
    [self configTitle:@"商品分类销售报表" leftPath:Head_ICON_BACK rightPath:nil];
    //表格
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 88;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
    __weak typeof(self) wself = self;
    self.currentPage = 1;
    [self.tableView ls_addHeaderWithCallback:^{
        wself.currentPage = 1;
        [wself loadData];
    }];
    [self.tableView ls_addFooterWithCallback:^{
        wself.currentPage++;
        [wself loadData];
    }];
    [self.view addSubview:self.tableView];
    
    //底部工具栏
    self.footerView = [LSFooterView footerView];
    [self.footerView initDelegate:self btnsArray:@[kFootExport, kFootManual]];
    [self.view addSubview:self.footerView];
    self.footerView.hidden = YES;
}

- (void)configConatraints {
    __weak typeof(self) wself = self;
    //配置标题
    //配置表格
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(wself.view);
        make.top.equalTo(wself.view.top).offset(kNavH);
    }];
    //配置底部工具栏
    [self.footerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.height.equalTo(60);
    }];
}

// 查询列表
- (void)loadData {
    [self.param setValue:@(self.currentPage) forKey:@"currentPage"];
    NSString *url = @"goodsSalesReport/sortList";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        if (wself.currentPage == 1) {//currentPage = 1时才会返回
            [wself.datas removeAllObjects];
        }
        if ([ObjectUtil isNotNull:json[@"voList"]]) {
            NSArray *list = [LSGoodsSalesReportVo mj_objectArrayWithKeyValuesArray:json[@"voList"]];
            [wself.datas addObjectsFromArray:list];
        }
        
        if (self.datas.count > 0 && self.totalAmount.doubleValue <= 0) {
            [self getTotalAccount];
        }
        
        [wself.tableView reloadData];
        wself.tableView.ls_show = YES;
    } errorHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [AlertBox show:json];
        
    }];
}

// 查询合计金额
- (void)getTotalAccount {
    NSString *url = @"goodsSalesReport/sortSum";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:self.param];
    [params removeObjectForKey:@"currentPage"];
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:params withMessage:nil show:YES CompletionHandler:^(id json) {
            if ([ObjectUtil isNotNull:json[@"totalAmount"]]) {
                wself.totalAmount = json[@"totalAmount"];
                if (wself.tableView.ls_show) {
                    [wself.tableView reloadData];
                }
            }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark 手动生成剩余时间
- (void)loadManualTimer {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSString *shopId = self.param[@"shopId"];
    [param setValue:shopId forKey:@"shopId"];
    __weak typeof(self) wself = self;
    NSString *url = @"dayReport/manuallyGeneratedDailyCheck";
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        wself.footerView.hidden = NO;
        if ([json[@"isOk"] isEqual:@0]) {
            NSTimeInterval timerInterval = [[json objectForKey:@"remainTime"] doubleValue]/1000;
            [wself createTimerWith:timerInterval];
            [wself.footerView showManualBtn:NO text:nil];
        } else {
            [wself.footerView showManualBtn:YES text:nil];
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}



#pragma mark - <LSFooterViewDelegate>
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootExport]) {//点击导出按钮
        [self showExportEvent];
    } else if ([footerType isEqualToString:kFootManual]) {//点击手动导出
        [self showManualEvent];
    }
}

#pragma mark 导出
- (void)showExportEvent {
    ExportView *vc = [[ExportView alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    [self.param removeObjectForKey:@"currentPage"];
    [vc loadData:self.param withPath:@"goodsSalesReport/sortExport" withIsPush:YES callBack:^{
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    }];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}
#pragma mark 手动导出
- (void)showManualEvent {
    NSDate *date = [NSDate date];
    [DatePickerBox setRight];
    [DatePickerBox show:@"选择时间" date:date client:self event:0];
    
}

- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event {
    [AlertBox show:@"销售数据正在生成中，请稍后再查看!"];
    [self.footerView showManualBtn:NO text:@"正在\n生成中..."];
    [DateUtils formateDate2:date];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[NSNumber numberWithLongLong:[DateUtils getStartTimeOfDate:date]] forKey:@"startTime"];
    [param setValue:[NSNumber numberWithLongLong:[DateUtils getEndTimeOfDate:date]] forKey:@"endTime"];
    [param setValue:[self.param objectForKey:@"shopId"] forKey:@"shopId"];
    [param setValue:[self.param objectForKey:@"shopEntityId"] forKey:@"shopEntityId"];
    NSString *url = @"dayReport/manuallyGeneratedDailyReport";
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
    return YES;
}

//倒计时
- (void)createTimerWith:(NSTimeInterval)timeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"mm:ss"];
    [self.footerView showManualBtn:NO text:[formate stringFromDate:date]];
    NSTimeInterval period = 1.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    __weak typeof(self) wself = self;
    __block long long weakSeconds = (long long)timeInterval;
    dispatch_source_set_event_handler(self.timer, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            weakSeconds = weakSeconds - 1;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:weakSeconds];
            NSDateFormatter *formate = [[NSDateFormatter alloc] init];
            [formate setDateFormat:@"mm:ss"];
            [wself.footerView showManualBtn:NO text:[NSString stringWithFormat:@"%@\n生成中...",[formate stringFromDate:date]]];
            if (weakSeconds <= 0) {
                [wself.footerView showManualBtn:YES text:nil];
                dispatch_cancel(wself.timer);
            }
        });
        
    });
    dispatch_resume(self.timer);
}


#pragma mark - <UITableView>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSGoodsCategorySaleCell *cell = [LSGoodsCategorySaleCell goodsCategorySaleCellWithTableView:tableView];
    LSGoodsSalesReportVo *model = self.datas[indexPath.row];
    cell.model = model;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderItem *headItem = [HeaderItem headerItem];
    NSString *totalAmount = [NSString stringWithFormat:@"合计：¥%.2f", self.totalAmount.doubleValue];
    [headItem initWithName:totalAmount];
    return headItem;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
@end
