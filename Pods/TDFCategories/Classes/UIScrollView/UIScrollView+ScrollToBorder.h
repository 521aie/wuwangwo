//
//  UIScrollView+ScrollToBorder.h
//  Pods
//
//  Created by tripleCC on 11/2/16.
//
//

#import <UIKit/UIKit.h>

@interface UIScrollView (ScrollToBorder)
//===============================================
//             滚动至四个边界
//===============================================
- (void)tdf_scrollToTop;
- (void)tdf_scrollToBottom;
- (void)tdf_scrollToLeft;
- (void)tdf_scrollToRight;
- (void)tdf_scrollToTopAnimated:(BOOL)animated;
- (void)tdf_scrollToBottomAnimated:(BOOL)animated;
- (void)tdf_scrollToLeftAnimated:(BOOL)animated;
- (void)tdf_scrollToRightAnimated:(BOOL)animated;
@end
