//
//  LSShopCollectionListController.m
//  retailapp
//
//  Created by guozhi on 2016/11/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSShopCollectionListController.h"
#import "XHAnimalUtil.h"
#import "LSFooterView.h"
#import "ExportView.h"
#import "AlertBox.h"
#import "HeaderItem.h"
#import "DateUtils.h"
#import "LSShopCollectionListCell.h"
#import "ColorHelper.h"
#import "LSHandoverPayTypeDateVo.h"
#import "LSHandoverPayTypeVo.h"
#import "LSShopCollectionDetailListController.h"
#import "DatePickerBox.h"
@interface LSShopCollectionListController ()< UITableViewDelegate, UITableViewDataSource, LSFooterViewDelegate>
/** 表格 */
@property (nonatomic, strong)  UITableView *tableView;
/** 分页标志 */
@property (nonatomic, strong) NSNumber *lastTime;
/** 底部工具栏 */
@property (nonatomic, strong) LSFooterView *footerView;
/** 数据源 */
@property (nonatomic, strong)  NSMutableArray *datas;
/** 用来分页 */
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation LSShopCollectionListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self loadData];
    if (self.isToday) {
        [self loadManualTimer];
    }
}

- (void)configViews {
    self.datas = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor clearColor];
   
    //标题
    [self configTitle:@"收款统计报表" leftPath:Head_ICON_BACK rightPath:nil];
    //表格
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 88;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
    [self.view addSubview:self.tableView];
    __weak typeof(self) wself = self;
    self.currentPage = 1;
    [self.tableView ls_addHeaderWithCallback:^{
        wself.currentPage = 1;
        [wself loadData];
    }];
    [self.tableView ls_addFooterWithCallback:^{
        wself.currentPage ++;
        [wself loadData];
    }];
    
    //底部工具栏
    self.footerView = [LSFooterView footerView];
    if (self.isToday) {//只有今天的才有手动生成按钮
        [self.footerView initDelegate:self btnsArray:@[kFootExport, kFootManual]];
    } else {
        [self.footerView initDelegate:self btnsArray:@[kFootExport]];
    }
    [self.view addSubview:self.footerView];
    self.footerView.ls_bottom = SCREEN_H;
}




#pragma mark - 加载数据
- (void)loadData {
    NSString *url = @"shopCashierReport/v1/list";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        if (wself.currentPage == 1) {
            [wself.datas removeAllObjects];
        }
        if ([ObjectUtil isNotNull:json[@"handoverPayTypeVos"]]) {
            NSMutableArray *list = [LSHandoverPayTypeDateVo mj_objectArrayWithKeyValuesArray:json[@"handoverPayTypeVos"]];
            [wself.datas addObjectsFromArray:list];
            [wself.tableView reloadData];
        }
         wself.tableView.ls_show = YES;
    } errorHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [AlertBox show:json];
    }];
}

#pragma mark 手动生成剩余时间
- (void)loadManualTimer {
    __weak typeof(self) wself = self;
    NSString *url = @"shopCashierReport/manuallyGeneratedHandoverPayTypeCheck";
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
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

- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [NSMutableDictionary dictionary];
    }
    [_param setValue:@(self.currentPage) forKey:@"currPage"];
    return _param;
}



#pragma mark - 导出事件
-(void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootExport]) {//点击导出按钮
        [self showExportEvent];
    } else if ([footerType isEqualToString:kFootManual]) {//点击手动导出
        [self showManualEvent];
    }
}

#pragma mark 手动导出
- (void)showManualEvent {
    [AlertBox show:@"收款数据正在生成中，请稍后再查看！"];
    [self.footerView showManualBtn:NO text:@"正在\n生成中..."];
    NSString *url = @"shopCashierReport/manuallyGeneratedHandoverPayType";
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}

- (void)showExportEvent {
    ExportView *exportView = [[ExportView alloc] init];
    __weak typeof(self) weakSelf = self;
    [exportView loadData:self.param withPath:@"shopCashierReport/v1/export" withIsPush:YES callBack:^{
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
    }];
    [self.navigationController pushViewController:exportView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    LSHandoverPayTypeDateVo *handoverPayTypeDateVo = self.datas[section];
    return handoverPayTypeDateVo.handoverPayTypes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderItem *headItem = [HeaderItem headerItem];
    LSHandoverPayTypeDateVo *handoverPayTypeDateVo = self.datas[section];
    NSString *titleVal = [NSString stringWithFormat:@"%@  合计：￥%.2f",[DateUtils formateTime5:handoverPayTypeDateVo.currDate.longLongValue], handoverPayTypeDateVo.totalSalesAmount.doubleValue];
    [headItem initWithName:titleVal];
    return headItem;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSShopCollectionListCell *cell = [LSShopCollectionListCell shopCollectionListCellWithTableView:tableView];
    LSHandoverPayTypeDateVo *handoverPayTypeDateVo = self.datas[indexPath.section];
    LSHandoverPayTypeVo *handoverPayTypeVo = handoverPayTypeDateVo.handoverPayTypes[indexPath.row];
    [cell setHandoverPayTypeVo:handoverPayTypeVo showNextimg:self.show];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.show) {//不显示下一个图标若选择的来源是全部、微店，不支持点击支付方式栏进入详情页；
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:self.param];
    [param removeObjectForKey:@"lastSortId"];
    LSHandoverPayTypeDateVo *handoverPayTypeDateVo = self.datas[indexPath.section];
    LSHandoverPayTypeVo *handoverPayTypeVo = handoverPayTypeDateVo.handoverPayTypes[indexPath.row];
    [param setValue:handoverPayTypeVo.kindPayId forKey:@"kindPayId"];
    [param setValue:handoverPayTypeDateVo.currDate forKey:@"currDate"];
    if ([ObjectUtil isNotNull:handoverPayTypeVo.isInclude]) {
        [param setValue:handoverPayTypeVo.isInclude forKey:@"isInclude"];
    }
    LSShopCollectionDetailListController *vc = [[LSShopCollectionDetailListController alloc] init];
    vc.param = param;
    vc.currDate = handoverPayTypeDateVo.currDate;
    vc.titleName = handoverPayTypeVo.payMode;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}



@end
