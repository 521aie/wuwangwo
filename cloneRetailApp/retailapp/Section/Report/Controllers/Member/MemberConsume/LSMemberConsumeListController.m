//
//  LSMemberConsumeListController.m
//  retailapp
//
//  Created by guozhi on 2017/1/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define CELL_HEIGHT 88.0
#define HEADER_HEIGHT 40
#import "LSMemberConsumeListController.h"
#import "XHAnimalUtil.h"
#import "MemberListCell.h"
#import "HeaderItem.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "MemberTransactionListVo.h"
#import "SVProgressHUD.h"
#import "DateUtils.h"
#import "SystemUtil.h"
#import "ExportView.h"
#import "ObjectUtil.h"
#import "LSMemberConsumeDetailController.h"
#import "LSFooterView.h"
#import "NameItemVO.h"
#import "OptionPickerBox.h"
@interface LSMemberConsumeListController ()<UITableViewDataSource,UITableViewDelegate,LSFooterViewDelegate, OptionPickerClient>
@property (strong, nonatomic) UITableView *tableView;
/**分页标志*/
@property (nonatomic, strong) NSNumber *lastTime;

/*会员交易时间月份数据*/
@property (nonatomic, strong) NSMutableArray *dates;
/*会员交易分类*/
@property (nonatomic, strong) NSMutableDictionary *dict;

@property (strong, nonatomic) LSFooterView *footView;
/**
 *  选中的类型id 主要用来报表导出时的区分
 */
@property (nonatomic,copy) NSString *selectId;
@end

@implementation LSMemberConsumeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configConstraints];
    [self loadData];
    
}

#pragma mark - 初始化导航栏

- (void)configViews {
    self.view.backgroundColor = [UIColor clearColor];
    [self configTitle:@"会员消费记录" leftPath:Head_ICON_BACK rightPath:nil];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [ViewFactory generateFooter:HEIGHT_CONTENT_BOTTOM];
    [self.tableView registerNib:[UINib nibWithNibName:@"MemberListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    __weak typeof(self) wself = self;
    [self.tableView ls_addHeaderWithCallback:^{
        wself.lastTime = nil;
        [wself loadData];
    }];
    [self.tableView ls_addFooterWithCallback:^{
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


#pragma mark - 导出按钮点击事件
// 去“导出会员消费信息”界面
- (void)showExportEvent {
    NSArray *list = @[[[NameItemVO alloc] initWithVal:@"会员消费记录（无商品明细）" andId:@"1"],
                      [[NameItemVO alloc] initWithVal:@"会员消费记录（有商品明细）" andId:@"2"]];
    [OptionPickerBox initData:list itemId:nil];
    [OptionPickerBox show:@"报表类型选择" client:self event:0];
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;
    self.selectId = [item obtainItemId];
    if ([self.selectId isEqualToString:@"2"]) {
        BOOL isAlert = NO;
        long long startTime = [self.param[@"dateFrom"] longLongValue];
        long long endTime = [self.param[@"dateTo"] longLongValue];
        if ((endTime- startTime)/(1000.0*24*60*60) >=31) {
            isAlert = YES;
        }
        if (isAlert) {
            [AlertBox show:@"导出会员消费记录的时间区间不能超过31天！"];
            return YES;
        }
        
    }
    [self.exportParam setValue:@([[item obtainItemId] intValue]) forKey:@"exportType"];
    ExportView *vc = [[ExportView alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    [vc loadData:self.exportParam withPath:@"customerDeal/exportExcel" withIsPush:YES callBack:^{
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    }];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    return YES;
}

#pragma mark - 表的数据源
- (NSMutableArray *)dates {
    if (_dates == nil) {
        _dates = [[NSMutableArray alloc] init];
    }
    return _dates;
}

#pragma mark - 会员交易流水参数
- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [[NSMutableDictionary alloc] init];
    }
    if (self.lastTime == nil) {
        [_param setValue:@(0) forKey:@"lastTime"];
    } else {
        [_param setValue:self.lastTime forKey:@"lastTime"];
    }
    return _param;
}


#pragma mark - 加载数据
- (void)loadData {
    
    __weak typeof(self) strongSelf = self;
    NSString *url = @"customerDeal/dealList";
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [strongSelf.tableView headerEndRefreshing];
        [strongSelf.tableView footerEndRefreshing];
        if (strongSelf.lastTime == nil) {
            [strongSelf.dates removeAllObjects];
            [strongSelf.dict removeAllObjects];
        }
        
        NSArray *map = json[@"dealRecordList"];
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        if (!(map == nil || [map isEqual:[NSNull null]] || [map count] == 0)) {
            for (NSDictionary *dict in map) {
                MemberTransactionListVo *memberTransactionListVo = [MemberTransactionListVo memberTranscationVo:dict];
                [tempArray addObject:memberTransactionListVo];
            }
            
            if (!strongSelf.dict) {
                strongSelf.dict = [[NSMutableDictionary alloc] init];
            }
            
            for (MemberTransactionListVo *memberTransactionListVo in tempArray) {
                
                NSString *time = [DateUtils formateChineseTime4:[memberTransactionListVo.createTime longLongValue]];
                NSMutableArray *array = [self.dict objectForKey:time];
                
                if (!array) {
                    array = [[NSMutableArray alloc] init];
                    [self.dict setValue:array forKey:time];
                    [self.dates addObject:time];
                }
                [array addObject:memberTransactionListVo];
            }
        }
        
        [strongSelf.tableView reloadData];
        strongSelf.tableView.ls_show = YES;
        strongSelf.lastTime = json[@"lastTime"];
        
    } errorHandler:^(id json) {
        [strongSelf.tableView headerEndRefreshing];
        [strongSelf.tableView footerEndRefreshing];
        [AlertBox show:json];
    }];
    
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dates.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = [self.dict objectForKey:self.dates[section]];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSArray *memberTransactionVos = [self.dict objectForKey:self.dates[indexPath.section]];
    [cell initDataWithMemberTransactionListVo:memberTransactionVos[indexPath.row]];
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
    MemberTransactionListVo *memberTransactionListVo = [self.dict objectForKey:self.dates[indexPath.section]][indexPath.row];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:memberTransactionListVo.orderId forKey:@"orderId"];
    // 会员服务化新加参数
    [param setValue:memberTransactionListVo.shopEntityId forKey:@"shopEntityId"];
    [param setValue:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
    [param setValue:memberTransactionListVo.orderKind forKey:@"orderKind"];
    LSMemberConsumeDetailController *vc = [[LSMemberConsumeDetailController alloc] init];
    vc.param = param;
    vc.shopName = self.shopName;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}


@end
