//
//  LSReportSaleDetailController.m
//  retailapp
//
//  Created by taihangju on 2016/12/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSReportSaleDetailController.h"
#import "LSEditItemView.h"
#import "LSSaleGoodsDetailVo.h"

@interface LSReportSaleDetailController ()

@property (nonatomic ,strong) LSSaleGoodsDetailVo *detailVo;/*<商品销售报表详情vo>*/
@property (nonatomic ,strong) UIScrollView *scrollView;/*<>*/
/** <#注释#> */
@property (nonatomic, strong) UIView *container;
@property (nonatomic ,strong) LSEditItemView *goodName;/*<商品名称>*/
@property (nonatomic ,strong) LSEditItemView *barCode;/*<条形码>*/
@property (nonatomic ,strong) LSEditItemView *netSales;/*<净销量>*/
@property (nonatomic ,strong) LSEditItemView *netAmount;/*<净销售额>*/
@property (nonatomic ,strong) LSEditItemView *sellCost;/*<销售成本>*/
@property (nonatomic ,strong) LSEditItemView *averagePrice;/*<销售均价>*/
@property (nonatomic ,strong) LSEditItemView *sellProfit;/*<销售毛利>*/
@property (nonatomic ,strong) LSEditItemView *profitRatio;/*<毛利率>*/
@property (nonatomic ,strong) LSEditItemView *profit;/*<毛利比重>*/
@property (nonatomic ,strong) LSEditItemView *returnNum;/*<退货数量>*/
@property (nonatomic ,strong) LSEditItemView *returnAmount;/*<退货金额>*/
@property (nonatomic ,strong) LSEditItemView *returnRate;/*<退货率>*/
@end

@implementation LSReportSaleDetailController

- (instancetype)initWith:(LSSaleGoodsDetailVo *)vo {
    
    self = [super init];
    if (self) {
        self.detailVo = vo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self configSubviews];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}


- (void)configSubviews {
    [self configTitle:@"商品销售详情" leftPath:Head_ICON_BACK rightPath:nil];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H-kNavH)];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    
    // 商品名称
    self.goodName = [LSEditItemView editItemView];
    NSString *name = [NSString isNotBlank:self.detailVo.goodsName] ? self.detailVo.goodsName : self.detailVo.styleName;
    [self.goodName initLabel:@"商品名称" withHit:@""];
    [self.goodName initData:name];
    [self.container addSubview:self.goodName];
    // 条形码/款号
    self.barCode = [LSEditItemView editItemView];
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {
        // 服鞋
        [self.barCode initLabel:@"款号" withHit:nil];
        [self.barCode initData:self.detailVo.styleCode];
    } else {
        // 商超
        [self.barCode initLabel:@"条形码" withHit:nil];
        [self.barCode initData:self.detailVo.barCode];
    }
    
    [self.container addSubview:self.barCode];
    
    // 净销量
    self.netSales = [LSEditItemView editItemView];
    [self.netSales initLabel:@"净销量" withHit:nil];
    [self.netSales initData:[self.detailVo.netSales.stringValue getNumberStringWithFractionDigits:3]];
    [self.container addSubview:self.netSales];
    
    // 净销售额
    self.netAmount = [LSEditItemView editItemView];
    [self.netAmount initLabel:@"净销售额(元)" withHit:nil];
    [self.netAmount initData:[NSString stringWithFormat:@"%.2f" ,self.detailVo.netAmount.floatValue]];
    [self.container addSubview:self.netAmount];
    
    // 销售成本
    self.sellCost = [LSEditItemView editItemView];
    [self.sellCost initLabel:@"销售成本(元)" withHit:nil];
    [self.sellCost initData:[NSString stringWithFormat:@"%.2f" ,self.detailVo.sellCost.floatValue]];
    [self.container addSubview:self.sellCost];
    
    // 销售均价
    self.averagePrice = [LSEditItemView editItemView];
    [self.averagePrice initLabel:@"销售均价(元)" withHit:nil];
    [self.averagePrice initData:[NSString stringWithFormat:@"%.2f" ,self.detailVo.averagePrice.floatValue]];
    [self.container addSubview:self.averagePrice];
    
    // 销售毛利
    self.sellProfit = [LSEditItemView editItemView];
    [self.sellProfit initLabel:@"销售毛利(元)" withHit:nil];
    [self.sellProfit initData:[NSString stringWithFormat:@"%.2f" ,self.detailVo.sellProfit.floatValue]];
    [self.container addSubview:self.sellProfit];
    
    // 毛利率
    self.profitRatio = [LSEditItemView editItemView];
    [self.profitRatio initLabel:@"毛利率(%)" withHit:nil];
    [self.profitRatio initData:[NSString stringWithFormat:@"%.2f" ,self.detailVo.profitRatio.floatValue]];
    [self.container addSubview:self.profitRatio];
    
    // 毛利比重
    self.profit = [LSEditItemView editItemView];
    [self.profit initLabel:@"毛利比重(%)" withHit:nil];
    [self.profit initData:[NSString stringWithFormat:@"%.2f" ,self.detailVo.profit.floatValue]];
    [self.container addSubview:self.profit];
    
    // 退货数量
    self.returnNum = [LSEditItemView editItemView];
    [self.returnNum initLabel:@"退货数量" withHit:nil];
    [self.returnNum initData:self.detailVo.returnNum.stringValue];
    [self.container addSubview:self.returnNum];
    
    // 退货金额
    self.returnAmount = [LSEditItemView editItemView];
    [self.returnAmount initLabel:@"退货金额(元)" withHit:nil];
    [self.returnAmount initData:[NSString stringWithFormat:@"%.2f" ,self.detailVo.returnAmount.floatValue]];
    [self.container addSubview:self.returnAmount];
    
    // 退货率
    self.returnRate = [LSEditItemView editItemView];
    [self.returnRate initLabel:@"退货率(%)" withHit:nil];
    [self.returnRate initData:[NSString stringWithFormat:@"%.2f",self.detailVo.returnRate.floatValue]];
    [self.container addSubview:self.returnRate];
    NSString *text = @"提示:\n1. 净销售额=销售金额-退货金额\n2. 销售均价=净销售额/净销量\n3. 毛利比重=该产品的销售毛利/所有商品销售毛利之和*100\n4. 退货率=退货数量/销售数量*100";
    [LSViewFactor addExplainText:self.container text:text y:0];
    
    
   
}

@end
