//
//  LSHandoverPayTypeVo.h
//  retailapp
//
//  Created by guozhi on 2016/11/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSHandoverPayTypeVo : NSObject
/** <#注释#> */
@property (nonatomic, copy) NSString *kindPayId;
/** <#注释#> */
@property (nonatomic, strong) NSNumber *salesAmount;
/** <#注释#> */
@property (nonatomic, copy) NSString *payMode;
/** 是否计入 */
@property (nonatomic, strong) NSNumber *isInclude;
@end
