//
//  SelectDealListView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/10/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectDealListView.h"
#import "ISearchBarEvent.h"
#import "FooterMultiView.h"
#import "AlertBox.h"
#import "ServiceFactory.h"
#import "SelectGoodsCell.h"
#import "CommonService.h"
#import "NavigateTitle2.h"
#import "SearchBar2.h" 
#import "XHAnimalUtil.h"

#import "IMultiNameValueItem.h"
#import "AllShopVo.h"
#import "WareHouseVo.h"

#import "MicroOrderDealVo.h"


@interface SelectDealListView ()<INavigateEvent,ISearchBarEvent,FooterMultiEvent>

@property (nonatomic,strong) CommonService* commonService;

@property (nonatomic, strong) WechatService *wechatService;

@property (nonatomic,copy) SelectDealHandler dealHandler;

@property (nonatomic,strong) NSMutableArray* oldDealList;

@property (nonatomic,strong) NSMutableArray* dataList;

@property (nonatomic,strong) NSMutableArray* selectArr;

@property (nonatomic,copy) NSString* keyWord;
@property (nonatomic) NSInteger currentPage;

@property (nonatomic) BOOL isPush;

@property (nonatomic) long lastCreateTime;

@end

@implementation SelectDealListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.commonService = [ServiceFactory shareInstance].commonService;
        self.wechatService = [ServiceFactory shareInstance].wechatService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    [self initSearchBar];
    [self initMainGrid];
    [self initMainView];
    [self initFootView];
}
- (void)initNavigate
{
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"选择门店" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

- (void)onNavigateEvent:(Direct_Flag)event
{
    if (event==1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self save];
    }
}

- (void)initFootView {
    [self.footView initDelegate:self];
}

- (void)initSearchBar {
    [self.searchBar initDelagate:self placeholder:@"名称/编号"];
}

- (void)initMainView {
    self.selectArr = [NSMutableArray array];
    self.dataList = [NSMutableArray array];
}

- (void)initMainGrid {
    __weak typeof(self) weakSelf = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf selectDealList];
    }];
    
    [self.mainGrid ls_addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf selectDealList];
    }];
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mainGrid headerBeginRefreshing];
}




- (void)changeNavigate
{
    __block BOOL isChange = NO;
    if (self.dataList.count>0) {
        [self.dataList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id<IMultiNameValueItem> item = (id<IMultiNameValueItem>)obj;
            if ([item obtainCheckVal]) {
                isChange = YES;
                *stop = YES;
            }
        }];
    }
    [self.titleBox editTitle:isChange act:ACTION_CONSTANTS_EDIT];
}


#pragma mark - 选择检索条件
- (void)imputFinish:(NSString *)keyWord
{
    self.keyWord = keyWord;
    [self.mainGrid headerBeginRefreshing];
}

#pragma mark - 全选
- (void)checkAllEvent
{
    for (id<IMultiNameValueItem> item in self.dataList) {
        [item mCheckVal:YES];
    }
    [self changeNavigate];
    [self.mainGrid reloadData];
}

#pragma mark - 全不选
-(void) notCheckAllEvent
{
    for (id<IMultiNameValueItem> item in self.dataList) {
        [item mCheckVal:NO];
    }
    [self changeNavigate];
    [self.mainGrid reloadData];
}
- (void)loadData:(NSMutableArray*)dealList keyWord:(NSString*)keyWord currentPage:(NSInteger)currentPage{
    
    self.oldDealList=[NSMutableArray array];
    self.currentPage = 1;
    self.keyWord = keyWord;
    self.oldDealList = dealList;
}


#pragma mark - 检索商品列表
- (void)selectDealList
{
    __weak typeof(self) weakSelf = self;

    [self.commonService selectShopStoreList:[[Platform Instance] getkey:ORG_ID] keyWord:self.keyWord page:self.currentPage lastCreateTime:self.lastCreateTime notInclude:NO completionHandler:^(id json) {
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];

        NSMutableArray* shopList = [AllShopVo converToArr:[json objectForKey:@"allShopList"]];
        if (weakSelf.currentPage==1) {
            [weakSelf.dataList removeAllObjects];
        }
        if ([ObjectUtil isNotEmpty:shopList]) {
            [weakSelf.dataList addObjectsFromArray:shopList];
        }
        NSMutableArray *models = [NSMutableArray arrayWithArray:weakSelf.dataList];
        [weakSelf.dataList removeAllObjects];
        for (AllShopVo *shopVo in models) {
            if (shopVo.shopType == 1) {
                [weakSelf.dataList addObject:shopVo];
            }
        }
        
        weakSelf.lastCreateTime = [[json objectForKey:@"lastCreateTime"] longValue];
        [weakSelf.mainGrid reloadData];
            } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
}

#pragma mark UITableView无section列表

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* selectGoodsCellId = @"SelectGoodsCell";
    SelectGoodsCell* cell = [tableView dequeueReusableCellWithIdentifier:selectGoodsCellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SelectGoodsCell" bundle:nil] forCellReuseIdentifier:selectGoodsCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:selectGoodsCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataList.count>0&&indexPath.row<self.dataList.count) {
        SelectGoodsCell* detailItem = (SelectGoodsCell*)cell;
        id<IMultiNameValueItem> item =(id<IMultiNameValueItem>)[self.dataList objectAtIndex:indexPath.row];
        detailItem.lblName.text = [item obtainItemName];
        detailItem.lblCode.textColor=[UIColor colorWithRed:(0/255.0) green:(136/255.0) blue:(204/255.0) alpha:1.0];
        if ([item isKindOfClass:[AllShopVo class]]) {
            if ([item obtainItemType]==1) {
                detailItem.lblCode.text = [NSString stringWithFormat:@"门店编号：%@",[item obtainItemValue]];
            }else if ([item obtainItemType]==2){
                detailItem.lblCode.text = [NSString stringWithFormat:@"仓库编号：%@",[item obtainItemValue]];
            }
        } else {
            detailItem.lblCode.text = [NSString stringWithFormat:@"仓库编号：%@",[item obtainItemValue]];
        }
        [detailItem.checkPic setHidden:![item obtainCheckVal]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<IMultiNameValueItem> item=[self.dataList objectAtIndex: indexPath.row];
    
    if (item) {
        
        [item mCheckVal:![item obtainCheckVal]];
        
        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
        
        NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
        
        [self.mainGrid reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
    }
    [self changeNavigate];
}

- (void)save
{
    [self.selectArr removeAllObjects];
    NSMutableArray*arr=[[NSMutableArray alloc]init];
    for (id<IMultiNameValueItem> vo in self.dataList) {
        if ([vo obtainCheckVal]) {
            BOOL flag = NO;
            [self.selectArr addObject:vo];
            for (id<IMultiNameValueItem> item in self.oldDealList) {
                if ([[vo obtainItemId] isEqualToString:[item obtainItemId]]) {
                    flag = YES;
                }
            }
            if (!flag) {
                
                if ([vo obtainItemType]==2 ) {
                    [ arr addObject:vo];
                }
            }
            
        }
    }
    
    if (arr.count>1) {
        [AlertBox show:@"机构下已选择一个仓库"];
        return;
    }
    
//    if ((self.selectArr.count+self.oldGoodsList.count)>200) {
//        [AlertBox show:@"单次最多只能添加200种商品!"];
//        return;
//    }
    if (self.dealHandler) {
        self.dealHandler(YES, self.selectArr);
    }
    
    if ( _selectArr.count > 0) {
        //            [weakSelf.orderDealList removeAllObjects];
        NSMutableArray *dealList = [NSMutableArray array];
        
        for (id<IMultiNameValueItem>  vo in _selectArr) {
            MicroOrderDealVo* detailVo = [[MicroOrderDealVo alloc] init];
            
            if ([vo isKindOfClass:[AllShopVo class]]) {
                AllShopVo *shopVo = (AllShopVo *)vo;
                detailVo.shopId = shopVo.shopId;
                detailVo.shopType = shopVo.shopType;
                detailVo.name = shopVo.shopName;
                detailVo.code = shopVo.code;
            } else if ([vo isKindOfClass:[WareHouseVo class]]) {
                WareHouseVo *houseVo = (WareHouseVo *)vo;
                
                detailVo.shopId = houseVo.wareHouseId;
                detailVo.shopType = 2;
                detailVo.name = houseVo.wareHouseName;
                detailVo.code = houseVo.wareHouseCode;
            }
            
            [dealList addObject:detailVo];
        }
        
        
        //保存
        
        //微店申请信息检索
        __weak SelectDealListView* weakSelf = self;
        //店铺类型
        [_wechatService saveMicroOrderDeal:dealList completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    
}
    
}


@end
