//
//  FooterMultiView.m
//  RestApp
//
//  Created by zxh on 14-6-25.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "FooterMultiView.h"

@implementation FooterMultiView

+ (FooterMultiView *)footerMuiltSelectView:(id<FooterMultiEvent>)delegate {
    
    FooterMultiView *footer = [[FooterMultiView alloc] initWithFrame:CGRectZero];
    [[NSBundle mainBundle] loadNibNamed:@"FooterMultiView" owner:footer options:nil];
    [footer addSubview:footer.view];
    [footer sizeToFit];
    footer.delegate = delegate;
    return footer;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"FooterMultiView" owner:self options:nil];
    [self addSubview:self.view];
}

- (void)initDelegate:(id<FooterMultiEvent>)delegateTemp
{
    self.delegate = delegateTemp;
}

- (IBAction)onCheckAllClickEvent:(id)sender
{
     [self.delegate checkAllEvent];
}

- (IBAction)onNotCheckAllClickEvent:(id)sender
{
    [self.delegate notCheckAllEvent];
}

@end
