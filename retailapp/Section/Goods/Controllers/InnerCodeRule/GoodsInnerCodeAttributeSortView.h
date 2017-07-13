//
//  GoodsInnerCodeAttributeSortView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/14.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

typedef void(^goodsInnerCodeAttributeSortBack) (NSMutableArray* skuList);
@class NavigateTitle2;
@interface GoodsInnerCodeAttributeSortView : LSRootViewController<UIActionSheetDelegate,UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *datas;

@property (nonatomic, retain) NSMutableArray *skuList;

@property (nonatomic, copy) goodsInnerCodeAttributeSortBack goodsInnerCodeAttributeSortBack;


-(void) loadDatas:(NSMutableArray*) skuList callBack:(goodsInnerCodeAttributeSortBack) callBack;

@end
