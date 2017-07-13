//
//  WechatGoodsManagementStyleView.h
//  retailapp
//
//  Created by zhangzt on 15/10/12.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterListEvent.h"
#import "ISearchBarEvent.h"
#import "StyleChoiceTopView.h"
#import "NavigateTitle2.h"

@class NavigateTitle2,SearchBar2;
@interface WechatGoodsManagementStyleView : BaseViewController<INavigateEvent,ISearchBarEvent,StyleChoiceTopViewDelegate,UIActionSheetDelegate>
@property (nonatomic) NavigateTitle2 *titleBox;
@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet SearchBar2 *searchBar;

@property (nonatomic, strong) NSMutableDictionary* condition;
@property (nonatomic , retain)NSMutableArray *datas;
@property (nonatomic, retain) StyleChoiceTopView *styleChoiceTopView;

- (void)loaddatas;
@end
