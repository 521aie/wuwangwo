//
//  TreeNodeUtils.h
//  RestApp
//
//  Created by zxh on 14-4-25.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TreeNode,TreeItem;
@interface TreeNodeUtils : NSObject

+(NSString*) getParentName:(TreeNode*)node dic:(NSMutableDictionary*)dic isSelf:(BOOL)isSelf;

//把KindMenuList转换成节点字典项.
+(NSMutableDictionary*) convertNodeDic:(NSMutableArray*)sources;

//把所有节点扁平化.
+(NSMutableArray*) convertAllNode:(NSMutableArray*)sources;

//转换成末级分类的集合.
+(NSMutableArray*) convertEndNode:(NSMutableArray*)sources;

//转换多级的末级分类集合（点代表上级类）.
+(NSMutableArray*) convertDotEndNode:(NSMutableArray*)sources level:(int)level showAll:(BOOL) showAll;

//转换多级的末级分类集合(全路径).
+(NSMutableArray*) convertMultiEndNode:(NSMutableArray*)souces level:(int)level showAll:(BOOL) showAll;

//得到第一个根节点.
+(TreeNode*) getFirstRootKind:(NSMutableArray*)treeNodes;

+(NSMutableArray*)converToTreeItemArr:(NSArray*)arr;

@end
