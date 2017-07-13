//
//  GoodsCategoryEditView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/27.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@class CategoryVo;
typedef void(^goodsCategoryEditBack) (CategoryVo* categoryVo, int action, BOOL flg);
@interface GoodsCategoryEditView : LSRootViewController

@property (nonatomic) int action;
@property (nonatomic, strong) CategoryVo *categoryVo;
@property (nonatomic, strong) NSMutableArray* parentCategoryList;
@property (nonatomic) int fromViewTag;

@property (nonatomic, copy) goodsCategoryEditBack goodsCategoryEditBack;
-(void) loaddatas:(goodsCategoryEditBack) callBack;
@end
