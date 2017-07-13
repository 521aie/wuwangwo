//
//  MainPageShowView.m
//  retailapp
//
//  Created by qingmei on 15/9/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MainPageShowView.h"
#import "ISearchBarEvent.h"
#import "EmployeeService.h"
#import "ServiceFactory.h"
#import "SearchBar2.h"
#import "HomeShowVo.h"
#import "MainPageSetCell.h"
#import "MainPageDetailView.h"
#import "HeaderItem.h"
//#import "TDFComplexConditionFilter.h"
#import "TDFSimpleConditionFilter.h"

@interface MainPageShowView ()<ISearchBarEvent, UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic ,strong) TDFSimpleConditionFilter *filterView;/**<右侧筛选view>*/
@property (nonatomic ,strong) NSArray *filterItems; /**<筛选需要的数据模型>*/
@property (nonatomic, strong) SearchBar2   *searchBar; //搜索栏
@property (nonatomic, strong) UITableView  *mainGrid;  //tabelview
@property (nonatomic, strong) EmployeeService   *service;           //网络服务
@property (nonatomic, strong) NSMutableArray    *roleList;          //更多页面中的List
@property (nonatomic, strong) NSMutableArray    *homeShowVoList;    //主页显示设置Vo
@property (nonatomic, assign) NSInteger         shopMode;           //1 单店 2连锁门店 3连锁组织机构
@property (nonatomic, assign) NSInteger         roleType;           //连锁模式  //1单店模式 2连锁模式
@property (nonatomic, strong) NSMutableArray    *singleShopList;    //单店list,如果是单店模式时使用
@end

@implementation MainPageShowView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shopMode = [[Platform Instance] getShopMode];
    if (self.shopMode == 3) {
        self.roleType = 2;
    } else {
        self.roleType = 1;
    }
    _service = [ServiceFactory shareInstance].employeeService;
    [self initMainView];
    [self homepageSettingInit];
}


- (void)initMainView{

    // 导航
    [self configTitle:@"主页显示设置" leftPath:Head_ICON_BACK rightPath:nil];
    
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
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
    self.mainGrid.rowHeight = 88.0f;
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    [self.view addSubview:self.mainGrid];
    
    // 筛选
    if (self.shopMode == 3) {
        self.filterView = [[TDFSimpleConditionFilter alloc] initFilter:@"" image:@"ico_type_normal" highlightImage:@"ico_type_highlighted"];
        __weak typeof(self) wself = self;
        [self.filterView addToView:self.view items:self.filterItems callBack:^(TDFFilterItem *item) {
            [wself scroll:item.itemName];
        }];
    }
    [self configHelpButton:HELP_EMPLOYE_MAIN_PAGE_SHOW_SETTING];
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


- (NSArray *)filterItems {
    if (!_filterItems) {

        _filterItems = @[[TDFFilterItem filterItem:@"机构" itemValue:@"机构"],
                             [TDFFilterItem filterItem:@"门店" itemValue:@"门店"]];
    }
    return _filterItems;
}



// ISearchBarEvent
- (void)imputFinish:(NSString *)keyWord {
    [self reload];
}

//// TDFConditionFilterDelegate
//- (BOOL)tdf_filterWillShow {
//   return [self.searchBar endEditing:YES];
//}
//
//- (void)tdf_filterCompleted {
//    if ([[Platform Instance] getShopMode] == 3) {
//        TDFRegularCellModel *type = self.filterModels.lastObject;
//        [self scroll:type.currentValue];
//    }
//}


// UITableViewDelegate ,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.roleType != 1) {
        return (self.headList!=nil?self.headList.count:0);
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.roleType != 1) {
        NSString *head = [self.headList objectAtIndex:section];
        NSMutableArray *array = [self.detailMap objectForKey:head];
        return array.count;
    }
    return self.singleShopList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"homePageSetCell";
    MainPageSetCell* cell = (MainPageSetCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [MainPageSetCell getInstance];
    }
    
    if (self.roleType != 1) {
        NSString *head = [self.headList objectAtIndex:indexPath.section];
        if ([ObjectUtil isNotNull:head]) {
            NSMutableArray *details = [self.detailMap objectForKey:head];
            HomeShowVo *homeShowVo = [details objectAtIndex:indexPath.row];
            [cell loadCell:homeShowVo];
        }
    } else {
        HomeShowVo *homeShowVo = [self.singleShopList objectAtIndex:indexPath.row];
        [cell loadCell:homeShowVo];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeShowVo *homeShowVo ;
    if (self.roleType != 1) {
        NSString *head = [self.headList objectAtIndex:indexPath.section];
        if ([ObjectUtil isNotNull:head]) {
            NSMutableArray *details = [self.detailMap objectForKey:head];
            homeShowVo = [details objectAtIndex:indexPath.row];
        }
    } else {
        homeShowVo = [self.singleShopList objectAtIndex:indexPath.row];
    }
    
    MainPageDetailView *vc = [[MainPageDetailView alloc] init];
    vc.homeShowVo = homeShowVo;
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
        return 40;
    }
    return 0;
}

#pragma mark - 网络请求 - 
// 主页显示角色一览
- (void)reload {
    
    NSInteger selectRoleType;
    if (self.roleType == 2) {
        selectRoleType = 0;//连锁机构要同时查询门店和机构
    }else{
        selectRoleType = 1;//连锁门店、单店只需要查询门店
    }
    NSString *keyWord = self.searchBar.keyWordTxt.text;
    __weak MainPageShowView* weakSelf = self;
    [_service homepageRoleListByRoleName:keyWord roleType:selectRoleType completionHandler:^(id json) {
        
        weakSelf.detailMap = nil;
        weakSelf.detailMap = [[NSMutableDictionary alloc]init];
        
        
        weakSelf.headList = nil;
        if (weakSelf.roleType != 1) {//连锁机构再去创建
            weakSelf.headList = [[NSMutableArray alloc]init];
            [weakSelf.headList addObject:@"机构"];
            [weakSelf.headList addObject:@"门店"];
        }
        
        _singleShopList = [[NSMutableArray alloc]init];//存储单店角色
        NSMutableArray *arr1 = [[NSMutableArray alloc]init];//存储门店
        NSMutableArray *arr2 = [[NSMutableArray alloc]init];//存储机构
        
        NSArray *arr = [json objectForKey:@"homeShowVoList"];
        for (NSDictionary *dic in arr) {
            HomeShowVo *homeShowVo =  [HomeShowVo convertToUser:dic];
            
            if (1 == homeShowVo.roleType) {
                [arr1 addObject:homeShowVo];
                [_singleShopList addObject:homeShowVo];
            } else if (2 == homeShowVo.roleType){
                [arr2 addObject:homeShowVo];
            }
        }
        
        if (arr1.count > 0 && arr2.count >0) {
            self.filterView.hidden = NO;
        } else {
            self.filterView.hidden = YES;
        }
        
        [weakSelf.detailMap setValue:arr2 forKey:@"机构"];
        [weakSelf.detailMap setValue:arr1 forKey:@"门店"];
        
        [weakSelf.mainGrid reloadData];
        weakSelf.mainGrid.ls_show = YES;
        
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}

// 主页排序设置初始化
- (void)homepageSettingInit {
    
    __weak MainPageShowView* weakSelf = self;
    [_service homepageSettingInitWithCompletionHandler:^(id json) {
        [weakSelf reload];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}
@end
