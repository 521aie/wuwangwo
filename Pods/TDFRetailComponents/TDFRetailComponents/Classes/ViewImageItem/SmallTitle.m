//
//  SmallTitle.m
//  RestApp
//
//  Created by hm on 15/1/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SmallTitle.h"
#import "UIView+Sizes.h"

@implementation SmallTitle
@synthesize view;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"SmallTitle" owner:self options:nil];
    [self addSubview:self.view];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.lblName setBackgroundColor:[UIColor clearColor]];
    if (self.ls_height>48) {
        [self.view setLs_height:48];
        [self setLs_height:48];
    }
}

- (float)getHeight{
    return 48;
}

- (void)initDelegate:(id<ISmallTitleEvent>)delegate event:(int)event title:(NSString *)titleName {
    
    self.delegate=delegate;
    self.event=event;
    self.lblName.text = titleName;
    if (event == EXPAND_TYPE) {
        self.img.image = [UIImage imageNamed:@"ico_fold_up"];
    } else {
        self.img.image = [UIImage imageNamed:@"ico_bottom"];
    }
    [self showBtn:self.btn img:self.img showStatus:YES];

}

- (void)showBtn:(UIButton *)btn img:(UIImageView *)img showStatus:(BOOL)status {
    
    btn.hidden = !status;
    img.hidden = !status;
}


- (IBAction)btnClick:(id)sender {
    
    if (self.event== EXPAND_TYPE) {
       [self.delegate onTitleExpandClick:self.event];
    } else if (self.event == MOVE_TYPE) {
        [self.delegate onTitleMoveToBottomClick:self.event];
    }
   
}


-(void) visibal:(BOOL)show {
    
    [self setLs_height:show?[self getHeight]:0];
    self.alpha=show?1:0;
}

@end
