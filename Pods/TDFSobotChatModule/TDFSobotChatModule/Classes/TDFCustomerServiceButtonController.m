//
// Created by 於卓慧 on 7/6/16.
// Copyright (c) 2016 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFCustomerServiceButtonController.h"
#import "JSBadgeView.h"
#import "Masonry.h"
#import <SobotKit/SobotKit.h>
#import "TDFSobotChat.h"

///屏幕宏
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface TDFCustomerServiceButtonController ()

@property (nonatomic, weak) UIView *view;

@property (nonatomic, strong) UIButton *customerServiceButton;

@property (nonatomic, strong) JSBadgeView *badgeView;

@end

@implementation TDFCustomerServiceButtonController


- (UIButton *)customerServiceButton {
    
    if (!_customerServiceButton) {
        _customerServiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *image = [UIImage imageNamed:@"icon_ customer_service"];
        [_customerServiceButton setImage:image forState:UIControlStateNormal];
        
        _customerServiceButton.frame = CGRectMake(
                                                  self.view.frame.size.width - image.size.width,
                                                  (self.view.frame.size.height - image.size.height) / 2.0f,
                                                  image.size.width,
                                                  image.size.height
                                                  );
        [_customerServiceButton addTarget:self action:@selector(customerServiceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveButton:)];
        [_customerServiceButton addGestureRecognizer:pan];
    }
    
    return _customerServiceButton;
}

- (void)moveButton:(UIPanGestureRecognizer *)panGestureRecognizer
{
    BOOL isEnd = panGestureRecognizer.state == UIGestureRecognizerStateEnded || panGestureRecognizer.state == UIGestureRecognizerStateCancelled;
    
    CGPoint point = [panGestureRecognizer locationInView:self.view];
    
    if (isEnd) {
        [self endDraggingWithPoint:point];
    } else {
        [self.customerServiceButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(point.y - 30);
            make.leading.equalTo(self.view).with.offset(point.x - 30);
        }];
    }
}

- (void)endDraggingWithPoint:(CGPoint)point
{
    CGFloat top = point.y;
    CGFloat leading = point.x;
    CGFloat traling = SCREEN_WIDTH - leading;
    CGFloat bottom = SCREEN_HEIGHT - top;
    
    CGFloat minDistance = top;
    NSTimeInterval animateDuration = 0.8;
    CGPoint endPoint = CGPointMake(0, 0);
    
    if (leading < minDistance) {
        minDistance = leading;
    }
    
    if (traling < minDistance) {
        minDistance = traling;
    }
    
    if (bottom < minDistance) {
        minDistance = bottom;
    }
    
    if (minDistance == top) {
        endPoint = CGPointMake(point.x, 30);
    } else if (minDistance == leading) {
        endPoint = CGPointMake(30, point.y);
    } else if (minDistance == traling) {
        endPoint = CGPointMake(SCREEN_WIDTH - 30, point.y);
    } else if (minDistance == bottom) {
        endPoint = CGPointMake(point.x, SCREEN_HEIGHT - 30);
    }
    
    [UIView animateWithDuration:animateDuration animations:^{
        [self.customerServiceButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(endPoint.y - 30);
            make.leading.equalTo(self.view).with.offset(endPoint.x - 30);
        }];
    }];
    
    //    NSLog(@"%f, %f, %f, %f", top, leading, traling, bottom);
}


- (void)dragButtonClicked:(UIButton *)sender
{
    [self customerServiceButtonAction:sender];
}

- (JSBadgeView *)badgeView {
    if (!_badgeView) {
        _badgeView = [[JSBadgeView alloc] initWithParentView:self.customerServiceButton alignment:JSBadgeViewAlignmentTopRight];
        
        _badgeView.badgePositionAdjustment = CGPointMake(-18.0f, 5.0f);
    }
    return _badgeView;
}

- (void)leftNavButtonAction:(UIButton *)sender {
    UINavigationController *navigationController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    [navigationController.topViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)addCustomerServiceButtonToView:(UIView *)view {
    self.view = view;
    
    [self.view addSubview:self.customerServiceButton];
    
    [self.customerServiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).with.offset(SCREEN_WIDTH - 60);
        make.top.equalTo(self.view).with.offset(SCREEN_HEIGHT / 2);
        make.height.equalTo(@(60));
        make.width.equalTo(@(60));
    }];
    //赋值展示未读数view
    [TDFSobotChat shareInstance].badgeView = self.badgeView;
}

- (void)customerServiceButtonAction:(UIButton *)sender {

    [[TDFSobotChat shareInstance] startTDFChatView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
