//
//  SRTitleView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/11/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SRTitleView.h"

@interface SRTitleView ()

@property (weak, nonatomic) IBOutlet UILabel *lblValue;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineTrail;
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineLead;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@end

@implementation SRTitleView

+ (SRTitleView *)loadFromNibWithTitle:(NSString *)title {
    
    SRTitleView *titleView = [[[NSBundle mainBundle] loadNibNamed:@"SRTitleView" owner:nil options:nil] objectAtIndex:0];
    titleView.ls_width = SCREEN_W;
    titleView.lblTitle.text = title;
    return titleView;
}

+ (instancetype)titleViewWith:(NSString *)title {
    
    SRTitleView *titleView = [[[NSBundle mainBundle] loadNibNamed:@"SRTitleView" owner:nil options:nil] objectAtIndex:0];
    titleView.bottomLine.hidden = YES;
    titleView.lblTitle.font = [UIFont systemFontOfSize:15.0];
    titleView.lblValue.textColor = [ColorHelper getTipColor6];
    [titleView.bottomLineLead setConstant:10];
    [titleView.bottomLineTrail setConstant:10];
    titleView.ls_width = SCREEN_W;
    titleView.lblTitle.text = title;
    
    return titleView;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [_topLineHeight setConstant:1.0f/[UIScreen mainScreen].scale];
    [_bottomLineHeight setConstant:1.0f/[UIScreen mainScreen].scale];
}

- (void)setTitle:(NSString *)title {
    
    self.lblTitle.text = title;
}

- (void)setAttributedTitle:(NSAttributedString *)title {
    
    self.lblTitle.attributedText = title;
}

- (void)setLblText:(NSString *)lblText color:(UIColor *)lblColr {
    
    CGFloat titleWidth = [_lblTitle intrinsicContentSize].width;
    CGFloat maxValuewidth = CGRectGetMaxX([UIScreen mainScreen].bounds) - 32.0f - titleWidth;
    CGFloat valueHeight = 21.0;
    if (lblText.length > 10) {
        valueHeight = [NSString getTextSizeWithText:lblText font:_lblValue.font maxSize:CGSizeMake(maxValuewidth, CGFLOAT_MAX)].height;
        if (valueHeight > 21.0f) {
            self.ls_height = 44.0f - 21.0f + valueHeight;
        }
    }
    
//    CGFloat height = 
    _lblValue.text = lblText;
    if (lblColr) {
         _lblValue.textColor = lblColr;
    }
}

@end
