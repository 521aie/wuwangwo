//
//  GoodsInnerCodeRegulationSettingView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "LSFooterView.h"
@interface GoodsInnerCodeRegulationSettingView : LSRootViewController<LSFooterViewDelegate,  UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) LSFooterView *footView;

@property (nonatomic, retain) NSMutableArray *datas;

@property (nonatomic, retain) NSMutableArray *oldDatas;

@property (nonatomic, retain) NSString *isOpen;

-(void)reloadDatas:(NSMutableArray*) attributeList;

-(void)reloadSortDatas:(NSMutableArray*) skuList;

@end
