//
//  MainPageSortView.m
//  retailapp
//
//  Created by qingmei on 15/10/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MainPageDetailView.h"
#import "ColorHelper.h"
#import "INavigateEvent.h"
#import "FooterListEvent.h"
#import "MainPageDetailCell.h"
#import "SortView.h"
#import "MainPageShowView.h"
#import "EmployeeService.h"
#import "HomeShowVo.h"
#import "LSEditItemView.h"
#import "HeaderItem.h"
#import "ServiceFactory.h"
#import "FooterMultiView.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "LSFooterView.h"

@interface MainPageDetailView ()<LSFooterViewDelegate ,MainPageDetailCellDelegate,SortViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) EmployeeService   *service;       //网络服务
@property (nonatomic, strong) HomeShowVo        *homeShowVoOld; //保存初始化的vo
@property (nonatomic, strong) HomeShowVo        *homeShowVoSort;//保存经过排序的vo,排序完成会赋值给homeShowVo
@property (nonatomic, assign) NSInteger         showCount;      //显示项的数目
@property (nonatomic, assign) NSInteger         sortChangeCount;//显示项的数目
@property (nonatomic, strong) NSMutableArray    *cellList;      //保存所有cell
//tableview
@property (nonatomic, strong) UITableView  *mainGrid;      //tableview

//footview
@property (strong, nonatomic) LSFooterView *footView;    //页脚按钮

//角色名称
@property (strong, nonatomic) LSEditItemView *vewRoleName;        //角色名称

/** <#注释#> */
@property (nonatomic, strong) HeaderItem *viewHeader;
@end

@implementation MainPageDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initMainView];
    [self configHelpButton:HELP_EMPLOYE_MAIN_PAGE_SHOW_SETTING];
}

- (void)initMainView{
    _service = [ServiceFactory shareInstance].employeeService;
    //设置导航栏
    if ([ObjectUtil isNotNull:self.homeShowVo.roleName]) {
        [self configTitle:self.homeShowVo.roleName  leftPath:Head_ICON_BACK rightPath:nil];
    }
    
    //角色名
    CGFloat y = kNavH;
    self.vewRoleName = [LSEditItemView editItemView];
    self.vewRoleName.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.vewRoleName.ls_top = y;
    [self.vewRoleName initLabel:@"角色名" withHit:nil];
    self.vewRoleName.line.hidden = YES;
    [self.view addSubview:self.vewRoleName];
    
    y = y + self.vewRoleName.ls_height;
    
    self.mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_W, SCREEN_H - y)];
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 40)];
    UILabel *lbl = [LSViewFactor addExplainText:footerView text:@"提示：以上内容的排列顺序与首页一致，可以对其进行排序。" y:0];
    footerView.ls_height = lbl.ls_height;
    footerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.mainGrid.tableFooterView = footerView;
    [self.view addSubview:self.mainGrid];
    
    self.viewHeader = [HeaderItem headerItem];
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootSort]];
    [self.view addSubview:self.footView];
    self.footView.ls_bottom = SCREEN_H;
    [self loadByhomeShowVo:self.homeShowVo];
}

#pragma mark - 功能函数
- (void)save{
    __weak MainPageDetailView* weakSelf = self;
    for (int i=0; i<_homeShowVo.showTypeVoList.count; i++) {
        ShowTypeVo *temp = _homeShowVo.showTypeVoList[i];
        temp.sortCode = i+1;
    }
    NSString *shopId =[[Platform Instance]getkey:SHOP_ID];
    [_service homepageSettingSaveByRoleId:_homeShowVo.roleId shopId:shopId showTypeVoList:_homeShowVo.showTypeVoList completionHandler:^(id json) {
        if (!weakSelf) return ;
        [self.mainGrid reloadData];
        self.sortChangeCount = 0;//保存后重置变化状态
        [self isUIChange];
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[MainPageShowView class]]) {
                [(MainPageShowView *)obj reload];
            }
        }];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
       
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}
/**判断数据是否变化,来更新UI的变化*/
- (BOOL)isUIChange{
    
    NSInteger changeCount = 0;
    //判断cell里的开关是否变化
    for (int i = 0 ; i < _homeShowVo.showTypeVoList.count; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        MainPageDetailCell* cell = (MainPageDetailCell *)[self.mainGrid cellForRowAtIndexPath:index];
        if (cell) {
            if ([cell isDataChange]) {
                changeCount += 1;
            }
        }
    }

    if (self.sortChangeCount > 0 || changeCount > 0) {
        [self configTitle:self.homeShowVo.roleName leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
    }else{
         [self configTitle:self.homeShowVo.roleName leftPath:Head_ICON_BACK rightPath:nil];
    }
    
    return YES;
}


#pragma mark - network
- (void)loadByhomeShowVo:(HomeShowVo *)homeShowVo{
    self.homeShowVoOld = homeShowVo;
    NSString *shopId =[[Platform Instance]getkey:SHOP_ID];
    __weak MainPageDetailView* weakSelf = self;
    [_service homepageDetailByRoleId:homeShowVo.roleId shopId:shopId completionHandler:^(id json) {
        if (!weakSelf) return ;
        [weakSelf responseSuccess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}
- (void)responseSuccess:(id)json{
    
    _homeShowVo = nil;
    NSDictionary *dic = [json objectForKey:@"homeShowVo"];
    _homeShowVo = [HomeShowVo convertToUser:dic];
    _homeShowVoSort = [HomeShowVo convertToUser:dic];
    
    //角色名称
    if ([ObjectUtil isNotNull:self.homeShowVo.roleName]) {
        [self configTitle:self.homeShowVo.roleName leftPath:Head_ICON_BACK rightPath:nil];
    //        self.lblRoleName.text = _homeShowVo.roleName;
        
        [self.vewRoleName initData:_homeShowVo.roleName];
    }
    
    
    //主页显示内容
    _showCount = 0;
    if ([ObjectUtil isNotEmpty:_homeShowVo.showTypeVoList]) {
        for (ShowTypeVo *showTypeVo in self.homeShowVo.showTypeVoList) {
            if (showTypeVo.isShow) {
                _showCount += 1;
            }
        }
    }
   
    [self.viewHeader initWithName:[NSString stringWithFormat:@"主页显示内容: %ld",(long)_showCount]];
    
    [self.mainGrid reloadData];
}
#pragma mark - FooterListEvent代理

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootSort]) {
        [self showSortEvent];
    }
}
-(void) showSortEvent{
    
    //生成排序页面需要的列表数据
    NSMutableArray *sortObjArr = [NSMutableArray array];
    if ([ObjectUtil isNotEmpty:_homeShowVo.showTypeVoList]) {
        for (ShowTypeVo *showTypeVo in self.homeShowVo.showTypeVoList) {
            SortObject *object = [[SortObject alloc]init];
            object.objectId = showTypeVo.showType;
            object.objectName = showTypeVo.showTypeName;
            object.sortCode = showTypeVo.sortCode;
            [sortObjArr addObject:object];
        }
    }
    SortView *vc = [[SortView alloc]initWithSourceList:sortObjArr andDelegate:self];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    
}
#pragma mark - SortViewDelegate代理  (排序)
/**取消*/
- (void)SortViewCancel{
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
    [self.navigationController popViewControllerAnimated:NO];
}
/**保存*/
- (void)SortViewSave{
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
    [self.navigationController popViewControllerAnimated:NO];
    _homeShowVo = _homeShowVoSort;
    //点了保存认为经过了排序变化
    self.sortChangeCount += 1;
    [self isUIChange];
    [self.mainGrid reloadData];
}
/**排序事件*/
- (void)SortViewMoveRowAtIndexPath:(NSInteger )sourceIndexPath toIndexPath:(NSInteger )destinationIndexPath{
    NSMutableArray * tempArr = [NSMutableArray arrayWithArray:_homeShowVoSort.showTypeVoList];
    id object=[tempArr objectAtIndex:sourceIndexPath];
    [tempArr removeObjectAtIndex:sourceIndexPath];
    [tempArr insertObject:object atIndex:destinationIndexPath];
    _homeShowVoSort.showTypeVoList = tempArr;

}

#pragma mark - INavigateEvent代理  (导航)
-(void) onNavigateEvent:(LSNavigationBarButtonDirect)event{
    if (event==LSNavigationBarButtonDirectLeft) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
        
    } else {
        [self save];
    }
}
#pragma mark - MainPageDetailCellDelegate
- (void)clickBtnRadio:(MainPageDetailCell *)cell{
    NSIndexPath * indexPath = [self.mainGrid indexPathForCell:cell];
    ShowTypeVo *tempVo = [_homeShowVo.showTypeVoList objectAtIndex:indexPath.row];
    tempVo.isShow = cell.shopTpyeVo.isShow;
    if (tempVo.isShow) {
        _showCount += 1;
    }else{
        _showCount -= 1;
    }
    [self.viewHeader initWithName:[NSString stringWithFormat:@"主页显示内容: %ld",(long)_showCount]];
    
    [self isUIChange];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _homeShowVo.showTypeVoList.count>0?1:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _homeShowVo.showTypeVoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *cellIdentifier = @"MainPageSortCell";
    MainPageDetailCell* cell = (MainPageDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [MainPageDetailCell getInstance];
    }
    
    ShowTypeVo *tempVo = [_homeShowVo.showTypeVoList objectAtIndex:indexPath.row];
    cell.delegate = self;
    
    [cell loadCell:tempVo];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.viewHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}



@end
