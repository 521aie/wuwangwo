//
//  LSSuppilerPurchaseDetailHeaderView.m
//  retailapp
//
//  Created by wuwangwo on 2017/2/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSuppilerPurchaseDetailHeaderView.h"
#import "LSSuppilerPurchaseVo.h"

@interface LSSuppilerPurchaseDetailHeaderView ()
/** 白色背景 */
@property (nonatomic, strong) UIView *viewBg;
/** 供应商名称 */
@property (nonatomic, strong) UILabel *lblSupplierName;
/** 交易笔数 */
@property (nonatomic, strong) UILabel *lblTransactionNum;
/** 时间 */
@property (nonatomic, strong) UILabel *lblTime;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;
/** 进货图片标志 */
@property (nonatomic, strong) UIImageView *imgViewPurchase;
/** 进货信息 */
@property (nonatomic, strong) UILabel *lblPurchase;
/** 退货标志 */
@property (nonatomic, strong) UIImageView *imgViewReturn;
/** 退货信息 */
@property (nonatomic, strong) UILabel *lblReturn;
@end

@implementation LSSuppilerPurchaseDetailHeaderView
+ (instancetype)suppilerPurchaseDetailHeaderView{
    LSSuppilerPurchaseDetailHeaderView *view = [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 144)];
    [view configViews];
    [view configConstraints];
    return view;
}

- (void)configViews {
    //白色背景
    self.viewBg = [[UIView alloc] init];
    self.viewBg.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.viewBg];
    
    //供应商名称
    self.lblSupplierName = [[UILabel alloc] init];
    self.lblSupplierName.textColor = [ColorHelper getTipColor3];
    self.lblSupplierName.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.lblSupplierName];
    
    //交易笔数
    self.lblTransactionNum = [[UILabel alloc] init];
    self.lblTransactionNum.textColor = [ColorHelper getTipColor6];
    self.lblTransactionNum.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.lblTransactionNum];
    
    //时间
    self.lblTime = [[UILabel alloc] init];
    self.lblTime.textColor = [ColorHelper getTipColor6];
    self.lblTime.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.lblTime];
    
    //分割线
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self addSubview:self.viewLine];
    
    //进货图片
    self.imgViewPurchase = [[UIImageView alloc] init];
    self.imgViewPurchase.image = [UIImage imageNamed:@"status_purchase"];
    [self addSubview:self.imgViewPurchase];
    
    //进货信息
    self.lblPurchase = [[UILabel alloc] init];
    self.lblPurchase.font = [UIFont systemFontOfSize:13];
    self.lblPurchase.textColor = [ColorHelper getTipColor6];
    [self addSubview:self.lblPurchase];
    
    //退货图片
    self.imgViewReturn = [[UIImageView alloc] init];
    self.imgViewReturn.image = [UIImage imageNamed:@"status_return"];
    [self addSubview:self.imgViewReturn];
    
    //退货信息
    self.lblReturn = [[UILabel alloc] init];
    self.lblReturn.font = [UIFont systemFontOfSize:13];
    self.lblReturn.textColor = [ColorHelper getTipColor6];
    [self addSubview:self.lblReturn];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    CGFloat margin = 10;
    
    //白色背景
    [self.viewBg makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(wself);
        make.bottom.equalTo(wself.bottom).offset(-margin);
    }];
    
    //供应商名称
    [self.lblSupplierName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.left).offset(margin);
        make.top.equalTo(wself.top).offset(margin);
        make.right.equalTo(wself.right).offset(-margin);
    }];
    
    //交易笔数
    [self.lblTransactionNum makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.lblSupplierName);
        make.top.equalTo(wself.lblSupplierName.bottom).offset(margin);
    }];
    
    //时间
    [self.lblTime makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.lblSupplierName);
        make.top.equalTo(wself.lblTransactionNum.bottom).offset(margin);
    }];
    
    //分割线
    [self.viewLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.left).offset(margin);
        make.right.equalTo(wself.right).offset(-margin);
        make.height.equalTo(1);
        make.top.equalTo(wself.viewBg).offset(90);
    }];
    
    //进货图片
    [self.imgViewPurchase makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.left).equalTo(margin);
        make.bottom.equalTo(wself.bottom).offset(-21);
        make.size.equalTo(22);
    }];
    
    //进货信息
    [self.lblPurchase makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wself.imgViewPurchase.centerY);
        make.left.equalTo(wself.imgViewPurchase.right).offset(margin);
    }];
    
    //退货信息
    [self.lblReturn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wself.imgViewPurchase.centerY);
        make.right.equalTo(wself.right).offset(-margin);
    }];
    
    //退货图片
    [self.imgViewReturn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wself.imgViewPurchase.centerY);
        make.right.equalTo(wself.lblReturn.left).offset(-margin);
    }];
    [self layoutIfNeeded];
}

- (void)setObj:(LSSuppilerPurchaseVo *)obj time:(NSString *)time {
    //供应商名字
    self.lblSupplierName.text = obj.supplierName;

    //交易笔数
    self.lblTransactionNum.text = [NSString stringWithFormat:@"交易笔数：%@",obj.transactionNum];
    
    //时间
    self.lblTime.text = [NSString stringWithFormat:@"时间：%@", time];
    
    //进货量
    if ([ObjectUtil isNotNull:obj.stockNum]) {
        if ([obj.stockNum isEqualToNumber:@0]) {
            self.lblPurchase.text = @"0件 ￥0.00";
        }else{
            if ([obj.stockNum.stringValue containsString:@"."]) {
                self.lblPurchase.text = [NSString stringWithFormat:@"%.3f件 ¥%.2f", obj.stockNum.doubleValue, obj.stockAmount.doubleValue];
            } else {
                self.lblPurchase.text = [NSString stringWithFormat:@"%.f件 ¥%.2f", obj.stockNum.doubleValue, obj.stockAmount.doubleValue];
            }
        }
    }
    
    //退货量
    if ([ObjectUtil isNotNull:obj.returnNum]) {
        if ([obj.returnNum isEqualToNumber:@0]) {
            self.lblReturn.text = @"0件 ￥0.00";
        }else{
            if ([obj.returnNum.stringValue containsString:@"."]) {
                self.lblReturn.text = [NSString stringWithFormat:@"%.3f件 -¥%.2f", obj.returnNum.doubleValue, obj.returnAmount.doubleValue];
            } else {
                if (obj.returnAmount.doubleValue == 0) {
                    self.lblReturn.text = [NSString stringWithFormat:@"%.f件 ¥%.2f", obj.returnNum.doubleValue, obj.returnAmount.doubleValue];
                } else {
                    self.lblReturn.text = [NSString stringWithFormat:@"%.f件 -¥%.2f", obj.returnNum.doubleValue, obj.returnAmount.doubleValue];
                }
            }
        }
    }
}

@end
