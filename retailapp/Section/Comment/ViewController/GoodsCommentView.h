//
//  GoodsCommentView.h
//  retailapp
//
//  Created by Jianyong Duan on 15/11/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSRootViewController.h"

#import "NavigateTitle2.h"
#import "SearchBar.h"
#import "SearchBar2.h"
#import "EditItemList.h"

@interface GoodsCommentView : LSRootViewController

@property (nonatomic) NSInteger type;

-(instancetype)initWithType:(NSInteger)type;
@end
