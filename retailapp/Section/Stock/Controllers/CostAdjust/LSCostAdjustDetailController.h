//
//  LSCostAdjustDetailController.h
//  retailapp
//
//  Created by hm on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "INameCode.h"
@class LSCostAdjustVo;
typedef void(^CallBlock)(LSCostAdjustVo* item, NSInteger action);

@interface LSCostAdjustDetailController : LSRootViewController
/**是否有确认调整权限*/
@property (nonatomic,assign) BOOL hasCostAdjust;
/**页面显示模式*/
@property (nonatomic,assign) NSInteger action;
/** <#注释#> */
@property (nonatomic, strong) LSCostAdjustVo *costAdjustVo;
- (instancetype)initWithAction:(int)action costAdjustVo:(LSCostAdjustVo *)costAdjustVo hasCostAdjust:(BOOL)hasCostAdjust CallBlock:(CallBlock)callBlock;


@end
