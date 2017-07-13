//
//  MemoInputBox.m
//  RestApp
//
//  Created by zxh on 14-4-18.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemoInputView.h"
#import "NavigateTitle2.h"
#import "KeyBoardUtil.h"
#import "SystemUtil.h"
#import "ColorHelper.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"

@interface MemoInputView ()
@property (nonatomic, copy) NSString *val;
@end

@implementation MemoInputView

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigate];
    [self initMainView];
}

#pragma navigateTitle.
-(void) initNavigate{
    [self configTitle:self.titleName leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
    [KeyBoardUtil initWithTarget:self.txtMemo];
}

-(void) onNavigateEvent:(LSNavigationBarButtonDirect)event{
    if (event == LSNavigationBarButtonDirectLeft) {
        [self.txtMemo resignFirstResponder];
        if (![self.val isEqualToString:self.txtMemo.text]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"内容有变更尚未保存，确定要退出吗？" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
                [self.navigationController popViewControllerAnimated:NO];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
            [self.navigationController popViewControllerAnimated:NO];
        }

    } else {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
        [self.delegate finishInput:self.event content:self.txtMemo.text];
    }
}

- (void)initMainView {
    self.txtMemo.text =  self.val;
    self.txtMemo.textColor = [UIColor blackColor];
    if ([NSString isBlank:self.val]) {
        self.lblPlaceHolder.hidden = NO;
    } else {
         self.lblPlaceHolder.hidden = YES;
    }
    self.lblPlaceHolder.text = [NSString stringWithFormat:@"请输入%@...", self.titleName];
    self.txtMemo.delegate=self;
    self.txtMemo.returnKeyType=UIReturnKeyDone;
    [self.txtMemo becomeFirstResponder];
    [self rendText];

}



- (void)limitShow:(NSInteger)eventTemp delegate:(id<MemoInputClient>)delegate title:(NSString*)titleName val:(NSString*)val limit:(int)limit
{
    self.event=eventTemp;
    self.lenLimit=limit;
    self.delegate = delegate;
    self.titleName=titleName;
    self.val=val;
}


#pragma mark-textfield.delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];  //textField为你的UITextField实例对象
        return NO;
    }
    if (textView.markedTextRange == nil &&textView.text.length >= self.lenLimit && text.length > range.length) {
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.markedTextRange == nil && [textView.text length]>self.lenLimit) {
        textView.text=[textView.text substringToIndex:self.lenLimit];
    }
    if (textView.text.length > 0) {
        self.lblPlaceHolder.hidden = YES;
    } else {
        self.lblPlaceHolder.hidden = NO;
    }
    [self rendText];
}

- (void)rendText
{
    NSInteger li = [self.txtMemo.text length];
    li=(self.lenLimit-li<0)?0:(self.lenLimit-li);
    if(li <=0 ){
        self.lblTip.textColor=[ColorHelper getRedColor];
    }else{
        self.lblTip.textColor=[ColorHelper getBlueColor];
    }
    
    self.lblTip.text=[NSString stringWithFormat:@"还能输入%ld个字",(long)li];
}
@end
