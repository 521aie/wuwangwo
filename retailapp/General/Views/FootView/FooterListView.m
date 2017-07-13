//
//  FooterListView.m
//  RestApp
//
//  Created by zxh on 14-4-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "FooterListView.h"
#import "UIView+Sizes.h"

@implementation FooterListView
@synthesize view;

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"FooterListView" owner:self options:nil];
    [self addSubview:self.view];
}

- (void)initDelegate:(id<FooterListEvent>) delegate  btnArrs:(NSArray*) arr
{
    self.delegate=delegate;
    [self hideAllBtn];
    BOOL sortVisibal=NO;
    for (NSString* btnName in arr) {
        if ([[btnName uppercaseString] isEqualToString:@"BATCH"]) {
            [self showBtn:self.btnBatch img:self.imgBatch title:@"批量" showStatus:YES];
        } else if ([[btnName uppercaseString] isEqualToString:@"ADD"]) {
            [self showBtn:self.btnAdd img:self.imgAdd title:@"添加" showStatus:YES];
        } else if ([[btnName uppercaseString] isEqualToString:@"DEL"]) {
            [self showBtn:self.btnDel img:self.imgDel title:@"删除" showStatus:NO];
        } else if ([[btnName uppercaseString] isEqualToString:@"PUBLISH"]) {
            [self showBtn:self.btnAdd img:self.imgAdd title:@"发布" showStatus:YES];
        } else if ([[btnName uppercaseString] isEqualToString:@"SORT"]) {
            [self showBtn:self.btnSort img:self.imgSort title:@"排序" showStatus:YES];
            sortVisibal=YES;
        }
    }
    [self.btnAdd setLs_left:sortVisibal?190:255];
    [self.imgAdd setLs_left:sortVisibal?201:266];
    [self.btnAdd setNeedsDisplay];
    [self.imgAdd setNeedsDisplay];
}

- (void)hideAllBtn
{
    self.btnAdd.hidden=YES;
    self.btnDel.hidden=YES;
    self.btnSort.hidden=YES;
    self.btnBatch.hidden=YES;
    
    self.imgAdd.hidden=YES;
    self.imgDel.hidden=YES;
    self.imgSort.hidden=YES;
    self.imgBatch.hidden=YES;
}

- (void)showDel:(BOOL)showFlag
{
   [self showBtn:self.btnDel img:self.imgDel title:@"删除"  showStatus:showFlag];
   [self.btnDel setLs_left:255];
   [self.imgDel setLs_left:264];
}

- (void)showBtn:(UIButton*)btn img:(UIImageView*)img title:(NSString *)title showStatus:(BOOL)status
{
    [btn setTitle:title forState:UIControlStateNormal];
    btn.hidden=!status;
    img.hidden=!status;
}

- (IBAction)onAddClickEvent:(id)sender
{
    [self.delegate showAddEvent];
}

- (IBAction)onDelClickEvent:(id)sender
{
    [self.table setEditing:YES animated:YES];
    [self.delegate showDelEvent];
}
- (IBAction)onSortClickEvent:(id)sender
{
    [self.delegate showSortEvent];
}
- (IBAction)onHelpClickEvent:(id)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(showHelpEvent)]) {
        [self.delegate showHelpEvent];
    }
}

- (IBAction)onBatchClickEvent:(id)sender
{
    [self.delegate showBatchEvent];
}

@end
