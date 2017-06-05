//
//  WithdrawListView.m
//  retailapp
//
//  Created by Jianyong Duan on 16/1/4.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "WithdrawListView.h"
#import "WithdrawCheckVo.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "CompanionListCell.h"
#import "NameItemVO.h"
#import "OptionPickerBox.h"
#import "DateUtils.h"
#import "DatePickerBox.h"
#import "WithdrawDetailView.h"
#import "XHAnimalUtil.h"

@interface WithdrawListView () <INavigateEvent, ISearchBarEvent, IEditItemListEvent,OptionPickerClient,DatePickerClient>


@property (nonatomic, strong) NSMutableArray *withdrawCheckList;

@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic) NSInteger status;
@property (nonatomic) long long startTime;
@property (nonatomic) long long lastTime;
@property (nonatomic) long long reFreshLastTime;

@property (nonatomic) BOOL isRefresh;

@end

@implementation WithdrawListView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.withdrawCheckList = [NSMutableArray array];
    self.startTime = [[DateUtils getYearAgoDate:[NSDate date]] timeIntervalSince1970];
    self.lastTime = [[NSDate date] timeIntervalSince1970];
    self.reFreshLastTime = self.lastTime;
    self.isRefresh = YES;
    
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"余额提现审核" backImg:Head_ICON_BACK moreImg:Head_ICON_CHOOSE];
    [self.titleDiv addSubview:self.titleBox];
    
    [self.searchBar2 initDelagate:self placeholder:@"姓名/手机号或后4位"];
    [self initGridView];
    //默认查询未审核
    self.status = 1;
    [self loadData];
    
    //筛选
    [_lstCheckStatus initLabel:@"审核状态" withHit:nil delegate:self];
    [_lstCheckStatus initData:@"未审核" withVal:@"1"];
    _lstCheckStatus.tag = 1;
    
    [_lstCheckTime initLabel:@"申请日期" withHit:nil delegate:self];
//    [_lstCheckTime initData:[DateUtils formateDate2:[NSDate date]] withVal:[DateUtils formateDate2:[NSDate date]]];
    [_lstCheckTime initData:@"请选择" withVal:nil];
    _lstCheckTime.tag = 2;
    
}

- (void)initGridView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CompanionListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView ls_addHeaderWithCallback:^{
        self.isRefresh = YES;
        self.lastTime = self.reFreshLastTime;
        [self loadData];
    }];
    [self.tableView ls_addFooterWithCallback:^{
        self.isRefresh = NO;
        [self loadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == 1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        [self.view addSubview:self.viewFilter];
    }
}

// 输入完成
- (void)imputFinish:(NSString *)keyWord {
    self.keyWord = keyWord;
    [self.tableView headerBeginRefreshing];
}

- (void)onItemListClick:(EditItemList *)obj {
    
    if (obj == self.lstCheckStatus) {
        //1：未审核，2：审核不通过，3：审核通过
        NSMutableArray *nameItems = [[NSMutableArray alloc] init];
        NameItemVO *nameItemVo = [[NameItemVO alloc] initWithVal:@"全部" andId:@"0"];
        [nameItems addObject:nameItemVo];
        nameItemVo = [[NameItemVO alloc] initWithVal:@"未审核" andId:@"1"];
        [nameItems addObject:nameItemVo];
        nameItemVo = [[NameItemVO alloc] initWithVal:@"审核通过" andId:@"3"];
        [nameItems addObject:nameItemVo];
        nameItemVo = [[NameItemVO alloc] initWithVal:@"审核不通过" andId:@"2"];
        [nameItems addObject:nameItemVo];
        nameItemVo = [[NameItemVO alloc] initWithVal:@"取消" andId:@"4"];
        [nameItems addObject:nameItemVo];
        [OptionPickerBox initData:nameItems itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    } else if (obj == self.lstCheckTime) {
        NSDate* date = [DateUtils parseDateTime4:obj.lblVal.text];
        [DatePickerBox showClear:obj.lblName.text clearName:@"清空日期" date:date client:self event:obj.tag];
    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    
    id<INameItem> item = (id<INameItem>)selectObj;
    
    if (eventType == 1) {
        [self.lstCheckStatus initData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    return YES;
}

- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event {
    
    //最早只能选择一年前的日期，如今天是2015-11-02，那最早只能选择2014-11-02
    NSString* dateStr=[DateUtils formateDate2:date];
    
    //一年前的日期
    NSString *dateNow = [DateUtils formateDate2:[NSDate date]];
    int year = [[dateNow substringToIndex:4] intValue];
    NSString *date1 = [NSString stringWithFormat:@"%d%@", year - 1, [dateNow substringFromIndex:4]];
    if ([dateStr compare:date1] == NSOrderedAscending) {
        [AlertBox show:@"最早只能选择一年前的日期"];
        return NO;
    }
    
    [_lstCheckTime initData:[DateUtils formateDate2:date] withVal:[DateUtils formateDate2:date]];
    return YES;
}

- (void)clearDate:(NSInteger)eventType {
    [_lstCheckTime initData:@"" withVal:@""];
}

- (void)loadData {
    
    NSString* url = @"withdrawCheck/list";
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:5];
    
 
    if ([NSString isNotBlank:self.keyWord]) {
        [param setValue:self.keyWord forKey:@"keyWord"];
    }
    if (self.status > 0) {
        [param setValue:[NSNumber numberWithInteger:self.status] forKey:@"result"];
    }
    if (self.startTime > 0) {
        [param setValue:[NSNumber numberWithLongLong:self.startTime] forKey:@"startTime"];
    }
    if (self.lastTime > 0) {
        [param setValue:[NSNumber numberWithLongLong:self.lastTime] forKey:@"lastTime"];
    }
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        if (self.isRefresh) {
            [self.withdrawCheckList removeAllObjects];
            self.reFreshLastTime = self.lastTime;
        }
        if ([ObjectUtil isNotEmpty:json[@"withdrawCheckList"]]) {
            for (NSDictionary *obj in json[@"withdrawCheckList"]) {
                WithdrawCheckVo *checkVo = [WithdrawCheckVo converToVo:obj];
                [self.withdrawCheckList addObject:checkVo];
            }
        }
        
        if([ObjectUtil isNotNull:json[@"lastTime"]]) {
            self.lastTime = [json[@"lastTime"] longLongValue];
        }
        
        [self.tableView reloadData];
    } errorHandler:^(id json) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        [AlertBox show:json];
    }];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.withdrawCheckList.count;
}

#pragma table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    CompanionListCell *companionListCell = (CompanionListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    WithdrawCheckVo *checkVo = [self.withdrawCheckList objectAtIndex:indexPath.row];
    [companionListCell initWithdrawData:checkVo];
    
    return companionListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WithdrawCheckVo *checkVo = [self.withdrawCheckList objectAtIndex:indexPath.row];
    WithdrawDetailView *vc = [[WithdrawDetailView alloc] initWithNibName:[SystemUtil getXibName:@"WithdrawDetailView"] bundle:nil];
    vc.checkVo=checkVo;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    [vc loadWithdrawDetail:0 withIsPush:YES callBack:^(id<ITreeItem> companion) {
        [self.tableView headerBeginRefreshing];
    }];
}

- (IBAction)closeFilterView:(id)sender {
    [self.viewFilter removeFromSuperview];
}

- (IBAction)filterTypeClick:(UIButton *)sender {
    
    if (sender.tag == 0 ) {
        //重置
        [_lstCheckStatus initData:@"未审核" withVal:@"1"];
//        [_lstCheckTime initData:[DateUtils formateDate2:[NSDate date]] withVal:[DateUtils formateDate2:[NSDate date]]];
        [_lstCheckTime initData:@"请选择" withVal:nil];
    } else {
        //完成
        [self.viewFilter removeFromSuperview];
        //状态
        self.status = [_lstCheckStatus.currentVal intValue];
        //时间
        if ([NSString isNotBlank:_lstCheckTime.currentVal]) {
            NSDate *date = [DateUtils parseDateTime4:_lstCheckTime.currentVal];
            self.startTime = [DateUtils getStartTimeOfDate1:date];
            self.lastTime = [DateUtils getEndTimeOfDate1:date];
        } else {
            self.startTime = [[DateUtils getYearAgoDate:[NSDate date]] timeIntervalSince1970];
            self.lastTime = [[NSDate date] timeIntervalSince1970];
        }

        self.reFreshLastTime = self.lastTime;
        
        [self.tableView headerBeginRefreshing];
    }
}

@end
