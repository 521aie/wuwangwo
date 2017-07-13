//
//  SelectStaffListView.m
//  retailapp
//
//  Created by hm on 16/3/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectStaffListView.h"
#import "ServiceFactory.h"
#import "EmlpoyeeUserIntroVo.h"
#import "SelectEmployeeCell.h"
#import "XHAnimalUtil.h"
#import "KindMenuView.h"
#import "AlertBox.h"
#import "TreeNode.h"

@interface SelectStaffListView ()<ISearchBarEvent,SingleCheckHandle>
@property (nonatomic, strong) EmployeeService *employeeService;
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *selectId;
@property (nonatomic, copy) CallBack callBack;
@property (nonatomic ,assign) NSInteger currentPage;
//|1机构|2门店|
@property (nonatomic ,assign) NSInteger shopType;
//角色类型（|1门店|2机构|）
@property (nonatomic ,assign) NSInteger roleType;
//角色id
@property (nonatomic, copy) NSString *roleId;
//检索关键词
@property (nonatomic, copy) NSString *keyWord;
/**角色一览*/
@property (nonatomic, strong) KindMenuView *selectKindMenuView;
@end

@implementation SelectStaffListView
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.employeeService = [ServiceFactory shareInstance].employeeService;
    }
    return self;
}

- (void)loadDataById:(NSString *)shopId selectId:(NSString *)selectId roleType:(NSInteger)roleType callBack:(CallBack)callBack
{
    self.shopId = shopId;
    self.selectId = selectId;
    self.roleType = roleType;
    self.shopType = (roleType == 1)?2:1;
    self.callBack = callBack;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    [self.searchBar initDelagate:self placeholder:@"姓名/工号/手机号"];
    [self addHeaderAndFooter];
    self.footView.hidden = YES;
    [self loadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化导航
- (void)initNavigate
{
    [self configTitle:@"选择员工" leftPath:Head_ICON_BACK rightPath:nil];
    [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"角色" filePath:Head_ICON_CHOOSE];
    
  }

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event == LSNavigationBarButtonDirectLeft) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        __weak typeof(self) wself = self;
        [self.employeeService roleListByRoleName:nil roleType:self.roleType WithCompletionHandler:^(id json) {
            [wself responseRole:json];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

#pragma mark - 角色一览
- (void)responseRole:(id)json
{
    NSArray *arrDicVoList = [json objectForKey:@"roleVoList"];
    NSMutableArray *arr = [NSMutableArray array];
    //添加“全部”
    TreeNode *voAll = [[TreeNode alloc] init];
    voAll.itemName = @"全部";
    voAll.itemId = @"0";
    [arr addObject:voAll];
    if ([ObjectUtil isNotEmpty:arrDicVoList]) {
        for (NSDictionary* dic in arrDicVoList)
        {
            NSString *name = [dic objectForKey:@"roleName"];
            NSString *roleId = [dic objectForKey:@"roleId"];
            TreeNode *vo1 = [[TreeNode alloc] init];
            vo1.itemName = name;
            vo1.itemId = roleId;
            [arr addObject:vo1];
        }
    }
    if (_selectKindMenuView == nil) {
        _selectKindMenuView = [[KindMenuView alloc] init];
        _selectKindMenuView.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        [self.view addSubview:_selectKindMenuView.view];
    }
    [self.selectKindMenuView initDelegate:self event:0 isShowManagerBtn:NO];
    [self.selectKindMenuView loadData:nil nodes:nil endNodes:arr];
    self.selectKindMenuView.view.hidden = NO;
}

#pragma mark - SingleCheckHandle代理
- (void)singleCheck:(NSInteger)event item:(id<INameItem>)item
{
    [self.selectKindMenuView hideMoveOut];
    TreeNode* node=(TreeNode*)item;
    if ([@"0" isEqualToString:[node obtainItemId]]) {
        self.roleId = nil;
    }else{
        self.roleId = node.itemId;
    }
    self.keyWord = nil;
    self.searchBar.keyWordTxt.text = @"";
    [self loadData];
}

- (void)closeSingleView:(NSInteger)event
{
    [self.selectKindMenuView hideMoveOut];
}

#pragma mark - 添加刷新控件
- (void)addHeaderAndFooter
{
    __weak typeof(self) wself = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        wself.currentPage = 1;
        [wself loadData];
    }];
    
    [self.mainGrid ls_addFooterWithCallback:^{
        wself.currentPage += 1;
        [wself loadData];
    }];
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
}

#pragma mark - 检索条件
- (void)imputFinish:(NSString *)keyWord
{
    self.keyWord = keyWord;
    [self loadData];
}

#pragma mark - 加载员工列表数据
- (void)loadData
{
    __weak typeof(self) wself = self;
    [self.employeeService selectEmployee:self.keyWord shopId:self.shopId roleId:self.roleId currentPage:self.currentPage shopType:self.shopType completionHandler:^(id json) {
        wself.dataList  =  [[NSMutableArray alloc]init];
        NSArray * arr = [json objectForKey:@"userList"];
        if ([ObjectUtil isNotEmpty:arr]) {
            for (NSDictionary *dic in arr) {
                [wself.dataList addObject:[EmlpoyeeUserIntroVo convertToUser:dic]];
            }
        }
        [wself.mainGrid reloadData];
        wself.mainGrid.ls_show = YES;
        [wself.mainGrid headerEndRefreshing];
        [wself.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark - 表格
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"selectEmployeeCell";
    SelectEmployeeCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SelectEmployeeCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    [cell.imgCheck setHidden:YES];
    [cell setNeedsDisplay];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectEmployeeCell* detailItem = (SelectEmployeeCell*)cell;
    if (self.dataList.count>0&&indexPath.row<self.dataList.count) {
        EmlpoyeeUserIntroVo* user = [self.dataList objectAtIndex:indexPath.row];
        [detailItem loadCell:user];
        [detailItem.imgCheck setHidden:(![user.userId isEqualToString:self.selectId])];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EmlpoyeeUserIntroVo *user = [self.dataList objectAtIndex:indexPath.row];
    if (self.callBack) {
        self.callBack(user);
    }
}


@end
