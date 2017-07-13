//
//  StyleBatchChoiceView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/10/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "LSFooterView.h"
#import "ISearchBarEvent.h"
#import "StyleTopSelectView.h"

@class StyleChoiceView, SearchBar2;
@class ListStyleVo;
typedef void(^SelectBatchBack)(NSMutableArray* styleList);
@interface StyleBatchChoiceView : LSRootViewController<UIActionSheetDelegate, ISearchBarEvent, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIActionSheetDelegate, StyleTopSelectViewDelegate, LSFooterViewDelegate>

@property (nonatomic, strong) UITableView *mainGrid;
@property (nonatomic, strong) LSFooterView *footView;
@property (nonatomic, strong) SearchBar2 *searchBar;

@property (nonatomic, retain) StyleTopSelectView *styleTopSelectView;

@property (nonatomic, retain) NSMutableArray *datas;

@property (nonatomic, strong) NSMutableDictionary* conditionOfBatchView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@property (nonatomic,copy) SelectBatchBack selectBatchBack;

/**
 第一次进来为0，页面初始化，第二次进来页面不做操作
 */
@property (nonatomic, assign) short count;

-(void) loaddatas:(NSString*) shopId type:(NSString*) type condition:(NSMutableDictionary*) condition styleList:(NSMutableArray*) styleList callBack:(SelectBatchBack)callBack;

-(void) loadDatasFromSelect:(NSMutableDictionary *)condition;

-(void) loaddatas;

@end
