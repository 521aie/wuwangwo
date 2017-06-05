//
//  KindPayEditView.h
//  retailapp
//
//  Created by 果汁 on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@class LSEditItemText,NavigateTitle2,SettingService;

@interface GuestNoteEditView : LSRootViewController
{
    SettingService *service;//网络请求
}
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *container;

@property (strong, nonatomic) LSEditItemText *txtMeno;

@end
