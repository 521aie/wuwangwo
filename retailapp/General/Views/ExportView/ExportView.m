//
//  ExportView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ExportView.h"
#import "NavigateTitle2.h"
#import "AlertBox.h"
#import "ServiceFactory.h"
#import "XHAnimalUtil.h"
#import "Platform.h"
#import "HttpEngine.h"
#import "LSEditItemText.h"

@interface ExportView ()<AlertBoxClient>

@property (nonatomic,strong) CommonService* commonService;
@property (nonatomic,strong) NSMutableDictionary *params;
@property (nonatomic,copy) NSString *url;
/**以showView形式显示视图的传 NO 以导航控制器push显示的传 YES*/
@property (nonatomic) BOOL isPush;
/** <#注释#> */
@property (nonatomic, strong) LSEditItemText *txtEmail;

// 导出表单
@property (nonatomic, strong) NSArray *exportList;/*<导出单列表>*/
@property (nonatomic, assign) NSInteger exportType;/*<导出的表单类型>*/

@property (nonatomic ,strong) NSDictionary *reportParam;/*<报表导出参数>*/
@end

@implementation ExportView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commonService = [ServiceFactory shareInstance].commonService;
    [self configTitle:@"导出" leftPath:Head_ICON_BACK rightPath:nil];
    [self configViews];
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    
    CGFloat y = kNavH;
    LSEditItemText *txtEmail = [LSEditItemText editItemText];
    txtEmail.ls_top = y;
    [txtEmail initLabel:@"邮箱" withHit:nil isrequest:YES type:UIKeyboardTypeEmailAddress];
    [txtEmail initData:[[Platform Instance] getkey:MAIL_PATH]];
    [self.view addSubview:txtEmail];
    self.txtEmail = txtEmail;
    
    y = y + txtEmail.ls_height;
    NSString *tipStr = @"提示：\n导出的报表将以Excel文件形式发送到您的邮箱，请填写您的常用邮箱，以确保顺利接收到邮件";
    UILabel *lbl = [LSViewFactor addExplainText:self.view text:tipStr y:y];
    
    y = y + lbl.ls_height;
    
    UIButton *btn = [LSViewFactor addGreenButton:self.view title:@"发送" y:y];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loaddatas:(int)fromViewTag {
    self.action = fromViewTag;
}

- (void)loadData:(NSMutableDictionary *)param withPath:(NSString *)urlPath
      withIsPush:(BOOL)isPush callBack:(ExportHandler)handler {
    self.exportType = -1;
    self.params = param;
    self.url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,urlPath];
    self.isPush = isPush;
    self.exportHandler = handler;
}

// 报表导出
- (void)reportExport:(NSDictionary *)param type:(NSInteger)exportType callBack:(ExportHandler)handler {
    self.exportType = -1;
    self.exportHandler = handler;
    self.action = exportType;
    self.reportParam = [NSMutableDictionary dictionaryWithDictionary:param];
    self.url = [NSString stringWithFormat:@"%@/goodsSalesReport/v1/export" ,API_ROOT];
}

// 库存模块相关导出
- (void)exportData:(NSArray *)arr type:(NSInteger)exportType CallBack:(ExportHandler)handler {
    
    self.exportList = arr;
    self.exportHandler = handler;
    self.exportType = exportType;
    
    if (exportType == ORDER_PAPER_TYPE)
    {
        self.url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderGoods/export"];
    }
    else if (exportType == PURCHASE_PAPER_TYPE)
    {
        self.url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"purchase/export"];
    }
    else if (exportType == RETURN_PAPER_TYPE)
    {
        self.url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"returnGoods/export"];
    }
    else if (exportType == ALLOCATE_PAPER_TYPE)
    {
        self.url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"allocate/export"];
    }
    else if (exportType == CLIENT_ORDER_PAPER_TYPE)
    {
        self.url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderGoods/export"];
    }
    else if (exportType == CLIENT_RETURN_PAPER_TYPE)
    {
        self.url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"returnGoods/export"];
    }
    else if (exportType == STOCK_ADJUST_PAPER_TYPE)
    {
        self.url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockAdjust/export"];
    }else if (exportType == COST_ADJUST_PAPER_TYPE) {//成本价调整
        self.url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"costPriceOpBills/export"];
    }
}


- (void)btnClick:(id)sender {
    
    if ([self isValid])
    {
        NSString *email = [self.txtEmail getStrVal];
        // 保存邮箱到plist
        [[Platform Instance] saveKeyWithVal:MAIL_PATH withVal:email];
        
        if (self.params) {
            
            [self.params setValue:email forKey:@"email"];
            [self.commonService exportInfo:self.params withUrl:self.url];
        }
        else if (self.exportList)
        {
            if (self.exportType == ORDER_PAPER_TYPE)
            {
                [self exportOrderGoods:@(1)];
            }
            else if (self.exportType == PURCHASE_PAPER_TYPE)
            {
                [self exportPurchase];
            }
            else if (self.exportType == RETURN_PAPER_TYPE)
            {
                [self exportReturnGoods:@(1)];
            }
            else if (self.exportType == ALLOCATE_PAPER_TYPE)
            {
                [self exportAllocate];
            }
            else if (self.exportType == CLIENT_ORDER_PAPER_TYPE)
            {
                [self exportOrderGoods:@(2)];
            }
            else if (self.exportType == CLIENT_RETURN_PAPER_TYPE)
            {
                [self exportReturnGoods:@(2)];
            }
            else if (self.exportType == STOCK_ADJUST_PAPER_TYPE)
            {
                [self exportStockAdjust];
            } else if (self.exportType == COST_ADJUST_PAPER_TYPE) {//成本价调整
                [self exportCostStockAdjust];
            }
            
        }
        else if (self.reportParam) {
            [self goodSaleReportExport];
        }
        [AlertBox show:@"正在导出中，请稍后在您的邮箱中查看！" client:self];
    }
}

#pragma mark - AlertBoxClient
- (void)understand {
    
    if (self.exportHandler) {
        self.exportHandler();
    }
}

#pragma save-data
- (BOOL)isValid {
    
    if ([NSString isBlank:[self.txtEmail getStrVal]]) {
        [AlertBox show:@"请填写导出邮箱地址!"];
        return NO;
    }
    if (![NSString isValidateEmail:[self.txtEmail getStrVal]]) {
        [AlertBox show:@"填写的邮箱格式不正确!"];
        return NO;
    }
    
    return YES;
}



- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
    
    if (event == LSNavigationBarButtonDirectLeft) {
        if (self.exportHandler) {
            self.exportHandler();
        }
    }
}



#pragma mark - 网络请求
/**
 * 叫货单 导出
 * 1: 采购叫货单
 * 2: 客户叫货单
 */
- (void)exportOrderGoods:(NSNumber *)type {
    
    NSDictionary *param = @{@"orderGoodsNoList" : self.exportList,
                            @"type" : type,
                            @"email" : [self.txtEmail getStrVal]};
    [[HttpEngine sharedEngine] postUrl:self.url params:param completionHandler:^(id json) {
        ;
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

/**
 *  退货单 导出
 *  type == 1 采购退货单
 *  type == 2 客户退货单
 */
- (void)exportReturnGoods:(NSNumber *)type {
    
    NSDictionary *param = @{@"returnGoodsIdList" : self.exportList,
                            @"type" : type,
                            @"email" : [self.txtEmail getStrVal]};
    [[HttpEngine sharedEngine] postUrl:self.url params:param completionHandler:^(id json) {
        ;
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

/**
 *  库存调整单 导出
 */
- (void)exportStockAdjust {
    
    NSDictionary *param = @{@"adjustcodeList" : self.exportList,
                            @"email" : [self.txtEmail getStrVal]};
    [[HttpEngine sharedEngine] postUrl:self.url params:param completionHandler:^(id json) {
        ;
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

/**
 *  成本价调整导出
 */
- (void)exportCostStockAdjust {
    
    NSDictionary *param = @{@"costPriceOpNoList" : self.exportList,
                            @"email" : [self.txtEmail getStrVal]};
    [[HttpEngine sharedEngine] postUrl:self.url params:param completionHandler:^(id json) {
        ;
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

/**
 *  收货单 导出
 */
- (void)exportPurchase {
    
    NSDictionary *param = @{@"stockInList" : self.exportList ,
                            @"email" : [self.txtEmail getStrVal]};
    [[HttpEngine sharedEngine] postUrl:self.url params:param completionHandler:^(id json) {
        ;
    } errorHandler:^(id json) {
       [AlertBox show:json];
    }];
}

/**
 *  调拨单 导出
 */
- (void)exportAllocate {
    
    NSDictionary *param = @{@"allocateIdList" : self.exportList ,
                            @"email" : [self.txtEmail getStrVal]};
    [[HttpEngine sharedEngine] postUrl:self.url params:param completionHandler:^(id json) {
        ;
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

/**
 *  报表商品销售报表 导出
 *  因为后台处理报表可能要好久，固没有给返回值，所以这里不要弹窗(请求超时，会默认有弹窗)
 */
- (void)goodSaleReportExport {
    [self.reportParam setValue:[self.txtEmail getStrVal] forKey:@"email"];
    [[HttpEngine sharedEngine] postUrl:self.url params:self.reportParam completionHandler:^(id json) {
        ;
    } errorHandler:^(id json) {
//        [AlertBox show:json];
    }];
}

@end
