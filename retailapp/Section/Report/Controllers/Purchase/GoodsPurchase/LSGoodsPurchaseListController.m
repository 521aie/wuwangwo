//
//  LSGoodsPurchaseListController.m
//  retailapp
//
//  Created by guozhi on 2017/1/13.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSGoodsPurchaseListController.h"
#import "SearchBar.h"
#import "SearchBar2.h"
#import "LSFooterView.h"
#import "ScanViewController.h"
#import "XHAnimalUtil.h"
#import "LSGoodsPurchaseListCell.h"
#import "LSStockBalanceDetailController.h"
#import "LSRightFilterListView.h"
#import "LSGoodsPurchaseVo.h"
#import "ExportView.h"
#import "LSGoodsPurchaseDetailController.h"
#import "HeaderItem.h"
#import "DateUtils.h"
#import "CategoryVo.h"

@interface LSGoodsPurchaseListController ()< LSScanViewDelegate , ISearchBarEvent, UITableViewDataSource,UITableViewDelegate, LSFooterViewDelegate, LSRightFilterListViewDelegate>
@property (strong, nonatomic) SearchBar2 *searchBar2;
@property (strong, nonatomic) SearchBar *searchBar1;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LSFooterView *footView;
/**<数据源>*/
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger currentPage;
/** 总金额 */
@property (nonatomic, strong) NSNumber *totalAmount;
/** 总件数 */
@property (nonatomic, strong) NSNumber *totalNum;
@end

@implementation LSGoodsPurchaseListController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDatas];
    [self configSubViews];
    [self configConstraints];
    [self loadData];
}

- (void)configDatas {
    self.datas = [NSMutableArray array];
    self.currentPage = 1;
}

- (void)configSubViews {
    [self configTitle:@"商品采购报表" leftPath:Head_ICON_BACK rightPath:nil];
    
    self.searchBar1 = [SearchBar searchBar];
    [self.searchBar1 initDeleagte:self placeholder:@"条形码/简码/拼音码"];
    [self.view addSubview:self.searchBar1];
    
    self.searchBar2 = [SearchBar2 searchBar2];
    [self.searchBar2 initDelagate:self placeholder:@"名称/款号"];
    [self.view addSubview:self.searchBar2];
    
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
        self.searchBar1.hidden = YES;
    } else {
        self.searchBar2.hidden = YES;
    }
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    __strong typeof(self) wself = self;
    self.tableView.rowHeight = 88.0f;
    self.tableView.sectionHeaderHeight = 44.0;
    [self.tableView ls_addHeaderWithCallback:^{
        wself.currentPage = 1;
        [wself loadData];
    }];
    [self.tableView ls_addFooterWithCallback:^{
        wself.currentPage++;
        [wself loadData];
    }];
    self.tableView.tableFooterView = [ViewFactory generateFooter:60.0];
    [self.view addSubview:self.tableView];
    
    self.footView = [LSFooterView footerView];
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
        [self.footView initDelegate:self btnsArray:@[kFootExport]];
    } else {
        [self.footView initDelegate:self btnsArray:@[kFootScan,kFootExport]];
    }
    [self.view addSubview:self.footView];
    
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
        [LSRightFilterListView addFilterView:self.view type:LSRightFilterListViewTypeCategoryFirst delegate:self];
    } else {
        [LSRightFilterListView addFilterView:self.view type:LSRightFilterListViewTypeCategoryLast delegate:self];
    }
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    
    
    [self.searchBar1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.view);
        make.height.equalTo(44);
        make.top.equalTo(wself.view.top).offset(kNavH);
    }];
    
    [self.searchBar2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.view);
        make.height.equalTo(44);
        make.top.equalTo(wself.view.top).offset(kNavH);
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.top.equalTo(wself.searchBar1.bottom);
    }];
    
    [self.footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.height.equalTo(60);
    }];
}


- (void)loadData {
    __weak typeof(self) wself = self;
    [self.param setValue:@(self.currentPage) forKey:@"currPage"];
    NSString *url = @"goodsPurchase/list";
    
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        if (wself.currentPage == 1) {
            wself.totalNum = json[@"totalNum"];
            wself.totalAmount = json[@"totalAmount"];
            [wself.datas removeAllObjects];
        }
        NSArray *list = json[@"goodsPurchaseList"];
        if ([ObjectUtil isNotNull:list]) {
            NSArray *objs = [LSGoodsPurchaseVo mj_objectArrayWithKeyValuesArray:list];
            LSGoodsPurchaseVo *obj = [objs objectAtIndex:0];
            if (obj != nil) {
                //单店登录,有数据时
                if (self.entityIdExport == nil) {
                    self.shopIdExport = obj.shopId;
//                    self.entityIdExport = obj.entityId;
                    self.entityIdExport = obj.shopEntityId;
                }
            }
            [wself.datas addObjectsFromArray:objs];
        }
        [wself.tableView reloadData];
        wself.tableView.ls_show = YES;
    } errorHandler:^(id json) {
        wself.currentPage--;
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
        [LSAlertHelper showAlert:json];
    }];
}

#pragma mark - 导出事件
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootScan]) {
        [self scanStart];
    } else if ([footerType isEqualToString:kFootExport]) {//导出
        //点击【导出】，需要判断查询的时间区域，如果超出了31天， 报错误消息“导出商品采购报表的时间区间不能超过31天！”
        long long startTime = [self.param[@"startTime"] longLongValue];
        long long endTime = [self.param[@"endTime"] longLongValue];
        if ((endTime- startTime)/(24*60*60) >=31) {
            UIAlertView *alertView;
            if (alertView != nil) {
                [alertView dismissWithClickedButtonIndex:0 animated:NO];
                alertView = nil;
            }
            alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"导出商品采购报表的时间区间不能超过31天！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }else{
            [self showExportEvent];
        }
    }
}

- (void)showExportEvent {
    ExportView *vc = [[ExportView alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    [self.param removeObjectForKey:@"currPage"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param = self.param;
    
    //连锁登录时
    if ((self.shopTypeExport == 2)) {//2连锁登录的仓库
        [param setValue:@(2) forKey:@"type"];
        [param setValue:self.shopIdExport forKey:@"shopId"];
    }else{//连锁登录的门店/单店登录
        [param setValue:@(1) forKey:@"type"];
        if(self.entityIdExport != nil){//单店登录,有数据
            [param setValue:self.shopIdExport forKey:@"shopId"];
            [param setValue:self.entityIdExport forKey:@"shopEntityId"];
        }else{//单店登录,没数据
            
        }
    }
    
    [vc loadData:param withPath:@"goodsPurchase/export" withIsPush:YES callBack:^{
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    }];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

#pragma mark - 输入框代理
- (void)imputFinish:(NSString *)keyWord {
    [self.param setValue:keyWord forKey:@"keyWord"];
    self.currentPage = 1;
    [self loadData];
}

#pragma mark - 扫码代理
- (void)scanStart {
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

// LSScanViewDelegate
- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
        //服鞋
        self.searchBar2.keyWordTxt.text = scanString;
    } else {
        //商超
        self.searchBar1.keyWordTxt.text= scanString;
    }
    [self imputFinish:scanString];
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [LSAlertHelper showAlert:message];
}

- (void)rightFilterListView:(LSRightFilterListView *)rightFilterListView didSelectObj:(id<INameItem>)obj {
    self.currentPage = 1;
    [self.param setValue:[obj obtainItemId] forKey:@"categoryId"];
    [self loadData];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSGoodsPurchaseListCell *cell = [LSGoodsPurchaseListCell goodsPurchaseListCellWithTableView:tableView];
    LSGoodsPurchaseVo *obj = self.datas[indexPath.row];
    cell.obj = obj;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderItem *headItem = [HeaderItem headerItem];
    NSString *totalAmount = nil;
    if ([ObjectUtil isNotNull:self.totalAmount] && [ObjectUtil isNotNull:self.totalNum]) {
        if ([self.totalNum.stringValue containsString:@"."]) {
            if (self.totalAmount.doubleValue >= 0) {
                totalAmount = [NSString stringWithFormat:@"合计：%.3f件 ¥%.2f", self.totalNum.doubleValue, self.totalAmount.doubleValue];
            }else{
                totalAmount = [NSString stringWithFormat:@"合计：%.3f件 -¥%.2f", self.totalNum.doubleValue, -self.totalAmount.doubleValue];
            }
        } else {
            if (self.totalAmount.doubleValue >= 0) {
                totalAmount = [NSString stringWithFormat:@"合计：%.f件 ¥%.2f", self.totalNum.doubleValue, self.totalAmount.doubleValue];
            } else {
                totalAmount = [NSString stringWithFormat:@"合计：%.f件 -¥%.2f", self.totalNum.doubleValue, -self.totalAmount.doubleValue];
            }
        }
    }else{
        totalAmount = @"合计：0件 ¥0.00";
    }
    [headItem initWithName:totalAmount];
    return headItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSGoodsPurchaseVo *obj = self.datas[indexPath.row];
    NSNumber *startTime = self.param[@"startTime"];
    NSNumber *endTime = self.param[@"endTime"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:startTime forKey:@"startTime"];
    [param setValue:endTime forKey:@"endTime"];
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101
) {
        //服鞋
        [param setValue:obj.styleId forKey:@"styleId"];
    } else {
        //商超
        [param setValue:obj.goodsId forKey:@"goodsId"];
    }
    [param setValue:obj.shopId forKey:@"shopId"];
    
    NSString *supplier = [self.param objectForKey:@"supplierId"];
    if ([NSString isNotBlank:supplier]) {
         [param setValue:obj.supplierId forKey:@"supplierId"];
    }
   
    LSGoodsPurchaseDetailController *vc = [[LSGoodsPurchaseDetailController alloc] init];
    vc.param = param;
    vc.obj = obj;
    vc.time = [NSString stringWithFormat:@"%@~%@", [DateUtils formateTime2:startTime.longLongValue * 1000], [DateUtils formateTime2:endTime.longLongValue * 1000]];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

@end
