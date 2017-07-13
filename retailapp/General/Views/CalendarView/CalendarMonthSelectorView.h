//
//  CalendarMonthSelectorView.h
//  retailapp
//
//  Created by qingmei on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarMonthSelectorView : UIView

@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, weak) IBOutlet UIButton *forwardButton;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *imgLeft;
@property (strong, nonatomic) IBOutlet UIButton *imgRight;

@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *dayLabels;

// Designated initialiser
+ (id)view;

@end
