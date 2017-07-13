//
//  GoodsAttributeManageEditView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/10/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//


#import "LSRootViewController.h"

@class LSEditItemText;
typedef void(^goodsAttributeManageEditBack) (BOOL flg);
@interface GoodsAttributeManageEditView : LSRootViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *container;

//名称
@property (nonatomic, strong) LSEditItemText *txtName;

@property (nonatomic) int action;

@property (nonatomic, copy) goodsAttributeManageEditBack goodsAttributeManageEditBack;

-(void) loaddatas:(int) fromViewTag callBack:(goodsAttributeManageEditBack) callBack;

@end
