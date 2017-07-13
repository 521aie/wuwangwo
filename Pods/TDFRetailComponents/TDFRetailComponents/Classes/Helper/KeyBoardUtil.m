//
//  KeyBoardUtil.m
//  CardApp
//
//  Created by 邵建青 on 13-12-23.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import "KeyBoardUtil.h"
#import "KeyBoardBar.h"

#define SPACE_HEIGTHT 10

static KeyBoardUtil *keyBoardUtil;

@implementation KeyBoardUtil

+ (void)initWithTarget:(UITextField *)contentView {
    
    if (keyBoardUtil == nil) {
        keyBoardUtil = [[KeyBoardUtil alloc] init];
        [keyBoardUtil initKeyBoardNotification];
    }
    [keyBoardUtil initTarget:contentView];
}

- (id)init {
    
    self = [super init];
    if(self) {
        keyBoardBar = [[KeyBoardBar alloc]initWithFrame:CGRectMake(0, 0, 320, 32) client:nil];
    }
    return self;
}

- (void)initTarget:(UITextField *)view {
    
    if (view != nil) {
        view.inputAccessoryView = keyBoardBar;
//        [self initKeyBoardNotification];
    }
}

//监听键盘隐藏和显示事件
- (void)initKeyBoardNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (UIResponder *)getFirstResponder {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    UIResponder *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
#pragma clang diagnostic pop
    return firstResponder;
}

//计算当前键盘的高度
-(void)keyboardWillShow:(NSNotification *)notification {
	
    UIResponder *responder = [self getFirstResponder];
    if ([responder isKindOfClass:[UITextView class]] || [responder isKindOfClass:[UITextField class]]) {
       
        UIView *targertView = [self getResponderSuperView:(UIView *)responder];
        if (targertView) {

            NSValue *keyboardEndBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
            CGRect keyboardEndRect;
            [keyboardEndBoundsValue getValue:&keyboardEndRect];
            UIWindow *window = [self getCurrentWindow:responder];
            CGRect convertFrame = [window convertRect:[(UIView *)responder frame] fromView:[(UIView *)responder superview]];
            
            if (CGRectGetMinY(keyboardEndRect) < CGRectGetMaxY(convertFrame)) {
                
                dValue += CGRectGetMinY(keyboardEndRect) - CGRectGetMaxY(convertFrame);
                
                if ([targertView isKindOfClass:[UIScrollView class]]) {
                    
                    UIScrollView *view = (UIScrollView *)targertView;
                    view.contentOffset = CGPointMake(view.contentOffset.x, view.contentOffset.y-dValue);
                }
                else if (fabs(dValue) > 0) {
                    [UIView animateWithDuration:0.25 animations:^{
                        UIView *targertView = [self getResponderSuperView:(UIView *)responder];
                        targertView.transform = CGAffineTransformMakeTranslation(0, dValue);
                    }];
                }
            }
        }
    }
}


-(void)keyboardWillHide:(NSNotification *)notification {
    
    UIResponder *responder = [self getFirstResponder];
    if ([responder isKindOfClass:[UITextView class]] || [responder isKindOfClass:[UITextField class]]) {
        
        UIView *targertView = [self getResponderSuperView:(UIView *)responder];
        if (targertView) {
            
            if ([targertView isKindOfClass:[UIScrollView class]]) {
                UIScrollView *view = (UIScrollView *)targertView;
                view.contentOffset = CGPointMake(view.contentOffset.x, view.contentOffset.y+dValue);
            }
            else if (fabs(dValue)>0) {
                [UIView animateWithDuration:0.25 animations:^{
                    
                    if (targertView) {
                        targertView.transform = CGAffineTransformIdentity;
                    }
                }];
            }
        }
    }
    
    dValue = 0;
}


- (UIView *)getResponderSuperView:(UIView *)responder {
    
    
    for (UIView *view = responder; view; view = view.superview) {
        
        NSString *viewClass = NSStringFromClass([view class]);
        if ([viewClass isEqualToString:@"UIScrollView"] || [viewClass isEqualToString:@"UITableView"] || [viewClass isEqualToString:@"UICollectionView"]) {
            return view;
        }
        
        if ([[view nextResponder] isKindOfClass:[UIViewController class]]) {
            return view;
        }
    }
    return nil;
}


- (UIWindow *)getCurrentWindow:(UIResponder *)responder {
    
    for (UIResponder *nextResponder = responder; nextResponder; nextResponder = nextResponder.nextResponder) {
        if ([nextResponder isKindOfClass:[UIWindow class]]) {
            return (UIWindow *)nextResponder;
        }
    }
    return nil;
}


//输入框上移防止键盘遮挡
//- (void)animateNormalView:(BOOL)isShow textInput:(id)textInput heightforkeyboard:(CGFloat)kheight
//{
//	keyBoardHeight = kheight;
//	CGRect rect = contentView.frame;
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:0.3];
//	if (isShow) {
//		if ([textInput isKindOfClass:[UITextField class]]) {
//			UITextField *newText = ((UITextField *)textInput);
//			CGPoint textPoint = [newText convertPoint:CGPointMake(0, newText.frame.size.height + SPACE_HEIGTHT) toView:contentView];
//			if (rect.size.height - textPoint.y < kheight) {
//				rect.origin.y = rect.size.height - textPoint.y - kheight + originY;
//            } else {
//                rect.origin.y = originY;
//            }
//		} else {
//			UITextView *newView = ((UITextView *)textInput);
//			CGPoint textPoint = [newView convertPoint:CGPointMake(0, newView.frame.size.height + SPACE_HEIGTHT) toView:contentView];
//			if (rect.size.height - textPoint.y < kheight) {
//				rect.origin.y = rect.size.height - textPoint.y - kheight + originY;
//            } else {
//                rect.origin.y = originY;
//            }
//		}
//	} else {
//        rect.origin.y = originY;
//    }
//	contentView.frame = rect;
//	[UIView commitAnimations];
//}

//- (void)animateScrollView:(BOOL)isShow textInput:(id)textInput heightforkeyboard:(CGFloat)kheight
//{
//    keyBoardHeight = kheight;
//    CGPoint point = scrollView.contentOffset;
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:0.3];
//	if (isShow) {
//        originY = point.y;
//		if ([textInput isKindOfClass:[UITextField class]]) {
//			UITextField *newText = ((UITextField *)textInput);
//			CGPoint textPoint = [newText convertPoint:CGPointMake(0, newText.frame.size.height + SPACE_HEIGTHT) toView:contentView];
//			if (point.y - textPoint.y < kheight) {
//				point.y = textPoint.y - kheight;
//            } else {
//                point.y = originY;
//            }
//		} else {
//			UITextView *newView = ((UITextView *)textInput);
//			CGPoint textPoint = [newView convertPoint:CGPointMake(0, newView.frame.size.height + SPACE_HEIGTHT) toView:contentView];
//			if (point.y - textPoint.y < kheight) {
//				point.y = textPoint.y - kheight;
//            } else {
//                point.y = originY;
//            }
//		}
//	} else {
//        point.y = originY;
//    }
//	scrollView.contentOffset = point;
//	[UIView commitAnimations];
//}

//输入框获得焦点
//- (id)firstResponder:(UIView *)navView
//{
//	for (id aview in subViews) {
//		if ([aview isKindOfClass:[UITextField class]] && [(UITextField *)aview isFirstResponder]) {
//			return (UITextField *)aview;
//		} else if ([aview isKindOfClass:[UITextView class]] && [(UITextView *)aview isFirstResponder]) {
//			return (UITextView *)aview;
//		}
//	}
//	return nil;
//}

//找出所有的subview
//- (NSArray *)allSubviews:(UIView *)theView
//{
//	NSArray *results = [theView subviews];
//	for (UIView *eachView in [theView subviews]) {
//		NSArray *riz = [self allSubviews:eachView];
//		if (riz) {
//			results = [results arrayByAddingObjectsFromArray:riz];
//		}
//	}
//	return results;
//}

+ (void)clearTarget
{
    if (keyBoardUtil != nil) {
        [keyBoardUtil clear];
    }
}

- (void)hideKeyBorad
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)clear
{
//    contentView = nil;
    [self removeKeyBoardNotification];
}

//监听键盘隐藏和显示事件
- (void)removeKeyBoardNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
