//
//  IMenuDataItem.h
//  RestApp
//
//  Created by 邵建青 on 14-12-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMenuDataItem <NSObject>

@required
- (NSString *)obtainMenuId;

@end
