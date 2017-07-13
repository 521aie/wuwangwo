//
//  LSPaymentOrderDetailController.m
//  retailapp
//
//  Created by guozhi on 2016/12/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSPaymentOrderDetailController.h"
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "LSPaymentOrderDetailCell.h"
#import "LSPaymentOrderDetailMemberView.h"
#import "LSPaymentOrderDetailHeaderView.h"
#import "LSPaymentOrderDetailFooterView.h"
#import "AlertBox.h"
#import "LSOrderDetailReportVo.h"
#import "LSOrderReportVo.h"
#import "DateUtils.h"
#import "OrderInfoVo.h"
#import "OnlineChargeVo.h"

@interface LSPaymentOrderDetailController ()<INavigateEvent, UITableViewDelegate, UITableViewDataSource>
/** 标题 */
@property (nonatomic, strong) NavigateTitle2 *titleBox;
/** 表格 */
@property (nonatomic, strong)  UITableView *tableView;
/** 表头 */
@property (nonatomic, strong) LSPaymentOrderDetailHeaderView *viewHeader;
/** headerView */
@property (nonatomic, strong) UIView *viewMember;
/** footerView */
@property (nonatomic, strong) LSPaymentOrderDetailFooterView *viewFooter;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSDictionary *settlements;
@property (nonatomic, strong) OnlineChargeVo *onlineChargeVo;
/** <#注释#> */
@property (nonatomic, strong) OrderInfoVo *orderInfoVo;
@property (nonatomic, strong) LSPersonDetailVO *personDetailVO;
@end

@implementation LSPaymentOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configConatraints];
    [self loadData];
    [self configHelpButton:HELP_PAYMENT_ACCOUNT];
}

- (void)configViews {
    self.view.backgroundColor = [UIColor clearColor];
    self.datas = [NSMutableArray array];
    //标题
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"明细详情" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:self.titleBox];
    //表格
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 88;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)configConatraints {
    __weak typeof(self) wself = self;
    //配置标题
    [self.titleBox makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(wself.view);
        make.height.equalTo(64);
    }];
    //配置表格
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(wself.view);
        make.top.equalTo(wself.titleBox.bottom);
    }];
}

- (void)loadData {
    __weak typeof(self) wself = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //获取会员卡信息
    NSString *url = @"onlineReceipt/payPersonDetail";
    if ([ObjectUtil isNotNull:self.customerId]) {
        [param setValue:self.customerId forKey:@"customerId"];
    }
    if ([ObjectUtil isNotNull:self.customerRegisterId]) {
        [param setValue:self.customerRegisterId forKey:@"customerRegisterId"];
    }
    [param setValue:self.orderId forKey:@"orderId"];
    [param setValue:self.orderCode forKey:@"orderCode"];
    [param setValue:self.payMsgTag forKey:@"payMsgTag"];
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        wself.settlements = json[@"settlements"];
        NSDictionary *personDetail = json[@"personDetail"];
        //会员信息
        if ([ObjectUtil isNotNull:personDetail]) {
            wself.personDetailVO = [LSPersonDetailVO personDetailVOWithMap:personDetail];
        }
        //订单信息
        NSDictionary *orderInfoVo = json[@"orderInfoVo"];
        if ([ObjectUtil isNotNull:orderInfoVo]) {
            wself.orderInfoVo = [OrderInfoVo converToVo:orderInfoVo];
        }
        //充值信息
        NSDictionary *onlineChargeVo = json[@"onlineChargeVo"];
        if ([ObjectUtil isNotNull:onlineChargeVo]) {
            wself.onlineChargeVo = [OnlineChargeVo onlineChargeVoWithMap:onlineChargeVo];
        }
        //商品信息
        NSArray *instanceVoList = json[@"instanceVoList"];
        if ([ObjectUtil isNotNull:instanceVoList]) {
            wself.datas = [InstanceVo converToArr:instanceVoList];
            
        }
        if (wself.type == TypeConsume) {//订单收入
            //设置表头信息
            [wself.viewHeader setOrderInfoVo:wself.orderInfoVo memberInfo:wself.personDetailVO  orderCode:self.orderCode];
            wself.tableView.tableHeaderView = wself.viewHeader;
            
            [wself.tableView reloadData];
            //设置表尾信息
            [wself.viewFooter setOrderInfoVo:wself.orderInfoVo onlineChargeVo:wself.onlineChargeVo settlements:wself.settlements];
            wself.tableView.tableFooterView = wself.viewFooter;
        } else {
            //充值收入
            CGFloat topMargin = 0;
            UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 100)];
            viewHeader.backgroundColor = [UIColor clearColor];

            if ([NSString isNotBlank:wself.personDetailVO.payName]) {
                //会员View
                LSPaymentOrderDetailMemberView *viewMember = [LSPaymentOrderDetailMemberView paymentOrderDetailMemberView];
                [viewHeader addSubview:viewMember];
                //设置会员View数据
                viewMember.personDetailVO = wself.personDetailVO;
                
                //会员View约束
                [viewMember makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.equalTo(viewHeader);
                    make.height.equalTo(viewMember.ls_height);
                }];
                [viewHeader layoutIfNeeded];
                topMargin = viewMember.ls_height + 5;
            }
            //顶部图片
            UIImageView *imgViewTop = [[UIImageView alloc] init];
            imgViewTop.image = [UIImage imageNamed:@"img_bill_top"];
            imgViewTop.alpha = 0.8;
            [viewHeader addSubview:imgViewTop];
            //顶部图片约束
            [imgViewTop makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(viewHeader);
                make.top.equalTo(viewHeader).offset(topMargin);
                make.height.equalTo(5);
            }];
            topMargin = topMargin + 5;
            //中间白色背景
            UIView *viewBg = [[UIView alloc] init];
            viewBg.backgroundColor = [UIColor whiteColor];
            viewBg.alpha = 0.8;
            [viewHeader addSubview:viewBg];
            UIFont *font = [UIFont systemFontOfSize:13];
            UIColor *txtColor = [ColorHelper getTipColor6];
            //付款金额
            UILabel *lblAmount = [[UILabel alloc] init];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"付款金额   " attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:txtColor}];
            [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"¥" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[ColorHelper getRedColor]}]];
            [attr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",self.onlineChargeVo.pay.doubleValue] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25],NSForegroundColorAttributeName:[ColorHelper getRedColor]}]];
            lblAmount.attributedText = attr;
            [viewHeader addSubview:lblAmount];
            [lblAmount makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(viewHeader.top).offset(topMargin);
                make.left.equalTo(viewHeader.left).offset(10);
                make.height.equalTo(40);
            }];
            topMargin = topMargin + 40;
            //额外赠送
            NSString *txt = nil;
            if ([ObjectUtil isNull:self.onlineChargeVo.free_rule]&& [ObjectUtil isNull:self.onlineChargeVo.free_degree]) {
                txt = @"";
            } else if ([self isNull:self.onlineChargeVo.free_rule]&& [self isNotNull:self.onlineChargeVo.free_degree]) {
                txt = [NSString stringWithFormat:@"额外赠送    %d积分",self.onlineChargeVo.free_degree.intValue];
            } else if ([self isNotNull:self.onlineChargeVo.free_rule]&& [self isNull:self.onlineChargeVo.free_degree]) {
                txt = [NSString stringWithFormat:@"额外赠送    ¥%.2f",self.onlineChargeVo.free_rule.doubleValue];
            } else if ([self isNotNull:self.onlineChargeVo.free_rule]&& [self isNotNull:self.onlineChargeVo.free_degree]) {
                txt = [NSString stringWithFormat:@"额外赠送    ¥%.2f，%d积分",self.onlineChargeVo.free_rule.doubleValue,self.onlineChargeVo.free_degree.intValue];
            }
            if ([NSString isNotBlank:txt]) {
                UILabel *lblExtra = [[UILabel alloc] init];
                lblExtra.font = font;
                lblExtra.text = txt;
                lblExtra.textColor = txtColor;
                [viewHeader addSubview:lblExtra];
                [lblExtra makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(viewHeader.top).offset(topMargin);
                    make.left.equalTo(viewHeader.left).offset(10);
                    make.height.equalTo(40);
                }];
                topMargin = topMargin + 40;
            }
            //添加横线
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
            [viewHeader addSubview:line];
            [line makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(viewHeader.top).offset(topMargin);
                make.left.equalTo(viewHeader.left).offset(10);
                make.right.equalTo(viewHeader.right).offset(-10);
                make.height.equalTo(1);
            }];
            topMargin = topMargin + 1;
            
            NSString *txtCradNo = self.onlineChargeVo.cardNo;
            NSString *txtSeroalNo = self.onlineChargeVo.serialNo;
            if ([txtSeroalNo hasPrefix:@"RRW"]) {
                txtSeroalNo = [txtSeroalNo substringFromIndex:3];
            }
            NSString *txtPayType = @"";
            if (self.onlineChargeVo.payMode == 0) {
                if ([ObjectUtil isNotNull:self.settlements]) {
                    for (NSString *key in self.settlements.allKeys) {
                        NSString *val = [NSString stringWithFormat:@"%.2f",[self.settlements[key] doubleValue]];
                        txtPayType = [txtPayType stringByAppendingString:[NSString stringWithFormat:@"\n                  %@   %@元",key,val]];
                    }
                    if ([txtPayType hasPrefix:@"\n                  "]) {
                        txtPayType = [txtPayType substringFromIndex:19];
                    }
                }
            } else {
                txtPayType = [self getPayModeString:self.onlineChargeVo.payMode];
            }
            NSString *txtCreateTime = [DateUtils formateTime:self.onlineChargeVo.createTime];
            //会员卡号
            topMargin = topMargin + 10;
            UILabel *lbl = [[UILabel alloc] init];
            [viewHeader addSubview:lbl];
            lbl.textColor = [ColorHelper getTipColor6];
            lbl.font = font;
            lbl.text = [NSString stringWithFormat:@"会员卡号：%@",txtCradNo];
            [lbl makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(viewHeader.left).offset(10);
                make.top.equalTo(viewHeader.top).offset(topMargin);
                make.height.equalTo(20);
            }];
            topMargin = topMargin + 20;
            //充值流水号
            lbl = [[UILabel alloc] init];
            [viewHeader addSubview:lbl];
            lbl.textColor = [ColorHelper getTipColor6];
            lbl.font = font;
            lbl.text = @"充值流水号：";
            [lbl makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(viewHeader.left).offset(10);
                make.top.equalTo(viewHeader.top).offset(topMargin);
            }];
            [lbl setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [viewHeader layoutIfNeeded];
            
            
            UILabel *lblNo = [[UILabel alloc] init];
            [viewHeader addSubview:lblNo];
            lblNo.textColor = [ColorHelper getTipColor6];
            lblNo.font = font;
            lblNo.text = txtSeroalNo;
            lblNo.numberOfLines = 0;
            [lblNo makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lbl.right);
                make.top.equalTo(lbl.top);
                make.right.equalTo(viewHeader.right).offset(-10);
            }];
            [viewHeader layoutIfNeeded];
            topMargin = topMargin + lblNo.ls_height;
            
            //充值方式
            lbl = [[UILabel alloc] init];
            [viewHeader addSubview:lbl];
            lbl.textColor = [ColorHelper getTipColor6];
            lbl.font = font;
            if ([ObjectUtil isNotNull:self.channelType]) {
                if (self.channelType.intValue == 2) {
                    lbl.text = @"充值方式：微店充值";
                } else {
                    lbl.text = @"充值方式：实体充值";
                }
            }
            [lbl makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(viewHeader.left).offset(10);
                make.top.equalTo(viewHeader.top).offset(topMargin);
                make.height.equalTo(20);
            }];
            topMargin = topMargin + 20;
            
            //支付方式
            CGFloat payTypeH = [NSString sizeWithText:txtPayType maxSize:CGSizeMake(300, MAXFLOAT) font:font].height;
            payTypeH = payTypeH < 20 ? 20 : payTypeH;
            lbl = [[UILabel alloc] init];
            [viewHeader addSubview:lbl];
            lbl.textColor = [ColorHelper getTipColor6];
            lbl.font = font;
            lbl.text = [NSString stringWithFormat:@"支付方式：%@",txtPayType];
            [lbl makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(viewHeader.left).offset(10);
                make.top.equalTo(viewHeader.top).offset(topMargin);
                make.height.equalTo(payTypeH);
            }];
            topMargin = topMargin + payTypeH;
            
            //充值时间
            lbl = [[UILabel alloc] init];
            [viewHeader addSubview:lbl];
            lbl.textColor = [ColorHelper getTipColor6];
            lbl.font = font;
            lbl.text = [NSString stringWithFormat:@"充值时间：%@",txtCreateTime];
            [lbl makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(viewHeader.left).offset(10);
                make.top.equalTo(viewHeader.top).offset(topMargin);
                make.height.equalTo(20);
            }];
            topMargin = topMargin + 20;
            topMargin = topMargin + 40;
            //底部图片
            UIImageView *imgViewBottom = [[UIImageView alloc] init];
            imgViewBottom.image = [UIImage imageNamed:@"img_bill_btm"];
            imgViewBottom.alpha = 0.8;
            [viewHeader addSubview:imgViewBottom];
            [imgViewBottom makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(viewHeader);
                make.top.equalTo(viewHeader).offset(topMargin);
                make.height.equalTo(5);
            }];
            [viewBg makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(imgViewTop.bottom);
                make.left.right.equalTo(viewHeader);
                make.bottom.equalTo(imgViewBottom.top);
            }];
            topMargin = topMargin + 5;
            [viewHeader layoutIfNeeded];
            viewHeader.ls_height = topMargin;
            wself.tableView.tableHeaderView = viewHeader;            
        }
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (BOOL)isNull:(id)object
{
    if (object == nil || object == [NSNull null]) {
        return YES;
    }
    if ([object doubleValue] == 0.0) {
        return YES;
    }
    return NO;
}

- (BOOL)isNotNull:(id)object
{
    if (object != nil && object != [NSNull null] && [object doubleValue] != 0.0) {
        return YES;
    }
    return NO;
}
- (NSString *)getPayModeString:(short)status {
    //1:会员卡;2:优惠券;3:支付宝;4:支付宝;5:现金;6:微支付;99:其他'
    NSDictionary *statusDic = @{@"1":@"会员卡", @"2":@"优惠券", @"3":@"支付宝", @"4":@"银行卡", @"5":@"现金", @"6":@"[微信]", @"99":@"其他",@"8":@"[支付宝]",@"9":@"[微信]",@"50":@"货到付款",@"51":@"手动退款"};
    NSString *statusString = [statusDic objectForKey:[NSString stringWithFormat:@"%i", status]];
    if ([NSString isNotBlank:statusString]) {
        return statusString;
    } else {
        return @"";
    }
}


#pragma - <INavigateEvent>
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - header View
- (UIView *)viewHeader {
    if (_viewHeader == nil) {
        LSPaymentOrderDetailHeaderView *headerView = [LSPaymentOrderDetailHeaderView paymentOrderDetailHeaderView];
        headerView.frame = CGRectMake(0, 0, SCREEN_W, headerView.ls_height);
        _viewHeader = headerView;
    }
    return _viewHeader;
}
#pragma mark - footer View
- (LSPaymentOrderDetailFooterView *)viewFooter {
    if (_viewFooter == nil) {
        _viewFooter = [LSPaymentOrderDetailFooterView paymentOrderDetailFooterView];
    }
    return _viewFooter;
}
#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSPaymentOrderDetailCell *cell = [LSPaymentOrderDetailCell paymentOrderDetailCellWithTable:tableView];
    InstanceVo *goodsInfo = self.datas[indexPath.row];
    cell.goodsInfo = goodsInfo;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    InstanceVo *goodsInfo = self.datas[indexPath.row];
    return goodsInfo.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

@end
