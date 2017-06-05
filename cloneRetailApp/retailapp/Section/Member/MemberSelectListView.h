//
//  MemberRechargeListView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISearchBarEvent.h"
#import "FooterListEvent.h"
#import "CustomerCardVo.h"
#import "NavigateTitle2.h"

@class NavigateTitle2, SearchBar2, FooterListView;
@interface MemberSelectListView : BaseViewController<FooterListEvent,INavigateEvent,ISearchBarEvent,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic) NavigateTitle2 *titleBox;
@property (nonatomic, weak) IBOutlet UITableView *mainGrid;

@property (nonatomic, weak) IBOutlet SearchBar2 *memberSearchBarView;

@property (nonatomic, weak) IBOutlet FooterListView *footView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil action:(int) action;

-(void) loaddatasFromEdit;
// 从挂失页面返回
-(void) loaddatasFromCardLossEditView:(NSString*) status;

@end
