//
//  OrderPayListCell.m
//  RestApp
//
//  Created by 果汁 on 15/9/18.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//
#import "OrderPayListCell.h"
#import "NSString+Estimate.h"
#import "AlertImageView.h"
#import "ObjectUtil.h"

@interface OrderPayListCell ()
@property (nonatomic, strong) UILabel *payTime;
@property (nonatomic, strong) UILabel *payName;
@property (nonatomic, strong) UILabel *orIntoMyCount;
@property (nonatomic, strong) UILabel *intoCountMoney;
@property (nonatomic, strong) UILabel *innerCodeTitle;
@property ( strong, nonatomic) UILabel *mobile;
@property ( strong, nonatomic) UILabel *orderName;
@property ( strong, nonatomic) CopyFounctionLabel *orderId;
@property ( strong, nonatomic) UILabel *payMen;
/**
 *  收入类型  充值收入 消费收入
 */
@property ( strong, nonatomic) UILabel *lblCharge;
/** 下一个图片 */
@property (nonatomic, strong) UIImageView *imgViewNext;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;
@end

@implementation OrderPayListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configViews];
        [self configConstraints];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configViews {
    
    //付款人：
    self.payMen = [[UILabel alloc] init];
    self.payMen.font = [UIFont systemFontOfSize:12];
    self.payMen.textColor = [ColorHelper getWhiteColor];
    self.payMen.text = @"付款人：";
    [self.contentView addSubview:self.payMen];
    
    //付款人姓名
    self.payName = [[UILabel alloc] init];
    self.payName.font = [UIFont systemFontOfSize:18];
    self.payName.textColor = [ColorHelper getWhiteColor];
    [self.contentView addSubview:self.payName];
    
    //交易流水号
    self.innerCodeTitle = [[UILabel alloc] init];
    self.innerCodeTitle.font = [UIFont systemFontOfSize:12];
    self.innerCodeTitle.textColor = [ColorHelper getWhiteColor];
    [self.contentView addSubview:self.innerCodeTitle];
    
    self.innerCode = [[UILabel alloc] init];
    self.innerCode.font = [UIFont systemFontOfSize:12];
    self.innerCode.textColor = [ColorHelper getWhiteColor];
    self.innerCode.numberOfLines = 0;
    self.innerCode.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.innerCode];
    
    //时间
    self.payTime = [[UILabel alloc] init];
    self.payTime.font = [UIFont systemFontOfSize:12];
    self.payTime.textColor = [ColorHelper getWhiteColor];
    [self.contentView addSubview:self.payTime];
    
    //手机号/充值方式
    self.mobile = [[UILabel alloc] init];
    self.mobile.font = [UIFont systemFontOfSize:12];
    self.mobile.textColor = [ColorHelper getWhiteColor];
    [self.contentView addSubview:self.mobile];
    
    //微点/支付宝 账单号：
    self.orderName = [[UILabel alloc] init];
    self.orderName.font = [UIFont systemFontOfSize:12];
    self.orderName.textColor = [ColorHelper getWhiteColor];
    [self.contentView addSubview:self.orderName];
    
    //微点/支付宝 账单号
    self.orderId = [[CopyFounctionLabel alloc] init];
    self.orderId.font = [UIFont systemFontOfSize:12];
    self.orderId.textColor = [ColorHelper getWhiteColor];
    [self.contentView addSubview:self.orderId];
    
    //充值收入/消费收入
    self.lblCharge = [[UILabel alloc] init];
    self.lblCharge.font = [UIFont systemFontOfSize:12];
    self.lblCharge.textColor = [ColorHelper getWhiteColor];
    [self.contentView addSubview:self.lblCharge];
    
    //收入金额
    self.intoCountMoney = [[UILabel alloc] init];
    self.intoCountMoney.font = [UIFont systemFontOfSize:17];
    self.intoCountMoney.textColor = [ColorHelper getWhiteColor];
    self.intoCountMoney.textAlignment = 2;
    [self.contentView addSubview:self.intoCountMoney];
    
    //是否已到账
    self.orIntoMyCount = [[UILabel alloc] init];
    self.orIntoMyCount.font = [UIFont systemFontOfSize:12];
    self.orIntoMyCount.textColor = [ColorHelper getWhiteColor];
    [self.contentView addSubview:self.orIntoMyCount];
    
    //下一个图片
    self.imgViewNext = [[UIImageView alloc] init];
    self.imgViewNext.image = [UIImage imageNamed:@"ico_next"];
    [self.contentView addSubview:self.imgViewNext];
    
    //分割线
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.contentView addSubview:self.viewLine];
}

- (void)configConstraints {
    
    __weak typeof(self) wself = self;
    
    //付款人：
    [self.payMen makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.contentView).offset(6);
        make.left.equalTo(wself.contentView).offset(5);
        make.width.equalTo(50);
        make.height.equalTo(15);
    }];
    
    //下一个图片
    [self.imgViewNext makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.contentView).offset(39);
        make.right.equalTo(wself.contentView).offset(-10);
        make.width.height.equalTo(22);
    }];
    
    //充值收入/消费收入
    [self.lblCharge makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.contentView).offset(3);
        make.right.equalTo(wself.imgViewNext.left);
        make.width.equalTo(wself.payMen);
        make.height.equalTo(wself.payMen);
    }];
    
    //付款人姓名
    [self.payName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.contentView);
        make.left.equalTo(wself.payMen.right);
        make.right.lessThanOrEqualTo(wself.lblCharge.left);
        make.height.equalTo(22);
    }];
    
    //收入金额
    [self.intoCountMoney makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.lblCharge.bottom);
        make.right.equalTo(wself.lblCharge.right);
        make.width.equalTo(SCREEN_W-150);
        make.height.equalTo(21);
    }];
    
    //交易流水号
    [self.innerCodeTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.payMen.bottom);
        make.left.equalTo(wself.payMen.left);
        make.right.lessThanOrEqualTo(wself.intoCountMoney.left);
        make.height.equalTo(wself.payMen);
    }];
    
    [self.innerCode makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.innerCodeTitle.bottom);
        make.left.equalTo(wself.payMen.left);
        make.right.lessThanOrEqualTo(wself.orIntoMyCount.left);
        make.bottom.equalTo(wself.payTime.top);
    }];
    
    //是否已到账
    [self.orIntoMyCount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.intoCountMoney.bottom);
        make.right.equalTo(wself.lblCharge.right);
        make.width.equalTo(37);
        make.bottom.equalTo(wself.imgViewNext.bottom);
    }];
    
    //时间
    [self.payTime makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.innerCode.bottom);
        make.left.equalTo(wself.payMen.left);
        make.right.lessThanOrEqualTo(wself.orIntoMyCount.left);
        make.height.equalTo(wself.payMen);
    }];
    
    //手机号/充值方式
    [self.mobile makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.payTime.bottom);
        make.left.equalTo(wself.payMen.left);
        make.right.equalTo(wself.contentView);
        make.height.equalTo(wself.payMen);
    }];
    
    //微点/支付宝 账单号：
    [self.orderName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.mobile.bottom);
        make.left.equalTo(wself.payMen.left);
        make.right.equalTo(wself.orderId.left);
        make.height.equalTo(wself.payMen);
    }];
    
    //微点/支付宝 账单号
    [self.orderId makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.orderName);
        make.left.equalTo(wself.orderName.right);
        make.right.equalTo(wself.contentView);
        make.height.equalTo(wself.payMen);
    }];
    
    //分割线
    [self.viewLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.orderName.bottom).offset(5);
        make.left.equalTo(wself.contentView.left).offset(5);
        make.right.equalTo(wself.contentView.right).offset(-5);
        make.bottom.equalTo(wself.contentView);
        make.height.equalTo(1);
    }];
}

- (void)initWithData:(LSOnlineReceiptVo *)receiptVo payType:(NSString *)payType{
    
    self.orderId.delegate =  self;
    
    if ([ObjectUtil isNotNull:receiptVo.payName]) {
        
        self.payName.text=receiptVo.payName;
        
    } else {
        
        self.payName.text=@"无";
    }
   
    self.orderName.text = [NSString stringWithFormat:@"%@账单号：",payType];
    NSString *code = [NSString shortStringForOrderID:receiptVo.orderCode];
    
    if ([NSString isBlank:code]) {
        
        code = @"无";
    }
    self.innerCode.text =  code;
    
    NSString *mobile = [NSString stringWithFormat:@"手机号：%@",receiptVo.mobile];
    if ([receiptVo.payFor isEqualToString:@"pay_for_order"]) {
        //订单
        self.lblCharge.text = @"消费收入";
        self.innerCodeTitle.text = @"订单编号：";
        
        if ([NSString isBlank:receiptVo.mobile]) {
            
            self.mobile.text = @"手机号：无";
            
        } else {
            
            self.mobile.hidden = NO;
            self.mobile.text = mobile;
        }
        
    } else if ([receiptVo.payFor isEqualToString:@"pay_for_charge"]) {
        //充值
        self.lblCharge.text = @"充值收入";
        self.innerCodeTitle.text = @"充值流水号：";
        
        if ([receiptVo.channelType isEqual:@1]) {
            
            self.mobile.text = @"充值方式：实体充值";
            
        } else {
            
            self.mobile.text = @"充值方式：微店充值";
        }
//<<<<<<< HEAD
//        
//=======
//
//    } else if ([receiptVo.payFor isEqualToString:@"pay_for_charge"]) {//充值
//         self.lblCharge.text = @"充值收入";
//        innerCode = [NSString stringWithFormat:@"充值流水号：%@",code];
//        if ([ObjectUtil isNotNull:receiptVo.channelType]) {
//            if (receiptVo.channelType.intValue == 2) {
//                 self.mobile.text = @"充值方式：微店充值";
//            } else {
//                 self.mobile.text = @"充值方式：实体充值";
//            }
//        }
//       
//>>>>>>> feature/daily
    } else {
        
        self.lblCharge.text = @"消费收入";
        self.innerCodeTitle.text = @"订单编号：";
        
        if ([NSString isBlank:receiptVo.mobile]) {
            
            self.mobile.text = @"手机号：无";
            
        } else {
            
            self.mobile.hidden = NO;
            self.mobile.text = mobile;
        }
    }
    
    NSTimeInterval time =receiptVo.payTime/1000.0;
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    currentDateStr = [NSString stringWithFormat:@"时间：%@",currentDateStr];
    self.payTime.text =currentDateStr;
    
    self.intoCountMoney.text= [NSString stringWithFormat:@"＋¥%.2f",receiptVo.payWx];
    self.intoCountMoney.textColor = [ColorHelper getRedColor];
    
    NSString *weixinPayNo = [NSString stringWithFormat:@"%@",receiptVo.weixinPayNo];
    
    self.orderId.text = weixinPayNo;
    
    self.orIntoMyCount.text= receiptVo.statusMsg;
    if ([receiptVo.statusMsg isEqualToString:@"未到账"]) {
        
        self.orIntoMyCount.textColor=[ColorHelper getRedColor];
        
    } else {
        //已到账 已划帐
        self.orIntoMyCount.textColor = [ColorHelper getGreenColor];
    }
}

-(void)copyEventFininshed{
    
    AlertTextView * alertView = [[AlertTextView alloc]initWithContent:[NSString stringWithFormat: @"%@已经复制，可以粘贴使用", [self.orderName.text substringToIndex:self.orderName.text.length-1]] location:[UIApplication sharedApplication].keyWindow.center];
    
    [alertView setBackColor:[UIColor blackColor] alpha:0.7  textColor:[UIColor whiteColor]];
    [alertView setViewSizeFont:nil label:220];
    [alertView showAlertView];
    [alertView dismissAfterTimeInterval:4.0f alertFinish:nil];
}

@end
