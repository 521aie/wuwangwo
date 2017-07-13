//
//  SupplierListView.m
//  retailapp
//
//  Created by hm on 15/7/27.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SupplierListView.h"
#import "XHAnimalUtil.h"
#import "ViewFactory.h"
#import "ServiceFactory.h"
#import "SearchBar2.h"
#import "FooterListView.h"
#import "LSSuppilerListCell.h"
#import "SupplyVo.h"
#import "SupplyTypeVo.h"
#import "TreeNode.h"
#import "AlertBox.h"
#import "ColorHelper.h"
#import "SupplierEditView.h"
#import "SupplierKindListView.h"
#import "LSRightFilterListView.h"
#import "LSFooterView.h"

@interface SupplierListView ()<LSFooterViewDelegate, UITableViewDelegate, UITableViewDataSource,ISearchBarEvent,LSRightFilterListViewDelegate>
@property (nonatomic,strong) SearchBar2* searchBox;

@property (nonatomic,strong) UITableView* tableView;

@property (nonatomic, strong) LogisticService *logisticService;

@property (nonatomic, strong) CommonService *commonService;

@property (nonatomic, strong) NSMutableArray* supplierArr;

@property (nonatomic, strong) NSMutableArray* supplyTypeList;

@property (nonatomic, strong) SupplyVo *supplyVo;

@property (nonatomic, copy) NSString *keyWord;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, copy) NSString *supplyTypeId;
/** 筛选按钮 */
@property (nonatomic, strong) LSRightFilterListView *viewFilter;
/** <#注释#> */
@property (nonatomic, strong) LSFooterView *footView;

@end

@implementation SupplierListView

- (id)init
{
    self = [super init];
    if (self) {
        self.logisticService = [ServiceFactory shareInstance].logisticService;
        self.commonService = [ServiceFactory shareInstance].commonService;
        self.currentPage = 1;
        self.supplierArr = [NSMutableArray array];
        self.supplyTypeList = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    [self configViews];
    [self configFilterView];
    [self addHeaderAndFooter];
    [self selectSupplyList];
    [self configHelpButton:HELP_OUTIN_SUPPLIER];
}

- (void)configViews {
    CGFloat y = kNavH;
    self.searchBox = [SearchBar2 searchBar2];
    [self.searchBox initDelagate:self placeholder:@"名称/手机号"];
    [self.view addSubview:self.searchBox];
    self.searchBox.ls_top = y;
    
    y = self.searchBox.ls_bottom;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_W, SCREEN_H - y)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      self.tableView.tableFooterView =  [ViewFactory generateFooter:BOTTOM_HEIGHT];
    [self.view addSubview:self.tableView];
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootAdd]];
    [self.view addSubview:self.footView];
    self.footView.ls_bottom = SCREEN_H;
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    }
}

#pragma mark - 添加刷新控件和加载控件
- (void)addHeaderAndFooter
{
    __weak typeof(self) weakSelf = self;
    [self.tableView ls_addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf selectSupplyList];
        
    }];
    [self.tableView ls_addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf selectSupplyList];
    }];
}

#pragma mark - 初始化导航栏
- (void)initNavigate
{
    [self configTitle:@"供应商" leftPath:Head_ICON_BACK rightPath:nil];
}


- (void)configFilterView {
    self.viewFilter = [LSRightFilterListView addFilterView:self.view type:LSRightFilterListViewTypeSuppilerCategory delegate:self];
    self.viewFilter.isShowBtn = YES;
}

#pragma mark - LSRightFilterListViewDelegate
- (void)rightFilterListViewDidClickTopBtn:(LSRightFilterListView *)rightFilterListView {
    SupplierKindListView *kindListView = [[SupplierKindListView alloc] init];
    __weak typeof(self) weakSelf = self;
    [kindListView loadDataWithCallBack:^(NSMutableArray *kindList) {
        if (kindList != nil && kindList.count>0) {
            [weakSelf.supplyTypeList removeAllObjects];
            TreeNode *treeNode = [[TreeNode alloc] init];
            treeNode.itemId = @"";
            treeNode.itemName = @"全部类别";
            [weakSelf.supplyTypeList addObject:treeNode];
            for (SupplyTypeVo *supplyTypeVo in kindList) {
                treeNode = [[TreeNode alloc] init];
                treeNode.itemId = supplyTypeVo.typeVal;
                treeNode.itemName = supplyTypeVo.typeName;
                [weakSelf.supplyTypeList addObject:treeNode];
            }
            weakSelf.viewFilter.datas = weakSelf.supplyTypeList;
        }
    }];
    [self.navigationController pushViewController:kindListView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

- (void)rightFilterListView:(LSRightFilterListView *)rightFilterListView didSelectObj:(id<INameItem>)obj {
    self.currentPage = 1;
    self.keyWord = nil;
    self.searchBox.keyWordTxt.text = @"";
    self.supplyTypeId = [NSString isBlank:[obj obtainItemId]]?nil:[obj obtainItemId];
    [self selectSupplyList];

}

#pragma mark - ISearchBarEvent协议
- (void)imputFinish:(NSString *)keyWord
{
    self.supplyTypeId = nil;
    self.keyWord = keyWord;
    self.currentPage = 1;
    [self selectSupplyList];
}

#pragma mark - 查询供应商列表
- (void)selectSupplyList
{    __weak typeof(self) weakSelf = self;
    [self.logisticService selectSupplyListWithKeyWord:self.keyWord withCurrentPage:self.currentPage withSupplyTypeId:self.supplyTypeId completionHandler:^(id json) {
        NSMutableArray *arr = [SupplyVo converToArr:[json objectForKey:@"supplyList"]];
        if (weakSelf.currentPage==1) {
            [weakSelf.supplierArr removeAllObjects];
        }
        [weakSelf.supplierArr addObjectsFromArray:arr];
        [weakSelf.tableView reloadData];
        weakSelf.tableView.ls_show = YES;
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
    }];

}

#pragma mark - 添加供应商
- (void)showAddEvent
{
    [self showEditView:nil isWarehouse:NO action:ACTION_CONSTANTS_ADD];
}

- (void)showHelpEvent
{

}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.supplierArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSSuppilerListCell *cell = [LSSuppilerListCell suppilerListCellWithTableView:tableView];
    self.supplyVo = [self.supplierArr objectAtIndex:indexPath.row];
    cell.obj = self.supplyVo;
    return cell;
    
     
}

//详情页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.supplyVo = [self.supplierArr objectAtIndex:indexPath.row];
    [self showEditView:self.supplyVo.supplyId isWarehouse:(self.supplyVo.wareHouseFlg==1) action:ACTION_CONSTANTS_EDIT];
}

- (void)showEditView:(NSString *)supplyId isWarehouse:(BOOL)isWarehouse action:(NSInteger)action
{
    SupplierEditView *editView = [[SupplierEditView alloc] init];
    __weak typeof(self) weakSelf = self;
    [editView loadDataWithId:supplyId withIsWarehouse:isWarehouse withAction:action callBack:^(SupplyVo *supplyVo, NSInteger flg) {
        if (flg==ACTION_CONSTANTS_ADD) {
            [weakSelf.tableView headerBeginRefreshing];
        }else{
            for (SupplyVo *vo in weakSelf.supplierArr) {
                if ([vo.supplyId isEqualToString:supplyVo.supplyId]) {
                    if (flg==ACTION_CONSTANTS_DEL) {
                        [weakSelf.supplierArr removeObject:vo];
                        break;
                    }else{
                        vo.supplyName = supplyVo.supplyName;
                        vo.relation = supplyVo.relation;
                        vo.mobile = supplyVo.phone;
                        break;
                    }
                }
            }
            [weakSelf.tableView reloadData];
        }
        [XHAnimalUtil animalEdit:weakSelf.navigationController action:flg];
        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
    }];
    [self.navigationController pushViewController:editView animated:NO];
    [XHAnimalUtil animalPush:self.navigationController action:action];
}

@end
