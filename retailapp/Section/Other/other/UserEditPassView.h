//
//  UserEditPassView.h
//  retailapp
//
//  Created by hm on 15/8/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//


#import "LSRootViewController.h"

typedef void(^CallBack)();

@interface UserEditPassView : LSRootViewController



//设置页面参数及回调
- (void)loadData:(NSString*)userId userName:(NSString*)userName callBack:(CallBack)callBack;

@end
