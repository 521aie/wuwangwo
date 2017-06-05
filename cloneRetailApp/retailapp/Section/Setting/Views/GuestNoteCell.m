//
//  NameValueCell.m
//  RestApp
//
//  Created by zxh on 14-4-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "GuestNoteCell.h"
#import "UIView+Sizes.h"

@implementation GuestNoteCell

-(void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing) {
        UIView* scrollView=self.subviews[0];
        for (UIView* view in scrollView.subviews) {
            if ([NSStringFromClass([view class]) rangeOfString:@"Reorder"].location!=NSNotFound) {
                for (UIView* subView in view.subviews) {
                    if ([subView isKindOfClass:[UIImageView class]]) {
                        UIImageView* imgSort=(UIImageView*)subView;
                        imgSort.image=[UIImage imageNamed:@"ico_sort_table.png"];
                        [imgSort setLs_height:22];
                    }
                }
            }
        }
    }
}
- (IBAction)btnClick:(UIButton *)sender {
    if (self.delegate != nil &&[self.delegate respondsToSelector:@selector(onClick:)]) {
        [self.delegate onClick:self];
    }
    
}

@end
