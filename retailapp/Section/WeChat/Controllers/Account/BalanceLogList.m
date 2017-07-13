//
//  WeChatBalanceLog.m
//  retailapp
//
//  Created by diwangxie on 16/4/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "BalanceLogList.h"
#import "XHAnimalUtil.h"
#import "BaseService.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "BalanceLogVo.h"
#import "ObjectUtil.h"
#import "NameItemVO.h"
#import "DateUtils.h"

@interface BalanceLogList ()
@property (nonatomic, strong) BaseService             *service;           //网络服务
@property (nonatomic, strong) NSString                *companionAccountId;//id
@property (nonatomic) long long                       lastTime;           //翻页

@property (nonatomic, strong) NSMutableArray          *balanceLogVoArray; //网络服务

@end

@implementation BalanceLogList

- (void)viewDidLoad {
    [super viewDidLoad];
    _service = [ServiceFactory shareInstance].baseService;
    self.balanceLogVoArray=[[NSMutableArray alloc] init];
    [self initHead];
    [self initFilterView];
    [self initGrid];
    self.lastTime=1;
    [self loadDate];
    
}
-(void)initHead{
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"收支明细" backImg:Head_ICON_BACK moreImg:Head_ICON_CHOOSE];
    self.titleBox.lblRight.text=@"筛选";
    [self.titleDiv addSubview:self.titleBox];
}

- (void)initFilterView {
    [self.lstType initLabel:@"明细类型" withHit:nil delegate:self];
    [self.lstType initData:@"全部" withVal:@"0"];
    self.lstType.tag = 1;
    
    [self.lstDate initLabel:@"日期" withHit:nil delegate:self];
    [self.lstDate initData:@"请选择" withVal:nil];
    self.lstDate.tag = 2;
}

-(void)initGrid{
    [self.mainGrid ls_addHeaderWithCallback:^{
        self.lastTime=1;
        [self loadDate];
    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        [self loadDate];
    }];
}
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self.view addSubview:self.viewFilter];
    }
}
-(void)loadDate{
    
    NSString *url = nil;
    
    url = @"accountInfo/moneyflow/list";
    
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:6];
    
    self.companionAccountId=[[Platform Instance] getkey:SHOP_ID];
    [param setValue:self.companionAccountId forKey:@"companionAccountId"];
    [param setValue:[NSNumber numberWithLongLong:self.lastTime] forKey:@"lastTime"];
    [param setValue:[NSNumber numberWithInteger:[self.lstType getStrVal].intValue] forKey:@"type"];
    [param setValue:[self.lstDate getStrVal] forKey:@"createTime"];
    
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
         NSMutableArray *balanceLogVoList = nil;
        if (self.lastTime==1) {
            [self.balanceLogVoArray removeAllObjects];
        }
        
        self.lastTime=[[json objectForKey:@"lastTime"] longLongValue];

        balanceLogVoList=[json objectForKey:@"balanceLogVoList"];
        if([ObjectUtil isNotNull:balanceLogVoList]){
            for (NSDictionary *dic in balanceLogVoList) {
                [self.balanceLogVoArray addObject:[BalanceLogVo converToVo:dic]];
            }
        }
        
        [self.mainGrid reloadData];
        [self.mainGrid headerEndRefreshing];
        [self.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [self.mainGrid headerEndRefreshing];
        [self.mainGrid footerEndRefreshing];
        [AlertBox show:json];
    }];
}

- (void)onItemListClick:(EditItemList *)obj {
    
    if(obj == self.lstType) {
        
        NSMutableArray *nameItems = [[NSMutableArray alloc] init];
        NameItemVO *nameItemVo = [[NameItemVO alloc] initWithVal:@"全部" andId:@"0"];
        [nameItems addObject:nameItemVo];
        
//        if(([[Platform Instance] getShopMode]==2 && [[Platform Instance] getkey:SHOP_BIND_FLG].intValue==1) || [[Platform Instance] isBigCompanion]  || ([[Platform Instance] getShopMode]==3 && [[Platform Instance] getkey:SHOP_BIND_FLG].intValue==1) || ([[Platform Instance] getShopMode]==3 && [[Platform Instance] isTopOrg] && ![[Platform Instance]isBigCompanion])){
//            nameItemVo = [[NameItemVO alloc] initWithVal:@"分销返利" andId:@"1"];
//            [nameItems addObject:nameItemVo];
//            nameItemVo = [[NameItemVO alloc] initWithVal:@"余利收入" andId:@"3"];
//            [nameItems addObject:nameItemVo];
//        }
        
        if([[Platform Instance] getShopMode] == 2) {
            nameItemVo = [[NameItemVO alloc] initWithVal:@"销售收入" andId:@"4"];
            [nameItems addObject:nameItemVo];
        }
        nameItemVo = [[NameItemVO alloc] initWithVal:@"提现" andId:@"5"];
        [nameItems addObject:nameItemVo];
        
        [OptionPickerBox initData:nameItems itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    } else if (obj == self.lstDate) {
        NSDate *date = [NSDate date];
        if ([NSString isNotBlank:[self.lstDate getStrVal]]) {
            date=[DateUtils parseDateTime4:[self.lstDate getStrVal]];
        }
        NSTimeInterval time = 365 * 24 * 60 * 60;//一年的秒数
        NSDate* currentDate = [[NSDate alloc] init];
        NSDate * minimumDate = [currentDate dateByAddingTimeInterval:-time];
        [DatePickerBox showToClear:obj.lblName.text clearName:@"清空时间" date:date client:self startDate:minimumDate endDate:[NSDate date] event:(int)obj.tag];
    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {

    if (eventType == 1){
        id<INameItem> item = (id<INameItem>)selectObj;
        [self.lstType initData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    return YES;
}

- (void)clearDate:(NSInteger)eventType {
    [self.lstDate initData:@"请选择" withVal:nil];
}

- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event {
    
    NSString *time = [DateUtils formateDate2:date];
    [self.lstDate initData:time withVal:time];
    return YES;
}


- (IBAction)closeFilterView:(id)sender {
    [self.viewFilter removeFromSuperview];
}

- (IBAction)filterOkClick:(UIButton *)sender {
    self.lastTime=1;
    [self loadDate];
    [self.viewFilter removeFromSuperview];
}
- (IBAction)filterCancelClick:(UIButton *)sender {
    [self.lstType initData:@"全部" withVal:@"0"];
    [self.lstDate initData:@"请选择" withVal:nil];
}

#pragma mark - 表格
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.balanceLogVoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* tableViewCell = @"TableViewCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableViewCell];
    if (!cell) {
        //通过xib的名称加载自定义的cell
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCell];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    BalanceLogVo *vo=[self.balanceLogVoArray objectAtIndex:indexPath.row];
    
    UILabel*lblFee=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 150, 21)];
    if(vo.action ==5){
        lblFee.textColor=[ColorHelper getGreenColor];
        lblFee.text=[NSString stringWithFormat:@"-%0.2f",vo.fee];
    }else{
        if (vo.fee>0) {
            lblFee.textColor=[ColorHelper getRedColor];
            lblFee.text=[NSString stringWithFormat:@"+%0.2f",vo.fee];
        }else{
            lblFee.textColor=[ColorHelper getGreenColor];
            lblFee.text=[NSString stringWithFormat:@"%0.2f",vo.fee];
        }
    }
    lblFee.font=[UIFont fontWithName:@"Helvetica Neue" size:18];
    [cell.contentView addSubview:lblFee];
    
    UILabel*lblTime=[[UILabel alloc] initWithFrame:CGRectMake(10, 48, 150, 21)];
    lblTime.text=vo.opTime;
    lblTime.textColor=[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    lblTime.font=[UIFont fontWithName:@"Helvetica Neue" size:13];
    [cell.contentView addSubview:lblTime];
    
    
    
    UILabel*lblAction=[[UILabel alloc] initWithFrame:CGRectMake(194, 29, 100, 21)];
    lblAction.text=[self getActionString:vo.action];
    lblAction.textAlignment=NSTextAlignmentRight;
    lblAction.textColor=[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    lblAction.font=[UIFont fontWithName:@"Helvetica Neue" size:13];
    [cell.contentView addSubview:lblAction];
    
    
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

- (NSString *)getActionString:(short)status {
    //销售订单  状态:11待付款、12付款中、13待分配、15待处理、20配送中、21配送完成、16拒绝配送、22交易取消、23交易关闭
    //供货订单:15待处理、20配送中、21配送完成、16拒绝配送
//    NSDictionary *statusDic = @{ @"1":@"分销返利", @"2":@"微平台", @"3":@"余利收入", @"4":@"供货", @"5":@"提现", @"6":@"退货"};
    NSDictionary *statusDic = @{@"4":@"销售收入" , @"5":@"提现", @"6":@"退货"};
    NSString *statusString = [statusDic objectForKey:[NSString stringWithFormat:@"%i", status]];
    if ([NSString isNotBlank:statusString]) {
        return statusString;
    } else {
        return @"";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BalanceLogVo *vo=[self.balanceLogVoArray objectAtIndex:indexPath.row];
    BalanceLogDetail *vc = [[BalanceLogDetail alloc] initWithNibName:[SystemUtil getXibName:@"BalanceLogDetail"] bundle:nil];
    vc.actionType=vo.action;
    vc.moneyFlow=vo.moneyFlowId;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
