//
//  RolePermission.m
//  retailapp
//
//  Created by qingmei on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "RolePermissionView.h"
#import "EmployeeService.h"
#import "ServiceFactory.h"
#import "SearchBar2.h"
#import "LSFooterView.h"
#import "SearchBar2.h"
#import "NameItemVO.h"
#import "LSRoleInfoController.h"
#import "RoleCell.h"
#import "HeaderItem.h"
#import "TDFSimpleConditionFilter.h"

@interface RolePermissionView ()<ISearchBarEvent, LSFooterViewDelegate, UITableViewDataSource, UITableViewDelegate, TDFConditionFilterDelegate>

@property (nonatomic, strong) UITableView      *mainGrid;  //tableview
@property (nonatomic, strong) LSFooterView     *footView;  //页脚按钮
@property (nonatomic, strong) SearchBar2       *searchBar; //搜索栏
@property (nonatomic ,strong) TDFSimpleConditionFilter *filterView;/**<筛选页>*/
@property (nonatomic ,strong) NSArray *filterItems;/**<类型items>*/
/**header列表*/
@property (nonatomic, strong) NSMutableArray *headList;
/**heder与cell内容的map*/
@property (nonatomic, strong) NSMutableDictionary *detailMap;
@property (nonatomic, strong) EmployeeService *service;       //员工网络服务
@property (nonatomic, strong) NSMutableArray *roleList;      //角色列表
@property (nonatomic, assign) NSInteger shopMode;       //1 单店 2连锁门店 3连锁组织机构
@property (nonatomic, assign) NSInteger roleType;       //角色类型 //1单店、机构门店角色 2机构组织角色
@property (nonatomic, strong) NSMutableArray *singleShopList;//存储单店角色的list,再单店模式时使用
@end

@implementation RolePermissionView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTitle:@"角色权限" leftPath:Head_ICON_BACK rightPath:nil];
     _service = [ServiceFactory shareInstance].employeeService;
    [self initMainView];
    [self loadData];
    [self configHelpButton:HELP_EMPLOYEE_ROLE_PERMISSION];
}

- (void)initMainView {
    
    self.shopMode = [[Platform Instance] getShopMode];
    if (self.shopMode == 3) {
        self.roleType = 2;//机构组织
    } else {
        self.roleType = 1;//机构门店、单店
    }
    

    // 搜索框
    self.searchBar = [SearchBar2 searchBar2];
    self.searchBar.ls_top = kNavH;
    [self.searchBar initDelagate:self placeholder:@"名称"];
    [self.view addSubview:self.searchBar];
    
    // 列表
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.ls_bottom, SCREEN_W, SCREEN_H-self.searchBar.ls_bottom) style:UITableViewStylePlain];
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.showsVerticalScrollIndicator = NO;
    self.mainGrid.rowHeight = 88.0f;
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    [self.view addSubview:self.mainGrid];
    

    //设置foot
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootAdd]];
    [self.view addSubview:self.footView];
    
    // 筛选
    if (self.shopMode == 3) {
        self.filterView = [[TDFSimpleConditionFilter alloc] initFilter:@"" image:@"ico_type_normal" highlightImage:@"ico_type_highlighted"];
        self.filterView.delegate = self;
        __weak typeof(self) wself = self;
        [self.filterView addToView:self.view items:self.filterItems callBack:^(TDFFilterItem *item) {
            [wself scroll:item.itemName];
        }];
    }
}


- (NSArray *)filterItems {
    if (!_filterItems) {
        
        _filterItems = @[[TDFFilterItem filterItem:@"机构" itemValue:@"机构"],
                         [TDFFilterItem filterItem:@"门店" itemValue:@"门店"]];
    }
    return _filterItems;
}


//根据header滚动
- (void)scroll:(NSString *)headerKey {
    if ([ObjectUtil isNotEmpty:self.headList] && [ObjectUtil isNotNull:headerKey]) {
        NSInteger index = [self.headList indexOfObject:headerKey];
        CGFloat offset = index * 40.f;//跳过的head所占的高度
        for (NSInteger i= 0; i<index; ++i) {
            NSString *headTemp = [self.headList objectAtIndex:i];
            if ([ObjectUtil isNotNull:headTemp]) {
                NSArray *roles = [self.detailMap objectForKey:headTemp];
                if ([ObjectUtil isNotEmpty:roles]) {
                    offset += 88.f * roles.count;//跳过的cell所占的高度
                }
            }
        }
        [self.mainGrid setContentOffset:CGPointMake(0, offset) animated:YES];
    }
}


// LSFooterViewDelegate
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootAdd]) {
        LSRoleInfoController *vc = [[LSRoleInfoController alloc] init];
        vc.action = ACTION_CONSTANTS_ADD;
        [vc initDataInAddType];
        [self pushController:vc from:kCATransitionFromRight];
    }
}


// TDFConditionFilterDelegate
- (BOOL)tdf_filterWillShow {
    return [self.searchBar endEditing:YES];
}

//- (void)tdf_filterCompleted {
//    if ([[Platform Instance] getShopMode] == 3) {
//        TDFRegularCellModel *type = self.filterModels.lastObject;
//        [self scroll:type.currentValue];
//    }
//}

// ISearchBarEvent
- (void)imputFinish:(NSString *)keyWord {
    [self loadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadData];
}


// UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.roleType != 1) {
        return (self.headList!=nil?self.headList.count:0);
    } else {
        return 1;
    }
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.roleType != 1) {
        NSString *head = [self.headList objectAtIndex:section];
        NSMutableArray *array = [self.detailMap objectForKey:head];
        return array.count;
    } else {
        return self.singleShopList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"RolePermissionCell";
    RoleCell* cell = (RoleCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [RoleCell getInstance];
    }
    if (self.roleType != 1) {
        NSString *head = [self.headList objectAtIndex:indexPath.section];
        if ([ObjectUtil isNotNull:head]) {
            NSMutableArray *details = [self.detailMap objectForKey:head];
            RoleVo *role = [details objectAtIndex:indexPath.row];
            [cell loadCell:role];
        }

    } else {
        RoleVo *role = [self.singleShopList objectAtIndex:indexPath.row];
        [cell loadCell:role];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RoleVo *role ;
    if (self.roleType != 1) {
        NSString *head = [self.headList objectAtIndex:indexPath.section];
        if ([ObjectUtil isNotNull:head]) {
            NSMutableArray *details = [self.detailMap objectForKey:head];
            role = [details objectAtIndex:indexPath.row];
        }
    } else {
        role = [self.singleShopList objectAtIndex:indexPath.row];
    }
    
    LSRoleInfoController *vc = [[LSRoleInfoController alloc] init];
    vc.action = ACTION_CONSTANTS_EDIT;
    [vc loadDataWithRoleID:role.roleId];
    [self pushController:vc from:kCATransitionFromRight];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    HeaderItem *headItem = [[[NSBundle mainBundle]loadNibNamed:@"HeaderItem" owner:self options:nil]lastObject];
    headItem.lbtitle.textColor = [UIColor whiteColor];
    NSString *kindMember = [self.headList objectAtIndex:section];
    [headItem initWithName:kindMember];
    return headItem;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.roleType != 1) {
        return 40.f;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == self.headList.count - 1) {
        CGRect rect = CGRectMake(0, 0, self.view.frame.size.width,88);
        UIView *view = [[UIView alloc]initWithFrame:rect];
        [view setBackgroundColor:[UIColor clearColor]];
        return view;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.headList.count - 1) {
        return 88;
    } else {
        return 0;
    }
}

#pragma mark - 网络请求 -
// 加载角色列表数据
- (void)loadData {
    
    __weak typeof(self) weakSelf = self;
    NSInteger selectRoleType;
    if (self.roleType == 2) {
        selectRoleType = 0;//连锁机构要同时查询门店和机构
    } else {
        selectRoleType = 1;//连锁门店、单店只需要查询门店
    }
    NSString *keyWord = weakSelf.searchBar.keyWordTxt.text;
    [_service roleListByRoleName:keyWord roleType:selectRoleType WithCompletionHandler:^(id json) {
    
        weakSelf.detailMap = [[NSMutableDictionary alloc] init];
        weakSelf.headList = nil;
        if (weakSelf.roleType != 1) {//连锁机构再去创建
            weakSelf.headList = [[NSMutableArray alloc]init];
            [weakSelf.headList addObject:@"机构"];
            [weakSelf.headList addObject:@"门店"];
        }
        
        NSArray *arrDicVoList = [json objectForKey:@"roleVoList"];
        weakSelf.singleShopList = [[NSMutableArray alloc] init];//存储单店角色
        NSMutableArray *arr1 = [[NSMutableArray alloc] init];//存储单店角色
        NSMutableArray *arr2 = [[NSMutableArray alloc] init];//存储连锁机构角色
        
        if ([ObjectUtil isNotEmpty:arrDicVoList]) {
            for (NSDictionary *dic in arrDicVoList) {
                
                RoleVo *roleVo = [RoleVo convertToUser:dic];
                if (1 == roleVo.roleType) {//1门店
                    [arr1 addObject:roleVo];
                    [_singleShopList addObject:roleVo];
                } else if (2 == roleVo.roleType){//2机构
                    [arr2 addObject:roleVo];
                }
            }
        }
        
        [weakSelf.detailMap setValue:arr2 forKey:@"机构"];
        [weakSelf.detailMap setValue:arr1 forKey:@"门店"];
        
        //保存起来,ModuleInfoView中有用到
        NameItemVO *name1 = [[NameItemVO alloc]initWithVal:@"门店" andId:@"1"];
        NameItemVO *name2 = [[NameItemVO alloc]initWithVal:@"机构" andId:@"2"];
        weakSelf.roleTypeDicVoList = [[NSMutableArray alloc] initWithObjects:name1,name2, nil];
        
        if (arr1.count > 0 && arr2.count >0) {
            self.filterView.hidden = NO;
        } else {
            self.filterView.hidden = YES;
        }
        
        [weakSelf.mainGrid reloadData];
        weakSelf.mainGrid.ls_show = YES;

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}
@end
