//
//  StyleGoodsBatchView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/10/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "ISampleListEvent.h"
#import "LSFooterView.h"
typedef void(^styleGoodsBatchBack) (NSString* lastVer);

@interface StyleGoodsBatchView : LSRootViewController<LSFooterViewDelegate,ISampleListEvent,UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LSFooterView *footView;

@property (nonatomic, retain) NSMutableArray *datas;

@property (nonatomic,retain) NSMutableArray *goodsIds;

@property (nonatomic,copy) styleGoodsBatchBack styleGoodsBatchBack;

-(void) loadDatas:(NSMutableArray*) styleGoodsList type:(int) type action:(int) action lastVer:(NSString*) lastVer styleId:(NSString*) styleId synShopId:(NSString*) synShopId callBack:(styleGoodsBatchBack) callBack;

-(void) loaddatasFromPriceView:(NSString*) lastVer;

@end
