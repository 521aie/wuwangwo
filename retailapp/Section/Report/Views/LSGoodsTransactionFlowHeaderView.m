//
//  LSGoodsTransactionFlowHeaderView.m
//  retailapp
//
//  Created by guozhi on 2016/12/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSGoodsTransactionFlowHeaderView.h"
#import "LSGoodsTransactionFlowMemberView.h"
@interface LSGoodsTransactionFlowHeaderView()
/** 会员View */
@property (nonatomic, strong) LSGoodsTransactionFlowMemberView *viewMember;
/** 会员View高度 */
@property (nonatomic, assign) CGFloat heightMember;
/** 是否显示会员View */
@property (nonatomic, assign) BOOL showMemberView;
/** 顶部图片 */
@property (nonatomic, strong) UIImageView *imgViewTop;
/** 白色背景 */
@property (nonatomic, strong) UIView *viewBg;
/** 账单 */
@property (nonatomic, strong) UILabel *lblBill;
/** 单号 */
@property (nonatomic, strong) UILabel *lblOrderNumber;
/** 订单时间 */
@property (nonatomic, strong) UILabel *lblOrderTime;
/** 灰色背景 */
@property (nonatomic, strong) UIView *viewGray;
/** 商品名称 */
@property (nonatomic, strong) UILabel *lblGoodsName;
/** 商品数量 */
@property (nonatomic, strong) UILabel *lblGoodsNum;
/** 商品金额 */
@property (nonatomic, strong) UILabel *lblGoodsAmmount;
/** 数量左边分割线 */
@property (nonatomic, strong) UIView *viewLeftLine;
/** 数量右边分割线 */
@property (nonatomic, strong) UIView *viewRightLine;
@end
@implementation LSGoodsTransactionFlowHeaderView
+ (instancetype)goodsTransactionFlowHeaderView {
    LSGoodsTransactionFlowHeaderView *view = [[LSGoodsTransactionFlowHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 100)];
    [view configViews];
    [view configConstraints];
    return view;
}

- (void)configViews {
    self.backgroundColor = [UIColor clearColor];
    //会员View
    self.viewMember = [LSGoodsTransactionFlowMemberView goodsTransactionFlowMemberView];
    [self addSubview:self.viewMember];
    self.heightMember = self.viewMember.ls_height;
    //顶部图片
    self.imgViewTop = [[UIImageView alloc] init];
    self.imgViewTop.image = [UIImage imageNamed:@"img_bill_top"];
    self.imgViewTop.alpha = 0.8;
    [self addSubview:self.imgViewTop];
    //中间白色背景
    self.viewBg = [[UIView alloc] init];
    self.viewBg.backgroundColor = [UIColor whiteColor];
    self.viewBg.alpha = 0.8;
    [self addSubview:self.viewBg];
    //账单
    self.lblBill = [[UILabel alloc] init];
    self.lblBill.font = [UIFont boldSystemFontOfSize:18];
    self.lblBill.textColor = [ColorHelper getTipColor3];
    self.lblBill.textAlignment = NSTextAlignmentCenter;
    self.lblBill.text = @"账单";
    [self addSubview:self.lblBill];
    //单号
    self.lblOrderNumber = [[UILabel alloc] init];
    self.lblOrderNumber.font = [UIFont boldSystemFontOfSize:12];
    self.lblOrderNumber.textColor = [ColorHelper getTipColor3];
    [self addSubview:self.lblOrderNumber];
    //订单时间
    self.lblOrderTime = [[UILabel alloc] init];
    self.lblOrderTime.font = [UIFont boldSystemFontOfSize:12];
    self.lblOrderTime.textColor = [ColorHelper getBlueColor];
    [self addSubview:self.lblOrderTime];
    //灰色背景
    self.viewGray = [[UIView alloc] init];
    self.viewGray.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.viewGray];
    self.viewGray.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    self.viewGray.layer.borderWidth = 1;
    self.viewGray.layer.masksToBounds = YES;
    //商品名称
    self.lblGoodsName = [[UILabel alloc] init];
    self.lblGoodsName.font = [UIFont boldSystemFontOfSize:13];
    self.lblGoodsName.textColor = [ColorHelper getTipColor3];
    [self.viewGray addSubview:self.lblGoodsName];
    self.lblGoodsName.text = @"商品名称";
    //商品数量
    self.lblGoodsNum = [[UILabel alloc] init];
    self.lblGoodsNum.font = [UIFont boldSystemFontOfSize:13];
    self.lblGoodsNum.textColor = [ColorHelper getTipColor3];
    self.lblGoodsNum.textAlignment = NSTextAlignmentCenter;
    [self.viewGray addSubview:self.lblGoodsNum];
    self.lblGoodsNum.text = @"数量";
    //商品金额
    self.lblGoodsAmmount = [[UILabel alloc] init];
    self.lblGoodsAmmount.font = [UIFont boldSystemFontOfSize:13];
    self.lblGoodsAmmount.textColor = [ColorHelper getTipColor3];
    [self.viewGray addSubview:self.lblGoodsAmmount];
    self.lblGoodsAmmount.textAlignment = NSTextAlignmentCenter;
    self.lblGoodsAmmount.text = @"金额(元)";
    //商品数量左边分割线
    self.viewLeftLine = [[UIView alloc] init];
    self.viewLeftLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.viewGray addSubview:self.viewLeftLine];
    //商品数量右边分割线
    self.viewRightLine = [[UIView alloc] init];
    self.viewRightLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.viewGray addSubview:self.viewRightLine];
    
    
    

}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    //会员View
    [self.viewMember makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(wself);
        make.height.equalTo(wself.viewMember.ls_height);
    }];
    //顶部图片
    [self.imgViewTop makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself);
        make.top.equalTo(wself.viewMember.bottom).offset(5);
        make.height.equalTo(5);
    }];
    //中间白色背景
    [self.viewBg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.imgViewTop.bottom);
        make.left.right.equalTo(wself);
        make.bottom.equalTo(wself.viewGray.bottom);
    }];
    //账单
    [self.lblBill makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.imgViewTop.bottom).offset(5);
        make.left.right.equalTo(wself);
    }];
    //单号
    [self.lblOrderNumber makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.left).offset(10);
        make.top.equalTo(wself.lblBill.bottom).offset(10);
    }];
    //订单时间
    [self.lblOrderTime makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wself.lblOrderNumber);
        make.right.equalTo(wself.right).offset(-10);
    }];
    //灰色背景
    [self.viewGray makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.lblOrderNumber.bottom).offset(5);
        make.left.equalTo(wself.lblOrderNumber);
        make.right.equalTo(wself.lblOrderTime);
        make.height.equalTo(30);
    }];
    
    //商品名称
    [self.lblGoodsName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.viewGray.left).offset(5);
        make.top.bottom.equalTo(wself.viewGray);
        make.right.equalTo(wself.viewLeftLine.left).offset(-5);
    }];
    //商品数量
    [self.lblGoodsNum makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.viewRightLine.left);
        make.top.bottom.equalTo(wself.viewGray);
        make.width.equalTo(40);
    }];
    //商品金额
    [self.lblGoodsAmmount makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(wself.viewGray);
        make.width.equalTo(100);
    }];
    //商品数量左边分割线
    [self.viewLeftLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(wself.viewGray);
        make.right.equalTo(wself.lblGoodsNum.left);
        make.width.equalTo(1);
    }];
    //商品数量右边分割线
    [self.viewRightLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(wself.viewGray);
        make.right.equalTo(wself.lblGoodsAmmount.left);
        make.width.equalTo(1);
    }];

    //强制布局
    [self layoutIfNeeded];
    self.ls_height = self.viewBg.ls_bottom;
}


/**
 设置交易流水

 @param orderReportVo
 */
- (void)setOrderReportVo:(LSOrderReportVo *)orderReportVo {
    _orderReportVo = orderReportVo;
    //默认是显示会员
    if (orderReportVo.isMember) {//是会员
        //设置会员信息
        self.viewMember.orderReportVo = orderReportVo;
    } else {
        __weak typeof(self) wself = self;
        [self.viewMember updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(0);
        }];
        //顶部图片
        [self.imgViewTop updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wself.viewMember.bottom);
        }];
        self.viewMember.hidden = YES;
    }
    
    //单号
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"单号："];
    NSString *code = [NSString shortStringForOrderID:orderReportVo.waternumber];
    [attr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:code attributes:@{NSForegroundColorAttributeName : [ColorHelper getBlueColor]}]];
    self.lblOrderNumber.attributedText = attr;
    //订单时间
    self.lblOrderTime.text = orderReportVo.salesTime;
    //强制布局
    [self layoutIfNeeded];
    self.ls_height = self.viewBg.ls_bottom;
}


@end
