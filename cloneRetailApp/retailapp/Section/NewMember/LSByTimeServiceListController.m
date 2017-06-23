//
//  LSByTimeServiceListController.m
//  retailapp
//
//  Created by taihangju on 2017/4/5.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSByTimeServiceListController.h"
#import "NavigateTitle2.h"
#import "LSByTimeServiceCell.h"
#import "LSByTimeServiceVo.h"
#import "MobClick.h"


static NSString *byTimeServiceCellReuseId = @"LSByTimeServiceCell";
@interface LSByTimeServiceListController ()<UITableViewDelegate, UITableViewDataSource, INavigateEvent>

@property (nonatomic, assign) LSByTimeServiceType type;/**<>*/
@property (nonatomic, strong) NavigateTitle2 *titleBox;/**<>*/
@property (nonatomic, strong) UITableView *tableView;/**<>*/
@property (nonatomic, strong) NSMutableArray *dataList;/**<计次服务vo列表>*/
@property (nonatomic, strong) NSNumber *lastDateTime;/**<最后一条记录时间：用于分页>*/
@property (nonatomic, strong) LSByTimeServiceVo *lastedServiceVo;/**<记录上个点击查看详情按钮的LSByTimeServiceVo>*/
@property (nonatomic, strong) NSString *cardId;/**<会员卡id>*/
@end

@implementation LSByTimeServiceListController

- (instancetype)initWithListType:(LSByTimeServiceType)type cardId:(NSString *)cardId {
    
    self = [super init];
    if (self) {
        _type = type;
        _cardId = cardId;
        _lastDateTime = nil;
        _dataList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubviews];
    [_tableView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configSubviews {
    
    NSString *title = _type == LSByTimeServiceExpired ? @"已失效的计次服务" :@"计次服务";
    _titleBox = [NavigateTitle2 navigateTitle:self];
    [_titleBox initWithName:title backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:_titleBox];
    
    CGFloat tableHeight = _type == LSByTimeServiceExpired ? SCREEN_H-_titleBox.ls_bottom: SCREEN_H-_titleBox.ls_bottom-45;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _titleBox.ls_bottom, SCREEN_W, tableHeight) style:UITableViewStylePlain];
    [_tableView registerNib:[UINib nibWithNibName:@"LSByTimeServiceCell" bundle:nil] forCellReuseIdentifier:byTimeServiceCellReuseId];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    NSString *emptyNoticeText = _type == LSByTimeServiceNotExpired ? @"会员卡内没有有效的计次服务！" : @"没有失效的计次服务！";
    [_tableView emptyNoticeImage:@"ico_noByTimeCard" noticeText:emptyNoticeText];
    _tableView.estimatedRowHeight = 200.0f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
   
    [self tryShowExpiredNotceTableFooterView];
    
    __weak typeof(self) weakSelf = self;
    [weakSelf.tableView ls_addHeaderWithCallback:^{
        weakSelf.lastDateTime = nil;
        [weakSelf requestByTimeServiceList];
    }];
    
    [weakSelf.tableView ls_addFooterWithCallback:^{
        [weakSelf requestByTimeServiceList];
    }];
}

// 是否显示“查看已失效的计次服务”
- (void)tryShowExpiredNotceTableFooterView {
    
    if (_type == LSByTimeServiceNotExpired) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(toExpiredListView) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(10, SCREEN_H-45, SCREEN_W-20, 45);
        [button setTitle:@"查看已失效的计次服务>>" forState:0];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.79] forState:0];
        [self.view addSubview:button];
//        _tableView.tableFooterView = [ViewFactory generateFooter:45];
    }
}

// 进入”已过期的计次服务“页面
- (void)toExpiredListView {
    
    [MobClick event:@"Member_InvalidByTimeService_In"];
    LSByTimeServiceListController *expiredVc = [[LSByTimeServiceListController alloc] initWithListType:LSByTimeServiceExpired cardId:_cardId];
    [self pushController:expiredVc from:kCATransitionFromRight];
}

// 处理 LSByTimeServiceCell “查看详情” 操作
- (void)dealCellDetailChecking:(LSByTimeServiceVo *)vo {
    
    if (vo.goodsArray) {
        
//        self.tableView.footerHidden = YES;
        
        // 存在展开记次商品的cell，进行隐藏
        if (![vo isEqual:self.lastedServiceVo]) {
            self.lastedServiceVo.isExpand = NO;
        }
        
        NSIndexPath *cIndexPath = [NSIndexPath indexPathForRow:[_dataList indexOfObject:vo] inSection:0];
        [self.tableView beginUpdates];
        
        if (cIndexPath) {
            [self.tableView reloadRowsAtIndexPaths:@[cIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        if (![_lastedServiceVo isEqual:vo]) {
            NSIndexPath *lastedIndexpath = [NSIndexPath indexPathForRow:[_dataList indexOfObject:_lastedServiceVo] inSection:0];
            if (lastedIndexpath) {
                [self.tableView reloadRowsAtIndexPaths:@[lastedIndexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
        [self.tableView endUpdates];
        
        if (cIndexPath) {
             [self.tableView scrollToRowAtIndexPath:cIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        
        self.lastedServiceVo = vo;
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//           
//            [self.tableView setNeedsDisplay];
//             self.tableView.footerHidden = NO;
//        });
        
    } else {
       
        [self getByTimeGoods:vo];
    }
}

#pragma mark - 相关协议方法 -

// INavigateEvent
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        [self popToLatestViewController:kCATransitionFromLeft];
    }
}

// UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LSByTimeServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:byTimeServiceCellReuseId];
    LSByTimeServiceVo *serviceVo = _dataList[indexPath.row];
    BOOL isExpiry = _type == LSByTimeServiceExpired;
   
    __weak typeof(self) wself = self;
    [cell fillCellData:serviceVo expired:isExpiry callBackBlock:^{
        
        [wself dealCellDetailChecking:serviceVo];
    }];
    return cell;
}


#pragma mark - 网络请求 -

// 获取计次服务列表
- (void)requestByTimeServiceList {
 
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (_type == LSByTimeServiceNotExpired) {
        [param setObject:@"1" forKey:@"isExpiry"];
    } else {
        [param setObject:@"0" forKey:@"isExpiry"];
    }
    [param setValue:_cardId forKey:@"cardId"];
    [param setValue:_lastDateTime forKey:@"lastDateTime"];
    NSString *url = @"accountcard/memberAccountCardList";
    __weak typeof(self) wself = self;
    
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        
        
        if (wself.lastDateTime == nil) {
            [wself.dataList removeAllObjects];
        }
        
        if ([ObjectUtil isNotNull:json[@"lastDateTime"]]) {
            wself.lastDateTime = [json valueForKey:@"lastDateTime"];
        }
        
        NSArray *keyValuesArray = json[@"accountCardList"];
        if ([ObjectUtil isNotEmpty:keyValuesArray]) {
            NSArray *voArray = [LSByTimeServiceVo byTimeServiceVoListFromKeyValuesArray:keyValuesArray];
            [wself.dataList addObjectsFromArray:voArray];
        }
        
        [wself.tableView reloadData];
        wself.tableView.ls_show = YES;
        
    } errorHandler:^(id json) {
        
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [LSAlertHelper showAlert:json];
    }];
}


// 获取计次卡下的计次商品列表
- (void)getByTimeGoods:(LSByTimeServiceVo *)vo {
    
    NSString *url = @"accountcard/memberGoodsList";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:@{@"customerAccountCardId":vo.id} withMessage:nil show:YES CompletionHandler:^(id json) {
        
        NSArray *keyValuesList = [json valueForKey:@"goodsList"];
        if (keyValuesList.count > 0) {
            vo.goodsArray = [LSByTimeGoodVo byTimeGoodVoListFromKeyValuesArray:keyValuesList];
            [wself dealCellDetailChecking:vo];
        }
        
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}


- (void)dealloc {
    NSLog(@"%@： 被释放了\n",self);
}
@end
