//
//  LSSystemNotificationController.m
//  retailapp
//
//  Created by guozhi on 2016/11/3.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSystemNotificationController.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "LSSystemNotificationVo.h"
#import "LSSystemSmsCell.h"
#import "DateUtils.h"
#import "LSSystemNotificationVo.h"
#import "HeaderItem.h"

@interface LSSystemNotificationController ()< UITableViewDataSource, UITableViewDelegate ,LSSystemSmsCellDelegate>
/** 表格 */
@property (nonatomic, strong) UITableView *tableView;
/** 每页多少条数据 */
@property (nonatomic, assign) int pageSize;
/** 分页 */
@property (nonatomic, assign) int pageIndex;
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *param;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *datas;
/** <#注释#> */
@property (nonatomic, strong) NSMutableDictionary *map;
/** 日期数据源 */
@property (nonatomic, strong) NSMutableArray *dateList;
//@property (nonatomic ,assign) CGPoint saveLastContentOffSet;/*<保存的UITableView 的contentOffSet>*/
@property (nonatomic ,assign) double scrollVelocity;/*<tableView 滑动速率 points/millisecond>*/
@property (nonatomic ,strong) NSMutableArray *saveArray;/*<<#说明#>>*/
@end

@implementation LSSystemNotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configConstraints];
    [self.tableView headerBeginRefreshing];
}

- (void)configViews {
    self.view.backgroundColor = [UIColor clearColor];
    self.datas = [NSMutableArray array];
    self.map = [NSMutableDictionary dictionary];
    self.dateList = [NSMutableArray array];
    //配置标题栏
    [self configTitle:@"系统通知" leftPath:Head_ICON_BACK rightPath:nil];
    
    //配置表格
    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.decelerationRate = UIScrollViewDecelerationRateNormal;
    self.tableView.sectionHeaderHeight = 40.0; 
    self.tableView.estimatedRowHeight = 80.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.dataSource= self;
    self.tableView.delegate = self;
    self.pageSize = 20;
    self.pageIndex = 1;
    __weak typeof(self) wself = self;
    [self.tableView ls_addHeaderWithCallback:^{
        wself.pageIndex = 1;
        [wself loadData];
    }];
    [self.tableView ls_addFooterWithCallback:^{
        wself.pageIndex++;
        [wself loadData];
    }];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
}


- (void)configConstraints {
    __weak typeof(self) wself = self;
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.top.equalTo(wself.view).offset(kNavH);
    }];
}

- (void)loadData {
    
    __weak typeof(self) wself = self;
    NSString *url = @"get_sys_notification/v1/search_by_page";
    [BaseService getRemoteLSOutDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        NSString *userId = [[Platform Instance] getkey:USER_ID];
        NSString *notificationId = [[Platform Instance] getkey:NOFITICATION_ID];
        NSString *key = [NSString stringWithFormat:@"%@ %@ %@", SYSTEM_NOFITICATION, userId, notificationId];
        [[Platform Instance] saveKeyWithVal:key withVal:@"0"];//1是新消息 0不是新消息
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Message_Push  object:nil];
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        if (wself.pageIndex == 1) {
            [wself.datas removeAllObjects];
        }
        NSMutableArray *list = [LSSystemNotificationVo mj_objectArrayWithKeyValuesArray:json[@"data"]];
        [wself.datas addObjectsFromArray:list];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [wself.datas enumerateObjectsUsingBlock:^(LSSystemNotificationVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *date = [DateUtils formateChineseTime3:obj.createTime];
            [dict setValue:obj forKey:date];
        }];
        
        [wself.map removeAllObjects];
        [wself.dateList removeAllObjects];
        NSArray *dateList = [dict.allKeys sortedArrayUsingSelector:@selector(compare:)];
        [dateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [wself.dateList insertObject:obj atIndex:0];
        }];
        [wself.dateList enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableArray *list = [NSMutableArray array];
            [wself.datas enumerateObjectsUsingBlock:^(LSSystemNotificationVo *systemNotificationVo, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:[DateUtils formateChineseTime3:systemNotificationVo.createTime]]) {
                    [list addObject:systemNotificationVo];
                }
            }];
            [wself.map setValue:list forKey:obj];
        }];
        [wself.tableView reloadData];
    } errorHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [AlertBox show:json];
    }];
}

- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [NSMutableDictionary dictionary];
    }
    [_param setValue:@(self.pageSize) forKey:@"pageSize"];
    [_param setValue:@(self.pageIndex) forKey:@"pageIndex"];
    return _param;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dateList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *date = self.dateList[section];
    NSArray *datas = self.map[date];
    return datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSSystemSmsCell *cell = [LSSystemSmsCell systemSmsCellWithTableView:tableView];
    NSString *date = self.dateList[indexPath.section];
    NSArray *datas = self.map[date];
    cell.delegate = self;
    cell.systemNotificationVo = datas[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *date = self.dateList[section];
    HeaderItem *headerItem = [HeaderItem headerItem];
    [headerItem initWithName:date];
    return headerItem;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CFTimeInterval currentCallTime = CFAbsoluteTimeGetCurrent();
    static CFTimeInterval lastCallTime = 0;
    static double lastContentOffY = 0.0;
    if (lastCallTime && lastContentOffY != 0) {
        self.scrollVelocity = fabs((scrollView.contentOffset.y - lastContentOffY)/(currentCallTime - lastCallTime));
    }
    lastCallTime = currentCallTime;
    lastContentOffY = scrollView.contentOffset.y;
    
    if (scrollView.contentOffset.y <= 5.0 && self.saveArray.count > 0) {
        if (self.saveArray.count) {
            NSArray *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
            for (NSIndexPath *index in self.saveArray) {
                if ([visibleIndexPaths containsObject:index]) {
                    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationMiddle];
                }
            }
            [self.saveArray removeAllObjects];
        }
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (self.saveArray.count) {
        NSArray *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *index in self.saveArray) {
            if ([visibleIndexPaths containsObject:index]) {
                [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationMiddle];
            }
        }
        [self.saveArray removeAllObjects];
    }
}

- (void)needReloadVisibleCell:(UITableViewCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath) {
        if (!self.saveArray) {
            self.saveArray = [[NSMutableArray alloc] init];
        }
        [self.saveArray addObject:indexPath];
        if (self.scrollVelocity < 30.0) {
            NSArray *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
            for (NSIndexPath *index in self.saveArray) {
                if ([visibleIndexPaths containsObject:index]) {
                    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationMiddle];
                }
            }
            [self.saveArray removeAllObjects];
        }
    }
    self.scrollVelocity = 0.0;
}

@end
