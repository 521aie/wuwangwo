//
//  GoodsInfoSelectFooterListView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsFooterListView.h"
#import "UIView+Sizes.h"

@implementation GoodsFooterListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        ;
    }
    return self;
}

+ (GoodsFooterListView *)goodFooterListView {
    
    GoodsFooterListView *footerListView = [[GoodsFooterListView alloc] initWithFrame:CGRectZero];
    [[NSBundle mainBundle] loadNibNamed:@"GoodsFooterListView" owner:footerListView options:nil];
    [footerListView addSubview:footerListView.view];
    [footerListView sizeToFit];
    return footerListView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"GoodsFooterListView" owner:self options:nil];
    [self addSubview:self.view];
    
}

- (void)initDelegate:(id<FooterListEvent>)delegate btnArrs:(NSArray *)arr
{
    self.delegate = delegate;
    [self hideAllBtn];
    for (NSString* btnName in arr) {
        if([[btnName uppercaseString] isEqualToString:@"ADD"]){
            [self showView:self.addView showStatus:YES];
        }else if([[btnName uppercaseString] isEqualToString:@"EXPORT"]){
            [self showView:self.exportView showStatus:YES];
        }else if([[btnName uppercaseString] isEqualToString:@"BATCH"]){
            [self showView:self.batchView showStatus:YES];
        }else if([[btnName uppercaseString] isEqualToString:@"SCAN"]){
            [self showView:self.scanView showStatus:YES];
        }else if([[btnName uppercaseString] isEqualToString:@"NOTCHECK"]){
            [self showView:self.notChkAllView showStatus:YES];
        }else if([[btnName uppercaseString] isEqualToString:@"ALLCHECK"]){
            [self showView:self.chkAllView showStatus:YES];
        }
    }
    
    CGFloat width = self.view.frame.size.width-10;
    for (UIView* view in self.view.subviews) {
        if (!view.hidden) {
            [view setLs_right:width];
            width -= view.ls_width;
            width -= 10;
        }
    }
    
}

- (void)hideAllBtn {
    [self showView:self.addView showStatus:NO];
    [self showView:self.exportView showStatus:NO];
    [self showView:self.scanView showStatus:NO];
    [self showView:self.batchView showStatus:NO];
    [self showView:self.notChkAllView showStatus:NO];
    [self showView:self.chkAllView showStatus:NO];
}

- (void)showView:(UIView *)view showStatus:(BOOL)status
{
    view.hidden = !status;
}

- (IBAction)onAddClickEvent:(id)sender
{
    [self.delegate showAddEvent];
}

- (IBAction)onExportClickEvent:(id)sender
{
    [self.table setEditing:YES animated:YES];
    [self.delegate showExportEvent];
}

- (IBAction)onBatchClickEvent:(id)sender
{
    [self.delegate showBatchEvent];
}

- (IBAction)onScanClickEvent:(id)sender
{
    [self.delegate showScanEvent];
}

- (IBAction)onCheckAllClickEvent:(id)sender
{
    [self.delegate checkAllEvent];
}

- (IBAction)onNotCheckAllClickEvent:(id)sender
{
    [self.delegate notCheckAllEvent];
}

//- (IBAction)onHelpClickEvent:(id)sender
//{
//    if (self.delegate&&[self.delegate respondsToSelector:@selector(showHelpEvent)]) {
//        [self.delegate showHelpEvent];
//    }
//}

@end
