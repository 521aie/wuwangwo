//
//  GoodsStyleGoodsListView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/10/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "LSFooterView.h"

@class  StyleGoodsVo;
typedef void(^styleGoodsListBack)(BOOL flg);
@interface GoodsStyleGoodsListView : LSRootViewController<LSFooterViewDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LSFooterView *footView;

@property (nonatomic, retain) NSMutableArray *datas;

@property (nonatomic, copy) styleGoodsListBack styleGoodsListBack;

-(void) loaddatas:(NSString*) shopId styleId:(NSString*) styleId lastVer:(NSString*) lastVer synShopId:(NSString*) synShopId styleGoodsList:(NSMutableArray*) styleGoodsList fromViewTag:(int) fromViewTag callBack:(styleGoodsListBack) callBack;

-(void) loaddatasFromEditView:(StyleGoodsVo*) styleGoodsVo action:(int) action lastVer:(NSString*) lastVer;

-(void) loaddatasFromBatchView:(NSString*) lastVer;

@end
