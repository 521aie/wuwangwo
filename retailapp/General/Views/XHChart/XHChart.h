//
//  XHChart.h
//  testReg
//
//  Created by zxh on 14-8-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XHChartDataSource;
@protocol XHChartDelegate;
@interface XHChart : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *curViews;
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger itemCount;

@property (nonatomic, assign) id<XHChartDataSource> datasource;
@property (nonatomic, assign) id<XHChartDelegate> delegate;

- (void)setCurrentSelectPage:(NSInteger)selectPage; //设置初始化页数

- (void)reloadData;

- (void)loadData;

@end

@protocol XHChartDelegate <NSObject>

@optional

- (void)didClickPage:(XHChart *)csView atIndex:(NSInteger)index;

- (void)scrollviewDidChangeNumber;

@end

@protocol XHChartDataSource <NSObject>

@required

- (NSInteger)numberOfPages:(XHChart*)scrollView;

- (UIView *)pageAtIndex:(NSInteger)index andScrollView:(XHChart *)scrollView;

@end
