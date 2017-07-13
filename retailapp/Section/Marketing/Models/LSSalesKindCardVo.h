//
//  LSSalesKindCardVo.h
//  retailapp
//
//  Created by guozhi on 2016/10/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSSalesKindCardVo : NSObject

@property (nonatomic, copy) NSString *kindCardId;/** 会员卡Id */
@property (nonatomic, assign) BOOL selectStatus;/** <#注释#> */
@property (nonatomic, copy) NSString *memo; /** 备注 */
@property (nonatomic, assign) double ratio;/** 默认折扣率: 浮点型 */
@property (nonatomic, copy) NSString *kindCardName;/** 会员卡名称 */
@property (nonatomic, assign) double ratioExchangeDegree;/** <#注释#> */
@property (nonatomic, assign) BOOL canUpgrade;/** 是否可以升级 */
@property (nonatomic, assign) int lastVer;/** <#注释#> */
@property (nonatomic, assign) int checked;/** <#注释#> */
@property (nonatomic, assign) int mode;/** <#注释#> */
@end
