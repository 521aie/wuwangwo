//
//  SRItemView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/11/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SRItemView.h"

@interface SRItemView ()


@end

@implementation SRItemView

+ (SRItemView *)loadFromNib {
    SRItemView* itemView = [[[NSBundle mainBundle] loadNibNamed:@"SRItemView" owner:nil options:nil] objectAtIndex:0];
    return itemView;
}

- (void)setTitle:(NSString *)title value:(NSString *)value {
    self.lblTitle.text = title;
    self.lblValue.text = value;
}

- (void)setTitle:(NSString *)title attributedValue:(NSAttributedString *)value {
    self.lblTitle.text = title;
    self.lblValue.attributedText = value;
}

- (void)setAttributedTitle:(NSAttributedString *)title attributedValue:(NSAttributedString *)value {
    self.lblTitle.attributedText = title;
    self.lblValue.attributedText = value;
}

- (UILabel *)getValueLabel {
    return self.lblValue;
}
@end
