//
//  HomeShowVo.h
//  retailapp
//
//  Created by qingmei on 15/10/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeShowVo : NSObject
/**角色ID*/
@property (nonatomic, strong) NSString *roleId;
/**角色名*/
@property (nonatomic, strong) NSString *roleName;
/**角色类型*/
@property (nonatomic, assign) NSInteger roleType;
/**显示区分vo列表*/
@property (nonatomic, strong) NSArray *showTypeVoList;

+ (HomeShowVo *)convertToUser:(NSDictionary*)dic;

@end
