//
//  LSOrgInfoController.h
//  retailapp
//
//  Created by wuwangwo on 2017/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "INameValue.h"

typedef void(^HandlerOrgInfo)(id<INameValue> item,NSInteger action);

@interface LSOrgInfoController : LSRootViewController
/**页面显示模式*/
@property (nonatomic,assign) NSInteger action;
/**是否是登录*/
@property (nonatomic) BOOL isLogin;
/**机构id*/
@property (nonatomic,copy) NSString* organizationId;
/**机构名称*/
@property (nonatomic,copy) NSString* organizationName;

/**页面回调block*/
@property (nonatomic,copy) HandlerOrgInfo handlerOrgInfo;
//设置页面回调
- (void)changeOrgInfo:(HandlerOrgInfo)handler;
@end
