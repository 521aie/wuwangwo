//
//  LSGoodsListViewController.h
//  retailapp
//
//  Created by guozhi on 16/9/13.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "SingleCheckHandle.h"

@class  KindMenuView, GoodsVo;
@interface LSGoodsListViewController : LSRootViewController<  SingleCheckHandle>

//分类页面
@property (nonatomic, strong) KindMenuView *kindMenuView;

@property (nonatomic, strong) GoodsVo *goodsVo;

@property (nonatomic, retain) NSMutableArray *datas;

@property (nonatomic, retain) NSString *searchType;

@property (nonatomic, retain) NSString *searchCode;

@property (nonatomic, retain) NSString *barCode;

@property (nonatomic, retain) NSString *shopId;

@property (nonatomic, retain) NSString *categoryId;

@property (nonatomic, retain) NSString *createTime;

@property (nonatomic,retain) NSMutableArray* categoryList;

@property (nonatomic,retain) NSMutableArray* goodsList;

@property (nonatomic, strong) NSString* synShopId;

@property (nonatomic, strong) NSString* synShopName;
/**
 *  表格
 */
@property (nonatomic, strong) UITableView *tableView;


- (void)loadDatasFromEdit:(GoodsVo*) goodsVo action:(int) action;

-(void) loadDatasFromBatchSelectView;

-(void)showKindMenuViewOfClickCateBtn;


@end
