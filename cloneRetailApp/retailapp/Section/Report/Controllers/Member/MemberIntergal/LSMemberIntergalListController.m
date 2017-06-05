//
//  LSMemberIntergalListController.m
//  retailapp
//
//  Created by guozhi on 2017/1/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define CELL_HEIGHT 88
#define HEADER_HEIGHT 40
#import "LSMemberIntergalListController.h"
#import "XHAnimalUtil.h"
#import "MemberListCell.h"
#import "HeaderItem.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "SVProgressHUD.h"
#import "DateUtils.h"
#import "LSMemberIntergalDetailController.h"
#import "SystemUtil.h"
#import "LSFooterView.h"
#import "ExportView.h"
#import "MemberIntegralListVo.h"
@interface LSMemberIntergalListController ()<UITableViewDataSource,UITableViewDelegate,LSFooterViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) LSFooterView *footView;
/**分页标志*/
@property (nonatomic, assign) NSInteger pageNum;
/**会员积分兑换记录日期数*/
@property (nonatomic, strong) NSMutableArray *dates;
/**会员积分兑换数据源*/
@property (nonatomic, strong) NSMutableDictionary *dict;
@end

@implementation LSMemberIntergalListController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNum = 1;
    [self configViews];
    [self configConstraints];
    [self loadData];
    
}
- (void)configViews {
    self.view.backgroundColor = [UIColor clearColor];
    [self configTitle:@"会员积分兑换记录" leftPath:Head_ICON_BACK rightPath:nil];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    __weak typeof(self) wself = self;
    self.tableView.tableFooterView = [ViewFactory generateFooter:HEIGHT_CONTENT_BOTTOM];
    [self.tableView registerNib:[UINib nibWithNibName:@"MemberListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView ls_addHeaderWithCallback:^{
        wself.pageNum = 1;
        [wself loadData];
    }];
    [self.tableView ls_addFooterWithCallback:^{
        wself.pageNum += 1;
        [wself loadData];
    }];

    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootExport]];
    [self.view addSubview:self.footView];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.top.equalTo(wself.view.top).offset(kNavH);
    }];
    
    [self.footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.height.equalTo(60);
    }];
}



- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootExport]) {
        [self showExportEvent];
    }
}

#pragma mark - 点击导出事件
- (void)showExportEvent {
    ExportView *vc = [[ExportView alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    [vc loadData:self.exportParam withPath:@"customerExchange/exportExcel" withIsPush:YES callBack:^{
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    }];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}


#pragma mark - 查询会员积分兑换记录所需参数
- (NSMutableDictionary *)param {
    
    [_param setValue:@(_pageNum) forKey:@"pageNum"];
    return _param;
}

#pragma mark - 加载数据
- (void)loadData {
    __weak typeof(self) wself = self;
    NSString *url = @"customerExchange/exchangeList";
     [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        if (wself.pageNum == 1) {
            [self.dates removeAllObjects];
            [wself.dict removeAllObjects];
        }
        
        if (!wself.dict) {
            wself.dict = [[NSMutableDictionary alloc] init];
        }
        
        if (!wself.dates) {
            wself.dates = [[NSMutableArray alloc] init];
        }
        
        NSArray *map = json[@"exchangeFlowList"];
        if ([ObjectUtil isNotEmpty:map]) {
            
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (NSDictionary *obj in map) {
                MemberIntegralListVo *memberIntegralListVo = [[MemberIntegralListVo alloc] initWithDictionary:obj];
                [tempArray addObject:memberIntegralListVo];
            }
            
            for (MemberIntegralListVo *memberIntegralListVo in tempArray) {
                
                NSString *time = [DateUtils getTimeStringFromCreaateTime:memberIntegralListVo.createtime.stringValue format:@"yyyy年MM月"];
                NSMutableArray *arr1 = [self.dict objectForKey:time];
                if (!arr1) {
                    arr1 = [[NSMutableArray alloc] init];
                    [self.dict setValue:arr1 forKey:time];
                    [self.dates addObject:time];
                }
                [arr1 addObject:memberIntegralListVo];
            }
        }
        else {
            wself.pageNum = MAX(1, --wself.pageNum);
        }
        [wself.tableView reloadData];
        wself.tableView.ls_show = YES;
        
    } errorHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        wself.pageNum = MAX(1, --wself.pageNum);
        [AlertBox show:json];
    }];
    
}

#pragma mark - UItableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dates.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = [self.dict objectForKey:self.dates[section]];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSArray *memberIntegralListVos = [self.dict objectForKey:self.dates[indexPath.section]];
    [cell initDataWithMemberIntegralListVo:memberIntegralListVos[indexPath.row]];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderItem *headItem = [HeaderItem headerItem];
    [headItem initWithName:self.dates[section]];
    return headItem;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    return CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HEADER_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberIntegralListVo *memberIntegralListVo = [self.dict objectForKey:self.dates[indexPath.section]][indexPath.row];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:memberIntegralListVo.giftexchangeid forKey:@"giftexchangeId"];
    [param setValue:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
    LSMemberIntergalDetailController *vc = [[LSMemberIntergalDetailController alloc] init];
    vc.param = param;
    vc.shopName = self.shopName;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

@end
