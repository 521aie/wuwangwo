//
//  SMHeaderItem.m
//  retailapp
//
//  Created by hm on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SMHeaderItem.h"

@interface SMHeaderItem ()

@property (nonatomic, copy) void(^selectCallBack)(UIButton *sender);/**<点击选择button后的回调>*/
@end

@implementation SMHeaderItem

+ (SMHeaderItem*)loadFromNib
{
  SMHeaderItem* item = [[[NSBundle mainBundle] loadNibNamed:@"SMHeaderItem" owner:nil options:nil] objectAtIndex:0];
    return item;
}

+ (SMHeaderItem *)sm_headerItem:(BOOL)showOptionButton callBackBlack:(void(^)(UIButton *))block {
    SMHeaderItem* item = [[[NSBundle mainBundle] loadNibNamed:@"SMHeaderItem" owner:nil options:nil] objectAtIndex:0];
    item.selectCallBack = block;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(12, 2, 18, 18);
    [button setImage:[UIImage imageNamed:@"ico_uncheck"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"ico_check"] forState:UIControlStateSelected];
    [button addTarget:item action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [item.panel addSubview:button];
    item.selectButton = button;
    button.hidden = !showOptionButton;
    return item;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (void)initialize {
    self.panel.layer.cornerRadius = 11.0;
    self.panel.layer.masksToBounds = YES;
}

- (void)buttonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.selectCallBack) {
        self.selectCallBack(sender);
    }
}

@end
