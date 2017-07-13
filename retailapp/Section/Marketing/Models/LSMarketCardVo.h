//
//  LSMemberCardVo.h
//  retailapp
//
//  Created by guozhi on 2016/10/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSMarketCardVo : NSObject
/** 会员卡Id */
@property (nonatomic, copy) NSString *kindCardId;
/** 会员卡名称 */
@property (nonatomic, copy) NSString *kindCardName;
/** 是否选中 */
@property (nonatomic, assign) BOOL isSelect;
/** <#注释#> */
@property (nonatomic, assign) BOOL selectStatus;
/** <#注释#> */
@property (nonatomic, copy) NSString *memo;
/** <#注释#> */
@property (nonatomic, assign) double ratio;
/** <#注释#> */
@property (nonatomic, assign) double ratioExchangeDegree;
/** <#注释#> */
@property (nonatomic, assign) BOOL canUpgrade;
/** <#注释#> */
@property (nonatomic, assign) int lastVer;
/** <#注释#> */
@property (nonatomic, assign) int checked;
/** <#注释#> */
@property (nonatomic, assign) int mode;
@end
