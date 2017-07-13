//
//  EditItemList2.m
//  retailapp
//
//  Created by diwangxie on 16/4/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemList3.h"
#import "SystemUtil.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"
#import "ColorHelper.h"
#import "SystemUtil.h"

@implementation EditItemList3

@synthesize view;

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"EditItemList3" owner:self options:nil];
    [self addSubview:self.view];
    self.lblStyleCode.textColor = [ColorHelper getTipColor6];
}

- (void)initFromNib:(id<EditItemList3Delegate>)delegate
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"EditItemList3" owner:self options:nil];
    [self addSubview:self.view];
    self.delegate = delegate;
     self.lblStyleCode.textColor = [ColorHelper getTipColor6];
}

- (void)initCode:(NSString *)code initName:(NSString *)name {
//    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
//        self.lblStyleCode.text=[NSString stringWithFormat:@"款号:%@",code];
//    } else {
//        self.lblStyleCode.text=[NSString stringWithFormat:@"条形码:%@",code];
//    }
    self.lblStyleCode.text = code;
    self.lblStyleName.text=name;
}

- (void)changeData:(NSString *)code withVal:(NSString *)name {
//    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
//        self.lblStyleCode.text=[NSString stringWithFormat:@"款号:%@",code];
//    } else {
//        self.lblStyleCode.text=[NSString stringWithFormat:@"条形码:%@",code];
//    }
    self.lblStyleCode.text = code;
    self.lblStyleName.text=name;
    [self changeStatus];
}

#pragma change status
- (void)changeStatus {
    
    [super isChange];
}

-(NSString *)getVal{
    return self.currentVal;
}

- (IBAction)delClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(btnDelClick:)]) {
        [self.delegate btnDelClick:self];
    }
}

- (float) getHeight {
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
