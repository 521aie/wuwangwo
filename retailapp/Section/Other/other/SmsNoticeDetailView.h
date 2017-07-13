//
//  SmsNoticeDetailView.h
//  retailapp
//
//  Created by hm on 15/9/7.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

typedef void(^DetailHandler)(void);
@interface SmsNoticeDetailView : LSRootViewController

- (void)loadDataWithId:(NSString *)noticeId callBack:(DetailHandler)handler;
@end
