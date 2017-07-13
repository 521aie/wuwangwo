//
//  MarketStyleBatchView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/11/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SalesStyleBatchView.h"
#import "NavigateTitle2.h"
#import "UIHelper.h"
#import "GoodsStyleBatchSelectCell.h"
#import "ObjectUtil.h"
#import "SearchBar2.h"
#import "ViewFactory.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"
#import "SalesStyleAreaView.h"
#import "SaleStyleVo.h"

@interface SalesStyleBatchView ()

@property (nonatomic, strong) MarketService *marketService;

@property (nonatomic, retain) NSMutableArray *datas;

@property (nonatomic, strong) NSString* discountId;

@property (nonatomic, strong) NSString* discountType;

@property (nonatomic, strong) NSString *searchCode;

@property (nonatomic, strong) NSString* lastDateTime;

@property (nonatomic) int styleCount;

@property (nonatomic, strong) NSMutableArray* styleList;

@end

@implementation SalesStyleBatchView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil styleList:(NSMutableArray *)styleList discountId:(NSString *)discountId discountType:(NSString*) discountType lastDateTime:(NSString *)lastDateTime searchCode:(NSString *)searchCode{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _datas = styleList;
        _discountId = discountId;
        _discountType = discountType;
        _searchCode = searchCode;
        _lastDateTime = lastDateTime;
        _marketService = [ServiceFactory shareInstance].marketService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHead];
    [self initGrid];
    [self loadDatas];
    [self.searchbar initDelagate:self placeholder:@"名称/款号"];
    [UIHelper clearColor:self.footView];
    [self.footView initDelegate:self];
    __weak SalesStyleBatchView* weakSelf = self;
    [weakSelf.mainGrid ls_addHeaderWithCallback:^{
        _lastDateTime = nil;
        [weakSelf selectStyleList];
    }];
    
    [weakSelf.mainGrid ls_addFooterWithCallback:^{
        [weakSelf selectStyleList];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) loadDatas
{
    if (self.datas != nil && self.datas.count > 0) {
        for (SaleStyleVo* vo in self.datas) {
            vo.isCheck = @"0";
        }
    }
    self.searchbar.keyWordTxt.text = _searchCode;
    _styleList = [[NSMutableArray alloc] init];
    [self.mainGrid reloadData];
    
    self.mainGrid.ls_show = YES;
}

#pragma 款式list查询
-(void) selectStyleList
{
    __weak SalesStyleBatchView* weakSelf = self;
    [_marketService selectStyleList:_searchCode discountId:_discountId discountType:_discountType lastDateTime:_lastDateTime completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [self responseSuccess:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
}

#pragma 后台数据返回封装
- (void)responseSuccess:(id)json
{
    NSMutableArray *array = [json objectForKey:@"saleStyleVoList"];
    if (_lastDateTime == nil || [_lastDateTime isEqualToString:@""]) {
        self.datas = [[NSMutableArray alloc] init];
    }
    if ([ObjectUtil isNotNull:array]) {
        for (NSDictionary* dic in array) {
            [self.datas addObject:[SaleStyleVo convertToSaleStyleVo:dic]];
        }
    }
    
    if ([ObjectUtil isNotNull:[json objectForKey:@"lastDateTime"]]) {
        _lastDateTime = [[json objectForKey:@"lastDateTime"] stringValue];
    }
    
    [self.mainGrid reloadData];
    
    self.mainGrid.ls_show = YES;
}

#pragma navigateTitle.
-(void) initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"选择款式" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.titleBox.lblRight.text = @"操作";
    [self.titleDiv addSubview:self.titleBox];
}

#pragma 导航栏事件
-(void) onNavigateEvent:(Direct_Flag)event
{
    if (event == 1) {
        // 返回到促销款式列表
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        if (_styleList.count == 0) {
            [AlertBox show:@"请先选择款式!"];
            return;
        }
        // 批量操作
        UIActionSheet *menu = [[UIActionSheet alloc]
                               initWithTitle: @"请选择批量操作"
                               delegate:self
                               cancelButtonTitle:@"取消"
                               destructiveButtonTitle:nil
                               otherButtonTitles: @"删除", nil];
        [menu showInView:self.view];
        
    }
}

#pragma actionSheet事件
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        static UIAlertView *alertView;
        if (alertView != nil) {
            [alertView dismissWithClickedButtonIndex:0 animated:NO];
            alertView = nil;
        }
        alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认删除所有选中款式吗?" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
        [alertView show];
    }
}

#pragma alterView事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        __weak SalesStyleBatchView* weakSelf = self;
        NSMutableArray* styleIdList = [[NSMutableArray alloc] init];
        for (SaleStyleVo* vo in _styleList) {
            [styleIdList addObject:vo.styleId];
        }
        [_marketService deleteSalesStyle:styleIdList discountId:_discountId discountType:_discountType completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[SalesStyleAreaView class]]) {
                    SalesStyleAreaView *listView = (SalesStyleAreaView *)vc;
                    [listView loadDatasFromBatchOperateView];
                }
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
            [self.navigationController popViewControllerAnimated:NO];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

#pragma 全选事件
-(void) checkAllEvent
{
    _styleList = [[NSMutableArray alloc] initWithCapacity:self.datas.count];
    for (SaleStyleVo *vo in self.datas) {
        vo.isCheck = @"1";
        [_styleList addObject:vo];
    }
    
    [self.mainGrid reloadData];
}

#pragma 全不选事件
-(void) notCheckAllEvent
{
    for (SaleStyleVo *vo in self.datas) {
        vo.isCheck = @"0";
    }
    [_styleList removeAllObjects];
    
    [self.mainGrid reloadData];
}

#pragma 搜索框搜索事件
-(void) imputFinish:(NSString *)keyWord
{
    _searchCode = keyWord;
    _lastDateTime = nil;
    [self.mainGrid headerBeginRefreshing];
}

#pragma table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsStyleBatchSelectCell *detailItem = (GoodsStyleBatchSelectCell *)[self.mainGrid dequeueReusableCellWithIdentifier:GoodsStyleBatchSelectCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"GoodsStyleBatchSelectCell" owner:self options:nil].lastObject;
    }
    
    if ([ObjectUtil isNotEmpty:self.datas]) {
        SaleStyleVo *item = [self.datas objectAtIndex:indexPath.row];
        detailItem.lblName.text = item.styleName;
        detailItem.lblStyleNo.text = item.styleCode;
        
        if (item.isCheck == nil || [item.isCheck isEqualToString:@""] || [item.isCheck isEqualToString:@"0"]) {
            detailItem.imgUnCheck.hidden = NO;
            detailItem.imgCheck.hidden = YES;
        }else{
            detailItem.imgUnCheck.hidden = YES;
            detailItem.imgCheck.hidden = NO;
        }
        
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return detailItem;
    
}

#pragma click table cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SaleStyleVo *vo = [self.datas objectAtIndex:indexPath.row];
    if ([vo.isCheck isEqualToString:@"1"]) {
        vo.isCheck = @"0";
        [_styleList removeObject:vo];
    }else{
        [_styleList addObject:vo];
        vo.isCheck = @"1";
    }
    
//    BOOL isCheck = NO;
    for (SaleStyleVo* vo in self.datas) {
        if ([vo.isCheck isEqualToString:@"1"]) {
            [self.titleBox.imgMore setHidden:NO];
            [self.titleBox.lblRight setHidden:NO];
//            isCheck =YES;
            break ;
        }
    }
    
    [self.mainGrid reloadData];
}

#pragma mark UITableView无section列表

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count == 0 ? 0 :self.datas.count;
}

-(void)initGrid
{
    self.mainGrid.opaque=YES;
    UIView* view=[ViewFactory generateFooter:88];
    view.backgroundColor=[UIColor clearColor];
    
    [self.mainGrid setTableFooterView:view];
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

@end
