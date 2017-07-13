//
//  TreeItem.h
//  retailapp
//
//  Created by hm on 15/8/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITreeItem.h"

@interface TreeItem : NSObject<ITreeItem>

@property (nonatomic,retain)  NSString * itemId;
@property (nonatomic,retain)  NSString * itemName;
@property (nonatomic,retain)  NSString * itemVal;
@property (nonatomic,retain)  NSString * parentId;
@property (nonatomic,retain)  NSString * parentCode;
/** <#注释#> */
@property (nonatomic, copy) NSString *entityId;
/** 2 门店  0机构 */
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger joinMode;
@property (nonatomic) NSInteger level;
@property (nonatomic, retain) NSMutableArray *subItems;
@property (nonatomic) BOOL checkVal;
//isSubItemOpen来标记子菜单是否被打开
@property (nonatomic) BOOL isSubItemOpen;
//sCascadeOpen标记该子菜单是否要在其父菜单展开时自动展开
@property (nonatomic) BOOL isSubCascadeOpen;

@property (nonatomic,assign) id<ITreeItem>orign;

- (id)initWith:(id<ITreeItem>)orgin;

- (void)addChild:(TreeItem*) item;

- (BOOL)isRoot;
@end
