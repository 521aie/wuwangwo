//
//  WeChatStyleGoodsList.h
//  retailapp
//
//  Created by diwangxie on 16/4/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISearchBarEvent.h"
#import "NavigateTitle2.h"
#import "ITreeItem.h"
#import "StyleChoiceTopView.h"
#import "FooterMultiView.h"
#import "SearchBar2.h"

@class SearchBar2;

@interface WeChatStyleGoodsList : BaseViewController<INavigateEvent,StyleChoiceTopViewDelegate,FooterMultiEvent,ISearchBarEvent>

typedef void(^StyleGoodsList)(NSMutableArray *styleGoodsList);

@property (nonatomic,copy) StyleGoodsList sellStyleGoodsListBlock;

- (void)loadStyleGoodsList:(NSInteger)viewType callBack:(StyleGoodsList)callBack;

@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (weak, nonatomic) IBOutlet UITableView *mainGrid;
@property (nonatomic, retain) StyleChoiceTopView *styleChoiceTopView;
@property (weak, nonatomic) IBOutlet FooterMultiView *footerView;
@property (weak, nonatomic) IBOutlet SearchBar2 *searchBar;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
//cell 和点击模式
@property (nonatomic) NSInteger mode;
//不能呢超过12个
@property (nonatomic) short check;

@end
