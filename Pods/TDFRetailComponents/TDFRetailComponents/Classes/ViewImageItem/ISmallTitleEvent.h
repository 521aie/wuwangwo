//
//  ISmallTitleEvent.h
//  RestApp
//
//  Created by hm on 15/1/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ISmallTitleEvent <NSObject>

@optional
- (void)onTitleExpandClick:(NSInteger)event;
- (void)onTitleMoveToBottomClick:(NSInteger)event;


@end
