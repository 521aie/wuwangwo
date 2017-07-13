//
//  LSEmployeePerformanceListController.m
//  retailapp
//
//  Created by guozhi on 2016/11/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSGoodsTransactionFlowListController.h"
#import "LSMemberConsumeListController.h"
#import "XHAnimalUtil.h"
#import "LSGoodsTransactionFlowListCell.h"
#import "HeaderItem.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "MemberTransactionListVo.h"
#import "SVProgressHUD.h"
#import "DateUtils.h"
#import "SystemUtil.h"
#import "ExportView.h"
#import "LSOrderReportVo.h"
#import "Platform.h"
#import "BaseService.h"
#import "ObjectUtil.h"
#import "OptionPickerBox.h"
#import "NameItemVO.h"
#import "LSFooterView.h"
#import "LSGoodsTransactionFlowDetailController.h"
#import "SearchBar.h"
#import "ScanViewController.h"
@interface LSGoodsTransactionFlowListController ()<UITableViewDelegate, UITableViewDataSource, LSFooterViewDelegate, OptionPickerClient,ISearchBarEvent,LSScanViewDelegate>
/** 头部搜索*/
@property (nonatomic, strong) SearchBar *searchBar;
/** 表格 */
@property (nonatomic, strong)  UITableView *tableView;
/** 底部工具栏 */
@property (nonatomic, strong) LSFooterView *footerView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSNumber                  *lastTime;      //最后标识时间，用于分页
@property (nonatomic, strong) NSNumber                  *allSale;       //总金额，table header 显示
@property (nonatomic, strong) NSNumber                  *allcount;      //总单数，table header 显示
@property (nonatomic, copy  ) NSString                  *shopName;      //店铺名称
/**
 *  选中的类型id 主要用来报表导出时的区分
 */
@property (nonatomic,copy) NSString *selectId;
/**导出页面所需参数*/
@property (nonatomic, strong) NSMutableDictionary *exportParam;
/*
 * isAlert 参数 服鞋版增加以下需求：
 点击导出按钮时，如果查询的时间区间超过31天报错误信息“导出交易流水的销售时间区间不能超过31天！”
 导出销售明细报表时，需要同时导出交易流水报表
 */

@end

@implementation LSGoodsTransactionFlowListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configConatraints];
    [self loadData];
}

- (void)configViews {
    self.datas = [NSMutableArray array];
    self.view.backgroundColor = [UIColor clearColor];
    

    //数据源
    self.datas = [NSMutableArray array];
    //标题
    [self configTitle:@"商品交易流水报表" leftPath:Head_ICON_BACK rightPath:nil];

    
    self.searchBar = [SearchBar searchBar];
    [self.searchBar initDeleagte:self placeholder:@"单号"];
    if ([self.param objectForKey:@"code"]) {
        self.searchBar.keyWordTxt.text = [self.param objectForKey:@"code"];
    }
    [self.view addSubview:self.searchBar];
    
    //表格
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 88;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
    self.tableView.hidden = YES;
    __weak typeof(self) wself = self;
    [self.tableView ls_addHeaderWithCallback:^{
        wself.lastTime = nil;
        [wself loadData];
    }];
    [self.tableView ls_addFooterWithCallback:^{
        [wself loadData];
    }];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [ViewFactory generateFooter:HEIGHT_CONTENT_BOTTOM];
    
    //底部工具栏
    self.footerView = [LSFooterView footerView];
    [self.footerView initDelegate:self btnsArray:@[kFootScan,kFootExport]];
    [self.view addSubview:self.footerView];
    if (!self.showExport) {//员工业绩报表进到商品交易流水报表导出按钮不显示
        self.footerView.hidden = YES;
    }
    
}

- (void)configConatraints {
    __weak typeof(self) wself = self;
    //配置搜索框
    self.searchBar.frame = CGRectMake(0, 64, SCREEN_W, 48);
    //配置表格
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(wself.view);
        make.top.equalTo(wself.view.top).offset(112);
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
    [BaseService getRemoteLSDataWithUrl:self.url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        wself.tableView.hidden = NO;
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        if (wself.lastTime == nil) {
            wself.allSale = json[@"allSale"];//显示的是总的,只有第一页时,服务器才有数据返回
            wself.allcount = json[@"allcount"];
            [wself.datas removeAllObjects];
        }
        NSArray *list = json[@"orderReportVoList"];
        if ([wself.lastTime isEqual:[NSNull null]]) {
            [wself.tableView reloadData];
            wself.tableView.ls_show = YES;
            return ;
        }
        wself.lastTime = json[@"lastTime"];
        
        if ([ObjectUtil isNotEmpty:list]) {
            NSArray *arr = [LSOrderReportVo mj_objectArrayWithKeyValuesArray:list];
            [wself.datas addObjectsFromArray:arr];
        }
        [wself.tableView reloadData];
        wself.tableView.ls_show = YES;
    } errorHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [AlertBox show:json];
    }];
    
}

//使用时更新最后标识时间
- (NSMutableDictionary *)param {
    [_param removeObjectForKey:@"lastTime"];
    if ([ObjectUtil isNotNull:self.lastTime]) {
        [_param setValue:self.lastTime forKey:@"lastTime"];
    }
    return _param;
}

//获取导出参数
- (NSMutableDictionary *)exportParam {
    if (_exportParam == nil) {
        _exportParam = [[NSMutableDictionary alloc] init];
    }
    _exportParam = [NSMutableDictionary dictionaryWithDictionary:self.param];
    [_exportParam removeObjectForKey:@"lastTime"];
    [_exportParam removeObjectForKey:@"pageSize"];
    [_exportParam setValue:@(self.selectId.intValue) forKey:@"exportType"];
    return _exportParam;
}

#pragma mark - SearchBar
-(void)scanStart
{
    [self showSccanEvent];
}


#pragma mark - 导出事件
-(void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootExport]) {
        [self showExportEvent];
    }else if ([footerType isEqualToString:kFootScan]){
        [self showSccanEvent];
    }
}
- (void)showExportEvent {
    //导出页面
    NSMutableArray *items = [NSMutableArray array];
    NameItemVO *item = [[NameItemVO alloc] initWithVal:@"交易流水报表(无商品明细)" andId:@"1"];
    [items addObject:item];
    item = [[NameItemVO alloc] initWithVal:@"交易流水报表(有商品明细)" andId:@"2"];
    [items addObject:item];
    
    [OptionPickerBox initData:items itemId:nil];
    [OptionPickerBox show:@"报表类型选择" client:self event:0];
}

-(void)showSccanEvent
{
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

-(void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString
{
    if (scanString.length > 0) {
        self.searchBar.keyWordTxt.text = scanString;
        [self.param setValue:scanString forKey:@"code"];
        self.lastTime = nil;
        [self loadData];
    }
}

-(void)scanFail:(ScanViewController *)controller with:(NSString *)message
{
    
}


- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;
    self.selectId = [item obtainItemId];
    if ([self.selectId isEqualToString:@"2"]) {
        BOOL isAlert = NO;
        long long startTime = [self.param[@"startTime"] longLongValue];
        long long endTime = [self.param[@"endTime"] longLongValue];
        if ((endTime- startTime)/(1000.0*24*60*60) >=31) {
            isAlert = YES;
        }
        if (isAlert) {
            [AlertBox show:@"导出交易流水的销售时间区间不能超过31天！"];
            return YES;
        }

    }
    ExportView *vc = [[ExportView alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    [vc loadData:self.exportParam withPath:@"orderDetailsReport/v2/exportToExcel" withIsPush:YES callBack:^{
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    }];
    
    return YES;
}

#pragma mark - 输入结束
- (void)imputFinish:(NSString *)keyWord
{
    //判断是否输入了单号
    if (self.searchBar.keyWordTxt.text.length > 0) {
        [_param setValue:self.searchBar.keyWordTxt.text forKey:@"code"];
    }else{
        [_param setValue:@"" forKey:@"code"];
    }
    self.lastTime = nil;
    [self loadData];
}



#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSGoodsTransactionFlowListCell *cell = [LSGoodsTransactionFlowListCell goodsTransactionFlowListCellWithTableView:tableView];
    cell.orderReportVo = self.datas[indexPath.row];
    return cell;}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderItem *headItem = [HeaderItem headerItem];
    NSString *title = [NSString stringWithFormat:@"合计：%@单 ¥%.2f",self.allcount,[self.allSale doubleValue]];
    [headItem initWithName:title];
    return headItem;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSOrderReportVo *orderReportVo = self.datas[indexPath.row];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:orderReportVo.id forKey:@"orderId"];
    [param setValue:orderReportVo.orderKind forKey:@"orderKind"];
    [param setValue:self.param[@"shopId"] forKey:@"shopId"];
    [param setValue:self.param[@"shopEntityId"] forKey:@"shopEntityId"];
    if ([NSString isNotBlank:orderReportVo.id]) {
        [param setValue:self.param[@"searchType"] forKey:@"searchType"];
    } else {
        [param setValue:[NSNull null] forKey:@"searchType"];
    }
    [param setValue:self.param[@"entityId"] forKey:@"entityId"];
    LSGoodsTransactionFlowDetailController *vc = [[LSGoodsTransactionFlowDetailController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    vc.param = param;
    vc.salesTime = orderReportVo.salesTime;
    vc.orderKind = orderReportVo.orderKind;
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

@end
