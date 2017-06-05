//
//  LevelDescriptionView.h
//  retailapp
//
//  Created by Jianyong Duan on 15/11/12.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSRootViewController.h"

#import "NavigateTitle2.h"

@interface LevelDescriptionView : LSRootViewController

@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
