//
//  SelectOrgShopListView.h
//  retailapp
//
//  Created by hm on 15/9/1.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectSampleListView.h"
#import "ITreeItem.h"

typedef void(^SelectOrgShopBack)(NSMutableArray* selectArr,id<ITreeItem> item);

@interface SelectOrgShopListView : SelectSampleListView

@property (nonatomic,copy) SelectOrgShopBack selectBlock;
/**是否显示“全部”*/
@property (nonatomic) BOOL isAll;
/**是否显示微店*/
@property (nonatomic) BOOL isMicroShop;
/**是否过滤总部 默认不过滤*/
@property (nonatomic, assign) BOOL isFilterTop;
- (void)loadData:(NSString*)_id withModuleType:(NSInteger)type withCheckMode:(NSInteger)mode callBack:(SelectOrgShopBack)callBack;

@end
