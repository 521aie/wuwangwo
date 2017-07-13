//
//  VirtualStockCell.m
//  retailapp
//
//  Created by guozhi on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "VirtualStockCell.h"
#import "ColorHelper.h"
#import "UIImageView+SDAdd.h"
#import "UIView+Sizes.h"
#import "StockInfoVo.h"
#import "Masonry.h"

@interface VirtualStockCell ()

@property (nonatomic ,assign) BOOL showSelectButton;/**<是否显示选择按钮>*/
@end
@implementation VirtualStockCell

+ (instancetype)virtualStockCellWithTableView:(UITableView *)tableView optional:(BOOL)option {
    VirtualStockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VirtualStockCell"];
    if (!cell) {
        cell = [[VirtualStockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VirtualStockCell"];
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.showSelectButton = option;
        [cell configSubviews];
        [cell addContraints];
    }
    return cell;
}


- (void)configSubviews {
    
    if (self.showSelectButton) {
        self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.selectButton setImage:[UIImage imageNamed:@"ico_uncheck"] forState:UIControlStateNormal];
        [self.selectButton setImage:[UIImage imageNamed:@"ico_check"] forState:UIControlStateSelected];
        [self.contentView addSubview:self.selectButton];
        self.selectButton.userInteractionEnabled = NO;
    }
    
    self.icon = [[UIImageView alloc] init];
    [self.icon ls_addCornerWithRadii:4 roundRect:CGRectMake(0, 0, 68, 68)];
    [self.contentView addSubview:self.icon];
    
    self.name = [[UILabel alloc] init];
    [self.contentView addSubview:self.name];
    self.name.font = [UIFont systemFontOfSize:14.0f];
    self.name.numberOfLines = 0;
   
    self.code = [[UILabel alloc] init];
    [self.contentView addSubview:self.code];
    self.code.textColor = [ColorHelper getTipColor6];
    self.code.font = [UIFont systemFontOfSize:12.0f];
    
    self.stockNum = [[UILabel alloc] init];
    [self.contentView addSubview:self.stockNum];
    self.stockNum.textColor = [ColorHelper getTipColor6];
    self.stockNum.font = [UIFont systemFontOfSize:12.0f];
    
    self.vendibleNum = [[UILabel alloc] init];
    [self.contentView addSubview:self.vendibleNum];
    self.vendibleNum.textColor = [ColorHelper getTipColor6];
    self.vendibleNum.font = [UIFont systemFontOfSize:12.0f];
    self.vendibleNum.textAlignment = NSTextAlignmentRight;
    
    if (!self.showSelectButton) {
        self.arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_next"]];
        [self.contentView addSubview:self.arrow];
    }
    
    self.goodTypeIcon = [[UIImageView alloc] init];
    [self.contentView addSubview:self.goodTypeIcon];
    
    self.bottonLine = [[UIView alloc] init];
    [self.contentView addSubview:self.bottonLine];
    self.bottonLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
}

- (void)addContraints {
    
    __weak typeof(self) wself = self;
    if (self.showSelectButton) {
        [wself.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wself.contentView.mas_left).offset(10);
            make.centerY.equalTo(wself.contentView.mas_centerY);
            make.width.and.height.equalTo(@22);
        }];
    }
    
    if (!wself.showSelectButton) {
        [wself.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wself.contentView.mas_right).offset(-3);
            make.centerY.equalTo(wself.contentView.mas_centerY);
            make.width.and.height.equalTo(@22);
        }];
    }
    
    CGFloat offsetX = self.showSelectButton ? 40 : 10;
    [wself.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.mas_left).offset(offsetX);
        make.top.equalTo(wself.contentView.mas_top).offset(10);
        make.width.and.height.equalTo(@68);
        make.bottom.lessThanOrEqualTo(wself.contentView.mas_bottom).with.offset(-10);
    }];
    

    [wself.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.icon.mas_right).offset(10);
        make.top.equalTo(wself.contentView.mas_top).offset(12.0);
    }];
    
    
    [wself.goodTypeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.name.mas_right);
        make.height.and.width.equalTo(@15);
        make.top.equalTo(wself.contentView.mas_top).offset(13);
        make.right.lessThanOrEqualTo(wself.contentView.mas_right).with.offset(-10);
    }];
    
    
    [wself.code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.icon.mas_right).offset(10.0);
        make.top.equalTo(wself.name.mas_bottom).offset(3.0);
        make.height.equalTo(@17);
    }];
    
    [wself.stockNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.icon.mas_right).offset(10.0);
        make.top.equalTo(wself.code.mas_bottom).offset(3.0);
        make.height.equalTo(wself.code.mas_height);
    }];
    
    offsetX = wself.showSelectButton ? -10: -30;
    [wself.vendibleNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.contentView.mas_right).offset(offsetX);
        make.top.equalTo(wself.stockNum.mas_top);
        make.height.equalTo(wself.code.mas_height);
        make.bottom.lessThanOrEqualTo(wself.contentView.mas_bottom).with.offset(-10);
    }];
    
    CGFloat bottonLineHeight = 1/[UIScreen mainScreen].scale;
    [wself.bottonLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.mas_left);
        make.right.equalTo(wself.contentView.mas_right);
        make.bottom.equalTo(wself.contentView.mas_bottom);
        make.height.equalTo(@(bottonLineHeight));
    }];
}

- (void)initWithStockInfoVo:(StockInfoVo *)stockInfoVo shopMode:(NSInteger)shopMode {
    
    self.goodTypeIcon.hidden = YES;
    BOOL isCloth = [[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101;
    if (self.showSelectButton) {
        self.selectButton.selected = stockInfoVo.isSelected;
    }
    [self.icon ls_setImageWithPath:stockInfoVo.fileName placeholderImage:[UIImage imageNamed:@"img_default"]];
   
    /*
     
     if ([NSString isNotBlank:goodTypeName]) {
     NSTextAttachment *textAttach = [[NSTextAttachment alloc] init];
     textAttach.image = [UIImage imageNamed:goodTypeName];
     textAttach.bounds = CGRectMake(0, 0, 16, 16);
     NSAttributedString *attri = [NSAttributedString attributedStringWithAttachment:textAttach];
     [nameAttri appendAttributedString:attri];
     }
     */
    
    NSString *goodName = isCloth ? stockInfoVo.styleName : stockInfoVo.goodsName;
    goodName = [NSString isNotBlank:goodName]?goodName:@"";
    NSMutableAttributedString *nameAttri = [[NSMutableAttributedString alloc] initWithString:goodName attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[ColorHelper getBlackColor]}];
    
    self.stockNum.text = [NSString stringWithFormat:@"实库存数: %@" ,stockInfoVo.nowStore];
    self.vendibleNum.text = [NSString stringWithFormat:@"可销售数: %@",stockInfoVo.virtualStore];
    
    if (isCloth) {
        self.code.text = [NSString stringWithFormat:@"款号: %@",stockInfoVo.styleCode];
    } else {
        self.code.text = stockInfoVo.barCode;
        NSString *goodTypeName = [stockInfoVo goodTypeImageString];
        if (goodTypeName) {
            self.goodTypeIcon.hidden = NO;
            self.goodTypeIcon.image = [UIImage imageNamed:goodTypeName];
        }
    }
    self.name.attributedText = nameAttri;
    [self.name sizeToFit];
    [self layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
