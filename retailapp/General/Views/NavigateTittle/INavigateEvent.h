//
//  INavigateEvent.h
//  retailapp
//
//  Created by hm on 15/6/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger ,Direct_Flag){
    DIRECT_LEFT = 1,      //左侧
    DIRECT_RIGHT = 2      //右侧
};

@protocol INavigateEvent <NSObject>
@optional
- (void)onNavigateEvent:(Direct_Flag)event;
@end
