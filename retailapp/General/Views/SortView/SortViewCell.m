//
//  SortViewCell.m
//  retailapp
//
//  Created by qingmei on 15/11/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SortViewCell.h"
#import "ColorHelper.h"
#import "UIView+Sizes.h"
@implementation SortViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (id)getInstance{
    SortViewCell *item = [[[NSBundle mainBundle]loadNibNamed:@"SortViewCell" owner:self options:nil]lastObject];
    return item;
}

-(void) setEditing:(BOOL)editing animated:(BOOL)animated
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
- (void)loadCell:(id)obj{
    
    self.lblItemName.textColor = [ColorHelper getTipColor3];
    
    if ([obj isKindOfClass:[NSString class]]) {
        self.lblItemName.text = (NSString *)obj;
    }
}

@end
