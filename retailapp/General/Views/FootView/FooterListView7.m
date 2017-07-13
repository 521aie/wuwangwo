//
//  FooterListView6.m
//  retailapp
//
//  Created by yanguangfu on 15/11/13.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "FooterListView7.h"
#import "UIView+Sizes.h"

@implementation FooterListView7

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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
    [[NSBundle mainBundle] loadNibNamed:@"FooterListView7" owner:self options:nil];
    [self addSubview:self.view];
    
}

-(void) initDelegate:(id<FooterListEvent>) delegate  btnArrs:(NSArray*) arr
{
    self.delegate = delegate;
    [self hideAllBtn];
    for (NSString* btnName in arr) {
        
        if([[btnName uppercaseString] isEqualToString:@"BATCH"]){
            [self showBtn:self.btnBatch img:self.imgBatch showStatus:YES];
        }else if([[btnName uppercaseString] isEqualToString:@"EXPORT"]){
            [self showBtn:self.btnExport img:self.imgExport showStatus:YES];
        }
    }
}
-(void) hideAllBtn
{
    [self showBtn:self.btnBatch img:self.imgBatch showStatus:NO];
    [self showBtn:self.btnExport img:self.imgExport showStatus:NO];
}

-(void) showBtn:(UIButton*) btn img:(UIImageView*) img showStatus:(BOOL)status
{
    btn.hidden=!status;
    img.hidden=!status;
}

- (IBAction)onBatchClickEvent:(id)sender {
    [self.delegate showBatchEvent];
}

- (IBAction)onExportClickEvent:(id)sender {
    [self.delegate showExportEvent];
}
@end
