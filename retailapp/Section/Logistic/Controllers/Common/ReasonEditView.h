//
//  ReasonEditView.h
//  retailapp
//
//  Created by hm on 15/8/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

typedef void(^AddCallBack)(void);

@interface ReasonEditView : LSRootViewController



//设置原因code及回调
- (void)loadDataWithCode:(NSString *)dicCode callBack:(AddCallBack)callBack;

@end
