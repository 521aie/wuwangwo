//
//  GoodsSalePackManageListView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISearchBarEvent.h"
#import "FooterListEvent.h"
#import "INameValueItem.h"
#import "ISampleListEvent.h"
#import "NavigateTitle2.h"

@class GoodsModule,FooterListView2,NavigateTitle2, SearchBar2, EditItemList, SalePackVo;
typedef void(^CallBack)(NSString*str);
@interface ThemeRecommendedStyleViewController : BaseViewController<FooterListEvent, INavigateEvent, ISearchBarEvent, ISampleListEvent, UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate>


@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic) NavigateTitle2 *titleBox;

@property (nonatomic, weak) IBOutlet UITableView *mainGrid;

@property (nonatomic, weak) IBOutlet SearchBar2 *searchBar;

@property (nonatomic, strong) CallBack callBack;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

-(void) loaddatas;

-(void) loaddatasFromEdit:(int) action salePackVo:(SalePackVo*) salePackVo;



@end
