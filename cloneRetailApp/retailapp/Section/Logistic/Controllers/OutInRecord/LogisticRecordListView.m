//
//  LogisticRecordListView.m
//  retailapp
//
//  Created by hm on 15/8/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LogisticRecordListView.h"
#import "ServiceFactory.h"
#import "XHAnimalUtil.h"
#import "GridColHead2.h"
#import "LogisticRecordCell.h"
#import "ColorHelper.h"
#import "AlertBox.h"
#import "LogisticRecordDetailView.h"
#import "LogisticsVo.h"
@interface LogisticRecordListView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) LogisticService* logisticService;

@property (nonatomic) NSInteger currentPage;
/** <#注释#> */
@property (nonatomic, strong) UITableView *mainGrid;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *datas;
/**数据模型*/
@property (nonatomic,strong) LogisticsVo* logisticsVo;
@end

@implementation LogisticRecordListView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logisticService = [ServiceFactory shareInstance].logisticService;
    [self initNavigate];
    [self configViews];
    self.currentPage = 1;
    self.datas = [NSMutableArray array];
    [self selectLogisticRecordList];
}
- (void)configViews {
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.backgroundColor = [UIColor clearColor];
    __weak typeof(self) weakSelf = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.currentPage=1;
        [weakSelf selectLogisticRecordList];
    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf selectLogisticRecordList];
    }];
    [self.view addSubview:self.mainGrid];
}


#pragma mark - 初始化导航
- (void)initNavigate
{
    [self configTitle:@"出入库记录" leftPath:Head_ICON_BACK rightPath:nil];
}


#pragma mark - 物流单据列表
- (void)selectLogisticRecordList
{
    [self.param setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"currentPage"];
    __weak typeof(self) weakSelf = self;
    [_logisticService selectLogisticRecordList:self.param completionHandler:^(id json) {
        NSMutableArray* logisticsList = [LogisticsVo converToArr:[json objectForKey:@"logisticsList"]];
        if (weakSelf.currentPage==1) {
            [weakSelf.datas removeAllObjects];
        }
        [weakSelf.datas addObjectsFromArray:logisticsList];
        logisticsList = nil;
        [weakSelf.mainGrid reloadData];
        weakSelf.mainGrid.ls_show = YES;
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString* gridColHead2Id = @"GridColHead2";
    GridColHead2 *headItem = (GridColHead2 *)[tableView dequeueReusableCellWithIdentifier:gridColHead2Id];
    if (!headItem) {
        [tableView registerNib:[UINib nibWithNibName:@"GridColHead2" bundle:nil] forCellReuseIdentifier:gridColHead2Id];
        headItem = [tableView dequeueReusableCellWithIdentifier:gridColHead2Id];
    }
    [headItem initColHead:@"供应商" col2:@"类型" col3:@"状态"];
    return headItem;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* logisticRecordCellId = @"LogisticRecordCell";
    LogisticRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:logisticRecordCellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"LogisticRecordCell" bundle:nil] forCellReuseIdentifier:logisticRecordCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:logisticRecordCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogisticRecordCell* detailItem = (LogisticRecordCell*)cell;
    if (self.datas.count>0) {
        self.logisticsVo = [self.datas objectAtIndex:indexPath.row];
        detailItem.lblSupplier.text = self.logisticsVo.supplyName;
        detailItem.lblPaper.text = self.logisticsVo.typeName;
        detailItem.lblStatus.text = self.logisticsVo.billStatusName;
        detailItem.lblPaperNo.text = [NSString stringWithFormat:@"单号：%@",self.logisticsVo.logisticsNo];
        if ([self.logisticsVo.recordType isEqualToString:@"a"]) {
            if (self.logisticsVo.billStatus==4||self.logisticsVo.billStatus==1) {
                detailItem.lblStatus.textColor = [ColorHelper getGreenColor];
            }else if (self.logisticsVo.billStatus==2) {
                detailItem.lblStatus.textColor = [ColorHelper getTipColor6];
            }else{
                detailItem.lblStatus.textColor = [ColorHelper getRedColor];
            }
        }else{
            if (self.logisticsVo.billStatus==4) {
                detailItem.lblStatus.textColor = [ColorHelper getBlueColor];
            }else if (self.logisticsVo.billStatus==1) {
                detailItem.lblStatus.textColor = [ColorHelper getGreenColor];
            }else if (self.logisticsVo.billStatus==2) {
                detailItem.lblStatus.textColor = [ColorHelper getTipColor6];
            }else{
                detailItem.lblStatus.textColor = [ColorHelper getRedColor];
            }
        }
    }
}

//查看单据详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.logisticsVo = [self.datas objectAtIndex:indexPath.row];
    LogisticRecordDetailView* detailView = [[LogisticRecordDetailView alloc] init];
    detailView.logisticsVo = self.logisticsVo;
    [self.navigationController pushViewController:detailView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    detailView = nil;
}





@end
