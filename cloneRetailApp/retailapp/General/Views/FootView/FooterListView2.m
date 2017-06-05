//
//  FooterListView2.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "FooterListView2.h"

@implementation FooterListView2

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"FooterListView2" owner:self options:nil];
    [self addSubview:self.view];
}

-(void) initDelegate:(id<FooterListEvent>) delegate  btnArrs:(NSArray*) arr
{
    self.delegate=delegate;
    [self hideAllBtn];
    for (NSString* btnName in arr) {
        if ([[btnName uppercaseString] isEqualToString:@"EDIT"]) {
            [self showBtn:self.btnEdit img:self.imgEdit title:@"修改" showStatus:YES];
        } else if ([[btnName uppercaseString] isEqualToString:@"ADD"]) {
            [self showBtn:self.btnAdd img:self.imgAdd title:@"添加" showStatus:YES];
        }
    }
}

-(void) hideAllBtn
{
    self.btnAdd.hidden = YES;
    self.btnEdit.hidden = YES;
    
    self.imgAdd.hidden = YES;
    self.imgEdit.hidden = YES;
}

-(void) showBtn:(UIButton*)btn img:(UIImageView*)img title:(NSString *)title showStatus:(BOOL)status
{
    [btn setTitle:title forState:UIControlStateNormal];
    btn.hidden=!status;
    img.hidden=!status;
}

- (IBAction) onAddClickEvent:(id)sender
{
    [self.delegate showAddEvent];
}

- (IBAction) onEditClickEvent:(id)sender
{
    [self.delegate showEditEvent];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
