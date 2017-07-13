//
//  MemberInfoListView2.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterListEvent.h"
#import "ISampleListEvent.h"
#import "ISearchBarEvent.h"
#import "NavigateTitle2.h"
#import "CustomerCardVo.h"
#import "MemberTopSelectView.h"

@class MBProgressHUD,PaperFooterListView;
@class MemberModule, SearchBar2, MemberSearchCondition, CustomerVo;
@interface MemberInfoListView2 : BaseViewController<FooterListEvent,INavigateEvent, ISearchBarEvent, ISampleListEvent, MemberTopSelectViewDelegate, UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic) NavigateTitle2 *titleBox;
@property (nonatomic, weak) IBOutlet UITableView *mainGrid;
@property (nonatomic, weak) IBOutlet SearchBar2 *memberSearchBarView;
@property (nonatomic, weak) IBOutlet PaperFooterListView *footView;

@property (nonatomic, strong) CustomerCardVo *customerCardVo;
@property (nonatomic, retain) NSMutableArray *datas;
@property (nonatomic) int customerSum;
@property (nonatomic, retain) NSString *searchCode;
@property (nonatomic, retain) NSString *lastDateTime;
@property (nonatomic) int action;
/**记录会员信息页面点击的是哪一个*/
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *disposeName;
@property (nonatomic, strong) MemberSearchCondition *memberSearchCondition;
@property (nonatomic, retain) MemberSearchCondition* conditionOfInit;

//会员信息筛选页面
@property (nonatomic, strong) MemberTopSelectView *memberTopSelectView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil memberSearchCondition:(MemberSearchCondition *) memberSearchCondition action:(int)action;

- (void)selectMemberInfoList:(MemberSearchCondition*) memberSearchCondition action:(int) action;
- (void)loaddatesFromEdit:(CustomerVo*) customerVo action:(int) action;
@end
