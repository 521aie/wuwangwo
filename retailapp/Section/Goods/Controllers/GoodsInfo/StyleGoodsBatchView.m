//
//  StyleGoodsBatchView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/10/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "StyleGoodsBatchView.h"
#import "UIHelper.h"
#import "StyleGoodsBatchOfGoodsCell.h"
#import "StyleGoodsBatchOfColorCell.h"
#import "StyleGoodsVo.h"
#import "ViewFactory.h"
#import "GoodsSkuVo.h"
#import "AlertBox.h"
#import "GoodsStyleGoodsListView.h"
#import "StyleGoodsPriceView.h"
#import "XHAnimalUtil.h"

@interface StyleGoodsBatchView ()

/**
 1: 表示按商品批量 0: 表示按颜色批量
 */
@property (nonatomic) int type;

@property (nonatomic) int action;

@property (nonatomic, strong) NSMutableArray* styleGoodsList;

@property (nonatomic, strong) NSString* lastVer;

@property (nonatomic, strong) NSString* styleId;

@property (nonatomic, strong) NSString* synShopId;

@end

@implementation StyleGoodsBatchView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHead];
    [self configViews];
    [self loadDatas];
}

- (void)configViews {
    CGFloat y = kNavH;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_W, SCREEN_H - kNavH)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.opaque=YES;
    UIView* view=[ViewFactory generateFooter:88];
    view.backgroundColor=[UIColor clearColor];
    
    [self.tableView setTableFooterView:view];
    
    [self.tableView setTableFooterView:view];
    
    [self.view addSubview:self.tableView];
    
    self.footView = [LSFooterView footerView];
    [self.view addSubview:self.footView];
    self.footView.ls_bottom = SCREEN_H;
    [self.footView initDelegate:self btnsArray:@[kFootSelectAll, kFootSelectNo]];
    
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootSelectNo]) {
        [self notCheckAllEvent];
    } else if ([footerType isEqualToString:kFootSelectAll]) {
        [self checkAllEvent];
    }
    
}

-(void) loadDatas
{
    if (_type == 1) {
        [self configTitle:@"选择商品"];
    } else {
        [self configTitle:@"选择颜色"];
    }
    
    [self.tableView reloadData];
    
    self.tableView.ls_show = YES;
}

-(void) loadDatas:(NSMutableArray *)styleGoodsList type:(int)type action:(int)action lastVer:(NSString *)lastVer styleId:(NSString *)styleId synShopId:(NSString *)synShopId callBack:(styleGoodsBatchBack)callBack
{
    self.styleGoodsBatchBack = callBack;
    _lastVer = lastVer;
    _styleId = styleId;
    _synShopId = synShopId;
    _type = type;
    _action = action;
    self.datas = [[NSMutableArray alloc] init];
    
    if (_type == 1) {
        self.datas = styleGoodsList;
        
    }else{
        BOOL flg = NO;
        for (StyleGoodsVo* vo in styleGoodsList) {
            if (self.datas.count > 0) {
                for (StyleGoodsVo* tempVo in self.datas) {
                    if ([vo.styleColorName isEqualToString:tempVo.styleColorName]) {
                        flg = YES;
                    }
                }
            }
            if (!flg) {
                [self.datas addObject:vo];
            }
            flg = NO;
        }
    }
    
    _styleGoodsList = [[NSMutableArray alloc] initWithCapacity:self.datas.count];
}

-(void) loaddatasFromPriceView:(NSString*) lastVer
{
    _lastVer = lastVer;
}

#pragma navigateTitle.
-(void) initHead
{
    [self configTitle:@"选择款式" leftPath:Head_ICON_CANCEL rightPath:nil];
    [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"确认" filePath:Head_ICON_OK];
}

-(void) onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        self.styleGoodsBatchBack(_lastVer);
    }else{
        if (_styleGoodsList == nil || _styleGoodsList.count == 0) {
            if (_type == 1) {
                [AlertBox show:@"请先选择商品!"];
            } else {
                [AlertBox show:@"请先选择颜色!"];
            }
            return ;
        }
        StyleGoodsPriceView* vc = [[StyleGoodsPriceView alloc] init];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [self.navigationController pushViewController:vc animated:NO];
        __weak StyleGoodsBatchView* weakSelf = self;
        [vc loaddatas:_styleGoodsList type:_type lastVer:_lastVer styleId:_styleId synShopId:_synShopId action:ACTION_CONSTANTS_ADD callBack:^(NSString *lastVer) {
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            if (lastVer) {
                weakSelf.lastVer = lastVer;
            }
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
    }
}

-(void) checkAllEvent
{
    for (StyleGoodsVo *vo in self.datas) {
        vo.isCheck = @"1";
        [_styleGoodsList addObject:vo];
    }
    
    [self.tableView reloadData];
}

-(void) notCheckAllEvent
{
    
    for (StyleGoodsVo *vo in self.datas) {
        vo.isCheck = @"0";
    }
    [_styleGoodsList removeAllObjects];
    
    [self.tableView reloadData];
}

#pragma table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == 1) {
        StyleGoodsBatchOfGoodsCell *detailItem = (StyleGoodsBatchOfGoodsCell *)[self.tableView dequeueReusableCellWithIdentifier:StyleGoodsBatchOfGoodsCellIndentifier];
        
        if (!detailItem) {
            detailItem = [[NSBundle mainBundle] loadNibNamed:@"StyleGoodsBatchOfGoodsCell" owner:self options:nil].lastObject;
        }
        
        if ([ObjectUtil isNotEmpty:self.datas]) {
            StyleGoodsVo *item = [self.datas objectAtIndex:indexPath.row];
            detailItem.lblGoodsName.text = item.styleGoodsName;
            detailItem.lblInnerCode.text = item.innerCode;
            
            if (item.isCheck == nil || [item.isCheck isEqualToString:@""] || [item.isCheck isEqualToString:@"0"]) {
                detailItem.imgUnCheck.hidden = NO;
                detailItem.imgCheck.hidden = YES;
            }else{
                detailItem.imgUnCheck.hidden = YES;
                detailItem.imgCheck.hidden = NO;
            }
            
            detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
            return detailItem;
        }

    }else{
        StyleGoodsBatchOfColorCell *detailItem = (StyleGoodsBatchOfColorCell *)[self.tableView dequeueReusableCellWithIdentifier:StyleGoodsBatchOfColorCellIndentifier];
        
        if (!detailItem) {
            detailItem = [[NSBundle mainBundle] loadNibNamed:@"StyleGoodsBatchOfColorCell" owner:self options:nil].lastObject;
        }
        
        if ([ObjectUtil isNotEmpty:self.datas]) {
            StyleGoodsVo *item = [self.datas objectAtIndex:indexPath.row];
            detailItem.lblColorName.text = item.styleColorName;
            
            if (item.isCheck == nil || [item.isCheck isEqualToString:@""] || [item.isCheck isEqualToString:@"0"]) {
                detailItem.imgUnCheck.hidden = NO;
                detailItem.imgCheck.hidden = YES;
            }else{
                detailItem.imgUnCheck.hidden = YES;
                detailItem.imgCheck.hidden = NO;
            }
            
            detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
            return detailItem;
        }
    }
    abort();
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StyleGoodsVo *vo = [self.datas objectAtIndex:indexPath.row];
    if ([vo.isCheck isEqualToString:@"1"]) {
        vo.isCheck = @"0";
        [_styleGoodsList removeObject:vo];
    }else{
        [_styleGoodsList addObject:vo];
        vo.isCheck = @"1";
    }
    
    [self.tableView reloadData];
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
