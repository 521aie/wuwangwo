//
//  SalePackStyleListView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/11/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISearchBarEvent.h"
#import "FooterListEvent.h"
#import "INameValueItem.h"
#import "NavigateTitle2.h"

@class GoodsModule,GoodsFooterListView,NavigateTitle2, SearchBar2, EditItemList, StyleVo;

@interface SalePackStyleListView : BaseViewController<FooterListEvent, INavigateEvent, ISearchBarEvent,  UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
{
    GoodsModule *parent;
}


@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic) NavigateTitle2 *titleBox;
@property (nonatomic, weak) IBOutlet UITableView *mainGrid;

@property (nonatomic, weak) IBOutlet SearchBar2 *searchBar;

@property (nonatomic, weak) IBOutlet GoodsFooterListView *footView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil salePackId:(NSString*) salePackId lastVer:(NSString*) lastVer;

-(void) loadDatasFromEditView:(StyleVo*) styleVo action:(int)action;

-(void) loaddatas;

-(void) loadDatasFromBatchViewOrEditView:(NSString*) viewTag;

-(void) loadDatasFromAddView;

@end
