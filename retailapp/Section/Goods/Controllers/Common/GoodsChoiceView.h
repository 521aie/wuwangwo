//
//  GoodsChoiceView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/10/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "LSFooterView.h"
#import "ISearchBarEvent.h"
#import "SingleCheckHandle.h"

//商超版商品选择页面(包括单选和批量选择)

@class  SearchBar, GoodsBatchChoiceView, KindMenuView,MicroGoodsVo;
@class GoodsVo;
typedef void(^GoodsChoiceViewSelectBack)(NSMutableArray* goodsList);
@interface GoodsChoiceView : LSRootViewController<LSFooterViewDelegate, ISearchBarEvent, SingleCheckHandle, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainGrid;
@property (nonatomic, strong) SearchBar *searchBar;
@property (nonatomic, strong) LSFooterView *footView;

@property (nonatomic, retain) KindMenuView *kindMenuView;

@property (nonatomic, retain) NSMutableArray *datas;

@property (nonatomic, retain) NSString *searchType;

@property (nonatomic, retain) NSString *searchCode;

@property (nonatomic, retain) NSString *barCode;

@property (nonatomic, retain) NSString *shopId;

@property (nonatomic, retain) NSString *categoryId;

@property (nonatomic, retain) NSString *createTime;

@property (nonatomic, assign) int currentPage;

@property (nonatomic,strong) NSMutableArray *goodsIdList;

@property (nonatomic) NSString *saleCount;

@property (nonatomic,copy) GoodsChoiceViewSelectBack selectBlock;

-(void) loaddatas:(NSString*) shopId callBack:(GoodsChoiceViewSelectBack)callBack;

- (void)showView:(int)viewTag;

@end
