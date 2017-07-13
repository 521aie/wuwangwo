//
//  LSMemberCardBalanceCell.m
//  retailapp
//
//  Created by taihangju on 16/10/8.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberCardBalanceCell.h"
#import "Masonry.h"
#import "UIImageView+SDAdd.h"
#import "LSMemberGoodsGiftVo.h"

@interface LSMemberCardBalanceCell()

@property (nonatomic, assign) BOOL showSelectButton;/**<显示选择button>*/
@end

@implementation LSMemberCardBalanceCell

+ (instancetype)mb_balanceCellWith:(UITableView *)tableView optional:(BOOL)optional {
    
    NSString *identifier = @"LSMemberCardBalanceCell";
    LSMemberCardBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LSMemberCardBalanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configSubViews];
        [cell addConstraint];
    }
    if (optional != cell.showSelectButton) {
        cell.showSelectButton = optional;
        [cell setNeedsUpdateConstraints];
    }
    return cell;
}

- (void)updateConstraints {
    
    __weak typeof(self) wself = self;
    CGFloat offset1 = self.showSelectButton ? 38.0 : 8.0;
    CGFloat offset2 = self.showSelectButton ? -8 : -20;
    [UIView animateWithDuration:0.25 animations:^{
        
        [wself.imgV remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wself.contentView.mas_left).offset(offset1);
            make.width.and.height.equalTo(@68);
            make.top.equalTo(wself.contentView.mas_top).offset(10);
            make.bottom.equalTo(wself.contentView.mas_bottom).offset(-10);
        }];
        
        [wself.integral mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wself.contentView.mas_right).offset(offset2);
            make.centerY.equalTo(wself.contentView.mas_centerY);
            make.height.equalTo(@20.0);
        }];
        
    } completion:^(BOOL finished) {
        self.selectButton.hidden = !self.showSelectButton;
        self.arrow.hidden = self.showSelectButton;
    }];
    [super updateConstraints];
}


- (void)configSubViews {
    
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectButton setImage:[UIImage imageNamed:@"ico_uncheck"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"ico_check"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.selectButton];
    self.selectButton.userInteractionEnabled = NO;
    self.selectButton.hidden = YES;
    
    self.imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_balnce_bg"]];
    [self.contentView addSubview:self.imgV];
    
    self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    self.moneyLabel.textColor = [ColorHelper getTipColor3];
    [self.contentView addSubview:self.moneyLabel];
    
    self.typeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    self.typeLabel.textColor = [ColorHelper getTipColor6];
    self.typeLabel.font = [UIFont systemFontOfSize:10.0];
    self.typeLabel.text = @"卡余额";
    [self.contentView addSubview:self.typeLabel];
    
    self.balance = [[UILabel alloc] initWithFrame:CGRectZero];
    self.balance.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:self.balance];
    
    self.integral = [[UILabel alloc] initWithFrame:CGRectZero];
    self.integral.font = [UIFont systemFontOfSize:13.0];
    self.integral.textColor = [ColorHelper getRedColor];
    [self.contentView addSubview:self.integral];
    
    UIImageView *arrowhead = [[UIImageView alloc] initWithFrame:CGRectZero];
    arrowhead.image = [UIImage imageNamed:@"ico_next"];
    [self.contentView addSubview:arrowhead];
    self.arrow = arrowhead;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:line];
    self.bottomLine = line;
}

- (void)addConstraint {
    
    __weak typeof(self) wself = self;
    
    [wself.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.mas_left).offset(10);
        make.centerY.equalTo(wself.contentView.mas_centerY);
        make.width.and.height.equalTo(@22);
    }];
    
    [wself.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.mas_left).offset(8.0);
        make.width.and.height.equalTo(@68);
        make.top.equalTo(wself.contentView.mas_top).offset(10);
        make.bottom.equalTo(wself.contentView.mas_bottom).offset(-10);
    }];
    
    // 图片上显示 *元
    [wself.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wself.imgV.mas_centerX);
        make.centerY.equalTo(wself.imgV.mas_centerY).offset(-4);
        make.height.equalTo(@25);
    }];
    
    // 卡余额
    [wself.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wself.imgV.mas_centerX);
        make.centerY.equalTo(wself.imgV.mas_centerY).offset(10);
        make.height.equalTo(@15.0);
    }];
    
    [wself.balance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.imgV.mas_right).offset(8.0);
        make.centerY.equalTo(wself.imgV.mas_centerY);
        make.height.equalTo(@20.0);
    }];
    
    [wself.integral mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.moneyLabel.mas_right).offset(-20.0);
        make.centerY.equalTo(wself.contentView.mas_centerY);
        make.height.equalTo(@20.0);
    }];
    
    [wself.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(@22.0);
        make.centerY.equalTo(wself.contentView.mas_centerY);
        make.right.equalTo(wself.contentView.mas_right);
    }];
    
    CGFloat onePixel = 1/[UIScreen mainScreen].scale;
    [wself.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.mas_left);
        make.right.equalTo(wself.contentView.mas_right);
        make.height.equalTo(@(onePixel));
        make.bottom.equalTo(wself.contentView.mas_bottom);
    }];

}

- (void)setData:(id)selectObj {
    
    LSMemberGoodsGiftVo *vo = (LSMemberGoodsGiftVo *)selectObj;
    self.selectButton.selected = vo.selected;
    NSString *money = [NSString stringWithFormat:@"%@元",vo.cardFee?:@" "];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:money];
    [attri setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[ColorHelper getTipColor3]} range:NSMakeRange(0, money.length-1)];
    [attri setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[ColorHelper getTipColor6]} range:NSMakeRange(money.length-1, 1)];
    self.moneyLabel.attributedText = attri;
    self.balance.text = vo.name;
    self.integral.text = [NSString stringWithFormat:@"%@积分",vo.point];
}

@end
