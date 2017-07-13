//
//  TDFBaseConditionFilter.m
//  TDFConditionFilter
//
//  Created by taihangju on 2017/2/10.
//  Copyright © 2017年 2dfire. All rights reserved.
//

#import "TDFBaseConditionFilter.h"

@interface TDFBaseConditionFilter () {
    UITapGestureRecognizer *tap;
}
@end
@implementation TDFBaseConditionFilter

- (instancetype)initFilter:(NSString *)title image:(NSString *)imageName highlightImage:(NSString *)highlightImageName {
    
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGFloat kRightViewWidth = 200;
    
    self = [super initWithFrame:CGRectMake(kRightViewWidth, 0, screenWidth, screenHeight)];
    if (self) {
        
        tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(hideMainView:)];
        [self addGestureRecognizer:tap];
        tap.enabled = NO;
        
        // 配置相关子views
        {
            // 右边wrapper View
            UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(screenWidth-kRightViewWidth, 0, kRightViewWidth, screenHeight)];
            rightView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
            [self addSubview:rightView];
            self.rightView = rightView;
            
            CGFloat levelMargin = 10.0f; // 子view到rightView水平边缘的间距
            CGFloat subviewWidth = kRightViewWidth - 2*levelMargin; // rightView 子视图宽度
            
            // 标题: 距离rightView 左边界15
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(levelMargin+5, 27, subviewWidth-10, 22)];
            titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
            titleLabel.font = [UIFont boldSystemFontOfSize:16];
            titleLabel.text = title;
            [rightView addSubview:titleLabel];
            self.titleLabel = titleLabel;
            
            // 顶部分割线
            UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(levelMargin, 63, subviewWidth, 1/([UIScreen mainScreen].scale))];
            topLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
            [rightView addSubview:topLine];
            self.rightView = rightView;
            
            // talbeview
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(levelMargin, 64.0, subviewWidth, screenHeight-64.0)];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.showsVerticalScrollIndicator = NO;
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 5, 0);
            [rightView addSubview:tableView];
            self.tableView = tableView;

            
            // filter button
            UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [filterButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [filterButton setBackgroundImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
            [filterButton addTarget:self action:@selector(changeFilterFrame) forControlEvents:UIControlEventTouchUpInside];
            filterButton.frame = CGRectMake(-38.0, screenHeight/2-34.5, 38.0, 67.0);
            [rightView addSubview:filterButton];
            self.filterButton = filterButton;
        }
    }
    return self;
}

- (void)hideMainView:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.rightView];
    if (CGRectContainsPoint(self.rightView.bounds, point)) {
        return;
    }
    [self changeFilterFrame];
}

// 点击：隐藏或者显示
- (void)changeFilterFrame {
    if (self.frame.origin.x > 0) {
        CGFloat rightViewWidth = CGRectGetWidth(self.rightView.frame);
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformMakeTranslation(-rightViewWidth, 0);
        } completion:^(BOOL finished) {
            tap.enabled = NO; // 避免影响发生在cell上的点击
        }];
    } else {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [self endEditing:YES];
        }];
    }
}


// 返会包含point的view对象
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if ([self pointInside:point withEvent:event] == NO) {
        return nil;
    }
    
    // 先判断point是不是在filterButton 上
    CGRect rect = [self convertRect:self.filterButton.frame fromView:self.rightView];
    if (CGRectContainsPoint(rect, point)) {
        return self.filterButton;
    }
    
    // 判断point是不是在rightView及其子类控件上
    int count = (int)self.subviews.count - 1;
    for (int i = count ; i >= 0 ; --i) {
        
        UIView *subview = self.subviews[i];
        CGPoint covertPoint = [self convertPoint:point toView:subview];
        UIView *responderView = [subview hitTest:covertPoint withEvent:event];
        if (responderView) {
            return responderView;
        }
    }
    
    // point 在自身除去子控件以外的范围，这时候的处理分两种情况:@1 筛选view已经显示，进行隐藏 @2 筛选view未显示，返回nil
    if (self.frame.origin.x > 0) {
        return nil;
    }
    
    tap.enabled = YES;
    
    return self;
}
@end
