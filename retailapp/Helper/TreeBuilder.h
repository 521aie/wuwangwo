//
//  TreeBuilder.h
//  RestApp
//
//  Created by zxh on 14-4-24.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeBuilder : NSObject

+(NSMutableArray*) buildTree:(NSMutableArray*)sourceList;

+(NSMutableArray*) buildTreeItem:(NSMutableArray*)sourceList;

@end
