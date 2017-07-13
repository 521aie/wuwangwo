//
// Created by 於卓慧 on 7/6/16.
// Copyright (c) 2016 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TDFCustomerServiceButtonDelegate <NSObject>

//返回用户数据

@end

@class JSBadgeView;

@interface TDFCustomerServiceButtonController : NSObject

- (void)addCustomerServiceButtonToView:(UIView *)view;

@end
