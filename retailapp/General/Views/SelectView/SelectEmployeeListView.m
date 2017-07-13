//
//  SelectEmployeeListView.m
//  retailapp
//
//  Created by qingmei on 15/10/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectEmployeeListView.h"
#import "NavigateTitle2.h"
#import "SearchBar2.h"
#import "EditItemList.h"

#import "SelectEmployeeCell.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "UIView+Sizes.h"
#import "EmlpoyeeUserIntroVo.h"
#import "TreeNode.h"

#import "KindMenuView.h"
#import "SelectOrgShopListView.h"

@interface SelectEmployeeListView ()<INavigateEvent,ISearchBarEvent,IEditItemListEvent,SingleCheckHandle>
@property (nonatomic, strong) EmployeeService       *employeeService;       //员工网络服务
@property (nonatomic, copy  ) SelectEmployeeHandler employeeHandler;        //block
@property (nonatomic, strong) NSString              *shopID;                //登陆者店铺ID
@property (nonatomic, strong) NSString              *selectShopID;          //选中的店铺ID
@property (nonatomic, strong) NSString              *roleId;                //角色ID
@property (nonatomic, strong) NSMutableArray        *employeeIntroList;     //员工简介列表
@property (nonatomic, assign) NSInteger             selectType;             //选择门店页面需要的参数
@property (nonatomic, assign) NSInteger             roleType;               //读取角色的type 1.门店 2.机构
@property (nonatomic, assign) NSInteger             currentPage;            //当前页

@end

@implementation SelectEmployeeListView
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.employeeService = [ServiceFactory shareInstance].employeeService;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shopMode = [[Platform Instance] getShopMode];
    self.shopID = [[Platform Instance]getkey:SHOP_ID];
    if (self.isSelfShop) {
        self.selectShopID = self.shopID;
    } else {
        if (self.shopMode == 3) {
            self.selectShopID = nil;
        }else{
            self.selectShopID = self.shopID;
        }
    }
    
    self.roleId = nil;
    
    [self initMainView];
    [self loadData];
}

- (void)initMainView{
    //设置导航栏
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    
    [self.titleBox initWithName:@"选择员工" backImg:Head_ICON_BACK moreImg:Head_ICON_CATE];
    self.titleBox.lblRight.text = @"角色";
    [self.view addSubview:self.titleBox];
        
    
    //设置searchbar
    [self.seachBar initDelagate:self placeholder:@"姓名/工号/手机号"];
    
    //设置itemlist
    [self layoutItemListWithViewType];
    
    __weak SelectEmployeeListView* weakSelf = self;
    [self.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData];
    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        weakSelf.currentPage ++;
        [weakSelf loadData];
    }];
}

#pragma mark - block
- (void)loadDataWithCallBack:(SelectEmployeeHandler)handler{
    self.employeeHandler = handler;
}





#pragma mark - netWork
- (void)responseSuccess:(id)json{
    
    self.employeeIntroList  =  [[NSMutableArray alloc]init];
    NSArray * arr = [json objectForKey:@"userList"];
    if ([ObjectUtil isNotEmpty:arr]) {
        for (NSDictionary *dic in arr) {
            [self.employeeIntroList addObject:[EmlpoyeeUserIntroVo convertToUser:dic]];
            
        }
    }
   
    [self.mainGrid reloadData];
    self.mainGrid.ls_show = YES;
}

- (void)responseRole:(id)json{
    
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


#pragma mark - 功能方法
- (void)layoutItemListWithViewType{
    
    if (self.shopMode == 3) {//连锁机构
        [self.itemListShopSelect initData:@"请选择" withVal:nil];
        self.selectType = 1;
        self.roleType = 2;
    } else if (self.shopMode == 2) {//连锁门店
        [self.itemListShopSelect visibal:NO];
        [self.itemListShopSelect initData:[[Platform Instance] getkey:SHOP_NAME] withVal:[[Platform Instance] getkey:SHOP_ID]];
        self.selectType = 2;
        self.roleType = 1;
    } else {//单店
        [self.itemListShopSelect visibal:NO];
        [self.itemListShopSelect initData:[[Platform Instance] getkey:SHOP_NAME] withVal:[[Platform Instance] getkey:SHOP_ID]];
        self.selectType = 2;//默认是1 门店
        self.roleType = 1;
    }
    
    if (3 == self.shopMode) {
        //显示门店选择框
        [self.itemListShopSelect initLabel:@"机构/门店" withHit:nil delegate:self];
        [self.itemListShopSelect setLs_height:40];
        self.itemListShopSelect.imgMore.image = [UIImage imageNamed:@"ico_next.png"];
        
        self.itemListShopSelect.line.hidden = YES;
        self.seachBar.ls_top = self.itemListShopSelect.ls_bottom;
        self.mainGrid.ls_top = self.seachBar.ls_bottom;
        self.mainGrid.ls_height -= self.itemListShopSelect.ls_height;
    }
    //不包括下属门店或机构的员工只查询自己的
    if (self.isSelfShop) {
        [self.itemListShopSelect visibal:NO];
        self.seachBar.ls_top = self.titleDiv.ls_bottom;
        self.mainGrid.ls_top = self.seachBar.ls_bottom;
        self.mainGrid.ls_height = self.view.ls_height - self.titleDiv.ls_height - self.seachBar.ls_height;
    }
}

//加载数据
- (void)loadData{

    
    NSString *shopId;
    
    if (self.shopMode == 3) {
        if ([ObjectUtil isNotNull:self.selectShopID]) {
            shopId = self.selectShopID;
        }
        else{
            shopId = nil;
            [self.mainGrid headerEndRefreshing];
            [self.mainGrid footerEndRefreshing];
        }
        
    }
    else{
        shopId = self.shopID;
    }
    
    __weak SelectEmployeeListView* weakSelf = self;
    if ([ObjectUtil isNotNull:shopId]) {
        [_employeeService selectEmployee:Nil shopId:shopId roleId:self.roleId currentPage:self.currentPage shopType:self.selectType completionHandler:^(id json) {
            if (!weakSelf) return ;
            [weakSelf.mainGrid headerEndRefreshing];
            [weakSelf.mainGrid footerEndRefreshing];
            [weakSelf responseSuccess:json];
        } errorHandler:^(id json) {
            [weakSelf.mainGrid headerEndRefreshing];
            [weakSelf.mainGrid footerEndRefreshing];
            [AlertBox show:json];
            
        }];
    }
    
}



#pragma mark - INavigateEvent代理  (导航)
- (void)onNavigateEvent:(Direct_Flag)event
{
    if (event==1) {
        if (_employeeHandler) {
            _employeeHandler(nil);
        }
    }else{
        __weak SelectEmployeeListView *weakSelf = self;
        [_employeeService roleListByRoleName:nil roleType:self.roleType WithCompletionHandler:^(id json) {
            if (!weakSelf) return ;
            [self responseRole:json];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];

    }
    
}

#pragma mark - IEditItemListEvent代理
- (void)onItemListClick:(EditItemList*)obj{
    
    if (obj == _itemListShopSelect) {
            __weak SelectEmployeeListView *weakSelf = self;
            SelectOrgShopListView *vc = [[SelectOrgShopListView alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:NO];
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
            [vc loadData:[obj getStrVal] withModuleType:2 withCheckMode:SINGLE_CHECK callBack:^(NSMutableArray *selectArr, id<ITreeItem> item) {
                if (item) {
                    [weakSelf.itemListShopSelect initData:[item obtainItemName] withVal:[item obtainItemId]];
                    self.selectShopID = [item obtainItemId];
                }
                NSInteger selectShopType = [item obtainItemType];
                if (selectShopType == 2) {
                    //门店
                    self.selectType = 2;
                    self.roleType = 1;
                }else{
                    //公司、部门
                    self.selectType = 1;
                    self.roleType = 2;
                }
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                [self.navigationController popViewControllerAnimated:NO];
                
                [self loadData];
            }];
            
        }

}

#pragma mark - SingleCheckHandle代理  ('更多'页面事件)
-(void) singleCheck:(NSInteger)event item:(id<INameItem>)item
{
   
    NSString *shopId;
    if (self.shopMode == 3) {
        if ([ObjectUtil isNotNull:self.selectShopID]) {
            shopId = self.selectShopID;
        }
        else{//没有选择 默认登陆的shopid
            shopId = nil;
        }
        
    }
    else{
        shopId = self.shopID;
    }
    
    TreeNode* node=(TreeNode*)item;
    if ([ObjectUtil isNotNull:node]) {
        if ([node.itemId isEqualToString:@"0"] && [ObjectUtil isNotNull:node.itemId]) {
            self.roleId = nil;//roleId为nil时,会去查询全部的角色
        }else{
            self.roleId  = node.itemId;
        }
    }
   
     __weak SelectEmployeeListView* weakSelf = self;
    if ([ObjectUtil isNotNull:shopId]) {
        [_employeeService selectEmployee:Nil shopId:shopId roleId:self.roleId currentPage:0 shopType:self.selectType completionHandler:^(id json) {
            if (!weakSelf) return ;
            [weakSelf responseSuccess:json];
        } errorHandler:^(id json) {
            [AlertBox show:json];
            
        }];
    }
    [self.selectKindMenuView hideMoveOut];
}
-(void) closeSingleView:(NSInteger)event
{
    [self.selectKindMenuView hideMoveOut];
}


#pragma mark - ISearchBarEvent代理 (搜索)
- (void)imputFinish:(NSString *)keyWord{
    //带上条件去查询
    
    NSString *shopId;
    if (self.shopMode == 3) {
        if ([ObjectUtil isNotNull:self.selectShopID]) {
            shopId = self.selectShopID;
        }
        else{//没有选择 默认登陆的shopid
            shopId = nil;
        }
        
    }
    else{
        shopId = self.shopID;
    }
    

    __weak SelectEmployeeListView* weakSelf = self;
    if ([ObjectUtil isNotNull:shopId]) {
        [_employeeService selectEmployee:keyWord shopId:shopId roleId:self.roleId currentPage:0 shopType:self.selectType completionHandler:^(id json) {
            if (!weakSelf) return ;
            [weakSelf responseSuccess:json];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }else{
        [AlertBox show:@"请选择机构/门店."];
    }
    
    
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (self.employeeIntroList!=nil?self.employeeIntroList.count:0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"selectEmployeeCell";
    SelectEmployeeCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [SelectEmployeeCell getInstance];
    }
    
    EmlpoyeeUserIntroVo *user = [self.employeeIntroList objectAtIndex:indexPath.row];
    if ([self.selectedUerId isEqualToString:user.userId]) {
        cell.imgCheck.hidden = NO;
        cell.imgUncheck.hidden = YES;
    }else{
        cell.imgCheck.hidden = YES;
         cell.imgUncheck.hidden = NO;
    }
    [cell loadCell:user];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EmlpoyeeUserIntroVo *user = [self.employeeIntroList objectAtIndex:indexPath.row];
    NSMutableDictionary *dic = [user getDic:user];
    if ([ObjectUtil isNotNull:self.selectShopID]) {
        [dic setValue:self.selectShopID forKey:@"shopid"];
    }
    //通过block传递回调用页面
    self.employeeHandler(dic);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
   
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width,88);
    UIView *view = [[UIView alloc]initWithFrame:rect];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 88;
 
}



@end
