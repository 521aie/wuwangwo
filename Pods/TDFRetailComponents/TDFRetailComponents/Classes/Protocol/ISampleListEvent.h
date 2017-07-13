//
//  ISampleListEvent.h
//  RestApp
//
//  Created by zxh on 14-4-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameValueItem.h"
#import "INameItem.h"

@protocol ISampleListEvent <NSObject>

@optional
- (void)closeListEvent:(NSString*)event;

- (void)confirmListEvent:(NSString*)event;

- (void)showAddEvent:(NSString*)event obj:(id)obj;

- (void)showAddEvent:(NSString*)event;

- (void)delEvent:(NSString*)event ids:(NSMutableArray*) ids;

- (void)delObjEvent:(NSString*)event obj:(id) obj;

- (void)batchDelEvent:(NSString*)event ids:(NSMutableArray*)ids;

- (void)sortEvent:(NSString*)event ids:(NSMutableArray*)ids;

- (void)showHelpEvent:(NSString*)event;


-(void) showEditObjId:(NSString*)objId event:(NSString*)event;

//编辑键值对对象的Obj
- (void)showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj;

//编辑只有名字的Obj
- (void)showEditNItemEvent:(NSString*)event withObj:(id<INameItem>)obj;

//-------------供应链新增-------------------------------------
- (void)showTitleEvent:(NSString*)event withFlag:(int)flag;
-(void) showExportEvent:(NSString*)event;

@end
