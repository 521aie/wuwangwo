//
//  SalesStyleAreaView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/11/12.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISearchBarEvent.h"
#import "FooterListEvent.h"
#import "INameValueItem.h"
#import "ISampleListEvent.h"
#import "NavigateTitle2.h"

@class GoodsModule,GoodsFooterListView,NavigateTitle2, SearchBar2, EditItemList, StyleVo;
@interface SalesStyleAreaView : BaseViewController<FooterListEvent, INavigateEvent, ISearchBarEvent, ISampleListEvent, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
{
    GoodsModule *parent;
}

@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic) NavigateTitle2 *titleBox;
@property (nonatomic, weak) IBOutlet UITableView *mainGrid;

@property (nonatomic, weak) IBOutlet SearchBar2 *searchBar;

@property (nonatomic, weak) IBOutlet GoodsFooterListView *footView;

@property (nonatomic,strong) NSString* operateMode;

@property (nonatomic,strong) NSString* titleName;

@property (nonatomic, strong) NSString* isCanDeal;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil discountId:(NSString*) discountId discountType:(NSString*) discountType shopId:(NSString*) shopId action:(int) action;

// 从”选择条件添加“页面返回
-(void) loadDatasFromAddByConditionView;

// 从批量页面返回
-(void) loadDatasFromBatchOperateView;

@end
