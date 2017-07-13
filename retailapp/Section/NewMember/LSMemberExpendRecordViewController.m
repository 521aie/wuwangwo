//
//  LSMemberExpendRecordViewController.m
//  retailapp
//
//  Created by taihangju on 16/10/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberExpendRecordViewController.h"
#import "NavigateTitle2.h"
#import "LSMemberSearchBar.h"
#import "LSSegmentedView.h"

@interface LSMemberExpendRecordViewController ()<INavigateEvent>

@property (nonatomic ,strong) LSMemberSearchBar *mbSearchBar;/*<搜索框>*/
@property (nonatomic ,strong) NavigateTitle2 *titleBox;/*<>*/
@property (nonatomic ,strong) UIScrollView *scrollView;/*<>*/
@property (nonatomic ,strong) LSSegmentedView *segmentView;/*<>*/
@end

@implementation LSMemberExpendRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configSubviews {
    
    if (!self.titleBox) {
        self.titleBox = [NavigateTitle2 navigateTitle:self];
        self.titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
        [self.titleBox initWithName:@"会员消费记录" backImg:Head_ICON_BACK moreImg:nil];
        [self.view addSubview:self.titleBox];
    }

    if (!self.scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64.0, SCREEN_W, SCREEN_H-64.0)];
        [self.view addSubview:self.scrollView];
    }
    
    
    CGFloat topY = 0.0;
    if (!self.mbSearchBar) {
        self.mbSearchBar = [LSMemberSearchBar memberSearchBar:^(NSString *queryString) {
            
        }];
        [self.scrollView addSubview:self.mbSearchBar];
    }
    self.mbSearchBar.ls_top = topY;
    topY += self.mbSearchBar.ls_height;
    
    if (!self.segmentView) {
        self.segmentView = [LSSegmentedView segmentedView:^(NSInteger index) {
            
        }];
        [self.scrollView addSubview:self.segmentView];
    }
    self.segmentView.ls_top = topY + 8.0;
    topY = self.segmentView.ls_bottom;
}

#pragma mark - 相关协议方法

//导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        [self popToLatestViewController:kCATransitionFromLeft];
    }
    else if (event == DIRECT_RIGHT) {
        
    }
}
@end
