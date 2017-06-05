//
//  ITreeNode.h
//  RestApp
//
//  Created by zxh on 14-4-24.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ITreeNode <NSObject>

@required
-(NSString*) obtainItemId;
-(NSString*) obtainItemName;
-(NSString*) obtainParentId;

@optional
-(void) mId:(NSString*)itemId;
-(void) mName:(NSString*)itemName;
-(void) mParentId:(NSString*)parentId;

-(id)copy;

@end
