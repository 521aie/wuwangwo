//
//  GoodsCommentDetailView.h
//  retailapp
//
//  Created by Jianyong Duan on 15/11/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsCommentReportVo.h"
#import "LSRootViewController.h"

#import "EditItemList.h"

@class NavigateTitle2;

@interface GoodsCommentDetailView : LSRootViewController

//input
@property (nonatomic, strong) GoodsCommentReportVo *commentReport;
@end
