//
//  LSSegmentedView.h
//  retailapp
//
//  Created by taihangju on 16/10/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SegmentSelectedBlock)(NSInteger index);
@interface LSSegmentedView : UIView

+ (LSSegmentedView *)segmentedView:(SegmentSelectedBlock)block;

- (void)setLeftButtonTitle:(NSString *)title1 rightButtonTitle:(NSString *)title2;
@end
