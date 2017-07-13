//
//  KeyBoardUtil.m
//  CardApp
//
//  Created by 邵建青 on 13-12-23.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import "KeyBoardUtil.h"
#import "KeyBoardBar.h"

//#define SPACE_HEIGTHT 10

static KeyBoardUtil *keyBoardUtil;

@implementation KeyBoardUtil

+ (void)initWithTarget:(UITextField *)contentView
{
    if (keyBoardUtil == nil) {
        keyBoardUtil = [[KeyBoardUtil alloc] init];
//        [keyBoardUtil initKeyBoardNotification];
    }
    [keyBoardUtil initTarget:contentView];
}

- (id)init
{
    self = [super init];
    if(self) {
        keyBoardBar = [[KeyBoardBar alloc]initWithFrame:CGRectMake(0, 0, 320, 32) client:nil];
    }
    return self;
}

- (void)initTarget:(UITextField *)view
{
    if (view != nil) {
        view.inputAccessoryView = keyBoardBar;
//        [self initKeyBoardNotification];
    }
}

////监听键盘隐藏和显示事件
//- (void)initKeyBoardNotification
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//}
//
//
//- (UIResponder *)getFirstResponder {
//    
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wundeclared-selector"
//    UIResponder *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
//#pragma clang diagnostic pop
//    return firstResponder;
//}
//
////计算当前键盘的高度
//-(void)keyboardWillShow:(NSNotification *)notification {
//	
//    UIResponder *responder = [self getFirstResponder];
//    if ([responder isKindOfClass:[UITextView class]] || [responder isKindOfClass:[UITextField class]]) {
//       
//        UIView *targertView = [self getResponderSuperView:(UIView *)responder];
//        if (targertView) {
//
//            NSValue *keyboardEndBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
//            CGRect keyboardEndRect;
//            [keyboardEndBoundsValue getValue:&keyboardEndRect];
//            UIWindow *window = [self getCurrentWindow:responder];
//            CGRect convertFrame = [window convertRect:[(UIView *)responder frame] fromView:[(UIView *)responder superview]];
//            
//            if (CGRectGetMinY(keyboardEndRect) < CGRectGetMaxY(convertFrame)) {
//                
//                dValue += CGRectGetMinY(keyboardEndRect) - CGRectGetMaxY(convertFrame);
//                
//                if ([targertView isKindOfClass:[UIScrollView class]]) {
//                    
//                    UIScrollView *view = (UIScrollView *)targertView;
//                    view.contentOffset = CGPointMake(view.contentOffset.x, view.contentOffset.y-dValue);
//                }
//                else if (fabs(dValue) > 0) {
//                    [UIView animateWithDuration:0.25 animations:^{
//                        UIView *targertView = [self getResponderSuperView:(UIView *)responder];
//                        targertView.transform = CGAffineTransformMakeTranslation(0, dValue);
//                    }];
//                }
//            }
//        }
//    }
//}
//
//
//-(void)keyboardWillHide:(NSNotification *)notification {
//    
//    UIResponder *responder = [self getFirstResponder];
//    if ([responder isKindOfClass:[UITextView class]] || [responder isKindOfClass:[UITextField class]]) {
//        
//        UIView *targertView = [self getResponderSuperView:(UIView *)responder];
//        if (targertView) {
//            
//            if ([targertView isKindOfClass:[UIScrollView class]]) {
//                UIScrollView *view = (UIScrollView *)targertView;
//                view.contentOffset = CGPointMake(view.contentOffset.x, view.contentOffset.y+dValue);
//            }
//            else if (fabs(dValue)>0) {
//                [UIView animateWithDuration:0.25 animations:^{
//                    
//                    if (targertView) {
//                        targertView.transform = CGAffineTransformIdentity;
//                    }
//                }];
//            }
//        }
//    }
//    
//    dValue = 0;
//}
//
//
//- (UIView *)getResponderSuperView:(UIView *)responder {
//    
//    
//    for (UIView *view = responder; view; view = view.superview) {
//        
//        NSString *viewClass = NSStringFromClass([view class]);
//        if ([viewClass isEqualToString:@"UIScrollView"] || [viewClass isEqualToString:@"UITableView"] || [viewClass isEqualToString:@"UICollectionView"]) {
//            return view;
//        }
//        
//        if ([[view nextResponder] isKindOfClass:[UIViewController class]]) {
//            return view;
//        }
//    }
//    return nil;
//}
//
//
//- (UIWindow *)getCurrentWindow:(UIResponder *)responder {
//    
//    for (UIResponder *nextResponder = responder; nextResponder; nextResponder = nextResponder.nextResponder) {
//        if ([nextResponder isKindOfClass:[UIWindow class]]) {
//            return (UIWindow *)nextResponder;
//        }
//    }
//    return nil;
//}
/////监听键盘隐藏和显示事件
//- (void)removeKeyBoardNotification
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//}


+ (void)clearTarget {
    
    if (keyBoardUtil != nil) {
        [keyBoardUtil clear];
    }
}

- (void)hideKeyBorad {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)clear {
//    contentView = nil;
//    [self removeKeyBoardNotification];
}


@end
