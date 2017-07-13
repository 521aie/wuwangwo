//
//  StyleBatchChoiceView2.h
//  retailapp
//
//  Created by zhangzhiliang on 15/11/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISearchBarEvent.h"
#import "FooterMultiView.h"
#import "NavigateTitle2.h"

//批量选择款式页面
@class StyleChoiceView, NavigateTitle2, SearchBar2, StyleChoiceTopView2;
@class ListStyleVo;
typedef void(^SelectBatchBack)(NSMutableArray* styleList);
@interface StyleBatchChoiceView2 : BaseViewController
<INavigateEvent,UIActionSheetDelegate, FooterMultiEvent, ISearchBarEvent, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, weak) IBOutlet UITableView *mainGrid;
@property (nonatomic, weak) IBOutlet FooterMultiView *footView;
@property (nonatomic, weak) IBOutlet SearchBar2 *searchBar;

@property (nonatomic, retain) NSMutableArray *datas;

@property (nonatomic, retain) StyleChoiceTopView2 *styleChoiceTopView2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@property (nonatomic,copy) SelectBatchBack selectBatchBack;

/**
 type: 传1时，批量选择时，选择商品之后，右上角显示“确认”按键
 传2时，批量选择时，选择商品之后，右上角显示“保存”按键
 */
-(void) loaddatas:(NSString*) shopId type:(NSString*) type callBack:(SelectBatchBack)callBack;

- (void)showView:(int)viewTag;

-(void) loadDatasFromSelect:(NSMutableDictionary *)condition;

- (void) clearCheckStatus;

@end
