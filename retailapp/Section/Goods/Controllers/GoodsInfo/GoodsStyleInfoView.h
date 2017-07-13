//
//  GoodsStyleInfoView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/10/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "ISearchBarEvent.h"
#import "IEditItemListEvent.h"
#import "StyleTopSelectView.h"
#import "LSFooterView.h"
@class  SearchBar2, LSEditItemList, StyleTopSelectView;
@interface GoodsStyleInfoView : LSRootViewController<LSFooterViewDelegate, ISearchBarEvent, IEditItemListEvent, StyleTopSelectViewDelegate>

@property (nonatomic, strong) SearchBar2 *searchBar;

@property (nonatomic, strong) LSFooterView *footView;

@property (nonatomic, strong) UIView *container;

//门店
@property (nonatomic, strong) LSEditItemList *lsShopName;
/** <#注释#> */
@property (nonatomic, strong) LSEditItemList *lstTotalNum;

//款式筛选页面
@property (nonatomic, strong) StyleTopSelectView *styleTopSelectView;

-(void) loadDatasFromEdit;

-(void) selectStyleCount;

@end
