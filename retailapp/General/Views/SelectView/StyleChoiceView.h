//
//  StyleChoiceView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/10/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "LSFooterView.h"
#import "ISearchBarEvent.h"
#import "StyleTopSelectView.h"
#import "NavigateTitle2.h"

//款式选择页面（包含单选和批量选择）
typedef void(^StyleChoiceViewSelectBack1)(NSMutableArray* styleList);
typedef void(^StyleChoiceViewSelectBack)(NSMutableArray* styleList);
@class GoodsModule,NavigateTitle2, SearchBar2, KindMenuView, StyleBatchChoiceView, StyleChoiceTopView;
@interface StyleChoiceView : LSRootViewController<LSFooterViewDelegate, ISearchBarEvent, UITableViewDelegate, UITableViewDataSource, StyleTopSelectViewDelegate>

@property (nonatomic, strong) UITableView *mainGrid;
@property (nonatomic, strong) SearchBar2 *searchBar;
@property (nonatomic, strong) LSFooterView *footView;
@property (nonatomic, retain) NSString *searchCode;
@property (nonatomic, retain) StyleTopSelectView *styleTopSelectView;

@property (nonatomic, strong) NSMutableDictionary* conditionOfBatchView;

@property (nonatomic, retain) NSMutableArray *datas;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@property (nonatomic,copy) StyleChoiceViewSelectBack selectBlock;
@property (nonatomic,copy) StyleChoiceViewSelectBack1 selectBlock1;


/**
 type: 传1时，批量选择时，选择商品之后，右上角显示“确认”按键
       传2时，批量选择时，选择商品之后，右上角显示“保存”按键
 */
- (void)loaddatas:(NSString *)shopId type:(NSString *)type callBack:(StyleChoiceViewSelectBack)callBack;

- (void)loadDatasFromSelect:(NSMutableDictionary *)condition;

@end
