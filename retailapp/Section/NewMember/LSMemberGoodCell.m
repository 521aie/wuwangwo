//
//  LSMemberGoodCell.m
//  retailapp
//
//  Created by taihangju on 16/10/12.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberGoodCell.h"
#import "Masonry.h"
#import "UIImageView+SDAdd.h"
#import "LSMemberGoodsGiftVo.h"
#import "GoodsGiftListVo.h"

@interface LSMemberGoodCell ()

@property (nonatomic, assign) BOOL showSelectButton;/**<是否显示selectButton>*/
@end

@implementation LSMemberGoodCell

+ (instancetype)mb_goodCellWith:(UITableView *)tableView optional:(BOOL)optional {
    
    NSString *identifier = @"LSMemberGoodCell";
    LSMemberGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LSMemberGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configSubviews];
        [cell addConstraints];
    }
    if (optional != cell.showSelectButton) {
        cell.showSelectButton = optional;
        [cell setNeedsUpdateConstraints];
    }
    return cell;
}

- (void)configSubviews {
    
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectButton setImage:[UIImage imageNamed:@"ico_uncheck"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"ico_check"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.selectButton];
    self.selectButton.userInteractionEnabled = NO;
    self.selectButton.hidden = YES;
    
    self.imgV = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imgV.image = [UIImage imageNamed:@"img_default"];
    [self.imgV ls_addCornerWithRadii:4 roundRect:CGRectMake(0, 0, 68, 68)];
    [self.contentView addSubview:self.imgV];
    
    self.typeImage = [[UIImageView alloc] init];
    [self.contentView addSubview:self.typeImage];
    
    self.name = [[UILabel alloc] initWithFrame:CGRectZero];
    self.name.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.name];
    self.name.numberOfLines = 0;
    
    self.code = [[UILabel alloc] initWithFrame:CGRectZero];
    self.code.font = [UIFont systemFontOfSize:13.0];
    self.code.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.code];
    
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {
        self.style = [[UILabel alloc] initWithFrame:CGRectZero];
        self.style.font = [UIFont systemFontOfSize:13.0];
        self.style.textColor = [ColorHelper getTipColor6];
        [self.contentView addSubview:self.style];
    }

    self.integral = [[UILabel alloc] initWithFrame:CGRectZero];
    self.integral.font = [UIFont systemFontOfSize:13.0];
    self.integral.textColor = [ColorHelper getRedColor];
    [self.contentView addSubview:self.integral];
    
    self.shopNum = [[UILabel alloc] initWithFrame:CGRectZero];
    self.shopNum.font = [UIFont systemFontOfSize:13.0];
    self.shopNum.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.shopNum];
    
    self.wechatNum = [[UILabel alloc] initWithFrame:CGRectZero];
    self.wechatNum.font = [UIFont systemFontOfSize:13.0];
    self.wechatNum.textColor = [ColorHelper getTipColor6];
    [self.contentView addSubview:self.wechatNum];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectZero];
    arrow.image = [UIImage imageNamed:@"ico_next"];
    [self.contentView addSubview:arrow];
    self.arrow = arrow;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:line];
    self.bottomLine = line;
}

- (void)updateConstraints {
    [super updateConstraints];
    __weak typeof(self) wself = self;
    CGFloat offset1 = self.showSelectButton ? 38.0 : 8.0;
    CGFloat offset2 = self.showSelectButton ? -8.0 : -20.0;
    [UIView animateWithDuration:0.25 animations:^{
        [wself.imgV remakeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(@68.0);
            make.top.equalTo(@10);
            make.bottom.lessThanOrEqualTo(wself.contentView.mas_bottom).with.offset(-10);
            make.left.equalTo(wself.contentView.mas_left).offset(offset1);
        }];
        
//        [wself.name remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(wself.imgV.mas_right).offset(8.0);
//            make.top.equalTo(wself.contentView.mas_top).offset(10);
//            make.right.lessThanOrEqualTo(wself.contentView.mas_right).with.offset(offset2);
//        }];
        
        [wself.integral remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wself.name.mas_bottom);
            make.right.equalTo(wself.contentView.mas_right).offset(offset2);
            make.height.equalTo(@20.0);
        }];
        
    } completion:^(BOOL finished) {
        self.selectButton.hidden = !self.showSelectButton;
        self.arrow.hidden = self.showSelectButton;
    }];
}

- (void)addConstraints {
    
    __weak typeof(self) wself = self;
    
    [wself.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.mas_left).offset(10);
        make.centerY.equalTo(wself.contentView.mas_centerY);
        make.width.and.height.equalTo(@22);
    }];
    
    [wself.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(@68.0);
        make.top.equalTo(@10);
        make.bottom.lessThanOrEqualTo(wself.contentView.mas_bottom).with.offset(-10);
        make.left.equalTo(wself.contentView.mas_left).offset(8.0);
    }];
    
    
    [wself.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.imgV.mas_right).offset(8.0);
        make.top.equalTo(wself.contentView.mas_top).offset(10);
        make.right.lessThanOrEqualTo(wself.contentView.mas_right);
    }];
    
    [wself.typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.name.mas_right);
        make.top.equalTo(wself.name.mas_top);
        make.width.and.height.equalTo(@18);
        make.right.lessThanOrEqualTo(wself.contentView.mas_right).with.offset(-10);
    }];
    
    [wself.code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.name.mas_bottom).offset(4);
        make.left.equalTo(wself.name.mas_left);
        make.height.equalTo(@18.0);
    }];
    
    __weak UIView *view = wself.code;
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {
        [wself.style mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wself.code.mas_bottom);
            make.left.equalTo(wself.name.mas_left);
            make.height.equalTo(wself.code.mas_height);
        }];
        view = wself.style;
    }
    
    [wself.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(@22.0);
        make.centerY.equalTo(wself.contentView.mas_centerY);
        make.right.equalTo(wself.contentView.mas_right);
    }];
    
    [wself.shopNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.name.mas_left);
        make.top.equalTo(view.mas_bottom);
        make.height.equalTo(wself.code.mas_height);
        make.bottom.lessThanOrEqualTo(wself.contentView.mas_bottom).with.offset(-10);
    }];
    
    [wself.integral mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.name.mas_bottom);
        make.right.equalTo(wself.contentView.mas_right).offset(-20);
        make.height.equalTo(@20.0);
    }];
    
    [wself.wechatNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.shopNum.mas_top);
        make.height.equalTo(wself.code.mas_height);
        make.right.equalTo(wself.integral.mas_right);
    }];

    CGFloat onePixel = 1/[UIScreen mainScreen].scale;
    [wself.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.mas_left);
        make.right.equalTo(wself.contentView.mas_right);
        make.height.equalTo(@(onePixel));
        make.bottom.equalTo(wself.contentView.mas_bottom);
    }];
}

- (void)prepareForReuse {
    self.imgV.image = [UIImage imageNamed:@"img_default"];
    self.name.text = @"";
    self.code.text = @"";
    self.shopNum.text = @"";
    self.integral.text = @"";
}

- (void)setGiftGoodVo:(id)vo {
    
    NSString *goodName = nil;
    NSString *goodTypeImageName = nil;
    NSInteger shelfStatus = 1; // 商品上下架状态
    if ([vo isKindOfClass:[LSMemberGoodsGiftVo class]]) {
        
        self.shopNum.hidden = NO;
        self.wechatNum.hidden = NO;
        
        LSMemberGoodsGiftVo *goodVo = (LSMemberGoodsGiftVo *)vo;
        self.selectButton.selected = goodVo.selected;
        
        if ([NSString isNotBlank:goodVo.point.stringValue]) { // 积分兑换设置页面
            self.integral.text = [NSString stringWithFormat:@"%@积分",goodVo.point];
        }
        
        if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) { // 服鞋
            self.code.text = goodVo.innerCode;
            self.style.text = [NSString stringWithFormat:@"%@ %@",goodVo.goodsColor,goodVo.goodsSize];
        } else {
            self.code.text = goodVo.barCode;
        }
        
        if (goodVo.limitedGiftStore.boolValue) {
            self.shopNum.text = [NSString stringWithFormat:@"实体数量: %@",goodVo.giftStore];
        } else {
            self.shopNum.text = @"实体数量: 不限";
        }
        
        if (goodVo.limitedWXGiftStore.boolValue) {
            self.wechatNum.text = [NSString stringWithFormat:@"微店数量: %@",goodVo.weixinGiftStore];
        } else {
            self.wechatNum.text = @"微店数量: 不限";
        }
        
        if ([[Platform Instance] getShopMode] == 3) {
            self.shopNum.hidden = YES;
            self.wechatNum.hidden = YES;
        } else if ([[Platform Instance] getShopMode] != 3 && [[Platform Instance] getMicroShopStatus] != 2) {
            self.wechatNum.hidden = YES;
        }
        
        [self.imgV ls_setImageWithPath:goodVo.picture placeholderImage:[UIImage imageNamed:@"img_default"]];
        goodName = goodVo.name?:@"";
        goodTypeImageName = [goodVo goodTypeImageString];
        shelfStatus = goodVo.goodsStatus.integerValue;
    }
    else if ([vo isKindOfClass:[GoodsGiftListVo class]]) { // 积分商品选择界面
        
        GoodsGiftListVo *noGiftVo = (GoodsGiftListVo *)vo;
        self.name.text = noGiftVo.name;
        goodName = noGiftVo.name?:@"";
        goodTypeImageName = [noGiftVo goodTypeImageString];
        shelfStatus = noGiftVo.goodsStatus.integerValue;

        [self.imgV ls_setImageWithPath:noGiftVo.picture placeholderImage:[UIImage imageNamed:@"img_default"]];
        
        if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {
            // 服鞋显示3行：商品名，店内码，颜色尺码
            self.code.text = noGiftVo.innerCode;
            self.shopNum.text = [NSString stringWithFormat:@"%@ %@" ,noGiftVo.goodsColor ,noGiftVo.goodsSize];
        } else {
            // 商超显示2行：商品名，店内码
            self.shopNum.text = noGiftVo.barCode;
        }
    }
    
    // 商品名称 设置
    NSMutableAttributedString *mutAttri = [[NSMutableAttributedString alloc] initWithString:goodName attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName:[ColorHelper getBlackColor]}];
    if (shelfStatus == 2) {
        NSTextAttachment *textAttach = [[NSTextAttachment alloc] init];
        textAttach.image = [UIImage imageNamed:@"ico_alreadyOffShelf"];
        textAttach.bounds = CGRectMake(0, -2, 40, 15);
        NSAttributedString *attri = [NSAttributedString attributedStringWithAttachment:textAttach];
        [mutAttri insertAttributedString:attri atIndex:0];
    }
    self.name.attributedText = mutAttri;
    if ([NSString isNotBlank:goodTypeImageName]) {
        
        self.typeImage.image = [UIImage imageNamed:goodTypeImageName];
    }
}

@end
