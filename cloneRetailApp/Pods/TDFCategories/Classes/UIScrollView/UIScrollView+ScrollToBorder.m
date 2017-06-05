//
//  UIScrollView+ScrollToBorder.m
//  Pods
//
//  Created by tripleCC on 11/2/16.
//
//

#import "UIScrollView+ScrollToBorder.h"

@implementation UIScrollView (ScrollToBorder)
- (void)tdf_scrollToTop {
    [self tdf_scrollToTopAnimated:YES];
}

- (void)tdf_scrollToBottom {
    [self tdf_scrollToBottomAnimated:YES];
}

- (void)tdf_scrollToLeft {
    [self tdf_scrollToLeftAnimated:YES];
}

- (void)tdf_scrollToRight {
    [self tdf_scrollToRightAnimated:YES];
}

- (void)tdf_scrollToTopAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = MAX(0, 0 - self.contentInset.top);
    [self setContentOffset:off animated:animated];
}

- (void)tdf_scrollToBottomAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y =  MAX(0, self.contentSize.height - self.bounds.size.height + self.contentInset.bottom);
    [self setContentOffset:off animated:animated];
}

- (void)tdf_scrollToLeftAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = MAX(0, 0 - self.contentInset.left);
    [self setContentOffset:off animated:animated];
}

- (void)tdf_scrollToRightAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = MAX(0, self.contentSize.width - self.bounds.size.width + self.contentInset.right);
    [self setContentOffset:off animated:animated];
}
@end
