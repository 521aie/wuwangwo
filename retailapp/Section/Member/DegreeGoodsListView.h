//
//  DegreeGoodsView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISearchBarEvent.h"
#import "FooterListEvent.h"
#import "GoodsGiftVo.h"
#import "NavigateTitle2.h"

@class NavigateTitle2, SearchBar3, PaperFooterListView;
@class MemberModule;
@interface DegreeGoodsListView : BaseViewController<FooterListEvent,INavigateEvent,ISearchBarEvent,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic) NavigateTitle2 *titleBox;
@property (nonatomic, weak) IBOutlet UITableView *mainGrid;

@property (nonatomic, weak) IBOutlet SearchBar3 *searchBar3;

@property (nonatomic, weak) IBOutlet PaperFooterListView *footView;

@property (nonatomic, retain) NSMutableArray *datas;

@property (nonatomic, retain) NSString *searchCode;

@property (nonatomic, retain) NSString *searchType;

@property (nonatomic, strong) GoodsGiftVo *goodsGiftVo;

@property (nonatomic) int action;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

-(void) loaddatas;

@end
