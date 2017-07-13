//
//  SubOrgShopListView.m
//  retailapp
//
//  Created by hm on 15/8/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SubOrgShopListView.h"
#import "SearchBar2.h"
#import "ViewFactory.h"
#import "ColorHelper.h"
#import "ServiceFactory.h"
#import "XHAnimalUtil.h"
#import "ShopCell.h"
#import "AlertBox.h"
#import "SubOrgVo.h"
#import "ColorHelper.h"
#import "OrgBranchListView.h"
#import "SearchBar2.h"
#import "LSFooterView.h"
#import "LSChainShopInfoController.h"
#import "LSOrgInfoController.h"

@interface SubOrgShopListView ()<ISearchBarEvent,LSFooterViewDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) SettingService* settingService;
/**tableview数据源*/
@property (nonatomic,strong) NSMutableArray* data;
/**机构id*/
@property (nonatomic,copy) NSString* orginizationId;
/**机构名称*/
@property (nonatomic,copy) NSString* orginizationName;
/**检索关键词*/
@property (nonatomic,copy) NSString* keyWord;
/**分页*/
@property (nonatomic) NSInteger currentPage;
//是否是最末级机构
@property (nonatomic) BOOL isLeaf;
/**下级机构门店数据模型*/
@property (nonatomic,strong) SubOrgVo* subOrgVo;
/**是否有添加门店权限*/
@property (nonatomic) BOOL isShopAddLock;
@property (nonatomic,strong) SearchBar2* searchBar;
@property (nonatomic,strong) UITableView* mainGrid;
@property (nonatomic,strong) LSFooterView * footView;
@end

@implementation SubOrgShopListView
@synthesize settingService;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    settingService = [ServiceFactory shareInstance].settingService;
    [self initNavigate];
    [self configViews];
    [self addHeaderAndFooter];
    [self loadData:self.orginizationId withPage:self.currentPage withKeyWord:self.keyWord];
    [self reload];
}

- (void)configViews {
    self.searchBar = [SearchBar2 searchBar2];
    //设置查询代理
    [self.searchBar initDelagate:self placeholder:@"名称/编号"];
    [self.view addSubview:self.searchBar];
    __weak typeof(self) wself = self;
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
    
}


- (void)addHeaderAndFooter
{
    __weak SubOrgShopListView* weakSelf = self;
    //下拉刷新
    [self.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.currentPage = 1;
        [weakSelf loadData:weakSelf.orginizationId withPage:weakSelf.currentPage withKeyWord:weakSelf.keyWord];
    }];
    //上拉加载
    [self.mainGrid ls_addFooterWithCallback:^{
        weakSelf.currentPage++;
        [weakSelf loadData:weakSelf.orginizationId withPage:weakSelf.currentPage withKeyWord:weakSelf.keyWord];
    }];
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.tableFooterView = [ViewFactory generateFooter:BOTTOM_HEIGHT];
}

#pragma mark - 添加门店的权限
- (void)reload
{
    self.isShopAddLock = [[Platform Instance] lockAct:ACTION_SHOP_ADD];
    self.footView.hidden = self.isShopAddLock;
}

#pragma mark - 初始化导航
//•如果登录的机构用户是第4级的用户，标题显示“下属门店”
//•如果登录的机构用户是第1～3级的用户，标题显示“下属机构/门店”
- (void)initNavigate
{
    [self configTitle:@"下属机构/门店" leftPath:Head_ICON_BACK rightPath:nil];
    [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"分支" filePath:Head_ICON_CATE];
    [self configTitle:self.isLeaf?@"下属门店":@"下属机构/门店"];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        //返回
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        //分支
        OrgBranchListView* orgBranchListView = [[OrgBranchListView alloc] init];
        orgBranchListView.organizationId = self.orginizationId;
        [self.navigationController pushViewController:orgBranchListView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        orgBranchListView = nil;
    }
    
}

//设置页面参数
- (void)loadData:(NSString*)organizationId withOrgName:(NSString *)orgName withParent:(BOOL)hasParent
{
    self.orginizationId = organizationId;
    self.orginizationName = orgName;
    self.isLeaf = hasParent;
    self.currentPage = 1;
    self.keyWord = @"";
    self.data = [NSMutableArray array];
}

#pragma mark - 下属机构列表
- (void)loadData:(NSString*)orginizationId withPage:(NSInteger)currentPage withKeyWord:(NSString*)keyWord
{
    NSString* page = [NSString stringWithFormat:@"%ld",(long)currentPage];
    __weak SubOrgShopListView* weakSelf = self;
    [settingService selectSubOrgInfo:orginizationId withPage:page withKeyWord:keyWord completionHandler:^(id json) {
        NSArray* arrList = [SubOrgVo converToSubOrgList:[json objectForKey:@"sonList"]];
        if (weakSelf.currentPage==1) {
            [weakSelf.data removeAllObjects];
        }
        [weakSelf.data addObjectsFromArray:arrList];
        //最末级机构并且没有门店添加权限
        weakSelf.footView.hidden = (weakSelf.isLeaf&&weakSelf.isShopAddLock);
        [weakSelf.mainGrid reloadData];
        weakSelf.mainGrid.ls_show = YES;
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
}


#pragma mark - 检索条件
- (void)imputFinish:(NSString *)keyWord
{
    self.keyWord = keyWord;
    self.currentPage=1;
    [self.mainGrid headerBeginRefreshing];
}

#pragma mark - 添加机构/门店

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    }
}
- (void)showAddEvent
{
    if (self.isLeaf) {
        //添加门店
        [self addShop];
    }else{
        UIActionSheet * alertView = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"添加机构",@"添加门店", nil];
        [alertView showInView:[UIApplication sharedApplication].keyWindow];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        //添加机构
        [self addOrginization];
    }else if(buttonIndex==1){
        [self addShop];
    }
}

- (void)addShop
{
    //添加门店
//    ChainShopInfoView* chainShopInfoView = [[ChainShopInfoView alloc] initWithNibName:[SystemUtil getXibName:@"ChainShopInfoView"] bundle:nil];
    LSChainShopInfoController *chainShopInfoView = [[LSChainShopInfoController alloc] init];
    chainShopInfoView.isLogin = NO;
    chainShopInfoView.superOrgId = self.orginizationId;
    chainShopInfoView.superOrgName = self.orginizationName;
    chainShopInfoView.action = ACTION_CONSTANTS_ADD;
    [chainShopInfoView changChainInfo:^(id<INameValue> item, NSInteger action) {
        [self.mainGrid headerBeginRefreshing];
    }];
    [self.navigationController pushViewController:chainShopInfoView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    chainShopInfoView= nil;
}

- (void)addOrginization
{
    //添加机构
//    OrgInfoView* orgInfoView = [[OrgInfoView alloc] initWithNibName:[SystemUtil getXibName:@"OrgInfoView"] bundle:nil];
    LSOrgInfoController *orgInfoView = [[LSOrgInfoController alloc] init];
    orgInfoView.isLogin = NO;
    orgInfoView.action = ACTION_CONSTANTS_ADD;
    orgInfoView.organizationId = self.orginizationId;
    orgInfoView.organizationName = self.orginizationName;
    [orgInfoView changeOrgInfo:^(id<INameValue> item, NSInteger action) {
        [self.mainGrid headerBeginRefreshing];
    }];
    [self.navigationController pushViewController:orgInfoView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    orgInfoView = nil;
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* shopCellId = @"ShopCell";
    ShopCell* cell = [tableView dequeueReusableCellWithIdentifier:shopCellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ShopCell" bundle:nil] forCellReuseIdentifier:shopCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:shopCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.data.count>0&&indexPath.row<self.data.count) {
        ShopCell* detailItem = (ShopCell*)cell;
        SubOrgVo* orgVo = [self.data objectAtIndex:indexPath.row];
        detailItem.lblNo.textColor = [ColorHelper getBlueColor];
        detailItem.lblName.text = orgVo.name;
        detailItem.lblNo.text = (orgVo.type==2)?[NSString stringWithFormat:@"门店编号:%@",orgVo.code]:[NSString stringWithFormat:@"机构编号:%@",orgVo.code];
        [detailItem showImg:(orgVo.type==2) withType:1];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    self.subOrgVo = [self.data objectAtIndex:row];
    if (self.subOrgVo.type==2) {
        //进入门店信息页面
//        ChainShopInfoView* chainShopInfoView = [[ChainShopInfoView alloc] initWithNibName:[SystemUtil getXibName:@"ChainShopInfoView"] bundle:nil];
        LSChainShopInfoController *chainShopInfoView = [[LSChainShopInfoController alloc] init];
        chainShopInfoView.isLogin = NO;
        chainShopInfoView.action = ACTION_CONSTANTS_EDIT;
        chainShopInfoView.shopId = self.subOrgVo._id;
        chainShopInfoView.shopEntityId = self.subOrgVo.entityId;
        [chainShopInfoView changChainInfo:^(id<INameValue> item, NSInteger action) {
            if (item) {
                if (action==ACTION_CONSTANTS_DEL) {
                    [self.data removeObject:self.subOrgVo];
                }else{
                    self.subOrgVo.name = [item obtainItemName];
                    self.subOrgVo.code = [item obtainItemValue];
                }
                [self.mainGrid reloadData];
            }
        }];
        [self.navigationController pushViewController:chainShopInfoView animated:NO];
        chainShopInfoView = nil;
    }else{
        //进入机构详情页面
//        OrgInfoView* orgInfoView = [[OrgInfoView alloc] initWithNibName:[SystemUtil getXibName:@"OrgInfoView"] bundle:nil];
        LSOrgInfoController *orgInfoView = [[LSOrgInfoController alloc] init];
        orgInfoView.isLogin = NO;
        orgInfoView.action = ACTION_CONSTANTS_EDIT;
        orgInfoView.organizationId = self.subOrgVo._id;
        [orgInfoView changeOrgInfo:^(id<INameValue> item, NSInteger action) {
            if (item) {
                if (action==ACTION_CONSTANTS_DEL) {
                    [self.data removeObject:self.subOrgVo];
                }else{
                    self.subOrgVo.name = [item obtainItemName];
                    self.subOrgVo.code = [item obtainItemValue];
                }
                [self.mainGrid reloadData];
            }
        }];
        [self.navigationController pushViewController:orgInfoView animated:NO];
        orgInfoView = nil;
    }
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

@end
