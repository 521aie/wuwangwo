//
//  LSSuppilerPurchaseRecordHeaderView.m
//  retailapp
//
//  Created by wuwangwo on 2017/2/5.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSuppilerPurchaseRecordHeaderView.h"
#import "LSSuppilerPurchaseVo.h"
#import "DateUtils.h"

@interface LSSuppilerPurchaseRecordHeaderView ()
/** 供应商 */
@property (nonatomic, strong) UILabel *lblSuppiler;
/** 单号 */
@property (nonatomic, strong) UILabel *lblNo;
/** 时间 */
@property (nonatomic, strong) UILabel *lblTime;
@end

@implementation LSSuppilerPurchaseRecordHeaderView
+ (instancetype)suppilerPurchaseRecordHeaderView : (LSSuppilerPurchaseVo *)obj{
    LSSuppilerPurchaseRecordHeaderView *view = [[LSSuppilerPurchaseRecordHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 119)];
    [view configViews : obj];
    return view;
}

- (void)configViews : (LSSuppilerPurchaseVo*)obj {
    __weak typeof(self) wself = self;
    
    //收货单/退货单
    UILabel *lbl = [[UILabel alloc] init];
    if ([ObjectUtil isNotNull:obj.invoiceFlag]) {
        if (obj.invoiceFlag.intValue == 1) {
            lbl.text = @"收货单";
        }else{
            lbl.text = @"退货单";
        }
    }
    lbl.font = [UIFont systemFontOfSize:18];
    lbl.textColor = [ColorHelper getTipColor3];
    [self addSubview:lbl];
    [lbl makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.top).offset(15);
        make.centerX.equalTo(wself);
    }];
    
    //供应商
    self.lblSuppiler = [[UILabel alloc] init];
    self.lblSuppiler.font = [UIFont systemFontOfSize:13];
    self.lblSuppiler.textAlignment = 1;
    self.lblSuppiler.textColor = [ColorHelper getTipColor6];
    if (obj.supplierName.length <= 23) {
        self.lblSuppiler.text = [NSString stringWithFormat:@"(%@)",obj.supplierName];
    }else{
        NSString *str1 = [obj.supplierName substringToIndex:21];
        self.lblSuppiler.text = [NSString stringWithFormat:@"(%@...)",str1];
    }
    [self addSubview:self.lblSuppiler];
    [self.lblSuppiler makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbl.bottom).offset(5);
        make.centerX.equalTo(wself);
    }];
    
    //单号
    self.lblNo = [[UILabel alloc] init];
    self.lblNo.font = [UIFont systemFontOfSize:13];
    self.lblNo.textColor = [ColorHelper getTipColor6];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"单号："];
    NSString *string = obj.invoiceCode;
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName : [ColorHelper getBlueColor]}]];
    self.lblNo.attributedText = attr;
    [self addSubview:self.lblNo];
    [self.lblNo makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.left).offset(10);
        make.top.equalTo(wself.lblSuppiler.bottom).offset(15);
    }];
    
    //时间
    self.lblTime = [[UILabel alloc] init];
    self.lblTime.font = [UIFont systemFontOfSize:13];
    self.lblTime.text =  [NSString stringWithFormat:@"%@",[DateUtils formateTime:[obj.sendEndTime longLongValue]]];
    self.lblTime.textColor = [ColorHelper getBlueColor];
    [self addSubview:self.lblTime];
    [self.lblTime makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.right).offset(-10);
        make.centerY.equalTo(wself.lblNo);
    }];
    
    //灰色背景
    UIView *viewGray = [[UIView alloc] init];
    viewGray.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self addSubview:viewGray];
    [viewGray makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.left).offset(10);
        make.right.equalTo(wself.right).offset(-10);
        make.top.equalTo(wself.lblNo.bottom).offset(5);
        make.height.equalTo(30);
    }];
    
    //上方分割线
    UIView *viewTopLine = [[UIView alloc] init];
    viewTopLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self addSubview:viewTopLine];
    [viewTopLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(viewGray);
        make.height.equalTo(1);
    }];
    
    //下方分割线
    UIView *viewBottomLine = [[UIView alloc] init];
    viewBottomLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [wself addSubview:viewBottomLine];
    [viewBottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(viewGray);
        make.height.equalTo(1);
    }];
    
    //左边分割线
    UIView *viewLeftLine = [[UIView alloc] init];
    viewLeftLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self addSubview:viewLeftLine];
    [viewLeftLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(viewGray);
        make.width.equalTo(1);
    }];
    
    //右边分割线
    UIView *viewRightLine = [[UIView alloc] init];
    viewRightLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self addSubview:viewRightLine];
    [viewRightLine makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(viewGray);
        make.width.equalTo(1);
    }];
    
    //右边中心分割线
    UIView *viewRightCenterLine = [[UIView alloc] init];
    viewRightCenterLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self addSubview:viewRightCenterLine];
    [viewRightCenterLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(viewGray);
        make.right.equalTo(viewGray.right).offset(-80);
        make.width.equalTo(1);
    }];
    
    //左边边中心分割线
    UIView *viewLeftCenterLine = [[UIView alloc] init];
    viewLeftCenterLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self addSubview:viewLeftCenterLine];
    [viewLeftCenterLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(viewGray);
        make.right.equalTo(viewRightCenterLine.right).offset(-60);
        make.width.equalTo(1);
    }];
    
    //商品名称
    UILabel *lblGoodsName = [[UILabel alloc] init];
    lblGoodsName.font = [UIFont systemFontOfSize:12];
    lblGoodsName.textColor = [ColorHelper getTipColor3];
    lblGoodsName.text = @"商品名称";
    [self addSubview:lblGoodsName];
    [lblGoodsName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewLeftLine.left).offset(10);
        make.top.equalTo(viewTopLine);
        make.bottom.equalTo(viewBottomLine);
    }];
    
    //数量
    UILabel *lblGoodsNum = [[UILabel alloc] init];
    lblGoodsNum.font = [UIFont systemFontOfSize:12];
    lblGoodsNum.textColor = [ColorHelper getTipColor3];
    lblGoodsNum.textAlignment = NSTextAlignmentCenter;
    lblGoodsNum.text = @"数量";
    [self addSubview:lblGoodsNum];
    [lblGoodsNum makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewLeftCenterLine.right);
        make.top.equalTo(viewTopLine.bottom);
        make.bottom.equalTo(viewBottomLine.top);
        make.right.equalTo(viewRightCenterLine.left);
    }];
    
    //进货价
    UILabel *lblGoodsPrice = [[UILabel alloc] init];
    lblGoodsPrice.font = [UIFont systemFontOfSize:12];
    lblGoodsPrice.textColor = [ColorHelper getTipColor3];
    lblGoodsPrice.textAlignment = NSTextAlignmentCenter;
    if ([ObjectUtil isNotNull:obj.invoiceFlag]) {
        if (obj.invoiceFlag.intValue == 1) {
            lblGoodsPrice.text = @"进货价(元)";
        }else{
            lblGoodsPrice.text = @"退货价(元)";
        }
    }
    [self addSubview:lblGoodsPrice];
    [lblGoodsPrice makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewRightCenterLine.right);
        make.top.equalTo(viewTopLine.bottom);
        make.bottom.equalTo(viewBottomLine.top);
        make.right.equalTo(viewRightLine.left);
    }];
}

@end
