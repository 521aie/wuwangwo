//
//  WarehouseListView.m
//  retailapp
//
//  Created by hm on 15/9/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "WarehouseListView.h"
#import "ServiceFactory.h"
#import "ViewFactory.h"
#import "SearchBar2.h"
#import "LSFooterView.h"
#import "LSRootViewController.h"
#import "XHAnimalUtil.h"
#import "WareHouseVo.h"
#import "WarehouseEditView.h"
#import "AlertBox.h"
#import "ColorHelper.h"
#import "WarehouseCell.h"
@interface WarehouseListView ()<ISearchBarEvent,LSFooterViewDelegate, UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) SearchBar2* searchBar;
@property (nonatomic,strong) UITableView* mainGrid;
@property (nonatomic,strong) LSFooterView * footView;
@property (nonatomic,strong) StockService* stockService;
/**仓库数据列表*/
@property (nonatomic,strong) NSMutableArray* warehouseList;
/**分页*/
@property (nonatomic) NSInteger currentPage;
/**查询关键词*/
@property (nonatomic,copy) NSString* keyWord;
/**机构id*/
@property (nonatomic,copy) NSString* orgId;
/**仓库数据模型*/
@property (nonatomic,strong) WareHouseVo *wareHouseVo;

@end

@implementation WarehouseListView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    self.stockService = [ServiceFactory shareInstance].stockService;
    [self configViews];
    [self addHeaderAndFooter];
    [self selectWarehouseList];
}

- (void)configViews {
    __weak typeof(self) wself = self;
    self.searchBar = [SearchBar2 searchBar2];
     [self.searchBar initDelagate:self placeholder:@"名称/编号"];
    [self.view addSubview:self.searchBar];
    [self.searchBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.view);
        make.top.equalTo(wself.view.top).offset(kNavH);
        make.height.equalTo(44);
    }];
    
    self.mainGrid = [[UITableView alloc] init];
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    [self.view addSubview:self.mainGrid];
    [self.mainGrid makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.top.equalTo(wself.searchBar.bottom);
    }];
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootAdd]];
    [self.view addSubview:self.footView];
    [self.footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.height.equalTo(60);
    }];
    self.warehouseList = [NSMutableArray array];
    self.currentPage=1;
    self.keyWord = nil;
    self.orgId = [[Platform Instance] getkey:ORG_ID];
}


#pragma mark - 添加刷新加载控件
- (void)addHeaderAndFooter
{
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
    self.mainGrid.rowHeight = 88.0f;

    __strong typeof(self) strongSelf = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        strongSelf.currentPage = 1;
        [strongSelf selectWarehouseList];
    }];
    
    [self.mainGrid ls_addFooterWithCallback:^{
        strongSelf.currentPage++;
        [strongSelf selectWarehouseList];
    }];
}

#pragma mark - 初始化导航栏
- (void)initNavigate {
    [self configTitle:@"仓库" leftPath:Head_ICON_BACK rightPath:nil];
}



#pragma mark - 查询
- (void)imputFinish:(NSString *)keyWord
{
    self.keyWord = keyWord;
    
    [self.mainGrid headerBeginRefreshing];
}

#pragma mark - 查询仓库一览
- (void)selectWarehouseList
{
    __strong typeof(self) strongSelf = self;
    [_stockService selectWarehouseListById:self.orgId withKeyWord:self.keyWord withPage:self.currentPage CompletionHandler:^(id json) {
        NSMutableArray* arrList = [WareHouseVo converToArr:[json objectForKey:@"wareHouseList"]];
        if (strongSelf.currentPage==1) {
            [strongSelf.warehouseList removeAllObjects];
        }
        [strongSelf.warehouseList addObjectsFromArray:arrList];
        arrList = nil;
        [strongSelf.mainGrid reloadData];
        strongSelf.mainGrid.ls_show = YES;
        [strongSelf.mainGrid headerEndRefreshing];
        [strongSelf.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [strongSelf.mainGrid headerEndRefreshing];
        [strongSelf.mainGrid footerEndRefreshing];
    }];
    
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.warehouseList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* warehouseCellId = @"WarehouseCell";
    WarehouseCell* cell = [tableView dequeueReusableCellWithIdentifier:warehouseCellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"WarehouseCell" bundle:nil] forCellReuseIdentifier:warehouseCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:warehouseCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.warehouseList.count > 0) {
        WarehouseCell* detailItem = (WarehouseCell*)cell;
        WareHouseVo* warehouseVo = [self.warehouseList objectAtIndex:indexPath.row];
        //拼接仓库名和所属机构名
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];

        NSString *nameStr = [NSString stringWithFormat:@"%@",warehouseVo.wareHouseName];
        NSMutableAttributedString *attrNameString = [[NSMutableAttributedString alloc] initWithString:nameStr];
        [attrNameString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,nameStr.length-1)];
        [attrString appendAttributedString:attrNameString];

        NSString *staffStr = [NSString stringWithFormat:@"(%@)",warehouseVo.orgName];
        NSMutableAttributedString *attrStaffStr = [[NSMutableAttributedString alloc] initWithString:staffStr];
        [attrStaffStr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getTipColor6] range:NSMakeRange(0,staffStr.length)];
        [attrStaffStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:13.0] range:NSMakeRange(0,staffStr.length)];
        [attrString appendAttributedString:attrStaffStr];
        detailItem.lblName.attributedText = attrString;
        attrString = nil;
        attrNameString = nil;
        attrStaffStr = nil;
        detailItem.lblCode.text = [NSString stringWithFormat:@"仓库编号：%@",warehouseVo.wareHouseCode];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.wareHouseVo = [self.warehouseList objectAtIndex:indexPath.row];
    [self showEditView:self.wareHouseVo.wareHouseId withAction:ACTION_CONSTANTS_EDIT];
}

#pragma mark - 添加仓库
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    }
}
- (void)showAddEvent
{
    [self showEditView:nil withAction:ACTION_CONSTANTS_ADD];
}

#pragma mark - 显示仓库详情页面
- (void)showEditView:(NSString*)warehouseId withAction:(NSInteger)action
{
    WarehouseEditView* warehouseEditView = [[WarehouseEditView alloc] init];
    __strong typeof(self) strongSelf = self;
    [warehouseEditView showDetail:warehouseId action:action callBack:^(id<INameCode> item ,NSInteger operateType) {
        if (operateType==ACTION_CONSTANTS_ADD) {
            //添加仓库，刷新页面
            [strongSelf.mainGrid headerBeginRefreshing];
        }else if (operateType==ACTION_CONSTANTS_EDIT){
            //编辑仓库
            strongSelf.wareHouseVo.wareHouseCode = [item obtainItemCode];
            strongSelf.wareHouseVo.wareHouseName = [item obtainItemName];
            [strongSelf.mainGrid reloadData];
        }else if (operateType==ACTION_CONSTANTS_DEL){
            //删除仓库
            [strongSelf.warehouseList removeObject:strongSelf.wareHouseVo];
            [strongSelf.mainGrid reloadData];
        }
    }];
    [self.navigationController pushViewController:warehouseEditView animated:NO];
    [XHAnimalUtil animalPush:self.navigationController action:action];
}
@end
