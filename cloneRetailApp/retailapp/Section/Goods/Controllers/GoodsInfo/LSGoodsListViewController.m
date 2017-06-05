//
//  LSGoodsListViewController.m
//  retailapp
//
//  Created by guozhi on 16/9/13.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSGoodsListViewController.h"
#import "GoodsVo.h"
#import "GoodsListCell.h"
#import "ObjectUtil.h"
#import "UIImageView+WebCache.h"
#import "NSString+Estimate.h"
#import "LSGoodsBatchViewController.h"
#import "XHAnimalUtil.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "CategoryVo.h"
#import "JsonHelper.h"
#import "TreeNode.h"
#import "KindMenuView.h"
#import "XHAnimalUtil.h"
#import "ObjectUtil.h"
#import "ViewFactory.h"
#import "GoodsCategoryListView.h"
#import "LSGoodsInfoSelectViewController.h"
#import "ColorHelper.h"
#import "ScanViewController.h"
#import "MyUILabel.h"
#import "LSFooterView.h"
#import "LSGoodsEditView.h"

@interface LSGoodsListViewController ()<LSScanViewDelegate, UITableViewDelegate, UITableViewDataSource, LSFooterViewDelegate>
@property (nonatomic, strong) GoodsService *goodsService;
@property (nonatomic, strong) GoodsVo *tempVo;
@property (nonatomic, strong) GoodsVo *addGoodsVo;
@property (nonatomic, strong) NSNumber *searchStatus;


/**
 *  底部工具栏
 */
@property (nonatomic, strong) LSFooterView *footerView;
@end

@implementation LSGoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainView];
    [self selectGoodsList];
    [self configHelpButton:HELP_GOODS_INFO_LIST];
    
}
#pragma mark 初始化数据
- (void)initMainView {
    _goodsService = [ServiceFactory shareInstance].goodsService;
    self.datas = [NSMutableArray array];
    CGFloat y = 0;
    //标题
    [self configTitle:@"商品" leftPath:Head_ICON_BACK rightPath:nil];
    [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"分类" filePath:Head_ICON_CATE];
    y = kNavH;
    
    //表格
    CGFloat tableViewX = 0;
    CGFloat tableViewY = y;
    CGFloat tableViewW = self.view.ls_width;
    CGFloat tableViewH = self.view.ls_height - kNavH;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    UIView* view=[ViewFactory generateFooter:88];
    view.backgroundColor=[UIColor clearColor];
    [self.tableView setTableFooterView:view];
    self.tableView.ls_top = y;
    __weak typeof(self) wself = self;
    [self.tableView ls_addHeaderWithCallback:^{
        wself.createTime = nil;
        [wself selectGoodsList];
    }];
    [self.tableView ls_addFooterWithCallback:^{
         [wself selectGoodsList];
    }];
    
    //底部工具栏
    NSArray *arr = nil;
    if (![[Platform Instance] lockAct:ACTION_GOODS_ADD] && (![[Platform Instance] lockAct:ACTION_GOODS_EDIT] || ![[Platform Instance] lockAct:ACTION_GOODS_DELETE] || ![[Platform Instance] lockAct:ACTION_MARKET_SET])) {
        arr = [[NSArray alloc] initWithObjects:kFootScan, kFootBatch, kFootAdd, nil];
    } else if ([[Platform Instance] lockAct:ACTION_GOODS_ADD] && (![[Platform Instance] lockAct:ACTION_GOODS_EDIT] || ![[Platform Instance] lockAct:ACTION_GOODS_DELETE] || ![[Platform Instance] lockAct:ACTION_MARKET_SET])) {
        arr = [[NSArray alloc] initWithObjects:kFootScan, kFootBatch, nil];
    } else if (![[Platform Instance] lockAct:ACTION_GOODS_ADD] && [[Platform Instance] lockAct:ACTION_GOODS_EDIT] && [[Platform Instance] lockAct:ACTION_GOODS_DELETE] && [[Platform Instance] lockAct:ACTION_MARKET_SET]) {
        arr = [[NSArray alloc] initWithObjects:kFootScan, kFootAdd, nil];
    } else {
        arr = [[NSArray alloc] initWithObjects:kFootScan, nil];
    }
    self.footerView = [LSFooterView footerView];
    [self.footerView initDelegate:self btnsArray:arr];
    y = self.view.ls_height - self.footerView.ls_height;
    self.footerView.ls_top = y;
    [self.view addSubview:self.footerView];

}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    } else if ([footerType isEqualToString:kFootBatch]) {
        [self showBatchEvent];
    } else if ([footerType isEqualToString:kFootScan]) {
        [self showScanEvent];
    }
}



- (void)loaddatas
{
    [self selectCategory];
    if (self.goodsList == nil) {
        [self selectGoodsList];
    }else{
        self.datas = [[NSMutableArray alloc] init];
        for (GoodsVo* vo in self.goodsList) {
            [self.datas addObject:vo];
        }
        [self.tableView reloadData];
        
        self.tableView.ls_show = YES;
    }
}

- (void)loadDatasFromEdit:(GoodsVo*) goodsVo action:(int) action
{
    self.barCode = @"";
    if (action == ACTION_CONSTANTS_DEL) {
        
        [self.datas removeObject:_tempVo];
        [self.tableView reloadData];
        
        self.tableView.ls_show = YES;
    }else if (action == ACTION_CONSTANTS_EDIT){
        _tempVo.goodsName = goodsVo.goodsName;
        _tempVo.retailPrice = goodsVo.retailPrice;
        _tempVo.image = goodsVo.image;
        _tempVo.filePath = goodsVo.filePath;
        _tempVo.upDownStatus = goodsVo.upDownStatus;
        _tempVo.barCode = goodsVo.barCode;
        [self.tableView reloadData];
        
    }else{
        self.createTime = nil;
        [self.tableView headerBeginRefreshing];
    }
}

- (void)loadDatasFromBatchSelectView
{
    [self.tableView headerBeginRefreshing];
}

#pragma 查询商品一览
- (void)selectGoodsList
{
    
    __weak typeof(self) wself = self;
    [_goodsService selectGoodsList:self.searchType shopId:self.shopId searchCode:self.searchCode barCode: self.barCode categoryId:self.categoryId createTime:self.createTime validTypeList:nil completionHandler:^(id json) {
        [wself responseSuccess:json];
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [wself.tableView headerEndRefreshing];
        [wself.tableView footerEndRefreshing];
    }];
}

#pragma 查询叶子节点分类一览
- (void)selectCategory
{
    __weak typeof(self) wself = self;
    [_goodsService selectLastCategoryInfo:@"1" completionHandler:^(id json) {
        [wself responseSuccess2:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)responseSuccess:(id)json
{
    if ([[json objectForKey:@"searchStatus"] integerValue] == 1) {
        NSMutableArray *array = [json objectForKey:@"goodsVoList"];
        if (self.createTime == nil) {
            [self.datas removeAllObjects];
        }
        for (NSDictionary* dic in array) {
            [self.datas addObject:[GoodsVo convertToGoodsVo:dic]];
        }
        
        if ([ObjectUtil isNotNull:[json objectForKey:@"createTime"]]) {
            self.createTime = [[json objectForKey:@"createTime"] stringValue];
        }
    }
    
    [self.tableView reloadData];
    self.tableView.ls_show = YES;
}

- (void)responseSuccess2:(id)json
{
    NSMutableArray* list = [JsonHelper transList:[json objectForKey:@"categoryList"] objName:@"CategoryVo"];
    
    self.categoryList = [[NSMutableArray alloc] init];
    TreeNode *vo = [[TreeNode alloc] init];
    vo.itemName = @"全部";
    vo.itemId = @"";
    [_categoryList addObject:vo];
    for (CategoryVo* vo in list) {
        TreeNode *vo1 = [[TreeNode alloc] init];
        vo1.itemName = vo.name;
        vo1.itemId = vo.categoryId;
        [self.categoryList addObject:vo1];
    }
}

#pragma 从商品分类页面返回
- (void)showKindMenuViewOfClickCateBtn
{
    __weak typeof(self) weakSelf = self;
    [_goodsService selectLastCategoryInfo:@"1" completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        NSMutableArray* list = [JsonHelper transList:[json objectForKey:@"categoryList"] objName:@"CategoryVo"];
        
        weakSelf.categoryList = [[NSMutableArray alloc] init];
        TreeNode *vo = [[TreeNode alloc] init];
        vo.itemName = @"全部";
        vo.itemId = @"";
        [_categoryList addObject:vo];
        for (CategoryVo* vo in list) {
            TreeNode *vo1 = [[TreeNode alloc] init];
            vo1.itemName = vo.name;
            vo1.itemId = vo.categoryId;
            [weakSelf.categoryList addObject:vo1];
        }
        
        [weakSelf showKindMenuView];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}


#pragma 显示添加商品页面
- (void)showAddEvent
{
    LSGoodsEditView *vc = [[LSGoodsEditView alloc] init];
    vc.synShopId = self.synShopId;
    vc.synShopName = self.synShopName;
    vc.goodsId = nil;
    vc.shopId = self.shopId;
    vc.action = ACTION_CONSTANTS_ADD;
    vc.viewTag = GOODS_LIST_VIEW;
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[LSGoodsInfoSelectViewController class]]) {
                LSGoodsInfoSelectViewController *listView = (LSGoodsInfoSelectViewController *)vc;
                [listView selectGoodsCount];
            }
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self showKindMenuViewOfClickCateBtn];
    }
}

#pragma 显示分类页面
- (void)showKindMenuView
{
    [self loadKindMenuView];
    [self.kindMenuView showMoveIn];
    if (![[Platform Instance] lockAct:ACTION_CATEGORY_MANAGE]) {
        [self.kindMenuView initDelegate:self event:0 isShowManagerBtn:YES];
    } else {
        [self.kindMenuView initDelegate:self event:0 isShowManagerBtn:NO];
    }
    [self.kindMenuView loadData:nil nodes:nil endNodes:self.categoryList];
    
}

/*加载分类页面*/
- (void)loadKindMenuView
{
    if (self.kindMenuView) {
        self.kindMenuView.view.hidden = NO;
    }else{
        self.kindMenuView = [[KindMenuView alloc] init];
        self.kindMenuView.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        self.kindMenuView.isAnimated = YES;
        if ([[Platform Instance] lockAct:ACTION_CATEGORY_MANAGE]) {//没有分类管理权限
            self.kindMenuView.isShowManagerBtn = NO;
        }
        [self.view addSubview:self.kindMenuView.view];
    }
}

#pragma mark 点击某个分类进行商品查询
- (void)singleCheck:(NSInteger)event item:(id<INameItem>)item
{
    TreeNode* node=(TreeNode*)item;
    if ([node.itemId isEqualToString:@"noCategory"]) {
        node.itemId = @"0";
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString* url = @"goods/list";
    [param setValue:@"2" forKey:@"searchType"];
    [param setValue:self.shopId forKey:@"shopId"];
    if ([NSString isNotBlank:node.itemId]) {
        [param setValue:node.itemId forKey:@"categoryId"];
    }
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        NSMutableArray *array = [json objectForKey:@"goodsVoList"];
        if ([ObjectUtil isEmpty:array]) {
            [AlertBox show:@"该分类下暂无符合条件的商品！"];
            return;
        }
        [self.kindMenuView hideMoveOut];
        self.categoryId = node.itemId;
        self.searchType = @"2";
        self.goodsList = nil;
        self.createTime = nil;
        self.searchCode = nil;
        [self.tableView headerBeginRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];

    
}

#pragma mark 跳转到商品分类一览
- (void)closeSingleView:(NSInteger)event
{
    GoodsCategoryListView* vc = [[GoodsCategoryListView alloc] initWithTag:GOODS_LIST_VIEW];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark 显示批量页面
- (void)showBatchEvent
{
    LSGoodsBatchViewController *vc = [[LSGoodsBatchViewController alloc] init];
    vc.shopId = self.shopId;
    vc.searchCode = self.searchCode;
    vc.searchType = self.searchType;
    vc.categoryId = self.categoryId;
    vc.barCode = self.barCode;
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark footer扫一扫按钮
- (void)showScanEvent
{
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

// LSScanViewDelegate
- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [AlertBox show:message];
}

- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    
    self.searchType = @"1";
    self.barCode = scanString;
    self.createTime = nil;
    
    __weak typeof(self) wself = self;
    [_goodsService selectGoodsList:self.searchType shopId:self.shopId searchCode:self.searchCode barCode: self.barCode categoryId:@"" createTime:@"" validTypeList:nil completionHandler:^(id json) {
//        wself.barCode = @"";//扫码添加商品如果不清空保存商品进到列表页面只会查到扫码商品
        wself.searchStatus = json[@"searchStatus"];
        NSMutableArray *goodsArray = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:[json objectForKey:@"goodsVoList"]]) {
            for (NSDictionary* dic in [json objectForKey:@"goodsVoList"]) {
                [goodsArray addObject:[GoodsVo convertToGoodsVo:dic]];
            }
        }
        if ([[json objectForKey:@"searchStatus"] integerValue] != 2) {
            if ([ObjectUtil isNotNull:[json objectForKey:@"createTime"]]) {
                wself.createTime = [[json objectForKey:@"createTime"] stringValue];
            }
        }
        self.tableView.ls_show = YES;
        if (goodsArray.count > 1) {
            [self.datas removeAllObjects];
            [self.datas addObjectsFromArray:goodsArray];
            [wself.tableView reloadData];
        } else if (goodsArray.count == 1) {
            
            GoodsVo* vo = [goodsArray objectAtIndex:0];
            if ([[json objectForKey:@"searchStatus"] integerValue] == 1) {
                LSGoodsEditView *vc = [[LSGoodsEditView alloc] init];
                vc.goodsId = vo.goodsId;
                vc.shopId = wself.shopId;
                vc.synShopId = wself.synShopId;
                vc.synShopName = wself.synShopName;
                vc.action = ACTION_CONSTANTS_EDIT;
                vc.viewTag = GOODS_LIST_VIEW;
//                [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                [wself.navigationController pushViewController:vc animated:NO];
            } else {
                [wself selectGoodsDetail:vo];
            }
        }else if (goodsArray.count == 0){
            UIAlertView *alertView;
            if (alertView != nil) {
                [alertView dismissWithClickedButtonIndex:0 animated:NO];
                alertView = nil;
            }
            alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您查询的商品不存在，是否添加该商品?" delegate:wself cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
            alertView.tag = 101;
            [alertView show];
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}


- (void)selectGoodsDetail:(GoodsVo *)goodsVo
{
    if (goodsVo == nil) {
        _addGoodsVo = nil;
        UIAlertView *alertView;
        if (alertView != nil) {
            [alertView dismissWithClickedButtonIndex:0 animated:NO];
            alertView = nil;
        }
        alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您查询的商品不存在，是否添加该商品?" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
        alertView.tag = 102;
        [alertView show];
    } else {
//        __weak typeof(self) wself = self;
//        [_goodsService selectGoodsBaseInfo:goodsVo.goodsId completionHandler:^(id json) {
//            GoodsVo* tempVo = [GoodsVo convertToGoodsVo:[json objectForKey:@"goodsVo"]];
//            if (tempVo != nil) {
//                _addGoodsVo = tempVo;
//            }
//            
//            UIAlertView *alertView;
//            if (alertView != nil) {
//                [alertView dismissWithClickedButtonIndex:0 animated:NO];
//                alertView = nil;
//            }
//            alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您查询的商品不存在，是否添加该商品?" delegate:wself cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
//            alertView.tag = 102;
//            [alertView show];
//        } errorHandler:^(id json) {
//            [AlertBox show:json];
//        }];
        _addGoodsVo = goodsVo;
        UIAlertView *alertView;
        if (alertView != nil) {
            [alertView dismissWithClickedButtonIndex:0 animated:NO];
            alertView = nil;
        }
        alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您查询的商品不存在，是否添加该商品?" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
        alertView.tag = 102;
        [alertView show];

    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        if (buttonIndex == 1) {
            LSGoodsEditView *vc = [[LSGoodsEditView alloc] init];
            vc.synShopId = self.synShopId;
            vc.synShopName = self.synShopName;
            vc.addGoodsVo = [[GoodsVo alloc] init];
            vc.addGoodsVo.barCode = self.barCode;
            vc.goodsId = nil;
            vc.shopId = nil;
            vc.action = ACTION_CONSTANTS_ADD;
            vc.viewTag = GOODS_LIST_VIEW;
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
            [self.navigationController pushViewController:vc animated:NO];
        }
    } else if (alertView.tag == 102) {
        if (buttonIndex == 1) {
            LSGoodsEditView *vc = [[LSGoodsEditView alloc] init];
            vc.synShopId = self.synShopId;
            vc.synShopName = self.synShopName;
            vc.addGoodsVo = _addGoodsVo;
            vc.goodsId = nil;
            vc.shopId = nil;
            vc.searchStatus = self.searchStatus;
            vc.action = ACTION_CONSTANTS_ADD;
            vc.viewTag = GOODS_LIST_VIEW;
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
            [self.navigationController pushViewController:vc animated:NO];
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _tempVo = [self.datas objectAtIndex:indexPath.row];
    LSGoodsEditView *vc = [[LSGoodsEditView alloc] init];
    vc.synShopId = self.synShopId;
    vc.synShopName = self.synShopName;
    vc.goodsId = _tempVo.goodsId;
    vc.shopId = self.shopId;
    vc.action = ACTION_CONSTANTS_EDIT;
    vc.viewTag = GOODS_LIST_VIEW;
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    [self.navigationController pushViewController:vc animated:NO];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsListCell *cell = [GoodsListCell goodsListCellWithTableView:tableView];;
    GoodsVo *goodsVo = [self.datas objectAtIndex:indexPath.row];
    cell.goodsVo = goodsVo;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}
  
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsVo *obj = self.datas[indexPath.row];
    return obj.cellHeight;
}

@end
