//
//  GoodsAttributeGroupSortView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/12/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "ISampleListEvent.h"

typedef void(^goodsAttributeGroupSortBack) (BOOL flg);
@interface GoodsAttributeGroupSortView : LSRootViewController<ISampleListEvent,UIActionSheetDelegate,UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) goodsAttributeGroupSortBack goodsAttributeGroupSortBack;


-(void) loadDatas:(NSMutableArray*) attributeGroupList attributeNameId:(NSString*) attributeNameId attributeName:(NSString*) attributeName callBack:(goodsAttributeGroupSortBack) callBack;

@end
