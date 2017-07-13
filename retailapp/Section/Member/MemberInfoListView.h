//
//  MemberInfoListView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterListEvent.h"
#import "OptionPickerClient.h"
#import "IEditItemListEvent.h"
#import "ISearchBarEvent.h"
#import "MemberTopSelectView.h"
#import "NavigateTitle2.h"

@class NavigateTitle2, EditItemList, EditItemText, SearchBar2, FooterListView, MemberTopSelectView;
@class MemberModule,CardSummarizingVo, MemberSearchCondition;
@interface MemberInfoListView : BaseViewController<FooterListEvent, INavigateEvent, IEditItemListEvent, ISearchBarEvent, MemberTopSelectViewDelegate,  UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic) NavigateTitle2 *titleBox;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet EditItemList *lsMyMember;
@property (nonatomic, strong) IBOutlet EditItemList *lsMemberSum;
@property (nonatomic, strong) IBOutlet EditItemList *lsCurrentMonthMemberNum;

@property (nonatomic, strong) IBOutlet UIView *infoView;

//会员信息筛选页面
@property (nonatomic, strong) MemberTopSelectView *memberTopSelectView;

@property (nonatomic, weak) IBOutlet SearchBar2 *memberSearchBarView;

@property (nonatomic, weak) IBOutlet FooterListView *footView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

-(void) loaddatas:(MemberSearchCondition *) memberSearchCondition;

@end
