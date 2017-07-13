//
//  LSGoodsSaleListController.m
//  retailapp
//
//  Created by guozhi on 2017/1/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSGoodsSaleListController.h"
#import "LSReportSaleDetailController.h"
#import "XHAnimalUtil.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "GoodsSalesReportVo.h"
#import "HeaderItem.h"
#import "GoodsRetailCell.h"
#import "ColorHelper.h"
#import "DateUtils.h"
#import "ExportView.h"
#import "SearchBar.h"
#import "SearchBar2.h"
#import "DatePickerBox.h"
#import "OptionPickerBox.h"
#import "ScanViewController.h"
#import "LSFooterView.h"
#import "LSSaleGoodsDetailVo.h"
#import "NameItemVO.h"

@interface LSGoodsSaleListController ()< LSScanViewDelegate ,UITableViewDataSource,UITableViewDelegate,LSFooterViewDelegate ,DatePickerClient ,OptionPickerClient>
@property (strong, nonatomic) SearchBar2 *searchBar2;
@property (strong, nonatomic) SearchBar *searchBar1;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LSFooterView *footView;/*<>*/
@property (nonatomic, strong) NSMutableArray *datas; /**<数据源>*/
@property (nonatomic, strong) NSArray *sortItems;/*<排序item>*/
@property (nonatomic, strong) NameItemVO *currentSortItem;/*<当前选择的排序策略>*/
@property (nonatomic, strong) NSNumber *goodsSum;
@property (nonatomic, assign) double amount;
@property (nonatomic, strong) NSString *keyWord;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic ,strong) NSNumber *totalSellProfit;/*<按商品销售 的所有商品销售毛利之和>*/
@end

@implementation LSGoodsSaleListController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
    [self configConstraints];
    [self loadData];
}

- (void)configSubViews {
    self.datas = [NSMutableArray array];
    self.currentPage = 1;
    self.datas = [[NSMutableArray alloc] init];
    
    [self configTitle:@"商品销售报表" leftPath:Head_ICON_BACK rightPath:nil];
    
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
    [self.footView initDelegate:self btnsArray:@[kFootScan,kFootExport,kFootSort]];
    [self.view addSubview:self.footView];
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

// 因为此处写死的排序类型，修改时注意一并修改相关内容如：currentSortItem
- (NSArray *)sortItems {
    if (!_sortItems) {
        _sortItems = @[[[NameItemVO alloc] initWithVal:@"净销量由高到低" andId:@"1"],
                       [[NameItemVO alloc] initWithVal:@"净销量由低到高" andId:@"2"],
                       [[NameItemVO alloc] initWithVal:@"净销售额由高到低" andId:@"3"],
                       [[NameItemVO alloc] initWithVal:@"净销售额由低到高" andId:@"4"],
                       [[NameItemVO alloc] initWithVal:@"销售毛利由高到低" andId:@"5"],
                       [[NameItemVO alloc] initWithVal:@"销售毛利由低到高" andId:@"6"],
                       [[NameItemVO alloc] initWithVal:@"退货量由高到低" andId:@"7"],
                       [[NameItemVO alloc] initWithVal:@"退货量由低到高" andId:@"8"]];
        self.currentSortItem = _sortItems.firstObject;
    }
    return _sortItems;
}

// LSFooterViewDelegate 扫码，导出，排序
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    
    if ([footerType isEqualToString:kFootScan]) {
        [self scanStart];
    } else if ([footerType isEqualToString:kFootExport]) {//导出
        //        long long startTime = [self.param[@"startTime"] longLongValue];
        //        long long endTime = [self.param[@"endTime"] longLongValue];
        //        if ((endTime- startTime)/(24*60*60) >=31) {
        //            [AlertBox show:@"导出商品销售报表的时间区间不能超过31天！"];
        //            return;
        //        }
        __strong typeof(self) strongSelf = self;
        ExportView *vc = [[ExportView alloc] init];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self.param];
        // 按商品统计，导出时传入列表请求返回的totalSellProfit
        if ([[self.param valueForKey:@"categoryType"] compare:@(3)] == NSOrderedSame) {
            [dic setValue:_totalSellProfit forKey:@"totalProfit"];
        }
        [vc reportExport:[dic copy] type:0 callBack:^{
            [strongSelf popToLatestViewController:kCATransitionFromBottom];
        }];
        [strongSelf pushController:vc from:kCATransitionFromTop];
    } else if ([footerType isEqualToString:kFootSort]) {
        [OptionPickerBox initData:self.sortItems itemId:self.currentSortItem.itemId];
        [OptionPickerBox show:@"商品排序" client:self event:0];
    }
}

// OptionPickerClient
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    if (selectObj) {
        self.currentSortItem = (NameItemVO *)selectObj;
        // 选择的排序方式，用作请求参数
        [self.param setValue:@(self.currentSortItem.itemId.integerValue) forKey:@"goodsSortType"];
        self.currentPage = 1;
        [self loadData];
    }
    return YES;
}

//  扫码
- (void)scanStart {
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

// LSScanViewDelegate
- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {//服鞋
        self.searchBar2.keyWordTxt.text = scanString;
    } else {//商超
        self.searchBar1.keyWordTxt.text= scanString;
    }
    [self imputFinish:scanString];
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [AlertBox show:message];
}

// ISearchBarEvent  输入完成
- (void)imputFinish:(NSString *)keyWord {
    self.currentPage = 1;
    self.keyWord = keyWord;
    [self loadData];
}

- (void)showUnautoEvent {
    NSDate *date = [NSDate date];
    [DatePickerBox setRight];
    [DatePickerBox show:@"选择时间" date:date client:self event:0];
    //    self.footView.labTime.text = @"正在\n生成中...";
}

- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event {    
    [AlertBox show:@"商品销售报表正在生成中，请稍后再查看!"];
    self.footView.hidden = NO;
    [DateUtils formateDate2:date];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[NSNumber numberWithLongLong:[DateUtils getStartTimeOfDate:date]] forKey:@"starttime"];
    [param setValue:[NSNumber numberWithLongLong:[DateUtils getEndTimeOfDate:date]] forKey:@"endtime"];
    [param setValue:self.param[@"shopType"] forKey:@"shopType"];
    NSString *shopId = self.param[@"shopId"];
    if ([NSString isNotBlank:shopId]) {
        [param setValue:shopId forKey:@"shopId"];
    }
    
    id companionId = self.param[@"companionId"];
    if ([ObjectUtil isNotNull:companionId]) {
        [param setValue:companionId forKey:@"companionId"];
        
    }
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
        if ([NSString isNotBlank:self.searchBar2.keyWordTxt.text]) {
            [param setValue:self.searchBar2.keyWordTxt.text forKey:@"keyWord"];
        }
        
    } else {
        if ([NSString isNotBlank:self.searchBar1.keyWordTxt.text]) {
            [param setValue:self.searchBar1.keyWordTxt.text forKey:@"keyWord"];
        }
    }
    NSString *url = @"dayReport/manuallyGeneratedDailyReport";
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
    return YES;
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderItem *headItem = [HeaderItem headerItem];
    NSString *goodsSum = nil;
    if ([_goodsSum.stringValue containsString:@"."]) {
        goodsSum = [NSString stringWithFormat:@"%.3f", _goodsSum.doubleValue];
    } else {
        goodsSum = [NSString stringWithFormat:@"%.f", _goodsSum.doubleValue];
        
    }
    
    [headItem initWithName:[NSString stringWithFormat:@"合计%@件，￥%.2f", goodsSum ?:@"0", _amount]];
    return headItem;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *goodsRetailCellId = @"GoodsRetailCell";
    GoodsRetailCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsRetailCellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"GoodsRetailCell" bundle:nil] forCellReuseIdentifier:goodsRetailCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:goodsRetailCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodsRetailCell *detailItem = (GoodsRetailCell *)cell;
    [detailItem visibleArrowImageView:YES];
    LSSaleGoodsDetailVo* item = self.datas[indexPath.row];
    if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
        detailItem.lblName.text = item.styleName;
        detailItem.lblCode.text = item.styleCode;
        detailItem.lblName.text = item.styleName;
    } else {
        detailItem.lblName.text = item.goodsName;
        detailItem.lblCode.text = item.barCode;
        detailItem.lblName.text = item.goodsName;
    }
    
    // 当前的排序类型
    NSInteger sortType = self.currentSortItem.itemId.integerValue;
    
    if (sortType == 5 || sortType == 6) {
        // 按“销售毛利”排序
        NSString *netSaleNum = [NSString stringWithFormat:@"净销量：%@", [[item.netSales stringValue] getNumberStringWithFractionDigits:3]];
        NSMutableAttributedString *netSaleNumAttr = [[NSMutableAttributedString alloc] initWithString:netSaleNum];
        [netSaleNumAttr setAttributes:@{NSForegroundColorAttributeName:[ColorHelper getRedColor]} range:NSMakeRange(4, netSaleNum.length-4)];
        detailItem.lblNetSales.attributedText = netSaleNumAttr;
        UIColor *color = nil;
        if (item.sellProfit.floatValue < 0) {
            color = [ColorHelper getGreenColor];
        } else {
            color = [ColorHelper getRedColor];
        }
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"销售毛利：￥%.2f", item.sellProfit.floatValue]];
        [attrString addAttribute:NSForegroundColorAttributeName
         
                           value:color
         
                           range:NSMakeRange(5, attrString.length - 5)];
        
        detailItem.lblNetAmount.attributedText = attrString;
        
    } else if (sortType == 7 || sortType == 8) {
        // 按"退货量"
        NSString *returnNum = [NSString stringWithFormat:@"退货数量：%@", [[item.returnNum stringValue] getNumberStringWithFractionDigits:3]?:@""];
        NSMutableAttributedString *netSaleNumAttr = [[NSMutableAttributedString alloc] initWithString:returnNum];
        [netSaleNumAttr setAttributes:@{NSForegroundColorAttributeName:[ColorHelper getRedColor]} range:NSMakeRange(5, returnNum.length-5)];
        detailItem.lblNetSales.attributedText = netSaleNumAttr;
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"退货率：%.2f%%", item.returnRate.floatValue]];
        [attrString addAttribute:NSForegroundColorAttributeName
         
                           value:[ColorHelper getRedColor]
         
                           range:NSMakeRange(4, attrString.length - 4)];
        
        detailItem.lblNetAmount.attributedText = attrString;
        
        
    } else {
        //  按“净销量”和“净销售额”排序
        NSString *netSaleNum = [NSString stringWithFormat:@"净销量：%@", [[item.netSales stringValue] getNumberStringWithFractionDigits:3]];
        NSMutableAttributedString *netSaleNumAttr = [[NSMutableAttributedString alloc] initWithString:netSaleNum];
        [netSaleNumAttr setAttributes:@{NSForegroundColorAttributeName:[ColorHelper getRedColor]} range:NSMakeRange(4, netSaleNum.length-4)];
        detailItem.lblNetSales.attributedText = netSaleNumAttr;
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"净销售额：￥%.2f", item.netAmount.floatValue]];
        [attrString addAttribute:NSForegroundColorAttributeName
         
                           value:[ColorHelper getRedColor]
         
                           range:NSMakeRange(5, attrString.length - 5)];
        
        detailItem.lblNetAmount.attributedText = attrString;
    }
    detailItem.lblPrice.hidden = YES;
    //    detailItem.lblPrice.text = [NSString stringWithFormat:@"￥%@", item.averagePrice];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSReportSaleDetailController *vc = [[LSReportSaleDetailController alloc] initWith:self.datas[indexPath.row]];
    [self pushController:vc from:kCATransitionFromRight];
}

#pragma mark - 网络请求

- (void)loadData {
    
    __strong typeof(self) strongSelf  = self;
    [self.param setValue:@(self.currentPage) forKey:@"currentPage"];
    if ([ObjectUtil isNull:self.currentSortItem]) {
        [self.param setValue:@(1) forKey:@"goodsSortType"]; // 默认按"净销量由高到低"排序
    }
    
    [self.param setValue:self.keyWord forKey:@"keyWord"];
    [BaseService getRemoteLSDataWithUrl:@"goodsSalesReport/v1/list" param:[self.param mutableCopy] withMessage:@"" show:YES CompletionHandler:^(id json) {
        _goodsSum = [json objectForKey:@"totalNetSales"];
        _amount = [[json objectForKey:@"totalNetAmount"] doubleValue];
        if ([[self.param valueForKey:@"categoryType"] compare:@(3)] == NSOrderedSame) {
            _totalSellProfit = [json valueForKey:@"totalSellProfit"];
        }
        if (strongSelf.currentPage == 1) {
            [strongSelf.datas removeAllObjects];
        }
        NSArray *reportVoList = [json objectForKey:@"saleGoodsDetailVoList"];
        if ([ObjectUtil isNotNull:reportVoList]) {
            [strongSelf.datas addObjectsFromArray:[LSSaleGoodsDetailVo saleGoodsDetailVoList:reportVoList]];
        }
        else {
            strongSelf.currentPage --;
        }
        [strongSelf.tableView reloadData];
        strongSelf.tableView.ls_show = YES;
        [strongSelf.tableView headerEndRefreshing];
        [strongSelf.tableView footerEndRefreshing];
        
    } errorHandler:^(id json) {
        strongSelf.currentPage --;
        [strongSelf.tableView headerEndRefreshing];
        [strongSelf.tableView footerEndRefreshing];
        [AlertBox show:json];
    }];
    
}



@end
