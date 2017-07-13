//
//  LSMemberMeterViewController.h
//  retailapp
//
//  Created by wuwangwo on 2017/3/28.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface LSMemberMeterViewController : LSRootViewController

/** 当前页 */
@property (nonatomic, strong) NSNumber *lastDateTime;
@property (nonatomic, strong) NSMutableDictionary *param;
- (void)loadData;
@end
