//
//  LSOrderPayTypeCell.m
//  retailapp
//
//  Created by guozhi on 16/9/2.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSOrderPayTypeCell.h"
#import "ColorHelper.h"
#import "UIView+Sizes.h"

@implementation LSOrderPayTypeCell
+ (instancetype)orderPayTypeCellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    LSOrderPayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.lblName = [[UILabel alloc] init];
        self.lblName.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.lblName];
        
        self.imgCheck = [[UIImageView alloc] init];
        [self addSubview:self.imgCheck];
        
        self.imgIcon = [[UIImageView alloc] init];
        [self addSubview:self.imgIcon];

        
        self.line = [[UIView alloc] init];
        self.line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        [self addSubview:self.line];
    }
    return self;
}

- (void)setPayVo:(LSPayVo *)payVo {
    _payVo = payVo;
    self.imgIcon.image = [UIImage imageNamed:payVo.path];
    self.lblName.text = payVo.name;
    if (payVo.isSelect) {
        self.imgCheck.image = [UIImage imageNamed:@"ico_check"];
    } else {
        self.imgCheck.image = [UIImage imageNamed:@"ico_uncheck"];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = 10;
    
    CGFloat imgW = 20;
    CGFloat imgH = 20;
    CGFloat imgX = self.ls_width - margin - imgW;
    CGFloat imgY = (self.ls_height - imgH) / 2;
    self.imgCheck.frame = CGRectMake(imgX, imgY, imgW, imgH);
    
    CGFloat lineX = margin;
    CGFloat lineH = 1;
    CGFloat lineY = self.ls_height - lineH;
    CGFloat lineW = self.ls_width - 2 * margin;
    self.line.frame = CGRectMake(lineX, lineY, lineW, lineH);
    
    CGFloat imgIconX = margin;
    CGFloat imgIconW = 22;
    CGFloat imgIconH = 22;
    CGFloat imgIconY = (self.ls_height - imgIconH)/2;
    self.imgIcon.frame = CGRectMake(imgIconX, imgIconY, imgIconW, imgIconH);
    
    CGFloat lblNameX = self.imgIcon.ls_right + margin;;
    CGFloat lblNameY = 0;
    CGFloat lblNameW = 300;
    CGFloat lblNameH = self.ls_height;
    self.lblName.frame = CGRectMake(lblNameX, lblNameY, lblNameW, lblNameH);
    
}


@end
