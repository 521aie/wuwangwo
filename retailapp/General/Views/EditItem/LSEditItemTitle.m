//
//  LSEditItemTitle.m
//  retailapp
//
//  Created by guozhi on 2017/3/16.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSEditItemTitle.h"
@interface LSEditItemTitle()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *btn;
/** <#注释#> */
@property (nonatomic, copy) RightClickBlock rightClickBlock;

/** <#注释#> */
@property (nonatomic, assign) LSEditItemTitleType type;
@end
@implementation LSEditItemTitle
+ (instancetype)editItemTitle {
    LSEditItemTitle *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
    [view setup];
    return view;
}

- (void)setup {
    self.frame = CGRectMake(0, 0, SCREEN_W, 48);
    self.btn.hidden = YES;
    self.imgView.hidden = YES;
    
}

- (void)configTitle:(NSString *)title type:(LSEditItemTitleType)type rightClick:(RightClickBlock)rightClickBlock; {
    self.lblName.text = title;
    self.rightClickBlock = rightClickBlock;
    self.btn.hidden = NO;
    self.type = type;
    self.imgView.hidden = NO;
    if (type == LSEditItemTitleTypeOpen) {
        self.imgView.image = [UIImage imageNamed:@"ico_fold_up"];
    } else if (type == LSEditItemTitleTypeDown) {
        self.imgView.image = [UIImage imageNamed:@"ico_bottom"];
    } else if (type == LSEditItemTitleTypeClose) {
        self.imgView.image = [UIImage imageNamed:@"ico_fold"];
    }
    
    
}

- (IBAction)btnClick:(id)sender {
    if (self.rightClickBlock) {
         self.rightClickBlock(self);
    }
    if (self.type == LSEditItemTitleTypeOpen) {
        self.type = LSEditItemTitleTypeClose;
        self.imgView.image = [UIImage imageNamed:@"ico_fold"];
    } else  if (self.type == LSEditItemTitleTypeClose) {
        self.type = LSEditItemTitleTypeOpen;
        self.imgView.image = [UIImage imageNamed:@"ico_fold_up"];
    }
}

- (void)configTitle:(NSString *)title {
    self.lblName.text = title;
}
- (void)visibal:(BOOL)show
{
    [self setLs_height:show?[self getHeight]:0];
    self.alpha=show?1:0;
};

- (float)getHeight
{
    return 48;
}
@end
