//
//  LSMemberCardOperateListController.m
//  retailapp
//
//  Created by wuwangwo on 17/1/5.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberCardOperateListController.h"
#import "XHAnimalUtil.h"
#import "LSFooterView.h"
#import "ExportView.h"
#import "AlertBox.h"
#import "DateUtils.h"
#import "ColorHelper.h"
#import "DatePickerBox.h"
#import "LSCardOperateListVo.h"
#import "LSMemberCardOperateListCell.h"
#import "LSMemberCardOperateDetailController.h"
#import "HeaderItem.h"

@interface LSMemberCardOperateListController ()< UITableViewDelegate, UITableViewDataSource, LSFooterViewDelegate>
@property (nonatomic, strong)  UITableView *tableView;//表格
@property (nonatomic, strong) LSFooterView *footerView;//底部工具栏
@property (nonatomic, strong) NSMutableArray *dates;//记录日期数
@property (nonatomic, strong) NSMutableDictionary *dict;//数据源
@property (nonatomic, strong) NSString *keyWords;//关键字：手机号/会员卡号
@property (nonatomic, assign) NSInteger currPage;//用来分页
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation LSMemberCardOperateListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currPage = 1;
    [self configViews];
    [self configConatraints];
    [self loadData];
}

- (void)configViews {
    self.dates = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor clearColor];
    
    //标题
    [self configTitle:@"会员卡操作记录" leftPath:Head_ICON_BACK rightPath:nil];
    
    //表格
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 88;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[LSMemberCardOperateListCell class] forCellReuseIdentifier:@"OperateListCell"];
    
    __weak typeof (self) wself = self;
    [self.tableView ls_addHeaderWithCallback:^{
        wself.currPage = 1;
        [wself loadData];
    }];
    [self.tableView ls_addFooterWithCallback:^{
        wself.currPage += 1;
        [wself loadData];
    }];
    //底部工具栏
    self.footerView = [LSFooterView footerView];
    [self.footerView initDelegate:self btnsArray:@[kFootExport]];
    [self.view addSubview:self.footerView];
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

#pragma mark - 加载数据
- (void)loadData {
    __weak typeof(self) wself = self;
    NSString *url =  @"customerOperaLog/list";
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        if (wself.currPage == 1) {
            [wself.dates removeAllObjects];
            [wself.dict removeAllObjects];
        }
        if (!wself.dict) {
            wself.dict = [[NSMutableDictionary alloc] init];
        }
        if (!wself.dates) {
            wself.dates = [[NSMutableArray alloc] init];
        }
        
        NSArray *map = json[@"customerOpLogList"];
        if ([ObjectUtil isNotEmpty:map]) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (NSDictionary *obj in map) {
                LSCardOperateListVo *operateListVo = [[LSCardOperateListVo alloc] initWithDictionary:obj];
                [tempArray addObject:operateListVo];
            }
            for (LSCardOperateListVo *operateListVo in tempArray) {
                NSString *str = [NSString stringWithFormat:@"%@",operateListVo.opTime];
                NSString *time = [DateUtils getTimeStringFromCreaateTime:str format:@"yyyy年MM月"];
                NSMutableArray *arr1 = [self.dict objectForKey:time];
                
                if (!arr1) {
                    arr1 = [[NSMutableArray alloc] init];
                    [self.dict setValue:arr1 forKey:time];
                    [self.dates addObject:time];
                }
                [arr1 addObject:operateListVo];
            }
        }else {
            wself.currPage = MAX(1, --wself.currPage);
        }
        [wself.tableView reloadData];
        wself.tableView.ls_show = YES;
    } errorHandler:^(id json) {
        wself.currPage = MAX(1, --wself.currPage);
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [AlertBox show:json];
    }];
}

#pragma mark - 会员卡交易参数
- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [[NSMutableDictionary alloc] init];
    }
     [_param setValue:@(self.currPage) forKey:@"currPage"];
    return _param;
}

#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dates.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [self.dict objectForKey:self.dates[section]];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderItem *headItem = [HeaderItem headerItem];
    [headItem initWithName:self.dates[section]];
    return headItem;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSMemberCardOperateListCell *cell = [LSMemberCardOperateListCell shopCollectionListCellWithTableView:tableView];
    NSArray *operateListVos = [self.dict objectForKey:self.dates[indexPath.section]];
    LSCardOperateListVo *list = operateListVos[indexPath.row];
    [cell setoperateVo:list showNextimg:YES];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSMemberCardOperateDetailController *vc = [[LSMemberCardOperateDetailController alloc] init];
    NSArray *operateListVos = [self.dict objectForKey:self.dates[indexPath.section]];
    LSCardOperateListVo *list = operateListVos[indexPath.row];
    vc.id = list.id;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
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


#pragma mark - 导出事件
-(void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootExport]) {
        [self showExportEvent];
    }
}

//点击导出按钮
- (void)showExportEvent {
    ExportView *exportView = [[ExportView alloc] init];
    __weak typeof(self) weakSelf = self;
    [exportView loadData:self.param withPath:@"customerOperaLog/export" withIsPush:YES callBack:^{
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
    }];
    [self.navigationController pushViewController:exportView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

@end
