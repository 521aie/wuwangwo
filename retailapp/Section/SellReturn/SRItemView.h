//
//  SRItemView.h
//  retailapp
//
//  Created by Jianyong Duan on 15/11/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRItemView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblValue;
@property (weak, nonatomic) IBOutlet UIView *line;

+ (SRItemView *)loadFromNib;
- (void)setTitle:(NSString *)title value:(NSString *)value;
- (void)setTitle:(NSString *)title attributedValue:(NSAttributedString *)value;
- (void)setAttributedTitle:(NSAttributedString *)title attributedValue:(NSAttributedString *)value;
- (UILabel *)getValueLabel;
@end
