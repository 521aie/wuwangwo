//
//  TicketReviewController.m
//  retailapp
//
//  Created by taihangju on 16/8/31.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TicketReviewController.h"
#import "UIView+Sizes.h"
#import "NavigateTitle2.h"

@interface TicketReviewController ()<INavigateEvent>

@property (nonatomic ,strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) UIScrollView *scrollView;/*<>*/
@property (nonatomic ,strong) UIImageView *reviewImageView;/*<模板预览view>*/
@end

@implementation TicketReviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 64.0);
    [self.titleBox initWithName:@"小票模板预览" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:self.titleBox];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64.0, SCREEN_W, SCREEN_H - 64)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    
    CGFloat topY = 0.0;
    
    // 提示文案
    UILabel *notice = [[UILabel alloc] initWithFrame:CGRectMake(10, topY, SCREEN_W - 20, 50)];
    notice.font = [UIFont systemFontOfSize:13.0];
    notice.textColor = [ColorHelper getTipColor6];
    notice.numberOfLines = 0;
    [self.scrollView addSubview:notice];
    topY += notice.ls_height;
    notice.text = @"以下是标准小票的模板预览图，在实际打印小票时，系统会根据选择的打印内容进行排版打印。";
    NSString *imageName = nil;
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {//服鞋
        if (self.type == SmallTicketType58mm) {//58mm
            imageName = @"xiaopiao_setting_style_58mm";
        } else if (self.type == SmallTicketType80mm){
            imageName = @"xiaopiao_setting_style_80mm";
        }
    } else if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 102){//商超
        if (self.type == SmallTicketType58mm) {//58mm
            imageName = @"xiaopiao_setting_goods_58mm";
        } else if (self.type == SmallTicketType80mm){
            imageName = @"xiaopiao_setting_goods_80mm";
        }
        
    }
    // 模板展示图
    self.reviewImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    self.reviewImageView.ls_top = topY;
    self.reviewImageView.ls_centerX = self.scrollView.ls_centerX;
    [self.scrollView addSubview:self.reviewImageView];
    topY = self.reviewImageView.ls_bottom;
    
    [self.scrollView setContentSize:CGSizeMake(SCREEN_W, topY + 60)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - 协议方法

// INavigateEvent
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        [self popToLatestViewController:kCATransitionFromLeft];
    }
    else if (event == DIRECT_RIGHT)
    {
        
    }
}

@end
