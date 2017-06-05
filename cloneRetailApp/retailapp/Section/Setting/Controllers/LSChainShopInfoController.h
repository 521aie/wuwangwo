//
//  LSChainShopInfoController.h
//  retailapp
//
//  Created by wuwangwo on 2017/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "INameValue.h"

typedef void(^HandlerChainInfo)(id<INameValue> item,NSInteger action);

@interface LSChainShopInfoController : LSRootViewController
/**页面模式参数*/
@property (nonatomic,assign) NSInteger action;
/**门店登录时YES  否则NO*/
@property (nonatomic) BOOL isLogin;
/**门店id*/
@property (nonatomic,copy) NSString* shopId;
/** <#注释#> */
@property (nonatomic, copy) NSString *shopEntityId;
/**上级机构id*/
@property (nonatomic,copy) NSString* superOrgId;
/**上级机构名称*/
@property (nonatomic,copy) NSString* superOrgName;

/**回调block*/
@property (nonatomic,copy) HandlerChainInfo handlerChainInfo;
//设置回调block
- (void)changChainInfo:(HandlerChainInfo)handler;
@end
