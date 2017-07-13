//
//  RoleCommissionView.m
//  retailapp
//
//  Created by qingmei on 15/9/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//


#import "RoleCommissionView.h"
#import "SelectOrgShopListView.h"
#import "ServiceFactory.h"
#import "SingleCheckHandle.h"
#import "EmployeeService.h"
#import "SearchBar2.h"
#import "UIView+Sizes.h"
#import "RoleCell.h"
#import "HeaderItem.h"
#import "RoleCommissionnDetailView.h"
#import "IEditItemListEvent.h"
#import "TDFComplexConditionFilter.h"

@interface RoleCommissionView ()<ISearchBarEvent,UITableViewDataSource,UITableViewDelegate, TDFConditionFilterDelegate>

@property (nonatomic, strong) EmployeeService *service;       //网络服务
/**角色提成一览列表*/
//@property (nonatomic, strong) NSMutableArray *roleCommissionList;
/**角色list*/
//@property (nonatomic, strong) NSMutableArray *roleTypeDicVoList;
@property (nonatomic, strong) NSMutableArray *roleList;      //角色列表
@property (nonatomic, assign) NSInteger shopMode;       //1 单店 2连锁门店 3连锁组织机构
@property (nonatomic, assign) NSInteger roleType;       //连锁模式  2单店模式 1连锁模式
@property (nonatomic, strong) NSMutableArray *singleShopList;//单店list,如果是单店模式时使用
@property (nonatomic, strong) NSString *shopId;//机构or门店id
@property (nonatomic, strong) UITableView  *mainGrid;  //tableview
@property (nonatomic, strong) SearchBar2   *searchBar; //搜索栏
@property (nonatomic, strong) NSMutableArray        *headList;  //tableview Header 数据
@property (nonatomic, strong) NSMutableDictionary   *detailMap; //tableview详细数据
@property (nonatomic ,strong) TDFComplexConditionFilter *filterView;/**<筛选view>*/
@property (nonatomic ,strong) NSArray *filterModels;/**<筛选数据>*/
@end

@implementation RoleCommissionView

- (void)viewDidLoad {
    [super viewDidLoad];
    _service = [ServiceFactory shareInstance].employeeService;
    self.shopMode = [[Platform Instance] getShopMode];
    if (self.shopMode == 3) {
        self.roleType = 1;
        self.shopId = [[Platform Instance] getkey:ORG_ID];
    } else {
        self.roleType = 2;
        self.shopId = [[Platform Instance] getkey:SHOP_ID];
    }
    [self initMainView];
    [self loadRoleCommissionList];
    [self configHelpButton:HELP_EMPLOYE_ROLE_SETTING];
}


- (void)initMainView {

    // 导航
    [self configTitle:@"角色提成设置" leftPath:Head_ICON_BACK rightPath:nil];
    
    
    // 搜索框
    self.searchBar = [SearchBar2 searchBar2];
    self.searchBar.ls_top = 64;
    [self.searchBar initDelagate:self placeholder:@"名称"];
    [self.view addSubview:self.searchBar];
    
    // 列表
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.ls_bottom, SCREEN_W, SCREEN_H-self.searchBar.ls_bottom) style:UITableViewStylePlain];
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.showsVerticalScrollIndicator = NO;
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
    self.mainGrid.rowHeight = 88.0f;
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    [self.view addSubview:self.mainGrid];
    
    // 筛选
    if (self.shopMode == 3) {
        self.filterView = [[TDFComplexConditionFilter alloc] initFilter:@"筛选条件" image:@"ico_filter_normal" highlightImage:@"ico_filter_highlighted"];
        self.filterView.delegate = self;
        [self.filterView addToView:self.view withDatas:self.filterModels];
    }
}

- (NSArray *)filterModels {
    
    if (!_filterModels) {
        
        //连锁机构
        TDFTwiceCellModel *shopModel = [[TDFTwiceCellModel alloc] initWithType:TDF_TwiceFilterCellTwoLine optionName:@"机构/门店" hideStatus:NO];
        shopModel.arrowImageName = @"ico_next";
        shopModel.restName = [[Platform Instance] getkey:SHOP_NAME];
        shopModel.restValue = [[Platform Instance] getkey:SHOP_ID];
        //连锁门店/单店
//        TDFRegularCellModel *role = [[TDFRegularCellModel alloc] initWithOptionName:@"类型" hideStatus:NO];
//        role.resetItemIndex = 0;
//        role.optionItems = @[[TDFFilterItem filterItem:@"机构" itemValue:@"机构"],
//                             [TDFFilterItem filterItem:@"门店" itemValue:@"门店"]];
        _filterModels = @[shopModel];
    }
    return _filterModels;
}

#pragma mark - 相关代理方法 -
// INavigateEvent
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event{
    if (event == LSNavigationBarButtonDirectLeft) {
        [self popToLatestViewController:kCATransitionFromLeft];
    }
}


// ISearchBarEvent
- (void)imputFinish:(NSString *)keyWord{
    [self loadRoleCommissionList];
}

// TDFConditionFilterDelegate
- (BOOL)tdf_filterWillShow {
   return [self.searchBar endEditing:YES];
}

- (void)tdf_filter:(TDFComplexConditionFilter *)filter actionWithCellModel:(TDFFilterMoel *)model {
   
    if (model.type == TDF_TwiceFilterCellTwoLine) {
       
        [self selectOrganiOrShop];
    } else if (model.type == TDF_RegularFilterCell) {
        
        if ([[Platform Instance] getShopMode] == 3) {
//            TDFRegularCellModel *type = self.filterModels.lastObject;
//            [self scroll:type.currentValue];
        }
    }
}

- (void)tdf_filterCompleted {
    [self loadRoleCommissionList];
}

- (void)tdf_filterReset {
    if ([[Platform Instance] getShopMode] == 3) {
//        TDFRegularCellModel *type = self.filterModels.lastObject;
//        [self scroll:type.currentValue];
    }
}

// UITableViewDelegate , UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if (self.roleType != 2) {
//        return (self.headList!=nil?self.headList.count:0);
//    } else {
//        return 1;
//    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (self.roleType != 2) {
//        NSString *head = [self.headList objectAtIndex:section];
//        NSMutableArray *array = [self.detailMap objectForKey:head];
//        return array.count;
//    } else {
//        return self.singleShopList.count;
//    }
    return self.singleShopList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"RoleCommissionCell";
    RoleCell* cell = (RoleCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [RoleCell getInstance];
    }
    
//    if (self.roleType != 2) {
//        NSString *head = [self.headList objectAtIndex:indexPath.section];
//        if ([ObjectUtil isNotNull:head]) {
//            NSMutableArray *details = [self.detailMap objectForKey:head];
//            RoleCommissionVo *roleCommission = [details objectAtIndex:indexPath.row];
//            [cell loadCell:roleCommission];
//        }
//    } else {
//        RoleCommissionVo *roleCommission = [self.singleShopList objectAtIndex:indexPath.row];
//        [cell loadCell:roleCommission];
//    }
    RoleCommissionVo *roleCommission = [self.singleShopList objectAtIndex:indexPath.row];
    [cell loadCell:roleCommission];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RoleCommissionVo *roleCommission;
//    if (self.roleType != 2) {
//        NSString *head = [self.headList objectAtIndex:indexPath.section];
//        if ([ObjectUtil isNotNull:head]) {
//            NSMutableArray *details = [self.detailMap objectForKey:head];
//            roleCommission = [details objectAtIndex:indexPath.row];
//        }
//    } else {
//         roleCommission = [self.singleShopList objectAtIndex:indexPath.row];
//    }
    roleCommission = [self.singleShopList objectAtIndex:indexPath.row];
    RoleCommissionnDetailView *vc = [[RoleCommissionnDetailView alloc] init];
    __weak typeof(self) wself = self;
    [vc loadDataWithRoleCommissionId:roleCommission.Id block:^{
        [wself loadRoleCommissionList];
    }];
    [self pushController:vc from:kCATransitionFromRight];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    HeaderItem *headItem = [[[NSBundle mainBundle]loadNibNamed:@"HeaderItem" owner:self options:nil]lastObject];
//    headItem.lbtitle.textColor = [UIColor whiteColor];
//    NSString *kindMember = [self.headList objectAtIndex:section];
//    [headItem initWithName:kindMember];
//    return headItem;
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (self.roleType!=2 || (self.roleType == 2 && [[Platform Instance] getShopMode] == 3)) {
//        return 40;
//    } else {
//        return 0;
//    }
    return 0;
}

//根据header滚动
- (void)scroll:(NSString *)headerKey{
    if ([ObjectUtil isNotEmpty:self.headList] && [ObjectUtil isNotNull:headerKey]) {
        NSInteger index = [self.headList indexOfObject:headerKey];
        CGFloat offset = index * 40;//跳过的head所占的高度
        for (NSInteger i= 0; i<index; ++i) {
            NSString *headTemp = [self.headList objectAtIndex:i];
            if ([ObjectUtil isNotNull:headTemp]) {
                NSArray *roles = [self.detailMap objectForKey:headTemp];
                if ([ObjectUtil isNotEmpty:roles]) {
                    offset += 88 * roles.count;//跳过的cell所占的高度
                }
            }
        }
        [self.mainGrid setContentOffset:CGPointMake(0, offset) animated:YES];
    }
}

//跳转页面至选择门店或机构
- (void)selectOrganiOrShop {
    
    SelectOrgShopListView *selectOrgShopListView = [[SelectOrgShopListView alloc] init];
    selectOrgShopListView.isMicroShop = NO;
    [self pushController:selectOrgShopListView from:kCATransitionFromRight];
    __weak RoleCommissionView* weakSelf = self;
    [selectOrgShopListView loadData:_shopId withModuleType:3 withCheckMode:SINGLE_CHECK callBack:^(NSMutableArray *selectArr, id<ITreeItem> item) {
        if (item) {
            // 切换门店/机构 更新列表信息
            if (![[item obtainItemId] isEqualToString:self.shopId]) {
                weakSelf.shopId = [item obtainItemId];
                weakSelf.roleType = [item obtainItemType];
                TDFTwiceCellModel *shop = weakSelf.filterModels.firstObject;
                shop.currentName = [item obtainItemName];
                shop.currentValue = [item obtainItemId];
//                [weakSelf loadRoleCommissionList];
            }
        }
        [weakSelf popToLatestViewController:kCATransitionFromLeft];
    }];
}


#pragma mark - 网络请求 -
// 获取角色权限列表
- (void)loadRoleCommissionList {
    
    __weak typeof(self) weakSelf = self;
    NSInteger selectRoleType;
    if (self.roleType == 2) {
        selectRoleType = 1;//连锁门店、单店只需要查询门店
    } else {
        selectRoleType = 0;//连锁机构要同时查询门店和机构
    }
    NSString *keyWord = self.searchBar.keyWordTxt.text;
    [_service roleCommissionListByRoleName:keyWord roleType:selectRoleType shopId:_shopId completionHandler:^(id json) {
        
        weakSelf.detailMap = nil;
        weakSelf.detailMap = [[NSMutableDictionary alloc]init];
        
        weakSelf.headList = nil;
        if (weakSelf.roleType != 2) {//连锁机构再去创建
            weakSelf.headList = [[NSMutableArray alloc]init];
            [weakSelf.headList addObject:@"机构"];
            [weakSelf.headList addObject:@"门店"];
        } else if ([[Platform Instance] getShopMode] == 3) {
            weakSelf.headList = [[NSMutableArray alloc]init];
            [weakSelf.headList addObject:@"门店"];
        }
        
        _singleShopList = [[NSMutableArray alloc]init];//存储单店角色
        NSMutableArray *arr1 = [[NSMutableArray alloc]init];//存储单店角色
        NSMutableArray *arr2 = [[NSMutableArray alloc]init];//存储连锁机构角色
        
        
        
        NSArray *arr = [json objectForKey:@"roleCommission"];
        if ([ObjectUtil isNotEmpty:arr]) {
            for (NSDictionary *dic in arr) {
                RoleCommissionVo *roleCommission =  [RoleCommissionVo convertToUser:dic];
                
                if (1 == roleCommission.roleType) {//门店
                    [arr1 addObject:roleCommission];
                    [_singleShopList addObject:roleCommission];
                } else if (2 == roleCommission.roleType){//机构
                    [arr2 addObject:roleCommission];
                }
            }
        }
        [weakSelf.detailMap setValue:arr2 forKey:@"机构"];
        [weakSelf.detailMap setValue:arr1 forKey:@"门店"];
        [weakSelf.mainGrid reloadData];
        weakSelf.mainGrid.ls_show = YES;
        
        // 选择机构或门店后，即使更新筛选数据源
//        TDFRegularCellModel *type = weakSelf.filterModels.lastObject;
        if (_roleType == 2) {
            // 非机构
//            type.updateOption = YES;
//            type.currentHideStatus = YES;
            
        } else {
            // 机构
//            type.updateOption = YES;
//            type.currentHideStatus = NO;
//            type.resetItemIndex = 0;
//            NSMutableArray *options = [NSMutableArray arrayWithCapacity:2];
//            for (NSString* key in weakSelf.headList) {
//                [options addObject:[TDFFilterItem filterItem:key itemValue:key]];
//            }
//            type.optionItems = [options copy];
        }
        [weakSelf.filterView renewListViewWithDatas:weakSelf.filterModels];
        
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}

@end

