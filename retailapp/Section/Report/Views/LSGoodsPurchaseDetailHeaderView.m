//
//  LSGoodsPurchaseDetailHeaderView.m
//  retailapp
//
//  Created by guozhi on 2017/1/14.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSGoodsPurchaseDetailHeaderView.h"
#import "LSGoodsPurchaseVo.h"

@interface LSGoodsPurchaseDetailHeaderView()
/** 白色背景 */
@property (nonatomic, strong) UIView *viewBg;
/** 商品图片 */
@property (nonatomic, strong) UIImageView *imgViewGoods;
/** 商品名称 */
@property (nonatomic, strong) UILabel *lblGoodsName;
/** 条形码 */
@property (nonatomic, strong) UILabel *lblCode;
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

@implementation LSGoodsPurchaseDetailHeaderView
+ (instancetype)goodsPurchaseDetailHeaderView {
    LSGoodsPurchaseDetailHeaderView *view = [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 144)];
    [view configViews];
    [view configConstraints];
    return view;
}

- (void)configViews {
    //白色背景
    self.viewBg = [[UIView alloc] init];
    self.viewBg.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.viewBg];
    
    //商品图片
    self.imgViewGoods = [[UIImageView alloc] init];
    self.imgViewGoods.layer.cornerRadius = 4;
    self.imgViewGoods.layer.masksToBounds = YES;
    [self addSubview:self.imgViewGoods];
    
    //商品名称
    self.lblGoodsName = [[UILabel alloc] init];
    self.lblGoodsName.textColor = [ColorHelper getTipColor3];
    self.lblGoodsName.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.lblGoodsName];
    
    //条形码
    self.lblCode = [[UILabel alloc] init];
    self.lblCode.textColor = [ColorHelper getTipColor6];
    self.lblCode.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.lblCode];
    
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
    
    //商品图片
    [self.imgViewGoods makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.left).offset(margin);
        make.top.equalTo(wself.top).offset(margin);
        make.size.equalTo(72);
    }];
    
    //商品名称
    [self.lblGoodsName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.imgViewGoods.right).offset(margin);
        make.right.equalTo(wself.right).offset(-margin);
        make.top.equalTo(wself.imgViewGoods.top);
    }];
    
    //条形码
    [self.lblCode makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblGoodsName.left);
        make.centerY.equalTo(wself.imgViewGoods.centerY);
    }];
    
    //时间
    [self.lblTime makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblGoodsName.left);
        make.bottom.equalTo(wself.imgViewGoods.bottom);
    }];
    
    //分割线
    [self.viewLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.left).offset(margin);
        make.right.equalTo(wself.right).offset(-margin);
        make.height.equalTo(1);
        make.top.equalTo(wself.imgViewGoods.bottom).offset(margin);
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

- (void)setObj:(LSGoodsPurchaseVo *)obj time:(NSString *)time imgUrl:(NSString *)imgUrl {
    //设置图片
    [self.imgViewGoods sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"img_default"]];
    
    //商品名字
    NSString *goodsName = [[[Platform Instance] getkey:SHOP_MODE] intValue] == 101 ? obj.styleName : obj.goodsName;
    self.lblGoodsName.text = goodsName;
    
    //条形码店内码
    //服鞋显示为：款号:***
    NSString *styleC = [NSString stringWithFormat:@"款号: %@",obj.styleCode];
    NSString *code = [[[Platform Instance] getkey:SHOP_MODE] intValue] == 101 ? styleC : obj.barCode;
    self.lblCode.text = code;
    
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
    
    //时间
    self.lblTime.text = [NSString stringWithFormat:@"时间：%@", time];
}

@end
