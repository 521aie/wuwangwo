//
//  FooterListView6.m
//  retailapp
//
//  Created by yanguangfu on 15/11/13.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "FooterListView6.h"
#import "UIView+Sizes.h"

@implementation FooterListView6

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
    [[NSBundle mainBundle] loadNibNamed:@"FooterListView6" owner:self options:nil];
    [self addSubview:self.view];
    
}

-(void) initDelegate:(id<FooterListEvent>) delegate  btnArrs:(NSArray*) arr
{
    self.delegate = delegate;
    [self hideAllBtn];
    for (NSString* btnName in arr) {
        
        if([[btnName uppercaseString] isEqualToString:@"ADD"]){
            [self showBtn:self.btnAdd img:self.imgAdd showStatus:YES];
        }else if([[btnName uppercaseString] isEqualToString:@"SCAN"]){
            [self showBtn:self.btnScan img:self.imgScan showStatus:YES];
        }
    }
    if (arr.count == 1 && [[arr.firstObject uppercaseString] isEqualToString:@"SCAN"]) {
        self.imgScan.ls_right = 310;
        self.btnScan.ls_right = 310;
    }
}
-(void) hideAllBtn
{
    [self showBtn:self.btnAdd img:self.imgAdd showStatus:NO];
    [self showBtn:self.btnScan img:self.imgScan showStatus:NO];
}

-(void) showBtn:(UIButton*) btn img:(UIImageView*) img showStatus:(BOOL)status
{
    btn.hidden=!status;
    img.hidden=!status;
}

- (IBAction)onScanClickEvent:(id)sender {
    [self.delegate showScanEvent];
}

- (IBAction)onAddClickEvent:(id)sender {
    [self.delegate showAddEvent];
}
@end