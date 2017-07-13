//
//  LSByTimeServiceListController.h
//  retailapp
//
//  Created by taihangju on 2017/4/5.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger ,LSByTimeServiceType) {
    LSByTimeServiceNotExpired,  // 查看未过期的计次服务
    LSByTimeServiceExpired      // 查看已过期的计次服务
};

@interface LSByTimeServiceListController : BaseViewController

- (instancetype)initWithListType:(LSByTimeServiceType)type cardId:(NSString *)cardId;
@end
