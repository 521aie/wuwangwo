//
//  WechatGoodsManagementStyleBatchSelectView.h
//  retailapp
//
//  Created by zhangzt on 15/10/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterMultiView.h"
#import "ISearchBarEvent.h"
#import "StyleChoiceTopView.h"
#import "NavigateTitle2.h"

@class NavigateTitle2,WechatModule,SearchBar2,DHHeadItem;
@interface WechatGoodsManagementStyleBatchSelectView : BaseViewController<INavigateEvent,FooterMultiEvent,ISearchBarEvent,StyleChoiceTopViewDelegate,UIActionSheetDelegate>
{
    WechatModule *parent;
}

@property (nonatomic) NavigateTitle2 *titleBox;
@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (weak, nonatomic) IBOutlet SearchBar2 *searchbar;
@property (weak, nonatomic) IBOutlet UITableView *mainGrid;
@property (weak, nonatomic) IBOutlet FooterMultiView *footView;

@property (nonatomic, retain) NSMutableArray *datas;

@property (nonatomic,retain) NSMutableArray *stylesIds;

@property (nonatomic, strong) NSMutableDictionary *condition;

-(void) loaddata;

-(void) loadDatasFromOperateView:(int) action;

-(void) loadDatasFromSelect:(NSMutableDictionary *)condition;

@end
