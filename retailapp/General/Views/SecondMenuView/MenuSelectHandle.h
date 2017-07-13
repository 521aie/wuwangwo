//
//  MenuSelectHandle.h
//  RestApp
//
//  Created by zxh on 14-3-24.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIMenuAction.h"
@protocol MenuSelectHandle <NSObject>

@required
-(void) onMenuSelectHandle:(UIMenuAction *)action;
-(void) backMenu;

@optional
-(NSMutableArray*) createList;

@end
