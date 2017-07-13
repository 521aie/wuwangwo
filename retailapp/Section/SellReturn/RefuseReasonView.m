//
//  RefuseReasonView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/11/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "RefuseReasonView.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"
#import "KeyBoardUtil.h"

@interface RefuseReasonView () <INavigateEvent>

@end

@implementation RefuseReasonView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    if (self.status == 4) {
        
        [self.titleBox initWithName:@"审核不通过" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
        self.lblPlaceHolder.text = @"请输入审核不通过的原因";
    } else if (self.status == 1) {
        
        [self.titleBox initWithName:@"拒绝退货原因" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
        self.lblPlaceHolder.text = @"请输入拒绝退货的原因";
    } else {
        [self.titleBox initWithName:@"拒绝退款原因" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
        self.lblPlaceHolder.text = @"请输入拒绝退款的原因";
    }
    [self.titleDiv addSubview:self.titleBox];
    [KeyBoardUtil initWithTarget:self.textView];
}

-(void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.lblPlaceHolder.hidden = NO;
    } else {
        self.lblPlaceHolder.hidden = YES;
    }
    NSString *txt = textView.text;
    if (txt.length > 100) {
        txt = [txt substringToIndex:100];
        textView.text = txt;
        if (self.status == 4) {
            [AlertBox show:@"审核不通过字数限制为100"];
        } else if (self.status == 1) {
            [AlertBox show:@"拒绝退货字数限制为100"];
        } else {
            [AlertBox show:@"拒绝退款字数限制为100"];
        }
    }
}

-(void) onNavigateEvent:(Direct_Flag)event {
    if (event == 1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        NSString *reason = self.textView.text;
        if (self.status == 4 || self.status==3 || self.status==1) {
            if ([NSString isBlank:reason]) {
                [AlertBox show:self.lblPlaceHolder.text];
                return;
            }
        }
         self.refuseReasonBack(reason);
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

@end
