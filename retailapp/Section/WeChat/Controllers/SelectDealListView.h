//
//  SelectDealListView.h
//  retailapp
//
//  Created by Jianyong Duan on 15/10/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectDealHandler)(BOOL saveflg, NSMutableArray* selectArr);

@class NavigateTitle2,SearchBar2,FooterMultiView;
@interface SelectDealListView : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) IBOutlet UIView* titleDiv;
@property (nonatomic,strong) NavigateTitle2* titleBox;

@property (nonatomic,weak) IBOutlet SearchBar2* searchBar;

@property (nonatomic,weak) IBOutlet UITableView* mainGrid;

@property (nonatomic,weak) IBOutlet FooterMultiView* footView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
//- (void)loadData:(NSMutableArray*)dealList withIsPush:(BOOL)isPush callBack:(SelectDealHandler)handler;
- (void)loadData:(NSMutableArray*)dealList keyWord:(NSString*)keyWord currentPage:(NSInteger)currentPage;

@end
