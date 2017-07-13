//
//  SalePackStyleBatchView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/11/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"
#import "FooterMultiView.h"
#import "OptionPickerClient.h"
#import "ISearchBarEvent.h"
#import "NavigateTitle2.h"

@class NavigateTitle2,  GoodsModule, SearchBar2;
@interface SalePackStyleBatchView : BaseViewController<INavigateEvent,ISampleListEvent,UIActionSheetDelegate,FooterMultiEvent, ISearchBarEvent, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, retain) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic) NavigateTitle2* titleBox;
@property (nonatomic, weak) IBOutlet UITableView *mainGrid;
//@property (nonatomic, weak) IBOutlet BatchRawListPanel *dhListPanel;
@property (nonatomic, weak) IBOutlet FooterMultiView *footView;

@property (nonatomic, weak) IBOutlet SearchBar2 *searchbar;

@property (nonatomic,retain) NSMutableArray *goodsIds;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil styleList:(NSMutableArray*) styleList salePackId:(NSString*) salePackId lastVer:(NSString*) lastVer createTime:(NSString*) createTime searchCode:(NSString*) searchCode;

-(void) loadDatas;

@end
