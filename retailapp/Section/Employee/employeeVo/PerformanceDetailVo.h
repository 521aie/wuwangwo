//
//  PerformanceDetailVo.h
//  retailapp
//
//  Created by qingmei on 15/10/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PerformanceDetailVo : NSObject
/**<#注释#>*/
@property (nonatomic, assign) NSInteger performanceId;
/**<#注释#>*/
@property (nonatomic, assign) NSInteger startDate;
/**<#注释#>*/
@property (nonatomic, assign) NSInteger endDate;
/**<#注释#>*/
@property (nonatomic, strong) NSString *saleTargetDay;
/**<#注释#>*/
@property (nonatomic, assign) NSInteger collectType;
/**<#注释#>*/
@property (nonatomic, assign) NSInteger lastVer;

+ (PerformanceDetailVo*)convertToUser:(NSDictionary*)dic;

- (NSMutableDictionary *)getDic:(PerformanceDetailVo *)performanceDetailVo;
@end
