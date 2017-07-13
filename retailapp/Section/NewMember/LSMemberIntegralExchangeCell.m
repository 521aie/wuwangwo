//
//  LSMemberIntegralExchangeCell.m
//  retailapp
//
//  Created by taihangju on 16/10/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberIntegralExchangeCell.h"
#import "Masonry.h"
#import "LSMemberGoodsGiftVo.h"
#import "KeyBoardUtil.h"
#import <QuartzCore/QuartzCore.h>

@interface LSMemberIntegralExchangeCell()<UITextFieldDelegate>

@property (nonatomic ,strong) UITextField *numTextField;/*<显示数目的label>*/
@property (nonatomic ,strong) UIButton *addButton;/*<添加>*/
@property (nonatomic ,strong) LSMemberGoodsGiftVo *giftGoodVo;/*<>*/
@end

@implementation LSMemberIntegralExchangeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configSubViews];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configSubViews {
    
    self.goodName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.goodName.textColor = [ColorHelper getBlackColor];
    self.goodName.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.goodName];
    
    self.goodAttribute = [[UILabel alloc] initWithFrame:CGRectZero];
    self.goodAttribute.textColor = [ColorHelper getTipColor6];
    self.goodAttribute.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:self.goodAttribute];
    
    self.needIntegral = [[UILabel alloc] initWithFrame:CGRectZero];
    self.needIntegral.textColor = [ColorHelper getTipColor9];
    self.needIntegral.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:self.needIntegral];
    
    self.remainNum = [[UILabel alloc] initWithFrame:CGRectZero];
    self.remainNum.textColor = [ColorHelper getTipColor9];
    self.remainNum.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:self.remainNum];
    
    self.addButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.addButton setImage:[UIImage imageNamed:@"btn_add"] forState:0];
    [self.addButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.addButton];
    
    self.numTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.numTextField.textColor = [ColorHelper getBlueColor];
    self.numTextField.textAlignment = NSTextAlignmentCenter;
    self.numTextField.font = [UIFont systemFontOfSize:13.0];
    self.numTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.numTextField.delegate = self;
     [KeyBoardUtil initWithTarget:self.numTextField];
    [self.contentView addSubview:self.numTextField];
    [self.numTextField addTarget:self action:@selector(numChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.subtractButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.subtractButton setImage:[UIImage imageNamed:@"btn_del"] forState:0];
    [self.subtractButton addTarget:self action:@selector(subtractAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.subtractButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:line];
    
    
    __weak typeof(self) wself = self;
    [wself.goodName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.mas_left).offset(8.0);
        make.top.equalTo(wself.contentView.mas_top).offset(10.0);
        make.right.equalTo(wself.contentView.mas_right).offset(-140.0);
        make.height.equalTo(@20.0);
    }];
    
    [wself.goodAttribute mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.goodName.mas_bottom);
        make.left.equalTo(wself.contentView.mas_left).offset(8.0);
        make.right.equalTo(wself.contentView.mas_right).offset(-140.0);
        make.height.equalTo(@20.0);
    }];
    
    [wself.needIntegral mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.mas_left).offset(8.0);
        make.right.equalTo(wself.contentView.mas_right).offset(-200.0);
        make.bottom.equalTo(wself.contentView.mas_bottom).offset(-10);
        make.height.equalTo(@20.0);
    }];
    
    [wself.remainNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.needIntegral.mas_right);
        make.top.equalTo(wself.needIntegral.mas_top);
        make.height.equalTo(wself.needIntegral.mas_height);
    }];
    
    [wself.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.contentView.mas_right).offset(-8.0);
        make.centerY.equalTo(wself.contentView.mas_centerY);
        make.width.and.height.equalTo(@28.0);
    }];
    
    [wself.numTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.addButton.mas_left).offset(-2.0);
        make.centerY.equalTo(wself.contentView.mas_centerY);
        make.width.equalTo(@55.0);
        make.height.equalTo(@28.0);
    }];
    
    [wself.subtractButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.numTextField.mas_left).offset(-2.0);
        make.centerY.equalTo(wself.contentView.mas_centerY);
        make.width.and.height.equalTo(@28.0);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@(1/[UIScreen mainScreen].scale));
    }];
}

- (void)fillData:(LSMemberGoodsGiftVo *)obj {
    
    self.giftGoodVo = obj;
    if (obj.type.integerValue == 1) {
        // 积分兑卡内金额
        self.goodName.text = obj.name;
        self.needIntegral.text = [NSString stringWithFormat:@"%@积分" ,obj.point];
        self.goodAttribute.hidden = YES;
    }
    else  {
        // 积分兑换商品 (服鞋和商超商品区分，服鞋使用innerCode，商超使用barCode)
        self.goodName.text = obj.name;
        if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {
            self.goodAttribute.text = [NSString stringWithFormat:@"%@ %@ %@" ,obj.innerCode,obj.goodsColor,obj.goodsSize];
        }
        else if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 102) {
            self.goodAttribute.text = obj.barCode;
        }
        self.goodAttribute.hidden = NO;
        self.needIntegral.text = [NSString stringWithFormat:@"%@积分" ,obj.point];
        if (obj.limitedGiftStore.boolValue) {
            self.remainNum.text = [NSString stringWithFormat:@"剩余数量: %@",obj.giftStore.stringValue?:@"0"];
        } else {
            self.remainNum.text = @"剩余数量: 不限";
        }
        // 机构用户和总部用户不显示剩余数量
        self.remainNum.hidden = [[Platform Instance] getShopMode] == 3;
    }
    
    if (self.giftGoodVo.number.integerValue == 0) {
        self.subtractButton.hidden = YES;
        self.numTextField.hidden = YES;
    }
    else {
        self.subtractButton.hidden = NO;
        self.numTextField.hidden = NO;
    }
    self.numTextField.text = [NSString stringWithFormat:@"%@" ,self.giftGoodVo.number?:@""];
}

// 加操作
- (void)addAction:(UIButton *)sender {
    
    // 限制最大输入
    if (_numTextField.text.integerValue < 999999) {
        
       // 机构用户登录时，不显示剩余数量，做无效数量处理，所以不需要check
        if ([[Platform Instance] getShopMode] != 3) {
            //剩余数量不是不限类型的要判断当前兑换数量是否大于剩余数量
            if (_giftGoodVo.limitedGiftStore.boolValue && _giftGoodVo.giftStore.integerValue < _giftGoodVo.number.integerValue + 1) {
                [LSAlertHelper showAlert:@"兑换数量大于实体门店可兑换数量! "]; return;
            }
        }

        
        if (self.giftGoodVo.number.integerValue== 0) {
            self.subtractButton.hidden = NO;
            self.numTextField.hidden = NO;
        }
        
        self.giftGoodVo.number = @(self.giftGoodVo.number.integerValue + 1);
        self.numTextField.text = [NSString stringWithFormat:@"%@" ,self.giftGoodVo.number];
        if ([self.delegate respondsToSelector:@selector(countChange:cell:)]) {
            [self.delegate countChange:self.giftGoodVo cell:self];
        }

    }
}

// 减操作
- (void)subtractAction:(UIButton *)sender {
    
    if (self.giftGoodVo.number.integerValue - 1 <= 0) {
        [self.numTextField resignFirstResponder];
        self.giftGoodVo.number = @(0);
        self.subtractButton.hidden = YES;
        self.numTextField.hidden = YES;
    }
    else {
        self.giftGoodVo.number  = @(self.giftGoodVo.number.integerValue - 1);
    }
    self.numTextField.text = [NSString stringWithFormat:@"%@" ,self.giftGoodVo.number];
    if ([self.delegate respondsToSelector:@selector(countChange:cell:)]) {
        [self.delegate countChange:self.giftGoodVo cell:self];
    }
}

// 显示输入位数不超过6位
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (range.location >= 6) {
        return NO;
    }
    
    return YES;
}

- (void)numChanged:(UITextField *)textField {
    
    // 机构用户登录时，不显示剩余数量，做无效数量处理，所以不需要check
    if ([[Platform Instance] getShopMode] != 3) {
        
        // 剩余数量不是不限类型的要判断当前兑换数量是否大于剩余数量
        if (_giftGoodVo.limitedGiftStore.boolValue &&
            _giftGoodVo.giftStore.integerValue < textField.text.integerValue) {
            
            __weak typeof(self) wself = self;
            [LSAlertHelper showAlert:@"兑换数量大于实体门店可兑换数量! " block:^{
                wself.numTextField.text = wself.giftGoodVo.number.stringValue;
                if (wself.giftGoodVo.number.integerValue <= 0) {
                    [wself subtractAction:nil];
                } else {
                    [wself.numTextField resignFirstResponder];
                }
            }];
            return;
        }
    }

    
    if (([NSString isBlank:textField.text] || textField.text.integerValue == 0) && ![textField isFirstResponder]) {
        self.giftGoodVo.number = @(0);
        self.subtractButton.hidden = YES;
        self.numTextField.hidden = YES;
    }else {
        self.giftGoodVo.number = [textField.text convertToNumber];
    }
    if ([self.delegate respondsToSelector:@selector(countChange:cell:)]) {
        [self.delegate countChange:self.giftGoodVo cell:self];
    }
}


#pragma mark - 
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.integerValue <= 0) {
        [self subtractAction:nil];
    }
}

@end
