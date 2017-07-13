//
//  FooterListView3.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "FooterListView5.h"

@implementation FooterListView5

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
    [[NSBundle mainBundle] loadNibNamed:@"FooterListView5" owner:self options:nil];
    [self addSubview:self.view];
    
}

-(void) initDelegate:(id<FooterListEvent>) delegate  btnArrs:(NSArray*) arr
{
    self.delegate = delegate;
    [self hideAllBtn];
    for (NSString* btnName in arr) {
        if([[btnName uppercaseString] isEqualToString:@"UNAUTO"]){
            self.btnUnauto.hidden = NO;
            self.imgUnauto.hidden = NO;
        }else if([[btnName uppercaseString] isEqualToString:@"EXPORT"]){
            [self showBtn:self.btnExport img:self.imgExport showStatus:YES];
        }
    }
    
}

- (IBAction)onUnautoClickEvent:(id)sender {
    [self.delegate showUnautoEvent];
}

-(void) hideAllBtn
{
    [self showBtn:self.btnExport img:self.imgExport showStatus:NO];
    self.btnUnauto.hidden = YES;
    self.imgUnauto.hidden = YES;
    self.imgUnautoing.hidden = YES;
}

-(void) showBtn:(UIButton*) btn img:(UIImageView*) img showStatus:(BOOL)status
{
    btn.hidden=!status;
    img.hidden=!status;
}
/**正在生成按钮是否可见*/
- (void)isVisibal:(BOOL)isVisibal {
    self.btnUnauto.hidden = isVisibal;
    self.labTime.hidden = !isVisibal;
    self.imgUnauto.hidden = isVisibal;
    self.imgUnautoing.hidden = !isVisibal;
}


- (IBAction) onExportClickEvent:(id)sender
{
    [self.delegate showExportEvent];
}


- (IBAction) onHelpClickEvent:(id)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(showHelpEvent)]) {
        [self.delegate showHelpEvent];
    }
}


@end
