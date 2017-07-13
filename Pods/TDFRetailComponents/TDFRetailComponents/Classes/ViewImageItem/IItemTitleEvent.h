//
//  IItemTitleEvent.h
//  RestApp
//
//  Created by zxh on 14-7-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IItemTitleEvent <NSObject>
@optional
-(void) onTitleAddClick:(NSInteger)event;
-(void) onTitleSortClick:(NSInteger)event;
@end
