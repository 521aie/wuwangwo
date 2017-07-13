//
//  WithdrawRecordView.m
//  retailapp
//
//  Created by Jianyong Duan on 16/1/19.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "WithdrawRecord.h"
#import "WithdrawCheckVo.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "NameItemVO.h"
#import "OptionPickerBox.h"
#import "DateUtils.h"
#import "DatePickerBox.h"
#import "XHAnimalUtil.h"
#import "WithdrawDetailView.h"
#import "CashRecordDetail.h"
@interface WithdrawRecord ()<INavigateEvent, IEditItemListEvent,OptionPickerClient,DatePickerClient>


@property (nonatomic, strong) NSMutableArray *withdrawCheckList;

@property (nonatomic) NSInteger status;
@property (nonatomic) long long startTime;
@property (nonatomic) long long lastTime;
@property (nonatomic) long long reFreshLastTime;

@property (nonatomic) BOOL isRefresh;

@end

@implementation WithdrawRecord

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.withdrawCheckList = [NSMutableArray array];
    self.startTime = [[DateUtils getYearAgoDate:[NSDate date]] timeIntervalSince1970];
    self.lastTime = [[NSDate date] timeIntervalSince1970];
    self.reFreshLastTime = self.lastTime;
    self.isRefresh = YES;
    
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"提现记录" backImg:Head_ICON_BACK moreImg:Head_ICON_CHOOSE];
    [self.titleDiv addSubview:self.titleBox];
    
    [self initGridView];
    
    [self loadData];
    
    //筛选
    [_lstCheckStatus initLabel:@"审核状态" withHit:nil delegate:self];
    [_lstCheckStatus initData:@"全部" withVal:@"0"];
    _lstCheckStatus.tag = 1;
    
    [_lstCheckTime initLabel:@"申请日期" withHit:nil delegate:self];
    [_lstCheckTime initData:@"请选择" withVal:nil];
    _lstCheckTime.tag = 2;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.mainGrid reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initGridView {
    [self.mainGrid ls_addHeaderWithCallback:^{
        self.isRefresh = YES;
        self.lastTime = self.reFreshLastTime;
        [self loadData];
    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        self.isRefresh = NO;
        [self loadData];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) onNavigateEvent:(Direct_Flag)event {
    if (event == 1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        [self.view addSubview:self.viewFilter];
    }
}

- (void)onItemListClick:(EditItemList*)obj {
    
    if (obj == self.lstCheckStatus) {
        //1：未审核，2：审核不通过，3：审核通过
        NSMutableArray *nameItems = [[NSMutableArray alloc] init];
        NameItemVO *nameItemVo = [[NameItemVO alloc] initWithVal:@"全部" andId:@"0"];
        [nameItems addObject:nameItemVo];
        nameItemVo = [[NameItemVO alloc] initWithVal:@"未审核" andId:@"1"];
        [nameItems addObject:nameItemVo];
        nameItemVo = [[NameItemVO alloc] initWithVal:@"审核不通过" andId:@"2"];
        [nameItems addObject:nameItemVo];
        nameItemVo = [[NameItemVO alloc] initWithVal:@"审核通过" andId:@"3"];
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
    NSString * proposerId = [[Platform Instance] getkey:SHOP_ID];

    NSString* url = @"withdrawCheck/resume";
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [param setValue:proposerId forKey:@"proposerId"];
    if (self.status  > 0) {
        [param setValue:[NSNumber numberWithInteger:self.status ] forKey:@"result"];
    }
    if (self.startTime > 0) {
        [param setValue:[NSNumber numberWithLongLong:self.startTime] forKey:@"startTime"];
    }
    if (self.lastTime > 0) {
        [param setValue:[NSNumber numberWithLongLong:self.lastTime] forKey:@"lastTime"];
    }

    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        [self.mainGrid headerEndRefreshing];
        [self.mainGrid footerEndRefreshing];
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
        
        [self.mainGrid reloadData];
    } errorHandler:^(id json) {
        [self.mainGrid headerEndRefreshing];
        [self.mainGrid footerEndRefreshing];
        [AlertBox show:json];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.withdrawCheckList.count;
}

#pragma table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* tableViewCell = @"TableViewCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableViewCell];
    if (!cell) {
        //通过xib的名称加载自定义的cell
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCell];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    WithdrawCheckVo *vo = [self.withdrawCheckList objectAtIndex:indexPath.row];
    
    UILabel*lblFee=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 209, 21)];
    lblFee.text = [NSString stringWithFormat:@"提现%.2f元", vo.actionAmount];
    lblFee.font=[UIFont fontWithName:@"Helvetica Neue" size:18];
    lblFee.textColor=[UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
    [cell.contentView addSubview:lblFee];
    
    UILabel*lblTime=[[UILabel alloc] initWithFrame:CGRectMake(10, 48, 150, 21)];
    lblTime.text=[DateUtils formateTime1:vo.createTime];
    lblTime.textColor=[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    lblTime.font=[UIFont fontWithName:@"Helvetica Neue" size:13];
    [cell.contentView addSubview:lblTime];

    UILabel*lblState=[[UILabel alloc] initWithFrame:CGRectMake(194, 29, 100, 21)];
    
    //1：未审核，2：审核不通过，3：审核通过
    if (vo.checkResult == 1) {
        lblState.text = @"未审核";
        lblState.textColor = RGB(0, 136, 204);
    } else if (vo.checkResult == 2) {
        lblState.text = @"审核不通过";
        lblState.textColor = RGB(255, 0, 0);
    } else if (vo.checkResult == 3) {
        lblState.text = @"审核通过";
        lblState.textColor = RGB(0, 170, 34);
    } else {
        lblState.text = @"取消";
        lblState.textColor = RGB(255, 0, 0);
    }
    
    lblState.textAlignment=NSTextAlignmentRight;
    lblState.font=[UIFont fontWithName:@"Helvetica Neue" size:13];
    [cell.contentView addSubview:lblState];

    UIImageView *imgArray=[[UIImageView alloc] initWithFrame:CGRectMake(292, 30, 20, 20)];
    imgArray.image=[UIImage imageNamed:@"ico_next.png"];
    imgArray.alpha=0.6;
    [cell.contentView addSubview:imgArray];
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 79, 320, 1)];
    line.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    [cell.contentView addSubview:line];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WithdrawCheckVo *checkVo = [self.withdrawCheckList objectAtIndex:indexPath.row];
    CashRecordDetail *vc = [[CashRecordDetail alloc] initWithNibName:[SystemUtil getXibName:@"CashRecordDetail"] bundle:nil withdrawCheckVo:checkVo];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

- (IBAction)closeFilterView:(id)sender {
    [self.viewFilter removeFromSuperview];
}

- (IBAction)filterTypeClick:(UIButton *)sender {
    
    if (sender.tag == 0 ) {
        //重置
        [_lstCheckStatus initData:@"全部" withVal:@"0"];
        [_lstCheckTime initData:@"请选择" withVal:@""];
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
        
        [self.mainGrid headerBeginRefreshing];
    }
}

@end
