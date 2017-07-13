//
//  MainPageSortView.h
//  retailapp
//
//  Created by qingmei on 15/10/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@class HomeShowVo;
@interface MainPageDetailView : LSRootViewController

@property (nonatomic, strong) HomeShowVo *homeShowVo;

//通过HomeShowVo加载页面
- (void)loadByhomeShowVo:(HomeShowVo *)homeShowVo;

@end
