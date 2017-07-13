//
//  SelectShopStoreListView.h
//  retailapp
//
//  Created by hm on 15/9/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectSampleListView.h"
#import "INameCode.h"

typedef void(^ShopStoreHandler)(id<INameCode> item);

@interface SelectShopStoreListView : SelectSampleListView
/** 只查询门店（不包括仓库） 默认是门店仓库 如果只查询门店需要设置为YES*/
@property (nonatomic, assign) BOOL onlyShop;
//是否是调整单进入
@property (nonatomic) BOOL isAdjust;
//是否包含本仓库
@property (nonatomic) BOOL notInclude;
//是否是供货日报表页面进入
@property (nonatomic,assign) BOOL isDayReport;
/**是否包含全部 默认是不包含*/
@property (nonatomic,assign) BOOL isContainAll;
@property (nonatomic,copy) ShopStoreHandler shopStoreHandele;

- (void)loadData:(NSString*)selectId checkMode:(NSInteger)mode isPush:(BOOL)isPush callBack:(ShopStoreHandler)shopStoreHandele;

@end
