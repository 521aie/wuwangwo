//
//  SMHeaderItem.h
//  retailapp
//
//  Created by hm on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMHeaderItem : UIView

@property (nonatomic,weak) IBOutlet UIView* panel;
@property (nonatomic,weak) IBOutlet UILabel* lblVal;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (nonatomic, strong) UIButton *selectButton;/**<选择button>*/

+ (SMHeaderItem*)loadFromNib;
+ (SMHeaderItem *)sm_headerItem:(BOOL)showOptionButton callBackBlack:(void(^)(UIButton *))block;
@end
