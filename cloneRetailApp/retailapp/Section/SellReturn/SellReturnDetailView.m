//
//  SellReturnDetailView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/11/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SellReturnDetailView.h"
#import "ServiceFactory.h"
#import "SellReturnService.h"
#import "AlertBox.h"
#import "SRTitleView.h"
#import "SRItemView.h"
#import "SRItemView2.h"
#import "SRGoodsView.h"
#import "SRButtonView.h"
#import "RetailSellReturnVo.h"
#import "DateUtils.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "SymbolNumberInputBox.h"
#import "OptionPickerBox.h"
#import "NameItemVO.h"
#import "RefuseReasonView.h"
#import "DealSellReturnData.h"
#import "SellReturnAddressView.h"
#import "SellReturnAddressView.h"
#import "ShopReturnInfoVo.h"
#import "OrderLogisticsInfoView.h"

#import "XHAnimalUtil.h"

#import "WechatOrderDetailView.h"

#define RETURNTYPE 1

#define DISCOUNTAMOUNT 2

@interface SellReturnDetailView ()<INavigateEvent, IEditItemListEvent, OptionPickerClient,SymbolNumberInputClient>

@property (nonatomic, strong) SellReturnService *sellReturnService;
@property (nonatomic ,strong) RetailSellReturnVo *sellReturnDetail;//退货单详情
@property (nonatomic, strong) EditItemList *lstReturnReason;
@property (nonatomic, strong) EditItemList *txtAmount;//实退金额
@property (nonatomic, strong) DealSellReturnData *dealSellReturnData;
@property (nonatomic, strong) NSMutableArray *returnTypeList;//退货类型列表
@property (nonatomic) BOOL isPush;//是否刷新页面
@end

@implementation SellReturnDetailView

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sellReturnService = [ServiceFactory shareInstance].sellReturnService;
    self.dealSellReturnData = [[DealSellReturnData alloc] init];
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:self.sellReturn.customerName backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
    [self configHelpButton:HELP_WECHAT_RETURN_AUDIT_DETAIL];
    [self loadData];
    
    //退货类型列表
    [self loadReturnTypeList];
}

- (void)loadData {
    [self.sellReturnService sellReturnDetail:self.sellReturn.id
                           completionHandler:^(id json) {
                               //退货单一览
                               self.sellReturnDetail = [RetailSellReturnVo converToVo:json[@"sellReturn"]];
                               [self displayData];
                           } errorHandler:^(id json) {
                               [AlertBox show:json];
                           }];
}

- (void)loadReturnTypeList {
    [self.sellReturnService returnTypeListCompletionHandler:^(id json) {
        //退货单一览
        self.returnTypeList = [NSMutableArray array];
        NSMutableArray *returnTypeList = json[@"returnTypeList"];
        if ([ObjectUtil isNotEmpty:returnTypeList]) {
            NameItemVO *nameItemVO = nil;
            for (NSDictionary* dic in returnTypeList) {
                nameItemVO = [[NameItemVO alloc] initWithVal:dic[@"name"] andId:dic[@"name"]];
                [self.returnTypeList addObject:nameItemVO];
            }
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == 1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
        _sellReturnDetailViewBlock(nil);
    }
}


- (void)displayData {
    if (!self.sellReturnDetail) {
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
    
    //退货状态
    SRItemView *itemView = [SRItemView loadFromNib];
    [itemView setTitle:@"退货状态" value:[self getStatusString:self.sellReturnDetail.status]];
    [self setViewFrame:itemView Y:_h];
    [self.scrollView addSubview:itemView];
    _h = _h + 44;
    
    //退货单号
    itemView = [SRItemView loadFromNib];
    [itemView setTitle:@"退货单号" value:self.sellReturnDetail.globalCode];
    [self setViewFrame:itemView Y:_h];
    [self.scrollView addSubview:itemView];
    _h = _h + 44;
    
    //退货时间
    itemView = [SRItemView loadFromNib];
    [itemView setTitle:@"退货时间" value:[DateUtils formateTime:self.sellReturnDetail.createTime]];
    [self setViewFrame:itemView Y:_h];
    [self.scrollView addSubview:itemView];
    _h = _h + 44;
    
    //原订单支付方式
    NSString *payMode = [self getPayModeString:self.sellReturnDetail.payMode];
    if (self.sellReturnDetail.isCashOnDelivery == 1) { //货到付款
        if (![payMode containsString:@"货到付款"]) {
             payMode = [payMode stringByAppendingString:@"(货到付款)"];
        }
    }
    
    itemView = [SRItemView loadFromNib];
    [itemView setTitle:@"原订单支付方式" value:payMode];
    [self setViewFrame:itemView Y:_h];
    [self.scrollView addSubview:itemView];
    _h = _h + 44;
    
    //原订单详情
    SRButtonView *buttonView = [SRButtonView loadFromNibWithTitle:@"原订单详情"];
    [buttonView.buttonNext addTarget:self action:@selector(orderDetailClick:) forControlEvents:UIControlEventTouchUpInside];
    [self setViewFrame:buttonView Y:_h];
    [self.scrollView addSubview:buttonView];
    _h = _h + 44;
    
    _h = _h + 20;
    
    //退货商品
    SRTitleView *returnGoodsView = [SRTitleView loadFromNibWithTitle:@""];
    [self.scrollView addSubview:returnGoodsView];
    [self setViewFrame:returnGoodsView Y:_h];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"退货商品"];
    double amount = 0;
    if (self.sellReturnDetail.resultAmount > 0) {
        amount = self.sellReturnDetail.resultAmount;
    }

    NSString *total = [NSString stringWithFormat:@"%.0f", self.sellReturnDetail.totalCount];
    //    NSString *amount = [NSString stringWithFormat:@"￥%.2f", self.sellReturn.totalAmount];
    
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"（" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15] }]];
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"合计 " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                                                                NSForegroundColorAttributeName:RGB(102, 102, 102)}]];
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:total attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                                                               NSForegroundColorAttributeName:RGB(204, 0, 0)}]];
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@" 件，" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                                                                NSForegroundColorAttributeName:RGB(102, 102, 102)}]];
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%.2f",amount] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                                                                                                     NSForegroundColorAttributeName:RGB(204, 0, 0)}]];
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"）" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15] }]];
    
    [returnGoodsView setAttributedTitle:attr];
    _h = _h + 44 + 8;
    
    // 商品列表
    for (int i = 0; i < self.sellReturnDetail.instanceList.count; i++) {
        RetailInstanceVo *instanceVo = [self.sellReturnDetail.instanceList objectAtIndex:i];
        SRGoodsView *goodsView = [SRGoodsView loadFromNib];
        [self.scrollView addSubview:goodsView];
        [goodsView initData:instanceVo];
        [self setViewFrame:goodsView Y:_h];
        _h = _h + goodsView.ls_height;
    }
    
    _h = _h + 20;
    //退货信息
    SRTitleView *returnInfoView = [SRTitleView loadFromNibWithTitle:@"退货信息"];
    [self.scrollView addSubview:returnInfoView];
    [self setViewFrame:returnInfoView Y:_h];
    _h = _h + 44;
    
    // 物流信息 logisticsNo TODO
    if ((_sellReturnDetail.status == 3 || _sellReturnDetail.status == 4) && [NSString isNotBlank:_sellReturnDetail.logisticsNo]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(320-62, 0, 52, 44);
        [button setImage:[UIImage imageNamed:@"ico_logistics"] forState:UIControlStateNormal];
        [returnInfoView addSubview:button];
        [button addTarget:self action:@selector(logisticsClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([NSString isNotBlank:self.sellReturnDetail.returnType]) {
        itemView = [SRItemView loadFromNib];
        [itemView setTitle:@"退货类型" value:self.sellReturnDetail.returnType];
        [self setViewFrame:itemView Y:_h];
        [self.scrollView addSubview:itemView];
        _h = _h + 44;
    }
    
//    if ([NSString isNotBlank:self.sellReturn.returnType]) {
//    
//    //退货类型 -退货状态只有是“待审核”、“同意退货”、“退货中”时可修改
//    if([[Platform Instance] getShopMode] == 3 && [[Platform Instance] isTopOrg] && ![[Platform Instance] isBigCompanion]){
//        if (self.sellReturn.returnSource==1) {
//            if (self.sellReturn.status == 1 || self.sellReturn.status == 3 || self.sellReturn.status == 4) {
//                EditItemList *lstRetuenType = [[EditItemList alloc] initWithFrame:CGRectMake(0, _h, 320, 44)];
//                [lstRetuenType initLabel:@"退货类型" withHit:nil delegate:self];
//                [lstRetuenType initData:self.sellReturn.returnType withVal:self.sellReturn.returnType];
//                [self.scrollView addSubview:lstRetuenType];
//                lstRetuenType.tag=RETURNTYPE;
//                self.lstReturnReason = lstRetuenType;
//                self.dealSellReturnData.returnTypeId = [NSString stringWithFormat:@"%i",self.sellReturn.returnTypeId];
//            } else {
//                itemView = [SRItemView loadFromNib];
//                [itemView setTitle:@"退货类型" value:self.sellReturn.returnType];
//                [self setViewFrame:itemView Y:_h];
//                [self.scrollView addSubview:itemView];
//            }
//        }else{
//            itemView = [SRItemView loadFromNib];
//            [itemView setTitle:@"退货类型" value:self.sellReturn.returnType];
//            [self setViewFrame:itemView Y:_h];
//            [self.scrollView addSubview:itemView];
//        }
//    }else{
//        if (self.sellReturn.status == 1 || self.sellReturn.status == 3 || self.sellReturn.status == 4) {
//            EditItemList *lstRetuenType = [[EditItemList alloc] initWithFrame:CGRectMake(0, _h, 320, 44)];
//            [lstRetuenType initLabel:@"退货类型" withHit:nil delegate:self];
//            [lstRetuenType initData:self.sellReturn.returnType withVal:[NSString stringWithFormat:@"%i",self.sellReturn.returnTypeId]];
//            [self.scrollView addSubview:lstRetuenType];
//            lstRetuenType.tag=RETURNTYPE;
//            self.lstReturnReason = lstRetuenType;
//            self.dealSellReturnData.returnTypeId = [NSString stringWithFormat:@"%i",self.sellReturn.returnTypeId];
//        }else {
//            itemView = [SRItemView loadFromNib];
//            [itemView setTitle:@"退货类型" value:self.sellReturn.returnType];
//            [self setViewFrame:itemView Y:_h];
//            [self.scrollView addSubview:itemView];
//        }
//        
//    }
//    
//    _h = _h + 44;
//    }
    
    //应退金额(元)
    itemView = [SRItemView loadFromNib];
    [itemView setTitle:@"应退金额(元)" value:[NSString stringWithFormat:@"%.2f",self.sellReturn.resultAmount]];
    [self setViewFrame:itemView Y:_h];
    [self.scrollView addSubview:itemView];
    
    _h = _h + 44;
    
    //实退金额(元)
    // ①、退货状态为“待审核”时默认值与应退金额相同；
    // ②、退货状态只有是“待审核”、“同意退货”、“退货中”时可修改，其他状态标签表示
    // ③、退货状态是“拒绝退货”、“拒绝退款”时，显示0，不能修改
    if([[Platform Instance] getShopMode] == 3 && [[Platform Instance] isTopOrg]){
        if (self.sellReturn.returnSource == 1) {
            if (self.sellReturn.status == 1 || self.sellReturn.status == 3 || self.sellReturn.status == 4) {
                _txtAmount = [[EditItemList alloc] initWithFrame:CGRectMake(0, _h, 320, 44)];
                _txtAmount.line.frame = CGRectMake(10, 43, 300, 1);
                _txtAmount.tag=DISCOUNTAMOUNT;
                if (self.sellReturn.status == 1) {
                    [_txtAmount initLabel:@"实退金额(元)" withHit:nil delegate:self];
                    
                    [_txtAmount initData:[NSString stringWithFormat:@"%.2f",self.sellReturn.resultAmount] withVal:[NSString stringWithFormat:@"%.2f",self.sellReturn.resultAmount]];
                    self.dealSellReturnData.returnAmount = [NSNumber numberWithDouble:self.sellReturn.resultAmount];
                } else {
                    [_txtAmount initLabel:@"实退金额(元)" withHit:nil delegate:self];
                    [_txtAmount initData:[NSString stringWithFormat:@"%.2f",self.sellReturn.discountAmount] withVal:[NSString stringWithFormat:@"%.2f",self.sellReturn.discountAmount]];
                    self.dealSellReturnData.returnAmount = [NSNumber numberWithDouble:self.sellReturn.discountAmount];
                }
                [self.scrollView addSubview:_txtAmount];
            } else {
                itemView = [SRItemView loadFromNib];
                if (self.sellReturn.status == 6 || self.sellReturn.status == 7) {
                    [itemView setTitle:@"实退金额(元)" value:@"0"];
                    self.dealSellReturnData.returnAmount = @0;
                } else {
                    [itemView setTitle:@"实退金额(元)" value:[NSString stringWithFormat:@"%.2f",self.sellReturn.discountAmount]];
                    self.dealSellReturnData.returnAmount = [NSNumber numberWithDouble:self.sellReturn.discountAmount];
                }
                [self setViewFrame:itemView Y:_h];
                [self.scrollView addSubview:itemView];
            }
        }else{
            itemView = [SRItemView loadFromNib];
            if (self.sellReturn.status == 6 || self.sellReturn.status == 7) {
                [itemView setTitle:@"实退金额(元)" value:@"0"];
                self.dealSellReturnData.returnAmount = @0;
            } else {
                [itemView setTitle:@"实退金额(元)" value:[NSString stringWithFormat:@"%.2f",self.sellReturn.discountAmount]];
                self.dealSellReturnData.returnAmount = [NSNumber numberWithDouble:self.sellReturn.discountAmount];
            }
            [self setViewFrame:itemView Y:_h];
            [self.scrollView addSubview:itemView];
        }
    } else {
        if (self.sellReturn.status == 1 || self.sellReturn.status == 3 || self.sellReturn.status == 4) {
            _txtAmount = [[EditItemList alloc] initWithFrame:CGRectMake(0, _h, 320, 44)];
            _txtAmount.line.frame = CGRectMake(10, 43, 300, 1);
            _txtAmount.tag=DISCOUNTAMOUNT;
            if (self.sellReturn.status == 1) {
                [_txtAmount initLabel:@"实退金额(元)" withHit:nil delegate:self];
                
                [_txtAmount initData:[NSString stringWithFormat:@"%.2f",self.sellReturn.discountAmount] withVal:[NSString stringWithFormat:@"%.2f",self.sellReturn.discountAmount]];
                self.dealSellReturnData.returnAmount = [NSNumber numberWithDouble:self.sellReturn.discountAmount];
            } else {
                [_txtAmount initLabel:@"实退金额(元)" withHit:nil delegate:self];
                [_txtAmount initData:[NSString stringWithFormat:@"%.2f",self.sellReturn.discountAmount] withVal:[NSString stringWithFormat:@"%.2f",self.sellReturn.discountAmount]];
                self.dealSellReturnData.returnAmount = [NSNumber numberWithDouble:self.sellReturn.discountAmount];
            }
            [self.scrollView addSubview:_txtAmount];
         } else {
            itemView = [SRItemView loadFromNib];
            if (self.sellReturn.status == 6 || self.sellReturn.status == 7) {
                [itemView setTitle:@"实退金额(元)" value:@"0"];
                self.dealSellReturnData.returnAmount = @0;
            } else {
                [itemView setTitle:@"实退金额(元)" value:[NSString stringWithFormat:@"%.2f",self.sellReturn.discountAmount]];
                self.dealSellReturnData.returnAmount = [NSNumber numberWithDouble:self.sellReturn.discountAmount];
            }
            [self setViewFrame:itemView Y:_h];
            [self.scrollView addSubview:itemView];
        }
        
    }
    _h = _h + 44;
    
    //退货理由
    SRItemView2 *itemView2 = [SRItemView2 loadFromNib];
    NSString *val = nil;
    if ([NSString isBlank:self.sellReturnDetail.returnType]) {
        val = @"店家拒绝";
    } else {
        val = self.sellReturnDetail.returnReason;
    }
    [itemView2 setTitle:@"退货理由" value:val];
    [self setViewFrame:itemView2 Y:_h];
    [self.scrollView addSubview:itemView2];
    _h = _h + itemView2.frame.size.height;
    
    self.dealSellReturnData.returnReason = self.sellReturnDetail.returnReason;
    
    //拒绝退货原因
    if (self.sellReturn.status == 6) {
        itemView2 = [SRItemView2 loadFromNib];
        [itemView2 setTitle:@"拒绝退货原因" value:self.sellReturnDetail.refuseReason];
        [self setViewFrame:itemView2 Y:_h];
        [self.scrollView addSubview:itemView2];
        _h = _h + itemView2.frame.size.height;
        
        self.dealSellReturnData.refuseReason = self.sellReturnDetail.refuseReason;
    }
    
    //拒绝退款原因
    if (self.sellReturn.status == 7) {
        itemView2 = [SRItemView2 loadFromNib];
        [itemView2 setTitle:@"拒绝退款原因" value:self.sellReturnDetail.refuseReason];
        [self setViewFrame:itemView2 Y:_h];
        [self.scrollView addSubview:itemView2];
        _h = _h + itemView2.frame.size.height;
        
        self.dealSellReturnData.refuseReason = self.sellReturnDetail.refuseReason;
    }
    
    //退货地址 - 联系人姓名、手机号、退货地址
    if ([NSString isNotBlank:self.sellReturnDetail.address]) {
        NSString *address = [NSString stringWithFormat:@"%@      %@\n%@", self.sellReturnDetail.linkeMan, self.sellReturnDetail.phone, self.sellReturnDetail.address];
        itemView2 = [SRItemView2 loadFromNib];
        [itemView2 setTitle:@"退货地址" value:address];
        [self setViewFrame:itemView2 Y:_h];
        [self.scrollView addSubview:itemView2];
        _h = _h + itemView2.frame.size.height;
    }
    
    //按钮
    self.viewOper.hidden = YES;
    self.btnRed.hidden = NO;
    self.btnGreen.frame = CGRectMake(165, 10, 140, 45);
    if (![[Platform Instance] isTopOrg]) {
        if(self.sellReturnDetail.status == 1) {
            self.viewOper.hidden = NO;
            self.viewOper.frame = CGRectMake(0, _h, 320, 65);
            [self.btnRed setTitle:@"拒绝退货" forState:UIControlStateNormal];
            self.btnRed.tag = 1;
            [self.btnGreen setTitle:@"同意退货" forState:UIControlStateNormal];
            self.btnGreen.tag = 2;
            _h = _h + 65;
        } else if (self.sellReturnDetail.status == 3 || self.sellReturnDetail.status == 4) {
            self.viewOper.hidden = NO;
            self.viewOper.frame = CGRectMake(0, _h, 320, 65);
            [self.btnRed setTitle:@"拒绝退款" forState:UIControlStateNormal];
            self.btnRed.tag = 3;
            [self.btnGreen setTitle:@"同意退款" forState:UIControlStateNormal];
            self.btnGreen.tag = 4;
            _h = _h + 65;
        }
    } 
    [self.scrollView setContentSize:CGSizeMake(320, _h + 10)];
}

- (void)onItemListClick:(EditItemList*)obj {
    
    if (obj.tag == DISCOUNTAMOUNT) {
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
        
    } else if(obj.tag == RETURNTYPE) {
        [OptionPickerBox initData:self.returnTypeList itemId:[obj getDataLabel]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    
    id<INameItem> item = (id<INameItem>)selectObj;
    [self.lstReturnReason initData:[item obtainItemName] withVal:[item obtainItemId]];
    return YES;
}

#pragma mark - SymbolNumberInputClient协议
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    if (eventType == DISCOUNTAMOUNT) {
        [_txtAmount changeData:[NSString stringWithFormat:@"%.2f",val.doubleValue] withVal:val];
        self.dealSellReturnData.returnAmount=[NSNumber numberWithDouble:[_txtAmount getStrVal].doubleValue];
    }
}

//原订单详细
- (void)orderDetailClick:(id)sender {
    WechatOrderDetailView *detailView = [[WechatOrderDetailView alloc] initWithNibName:[SystemUtil getXibName:@"WechatOrderDetailView"] bundle:nil];
    detailView.orderId = self.sellReturn.orignId;
    detailView.orderType = 1;
    detailView.shopId = self.sellReturn.shopId;
    detailView.receiverName = self.sellReturn.customerName;
    detailView.type = 1;
    [self.navigationController pushViewController:detailView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

- (IBAction)sellReturnDealClick:(UIButton *)sender {
    
    //拒绝退货 拒绝退款
    if (sender.tag == 1 || sender.tag == 3) {
        if (sender.tag==3) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"拒绝退款操作不会将退货商品入库，确定要拒绝吗？" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
            [alertView show];
            alertView.tag = (short)sender.tag;
        }else{
            RefuseReasonView *reasonView = [[RefuseReasonView alloc] initWithNibName:[SystemUtil getXibName:@"RefuseReasonView"] bundle:nil];
            reasonView.status = (int)sender.tag;
            reasonView.refuseReasonBack = ^(NSString *reason) {
                self.dealSellReturnData.refuseReason = reason;
                
                //处理退货单
                [self dealSellReturn:(short)sender.tag];
            };
            [self.navigationController pushViewController:reasonView animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        }
    }
    //同意退货
    else if (sender.tag == 2) {
        if (self.sellReturn.resultAmount<[_txtAmount getStrVal].doubleValue) {
            [AlertBox show:@"当前实退金额大于应退金额！无法操作！"];
            return;
        }else{
            [self sellReturnAddress:(short)sender.tag];
        }
    } else {
        //4-同意退款 5-转入自动退款 6-手动退款成功
        if (sender.tag == 4) {
            if (self.sellReturn.resultAmount < [_txtAmount getStrVal].doubleValue) {
                [AlertBox show:@"当前实退金额大于应退金额！无法操作！"];
                return;
            } else {
                [self dealSellReturn:(short)sender.tag];
            }
        } else {
            [self dealSellReturn:(short)sender.tag];
        }
        //处理退货单
        
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 3 && buttonIndex == 1) {
        RefuseReasonView *reasonView = [[RefuseReasonView alloc] initWithNibName:[SystemUtil getXibName:@"RefuseReasonView"] bundle:nil];
        reasonView.status = (int)alertView.tag;
        reasonView.refuseReasonBack = ^(NSString *reason) {
            self.dealSellReturnData.refuseReason = reason;
            
            //处理退货单
            [self dealSellReturn:(short)alertView.tag];
        };
        [self.navigationController pushViewController:reasonView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }
}

//处理退货地址
-(void)sellReturnAddress:(short)tag{
    SellReturnAddressView *addressView = [[SellReturnAddressView alloc] initWithNibName:@"SellReturnAddressView" bundle:nil];
    addressView.shopId = self.sellReturn.shopId;
    addressView.sellReturnAddressBack = ^(ShopReturnInfoVo *infoVo) {
        self.dealSellReturnData.linkman = infoVo.linkMan;
        self.dealSellReturnData.phone = infoVo.phone;
        self.dealSellReturnData.address = infoVo.address;
        self.dealSellReturnData.provinceId = infoVo.provinceid;
        self.dealSellReturnData.cityId = infoVo.cityid;
        self.dealSellReturnData.countyId = infoVo.countyid;
        self.dealSellReturnData.zipCode = infoVo.zipcode;
        
        //处理退货单
        [self dealSellReturn:tag];
    };
    
    [self.navigationController presentViewController:addressView animated:NO completion:nil];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

//处理退货单
- (void)dealSellReturn:(short)opType {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (opType > 0) {
        [param setValue:[NSNumber numberWithShort:opType] forKey:@"opType"];
    }
    [param setValue:self.sellReturn.code forKey:@"code"];
    [param setValue:self.dealSellReturnData.returnTypeId forKey:@"returnTypeId"];
    [param setValue:self.dealSellReturnData.returnAmount forKey:@"returnAmount"];
    [param setValue:self.dealSellReturnData.returnReason forKey:@"returnReason"];
    [param setValue:self.dealSellReturnData.refuseReason forKey:@"refuseReason"];
    [param setValue:[NSNumber numberWithInteger:self.sellReturn.lastVer] forKey:@"lastVer"];
    [param setValue:self.dealSellReturnData.linkman forKey:@"linkman"];
    [param setValue:self.dealSellReturnData.phone forKey:@"phone"];
    [param setValue:self.dealSellReturnData.address forKey:@"address"];
    [param setValue:self.dealSellReturnData.provinceId forKey:@"provinceId"];
    [param setValue:self.dealSellReturnData.cityId forKey:@"cityId"];
    [param setValue:self.dealSellReturnData.countyId forKey:@"countyId"];
    [param setValue:self.dealSellReturnData.zipCode forKey:@"zipCode"];
    [param setValue:self.sellReturn.shopId forKey:@"shopId"]; // 当前登录门店id
    [param setValue:self.sellReturn.id forKey:@"sellReturnId"];    // 退货id
    // 这个必须要传，不然后台找不到该单子
    [param setValue:self.sellReturn.organizationShopSellReturnId forKey:@"shopSellReturnId"]; // 连锁门店退货关联表ID
    [self.sellReturnService dealSellReturn:param completionHandler:^(id json) {
         [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
         [self.navigationController popViewControllerAnimated:NO];
        
         //退货订单对应的原销售订单的支付方式是“会员卡”以外时，同意退款处理成功后，
         //单店模式弹出提示信息：本订单需店家进行手动退款处理！退款成功后，请点击手动退款成功按钮完成退款操作！
         //连锁模式弹出提示信息：本订单需总部进行手动退款处理！退款成功后，由总部点击手动退款成功按钮完成退款操作！
         // 退款时: 单子是会员卡付款的，退款成功不给提示信息 ，（_sellReturnDetail.payMode == 99 标示其他付款方式， 1 标示会员卡付款）
         if (self.sellReturn.status == 3 && opType == 4 &&  _sellReturnDetail.payMode != 99 && _sellReturnDetail.payMode != 1) {
             
             // 退款时：实退金额 >0 才给提示信息
             if (self.dealSellReturnData.returnAmount && [self.dealSellReturnData.returnAmount compare:@(0.0)] == NSOrderedDescending) {
                 
                 // 会员卡支付和在微店下单的0元商品 ，不需要显示提示信息
//                 if ([[Platform Instance] getShopMode] == 1) {
                     [AlertBox show:@"本订单需店家进行手动退款处理！退款成功后，请进入退款管理中完成退款操作！"];
//                 } else {
//                     [AlertBox show:@"本订单需总部进行手动退款处理！退款成功后，由总部进入退款管理中完成退款操作！"];
//                 }
             }
         }
         _sellReturnDetailViewBlock(nil);
         
    } errorHandler:^(id json) {
         [AlertBox show:json];
    }];
}

- (void)logisticsClick:(id)sender {
    
    OrderLogisticsInfoView *infoView = [[OrderLogisticsInfoView alloc] initWithNibName:[SystemUtil getXibName:@"OrderLogisticsInfoView"] bundle:nil];
    infoView.logisticsName = _sellReturnDetail.logisticsName;
    infoView.logisticsNo = _sellReturnDetail.logisticsNo;
    infoView.type = 1;
    [self.navigationController pushViewController:infoView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];

}

//七天无理由退货、收到的商品与描述不符、商品质量问题、不满配送时间或配送人员、商品有破损、包装不完整、其他原因
#pragma mark - private
- (void)setViewFrame:(UIView *)view Y:(CGFloat)y {
    CGRect rect = view.frame;
    rect.origin.y = y;
    view.frame = rect;
}


// 微店订单 可能存在的状态
- (NSString *)getStatusString:(short)status {
    NSDictionary *statusDic = @{@"1":@"待审核", @"2":@"退款成功", @"3":@"同意退货", @"4":@"退货中", @"5":@"待退款", @"6":@"拒绝退货", @"7":@"拒绝退款", @"8":@"取消退货", @"9":@"退款失败"};
    NSString *statusString = [statusDic objectForKey:[NSString stringWithFormat:@"%i", status]];
    if ([NSString isNotBlank:statusString]) {
        return statusString;
    } else {
        return @"";
    }
}

// 支付 方式
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

- (void)loadSellReturnDetail:(NSInteger)viewType withIsPush:(BOOL)isPush callBack:(SellReturnDetail)callBack {
    self.sellReturnDetailViewBlock = callBack;
    self.isPush = isPush;
    if (!isPush) {
        [self loadData];
    }
}

@end
