//
//  LSMemberMeterCardListController.h
//  retailapp
//
//  Created by wuwangwo on 2017/4/1.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface LSMemberMeterCardListController : LSRootViewController

@property (nonatomic, strong) NSMutableDictionary *param;
/**导出页面所需要的参数*/
@property (nonatomic, strong) NSMutableDictionary *exportParam;
@end
