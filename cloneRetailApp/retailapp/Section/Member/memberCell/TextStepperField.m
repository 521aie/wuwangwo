//
//  TextStepperField.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "TextStepperField.h"
#import "ColorHelper.h"

@implementation TextStepperField

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeControl];
    }
    return self;
}

- (void)awakeFromNib {
    
    [[NSBundle mainBundle] loadNibNamed:@"TextStepperField" owner:self options:nil];
    [self addSubview:self.view];
    [self setHidden:YES];
    [self initializeControl];

}

- (void)initializeControl {
    
    self.lbVal.text = @"1";
    
    self.autoresizesSubviews=YES;
    self.backgroundColor = [UIColor clearColor];
    self.multipleTouchEnabled = NO;
    self.clipsToBounds = YES;
    [self borderLine:self.lbVal];
    self.lbVal.textColor = [ColorHelper getRedColor];
}

//描绘边框
- (void)borderLine:(UIView*)view
{
    CALayer *layer=[view layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1];
    UIColor* color=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
    [layer setBorderColor:[color CGColor]];
}

#pragma mark - minus/plus
- (IBAction)didPressMinusButton:(id)sender
{
    if (self.lbVal.text.intValue > 1) {
        self.lbVal.text = [NSString stringWithFormat:@"%d", self.lbVal.text.intValue - 1];
        [self.delegate showGoodsNum:-1 item:_vo];
        
    }
    
}

- (IBAction)didPressPlusButton:(id)sender
{
    self.lbVal.text = [NSString stringWithFormat:@"%d", self.lbVal.text.intValue + 1];
    [self.delegate showGoodsNum:1 item:_vo];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
