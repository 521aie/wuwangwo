//
//  OrderDealView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrderDealView.h"
#import "WechatService.h"
#import "ServiceFactory.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"

#import "MicroOrderDealVo.h"
#import "OrderDealCell.h"

#import "JsonHelper.h"
#import "ViewFactory.h"

#import "SelectDealListView.h"
#import "IMultiNameValueItem.h"

#import "AllShopVo.h"
#import "WareHouseVo.h"

#import "SearchBar2.h"
#import "FooterListView.h"
#import "ISearchBarEvent.h"
#import "NavigateTitle2.h"
#import "FooterListEvent.h"
#import "SelectShopListView.h"

@interface OrderDealView ()<INavigateEvent,ISearchBarEvent,FooterListEvent>

@property (nonatomic, strong) WechatService *wechatService;
@property (nonatomic, strong) NSMutableArray *orderDealList;
@property (nonatomic, strong) NSMutableArray *addDealList;
@property (weak, nonatomic) IBOutlet SearchBar2 *searchBar;

@property (nonatomic) NavigateTitle2 *titleBox;
@property (weak, nonatomic) IBOutlet UIView *titleDiv;

@property (weak, nonatomic) IBOutlet UITableView *mainGrid;
@property (weak, nonatomic) IBOutlet FooterListView *footView;


@property (nonatomic, strong) NSString *keyWord;
@property (nonatomic) long lastDateTime;

@property (nonatomic, assign) NSInteger tag;

@end

@implementation OrderDealView

- (NSMutableArray *)orderDealList {
    if (!_orderDealList) {
        _orderDealList = [NSMutableArray array];
    }
    return _orderDealList;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.wechatService = [ServiceFactory shareInstance].wechatService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    [self initMainGrid];
    [self initSearchBar];
    [self initFootView];
}

- (void)initNavigate {
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"订单处理机构" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

-(void) onNavigateEvent:(Direct_Flag)event {
    if (event==1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)initSearchBar {
    [self.searchBar initDelagate:self placeholder:@"编号"];
}

// 搜索框输入完成方法
- (void)imputFinish:(NSString *)keyWord
{
    self.keyWord = keyWord;
     [self selectOrderDealList:0];
}

- (void)initMainGrid {
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
    __weak OrderDealView* weakSelf = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        [weakSelf selectOrderDealList:0];
    }];
    
    [self.mainGrid ls_addFooterWithCallback:^{
        [weakSelf selectOrderDealList:weakSelf.lastDateTime];
    }];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self selectOrderDealList:0];
}

- (void)initFootView {
    self.footView.imgHelp.hidden = YES;
    [self.footView initDelegate:self btnArrs:@[@"ADD"]];
}

- (void)showAddEvent {
    SelectDealListView* selectDealListView = [[SelectDealListView alloc] initWithNibName:[SystemUtil getXibName:@"SelectDealListView"] bundle:nil];
    [selectDealListView loadData:self.orderDealList keyWord:self.keyWord currentPage:1];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    [self.navigationController pushViewController:selectDealListView animated:NO];
    
}


- (void)selectOrderDealList:(long)lastDateTime {
    //微店申请信息检索
    __weak OrderDealView* weakSelf = self;
    //店铺类型
    [_wechatService selectMicroOrderDeal:self.keyWord lastDateTime:lastDateTime completionHandler:^(id json) {
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
        NSArray *dealList = [JsonHelper transList:[json objectForKey:@"microOrderDealVoList"] objName:@"MicroOrderDealVo"];
        if (lastDateTime == 0) {
            [self.orderDealList removeAllObjects];
        }
        [self.orderDealList addObjectsFromArray:dealList];
        NSString *time =[NSString stringWithFormat:@"%@",[json objectForKey:@"lastDateTime"]] ;
        if ([NSString isNotBlank:time]) {
            self.lastDateTime = [time integerValue];
        }
        [self.mainGrid reloadData];
        
    } errorHandler:^(id json) {
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
        [AlertBox show:json];
        
    }];
}





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderDealList.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"orderDealCellIdentifier";
    OrderDealCell *orderDealCell = (OrderDealCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!orderDealCell) {
        [tableView registerNib:[UINib nibWithNibName:@"OrderDealCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        orderDealCell = (OrderDealCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    MicroOrderDealVo *orderDeal = [self.orderDealList objectAtIndex:indexPath.row];
    
    orderDealCell.lblName.text = orderDeal.name;
    [orderDealCell.lblName setFont:[UIFont boldSystemFontOfSize:16]];
    if (orderDeal.shopType == 1) {
        orderDealCell.lblCode.text = [NSString stringWithFormat:@"门店编号：%@", orderDeal.code];
    } else {
        orderDealCell.lblCode.text = [NSString stringWithFormat:@"仓库编号：%@", orderDeal.code];
    }
    
    orderDealCell.btnDelete.tag = indexPath.row;
    [orderDealCell.btnDelete addTarget:self action:@selector(deleteOrderDeal:) forControlEvents:UIControlEventTouchUpInside];
    
    return orderDealCell;
}

- (void)deleteOrderDeal:(UIButton *)sender {
    self.tag=sender.tag;
    static UIAlertView *alertView;
    if (alertView != nil) {
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
        alertView = nil;
    }
    MicroOrderDealVo *orderDeal = [self.orderDealList objectAtIndex:self.tag];
    NSString*message=[NSString stringWithFormat:@"确认要删除[%@]吗？",orderDeal.name];
    alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
    
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
         MicroOrderDealVo *orderDeal = [self.orderDealList objectAtIndex:self.tag];
        __weak OrderDealView* weakSelf = self;
        //店铺类型
        [_wechatService deleteMicroOrderDeal:orderDeal.dealId completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            
            [self.orderDealList removeObjectAtIndex:self.tag];
            [self.mainGrid reloadData];
            
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
    
}




@end
