//
//  SmsDetailController.h
//  retailapp
//
//  Created by wuwangwo on 2017/2/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
@class Notice;

@interface SmsDetailController : LSRootViewController
/**消息Id*/
@property (nonatomic, strong) NSString *noticeId;
/**状态 ACTION_CONSTANTS_EDIT 编辑  ACTION_CONSTANTS_ADD 添加*/
@property (nonatomic, assign) NSInteger action;
/**保存时的消息对象*/
@property (nonatomic,strong) Notice *notice;
@end
