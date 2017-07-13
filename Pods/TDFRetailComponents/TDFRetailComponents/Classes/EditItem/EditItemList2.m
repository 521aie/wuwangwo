//
//  EditItemList2.m
//  retailapp
//
//  Created by diwangxie on 16/4/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemList2.h"
#import "SystemUtil.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"
#import "ColorHelper.h"
#import "SystemUtil.h"

@implementation EditItemList2

@synthesize view;

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"EditItemList2" owner:self options:nil];
    [self addSubview:self.view];
    [self.lblStyleCode setHidden:YES];
    [self.lblStyleName setHidden:YES];
    [self.lblContent setHidden:NO];
    [self.lblTip setHidden:YES];
}

-(void)initLabel:(NSString *) label request:(BOOL)request delegate:(id<EditItemList2Delegate>)delegate{
    self.lblTitle.text=label;
    NSString* hitStr=request?@"必填":@"可不填";
    self.lblContent.text=hitStr;
    self.delegate=delegate;
}

- (void)initCode:(NSString *) code initName:(NSString*)name{
    
    if (code==nil || [code isEqual:@""]) {
        [self.lblStyleCode setHidden:YES];
        [self.lblStyleName setHidden:YES];
        self.lblStyleCode.text=@"界面语言";
        self.lblStyleName.text=@"界面语言";
        [self.lblContent setHidden:NO];
    }else{
        [self.lblStyleCode setHidden:NO];
//        if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
//            self.lblStyleCode.text=[NSString stringWithFormat:@"款号:%@",code];
//        } else {
//            self.lblStyleCode.text=[NSString stringWithFormat:@"条形码:%@",code];
//        }
        self.lblStyleCode.text = code;
        self.lblStyleName.text = name;
        self.currentVal = code;
        [self.lblStyleName setHidden:NO];
        [self.lblContent setHidden:YES];
    }
}
- (void)changeCode:(NSString *) code initName:(NSString *)name {
//    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
//         self.lblStyleCode.text=([NSString isBlank:code]) ? @"" :[NSString stringWithFormat:@"款号:%@",code];
//    } else {
//         self.lblStyleCode.text=([NSString isBlank:code]) ? @"" :[NSString stringWithFormat:@"条形码:%@",code];
//    }
    self.lblStyleCode.text = code;
    self.lblStyleName.text=([NSString isBlank:name]) ? @"" :name;
    self.currentVal=([NSString isBlank:code]) ? @"" :code;
    [self.lblStyleCode setHidden:NO];
    [self.lblStyleName setHidden:NO];
    [self.lblContent setHidden:YES];
    [self changeStatus];
}

-(void) changeStatus
{
    [super isChange];
}

-(NSString *)getVal{
    return self.currentVal;
}
- (IBAction)addClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(btnAddClick:)]) {
        [self.delegate btnAddClick:self];
    }
}

- (float) getHeight
{
    return self.line.ls_top+self.line.ls_height+1;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
