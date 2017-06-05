//
//  LSShitfRecordDetailController.m
//  retailapp
//
//  Created by guozhi on 2017/1/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSShitfRecordDetailController.h"
#import "LSUserHandoverVo.h"
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "UIHelper.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "LSEditItemTitle.h"
#import "ViewFactory.h"
#import "Platform.h"
#import "NSString+Estimate.h"
#import "LSEditItemView.h"
#import "DateUtils.h"

@interface LSShitfRecordDetailController ()<INavigateEvent>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *container;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
/**交接班记录详情页面所需参数*/
@property (nonatomic, strong) NSMutableDictionary *param;
/**基本信息*/
@property (strong, nonatomic) LSEditItemTitle *baseTitle;
/**员工姓名*/
@property (strong, nonatomic) LSEditItemView *vewUserName;
/**员工角色*/
@property (strong, nonatomic) LSEditItemView *vewRoleName;
/**所属门店*/
@property (strong, nonatomic) LSEditItemView *vewShopName;
/**登陆时间*/
@property (strong, nonatomic) LSEditItemView *vewStartWorkTime;
/**结束时间*/
@property (strong, nonatomic) LSEditItemView *vewEndWorkTime;
/**销售单数*/
@property (strong, nonatomic) LSEditItemView *vewOrderNumber;
/**充值金额*/
@property (strong, nonatomic) LSEditItemView *vewChargeAmount;
/**赠送金额*/
@property (strong, nonatomic) LSEditItemView *vewPresntAmount;
/**退货金额*/
@property (strong, nonatomic) LSEditItemView *vewReturnAmount;
/**退货单数*/
@property (strong, nonatomic) LSEditItemView *vewReturnOrderNumber;
/**收款明细*/
@property (strong, nonatomic) LSEditItemTitle *payTitle;
/** 应收金额 */
@property (strong, nonatomic) LSEditItemView *vewResultAmount;
/** 实收金额 */
@property (strong, nonatomic) LSEditItemView *vewReceiveAmount;
/** 不计入销售额 */
@property (strong, nonatomic) LSEditItemView *vewSaleNotInclude;
/** 损益 */
@property (strong, nonatomic) LSEditItemView *vewProfitLoss;
/** 账单汇总标题 */
@property (strong, nonatomic) LSEditItemTitle *billTitle;
/** 销售金额 */
@property (strong, nonatomic) LSEditItemView *vewSaleAmount;
/** 说明 */
@property (strong, nonatomic) UILabel *lblNote;
/** <#注释#> */
@property (nonatomic, strong) UIView *viewClear;
@end

@implementation LSShitfRecordDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configConstraints];
    [self configContainerViews];
    [self loadData];    
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //标题
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"交接班详情" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:self.titleBox];
    //scollVIew
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    //container
    self.container = [[UIView alloc] init];
    self.container.ls_width = SCREEN_W;
    [self.scrollView addSubview:self.container];
}

- (void)configConstraints {
    //标题
    UIView *superView = self.view;
    __strong typeof(self) wself = self;
    [self.titleBox makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(superView);
        make.height.equalTo(64);
    }];
    //scrollView
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(superView);
        make.top.equalTo(wself.titleBox.bottom);
    }];
    
}

- (void)configContainerViews {
    self.baseTitle = [LSEditItemTitle editItemTitle];
    [self.baseTitle configTitle:@"基本信息"];
    [self.container addSubview:self.baseTitle];
    
    self.vewUserName = [LSEditItemView editItemView];
    [self.vewUserName initLabel:@"交班员工" withHit:nil];
    [self.container addSubview:self.vewUserName];
    
    self.vewRoleName = [LSEditItemView editItemView];
    [self.vewRoleName initLabel:@"员工角色" withHit:nil];
    [self.container addSubview:self.vewRoleName];
    
    self.vewStartWorkTime = [LSEditItemView editItemView];
    [self.vewStartWorkTime initLabel:@"开始时间" withHit:nil];
    [self.container addSubview:self.vewStartWorkTime];
    
    self.vewEndWorkTime = [LSEditItemView editItemView];
    [self.vewEndWorkTime initLabel:@"结束时间" withHit:nil];
    [self.container addSubview:self.vewEndWorkTime];
    
    self.vewShopName = [LSEditItemView editItemView];
    [self.vewShopName initLabel:@"所属门店" withHit:nil];
    [self.container addSubview:self.vewShopName];
    
    self.vewResultAmount = [LSEditItemView editItemView];
    [self.vewResultAmount initLabel:@"应收金额(元)" withHit:nil];
    [self.container addSubview:self.vewResultAmount];
    
    self.vewReceiveAmount = [LSEditItemView editItemView];
    [self.vewReceiveAmount initLabel:@"实收金额(元)" withHit:nil];
    [self.container addSubview:self.vewReceiveAmount];
    
    self.vewSaleNotInclude = [LSEditItemView editItemView];
    [self.vewSaleNotInclude initLabel:@"不计入销售额(元)" withHit:nil];
    [self.container addSubview:self.vewSaleNotInclude];
    
    self.vewProfitLoss = [LSEditItemView editItemView];
    [self.vewProfitLoss initLabel:@"损益(元)" withHit:nil];
    [self.container addSubview:self.vewProfitLoss];
    
    [LSViewFactor addClearView:self.container y:0 h:20];
    
    self.billTitle = [LSEditItemTitle editItemTitle];
    [self.billTitle configTitle:@"账单汇总"];
    [self.container addSubview:self.billTitle];
    
    self.vewOrderNumber = [LSEditItemView editItemView];
    [self.vewOrderNumber initLabel:@"销售单数" withHit:nil];
    [self.container addSubview:self.vewOrderNumber];
    
    self.vewSaleAmount = [LSEditItemView editItemView];
    [self.vewSaleAmount initLabel:@"销售金额(元)" withHit:nil];
    [self.container addSubview:self.vewSaleAmount];
    
    self.vewChargeAmount = [LSEditItemView editItemView];
    [self.vewChargeAmount initLabel:@"充值金额(元)" withHit:nil];
    [self.container addSubview:self.vewChargeAmount];
    
    self.vewPresntAmount = [LSEditItemView editItemView];
    [self.vewPresntAmount initLabel:@"赠送金额(元)" withHit:nil];
    [self.container addSubview:self.vewPresntAmount];
    
    self.vewReturnAmount = [LSEditItemView editItemView];
    [self.vewReturnAmount initLabel:@"退货金额(元)" withHit:nil];
    [self.container addSubview:self.vewReturnAmount];
    
    self.vewReturnOrderNumber = [LSEditItemView editItemView];
    [self.vewReturnOrderNumber initLabel:@"退货单数" withHit:nil];
    [self.container addSubview:self.vewReturnOrderNumber];
    
    [LSViewFactor addClearView:self.container y:0 h:20];

    self.payTitle = [LSEditItemTitle editItemTitle];
    [self.payTitle configTitle:@"收款明细"];
    [self.container addSubview:self.payTitle];

    if ([[Platform Instance] getShopMode] == 1) {
        [self.vewShopName visibal:NO];
    }
    self.viewClear = [LSViewFactor addClearView:self.container y:0 h:20];
    
    NSString *text = @"提示：\n1.实收金额：支付方式为“收入计入销售额”的收款金额合计\n2.不计入销售额：支付方式为“收入不计入销售额”的收款金额合计\n3.销售金额：销售订单的实收金额";
    self.lblNote = [LSViewFactor addExplainText:self.container text:text y:0];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma mark - 导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}


#pragma mark - 加载数据
- (void)loadData {
    NSString *url = @"changeShifts/v1/detail";
    __strong typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        if ([ObjectUtil isNotNull:json[@"userHandoverVo"]]) {
            wself.userHandoverVo = [LSUserHandoverVo mj_objectWithKeyValues:json[@"userHandoverVo"]];
            [wself initData];
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [NSMutableDictionary dictionary];
    }
    [_param removeAllObjects];
    [_param setValue:self.userHandoverVo.entityId forKey:@"entityId"];
    [_param setValue:self.userHandoverVo.shopEntityId forKey:@"shopEntityId"];
    [_param setValue:self.userHandoverVo.shopId forKey:@"shopId"];
    [_param setValue:self.userHandoverVo.id forKey:@"id"];
    return _param;
}

#pragma mark - 加载后页面初始化数据
- (void)initData {
    //员工姓名工号
    NSMutableAttributedString *userNameStaffIdAttr = [[NSMutableAttributedString alloc] init];
    if ([NSString isNotBlank:self.userHandoverVo.userName]) {
        [userNameStaffIdAttr appendAttributedString:[[NSAttributedString alloc] initWithString:self.userHandoverVo.userName]];
    }
    [userNameStaffIdAttr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"(工号:%@)", self.userHandoverVo.staffId] attributes: @{NSForegroundColorAttributeName : [ColorHelper getTipColor6], NSFontAttributeName : [UIFont systemFontOfSize:13]}]];
    self.vewUserName.lblVal.attributedText = userNameStaffIdAttr;
    [self.vewRoleName initData:self.userHandoverVo.roleName];
    [self.vewStartWorkTime initData:[DateUtils formateTime:[self.userHandoverVo.startWorkTime longLongValue]]];
    [self.vewEndWorkTime initData:[DateUtils formateTime:[self.userHandoverVo.endWorkTime longLongValue]]];
    [self.vewShopName initData:self.shopName];
    //应收金额
    [self.vewResultAmount initData:[NSString stringWithFormat:@"%.2f",[self.userHandoverVo.totalResultAmount doubleValue]]];
    //实收金额
    [self.vewReceiveAmount initData:[NSString stringWithFormat:@"%.2f",[self.userHandoverVo.totalRecieveAmount doubleValue]]];
    //不计入销售额
    [self.vewSaleNotInclude initData:[NSString stringWithFormat:@"%.2f",[self.userHandoverVo.salesNotInclude doubleValue]]];
    //损益
    [self.vewProfitLoss initData:[NSString stringWithFormat:@"%.2f",[self.userHandoverVo.profitLoss doubleValue]]];
    //销售金额
    [self.vewSaleAmount initData:[NSString stringWithFormat:@"%.2f",[self.userHandoverVo. discountAmount doubleValue]]];
    [self.vewOrderNumber initData:[NSString stringWithFormat:@"%.f",[self.userHandoverVo.orderNumber doubleValue]]];
    [self.vewChargeAmount initData:[NSString stringWithFormat:@"%.2f",[self.userHandoverVo.chargeAmount doubleValue]]];
    [self.vewPresntAmount initData:[NSString stringWithFormat:@"%.2f",[self.userHandoverVo.presentAmount doubleValue]]];
    [self.vewReturnAmount initData:[NSString stringWithFormat:@"%.2f",[self.userHandoverVo.returnAmount doubleValue]]];
    [self.vewReturnOrderNumber initData:[NSString stringWithFormat:@"%.f",[self.userHandoverVo.returnOrderNumber doubleValue]]];
    /** payTypeExpansionVos": [{
     "kindPayId": "1",
     "kindPayName": "cash",
     "totalAmount": 0
     }] */
    __strong typeof(self) wself = self;
    [self.userHandoverVo.payTypeExpansionVos enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LSEditItemView *itemView = [LSEditItemView editItemView];
        [itemView initLabel:[NSString stringWithFormat:@"%@(元)",obj[@"kind_pay_name"]]  withHit:nil];
        [itemView initData:[NSString stringWithFormat:@"%.2f",[obj[@"total_amount"] doubleValue]]];
        [wself.container insertSubview:itemView belowSubview:wself.viewClear];
        
    }];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

@end
