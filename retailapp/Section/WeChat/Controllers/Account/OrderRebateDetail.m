//
//  WeChatRebateOrderDetail.m
//  retailapp
//
//  Created by diwangxie on 16/5/11.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrderRebateDetail.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "RebateOrdersVo.h"
#import "UIHelper.h"
#import "DateUtils.h"
#import "EditItemList4.h"


@interface OrderRebateDetail ()

@property (nonatomic, strong) BaseService             *service;           //网络服务
@end

@implementation OrderRebateDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTitleBox];
    [self loadWechatShopOrderDetail];
}

- (void)initTitleBox {
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"订单详情" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

// 请求微店销售订单详情
-(void)loadWechatShopOrderDetail {
    
    NSString *url = @"accountInfo/orderRebate/detail";
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:6];
    [param setValue:self.orderId forKey:@"orderId"];
    [param setValue:@(self.rebateState) forKey:@"rebateState"];
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        [self responseSuccess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)responseSuccess:(id)json {
    
    RebateOrdersVo *vo = [RebateOrdersVo convertToRebateOrdersVo:[json objectForKey:@"orderRebateDetailVo"]];
    NSMutableArray *array = vo.instances;
    if ([NSString isNotBlank:vo.orderCode]) {
        self.lblOrderCode.text = [vo.orderCode substringFromIndex:3];
    }
    NSString *rabateDetailStr = nil;
    NSString *rebateFeeStr = @"";
    NSString *marginProfitFeeStr = @"";
    NSString *supplyFeeStr = @"";
    NSString *returnFeeStr = @"";
    
    if ([ObjectUtil isNotNull:vo.weiPlatformFee]) {
        rabateDetailStr = [NSString stringWithFormat:@"%.2f(微平台)",[vo.weiPlatformFee doubleValue]];
        self.lblRebateDetail.text = rabateDetailStr;
        CGFloat h = self.lblRebateDetail.frame.size.height;
        UIFont *font = self.lblFee.font;
        CGSize maxSize = CGSizeMake(MAXFLOAT, h);
        CGSize sizeName = [NSString sizeWithText:rabateDetailStr maxSize:maxSize font:font];
        _leftRightScrollView.contentSize = CGSizeMake(sizeName.width/2+10,35);
        _lblRebateDetail.frame = CGRectMake(10, 7, sizeName.width/2, 21);
    } else {
        
        if ([ObjectUtil isNotNull:vo.rebateFee]) {
            rebateFeeStr = [NSString stringWithFormat:@"%.2f(返利)",[vo.rebateFee doubleValue]];
        }
        
        if ([ObjectUtil isNotNull: vo.marginProfit]) {
            if([ObjectUtil isNotNull:vo.rebateFee]) {
                if ([vo.marginProfit doubleValue] >= 0) {
                    marginProfitFeeStr = [NSString stringWithFormat:@" + %.2f(余利)",[vo.marginProfit doubleValue]];
                } else {
                    marginProfitFeeStr = [NSString stringWithFormat:@" - %.2f(余利)",[vo.marginProfit doubleValue]*-1];
                }
            } else {
                marginProfitFeeStr = [NSString stringWithFormat:@"%.2f(余利)",[vo.marginProfit doubleValue]];
            }
        }
        
        if([ObjectUtil isNotNull:vo.supplyFee]) {
            if ([ObjectUtil isNotNull:vo.marginProfit] || [ObjectUtil isNotNull:vo.rebateFee]) {
                supplyFeeStr = [NSString stringWithFormat:@" + %.2f(销售)",[vo.supplyFee doubleValue]];
            } else {
                supplyFeeStr = [NSString stringWithFormat:@"%.2f(销售)",[vo.supplyFee doubleValue]];
            }
        }
        
        if ([ObjectUtil isNotNull:vo.returnFee]) {
            if([vo.returnFee doubleValue] >= 0) {
                returnFeeStr = [NSString stringWithFormat:@" - %.2f(退款)",[vo.returnFee doubleValue]];
            } else {
                returnFeeStr = [NSString stringWithFormat:@" + %.2f(退款)",[vo.returnFee doubleValue]*-1];
            }
        }
        self.lblRebateDetail.text = [NSString stringWithFormat:@"%@%@%@%@",rebateFeeStr,marginProfitFeeStr,supplyFeeStr,returnFeeStr];
        CGFloat h = self.lblRebateDetail.frame.size.height;
        UIFont *font = self.lblFee.font;
        CGSize maxSize = CGSizeMake(MAXFLOAT, h);
        CGSize sizeName = [NSString sizeWithText:[NSString stringWithFormat:@"%@%@%@%@",rebateFeeStr,marginProfitFeeStr,supplyFeeStr,returnFeeStr] maxSize:maxSize font:font];
        _leftRightScrollView.contentSize = CGSizeMake(sizeName.width/2+10,35);
        _lblRebateDetail.frame = CGRectMake(10, 7, sizeName.width/2, 21);
    }
    _leftRightScrollView.showsVerticalScrollIndicator = NO;
    _leftRightScrollView.showsHorizontalScrollIndicator = NO;
    CGRect r = [ UIScreen mainScreen ].applicationFrame;
    
    if(_lblRebateDetail.frame.size.width >= r.size.width-20){
        _lblRebateDetail.ls_left += 20.0;
        [UIView beginAnimations:@"testAnimation" context:NULL];
        [UIView setAnimationDuration:3.0f];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationRepeatCount:999999];
        _lblRebateDetail.ls_left = (_lblRebateDetail.frame.size.width-r.size.width+20)*-1;
        [UIView commitAnimations];
    }
    
    if (vo.rebateOrderFee > 0) {
        self.lblFee.text = [NSString stringWithFormat:@"+%.2f",vo.rebateOrderFee];
    } else {
        self.lblFee.text = [NSString stringWithFormat:@"%.2f",vo.rebateOrderFee];
    }
    
    CGFloat h = self.lblFee.frame.size.height;
    UIFont *font = self.lblFee.font;
    CGSize maxSize = CGSizeMake(MAXFLOAT, h);
    CGSize sizeName = [NSString sizeWithText:[NSString stringWithFormat:@"+%.2f",vo.rebateOrderFee] maxSize:maxSize font:font];
    
    self.lblFee.ls_size = sizeName;
    CGFloat w =  self.lblFee.frame.size.width;
    
    self.lblRebateOrderState.frame=CGRectMake(w+10, 47, 60, 21);
    
    if(vo.orderState > 0) {
        self.lblOrderState.text=[self getStatusString:vo.orderState];
    }
    
    if (vo.rebateState > 0) {
        if (vo.rebateState == 1) {
            self.lblRebateOrderState.textColor=[UIColor colorWithRed:0/255.0 green:136/255.0 blue:204/255.0 alpha:1];
        } else {
            self.lblRebateOrderState.textColor=[ColorHelper getGreenColor];
        }
        self.lblRebateOrderState.text = [self  getRabateString:vo.rebateState];
    }
    
    for(UIView *view in [_content subviews]) {
        [view removeFromSuperview];
    }
    
    if([ObjectUtil isNotNull:array]){
        int hh = 0;
        _content.frame=CGRectMake(0, 0, 320, array.count*80);
        [self.container addSubview:_content];
        [self.container insertSubview:_content belowSubview:self.footer];
        
        for (NSDictionary *dic in array) {
            EditItemList4 *edit = [[EditItemList4 alloc] init];
            [edit initFromNib];
            edit.frame = CGRectMake(0, hh, 320, 80);
            hh = hh+80;
            [edit initCode:dic];
            [_content addSubview:edit];
        }
        [self.container insertSubview:_content belowSubview:self.footer];
    }
    
    if (vo.outFee > 0) {
        self.lblOutFee.text = [NSString stringWithFormat:@"(含配送费:%.2f)",vo.outFee];
    } else {
        [self.lblOutFee setHidden:YES];
        self.lblTotalFee.frame = CGRectMake(10, 0, 300, 44);
    }
    
    
    if ([vo.outType isEqualToString:@"weixin"]) {
        self.lblOutType.text = @"微店订单";
    } else if ([vo.outType isEqualToString:@"weiPlatform"]) {//微平台订单
        self.lblOutType.text = @"微平台订单";
    } else {
        self.lblOutType.text = @"实体订单";
    }
    
    self.lblPayMode.text = [self getPayModeString:vo.payMode];
    if (vo.orderKind == 4) {
        self.lblSendType.text = @"上门自提";
    }else{
        self.lblSendType.text = @"配送到家";
    }
    self.lblCreateTime.text = [DateUtils formateTime:vo.openTime];
    self.lblTotalFee.text = [NSString stringWithFormat:@"合计:￥%.2f",vo.orderTotalFee];
    
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
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

- (NSString *)getRabateString:(short)status {
    //返利订单  状态:1待结算、2可提现
    NSDictionary *statusDic = @{ @"1":@"(待结算)", @"2":@"(可提现)"};
    NSString *statusString = [statusDic objectForKey:[NSString stringWithFormat:@"%i", status]];
    if ([NSString isNotBlank:statusString]) {
        return statusString;
    } else {
        return @"";
    }
}

- (NSString *)getPayModeString:(short)status {
    NSDictionary *statusDic = @{@"1":@"会员卡", @"2":@"优惠券", @"3":@"支付宝", @"4":@"银行卡", @"5":@"现金", @"6":@"微支付", @"99":@"其他",@"8":@"[支付宝]",@"9":@"[微信]",@"50":@"货到付款",@"51":@"手动退款", @"52":@"[QQ钱包]"};
    NSString *statusString = [statusDic objectForKey:[NSString stringWithFormat:@"%i", status]];
    if ([NSString isNotBlank:statusString]) {
        return statusString;
    } else {
        return @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
