//
//  GoodsInfoSelectFooterListView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "FooterListView4.h"
#import "UIView+Sizes.h"
@implementation FooterListView4

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"FooterListView4" owner:self options:nil];
    [self addSubview:self.view];
    
}

-(void) initDelegate:(id<FooterListEvent>) delegate  btnArrs:(NSArray*) arr
{
    self.delegate = delegate;
    [self hideAllBtn];
    for (NSString* btnName in arr) {
        if([[btnName uppercaseString] isEqualToString:@"SCAN"]){
            [self showBtn:self.btnScan img:self.imgScan showStatus:YES];
        }else if([[btnName uppercaseString] isEqualToString:@"BATCH"]){
            [self showBtn:self.btnBatch img:self.imgBatch showStatus:YES];
        }
        
    }
    
}

-(void) hideAllBtn
{
    [self showBtn:self.btnScan img:self.imgScan showStatus:NO];
    [self showBtn:self.btnBatch img:self.imgBatch showStatus:NO];
}

- (void)showBatch:(BOOL)isVisibal {
    self.imgBatch.hidden = !isVisibal;
    self.btnBatch.hidden = !isVisibal;
    self.imgScan.ls_right = isVisibal ? 300-self.imgBatch.ls_width : 310;
    self.btnScan.ls_right = isVisibal ? 300-self.btnBatch.ls_width : 310;
    
}

-(void) showBtn:(UIButton*) btn img:(UIImageView*) img showStatus:(BOOL)status
{
    btn.hidden=!status;
    img.hidden=!status;
}

- (IBAction) onBatchClickEvent:(id)sender
{
    [self.delegate showBatchEvent];
}

- (IBAction) onScanClickEvent:(id)sender
{
    [self.delegate showScanEvent];
}

- (IBAction) onHelpClickEvent:(id)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(showHelpEvent)]) {
        [self.delegate showHelpEvent];
    }
}

@end
