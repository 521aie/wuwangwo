//
//  PerformanceExportVo.h
//  retailapp
//
//  Created by qingmei on 15/10/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PerformanceExportVo : NSObject
/**<#注释#>*/
@property (nonatomic, strong) NSString *shopId;
/**<#注释#>*/
@property (nonatomic, strong) NSString *shopName;
/**<#注释#>*/
@property (nonatomic, strong) NSString *shopCode;
/**<#注释#>*/
@property (nonatomic, assign) NSInteger targetMonth;
/**<#注释#>*/
@property (nonatomic, strong) NSString *userId;

/**<#注释#>*/
@property (nonatomic, strong) NSString *userName;
/**<#注释#>*/
@property (nonatomic, strong) NSString *mobile;
/**<#注释#>*/
@property (nonatomic, strong) NSString *staffId;
/**<#注释#>*/
@property (nonatomic, strong) NSString *totalTarget;
/**<#注释#>*/
@property (nonatomic, strong) NSArray *performanceDetailVoList;
@end
