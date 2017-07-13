//
//  FooterListView3.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "FooterListView3.h"

@implementation FooterListView3

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
    [[NSBundle mainBundle] loadNibNamed:@"FooterListView3" owner:self options:nil];
    [self addSubview:self.view];
    
}

-(void) initDelegate:(id<FooterListEvent>) delegate  btnArrs:(NSArray*) arr
{
    self.delegate = delegate;
    [self hideAllBtn];
    for (NSString* btnName in arr) {
        if([[btnName uppercaseString] isEqualToString:@"ADD"]){
            [self showBtn:self.btnAdd img:self.imgAdd showStatus:YES];
        }else if([[btnName uppercaseString] isEqualToString:@"EXPORT"]){
            [self showBtn:self.btnExport img:self.imgExport showStatus:YES];
        }else if([[btnName uppercaseString] isEqualToString:@"SCAN"]){
            [self showBtn:self.btnScan img:self.imgScan showStatus:YES];
        }
    }
    
}

-(void) hideAllBtn
{
    [self showBtn:self.btnAdd img:self.imgAdd showStatus:NO];
    [self showBtn:self.btnExport img:self.imgExport showStatus:NO];
    [self showBtn:self.btnScan img:self.imgScan showStatus:NO];
}

-(void) showBtn:(UIButton*) btn img:(UIImageView*) img showStatus:(BOOL)status
{
    btn.hidden=!status;
    img.hidden=!status;
}

- (IBAction) onAddClickEvent:(id)sender
{
    [self.delegate showAddEvent];
}

- (IBAction) onExportClickEvent:(id)sender
{
    [self.table setEditing:YES animated:YES];
    [self.delegate showExportEvent];
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
