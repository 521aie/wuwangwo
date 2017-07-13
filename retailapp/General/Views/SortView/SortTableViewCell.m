//
//  SortTableViewCell.m
//  retailapp
//
//  Created by guozhi on 16/2/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "SortTableViewCell.h"
#import "UIView+Sizes.h"
@interface SortTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *labName;
@end
@implementation SortTableViewCell
- (void)setTitle:(NSString *)title {
    self.labName.text = title;
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

@end
