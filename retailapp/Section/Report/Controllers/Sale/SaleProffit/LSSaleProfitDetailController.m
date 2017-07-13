//
//  LSSaleProfitDetailController.m
//  retailapp
//
//  Created by guozhi on 2017/1/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSaleProfitDetailController.h"
#import "OptionPickerClient.h"
#import "INameItem.h"
#import "XHAnimalUtil.h"
#import "LSEditItemView.h"
#import "UIHelper.h"
#import "MenuList.h"
#import "ExportView.h"
#import "NSString+Estimate.h"
#import "SelectShopListView.h"
#import "AlertBox.h"
#import "ServiceFactory.h"
#import "LSSaleRevenueSummaryVo.h"
#import "DateUtils.h"
#import "NameItemVO.h"
#import "OptionPickerBox.h"

@interface LSSaleProfitDetailController ()< OptionPickerClient>
@property (nonatomic, assign) NSInteger             shoptype;           /**1 门店用户登录查询 2机构用户登录查询*/
@property (strong, nonatomic) UIScrollView *scrollView;        //滚动栏
@property (strong, nonatomic) UIView       *container;         //滚动栏中子view容器
@property (strong, nonatomic) LSEditItemView *txtSaleShop;       //销售门店

@property (strong, nonatomic) LSEditItemView *txtSaleTime;       //销售时间
@property (strong, nonatomic) LSEditItemView *txtTotalAmount;    //总金额
@property (strong, nonatomic) LSEditItemView *txtTotalProfit;    //总利润
@property (strong, nonatomic) LSEditItemView *txtSaleAmount;     //销售金额
@property (strong, nonatomic) LSEditItemView *txtSaleNumber;     //销售数量
@property (strong, nonatomic) LSEditItemView *txtReturnAmount;   //退货金额
@property (strong, nonatomic) LSEditItemView *txtReturnNumber;   //退货数量
/** 配送费 */
@property (strong, nonatomic) LSEditItemView *vewOutFee;
/** 销售成本 */
@property (strong, nonatomic) LSEditItemView *vewSaleCost;
/** 毛利率 */
@property (strong, nonatomic) LSEditItemView *vewProfitRate;

@property (nonatomic ,strong) ReportService         *service;                       //报表网络服务                        //获取报表参数字典
@property (nonatomic, strong) LSSaleRevenueSummaryVo           *dayReportVo;                   //报表汇总信息
/** <#注释#> */
@property (nonatomic, strong) UILabel *lblInfo;

@end

@implementation LSSaleProfitDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configContainerViews];
    [self initData];
    [self loadData];
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //标题
    [self configTitle:@"销售收益报表" leftPath:Head_ICON_BACK rightPath:nil];
    //scollVIew
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    //container
    self.container = [[UIView alloc] init];
    self.container.ls_width = SCREEN_W;
    [self.scrollView addSubview:self.container];
}

- (void)configContainerViews {
    self.txtSaleShop = [LSEditItemView editItemView];
    [self.txtSaleShop initLabel:@"销售门店" withHit:nil];
    [self.container addSubview:self.txtSaleShop];
    
    self.txtSaleTime = [LSEditItemView editItemView];
    [self.txtSaleTime initLabel:@"销售时间" withHit:nil];
    [self.container addSubview:self.txtSaleTime];
    
    self.txtSaleNumber = [LSEditItemView editItemView];
    [self.txtSaleNumber initLabel:@"销售单数" withHit:nil];
    [self.container addSubview:self.txtSaleNumber];
    
    self.txtSaleAmount = [LSEditItemView editItemView];
    [self.txtSaleAmount initLabel:@"销售金额(元)" withHit:nil];
    [self.container addSubview:self.txtSaleAmount];
    
    self.txtReturnNumber = [LSEditItemView editItemView];
    [self.txtReturnNumber initLabel:@"退货单数" withHit:nil];
    [self.container addSubview:self.txtReturnNumber];
    
    self.txtReturnAmount = [LSEditItemView editItemView];
    [self.txtReturnAmount initLabel:@"退货金额(元)" withHit:nil];
    [self.container addSubview:self.txtReturnAmount];
    
    
    self.vewOutFee = [LSEditItemView editItemView];
    [self.vewOutFee initLabel:@"配送费(元)" withHit:nil];
    [self.container addSubview:self.vewOutFee];
    
    self.txtTotalAmount = [LSEditItemView editItemView];
    [self.txtTotalAmount initLabel:@"净销售额(元)" withHit:nil];
    [self.container addSubview:self.txtTotalAmount];
   
    self.vewSaleCost = [LSEditItemView editItemView];
    [self.vewSaleCost initLabel:@"销售成本(元)" withHit:nil];
    [self.container addSubview:self.vewSaleCost];
    
    self.txtTotalProfit = [LSEditItemView editItemView];
    [self.txtTotalProfit initLabel:@"销售毛利(元)" withHit:nil];
    [self.container addSubview:self.txtTotalProfit];
    
    self.vewProfitRate = [LSEditItemView editItemView];
    [self.vewProfitRate initLabel:@"毛利率(%)" withHit:nil];
    [self.container addSubview:self.vewProfitRate];
    
    [LSViewFactor addClearView:self.container y:0 h:10];
    NSString *text = @"提示:\n1.净销售额=销售金额-退货金额\n";
    self.lblInfo = [LSViewFactor addExplainText:self.container text:text y:0];
    
    UIButton *btn = [LSViewFactor addGreenButton:self.container title:@"导出详细明细" y:0];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];

}

- (void)initData{
    //单店非表示，连锁门店非表示；
    //连锁总部或机构查看全部销售报表时非表示；
    //连锁总部，查看微店销售报表时，显示“总部微店”；
    if ([[Platform Instance] getShopMode] != 3 || ([[Platform Instance] getShopMode] == 3 && [self.saleMode isEqualToString:@"全部"])) {
        [self.txtSaleShop visibal:NO];
    }
    //配送费：微店订单内配送费合计，限开通微店的情况下，查询微店订单、全部订单时显示
    [self.vewOutFee visibal:NO];
    self.lblInfo.text = @"提示:\n1.净销售额=销售金额-退货金额";
    self.lblInfo.textColor = [ColorHelper getTipColor6];
    if ([[Platform Instance] getMicroShopStatus] == 2) {//开通微店
        if ([self.saleMode isEqualToString:@"微店销售"] || [self.saleMode isEqualToString:@"全部"]) {
            [self.vewOutFee visibal:YES];
            self.lblInfo.text = @"提示:\n1.净销售额=销售金额-退货金额\n2.销售金额= 销售订单实收金额 - 配送费";
        }
    }
    [self.lblInfo sizeToFit];
    
    if ([[Platform Instance] getShopMode] == 3) {
        if ([[Platform Instance] isTopOrg] &&[self.saleMode isEqualToString:@"微店销售"]) {
            [self.txtSaleShop initData:@"总部微店"];
        } else {
            [self.txtSaleShop initData:_shopName];
        }
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}
#pragma mark - networ
//请求报表信息汇总
- (void)loadData{
    __strong typeof(self) wself = self;
    NSString *url = @"dayReport/v1/list";
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself responseReportTotal:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}
//报表信息汇总请求结果
- (void)responseReportTotal:(id)json{
    
    if ([ObjectUtil isNotNull:json[@"SaleRevenueSummary"]]) {
        self.dayReportVo = [LSSaleRevenueSummaryVo mj_objectWithKeyValues:json[@"SaleRevenueSummary"]];
    }
    
//    if ([[Platform Instance] getMicroDistributionStatus] != 1) {
        if ([[Platform Instance] isTopOrg] && [self.saleMode isEqualToString:@"微店销售"]) {
            [self.txtSaleShop initData:@"总部微店"];
            [self.txtSaleShop visibal:YES];
        }
        if (![[Platform Instance] isTopOrg] && [[Platform Instance] getShopMode] == 3) {
            [self.txtSaleShop initData:_shopName];
            [self.txtSaleShop visibal:YES];
        }
//    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
    _txtSaleTime.lblVal.text = _saleTime;
    //净销售额
    _txtTotalAmount.lblVal.text = [NSString stringWithFormat:@"%.2f",[self.dayReportVo.netSales doubleValue]];
    //销售毛利
    _txtTotalProfit.lblVal.text = [NSString stringWithFormat:@"%.2f",[self.dayReportVo.sellProfit doubleValue]];
    //销售金额
    _txtSaleAmount.lblVal.text = [NSString stringWithFormat:@"%.2f",[self.dayReportVo.saleAmount doubleValue]];
    //销售单数
    _txtSaleNumber.lblVal.text = [NSString stringWithFormat:@"%d",[self.dayReportVo.saleCount intValue]];
    //退货金额
    _txtReturnAmount.lblVal.text = [NSString stringWithFormat:@"%.2f",[self.dayReportVo.returnAmount doubleValue]];
    //退货单数
    _txtReturnNumber.lblVal.text = [NSString stringWithFormat:@"%d",[self.dayReportVo.returnCount intValue]];
    //配送费
    _vewOutFee.lblVal.text = [NSString stringWithFormat:@"%d",[self.dayReportVo.outFee intValue]];
    //销售成本
    _vewSaleCost.lblVal.text = [NSString stringWithFormat:@"%.2f",[self.dayReportVo.sellCost doubleValue]];
    //毛利率
    _vewProfitRate .lblVal.text = [NSString stringWithFormat:@"%.2f",[self.dayReportVo.profit doubleValue]];
    
    
}


#pragma mark - click 事件
- (void)btnClick:(id)sender {
    //导出页面
    NSMutableArray *items = [NSMutableArray array];
    NameItemVO *item = [[NameItemVO alloc] initWithVal:@"销售收益报表(无商品明细)" andId:@"1"];
    [items addObject:item];
    item = [[NameItemVO alloc] initWithVal:@"销售收益报表(有商品明细)" andId:@"2"];
    [items addObject:item];
    [OptionPickerBox initData:items itemId:nil];
    [OptionPickerBox show:@"报表类型选择" client:self event:0];
    
//    if (![self.saleMode isEqualToString:@"全部"]) {
//        //导出页面
//        NSMutableArray *items = [NSMutableArray array];
//        NameItemVO *item = [[NameItemVO alloc] initWithVal:@"销售收益报表(无商品明细)" andId:@"1"];
//        [items addObject:item];
//        item = [[NameItemVO alloc] initWithVal:@"销售收益报表(有商品明细)" andId:@"2"];
//        [items addObject:item];
//        [OptionPickerBox initData:items itemId:nil];
//        [OptionPickerBox show:@"报表类型选择" client:self event:0];
//    } else {
//        self.selectType = @"1";
//        [self showExportView];
//    }
    
}
- (void)showExportView {
    //1:无商品明细
    //2:有商品明细
    [self.param setValue:self.selectType forKey:@"exportType"];
    ExportView *vc = [[ExportView alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    //日报表
    [vc loadData:self.param withPath:@"dayReport/v1/export" withIsPush:YES callBack:^{
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    }];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;
    self.selectType = [item obtainItemId];
    if ([[item obtainItemId] isEqualToString:@"2"]) {//有商品明细
        long long startTime = [self.param[@"startTime"] longLongValue];
        long long endTime = [self.param[@"endTime"] longLongValue];
        if ((endTime- startTime)/(24*60*60) >=31) {
            // 若选择“销售收益报表（有商品明细）”
            // 需要判断查询的时间区域，如果超出了31天，报错误消息“导出销售收益报表的时间区间不能超过31天！
            [AlertBox show:@"导出销售收益报表的时间区间不能超过31天！"];
            return YES;
        }
        
    }
    [self showExportView];
    return YES;
    
}



@end
