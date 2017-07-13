//
//  GoodsAttributeValSortView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/12/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "ISampleListEvent.h"

typedef void(^goodsAttributeValSortBack) (BOOL flg);
@interface GoodsAttributeValSortView : LSRootViewController<ISampleListEvent,UIActionSheetDelegate,UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) goodsAttributeValSortBack goodsAttributeValSortBack;


-(void) loadDatas:(NSMutableArray*) attributeValList attributeGroupId:(NSString*) attributeGroupId attributeName:(NSString*) attributeName callBack:(goodsAttributeValSortBack) callBack;

@end
