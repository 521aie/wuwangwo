//
//  LSEmployeeCommissionDetailController.m
//  retailapp
//
//  Created by guozhi on 2017/1/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSEmployeeCommissionDetailController.h"
#import "XHAnimalUtil.h"
#import "UIHelper.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "ViewFactory.h"
#import "Platform.h"
#import "NSString+Estimate.h"
#import "LSEditItemView.h"
#import "DateUtils.h"
#import "LSEmployeeCommissionVo.h"
#import "LSEditItemTitle.h"

@interface LSEmployeeCommissionDetailController ()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) LSEditItemView *vewUserName;
@property (strong, nonatomic) LSEditItemView *vewStaffId;
@property (strong, nonatomic) LSEditItemView *vewRoleName;
@property (strong, nonatomic) LSEditItemView *vewShopName;
@property (strong, nonatomic) LSEditItemView *vewResultAmount;
@property (strong, nonatomic) LSEditItemView *vewOrderNumber;
@property (strong, nonatomic) LSEditItemView *vewReturnAmount;
@property (strong, nonatomic) LSEditItemView *vewReturnOrderNumber;
/** 基本信息 */
@property (strong, nonatomic) LSEditItemTitle *baseTitle;
/** 提成信息 */
@property (strong, nonatomic) LSEditItemTitle *commissionTitle;
/** 提成金额 */
@property (strong, nonatomic) LSEditItemView *vewCommission;
/** 净销售额 */
@property (strong, nonatomic) LSEditItemView *vewNetSale;
@end

@implementation LSEmployeeCommissionDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configContainerViews];
    [self initData];
}
- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //标题
    [self configTitle:@"提成详情" leftPath:Head_ICON_BACK rightPath:nil];
    //scollVIew
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    //container
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
}



- (void)configContainerViews {
    self.baseTitle = [LSEditItemTitle editItemTitle];
    [self.baseTitle configTitle:@"基本信息"];
    [self.container addSubview:self.baseTitle];
    
    self.vewUserName = [LSEditItemView editItemView];
    [self.vewUserName initLabel:@"员工姓名" withHit:nil];
    [self.container addSubview:self.vewUserName];
    
    self.vewStaffId = [LSEditItemView editItemView];
    [self.vewStaffId initLabel:@"员工工号" withHit:nil];
    [self.container addSubview:self.vewStaffId];
    
    self.vewRoleName = [LSEditItemView editItemView];
    [self.vewRoleName initLabel:@"员工角色" withHit:nil];
    [self.container addSubview:self.vewRoleName];
    
    self.vewShopName = [LSEditItemView editItemView];
    [self.vewShopName initLabel:@"所属门店" withHit:nil];
    [self.container addSubview:self.vewShopName];
    
    self.vewCommission = [LSEditItemView editItemView];
    [self.vewCommission initLabel:@"提成金额(元)" withHit:nil];
    self.vewCommission.lblVal.textColor = [ColorHelper getRedColor];
    [self.container addSubview:self.vewCommission];
    
    [LSViewFactor addClearView:self.container y:0 h:20];
    
    self.commissionTitle = [LSEditItemTitle editItemTitle];
    [self.commissionTitle configTitle:@"提成业绩"];
    [self.container addSubview:self.commissionTitle];
    
    self.vewNetSale = [LSEditItemView editItemView];
    [self.vewNetSale initLabel:@"净销售额(元)" withHit:nil];
    [self.container addSubview:self.vewNetSale];
    
    self.vewOrderNumber = [LSEditItemView editItemView];
    [self.vewOrderNumber initLabel:@"销售单数" withHit:nil];
    [self.container addSubview:self.vewOrderNumber];
    
    self.vewResultAmount = [LSEditItemView editItemView];
    [self.vewResultAmount initLabel:@"销售金额(元)" withHit:nil];
    [self.container addSubview:self.vewResultAmount];
    
    self.vewReturnOrderNumber = [LSEditItemView editItemView];
    [self.vewReturnOrderNumber initLabel:@"退货单数" withHit:nil];
    [self.container addSubview:self.vewReturnOrderNumber];
    
    self.vewReturnAmount = [LSEditItemView editItemView];
    [self.vewReturnAmount initLabel:@"退货金额(元)" withHit:nil];
    [self.container addSubview:self.vewReturnAmount];
    
   
    
    
    
   
    if ([[Platform Instance] getShopMode] == 1) {
        [self.vewShopName visibal:NO];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];

}


- (void)initData{
    [self.vewUserName initData:self.employeeCommissionVo.staffName];
    [self.vewStaffId initData:self.employeeCommissionVo.staffId ];
    [self.vewRoleName initData:self.employeeCommissionVo.staffRole];
    [self.vewShopName initData:self.shopName];
    //提成金额
    if (self.employeeCommissionVo.commissionAmount.doubleValue < 0) {
        self.vewCommission.lblVal.textColor = [ColorHelper getGreenColor];
    } else {
        self.vewCommission.lblVal.textColor = [ColorHelper getRedColor];
    }
    [self.vewCommission initData:[NSString stringWithFormat:@"%.2f",[self.employeeCommissionVo.commissionAmount doubleValue]]];
    //净销售额
    [self.vewNetSale initData:[NSString stringWithFormat:@"%.2f",[self.employeeCommissionVo.netSalesAmount doubleValue]]];
    //销售单数
    [self.vewOrderNumber initData:[NSString stringWithFormat:@"%@",self.employeeCommissionVo.saleOrderCount]];
    //销售金额(元)
    [self.vewResultAmount initData:[NSString stringWithFormat:@"%.2f",[self.employeeCommissionVo.saleAmount doubleValue]]];
    //退货金额(元)
    [self.vewReturnAmount initData:[NSString stringWithFormat:@"%.2f",[self.employeeCommissionVo.returnAmount doubleValue]]];
    //退货数量
    [self.vewReturnOrderNumber initData:[NSString stringWithFormat:@"%.2f",self.employeeCommissionVo.returnOrderCount.doubleValue]];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
    
}


@end
