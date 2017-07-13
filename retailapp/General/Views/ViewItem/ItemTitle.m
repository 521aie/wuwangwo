//
//  ItemTitle.m
//  RestApp
//
//  Created by zxh on 14-4-3.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ItemTitle.h"
#import "UIView+Sizes.h"
#import "ColorHelper.h"
@implementation ItemTitle
@synthesize view;

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"ItemTitle" owner:self options:nil];
    [self addSubview:self.view];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.lblName setBackgroundColor:[UIColor clearColor]];
    [self.lblName setTextColor:[ColorHelper getTipColor3]];
    if (self.ls_height>48) {
        [self.view setLs_height:48];
        [self setLs_height:48];
    }
}

+ (ItemTitle *)itemTitle:(NSString *)text {
    
    ItemTitle *title = [[ItemTitle alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48)];
    title.view.ls_width = SCREEN_W;
    [[NSBundle mainBundle] loadNibNamed:@"ItemTitle" owner:title options:nil];
    [title addSubview:title.view];
    [title.view setBackgroundColor:[UIColor clearColor]];
    [title.lblName setBackgroundColor:[UIColor clearColor]];
    [title.lblName setTextColor:[ColorHelper getTipColor3]];
    title.lblName.text = text ? : @"";
    return title;
}

- (void)initDelegate:(id<IItemTitleEvent>)delegate event:(NSInteger)event btnArrs:(NSArray*) arr
{
    self.delegate=delegate;
    self.event=event;
    for (NSString* btnName in arr) {
        if ([[btnName uppercaseString] isEqualToString:@"ADD"]) {
            [self showBtn:self.btnAdd img:self.imgAdd showStatus:YES];
        } else if ([[btnName uppercaseString] isEqualToString:@"SORT"]) {
            [self showBtn:self.btnSort img:self.imgSort showStatus:YES];
        }
    }
}

- (void)showBtn:(UIButton*) btn img:(UIImageView*) img showStatus:(BOOL)status
{
    btn.hidden=!status;
    img.hidden=!status;
}

- (IBAction)btnAddClick:(id)sender
{
    [self.delegate onTitleAddClick:self.event];
}

- (IBAction)btnSortClick:(id)sender
{
    [self.delegate onTitleSortClick:self.event];
}

- (void)visibal:(BOOL)show
{
    [self setLs_height:show?[self getHeight]:0];
    self.alpha=show?1:0;
}

- (float)getHeight
{
    return 48;
}

@end
