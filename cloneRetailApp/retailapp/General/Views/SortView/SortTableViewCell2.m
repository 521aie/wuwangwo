//
//  SortTableViewCell.m
//  retailapp
//
//  Created by guozhi on 16/2/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "SortTableViewCell2.h"
#import "UIView+Sizes.h"
#import "UIImageView+SDAdd.h"
@interface SortTableViewCell2()
@property (weak, nonatomic) IBOutlet UIImageView *imgBox;
@property (weak, nonatomic) IBOutlet UILabel *lblStyleName;
@property (weak, nonatomic) IBOutlet UILabel *lblStyleCode;

@end
@implementation SortTableViewCell2
- (void)setInitView:(NSString *) filePath styleName:(NSString *) styleName styleCode:(NSString*) styleCode{
    [self.imgBox sd_setImageWithURL_Corner:[NSURL URLWithString:[NSString urlFilterRan:filePath]] placeholderImage:nil];
    self.lblStyleName.text = styleName;
    self.lblStyleCode.text = styleCode;
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
