//
//  CopyFounctionLabel.m
//  RestApp
//
//  Created by xueyu on 16/3/31.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "CopyFounctionLabel.h"
#import "NSString+Estimate.h"
@implementation CopyFounctionLabel
- (id)initWithFrame:(CGRect)frame

{
    self = [super initWithFrame:frame];
    if (self)
        
    {
        [self attachLongPressHandler];
    }
    
    return self;
    
}


-(void)awakeFromNib

{
    [super awakeFromNib];
    
    [self attachLongPressHandler];
    
}
-(void)attachLongPressHandler

{
    
    self.userInteractionEnabled = YES;  //用户交互的总开关
    UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    
    touch.minimumPressDuration = 1.0f;
    
    [self addGestureRecognizer:touch];
    
    
}

-(void)handleLongPress:(UIGestureRecognizer*) recognizer

{
    [self becomeFirstResponder];
    self.backgroundColor = [UIColor blackColor];
   UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyFuncyion:)];
    
   [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
    
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
    
}

-(BOOL)canBecomeFirstResponder

{
    return YES;
    
}
-(BOOL)resignFirstResponder{
    [super resignFirstResponder];
    self.backgroundColor = [UIColor clearColor];
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if ([NSString isBlank:self.text]) {
        [self resignFirstResponder];
        return NO;
    }
    if (action == @selector(copyFuncyion:)) {
        return YES;
    }
    return NO;
}
-(void)copyFuncyion:(id)sender

{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
    if ([NSString isNotBlank:pboard.string]) {
        [self.delegate copyEventFininshed];
        [self resignFirstResponder];
    }
 }

@end
