//
//  UIHelper.m
//  retailapp
//
//  Created by hm on 15/6/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "UIHelper.h"
#import "UIView+Sizes.h"
#import "ItemBase.h"
#import "Platform.h"
#import "EditItemBase.h"
#import "EditItemChange.h"
#import "SystemUtil.h"
#import "AlertBox.h"

@implementation UIHelper

#pragma 界面处理部分.
+ (void)clearColor:(UIView*) container{
    for (UIView* view in container.subviews) {
        [view setBackgroundColor:[UIColor clearColor]];
    }
}

+ (void)refreshPos:(UIView*) container scrollview:(UIScrollView*) scrollView
{
    
    float height=0;
    id<ItemBase> base=nil;
    for (UIView*  view in container.subviews) {
        if ([view isHidden]) {
            continue;
        }
        
        [view setLs_top:height];
        if ([view conformsToProtocol:@protocol(ItemBase)]) {
            base=(id<ItemBase>)view;
            height+=[base getHeight];
        }else{
            height+=view.ls_height;
        }
        [container setNeedsDisplay];
    }
    if (scrollView) {
        int contentHeight=[[Platform Instance] getScreenHeight]-64;
        height=height>contentHeight?height:contentHeight;
        [container setLs_height:(height+88)];
        scrollView.contentSize=CGSizeMake(SCREEN_W, container.ls_height);
    }
    
}

//界面变动后，刷新界面.
+ (void)refreshUI:(UIView *)container scrollview:(UIScrollView *)scrollView
{
    float height=0;
    for (UIView*  view in container.subviews) {
        if (!view.hidden) {
            [view setLs_top:height];
            height+=view.ls_height;
        }
    }
    int contentHeight=SCREEN_H-64;
    height=height>contentHeight?height:contentHeight;
    if (![container isKindOfClass:[UIScrollView class]]) {
        [container setLs_height:(height+88)];
    }
    
    if (scrollView) {
        scrollView.contentSize=CGSizeMake(SCREEN_W, height+88.0);
        [container setNeedsDisplay];
    }
}


+ (void)refreshUI:(UIView*)container
{
    float height=0;
    for (UIView*  view in container.subviews) {
        if (!view.hidden) {
            [view setLs_top:height];
            height+=view.ls_height;
        }
    }
    if ([container isKindOfClass:[UIScrollView class]]) {
        int contentHeight=SCREEN_H-64;
        height = height>contentHeight?height:contentHeight;
        UIScrollView *scrollView = (UIScrollView *)container;
        scrollView.contentSize = CGSizeMake(SCREEN_W, height+88.0);
    } else {
        [container setLs_height:height];
    }
   
    
}

//超出界面滚动，反之则不滚动.
+ (void)refreshView:(UIView*)container scrollView:(UIScrollView*)scrollView
{
    float height=0;
    for (UIView*  view in container.subviews) {
        if (!view.hidden) {
            [view setLs_top:height];
            height+=view.ls_height;
        }
    }
    float contentHeight = scrollView.ls_height;
    height = height>contentHeight?height+48:contentHeight;
    [container setLs_height:height];
    if (scrollView) {
        scrollView.contentSize=CGSizeMake(SCREEN_W, container.ls_height);
        [container setNeedsDisplay];
    }
}

+ (void)initNotification:(UIView*)container event:(NSString*) eventType
{
    EditItemBase *current=nil;
    for (UIView *view in container.subviews) {
        if ([view isKindOfClass:[EditItemBase class]]) {
            current=(EditItemBase*)view;
            current.notificationType=eventType;
        }
    }
}

+ (void)alert:(UIView *)view andDelegate:(id)delegate andTitle:(NSString *)title
{
    UIActionSheet * alertView = [[UIActionSheet alloc] initWithTitle:title delegate:delegate cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确认", nil];
    [alertView showInView:[UIApplication sharedApplication].keyWindow];
}

+ (void)alert:(UIView *)view andDelegate:(id)delegate andTitle:(NSString *)title event:(int)event
{
    UIActionSheet * alertView = [[UIActionSheet alloc] initWithTitle:title delegate:delegate cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确认", nil];
    alertView.tag=event;
    [alertView showInView:[UIApplication sharedApplication].keyWindow];
}

+ (void)clearChange:(UIView*)container
{
    id<EditItemChange> base=nil;
    for (UIView*  view in container.subviews) {
        if ([view conformsToProtocol:@protocol(EditItemChange)]) {
            base=(id<EditItemChange>)view;
            [base clearChange];
        }
    }
}

+ (BOOL)currChange:(UIView*)container
{
    EditItemBase* current=nil;
    for (UIView*  view in container.subviews) {
        if (view.hidden == NO &&  [view isKindOfClass:[EditItemBase class]]) {
            current=(EditItemBase*)view;
            if (current.baseChangeStatus) {
                return YES;
            }
        }
    }
    return NO;
}

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize{
    UIGraphicsBeginImageContext(newsize);
    [img drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
    
}

@end
