//
//  PointExOrderDetailView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/12/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PointExOrderDetailView.h"
#import "WechatService.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "OrderInfoVo.h"
#import "DateUtils.h"
#import "SRTitleView.h"
#import "SRItemView.h"
#import "SRItemView2.h"
#import "SRGoodsView.h"
#import "StoreOrderDistributionView.h"
#import "XHAnimalUtil.h"
#import "PointExOrderListView.h"
#import "OrderLogisticsInfoView.h"
#import "StoreOrderDistributionView.h"
#import "SystemUtil.h"
#import "Platform.h"

@interface PointExOrderDetailView () <INavigateEvent>

@property (nonatomic, strong) WechatService *wechatService;

@property (nonatomic, strong) OrderInfoVo *orderInfo;
/** <#注释#> */
@property (nonatomic, strong) NSArray *instanceVoJsonList;

@end

@implementation PointExOrderDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    self.wechatService = [ServiceFactory shareInstance].wechatService;
    
    [self configHelpButton:HELP_WECHAT_INTERGAL_EXCHANGE_ORDER_DETAIL];
    
    [self loadData];
}

- (void)initNavigate {
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:self.receiverName backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}
- (void)loadData {
    [self.wechatService selectOrderDetail:self.orderId orderType:1 shopId:self.shopId
                        completionHandler:^(id json) {
                            //退货单一览
                            self.orderInfo = [OrderInfoVo converToVo:json[@"orderDetailVo"][@"orderInfo"]];
                            self.instanceVoJsonList = [InstanceVo converToArr:json[@"orderDetailVo"][@"instances"]];
                            [self displayData];
                        } errorHandler:^(id json) {
                            [AlertBox show:json];
                        }];
}

-(void) onNavigateEvent:(Direct_Flag)event {
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)displayData {
    if (!self.orderInfo) {
        return;
    } else {
        for (UIView *view in self.scrollView.subviews) {
            if (view == self.viewOper) {
                view.hidden = YES;
            } else {
                [view removeFromSuperview];
            }
        }
    }
    
    CGFloat _h = 0;
    //基本信息
    SRTitleView *baseInfoView = [SRTitleView loadFromNibWithTitle:@"基本信息"];
    [self.scrollView addSubview:baseInfoView];
    _h = _h + 44;
    
    //订单状态
    SRItemView *itemView = [SRItemView loadFromNib];
    [itemView setTitle:@"订单状态" value:[self getStatusString:self.orderInfo.status]];
    [self setViewFrame:itemView Y:_h];
    [self.scrollView addSubview:itemView];
    _h = _h + 44;
    
    //订单编号
    itemView = [SRItemView loadFromNib];
    [itemView setTitle:@"订单编号" value:[self.orderInfo.code substringFromIndex:3]];
    [self setViewFrame:itemView Y:_h];
    [self.scrollView addSubview:itemView];
    _h = _h + 44;
    
    //兑换仓库单店不显示兑换仓库： 默认开微店隐藏
//    if ([[Platform Instance] getShopMode] != 1) {
//        itemView = [SRItemView loadFromNib];
//        [itemView setTitle:@"兑换仓库" value:self.orderInfo.shopName];
//        [self setViewFrame:itemView Y:_h];
//        [self.scrollView addSubview:itemView];
//        _h = _h + 44;
//
//    }
    //下单时间
    itemView = [SRItemView loadFromNib];
    [itemView setTitle:@"下单时间" value:[DateUtils formateTime:self.orderInfo.openTime]];
    [self setViewFrame:itemView Y:_h];
    [self.scrollView addSubview:itemView];
    _h = _h + 44;
    
    //积分合计
    if(self.orderInfo.consume_points>0){
        itemView = [SRItemView loadFromNib];
        
        NSAttributedString *points = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.orderInfo.consume_points] attributes:@{NSForegroundColorAttributeName:RGB(204, 0, 0)}];
        [itemView setTitle:@"积分合计" attributedValue:points];
        [self setViewFrame:itemView Y:_h];
        [self.scrollView addSubview:itemView];
        _h = _h + 44;
    }
    
    //收货人
    //收货人手机号码
    //收货地址
    NSString *address=nil;
    if (self.orderInfo.address==nil || [self.orderInfo.address isEqual:@""]) {
        address = [NSString stringWithFormat:@"%@      %@", self.orderInfo.receiverName, self.orderInfo.mobile];
    }else{
        address = [NSString stringWithFormat:@"%@      %@\n%@", self.orderInfo.receiverName, self.orderInfo.mobile, self.orderInfo.address];
    }
    
    SRItemView2 *itemView2 = [SRItemView2 loadFromNib];
    [itemView2 setTitle:@"收货地址" value:address];
    [self setViewFrame:itemView2 Y:_h];
    [self.scrollView addSubview:itemView2];
    _h = _h + itemView2.frame.size.height;
    
    _h = _h + 20;
    //订单商品
    SRTitleView *returnGoodsView = [SRTitleView titleViewWith:@""];
    [self.scrollView addSubview:returnGoodsView];
    [self setViewFrame:returnGoodsView Y:_h];
    if ([[self getStatusString:self.orderInfo.status] isEqualToString:@"配送中"]||[[self getStatusString:self.orderInfo.status] isEqualToString:@"配送完成"]||[[self getStatusString:self.orderInfo.status] isEqualToString:@"交易成功"]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(320-52, 0, 52, 44);
        [button setImage:[UIImage imageNamed:@"ico_logistics.png"] forState:UIControlStateNormal];
        [returnGoodsView addSubview:button];
        [button addTarget:self action:@selector(logisticsClick:) forControlEvents:UIControlEventTouchUpInside];
        returnGoodsView.rightMarginConstraint.constant = 12 + 35;
        [returnGoodsView setLblText:[self getStatusString:self.orderInfo.status] color:nil];
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"订单商品"];
    
    NSString *total = [NSString stringWithFormat:@"%ld", (long)[self getGoodsTotal]];
    
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"（合计 "
                                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13] }]];
    
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:total
                                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                                                              NSForegroundColorAttributeName:RGB(204, 0, 0)}]];
    
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@" 件）" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13] }]];
    [returnGoodsView setAttributedTitle:attr];
    _h = _h + 44 + 8;
    
    // 商品列表
    for (int i = 0; i < self.instanceVoJsonList.count; i++) {
        InstanceVo *instanceVo = [self.instanceVoJsonList objectAtIndex:i];
        
        SRGoodsView *goodsView = [SRGoodsView loadFromNib];
        [goodsView initPointOrderData:instanceVo];
        [self.scrollView addSubview:goodsView];
        [self setViewFrame:goodsView Y:_h];
        _h = _h + goodsView.ls_height;
    }
    
    //按钮
    //确认配送
    // 订单状态为“待处理”时表示
    if (self.orderInfo.status == 1 || self.orderInfo.status == 15) {
        
        self.viewOper.hidden = NO;
        self.viewOper.frame = CGRectMake(0, _h, 320, 65);
        _h = _h + 65;
    }
    
    [self.scrollView setContentSize:CGSizeMake(320, _h + 10)];
}

#pragma mark - 物流点击事件
- (void)logisticsClick:(id)sender {
    
    OrderLogisticsInfoView *infoView = [[OrderLogisticsInfoView alloc] initWithNibName:[SystemUtil getXibName:@"OrderLogisticsInfoView"] bundle:nil];
    infoView.logisticsName = self.orderInfo.logisticsName;
    infoView.logisticsNo = self.orderInfo.logisticsNo;
    infoView.sendMan = self.orderInfo.sendMan;
    infoView.sendFee = [NSString stringWithFormat:@"%.2f", self.orderInfo.shopFreight];
    [self.navigationController pushViewController:infoView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

- (IBAction)sellOrderOperateClick:(UIButton *)sender {
    StoreOrderDistributionView *distributionView = [[StoreOrderDistributionView alloc] initWithNibName:@"StoreOrderDistributionView" bundle:nil];
    distributionView.expansionDic=self.orderInfo.expansionDic;
    distributionView.consume_points = self.orderInfo.consume_points;
    distributionView.confirmOrderBack = ^(NSDictionary *expansion) {
        
        //销售订单操作
        [self sellOrderOperate:@"confirm" expansion:expansion userOrderOpt:nil];
    };
    
    [self.navigationController pushViewController:distributionView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

- (void)sellOrderOperate:(NSString *)operateType expansion:(NSDictionary *)expansion userOrderOpt:(UserOrderOptVo *)userOrderOpt{
    __weak PointExOrderDetailView *weakSelf = self;
    NSDictionary *userOrderOptDic = [UserOrderOptVo getDictionaryData:userOrderOpt];
    [self.wechatService sellOrderOperate:self.orderInfo.orderId
                                  shopId:self.orderInfo.shopId
                             operateType:operateType
                               rejReason:nil
                                    code:self.orderInfo.code
                               expansion:expansion[@"expansion"]
                              employeeId:expansion[@"employeeId"]
                                 lastVer:self.orderInfo.lastVer
                                  outFee:expansion[@"outFee"]
                            userOrderOpt:userOrderOptDic
                       completionHandler:^(id json) {
                           [weakSelf gotoPointExOrderListView];
                           
                       } errorHandler:^(id json) {
                           [AlertBox show:json];
                       }];
    
}

#pragma mark - private
- (void)setViewFrame:(UIView *)view Y:(CGFloat)y {
    CGRect rect = view.frame;
    rect.origin.y = y;
    view.frame = rect;
}

#pragma mark 积分兑换管理页面
- (void)gotoPointExOrderListView {
    PointExOrderListView *weChatVc = nil;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[PointExOrderListView class]]) {
            weChatVc = (PointExOrderListView *)vc;
        }
    }
    [weChatVc.tableView headerBeginRefreshing];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popToViewController:weChatVc animated:NO];
}

- (NSString *)getStatusString:(short)status {
    //销售订单  状态:11待付款、12付款中、13待分配、15待处理、20配送中、21配送完成、16拒绝配送、22交易取消、23交易关闭
    //供货订单:15待处理、20配送中、21配送完成、16拒绝配送
    NSDictionary *statusDic = @{ @"11":@"待付款", @"13":@"待分配", @"15":@"待处理", @"16":@"拒绝配送", @"20":@"配送中", @"21":@"交易成功", @"22":@"交易取消", @"23":@"交易关闭",@"24":@"配送完成"};
    NSString *statusString = [statusDic objectForKey:[NSString stringWithFormat:@"%i", status]];
    if ([NSString isNotBlank:statusString]) {
        return statusString;
    } else {
        return @"";
    }
}

- (NSInteger)getGoodsTotal {
    
    NSInteger total = 0;
    
        for (InstanceVo *instanceVo in self.instanceVoJsonList) {
            total += instanceVo.accountNum;
        }
    
    return total;
}

@end
