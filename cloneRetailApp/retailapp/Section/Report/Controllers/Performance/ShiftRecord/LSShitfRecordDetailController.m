//
//  LSShitfRecordDetailController.m
//  retailapp
//
//  Created by guozhi on 2017/1/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSShitfRecordDetailController.h"
#import "LSUserHandoverVo.h"
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
#import "ObjectUtil.h"
#import "LSShitfRecordDetailHeaderView.h"

//<<<<<<< HEAD
@interface LSShitfRecordDetailController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *container;
/**交接班记录详情页面所需参数*/
//=======
//@interface LSShitfRecordDetailController ()<INavigateEvent>
//
//@property (strong, nonatomic) UIScrollView *scrollView;
//@property (strong, nonatomic) UIView *container;
//@property (nonatomic, strong) NavigateTitle2 *titleBox;
///** 交接班记录详情页面所需参数 */
//>>>>>>> feature/jicika
@property (nonatomic, strong) NSMutableDictionary *param;

@property (nonatomic,strong) LSShitfRecordDetailHeaderView *headerView;
/** 销售应收 */
@property (strong, nonatomic) LSEditItemView *vewResultAmount;
/** 不计入销售额 */
@property (strong, nonatomic) LSEditItemView *vewSaleNotInclude;
/** 损益 */
@property (strong, nonatomic) LSEditItemView *vewProfitLoss;

/** 账单汇总 */
@property (strong, nonatomic) LSEditItemTitle *billTitle;
/** 销售单数 */
@property (strong, nonatomic) LSEditItemView *vewSaleGoodsNumber;
/** 销售金额 */
@property (strong, nonatomic) LSEditItemView *vewDiscountAmount;
/** 充值金额 */
@property (strong, nonatomic) LSEditItemView *vewChargeAmount;
/** 赠送金额 */
@property (strong, nonatomic) LSEditItemView *vewPresentAmount;
/** 退货单数 */
@property (strong, nonatomic) LSEditItemView *vewReturnOrderNumber;
/** 退货金额 */
@property (strong, nonatomic) LSEditItemView *vewReturnAmount;

/** 销售 */
@property (strong, nonatomic) LSEditItemView *vewSale;
/** 退货 */
@property (strong, nonatomic) LSEditItemView *vewReturn;
/** 储蓄充值 */
@property (strong, nonatomic) LSEditItemView *vewSaveAmount;
/** 会员卡退卡 */
@property (strong, nonatomic) LSEditItemView *vewReturnMemberCard;
/** 计次充值 */
@property (strong, nonatomic) LSEditItemView *vewChargeMeter;
/** 计次服务退款 */
@property (strong, nonatomic) LSEditItemView *vewReturnMeter;

/** 收款明细 */
@property (strong, nonatomic) LSEditItemTitle *payTitle;
/** 说明 */
@property (strong, nonatomic) UILabel *lblNote;
/** 说明 */
@property (copy, nonatomic) NSString *lblNoteText;
@property (nonatomic, strong) UIView *viewClear;
@end

@implementation LSShitfRecordDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configContainerViews];
    [self loadData];
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //标题
    [self configTitle:@"交接班详情" leftPath:Head_ICON_BACK rightPath:nil];
    //scollVIew
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    //container
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
}

- (void)configContainerViews {
    self.headerView = [LSShitfRecordDetailHeaderView shitfRecordDetailHeaderView];
    [self.container addSubview:self.headerView];
    
    self.vewResultAmount = [LSEditItemView editItemView];
    [self.vewResultAmount initLabel:@"销售应收（元）" withHit:nil];
    [self.container addSubview:self.vewResultAmount];
    
    self.vewSaleNotInclude = [LSEditItemView editItemView];
    [self.vewSaleNotInclude initLabel:@"不计入销售额（元）" withHit:nil];
    [self.container addSubview:self.vewSaleNotInclude];
    
    self.vewProfitLoss = [LSEditItemView editItemView];
    [self.vewProfitLoss initLabel:@"损益（元）" withHit:nil];
    [self.container addSubview:self.vewProfitLoss];
    
    [LSViewFactor addClearView:self.container y:0 h:20];
    
    self.billTitle = [LSEditItemTitle editItemTitle];
    [self.billTitle configTitle:@"账单汇总"];
    [self.container addSubview:self.billTitle];
    
    self.vewSaleGoodsNumber = [LSEditItemView editItemView];
    [self.vewSaleGoodsNumber initLabel:@"销售单数" withHit:nil];
    [self.container addSubview:self.vewSaleGoodsNumber];
    
    self.vewDiscountAmount = [LSEditItemView editItemView];
    [self.vewDiscountAmount initLabel:@"销售金额（元）" withHit:nil];
    [self.container addSubview:self.vewDiscountAmount];
    
    self.vewChargeAmount = [LSEditItemView editItemView];
    [self.vewChargeAmount initLabel:@"充值金额（元）" withHit:nil];
    [self.container addSubview:self.vewChargeAmount];
    
    self.vewPresentAmount = [LSEditItemView editItemView];
    [self.vewPresentAmount initLabel:@"赠送金额（元）" withHit:nil];
    [self.container addSubview:self.vewPresentAmount];
    
    self.vewReturnOrderNumber = [LSEditItemView editItemView];
    [self.vewReturnOrderNumber initLabel:@"退货单数" withHit:nil];
    [self.container addSubview:self.vewReturnOrderNumber];
    
    self.vewReturnAmount = [LSEditItemView editItemView];
    [self.vewReturnAmount initLabel:@"退货金额（元）" withHit:nil];
    [self.container addSubview:self.vewReturnAmount];
    
    self.vewSale = [LSEditItemView editItemView];
    [self.vewSale initLabel:@"销售" withHit:nil];
    [self.container addSubview:self.vewSale];
    
    self.vewReturn = [LSEditItemView editItemView];
    [self.vewReturn initLabel:@"退货" withHit:nil];
    [self.container addSubview:self.vewReturn];
    
    self.vewSaveAmount = [LSEditItemView editItemView];
    [self.vewSaveAmount initLabel:@"储值充值" withHit:nil];
    [self.container addSubview:self.vewSaveAmount];
    
    self.vewReturnMemberCard = [LSEditItemView editItemView];
    [self.vewReturnMemberCard initLabel:@"会员卡退卡" withHit:nil];
    [self.container addSubview:self.vewReturnMemberCard];
    
    self.vewChargeMeter = [LSEditItemView editItemView];
    [self.vewChargeMeter initLabel:@"计次充值" withHit:nil];
    [self.container addSubview:self.vewChargeMeter];
    
    self.vewReturnMeter = [LSEditItemView editItemView];
    [self.vewReturnMeter initLabel:@"计次服务退款" withHit:nil];
    [self.container addSubview:self.vewReturnMeter];
    
    [LSViewFactor addClearView:self.container y:0 h:20];
    
    self.payTitle = [LSEditItemTitle editItemTitle];
    [self.payTitle configTitle:@"收款明细"];
    [self.container addSubview:self.payTitle];
    
    self.viewClear = [LSViewFactor addClearView:self.container y:0 h:20];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
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
    self.headerView.userHandoverVo = self.userHandoverVo;
    self.headerView.shopName = self.shopName;
    [self.headerView setShiftHeader:self.userHandoverVo];
    
    //判断掌柜端是否升级：已升级=3，其余的为未升级
    if ([self.userHandoverVo.handoverSrc  isEqual: @3]) {
        //销售应收
        if ([ObjectUtil isNotNull:self.userHandoverVo.resultAmount]) {
            [self.vewResultAmount initData:[NSString stringWithFormat:@"%.2f",[self.userHandoverVo.resultAmount doubleValue]]];
        }
        
        //销售
        if ([ObjectUtil isNotNull:self.userHandoverVo.discountAmount]) {
            [self.vewSale initData:[NSString stringWithFormat:@"%.2f（%@单）",[self.userHandoverVo.discountAmount doubleValue],self.userHandoverVo.orderNumber]];
        }
        
        //退货
        if ([ObjectUtil isNotNull:self.userHandoverVo.returnAmount]) {
            [self.vewReturn initData:[NSString stringWithFormat:@"%.2f（%@单）",[self.userHandoverVo.returnAmount doubleValue],self.userHandoverVo.returnOrderNumber]];
        }
        
        //储蓄充值
        if ([ObjectUtil isNotNull:self.userHandoverVo.chargeStoreAmount]) {
             if ([ObjectUtil isNotNull:self.userHandoverVo.presentAmount]) {
                 [self.vewSaveAmount initData:[NSString stringWithFormat:@"%.2f（%@单）\n赠送：%.2f",[self.userHandoverVo.chargeStoreAmount doubleValue],self.userHandoverVo.chargeStoreNumber,[self.userHandoverVo.presentAmount  doubleValue]]];
                 self.vewSaveAmount.lblVal.numberOfLines = 0;
             }else{
                 [self.vewSaveAmount initData:[NSString stringWithFormat:@"%.2f（%@单）",[self.userHandoverVo.chargeStoreAmount doubleValue],self.userHandoverVo.chargeStoreNumber]];
             }
        }
        
        //会员卡退卡
        if ([ObjectUtil isNotNull:self.userHandoverVo.chargeReturnAmount]) {
            [self.vewReturnMemberCard initData:[NSString stringWithFormat:@"%.2f（%@单）",[self.userHandoverVo.chargeReturnAmount doubleValue],self.userHandoverVo.chargeReturnNumber]];
        }
        
        //计次充值
        if ([ObjectUtil isNotNull:self.userHandoverVo.chargeAccAmount]) {
            [self.vewChargeMeter initData:[NSString stringWithFormat:@"%.2f（%@单）",[self.userHandoverVo.chargeAccAmount doubleValue],self.userHandoverVo.chargeAccNumber]];
        }
        
        //计次服务退款：没有计次充值数据时显示0.00（0单）
        if ([ObjectUtil isNotNull:self.userHandoverVo.chargeAccReturnAmount]) {
            [self.vewReturnMeter initData:[NSString stringWithFormat:@"%.2f（%@单）",[self.userHandoverVo.chargeAccReturnAmount doubleValue],self.userHandoverVo.chargeAccReturnNumber]];
        }else{
            [self.vewReturnMeter initData:@"0.00（0单）"];
        }
        
        self.lblNoteText = @"提示：\n1.销售实收：支付方式为“收入计入销售额”的收款金额合计，不包含会员充值金额（储值充值、计次充值）\n2.不计入销售额：支付方式为“收入不计入销售额”的收款金额合计\n3.销售：实体销售订单的实收金额";
        
         [self.vewSaleGoodsNumber visibal:NO];
         [self.vewDiscountAmount visibal:NO];
         [self.vewChargeAmount visibal:NO];
         [self.vewPresentAmount visibal:NO];
         [self.vewReturnOrderNumber visibal:NO];
         [self.vewReturnAmount visibal:NO];
        
        //商超连锁登录隐藏 计次充值和计次服务退款
        if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 102 && [[Platform Instance] getShopMode] != 1) {
    
            [self.vewChargeMeter visibal:NO];
            [self.vewReturnMeter visibal:NO];
        }
    }else{
        
        //销售单数
        if ([ObjectUtil isNotNull:self.userHandoverVo.saleGoodsNumber]) {
            [self.vewSaleGoodsNumber initData:[NSString stringWithFormat:@"%@",self.userHandoverVo.saleGoodsNumber]];
        }
        
        //销售金额
        if ([ObjectUtil isNotNull:self.userHandoverVo.discountAmount]) {
            [self.vewDiscountAmount initData:[NSString stringWithFormat:@"%.2f",[self.userHandoverVo.discountAmount doubleValue]]];
        }
        
        //充值金额
        if ([ObjectUtil isNotNull:self.userHandoverVo.chargeAmount]) {
            [self.vewChargeAmount initData:[NSString stringWithFormat:@"%.2f",[self.userHandoverVo.chargeAmount doubleValue]]];
        }
        
        //赠送金额
        if ([ObjectUtil isNotNull:self.userHandoverVo.presentAmount]) {
            [self.vewPresentAmount initData:[NSString stringWithFormat:@"%.2f",[self.userHandoverVo.presentAmount doubleValue]]];
        }
        
        //退货单数
        if ([ObjectUtil isNotNull:self.userHandoverVo.returnOrderNumber]) {
            [self.vewReturnOrderNumber initData:[NSString stringWithFormat:@"%@",self.userHandoverVo.returnOrderNumber]];
        }
        
        //退货金额
        if ([ObjectUtil isNotNull:self.userHandoverVo.returnAmount]) {
            [self.vewReturnAmount initData:[NSString stringWithFormat:@"%.2f",[self.userHandoverVo.returnAmount doubleValue]]];
        }
        
        [self.vewResultAmount visibal:NO];
        [self.vewSale visibal:NO];
        [self.vewReturn visibal:NO];
        [self.vewSaveAmount visibal:NO];
        [self.vewReturnMemberCard visibal:NO];
        [self.vewChargeMeter visibal:NO];
        [self.vewReturnMeter visibal:NO];
        
        self.lblNoteText = @"提示：\n1.实收金额：支付方式为“收入计入销售额”的收款金额合计\n2.不计入销售额：支付方式为“收入不计入销售额”的收款金额合计\n3.销售：实体销售订单的实收金额";
    }
    
    //不计入销售额
    if ([ObjectUtil isNotNull:self.userHandoverVo.salesNotInclude] && ![self.userHandoverVo.salesNotInclude isEqual:@0]) {
        [self.vewSaleNotInclude initData:[NSString stringWithFormat:@"%.2f",[self.userHandoverVo.salesNotInclude doubleValue]]];
    }else{
        [self.vewSaleNotInclude visibal:NO];
    }
    
    //损益
    if ([ObjectUtil isNotNull:self.userHandoverVo.profitLoss] && ![self.userHandoverVo.profitLoss isEqual:@0]) {
        [self.vewProfitLoss initData:[NSString stringWithFormat:@"%.2f",[self.userHandoverVo.profitLoss doubleValue]]];
    }else{
        [self.vewProfitLoss visibal:NO];
    }
    
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
    
    self.lblNote = [LSViewFactor addExplainText:self.container text:self.lblNoteText y:0];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

@end
