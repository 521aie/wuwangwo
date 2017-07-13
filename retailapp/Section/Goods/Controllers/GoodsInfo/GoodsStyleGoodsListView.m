//
//  GoodsStyleGoodsListView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/10/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsStyleGoodsListView.h"
#import "GoodsFooterListView.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"
#import "ViewFactory.h"
#import "GoodsStyleGoodsCell.h"
#import "StyleGoodsVo.h"
#import "GoodsStyleEditView.h"
#import "GoodsSkuVo.h"
#import "GoodsStyleGoodsEditView.h"
#import "GoodsAttributeAddListView.h"
#import "StyleGoodsBatchView.h"

@interface GoodsStyleGoodsListView ()

@property (nonatomic, strong) GoodsService* goodsService;

@property (nonatomic, strong) NSString* shopId;

@property (nonatomic, strong) NSString* synShopId;

@property (nonatomic, strong) NSString* styleId;

@property (nonatomic, strong) NSString* lastVer;

@property (nonatomic) int fromViewTag;

@property (nonatomic, strong) StyleGoodsVo* tempVo;

@property (nonatomic, retain) NSMutableArray* styleGoodsList;

@end

@implementation GoodsStyleGoodsListView

- (void)viewDidLoad {
    [super viewDidLoad];
    _goodsService = [ServiceFactory shareInstance].goodsService;
    [self initHead];
    [self configViews];
    [self selectStyleGoods];
}
- (void)configViews {
    CGFloat y = kNavH;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_W, SCREEN_H - kNavH)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    UIView* view=[ViewFactory generateFooter:88];
    view.backgroundColor=[UIColor clearColor];
    __weak GoodsStyleGoodsListView* weakSelf = self;
    [weakSelf.tableView ls_addHeaderWithCallback:^{
        [weakSelf selectStyleGoods];
    }];
    
    [self.tableView setTableFooterView:view];

    [self.view addSubview:self.tableView];
    
    self.footView = [LSFooterView footerView];
    [self.view addSubview:self.footView];
    self.footView.ls_bottom = SCREEN_H;
    
    NSArray *arr= nil;
    if (![[Platform Instance] lockAct:ACTION_GOODS_STYLE_ADD] && ![[Platform Instance] lockAct:ACTION_GOODS_STYLE_EDIT]) {
        arr=[[NSArray alloc] initWithObjects:kFootBatch, kFootAdd, nil];
    } else if ([[Platform Instance] lockAct:ACTION_GOODS_STYLE_ADD] && ![[Platform Instance] lockAct:ACTION_GOODS_STYLE_EDIT]) {
        arr=[[NSArray alloc] initWithObjects:kFootBatch, nil];
    } else if (![[Platform Instance] lockAct:ACTION_GOODS_STYLE_ADD] && [[Platform Instance] lockAct:ACTION_GOODS_STYLE_EDIT]) {
        arr=[[NSArray alloc] initWithObjects:kFootAdd, nil];
    } else {
        arr=[[NSArray alloc] init];
    }
    [self.footView initDelegate:self btnsArray:arr];
    
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    } else if ([footerType isEqualToString:kFootBatch]) {
        [self showBatchEvent];
    }
    
}


-(void) loaddatas:(NSString *)shopId styleId:(NSString *)styleId lastVer:(NSString *)lastVer synShopId:(NSString *)synShopId styleGoodsList:(NSMutableArray *)styleGoodsList fromViewTag:(int)fromViewTag callBack:(styleGoodsListBack)callBack
{
    self.styleGoodsListBack = callBack;
    _styleId = styleId;
    _shopId = shopId;
    _synShopId = synShopId;
    _lastVer = lastVer;
    _fromViewTag = fromViewTag;
    _styleGoodsList = styleGoodsList;
    if (_styleGoodsList == nil) {
        [self selectStyleGoods];
    }else{
        
        self.datas = _styleGoodsList;
        [self.tableView reloadData];
        
        self.tableView.ls_show = YES;
    }
}

-(void) loaddatasFromEditView:(StyleGoodsVo *)styleGoodsVo action:(int)action lastVer:(NSString *)lastVer
{
    _lastVer = lastVer;
    if (action == ACTION_CONSTANTS_DEL) {
        [self.datas removeObject:_tempVo];
    }else if (action == ACTION_CONSTANTS_EDIT){
        _tempVo = styleGoodsVo;
    }
    
    [self.tableView reloadData];
    
    self.tableView.ls_show = YES;
}

-(void) loaddatasFromBatchView:(NSString*) lastVer
{
    _lastVer = lastVer;
    
    [self.tableView headerBeginRefreshing];
}

-(void) selectStyleGoods
{
    
    __weak GoodsStyleGoodsListView* weakSelf = self;
    [_goodsService selectStyleGoodsList:_shopId styleId:_styleId completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [weakSelf responseSuccess:json];
        [weakSelf.tableView headerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.tableView headerEndRefreshing];
    }];
}

- (void)responseSuccess:(id)json
{
    [self.datas removeAllObjects];
    self.datas = [StyleGoodsVo converToArr:[json objectForKey:@"styleGoodsVoList"]];
    
    [self.tableView reloadData];
    
    self.tableView.ls_show = YES;
}

- (void) showAddEvent
{
    [self showEditNVItemEvent:ACTION_CONSTANTS_ADD];
}

-(void) showBatchEvent
{
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle: @"请选择批量操作"
                           delegate:self
                           cancelButtonTitle:@"取消"
                           destructiveButtonTitle:nil
                           otherButtonTitles: @"按颜色批量设置价格", @"按商品批量设置价格", nil];
    [menu showInView:self.view];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    for (StyleGoodsVo* goodsVo in self.datas) {
        NSString* goodsName = @"";
        for (GoodsSkuVo* sku in goodsVo.goodsSkuVoList) {
            if ([sku.attributeName isEqualToString:@"颜色"]) {
                goodsName = sku.attributeVal;
                goodsVo.styleColorName = sku.attributeVal;
                break;
            }
        }
        
        for (GoodsSkuVo* sku in goodsVo.goodsSkuVoList) {
            if ([sku.attributeName isEqualToString:@"尺码"]) {
                goodsName = [goodsName stringByAppendingString:[NSString stringWithFormat:@" %@", sku.attributeVal]] ;
                goodsVo.styleGoodsName = goodsName;
                break;
            }
        }
        
        
    }
    int type = 0;
    if (buttonIndex == 0) {
        type = 0;
        StyleGoodsBatchView* vc = [[StyleGoodsBatchView alloc] init];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
        [self.navigationController pushViewController:vc animated:NO];
        __weak GoodsStyleGoodsListView* weakSelf = self;
        [vc loadDatas:weakSelf.datas type:type action:ACTION_CONSTANTS_ADD lastVer:_lastVer styleId:_styleId synShopId:_synShopId callBack:^(NSString *lastVer) {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
            if (lastVer) {
                [weakSelf loaddatasFromBatchView:lastVer];
            }
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
    }else if (buttonIndex == 1){
        type = 1;
        StyleGoodsBatchView* vc = [[StyleGoodsBatchView alloc] init];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
        [self.navigationController pushViewController:vc animated:NO];
        __weak GoodsStyleGoodsListView* weakSelf = self;
        [vc loadDatas:weakSelf.datas type:type action:ACTION_CONSTANTS_ADD lastVer:_lastVer styleId:_styleId synShopId:_synShopId callBack:^(NSString *lastVer) {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
            if (lastVer) {
                [weakSelf loaddatasFromBatchView:lastVer];
            }
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
    }
}

-(void) onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        self.styleGoodsListBack(NO);
    }
}


#pragma navigateTitle.
-(void) initHead
{
    [self configTitle:@"商品信息" leftPath:Head_ICON_BACK rightPath:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _tempVo = (StyleGoodsVo*) [self.datas objectAtIndex:indexPath.row];
    if (self.datas != nil) {
        [self showEditNVItemEvent:ACTION_CONSTANTS_EDIT];
    }
}

-(void) showEditNVItemEvent:(int) action
{
    if (action == ACTION_CONSTANTS_ADD) {
        GoodsAttributeAddListView* vc = [[GoodsAttributeAddListView alloc] initWithShopId:_shopId styleId:_styleId lastVer:_lastVer synShopId:_synShopId action:ACTION_CONSTANTS_ADD fromViewTag:GOODS_STYLE_GOODS_LIST_VIEW];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
        [self.navigationController pushViewController:vc animated:NO];
        __weak GoodsStyleGoodsListView* weakSelf = self;
        [vc loadDatas:^(BOOL flg, NSString* lastVer) {
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
            if (flg) {
                _lastVer = lastVer;
                [weakSelf.tableView headerBeginRefreshing];
            }
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
    } else {
        GoodsStyleGoodsEditView* vc = [[GoodsStyleGoodsEditView alloc] init];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [self.navigationController pushViewController:vc animated:NO];
        __weak GoodsStyleGoodsListView* weakSelf = self;
        [vc loaddatas:_tempVo styleId:_styleId lastVer:_lastVer synShopId:_synShopId action:action callBack:^(StyleGoodsVo *item, int action, NSString *lastVer) {
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            if (action == ACTION_CONSTANTS_DEL) {
                _lastVer = lastVer;
                [self.datas removeObject:_tempVo];
            }else if (action == ACTION_CONSTANTS_EDIT){
                _lastVer = lastVer;
                _tempVo = item;
            }
            [self selectStyleGoods];
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
    }
}

#pragma table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsStyleGoodsCell *detailItem = (GoodsStyleGoodsCell *)[self.tableView dequeueReusableCellWithIdentifier:GoodsStyleGoodsCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"GoodsStyleGoodsCell" owner:self options:nil].lastObject;
    }
    
    if ([ObjectUtil isNotEmpty:self.datas]) {
        StyleGoodsVo *item = [self.datas objectAtIndex:indexPath.row];
        NSString* goodsName = @"";
        for (GoodsSkuVo* sku in item.goodsSkuVoList) {
            if ([sku.attributeName isEqualToString:@"颜色"]) {
                goodsName = sku.attributeVal;
                break;
            }
        }
        
        for (GoodsSkuVo* sku in item.goodsSkuVoList) {
            if ([sku.attributeName isEqualToString:@"尺码"]) {
                goodsName = [goodsName stringByAppendingString:[NSString stringWithFormat:@" %@", sku.attributeVal]] ;
                break;
            }
        }
        detailItem.lblGoodsName.text = goodsName;
        detailItem.lblInnerCode.text = item.innerCode;
        
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return detailItem;
}

#pragma mark UITableView无section列表

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count == 0 ? 0 :self.datas.count;
}


@end
