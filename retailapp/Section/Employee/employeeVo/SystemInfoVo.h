//
//  SystemInfoVo.h
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemInfoVo : NSObject

/**系统信息ID*/
@property (nonatomic, assign) NSInteger systemInfoId;       //系统信息ID
/**系统信息名*/
@property (nonatomic, strong) NSString *systemName;         //系统信息名
/**系统CODE*/
@property (nonatomic, strong) NSString *systemCode;         //系统CODE
/**系统分类*/
@property (nonatomic, strong) NSString *systemType;         //系统分类
/**分类ID*/
@property (nonatomic, assign) NSInteger businessid;         //分类ID
/**模块voList*/
@property (nonatomic, strong) NSMutableArray *moduleVoList;        //模块voList

+ (SystemInfoVo *)convertToUser:(NSDictionary*)dic;
@end
