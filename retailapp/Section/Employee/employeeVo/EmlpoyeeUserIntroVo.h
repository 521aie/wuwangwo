//
//  EmlpoyeeUserIntroVo.h
//  retailapp
//
//  Created by qingmei on 15/10/14.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmlpoyeeUserIntroVo : NSObject
/**用户ID*/
@property (nonatomic, strong) NSString *userId;
/**姓名*/
@property (nonatomic, strong) NSString *name;
/**工号*/
@property (nonatomic, strong) NSString *staffId;
/**手机号*/
@property (nonatomic, strong) NSString *mobile;
/**角色名*/
@property (nonatomic, strong) NSString *roleName;
/**头像url*/
@property (nonatomic, strong) NSString *fileName;
/**性别*/
@property (nonatomic, assign) NSInteger sex;

+ (EmlpoyeeUserIntroVo*)convertToUser:(NSDictionary*)dic;
- (NSMutableDictionary *)getDic:(EmlpoyeeUserIntroVo *)emlpoyeeUserIntroVo;

@end
