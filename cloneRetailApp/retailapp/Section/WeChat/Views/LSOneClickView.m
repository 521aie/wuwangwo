//
//  LSOneClickView.m
//  retailapp
//
//  Created by guozhi on 16/10/9.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSOneClickView.h"

@implementation LSOneClickView

+ (instancetype)show:(UIViewController *)vc {
    LSOneClickView *oneClickView = [[LSOneClickView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H - 64)];
    oneClickView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [vc.view addSubview:oneClickView];
    return oneClickView;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicatorView startAnimating];
        [self addSubview:indicatorView];
        indicatorView.center = CGPointMake(SCREEN_W/2, 160);
        CGFloat lblX = 30;
        CGFloat lblY = 240;
        CGFloat lblW = self.ls_width - 2*lblX;
        CGFloat lblH = 20;
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(lblX, lblY, lblW, lblH)];
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont boldSystemFontOfSize:13];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = @"一键上架商品正在进行中，请稍候～～";
        [self addSubview:lbl];
        
        lblY = lblY + 60;
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(lblX, lblY, lblW, lblH)];
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont boldSystemFontOfSize:13];
        lbl.numberOfLines = 0;
        lbl.text = @"提示：一键上架的商品，销售价策略默认“与零售价相同”，优先度默认设为99";
        [self addSubview:lbl];
        [lbl sizeToFit];
    }
    return self;
}
@end
