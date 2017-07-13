//
//  LSInfoAlertView.m
//  retailapp
//
//  Created by guozhi on 2016/10/20.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSInfoAlertView.h"
#import "LSInfoAlertViewItem.h"

@interface LSInfoAlertView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@end
@implementation LSInfoAlertView

- (instancetype)init {
    if (self = [super init]) {
        [self configViews];
        [self configConstraints];
    }
    return self;
    
}

- (void)configViews {
  
    self.scrollView = [[UIScrollView alloc] init];
    [self addSubview:self.scrollView];
    
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.pageControl = [[UIPageControl alloc] init];
    [self addSubview:self.pageControl];
    self.pageControl.currentPage = 0;
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
}

- (void)configConstraints {
      __weak typeof(self) wself = self;
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 30, 0));
    }];
    [self.pageControl makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.scrollView.bottom);
        make.left.right.right.equalTo(wself);
    }];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = scrollView.contentOffset.x/self.scrollView.frame.size.width;
}

- (void)loadDatas:(NSArray<LSInfoAlertVo *> *)datas callBlcok:(CallBlock)callBlock {
    self.pageControl.numberOfPages = datas.count;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.ls_width * datas.count, self.scrollView.ls_height);
    self.pageControl.hidesForSinglePage = YES;
    __weak typeof(self) wself = self;
    for (int i = 0; i < datas.count; i++) {
        LSInfoAlertViewItem *item = [[LSInfoAlertViewItem alloc] init];
        [wself.scrollView addSubview:item];
        [item infoAlertView:datas[i] callBlock:callBlock];
        [item makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(wself.scrollView);
            make.top.equalTo(wself.scrollView);
            make.left.equalTo(i*wself.scrollView.ls_width);
        }];
    }
}

@end
