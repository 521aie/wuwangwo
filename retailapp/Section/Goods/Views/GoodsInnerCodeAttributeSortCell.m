//
//  GoodsInnerCodeAttributeSortCell.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/14.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsInnerCodeAttributeSortCell.h"
#import "UIView+Sizes.h"
@implementation GoodsInnerCodeAttributeSortCell

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing) {
        for (UIView* view in self.subviews) {
            if ([NSStringFromClass([view class]) rangeOfString:@"Reorder"].location!= NSNotFound) {
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

@end
