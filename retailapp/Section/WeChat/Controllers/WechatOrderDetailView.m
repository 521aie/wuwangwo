//
//  WechatOrderDetailView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/11/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "WechatOrderDetailView.h"
#import "WechatService.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "OrderInfoVo.h"
#import "DateUtils.h"
//#import "ReSplitOrderView.h"
#import "UserOrderOptVo.h"
#import "SRTitleView.h"
#import "SRItemView.h"
#import "SRItemView2.h"
#import "SRGoodsView.h"
#import "SRButtonView.h"
#import "OrderRefuseReasonView.h"
#import "XHAnimalUtil.h"
#import "WechatOrderListView.h"
#import "StoreOrderDistributionView.h"
//#import "ChainOrderConfirmView.h"
//#import "SelectSplitOrderInfoView.h"
#import "OrderLogisticsInfoView.h"
#import "SystemUtil.h"
#import "BaseService.h"
#import "UIView+Sizes.h"

@interface WechatOrderDetailView () <INavigateEvent>

@property (nonatomic, strong) WechatService *wechatService;
@property (nonatomic, strong) BaseService *baseService;
@property (nonatomic, strong) OrderInfoVo *orderInfo;
/** 商品列表 */
@property (nonatomic, strong) NSArray *instanceVoJsonList;

@end

@implementation WechatOrderDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainView];
    [self initNavigate];
    [self loadData];
    [self configHelpButton:HELP_WECHAT_SALE_ORDER_DETAIL];
}

- (void)initMainView {
    self.wechatService = [ServiceFactory shareInstance].wechatService;
    self.baseService = [ServiceFactory shareInstance].baseService;
}

- (void)initNavigate {
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:self.receiverName backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

- (void)onNavigateEvent:(Direct_Flag)event {
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)fillData {
    
   for (UIView *view in self.scrollView.subviews) {
        if (view == self.viewOper) {
            view.hidden = YES;
        } else {
            [view removeFromSuperview];
        }
    }
    self.btnRed.hidden = YES;
    self.btnGreen.hidden = YES;
    self.btnSplitOrder.hidden = YES;
    
    CGFloat _h = 0;
    //基本信息
    SRTitleView *baseInfoView = [SRTitleView loadFromNibWithTitle:@"基本信息"];
    [self.scrollView addSubview:baseInfoView];
    _h = _h + 44;
    
    //退货状态
    SRItemView *itemView = [SRItemView loadFromNib];
    NSString *status = [self getStatusString:self.orderInfo.status];
    if (self.orderInfo.orderKind == 4) {//上门自提
        if (self.orderInfo.status == 20) {
            status = [status stringByAppendingString:@"(等待客户提货)"];
        } else if (self.orderInfo.status == 24) {
            status = [status stringByAppendingString:@"(客户已提货)"];
        }
    }
    [itemView setTitle:@"订单状态" value:status];
    [self setViewFrame:itemView Y:_h];
    [self.scrollView addSubview:itemView];
     _h = _h + 44;
    //订单处理门店
    NSString *dealShopName = self.orderInfo.dealShopName;
    if ([NSString isNotBlank:dealShopName]) {
        itemView = [SRItemView loadFromNib];
        [itemView setTitle:@"处理门店" value:dealShopName];
        [self setViewFrame:itemView Y:_h];
        [self.scrollView addSubview:itemView];
        _h = _h + 44;
    }
    if ([[Platform Instance] getShopMode] != 1) {
        NSString *orderType = nil;
        if ([self.orderInfo.outType isEqualToString:@"weixin"]) {//微店
            orderType = @"微店订单";
        } else if ([self.orderInfo.outType isEqualToString:@"weiPlatform"]) {//微平台
            orderType = @"微平台订单";
        }
        itemView = [SRItemView loadFromNib];
        [itemView setTitle:@"订单来源" value:orderType];
        [self setViewFrame:itemView Y:_h];
        _h = _h + 44;
        [self.scrollView addSubview:itemView];

    }
    if (self.orderType == 1) {
        if ([[Platform Instance] getShopMode] != 1 &&[[Platform Instance] isTopOrg]) {
            SRItemView *itemView2 = [SRItemView loadFromNib];
            [itemView2 setTitle:@"销售门店" value:self.orderInfo.shopName];
            [self setViewFrame:itemView2 Y:_h];
            _h = _h + 44;
            [self.scrollView addSubview:itemView2];
        }
        if ([[Platform Instance] getShopMode] != 1 &&[[Platform Instance] isTopOrg] && [self.orderInfo.outType isEqualToString:@"weixin"] && [[[Platform Instance] getkey:ORG_ID] isEqualToString:self.orderInfo.shopId]) {
            SRItemView *itemView2 = [SRItemView loadFromNib];
            [itemView2 setTitle:@"销售微店" value:@"总部微店"];
            [self setViewFrame:itemView2 Y:_h];
            _h = _h + 44;
            [self.scrollView addSubview:itemView2];
        }
    }
    //拒绝原因 - 订单状态是“拒绝配送”时表示
    if (self.orderInfo.status == 16) {
        SRItemView2 *itemView2 = [SRItemView2 loadFromNib];
        [itemView2 setTitle:@"拒绝原因" value:self.orderInfo.rejReason];
        [self setViewFrame:itemView2 Y:_h];
        [self.scrollView addSubview:itemView2];
        _h = _h + itemView2.frame.size.height;
    }
    
    //订单编号
    itemView = [SRItemView loadFromNib];

    //销售订单
    [itemView setTitle:@"订单编号" value:[self.orderInfo.code substringFromIndex:3]];

    [self setViewFrame:itemView Y:_h];
    [self.scrollView addSubview:itemView];
    _h = _h + 44;

    
    //下单时间
    itemView = [SRItemView loadFromNib];
    [itemView setTitle:@"下单时间" value:[DateUtils formateTime:self.orderInfo.openTime]];
    [self setViewFrame:itemView Y:_h];
    [self.scrollView addSubview:itemView];
    _h = _h + 44;
    if (self.orderInfo.status != 11 && self.orderInfo.status != 22) {//待付款的不展示
            //支付方式
            itemView = [SRItemView loadFromNib];
            NSString *payMode = [self getPayModeString:self.orderInfo.payMode];
        if (![payMode hasPrefix:@"货到付款"]) {
            NSString *is_cash = [NSString stringWithFormat:@"%@",self.orderInfo.is_cash_on_delivery];
            if ([ObjectUtil isNotNull:self.orderInfo.is_cash_on_delivery] && ![is_cash isEqualToString:@"null"]) {
                payMode = [NSString stringWithFormat:@"%@(货到付款)", payMode];
            }
        }
            [itemView setTitle:@"支付方式" value:payMode];
            [self setViewFrame:itemView Y:_h];
            [self.scrollView addSubview:itemView];
            _h = _h + 44;

        }
    //订单金额(元)
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f", self.orderInfo.resultAmount]
                                                                                 attributes:@{NSForegroundColorAttributeName:RGB(204, 0, 0)}];
        if (self.orderInfo.outFee > 0) {
            [attr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(含%.2f元配送费)", self.orderInfo.outFee]
                                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13] }]];
        } else {
            [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"(免配送费)" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13] }]];
        }
        
        itemView = [SRItemView loadFromNib];
        [itemView setTitle:@"订单金额(元)" attributedValue:attr];
        [self setViewFrame:itemView Y:_h];
        [self.scrollView addSubview:itemView];
        _h = _h + 44;

    //配送方式
    itemView = [SRItemView loadFromNib];
    if (self.orderInfo.orderKind == 4) {
        [itemView setTitle:@"配送方式" value:@"上门自提"];
    } else if (self.orderInfo.orderKind == 5) {
        [itemView setTitle:@"配送方式" value:@"火超市自提"];
    } else {
        [itemView setTitle:@"配送方式" value:@"配送到家"];
    }

    [self setViewFrame:itemView Y:_h];
    [self.scrollView addSubview:itemView];
    _h = _h + 44;
    
    
    
    //要求配送时间
    if ([NSString isNotBlank:self.orderInfo.sendTimeRange] && ![self.orderInfo.sendTimeRange isEqualToString:@"0"]) {
        if (self.orderInfo.orderKind != 4) {
            itemView = [SRItemView loadFromNib];
            [itemView setTitle:@"要求配送时间" value:self.orderInfo.sendTimeRange];
            [self setViewFrame:itemView Y:_h];
            [self.scrollView addSubview:itemView];
            _h = _h + 44;
        }
        
    }
    
    //预约时间
    if ([NSString isNotBlank:self.orderInfo.sendTimeRange] && ![self.orderInfo.sendTimeRange isEqualToString:@"0"]) {
        if (self.orderInfo.orderKind == 4) {
            itemView = [SRItemView loadFromNib];
            [itemView setTitle:@"预约时间" value:self.orderInfo.sendTimeRange];
            [self setViewFrame:itemView Y:_h];
            [self.scrollView addSubview:itemView];
            _h = _h + 44;
        }
       
    }
    

    //收货人
    //收货人手机号码
    //收货地址
    NSString *address = [NSString stringWithFormat:@"%@      %@\n%@", self.orderInfo.receiverName, self.orderInfo.mobile, self.orderInfo.address];
    SRItemView2 *itemView2 = [SRItemView2 loadFromNib];
    // 火超市和上门自提情况下标题显示为“提货人信息”
    if (self.orderInfo.orderKind == 5 || self.orderInfo.orderKind == 4) {
         [itemView2 setTitle:@"提货人信息" value:address];
    } else {
         [itemView2 setTitle:@"收货地址" value:address];
    }
   
    [self setViewFrame:itemView2 Y:_h];
    [self.scrollView addSubview:itemView2];
    _h = _h + itemView2.frame.size.height;
    
    //备注
    NSString *memo = self.orderInfo.memo;
    if ([NSString isNotBlank:memo]) {
        SRItemView2 *itemView2 = [SRItemView2 loadFromNib];
        [itemView2 setTitle:@"备注" value:memo];
        [self setViewFrame:itemView2 Y:_h];
        [self.scrollView addSubview:itemView2];
        _h = _h + itemView2.frame.size.height;

    }
    _h = _h + 20;
    //订单商品
    SRTitleView *returnGoodsView = [SRTitleView loadFromNibWithTitle:@""];
    [self.scrollView addSubview:returnGoodsView];
    [self setViewFrame:returnGoodsView Y:_h];
    attr = [[NSMutableAttributedString alloc] initWithString:@"订单商品"];
    
    NSString *total = [NSString stringWithFormat:@"%ld", (long)[self getGoodsTotal]];
    
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"（合计 "
                                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13] }]];

    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:total
                                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                                                                               NSForegroundColorAttributeName:RGB(204, 0, 0)}]];
    
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@" 件）" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13] }]];
    
    [returnGoodsView setAttributedTitle:attr];
    _h = _h + 44;
    

    //配送信息图标
    
    //只有订单的配送方式是“配送到家”，并且订单状态为配送中、配送完成、交易关闭时才会显示该图标，点击进入配送信息页面
    //订单有配送信息时表示
    if ((self.orderInfo.status == 20 || self.orderInfo.status == 21 || self.orderInfo.status == 23 || self.orderInfo.status == 24)) {
        //配送信息
        if ([NSString isNotBlank:self.orderInfo.logisticsNo] || [NSString isNotBlank:self.orderInfo.sendMan]) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-45, 0, 35, 44);
            [button setImage:[UIImage imageNamed:@"ico_logistics"] forState:UIControlStateNormal];
            [returnGoodsView addSubview:button];
            [button addTarget:self action:@selector(logisticsClick:) forControlEvents:UIControlEventTouchUpInside];
            //配送状态
            [returnGoodsView layoutIfNeeded];
            returnGoodsView.rightMarginConstraint.constant = 12 + 35;
//            returnGoodsView.lblValue.frame = CGRectMake(148 - 45, 11, 162, 21);
//            returnGoodsView.lblValue.text = [self getStatusString:self.orderInfo.status];
            [returnGoodsView setLblText:[self getStatusString:self.orderInfo.status] color:nil];
        }
    }
    
    // 商品列表
    for (int i = 0; i < self.instanceVoJsonList.count; i++) {
        InstanceVo *instanceVo = [self.instanceVoJsonList objectAtIndex:i];
        
        SRGoodsView *goodsView = [SRGoodsView loadFromNib];
        [self.scrollView addSubview:goodsView];
        [goodsView initOrderData:instanceVo orderType:self.orderType];
        [self setViewFrame:goodsView Y:_h];
        _h = _h + goodsView.ls_height;
    }
    
    //结算信息
    _h = _h + 20;
    SRTitleView *settleView = [SRTitleView loadFromNibWithTitle:@"结算信息"];
    [self.scrollView addSubview:settleView];
    [self setViewFrame:settleView Y:_h];
    _h = _h + 44;
    
    //商品总额(元)
    attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f", self.orderInfo.sourceAmount - self.orderInfo.outFee]
                                                                             attributes:@{NSForegroundColorAttributeName:RGB(204, 0, 0)}];
    itemView = [SRItemView loadFromNib];
    [itemView setTitle:@"商品总额(元)" attributedValue:attr];
    [self setViewFrame:itemView Y:_h];
    [self.scrollView addSubview:itemView];
    _h = _h + 44;
    
    //配送费(元)
    attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f", self.orderInfo.outFee]
                                                  attributes:@{NSForegroundColorAttributeName:RGB(204, 0, 0)}];
    itemView = [SRItemView loadFromNib];
    [itemView setTitle:@"配送费(元)" attributedValue:attr];
    [self setViewFrame:itemView Y:_h];
    [self.scrollView addSubview:itemView];
    _h = _h + 44;
    
    //优惠合计(元)
    NSMutableAttributedString *titleAttr = [[NSMutableAttributedString alloc] initWithString:@"优惠合计(元)"];
    // 满减
    if (self.orderInfo.reducePrice != 0) {
        //            if ([NSString isNotBlank:self.orderInfo.salesInfo]) {
        [titleAttr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(满减：%.2f)", self.orderInfo.reducePrice*(-1)]
                                                                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13] }]];
    }
    
    attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f", (self.orderInfo.sourceAmount - self.orderInfo.discountAmount)*(-1)] attributes:@{NSForegroundColorAttributeName:RGB(0, 170, 34)}];
    itemView = [SRItemView loadFromNib];
    [itemView setAttributedTitle:titleAttr attributedValue:attr];
    [self setViewFrame:itemView Y:_h];
    [self.scrollView addSubview:itemView];
    _h = _h + 44;
    
    //订单金额(元)
    attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f", self.orderInfo.discountAmount] attributes:@{NSForegroundColorAttributeName:RGB(204, 0, 0)}];
    itemView = [SRItemView loadFromNib];
    [itemView setTitle:@"订单金额(元)" attributedValue:attr];
    [self setViewFrame:itemView Y:_h];
    [self.scrollView addSubview:itemView];
    _h = _h + 44;

    //按钮
    
    //拒绝接单
    //①、单店模式：订单状态为“待处理”时表示
    //②、连锁模式:
    //•销售订单：只有总部用户登录，且订单状态为“待分配”时表示；
    //•供货订单：整单配送的订单状态为“待处理”时表示；拆单配送时，此按钮非表示
    if (([[Platform Instance] getShopMode] == 1 && (self.orderInfo.status == 15)) ||
        ([[Platform Instance] getShopMode] != 1 && self.orderType == 1 && [[Platform Instance] isTopOrg] && self.orderInfo.status == 13) ||
        ([[Platform Instance] getShopMode] != 1 && self.orderType == 2 && self.orderInfo.status == 15 && self.orderInfo.isDivide == 0) ) {
        
        self.viewOper.hidden = NO;
        self.viewOper.frame = CGRectMake(0, _h, 320, 65);
        self.btnRed.hidden = NO;
        _h = _h + 65;
    }
    
    //同意接单
    //①、单店模式：订单状态为“待处理”时表示
    //②、连锁模式:
    //•销售订单：只有总部用户登录，且订单状态为“待分配”时表示；
    //•供货订单：订单状态为“待处理”时表示
    if (
         ([[Platform Instance] getShopMode] == 1 && self.orderInfo.status == 15) ||
        ((([[Platform Instance] getShopMode] != 1 && self.orderType == 1 && [[Platform Instance] isTopOrg] && self.orderInfo.status == 13) ||
        ([[Platform Instance] getShopMode] != 1 && self.orderType == 2 && self.orderInfo.status == 15)
         )&& self.orderInfo.orderKind != 4)  ) {
        if (self.btnRed.hidden) {
            self.btnGreen.ls_left = 15;
            self.btnGreen.ls_width = 290;
        }
        self.btnGreen.hidden = NO;
        if (self.viewOper.hidden == YES) {
            self.viewOper.hidden = NO;
            self.viewOper.frame = CGRectMake(0, _h, 320, 65);
            _h = _h + 65;
        }
    }
    
    if (self.orderInfo.orderKind == 4 && ((self.orderInfo.status == 13 && self.orderType == 1 && [[Platform Instance] isTopOrg]) || (self.orderInfo.status == 15 && self.orderType == 2))) {//上门自提是待分配时显示同意接单按钮上门自提供货订单要显示同意接单
        self.btnGreen.hidden = NO;
        if (self.btnRed.hidden) {
            self.btnGreen.ls_left = 15;
            self.btnGreen.ls_width = 290;
        }

        if (self.viewOper.hidden == YES) {
            self.viewOper.hidden = NO;
            self.viewOper.frame = CGRectMake(0, _h, 320, 65);
            _h = _h + 65;
        }
    }

    
    //重新分单
    //①、单店模式：非表示
    //②、连锁模式：销售订单的配送方式是“配送到家”并且状态为“待处理”时表示
    if (([[Platform Instance] isTopOrg] ) && self.orderType == 1 && self.orderInfo.orderKind != 4 &&  self.orderInfo.status == 15) {
        self.btnSplitOrder.hidden = NO;
        if (self.viewOper.hidden == YES) {
            self.viewOper.hidden = NO;
            self.viewOper.frame = CGRectMake(0, _h, 320, 65);
            _h = _h + 65;
        }
    }
    
    //客户已提货
    if (self.orderInfo.orderKind == 4 && self.orderInfo.status == 20 && (([[Platform Instance] getShopMode] == 1) || ([[Platform Instance] getShopMode] != 1 && self.orderType == 2 ))) {
        self.btnPicking.hidden = NO;
        self.btnRed.hidden = YES;
        if (self.viewOper.hidden == YES) {
            self.viewOper.hidden = NO;
            self.viewOper.frame = CGRectMake(0, _h, 320, 65);
            _h = _h + 65;
        }
    }
    
    // 配送完成
    NSString *str = [NSString stringWithFormat:@"%@(%@)",[[Platform Instance] getkey:EMPLOYEE_NAME],[[Platform Instance] getkey:STAFF_ID]];
    if ([self.orderInfo.sendMan isEqualToString:str] && ([[Platform Instance] getShopMode] == 1 || ([[Platform Instance] getShopMode] != 1 && self.orderType == 2)) && self.orderInfo.status == 20) {
        self.btnComplete.hidden = NO;
        if (self.viewOper.hidden == YES) {
            self.viewOper.hidden = NO;
            self.viewOper.frame = CGRectMake(0, _h, 320, 65);
            _h = _h + 65;
        }
    }
    if (self.type == 1) {//从退货审核的原订单详情页面进入隐藏按钮
        self.viewOper.hidden = YES;
    }
    [self.scrollView setContentSize:CGSizeMake(320, _h + 30)];
}

- (IBAction)sellOrderOperateClick:(UIButton *)sender {
   
    __weak typeof(self) weakSelf = self;
    if (sender.tag == 0) {
        
        //拒绝接单
        OrderRefuseReasonView *reasonView = [[OrderRefuseReasonView alloc] initWithNibName:[SystemUtil getXibName:@"OrderRefuseReasonView"] bundle:nil];
        reasonView.refuseReasonBack = ^(NSString *reason) {
            [weakSelf sellOrderOperate:@"refuse" reason:reason expansion:nil userOrderOpt:nil];
        };
        [self pushController:reasonView from:kCATransitionFromRight];
        
    } else if (sender.tag == 1) {
     
        //&& ((self.orderInfo.orderKind != 4 || (self.orderInfo.orderKind ==4 && self.orderType == 2 && [[Platform Instance] getShopMode] != 1)) || ([[Platform Instance] getShopMode] == 1 && self.orderInfo.orderKind == 4))
 
        //同意接单, 上门自提
        if ([[Platform Instance] getShopMode] != 3 && self.orderInfo.orderKind == 4  && self.orderInfo.status == 15) {
            [self sellOrderOperate:@"confirm" reason:nil expansion:nil userOrderOpt:nil];
            return;
        }
        
        if ([[Platform Instance] getShopMode] == 1 || self.orderType == 2) {
           
            StoreOrderDistributionView *distributionView = [[StoreOrderDistributionView alloc] initWithNibName:[SystemUtil getXibName:@"StoreOrderDistributionView"] bundle:nil];
            distributionView.confirmOrderBack = ^(NSDictionary *expansion) {
                UserOrderOptVo * userOrderOpt=[[UserOrderOptVo alloc] init];
                userOrderOpt.roleId=[[Platform Instance] getkey:USER_ID];
                userOrderOpt.userId=[[Platform Instance] getkey:ROLE_ID];
                userOrderOpt.orderId=_orderInfo.orderId;
                userOrderOpt.code=_orderInfo.code;
                userOrderOpt.orderType = 2;
                NSDictionary *userOrderDic = [UserOrderOptVo getDictionaryData:userOrderOpt];
                [weakSelf sellOrderOperate:@"confirm" reason:nil expansion:expansion userOrderOpt:userOrderDic];
            };
            [weakSelf pushController:distributionView from:kCATransitionFromRight];
        }
    }
}



- (IBAction)btnClick:(UIButton *)sender {
    [self deliveryCompleted];
}


- (void)logisticsClick:(id)sender {
    
    OrderLogisticsInfoView *infoView = [[OrderLogisticsInfoView alloc] initWithNibName:[SystemUtil getXibName:@"OrderLogisticsInfoView"] bundle:nil];
    infoView.logisticsName = self.orderInfo.logisticsName;
    infoView.logisticsNo = self.orderInfo.logisticsNo;
    infoView.sendMan = self.orderInfo.sendMan;
    infoView.sendFee = [NSString stringWithFormat:@"%.2f", self.orderInfo.shopFreight];
    infoView.orderType = self.orderType;
    infoView.dealShop = self.orderInfo.dealShopName;
    [self.navigationController pushViewController:infoView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

#pragma mark - 网络请求 -

- (void)loadData {
    __weak WechatOrderDetailView *weakSelf = self;
    [self.wechatService selectOrderDetail:self.orderId orderType:self.orderType shopId:self.shopId completionHandler:^(id json) {
        weakSelf.orderInfo = [OrderInfoVo converToVo:json[@"orderDetailVo"][@"orderInfo"]];
        weakSelf.instanceVoJsonList = [InstanceVo converToArr:json[@"orderDetailVo"][@"instances"]];
        [weakSelf fillData];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

//销售订单
- (void)sellOrderOperate:(NSString *)operateType reason:(NSString *)reason
               expansion:(NSDictionary *)expansion
            userOrderOpt:(NSDictionary *) userOrderOpt   {
    __weak WechatOrderDetailView *weakSelf = self;
    [self.wechatService sellOrderOperate:self.orderInfo.orderId
                                  shopId:self.orderInfo.shopId
                             operateType:operateType
                               rejReason:reason
                                    code:self.orderInfo.code
                               expansion:expansion[@"expansion"]
                              employeeId:expansion[@"employeeId"]
                                 lastVer:self.orderInfo.lastVer
                                  outFee:expansion[@"outFee"]
                            userOrderOpt:(NSDictionary *)userOrderOpt
                       completionHandler:^(id json) {
                           [weakSelf gotoWechatOrderListView];
                       } errorHandler:^(id json) {
                           [AlertBox show:json];
                       }];
    
}

// 配送方式为上门自提: 销售订单状态为“待分配”,点击同意接单按钮
//- (void)takeGoodsBySelf {
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setValue:self.orderInfo.orderId forKey:@"orderId"];
//    [self.wechatService orderManagement:param completionHandler:^(id json) {
//        [self gotoWechatOrderListView];
//    } errorHandler:^(id json) {
//        [AlertBox show:json];
//    }];
//}

//  客户已提货 配送完成
- (void)deliveryCompleted {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@(self.orderType) forKey:@"orderType"];
    [param setValue:@(self.orderInfo.lastVer) forKey:@"lastVer"];
    [param setValue:self.orderInfo.orderId forKey:@"orderId"];
    NSString *url = @"orderManagement/orderStatusUpdate";
    __weak WechatOrderDetailView *weakSelf = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        [weakSelf gotoWechatOrderListView];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark 订单管理页面
- (void)gotoWechatOrderListView {
    WechatOrderListView *weChatVc = nil;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[WechatOrderListView class]]) {
            weChatVc = (WechatOrderListView *)vc;
        }
    }
    [weChatVc.tableView headerBeginRefreshing];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popToViewController:weChatVc animated:NO];
}



#pragma mark - private
- (void)setViewFrame:(UIView *)view Y:(CGFloat)y {
    CGRect rect = view.frame;
    rect.origin.y = y;
    view.frame = rect;
}

- (NSString *)getStatusString:(short)status {
    //销售订单  状态:11待付款、12付款中、13待分配、15待处理、20配送中、21交易成功、16拒绝配送、22交易取消、23交易关闭 24配送完成
    //供货订单:15待处理、20配送中、24配送完成、16拒绝配送
    NSDictionary *statusDic = @{ @"11":@"待付款", @"12":@"付款中", @"13":@"待分配", @"15":@"待处理", @"16":@"拒绝配送", @"20":@"配送中", @"21":@"交易成功", @"22":@"交易取消", @"23":@"交易关闭",@"24":@"配送完成"};
    NSString *statusString = [statusDic objectForKey:[NSString stringWithFormat:@"%i", status]];
    if ([NSString isNotBlank:statusString]) {
        return statusString;
    } else {
        return @"";
    }
}

- (NSString *)getPayModeString:(short)status {
    //1:会员卡;2:优惠券;3:支付宝;4:支付宝;5:现金;6:微支付;99:其他'
    NSDictionary *statusDic = @{@"1":@"会员卡", @"2":@"优惠券", @"3":@"支付宝", @"4":@"银行卡", @"5":@"现金", @"6":@"微支付", @"99":@"其他",@"8":@"[支付宝]",@"9":@"[微信]",@"50":@"货到付款",@"51":@"手动退款", @"52":@"[QQ钱包]"};
    NSString *statusString = [statusDic objectForKey:[NSString stringWithFormat:@"%i", status]];
    if ([NSString isNotBlank:statusString]) {
        return statusString;
    } else {
        return @"";
    }
}

// 获取商品总数
- (NSInteger)getGoodsTotal {
    
    NSInteger total = 0;
    for (InstanceVo *instanceVo in self.instanceVoJsonList) {
            total += instanceVo.accountNum;
    }
    
    return total;
}

@end
