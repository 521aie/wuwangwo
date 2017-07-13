//
//  LSSmsRechargeCell.m
//  retailapp
//
//  Created by guozhi on 16/9/2.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSmsRechargeCell.h"
#import "ColorHelper.h"
#import "UIView+Sizes.h"

@implementation LSSmsRechargeCell
+ (instancetype)smsRechargeCellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    LSSmsRechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
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
        
        self.img = [[UIImageView alloc] init];
        [self addSubview:self.img];
        
        self.line = [[UIView alloc] init];
        self.line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        [self addSubview:self.line];
    }
    return self;
}
- (void)setSmsPackageVo:(LSSmsPackageVo *)smsPackageVo {
    _smsPackageVo = smsPackageVo;
    NSString *name = [NSString stringWithFormat:@"▪︎ %@", smsPackageVo.name];
    self.lblName.text = name;
    if (smsPackageVo.isSelect) {
        self.img.image = [UIImage imageNamed:@"ico_check"];
    } else {
        self.img.image = [UIImage imageNamed:@"ico_uncheck"];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat margin = 10;
    CGFloat lblNameX = margin;
    CGFloat lblNameY = 0;
    CGFloat lblNameW = 300;
    CGFloat lblNameH = self.ls_height;
    self.lblName.frame = CGRectMake(lblNameX, lblNameY, lblNameW, lblNameH);
    CGFloat imgW = 20;
    CGFloat imgH = 20;
    CGFloat imgX = self.ls_width - margin - imgW;
    CGFloat imgY = (self.ls_height - imgH) / 2;
    self.img.frame = CGRectMake(imgX, imgY, imgW, imgH);
    
    CGFloat lineX = margin;
    CGFloat lineH = 1;
    CGFloat lineY = self.ls_height - lineH;
    CGFloat lineW = self.ls_width - 2 * margin;
    self.line.frame = CGRectMake(lineX, lineY, lineW, lineH);
    
}


@end
