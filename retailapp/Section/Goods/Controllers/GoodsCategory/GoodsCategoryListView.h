//
//  GoodsCategoryListView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/27.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@class CategoryVo;
typedef void(^goodsCategoryListBack) (int fromViewTag);
@interface GoodsCategoryListView : LSRootViewController

@property (nonatomic, strong) NSMutableArray* parentCategoryList;

@property (nonatomic, strong) goodsCategoryListBack goodsCategoryListBack;

- (instancetype)initWithTag:(int)fromViewTag;

- (void) loadData:(int)action goodsCategory:(CategoryVo*) goodsCategory;

- (void)loadDatasFromStyleEditView:(goodsCategoryListBack) callBack;

// 点击返回按钮
- (void)loadDataFromEditViewOfReturn;

@end
