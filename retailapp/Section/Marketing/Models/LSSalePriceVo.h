//
//  LSSalePriceVo.h
//  retailapp
//
//  Created by guozhi on 2016/10/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSSalePriceVo : NSObject
/** <#注释#> */
@property (nonatomic, copy) NSString *id;
/** <#注释#> */
@property (nonatomic, copy) NSString *salesId;
/** <#注释#> */
@property (nonatomic, assign) int goodsScope;
/** <#注释#> */
@property (nonatomic, copy) NSString *name;
/** <#注释#> */
@property (nonatomic, assign) int saleSchema;
/** <#注释#> */
@property (nonatomic, assign) double discountPriceRate;
/** <#注释#> */
@property (nonatomic, assign) int lastVer;
/** <#注释#> */
@property (nonatomic, copy) NSString *opUserId;
@end
