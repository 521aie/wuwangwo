//
//  GoodsAttributeCategoryManageEditView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/11.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@class  AttributeGroupVo, AttributeVo;
@class LSEditItemText;
typedef void(^goodsAttributeCategoryManageEditBack) (AttributeGroupVo* attributeGroupVo, int action);
@interface GoodsAttributeCategoryManageEditView : LSRootViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *container;

//商品属性分类名称
@property (nonatomic, strong) LSEditItemText *txtCategoryName;

@property (nonatomic, strong) UIView *btnDel;

@property (nonatomic) int action;

@property (nonatomic, strong) AttributeGroupVo* attributeGroupVo;

@property (nonatomic, strong) AttributeVo* attributeVo;

@property (nonatomic, copy) goodsAttributeCategoryManageEditBack goodsAttributeCategoryManageEditBack;

-(void) loaddatas:(AttributeGroupVo *) attributeGroupVoTemp attributeVo:(AttributeVo*) attributeVo action:(int) action callBack:(goodsAttributeCategoryManageEditBack) callBack;

@end
