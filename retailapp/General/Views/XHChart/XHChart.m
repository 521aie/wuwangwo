//
//  XHChart.m
//  testReg
//
//  Created by zxh on 14-8-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "XHChart.h"
#import "ChartItem.h"

@implementation XHChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemCount=31;
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.delegate = self;
        self.scrollView.contentSize = CGSizeMake((self.bounds.size.width/self.itemCount)*(self.itemCount+2), self.bounds.size.height);
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.contentOffset = CGPointMake((self.bounds.size.width/self.itemCount), 0);
        
        [self addSubview:self.scrollView];
    }
    return self;
}
//设置初始化页数
- (void)setCurrentSelectPage:(NSInteger)selectPage
{
    self.currentPage = selectPage;
}

- (void)reloadData
{
    self.totalPages = [self.datasource numberOfPages:self];
    if (self.totalPages == 0) {
        return;
    }
    [self loadData];
}

- (void)loadData
{
    NSArray *subViews = [self.scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:self.currentPage];
    
    for (int i = 0; i < (self.itemCount+2); i++) {
        UIView *v = [self.curViews objectAtIndex:i];
        v.frame = CGRectOffset(v.frame, v.frame.size.width*i, 0 );
        [self.scrollView addSubview:v];
    }
    
    [self.scrollView setContentOffset:CGPointMake( (self.bounds.size.width/self.itemCount),0  )];
}

- (void)getDisplayImagesWithCurpage:(NSInteger)page {
    if (!self.curViews) {
        self.curViews = [[NSMutableArray alloc] init];
    }
    
    [self.curViews removeAllObjects];
    
    for (int i=-1; i<=self.itemCount; i++) {
        NSInteger pre1 = self.currentPage+i;
        [self.curViews addObject:[self.datasource pageAtIndex:pre1 andScrollView:self]];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [self.delegate didClickPage:self atIndex:self.currentPage];
    }
}

- (void)setAfterScrollShowView:(UIScrollView*)scrollview  andCurrentPage:(NSInteger)pageNumber
{
    ChartItem* item=nil;
    NSInteger midVal= (self.itemCount % 2==0?(self.itemCount-1)/2:self.itemCount/2);
    for (int i=0;i<self.itemCount;i++) {
        item= (ChartItem*)[[scrollview subviews] objectAtIndex:pageNumber+i];
        item.backgroundColor =[UIColor clearColor];
        
        if (i==midVal) {
            item.lbl.textColor=RGBA(250, 0, 0, 1);
            [item.view setBackgroundColor:RGBA(255, 255, 255, 1)];
        }else{
            if (item.week==1) {
                item.lbl.textColor=RGBA(255, 255, 255, 1);
            }else{
                item.lbl.textColor=RGBA(255, 255, 255, 0.3);
            }
            [item.view setBackgroundColor:RGBA(255, 255, 255, 0.3)];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    NSInteger page = aScrollView.contentOffset.x/((self.bounds.size.width/self.itemCount));
    
    if (x>2*(self.bounds.size.width/self.itemCount) && self.currentPage<self.totalPages-16) {
        self.currentPage=self.currentPage+1;
        [self loadData];
    }
    if (x<=0 && self.currentPage>-15) {
        self.currentPage=self.currentPage-1;
        [self loadData];
    }

    if (page>1 || page <=0) {
        [self setAfterScrollShowView:aScrollView andCurrentPage:1];
    }
    if ([self.delegate respondsToSelector:@selector(scrollviewDidChangeNumber)]) {
        [self.delegate scrollviewDidChangeNumber];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self setAfterScrollShowView:scrollView andCurrentPage:1];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.scrollView setContentOffset:CGPointMake((self.bounds.size.width/self.itemCount),0 ) animated:YES];
    [self setAfterScrollShowView:scrollView andCurrentPage:1];
    if ([self.delegate respondsToSelector:@selector(scrollviewDidChangeNumber)]) {
        [self.delegate scrollviewDidChangeNumber];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self setAfterScrollShowView:scrollView andCurrentPage:1];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.scrollView setContentOffset:CGPointMake((self.bounds.size.width/self.itemCount),0) animated:YES];
    [self setAfterScrollShowView:scrollView andCurrentPage:1];
    if ([self.delegate respondsToSelector:@selector(scrollviewDidChangeNumber)]) {
        [self.delegate scrollviewDidChangeNumber];
    }
}

@end
