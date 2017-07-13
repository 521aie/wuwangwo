//
//  StockQueryView.h
//  retailapp
//
//  Created by guozhi on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@class LogisticService,EditMultiList,GoodsVo,SmallTitle,EditItemView;
@interface ReturnGuideDetail : LSRootViewController  {
    LogisticService *service;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (weak, nonatomic) IBOutlet SmallTitle *styleTitle;
@property (weak, nonatomic) IBOutlet EditItemView *vewCode;
@property (weak, nonatomic) IBOutlet EditItemView *vewName;
@property (weak, nonatomic) IBOutlet EditItemView *vewStart;
@property (weak, nonatomic) IBOutlet EditItemView *vewEnd;
@property (nonatomic, copy) NSString *guideId;
@property (weak, nonatomic) IBOutlet SmallTitle *baseTitle;
@property (weak, nonatomic) IBOutlet UIView *queryBtn;
@end
