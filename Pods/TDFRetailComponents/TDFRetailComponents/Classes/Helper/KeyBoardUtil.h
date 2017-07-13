//
//  KeyBoardUtil.h
//  CardApp
//
//  Created by 邵建青 on 13-12-23.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyBoardBar.h"

@interface KeyBoardUtil : NSObject<KeyBoardBarClient>
{
//    UIView *contentView;
//    
//    UIScrollView *scrollView;
    
    KeyBoardBar *keyBoardBar;
    
//    NSArray *subViews;
//    
//    CGRect keyBoardBounds;
//    
//    CGFloat originY;
//    
//    CGFloat keyBoardHeight;
    CGFloat dValue;
}

+ (void)initWithTarget:(UIView *)contentView;

+ (void)clearTarget;

@end
