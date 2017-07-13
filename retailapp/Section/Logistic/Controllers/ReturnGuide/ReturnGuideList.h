//
//  StockQueryView.h
//  retailapp
//
//  Created by guozhi on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "ReturnGuideSelectView.h"
#import "SearchBar2.h"

@class SearchBar,StockService,SearchBar2,LogisticService;
@interface ReturnGuideList : LSRootViewController <SelectViewDelegeate,ISearchBarEvent,UITableViewDataSource,UITableViewDelegate> {
   LogisticService *service;
}

@property (nonatomic, strong) ReturnGuideSelectView *selectView;
@property (weak, nonatomic) IBOutlet SearchBar2 *searchBar;

@property (nonatomic, strong) NSMutableArray *datas;
@property (weak, nonatomic) IBOutlet UITableView *mainGrid;
@property (nonatomic, assign) NSInteger shopMode;
@property (nonatomic, strong) NSNumber *lastDateTime;
@property (nonatomic, strong) NSMutableDictionary *param;
/**是否点击了完成按钮*/
@property (nonatomic, assign) BOOL isClicked;
@end
