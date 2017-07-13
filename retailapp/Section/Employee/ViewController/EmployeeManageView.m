//
//  EmployeeManageView.m
//  retailapp
//
//  Created by qingmei on 15/9/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "EmployeeManageView.h"
#import "EmployeeService.h"
#import "ServiceFactory.h"
#import "ISearchBarEvent.h"
#import "SearchBar2.h"
#import "UIHelper.h"
#import "UIView+Sizes.h"
#import "EmployeeRender.h"
#import "EmployeeEditView.h"
#import "EmlpoyeeUserIntroVo.h"
#import "SelectOrgShopListView.h"
#import "EmployeeCell.h"
#import "TDFComplexConditionFilter.h"
#import "TDFSimpleConditionFilter.h"
#import "LSEmployeeFilterModelFactory.h"
#import "LSFooterView.h"

@interface EmployeeManageView ()<ISearchBarEvent,TDFConditionFilterDelegate,UITableViewDelegate,UITableViewDataSource,LSFooterViewDelegate>

@property (strong, nonatomic) UITableView      *mainGrid;          //tableview
@property (strong, nonatomic) LSFooterView     *footView;          //页脚按钮
@property (strong, nonatomic) SearchBar2       *seachBar;          //搜索栏
@property (nonatomic, strong) TDFComplexConditionFilter *filterView;/**<筛选页面>*/
@property (nonatomic, strong) TDFSimpleConditionFilter *simpleFilterView;/**<简单筛选>*/
@property (nonatomic, strong) NSArray *filterModels;/**<筛选需要的数据>*/
@property (nonatomic, strong) EmployeeService   *service;           //网络服务
@property (nonatomic, assign) NSInteger         selectType;         //选择门店页面需要的参数 1.机构 2.门店
@property (nonatomic, assign) NSInteger         roleType;           //读取角色的type 1.门店 2.机构
@property (nonatomic, assign) NSInteger         currentPage;        //当前页
@property (nonatomic, assign) NSInteger         pageSize;           //总页数
@property (nonatomic, strong) NSString          *shopID;            //shopID
@property (nonatomic, assign) NSInteger         shopMode;           //1单店 2门店 3组织机构
@property (nonatomic, strong) NSString          *roleId;            //角色ID
@property (nonatomic, strong) NSMutableArray    *employeeIntroList; //员工简介列表
@property (nonatomic, strong) NSString          *keyWord;           //搜索条件
@property (nonatomic, strong) NSString          *selectShopCode;    //选中店铺的shopCode
@property (nonatomic, strong) NSString          *selectParentShopCode;//选中店的上级机构编号
@property (nonatomic, strong) NSString          *selectShopEntityId;/**<选择的机构门店的entityId>*/
@end

@implementation EmployeeManageView

- (void)viewDidLoad {
    [super viewDidLoad];
    _service = [ServiceFactory shareInstance].employeeService;
    self.shopMode = [[Platform Instance] getShopMode];
    self.shopID = [[Platform Instance] getkey:SHOP_ID];
    self.selectShopCode = [[Platform Instance] getkey:@"code"];
    self.roleId = nil;
    self.currentPage = 1;
    [self initMainView];
    [self loadRoleList];
    [self getParentShopCode];
    [self empolyeeInit];
    [self configHelpButton:HELP_EMPLOYEE_INFORMATION];
    [self loadEmployeeList];
}

- (void)initMainView{
    
    if (self.shopMode == 3) {
        self.selectType = 2;
        self.roleType = 2;
    } else {
        self.selectType = 1;
        self.roleType = 1;
    }
    
    //设置导航栏
    [self configTitle:@"员工" leftPath:Head_ICON_BACK rightPath:nil];
    
    // 搜索栏
    self.seachBar = [SearchBar2 searchBar2];
    [self.seachBar initDelagate:self placeholder:@"姓名/工号/手机号"];
    self.seachBar.ls_top = kNavH;
    [self.view addSubview:self.seachBar];
    
    // UITableView
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, self.seachBar.ls_bottom, SCREEN_W, SCREEN_H-self.seachBar.ls_bottom) style:UITableViewStylePlain];
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.showsVerticalScrollIndicator = NO;
    self.mainGrid.rowHeight = 88.0f;
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    [self.view addSubview:self.mainGrid];
    __weak EmployeeManageView* weakSelf = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadEmployeeList];
    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        weakSelf.currentPage ++;
        [weakSelf loadEmployeeList];
    }];
    
    //设置foot
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootAdd]];
    [self.footView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.footView];
    
    // 筛选
    if (self.shopMode == 3) {
        
        self.filterView = [[TDFComplexConditionFilter alloc] initFilter:@"筛选条件" image:@"ico_filter_normal" highlightImage:@"ico_filter_highlighted"];
        self.filterView.delegate = self;
        [self.filterView addToView:self.view withDatas:self.filterModels];
    }
}

// 门店/单店 右侧角色选择页
- (void)configRoleSelectView:(NSArray<TDFFilterItem *> *)roleItems {
    
    __weak typeof(self) wself = self;
    self.simpleFilterView = [[TDFSimpleConditionFilter alloc] initFilter:@"" image:@"ico_filter_jiaose" highlightImage:nil];
    [self.simpleFilterView addToView:self.view items:roleItems callBack:^(TDFFilterItem *filterItem) {
        wself.roleId = filterItem.itemValue;
        [wself loadEmployeeList];
    }];
}


- (NSMutableArray *)employeeIntroList {
    if (_employeeIntroList == nil) {
        _employeeIntroList = [[NSMutableArray alloc] init];
    }
    return _employeeIntroList;
}


- (NSArray *)filterModels {
    
    if (!_filterModels) {
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:2];
        if (self.shopMode == 3) {
            //连锁机构
            TDFTwiceCellModel *shopModel = [[TDFTwiceCellModel alloc] initWithType:TDF_TwiceFilterCellTwoLine optionName:@"机构/门店" hideStatus:NO];
            shopModel.arrowImageName = @"ico_next";
            shopModel.restName = [[Platform Instance] getkey:SHOP_NAME];
            shopModel.restValue = [[Platform Instance] getkey:SHOP_ID];
            [array addObject:shopModel];
        }
        
        //连锁门店/单店
        TDFRegularCellModel *role = [[TDFRegularCellModel alloc] initWithOptionName:@"角色" hideStatus:NO];
        role.resetItemIndex = 0;
        [array addObject:role];
        
        _filterModels = [array copy];
    }
    return _filterModels;
}

// 选择机构或门店
- (void)selectOrganizationOrShop {
    
    __weak typeof(self) weakSelf = self;
    SelectOrgShopListView *vc = [[SelectOrgShopListView alloc] init];
    [self pushController:vc from:kCATransitionFromRight];
    TDFTwiceCellModel *shopModel = self.filterModels.firstObject;
    [vc loadData:shopModel.currentValue withModuleType:2 withCheckMode:SINGLE_CHECK callBack:^(NSMutableArray *selectArr, id<ITreeItem> item) {
        if (item) {
            shopModel.currentName = [item obtainItemName];
            shopModel.currentValue = [item obtainItemId];
            weakSelf.selectShopCode = [item obtainItemValue];
            weakSelf.selectParentShopCode = [item obtainParentCode];
            weakSelf.selectShopEntityId = [item obtainShopEntityId];
            
            NSInteger selectShopType = [item obtainItemType];
            if (selectShopType == 2) {
                //门店
                self.selectType = 1;
                self.roleType = 1;
            } else {
                //公司、部门
                self.selectType = 2;
                self.roleType = 2;
            }
        }
        [weakSelf popToLatestViewController:kCATransitionFromLeft];
        [weakSelf loadRoleList];
    }];
}

#pragma mark - 代理方法 -
// TDFComplexConditionFilterDelegate
- (void)tdf_filter:(TDFComplexConditionFilter *)filter actionWithCellModel:(TDFFilterMoel *)model {
  
    if (model.type == TDF_TwiceFilterCellTwoLine) {
        
        [self selectOrganizationOrShop];
    } else if (model.type == TDF_RegularFilterCell) {
        
        TDFRegularCellModel *roleModel = [self.filterModels lastObject];
        self.roleId = roleModel.currentValue;
    }
}

- (BOOL)tdf_filterWillShow {
   return [self.seachBar endEditing:YES];
}

- (void)tdf_filterCompleted {
    [self loadEmployeeList];
}

// ISearchBarEvent
- (void)imputFinish:(NSString *)keyWord {
    //带上条件查询,角色信息清空
    self.keyWord = keyWord;
    self.roleId = nil;
    [self loadEmployeeList];
}

// LSFooterViewDelegate
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    
    if ([footerType isEqualToString:kFootAdd]) {
        EmployeeEditView *vc = [[EmployeeEditView alloc] initWithParent:self];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (self.shopMode == 3) {
            TDFTwiceCellModel *shopModel = self.filterModels.firstObject;
            [dic setValue:shopModel.currentName forKey:@"shopname"];
            [dic setValue:[NSNumber numberWithInteger:self.selectType] forKey:@"shoptype"];
            [dic setValue:shopModel.currentValue forKey:@"shopid"];
        }
        [dic setValue:self.selectShopEntityId forKey:@"shopEntityId"];
        [dic setValue:self.selectShopCode forKey:@"shopCode"];
        [dic setValue:self.selectParentShopCode forKey:@"parentShopCode"];
        [vc setShowType:YES];
        [vc initDataInAddTypeWithParam:dic];
        [self pushController:vc from:kCATransitionFromTop];
    }
}


#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (self.employeeIntroList!=nil?self.employeeIntroList.count:0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"employeeCell";
    EmployeeCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [EmployeeCell getInstance];
    }
    
    EmlpoyeeUserIntroVo *user = [self.employeeIntroList objectAtIndex:indexPath.row];
    [cell loadCell:user];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EmlpoyeeUserIntroVo *user = [self.employeeIntroList objectAtIndex:indexPath.row];
    EmployeeEditView *vc = [[EmployeeEditView alloc]initWithParent:self];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.selectShopCode forKey:@"shopCode"];
    [dic setValue:self.selectParentShopCode forKey:@"parentShopCode"];
    [vc loadDataWithUserID:user.userId WithParam:dic];
    [vc setShowType:NO];
    [self pushController:vc from:kCATransitionFromRight];
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width,88);
    UIView *view = [[UIView alloc]initWithFrame:rect];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

#pragma mark - 网络请求 - 
// 获取当前门店/机构的上级机构的机构码
- (void)getParentShopCode {
    __weak EmployeeManageView *weekSelf = self;
    NSString *shopId = [[Platform Instance] getkey:SHOP_ID];
    [_service selectOrgByShopId:shopId completionHandler:^(id json) {
        NSDictionary *dic = [json objectForKey:@"organization"];
        if ([ObjectUtil isNotEmpty:dic]) {
            weekSelf.selectParentShopCode = [ObjectUtil getStringValue:dic key:@"code"];
        }else{
            weekSelf.selectParentShopCode = [[Platform Instance] getkey:SHOP_CODE];;
        }
    } errorHandler:^(id json) {
        weekSelf.selectParentShopCode = [[Platform Instance] getkey:SHOP_CODE];;
    }];
}

// 请求的数据，本页面用不到，在别的界面需要用到(😂😂🤣)
- (void)empolyeeInit {
    __weak typeof(self) weakSelf = self;
    [_service employeeInitWithCompletionHandler:^(id json) {
        NSArray *identityTypeList = [json objectForKey:@"identityTypeList"];
        NSArray *sexList = [json objectForKey:@"sexList"];
        NSArray *roleList = [json objectForKey:@"roleList"];//全部的角色
        weakSelf.identityDicList = [EmployeeRender getItemVoListByDicVoList:identityTypeList];
        weakSelf.sexDicList = [EmployeeRender getItemVoListByDicVoList:sexList];
        weakSelf.roleDicList = [EmployeeRender getItemVoListByRoleList:roleList];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}

/**获取当前机构或者门店/单店的员工信息*/
- (void)loadEmployeeList {
    
    NSString *shopId;
    if (self.shopMode == 3) {
        
        TDFTwiceCellModel *shopModel = self.filterModels.firstObject;
        if (shopModel.currentValue && (![shopModel.currentValue isEqualToString:@""])) {
            shopId = shopModel.currentValue;
        } else {//没有选择 默认登陆的shopid
            [LSAlertHelper showAlert:@"请先选择门店。"];
            return;
        }
        
    } else {
        shopId = self.shopID;
    }
    

    __weak typeof(self) weakSelf = self;
    [_service selectEmployee:self.keyWord shopId:shopId roleId:self.roleId currentPage:weakSelf.currentPage shopType:weakSelf.selectType completionHandler:^(id json) {
        
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
        if (weakSelf.currentPage == 1) {
            [weakSelf.employeeIntroList removeAllObjects];
        }
        NSArray * arr = [json objectForKey:@"userList"];
        self.pageSize = [ObjectUtil getIntegerValue:json key:@"pageSize"];
        if ([ObjectUtil isNotEmpty:arr]) {
            for (NSDictionary *dic in arr) {
                [weakSelf.employeeIntroList addObject:[EmlpoyeeUserIntroVo convertToUser:dic]];
            }
        }
        [weakSelf.mainGrid reloadData];
        weakSelf.mainGrid.ls_show = YES;
    } errorHandler:^(id json) {
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
        [LSAlertHelper showAlert:json];
    }];
}

/** 获取机构或者店铺的角色列表
 角色分为两类：机构的角色，店铺的角色， 店铺只显示店铺级的角色，不会显示机构的角色；机构都显示
 */
- (void)loadRoleList {
    
    __weak typeof(self) weakSelf = self;
    NSString *keyWord = weakSelf.seachBar.keyWordTxt.text;
    [_service roleListByRoleName:keyWord roleType:weakSelf.roleType WithCompletionHandler:^(id json) {
        
        NSArray *arrDicVoList = [json objectForKey:@"roleVoList"];
        NSMutableArray *arr = [NSMutableArray array];
        //添加“全部”
        [arr addObject:[TDFFilterItem filterItem:@"全部" itemValue:nil]];
        //添加从服务器获取的
        if (arrDicVoList != nil && arrDicVoList.count > 0) {
            for (NSDictionary *dic in arrDicVoList) {
                NSString *name = [dic objectForKey:@"roleName"];
                NSString *roleId = [dic objectForKey:@"roleId"];
                [arr addObject:[TDFFilterItem filterItem:name itemValue:roleId]];
            }
        }
        
        if ([[Platform Instance] getShopMode] == 3) {
            
            TDFRegularCellModel *roleModel = self.filterModels.lastObject;
            roleModel.optionItems = [arr copy];
            roleModel.updateOption = YES;
            roleModel.resetItemIndex = 0;
            [weakSelf.filterView renewListViewWithDatas:weakSelf.filterModels];
            
        } else {
            
            [weakSelf configRoleSelectView:arr];
        }

//        [weakSelf loadEmployeeList];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}

@end
