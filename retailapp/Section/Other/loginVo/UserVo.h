//
//  UserVo.h
//  retailapp
//
//  Created by hm on 15/8/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserVo : NSObject

/**用户ID*/
@property (nonatomic,copy) NSString* userId;
/**角色ID*/
@property (nonatomic,copy) NSString* roleId;
/**用户名*/
@property (nonatomic,copy) NSString* userName;
/**员工号*/
@property (nonatomic,copy) NSString* staffId;
/**角色名*/
@property (nonatomic,copy) NSString* roleName;
/**头像*/
@property (nonatomic,copy) NSString* picture;
/**relevanceEntity放着这个user对应的Organization或者shop的entityId，起到关联作用*/
@property (nonatomic,copy) NSString* relevanceEntity;
/**员工名*/
@property (nonatomic,copy) NSString* name;

+ (UserVo*)convertToUser:(NSDictionary*)dic;
+ (NSMutableArray *)convertToUserList:(NSArray*)arr;

@end
