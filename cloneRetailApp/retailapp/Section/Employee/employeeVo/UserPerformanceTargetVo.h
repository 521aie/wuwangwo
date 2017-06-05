//
//  UserPerformanceTargetVo.h
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPerformanceTargetVo : NSObject

/**商户ID*/
@property (nonatomic, strong) NSString *shopId;
/**员工ID*/
@property (nonatomic, strong) NSString *userId;
/**员工姓名*/
@property (nonatomic, strong) NSString *name;
/**手机号码*/
@property (nonatomic, strong) NSString *mobile;
/**工号*/
@property (nonatomic, strong) NSString *staffId;
/**员工图片*/
@property (nonatomic, strong) NSString *filePath;
/**业绩总目标*/
@property (nonatomic, strong) NSString *totalTarget;
/**性别*/
@property (nonatomic, assign) NSInteger sex;

+ (UserPerformanceTargetVo*)convertToUser:(NSDictionary*)dic;

@end
