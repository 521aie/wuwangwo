//
//  LSSelectCategoryCell.m
//  retailapp
//
//  Created by guozhi on 16/10/9.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSelectCategoryCell.h"

@implementation LSSelectCategoryCell

+ (instancetype)selectCategoryCellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cellIdentifier";
    LSSelectCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LSSelectCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.img = [[UIImageView alloc] init];
        [self.contentView addSubview:self.img];
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        
        self.lblCategoryName = [[UILabel alloc] init];
        self.lblCategoryName.font = [UIFont systemFontOfSize:15];
        self.lblCategoryName.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.lblCategoryName];
        
        
        self.viewLine = [[UIView alloc] init];
        self.viewLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        [self.contentView addSubview:self.viewLine];
        
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)setCategoryVo:(CategoryVo *)categoryVo {
    if (categoryVo.isSelect) {
        self.img.image = [UIImage imageNamed:@"ico_check"];
    } else {
        self.img.image = [UIImage imageNamed:@"ico_uncheck"];
    }
    self.lblCategoryName.text = categoryVo.name;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat margin = 10;
    CGFloat imgW = 22;
    CGFloat imgH = 22;
    CGFloat imgX = margin;
    CGFloat imgY = (CGRectGetHeight(self.frame) - imgH)/2;
    self.img.frame = CGRectMake(imgX, imgY, imgW, imgH);
    
    CGFloat lblCategoryNameX = CGRectGetMaxX(self.img.frame) + 20;
    CGFloat lblCategoryNamey = 0;
    CGFloat lblCategoryNameW = CGRectGetWidth(self.frame) - 60;
    CGFloat lblCategoryNameH = CGRectGetHeight(self.frame);
    self.lblCategoryName.frame = CGRectMake(lblCategoryNameX, lblCategoryNamey, lblCategoryNameW, lblCategoryNameH);
    
    CGFloat viewLineX = 0.0f;
    CGFloat viewLineH = 1.0f/[UIScreen mainScreen].scale;
    CGFloat viewLineY = CGRectGetHeight(self.frame) - viewLineH;
    CGFloat viewLineW = CGRectGetWidth(self.frame) - 2*viewLineX;
    self.viewLine.frame = CGRectMake(viewLineX, viewLineY, viewLineW, viewLineH);
}


@end
