//
//  MultiCheckHandle.h
//  RestApp
//
//  Created by zxh on 14-4-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MultiCheckHandle <NSObject>

- (void)multiCheck:(NSInteger)event items:(NSMutableArray*)items;

- (void)closeMultiView:(NSInteger)event;

@end
