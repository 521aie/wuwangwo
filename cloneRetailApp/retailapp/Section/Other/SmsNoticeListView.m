//
//  SmsNoticeListView.m
//  retailapp
//
//  Created by hm on 15/9/7.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SmsNoticeListView.h"
#import "NavigateTitle2.h"
#import "LSSmsMainCell.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "ServiceFactory.h"
#import "Notice.h"
#import "DateUtils.h"
#import "SmsNoticeDetailView.h"
#import "ColorHelper.h"

@interface SmsNoticeListView ()

@property (nonatomic,strong) SmsService *smsService;
//数据列表
@property (nonatomic,strong) NSMutableArray* dataList;
//机构或门店id
@property (nonatomic,copy) NSString *shopId;
//分页
@property (nonatomic,assign) NSInteger currentPage;
//开始时间
@property (nonatomic,assign) long long startTime;
//结束时间
@property (nonatomic,assign) long long endTime;

@end

@implementation SmsNoticeListView


- (void)viewDidLoad {
    [super viewDidLoad];
     self.smsService = [ServiceFactory shareInstance].smsService;
    [self initNavigate];
    self.dataList = [NSMutableArray array];
    self.shopId = ([[Platform Instance] getShopMode]==3)?[[Platform Instance] getkey:ORG_ID]:[[Platform Instance] getkey:SHOP_ID];
    self.currentPage = 1;
    NSString *time = [NSString stringWithFormat:@"%@ 00:00:00",[DateUtils formateDate2:[NSDate date]]];
    self.startTime = [DateUtils formateDateTime2:time] - 6*24*60*60*1000;
    self.endTime = [DateUtils formateDateTime2:time] + 24*60*60*1000;
    __weak typeof(self) weakSelf = self;
    //下拉刷新
    [self.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf selectNoticeList];
    }];
    //上拉加载
    [self.mainGrid ls_addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf selectNoticeList];
    }];
    [self selectNoticeList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 初始化导航
- (void)initNavigate
{
    [self configTitle:@"公告通知" leftPath:Head_ICON_BACK rightPath:nil];
}


#pragma mark -公告列表
- (void)selectNoticeList
{
    __weak typeof(self) weakSelf = self;
    [self.smsService selectNoticeList:self.shopId startTime:self.startTime endTime:self.endTime currentPage:self.currentPage completionHandler:^(id json) {
        NSArray *noticeList = [Notice converToArr:[json objectForKey:@"noticeList"]];
        if (weakSelf.currentPage==1) {
            [weakSelf.dataList removeAllObjects];
        }
        [weakSelf.dataList addObjectsFromArray:noticeList];
        weakSelf.spaceView.hidden = (weakSelf.dataList.count > 0);
        [weakSelf.mainGrid reloadData];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
}


#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSSmsMainCell *cell =  [LSSmsMainCell smsMainCellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataList!=nil&&self.dataList.count>0) {
        LSSmsMainCell* detailItem = (LSSmsMainCell*)cell;
        Notice *notice = [self.dataList objectAtIndex:indexPath.row];
        detailItem.lblName.text = notice.noticeTitle;
        detailItem.lblVal.text = notice.status==1?@"未读":@"已读";
        detailItem.lblVal.textColor = notice.status==1?[ColorHelper getBlueColor]:[ColorHelper getTipColor6];
        detailItem.lblDetail.text = [DateUtils formateTime:notice.publishTime];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Notice *notice = [self.dataList objectAtIndex:indexPath.row];
    SmsNoticeDetailView* smsNoticeDetailView = [[SmsNoticeDetailView alloc] init];
    __weak typeof(self) weakSelf = self;
    [smsNoticeDetailView loadDataWithId:notice.noticeId callBack:^{
        [weakSelf.mainGrid headerBeginRefreshing];
    }];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    [self.navigationController pushViewController:smsNoticeDetailView animated:NO];
    smsNoticeDetailView = nil;
}
@end
