//
//  SRTitleView.h
//  retailapp
//
//  Created by Jianyong Duan on 15/11/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRTitleView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMarginConstraint;

+ (SRTitleView *)loadFromNibWithTitle:(NSString *)title;
// 代理EditItemText显示不可编辑项
+ (instancetype)titleViewWith:(NSString *)title;

- (void)setTitle:(NSString *)title;
- (void)setAttributedTitle:(NSAttributedString *)title;
- (void)setLblText:(NSString *)lblText color:(UIColor *)lblColr;
@end
