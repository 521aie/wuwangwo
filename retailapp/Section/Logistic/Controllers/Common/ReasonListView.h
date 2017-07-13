//
//  ReasonListView.h
//  retailapp
//
//  Created by hm on 15/8/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

typedef void(^ReasonHangler)(NSMutableArray *reasonList);

@interface ReasonListView : LSRootViewController


//设置页面参数及回调block
- (void)loadDataWithCode:(NSString*)dicCode titleName:(NSString *)titleName CallBack:(ReasonHangler)handler;

@end
