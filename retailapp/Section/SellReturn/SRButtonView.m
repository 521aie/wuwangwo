//
//  SRButtonView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/11/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SRButtonView.h"

@implementation SRButtonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (SRButtonView *)loadFromNibWithTitle:(NSString *)title {
    SRButtonView* buttonView = [[[NSBundle mainBundle] loadNibNamed:@"SRButtonView" owner:nil options:nil] objectAtIndex:0];
    [buttonView.buttonNext setTitle:title forState:UIControlStateNormal];
    return buttonView;
}

@end
