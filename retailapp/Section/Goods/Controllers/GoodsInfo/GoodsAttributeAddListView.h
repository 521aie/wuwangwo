//
//  GoodsAttributeListView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/5.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "ISampleListEvent.h"

typedef void(^attributeAddBack) (BOOL flg, NSString* lastVer);
@interface GoodsAttributeAddListView : LSRootViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,retain) NSMutableArray *headList;    //商品.
@property (nonatomic,retain) NSMutableDictionary *detailMap;
@property (nonatomic,retain) NSMutableArray *idList;    //商品.
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic,strong) NSString* dicCode;
@property (nonatomic,strong) NSString* currTitleName;

@property (nonatomic,copy) attributeAddBack addBack;

- (id)initWithShopId:(NSString *)shopId styleId:(NSString *)styleId lastVer:(NSString *)lastVer synShopId:(NSString *)synShopId action:(int)action fromViewTag:(int)fromViewTag;

-(void) loadDatas:(attributeAddBack) callBack;

-(void) loadDatasFromAttributeSelectView:(NSString*) type attributeValList:(NSMutableArray*) attributeValList;

@end
