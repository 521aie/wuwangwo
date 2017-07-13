//
//  LSPaymentAccountView.m
//  retailapp
//
//  Created by guozhi on 2017/3/14.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSPaymentAccountView.h"

@interface LSPaymentAccountView ()
/** 背景View */
@property (nonatomic, strong) UIView *bgView;
/** 费用View */
@property (nonatomic, strong) UIView *viewFee;

@end
@implementation LSPaymentAccountView
+ (instancetype)paymentAccountView {
    LSPaymentAccountView *view = [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 400)];
    [view configViews];
    view.isBindCard = YES;
    return view;
}
- (void)configViews {
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    self.bgView.layer.cornerRadius = 4;
    [self addSubview:self.bgView];
    __weak typeof(self) wself = self;
    [self.bgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(wself).offset(5);
        make.right.equalTo(wself).offset(-5);
//        make.bottom.equalTo(self.viewUnBind);
    }];
    //费用面板
    [self.viewFee makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(wself.bgView);
        make.bottom.equalTo(wself.lblMonthIncomeVal.bottom).offset(20);
    }];
    //未绑定卡显示的View
    [self.viewUnBind makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.bgView);
        make.top.equalTo(self.viewFee.bottom);
         make.bottom.equalTo(wself.btnBind.bottom).offset(5);
    }];
    //绑定卡显示的View
    [self.lblBind makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(5);
        make.right.equalTo(self.bgView).offset(-5);
        make.top.equalTo(self.viewFee.bottom);
    }];
    [self layoutIfNeeded];
    self.ls_height = self.bgView.ls_bottom + 5;
}

- (void)setIsBindCard:(BOOL)isBindCard {
    _isBindCard = isBindCard;
    self.viewUnBind.hidden = isBindCard;
    self.lblBind.hidden = !isBindCard;
    self.lblRate.hidden = !isBindCard;
    [self.bgView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(isBindCard ? self.lblBind : self.viewUnBind).offset(5);
    }];
    [self layoutIfNeeded];
    self.ls_height = self.bgView.ls_bottom + 5;
   
    
    
}

- (UIView *)viewFee {
    if (_viewFee == nil) {
        _viewFee = [[UIView alloc] init];
        [self.bgView addSubview:_viewFee];
        //未到账总额
        self.lblUnReceivedTotalName = [self addLableWithSuperView:_viewFee font:[UIFont systemFontOfSize:14] text:@"电子收款未到账总额(元)" numberOfLines:1];
        [self.lblUnReceivedTotalName makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_viewFee).offset(20);
            make.centerX.equalTo(_viewFee);
        }];
        self.lblUnReceivedTotalVal = [self addLableWithSuperView:_viewFee font:[UIFont boldSystemFontOfSize:19] text:@"0.00" numberOfLines:1];
        [self.lblUnReceivedTotalVal makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lblUnReceivedTotalName.bottom).offset(5);
            make.centerX.equalTo(_viewFee);
        }];
        
        
        //日分割线
        UIView *dayLine = [[UIView alloc] init];
        dayLine.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        [_viewFee addSubview:dayLine];
        [dayLine makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_viewFee);
            make.top.equalTo(self.lblUnReceivedTotalVal.bottom).offset(5);
            make.size.equalTo(CGSizeMake(1, 40));
        }];
        //某一日收入
        self.lblDayIncomeName = [self addLableWithSuperView:_viewFee font:[UIFont systemFontOfSize:12] text:@"03月14日电子收款收入(元)" numberOfLines:1];
        [self.lblDayIncomeName makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dayLine);
            make.right.equalTo(dayLine.left).offset(-2);
            make.left.greaterThanOrEqualTo(_viewFee).offset(2);
        }];
        //某一日收入
        self.lblDayIncomeVal = [self addLableWithSuperView:_viewFee font:[UIFont systemFontOfSize:14] text:@"0.00" numberOfLines:1];
        [self.lblDayIncomeVal makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lblDayIncomeName.bottom).offset(5);
            make.left.equalTo(self.lblDayIncomeName);
        }];
        //某一日到账
        self.lblDayReceivedName = [self addLableWithSuperView:_viewFee font:[UIFont systemFontOfSize:12] text:@"03月14日已到账金额(元)" numberOfLines:1];
        [self.lblDayReceivedName makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dayLine);
            make.left.equalTo(dayLine.right).offset(2);
            make.right.lessThanOrEqualTo(_viewFee).offset(-2);
        }];
        //某一日收入
        self.lblDayReceivedVal = [self addLableWithSuperView:_viewFee font:[UIFont systemFontOfSize:14] text:@"0.00" numberOfLines:1];
        [self.lblDayReceivedVal makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lblDayReceivedName.bottom).offset(5);
            make.left.equalTo(self.lblDayReceivedName);
        }];
        //@"(已扣除服务费)"
        self.lblRate = [self addLableWithSuperView:_viewFee font:[UIFont systemFontOfSize:8] text:@"(已扣除服务费)" numberOfLines:1];
        [self.lblRate makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lblDayReceivedName);
            make.top.equalTo(self.lblDayIncomeVal.bottom);
        }];
        
        //月分割线
        UIView *monthLine = [[UIView alloc] init];
        monthLine.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        [_viewFee addSubview:monthLine];
        [monthLine makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_viewFee);
            make.top.equalTo(dayLine.bottom).offset(10);
            make.size.equalTo(CGSizeMake(1, 40));
        }];
        //某一月收入
        self.lblMonthIncomeName = [self addLableWithSuperView:_viewFee font:[UIFont systemFontOfSize:12] text:@"本月累计电子收款收入(元)" numberOfLines:1];
        [self.lblMonthIncomeName makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(monthLine);
            make.right.equalTo(monthLine.left).offset(-2);
            make.left.equalTo(self.lblDayIncomeName);
        }];
        //某一月收入
        self.lblMonthIncomeVal = [self addLableWithSuperView:_viewFee font:[UIFont systemFontOfSize:14] text:@"0.00" numberOfLines:1];
        [self.lblMonthIncomeVal makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lblMonthIncomeName.bottom).offset(5);
            make.left.equalTo(self.lblMonthIncomeName);
        }];
        //某一月到账
        self.lblMonthReceivedName = [self addLableWithSuperView:_viewFee font:[UIFont systemFontOfSize:12] text:@"本月累计已到账金额(元)" numberOfLines:1];
        [self.lblMonthReceivedName makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(monthLine);
            make.left.equalTo(monthLine.right).offset(2);
            make.right.lessThanOrEqualTo(_viewFee).offset(-2);
        }];
        //某一月收入
        self.lblMonthReceivedVal = [self addLableWithSuperView:_viewFee font:[UIFont systemFontOfSize:14] text:@"0.00" numberOfLines:1];
        [self.lblMonthReceivedVal makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lblMonthReceivedName.bottom).offset(5);
            make.left.equalTo(self.lblMonthReceivedName);
        }];
        
        
    }
    return _viewFee;
}

- (UIView *)viewUnBind {
    if (_viewUnBind == nil) {
        _viewUnBind = [[UIView alloc] init];
        [self.bgView addSubview:_viewUnBind];
        //未绑定收款账户
        UIView *view = [[UIView alloc] init];
        [_viewUnBind addSubview:view];
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"ico_warning_r"];
        [view addSubview:imgView];
        UILabel *lbl = [self addLableWithSuperView:view font:[UIFont systemFontOfSize:13] text:@"未绑定收款账户！" numberOfLines:1];
        self.lblTip = lbl;
        lbl.textColor = [ColorHelper getRedColor];
        [imgView makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(22);
            make.centerY.equalTo(view);
            make.left.equalTo(view);
        }];
        [lbl makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.right).offset(10);
            make.centerY.equalTo(view);
        }];
        [self layoutIfNeeded];
        CGFloat w = imgView.ls_width + lbl.ls_width + 10;
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_viewUnBind);
            make.top.equalTo(_viewUnBind.top);
            make.size.equalTo(CGSizeMake(w, 30));
            
        }];
        
        self.lblUnBind = [self addLableWithSuperView:_viewUnBind font:[UIFont systemFontOfSize:12] text:@"本店电子支付已自动开通，顾客可以使用微信支付和支付宝支付付款啦！顾客支付成功的钱会自动转账到您指定的账户，两种收款方式使用同一个指定的收款账户。微信和支付宝官方会收取一定服务费（“未到账总额”、“电子收款收入”皆为扣除服务费之前的金额）。请尽快绑定您的收款账户，才能收到顾客支付的钱款！" numberOfLines:0];
        [self.lblUnBind makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_viewUnBind).offset(5);
            make.right.equalTo(_viewUnBind).offset(-5);
            make.top.equalTo(view.bottom);
        }];
        //按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_full_r"] forState:UIControlStateNormal];
        [btn setTitle:@"立即绑定收款账户，开始收款" forState:UIControlStateNormal];
        self.btnBind = btn;
        [_viewUnBind addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_viewUnBind).offset(5);
            make.right.equalTo(_viewUnBind).offset(-5);
            make.top.equalTo(self.lblUnBind.bottom).offset(5);
            make.height.equalTo(40);
        }];
     
        
    }
    return _viewUnBind;
}

- (UILabel *)lblBind {
    if (_lblBind == nil) {
        _lblBind = [self addLableWithSuperView:self.bgView font:[UIFont systemFontOfSize:12] text:@"本店电子支付已自动开通，顾客可以使用微信支付和支付宝支付付款啦！顾客支付成功的钱会自动转账到您指定的账户，两种收款方式使用同一个指定的收款账户。微信和支付宝官方会收取一定服务费（“未到账总额”、“电子收款收入”皆为扣除服务费之前的金额）。请尽快绑定您的收款账户，才能收到顾客支付的钱款！" numberOfLines:0];
    }
    return _lblBind;
}

- (UILabel *)addLableWithSuperView:(UIView *)superView font:(UIFont *)font text:(NSString *)text numberOfLines:(int)numberOfLines{
    UILabel *lbl = [[UILabel alloc] init];
    lbl.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75];
    lbl.font = font;
    lbl.text = text;
    lbl.numberOfLines = numberOfLines;
    [superView addSubview:lbl];
    return lbl;
}

@end
