//
//  SubOrgVo.h
//  retailapp
//
//  Created by hm on 15/8/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITreeItem.h"

@interface SubOrgVo : NSObject<ITreeItem>
@property (nonatomic,copy) NSString* _id;
@property (nonatomic,copy) NSString* code;
@property (nonatomic,copy) NSString* name;
@property (nonatomic,copy) NSString* entityId;
@property (nonatomic,copy) NSString* hierarchyCode;
@property (nonatomic,copy) NSString* mobile;
@property (nonatomic,copy) NSString* parentId;
@property (nonatomic) NSInteger joinMode;
/**0 公司 1部门 2门店*/
@property (nonatomic) NSInteger type;
@property (nonatomic) BOOL checkVal;
+ (SubOrgVo*)converToSubOrg:(NSDictionary*)dic;
+ (NSMutableArray*)converToSubOrgList:(NSArray*)array;
@end
