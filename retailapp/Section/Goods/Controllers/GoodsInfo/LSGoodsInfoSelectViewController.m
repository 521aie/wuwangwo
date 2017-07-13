//
//  LSGoodsInfoSelectViewController.m
//  retailapp
//
//  Created by guozhi on 16/9/12.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#define TAG_LST_SHOP 1
#define TAG_LST_GOOD_NUM 2
#import "LSGoodsInfoSelectViewController.h"
#import "LSSearchBar.h"
#import "LSFooterView.h"
#import "KindMenuView.h"
#import "LSEditItemList.h"
#import "GoodsVo.h"
#import "ScanViewController.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "TreeNode.h"
#import "CategoryVo.h"
#import "XHAnimalUtil.h"
#import "LSGoodsListViewController.h"
#import "GoodsCategoryListView.h"
#import "GoodsService.h"
#import "ExportView.h"
#import "SelectOrgShopListView.h"
#import "ShopVo.h"
#import "LSGoodsEditView.h"

@interface LSGoodsInfoSelectViewController ()<LSFooterViewDelegate, LSSearchBarDelegate,  IEditItemListEvent, SingleCheckHandle, UIAlertViewDelegate, LSScanViewDelegate>

/**
 *  搜索框
 */
@property (nonatomic, strong) LSSearchBar *searchBar;
/**
 *  底部工具栏
 */
@property (nonatomic, strong) LSFooterView *footerView;
/**
 *  右侧筛选页面
 */
@property (nonatomic, strong) KindMenuView *kindMenuView;
/**
 *  门店
 */
@property (nonatomic, strong) LSEditItemList *lsShop;
/**
 *  商品总数
 */
@property (nonatomic, strong) LSEditItemList *lsGoodsNum;
/**
 *  搜索框内容
 */
@property (nonatomic, retain) NSString *searchCode;
/**
 *  扫一扫获得的内容
 */
@property (nonatomic, retain) NSString *barCode;
/**
 *  当前门店shopId
 */
@property (nonatomic, retain) NSString *shopId;
/**
 *  商品总数
 */
@property (nonatomic) int goodsCount;
/**
 *  商品分类数据源
 */
@property (nonatomic,retain) NSMutableArray* categoryList;
/**
 *  添加的商品对象
 */
@property (nonatomic, strong) GoodsVo* addGoodsVo;
/**
 *  搜索状态
 */
@property (nonatomic, strong) NSNumber *searchStatus;

@property (nonatomic, strong) GoodsService *goodsService;

@end

@implementation LSGoodsInfoSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTitle];
    [self initMainView];
    [self selectGoodsCount];
    [self configHelpButton:HELP_GOODS_INFO_LIST];
    
}

- (void)configTitle {
    [self configTitle:@"商品" leftPath:Head_ICON_BACK rightPath:nil];
    [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"分类" filePath:Head_ICON_CATE];
}

#pragma mark 初始化页面
- (void)initMainView {
    _goodsService = [[GoodsService alloc] init];
    //初始化标题栏
    CGFloat y = kNavH;
 
    
    if ([[Platform Instance] getShopMode] == 3) {
        //初始化机构门店
        self.lsShop = [LSEditItemList editItemList];
        [self.lsShop initLabel:@"机构/门店" withHit:nil delegate:self];
        [self.lsShop.line setHidden:YES];
        [self.lsShop.imgMore setImage:[UIImage imageNamed:@"ico_next"]];
        self.lsShop.tag = TAG_LST_SHOP;
        self.lsShop.ls_top = y;
        self.lsShop.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        [self.view addSubview:self.lsShop];
        [self.lsShop initData:[[Platform Instance] getkey:SHOP_NAME] withVal:[[Platform Instance] getkey:SHOP_ID]];
        y = y + self.lsShop.ls_height;
    }
    
    //初始化搜索框
    self.searchBar = [LSSearchBar searchBar];
    self.searchBar.placeholder = @"条形码/简码/拼音码";
    self.searchBar.delegate = self;
    self.searchBar.ls_top = y;
    [self.view addSubview:self.searchBar];
    y = y + self.searchBar.ls_height;
    
    //商品总数
    self.lsGoodsNum = [LSEditItemList editItemList];
    [self.lsGoodsNum initLabel:@"商品总数" withHit:nil delegate:self];
    [self.lsGoodsNum.line setHidden:YES];
    [self.lsGoodsNum.imgMore setImage:[UIImage imageNamed:@"ico_next"]];
    self.lsGoodsNum.tag = TAG_LST_GOOD_NUM;
    self.lsGoodsNum.ls_top = y;
    self.lsGoodsNum.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:self.lsGoodsNum];
    
    //初始化工具栏
    self.footerView = [LSFooterView footerView];
    y = self.view.ls_height - self.footerView.ls_height;
    self.footerView.ls_top = y;
    NSMutableArray* arr= nil;
    if (![[Platform Instance] lockAct:ACTION_GOODS_ADD]) {
        arr=[[NSMutableArray alloc] initWithObjects:kFootScan, kFootAdd, nil];
    } else {
        arr=[[NSMutableArray alloc] initWithObjects: kFootScan, nil];
    }
    if (![[Platform Instance] lockAct:ACTION_GOODS_SEARCH]) {
        [arr insertObject:kFootExport atIndex:1];
    }
    [self.footerView initDelegate:self btnsArray:arr];
    [self.view addSubview:self.footerView];
    self.shopId = [[Platform Instance] getkey:SHOP_ID];
}

#pragma mark 导航栏
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event == LSNavigationBarButtonDirectLeft) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self showKindMenuViewOfClickCateBtn];
    }
}
#pragma mark 显示筛选页面
- (void)showKindMenuViewOfClickCateBtn {
    __weak typeof(self) wself = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"1" forKey:@"hasNoCategory"];
    NSString *url = @"category/lastCategoryInfo";
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        NSMutableArray* list = [JsonHelper transList:[json objectForKey:@"categoryList"] objName:@"CategoryVo"];
        wself.categoryList = [[NSMutableArray alloc] init];
        TreeNode *vo = [[TreeNode alloc] init];
        vo.itemName = @"全部";
        vo.itemId = @"";
        [_categoryList addObject:vo];
        for (CategoryVo* vo in list) {
            TreeNode *vo1 = [[TreeNode alloc] init];
            vo1.itemName = vo.name;
            vo1.itemId = vo.categoryId;
            [wself.categoryList addObject:vo1];
        }
        
        [wself showKindMenuView];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

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


#pragma mark - 查询商品总数
- (void)selectGoodsCount {
    __weak typeof(self) wself = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.shopId forKey:@"shopId"];
    NSString *url = @"goods/goodsCount";
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        wself.goodsCount = [[json objectForKey:@"goodsCount"] intValue];
        [wself.lsGoodsNum initData:[NSString stringWithFormat:@"%d", wself.goodsCount] withVal:nil];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}

#pragma mark 筛选页面点击时间
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
        LSGoodsListViewController* vc = [[LSGoodsListViewController alloc] init];
        vc.synShopId = self.shopId;
        vc.synShopName = self.lsShop.lblVal.text;
        vc.searchCode = nil;
        vc.searchType = @"2";
        vc.shopId = self.shopId;
        vc.categoryId = node.itemId;
        vc.createTime = nil;
        vc.goodsList = nil;
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [self.navigationController pushViewController:vc animated:NO];

    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
   

}

#pragma mark 关闭筛选页面
- (void)closeSingleView:(NSInteger)event {
    GoodsCategoryListView* vc = [[GoodsCategoryListView alloc] initWithTag:GOODS_INFO_SELECT_VIEW];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark 扫一扫页面
- (void)showScanEvent {
    [self scanStart];
}
- (void)scanStart {
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    self.barCode = scanString;
    self.searchBar.txtField.text = scanString;
    __weak typeof(self) wself = self;
    [_goodsService selectGoodsList:@"1" shopId:self.shopId searchCode:self.searchCode barCode: self.barCode categoryId:@"" createTime:@"" validTypeList:nil completionHandler:^(id json) {
        wself.searchStatus = json[@"searchStatus"];
        NSMutableArray *goodsArray = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:[json objectForKey:@"goodsVoList"]]) {
            for (NSDictionary* dic in [json objectForKey:@"goodsVoList"]) {
                [goodsArray addObject:[GoodsVo convertToGoodsVo:dic]];
            }
        }
        if ([[json objectForKey:@"searchStatus"] integerValue] == 1) {
            if (goodsArray.count > 1) {
//                NSString* time = nil;
//                if ([ObjectUtil isNotNull:[json objectForKey:@"createTime"]]) {
//                    time = [[json objectForKey:@"createTime"] stringValue];
//                }
                LSGoodsListViewController * vc = [[LSGoodsListViewController alloc] init];
                vc.synShopId = wself.shopId;
                vc.synShopName = wself.lsShop.lblVal.text;
                vc.searchCode = wself.searchCode;
                vc.searchType = @"1";
                vc.shopId = wself.shopId;
                vc.categoryId = @"";
                vc.barCode = scanString;
                vc.goodsList = goodsArray;
                [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                [wself.navigationController pushViewController:vc animated:NO];
                [vc.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
            } else if (goodsArray.count == 1) {
                GoodsVo* vo = [goodsArray objectAtIndex:0];
                if ([[json objectForKey:@"searchStatus"] integerValue] == 1) {
                    LSGoodsEditView *vc = [[LSGoodsEditView alloc] init];
                    vc.goodsId = vo.goodsId;
                    vc.searchStatus = [json objectForKey:@"searchStatus"];
                    
                    vc.shopId = wself.shopId;
                    vc.synShopId = wself.shopId;
                    vc.synShopName = wself.lsShop.lblVal.text;
                    vc.action = ACTION_CONSTANTS_EDIT;
                    vc.viewTag = GOODS_INFO_SELECT_VIEW;
                    [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                    [wself.navigationController pushViewController:vc animated:NO];
                } else {
                    [wself selectGoodsDetail:vo];
                }
            } else if (goodsArray.count == 0){
                if (![[Platform Instance] lockAct:ACTION_GOODS_ADD]) {
                    UIAlertView *alertView;
                    if (alertView != nil) {
                        [alertView dismissWithClickedButtonIndex:0 animated:NO];
                        alertView = nil;
                    }
                    alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您查询的商品不存在，是否添加该商品?" delegate:wself cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
                    alertView.tag = 101;
                    [alertView show];
                }
                
            }
        } else if ([[json objectForKey:@"searchStatus"] integerValue] == 0 ) {
            if (![[Platform Instance] lockAct:ACTION_GOODS_ADD]) {
                UIAlertView *alertView;
                if (alertView != nil) {
                    [alertView dismissWithClickedButtonIndex:0 animated:NO];
                    alertView = nil;
                }
                alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您查询的商品不存在，是否添加该商品?" delegate:wself cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
                alertView.tag = 101;
                [alertView show];
            }
        } else {
            if (![[Platform Instance] lockAct:ACTION_GOODS_ADD]) {
                GoodsVo* vo = [goodsArray objectAtIndex:0];
                [wself selectGoodsDetail:vo];
            }
        }
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [AlertBox show:message];
}

#pragma mark 商品基础信息查询
- (void)selectGoodsDetail:(GoodsVo*) goodsVo
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
//                _addGoodsVo = goodsVo;
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

#pragma mark 添加按钮
- (void)showAddEvent
{
    LSGoodsEditView *vc = [[LSGoodsEditView alloc] init];
    vc.goodsId = nil;
    vc.shopId = self.shopId;
    vc.synShopId = self.shopId;
    vc.synShopName = self.lsShop.lblVal.text;
    vc.action = ACTION_CONSTANTS_ADD;
    vc.viewTag = GOODS_INFO_SELECT_VIEW;
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark 导出按钮
- (void)showExportEvent
{
    ExportView *vc = [[ExportView alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:_shopId forKey:@"shopId"];
    [vc loadData:dic withPath:@"goods/exportGoods" withIsPush:YES callBack:^{
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

#pragma mark IEditItemListEvent
- (void)onItemListClick:(EditItemList *)obj
{
    if (obj.tag == TAG_LST_SHOP) {
        //跳转页面至选择门店
        SelectOrgShopListView* selectOrgShopListView = [[SelectOrgShopListView alloc] init];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [self.navigationController pushViewController:selectOrgShopListView animated:NO];
        __weak typeof(self) wself = self;
        [selectOrgShopListView loadData:[obj getStrVal] withModuleType:3 withCheckMode:SINGLE_CHECK callBack:^(NSMutableArray *selectArr, id<ITreeItem> item) {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [wself.navigationController popToViewController:wself animated:NO];
            if (item) {
                ShopVo* vo1 = [[ShopVo alloc] init];
                vo1.shopName = [item obtainItemName];
                vo1.shopId = [item obtainItemId];
                [wself.lsShop initData:vo1.shopName withVal:vo1.shopId];
                wself.shopId = vo1.shopId;
                [wself selectGoodsCount];
            }
        }];
    } else if (obj.tag == TAG_LST_GOOD_NUM) {
        LSGoodsListViewController *vc = [[LSGoodsListViewController alloc] init];
        vc.synShopId = self.shopId;
        vc.synShopName = self.lsShop.lblVal.text;
        vc.searchCode = nil;
        vc.searchType = @"1";
        vc.shopId = self.shopId;
        vc.categoryId = @"";
        vc.createTime = nil;
        vc.goodsList = nil;
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [self.navigationController pushViewController:vc animated:NO];
        
    }
}

#pragma mark 搜索框输入完成方法
- (void)searchBarImputFinish:(NSString *)keyWord {
    self.searchCode = keyWord;
    self.barCode = @"";
    __weak typeof(self) wself = self;
    [_goodsService selectGoodsList:@"1" shopId:self.shopId searchCode:wself.searchCode barCode: self.barCode categoryId:@"" createTime:@"" validTypeList:nil completionHandler:^(id json) {
        NSMutableArray *goodsArray = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:[json objectForKey:@"goodsVoList"]]) {
            for (NSDictionary* dic in [json objectForKey:@"goodsVoList"]) {
                [goodsArray addObject:[GoodsVo convertToGoodsVo:dic]];
            }
        }
        if ([[json objectForKey:@"searchStatus"] integerValue] == 1) {
            if (goodsArray.count == 1) {
                GoodsVo* vo = [goodsArray objectAtIndex:0];
                LSGoodsEditView *vc = [[LSGoodsEditView alloc] init];
                vc.synShopId = wself.shopId;
                vc.synShopName = wself.lsShop.lblVal.text;
                vc.goodsId = vo.goodsId;
                vc.shopId = wself.shopId;
                vc.action = ACTION_CONSTANTS_EDIT;
                vc.viewTag = GOODS_INFO_SELECT_VIEW;
                [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                [wself.navigationController pushViewController:vc animated:NO];
            } else {
//                NSString* time = nil;
//                if ([ObjectUtil isNotNull:[json objectForKey:@"createTime"]]) {
//                    time = [[json objectForKey:@"createTime"] stringValue];
//                }
                LSGoodsListViewController *vc = [[LSGoodsListViewController alloc] init];
                vc.synShopId = wself.shopId;
                vc.synShopName = self.lsShop.lblVal.text;
                vc.searchCode = wself.searchCode;
                vc.searchType = @"1";
                vc.shopId = wself.shopId;
                vc.categoryId = @"";
                vc.createTime = nil;
                vc.goodsList = goodsArray;
                [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                [wself.navigationController pushViewController:vc animated:NO];
                [vc.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
        } else if ([[json objectForKey:@"searchStatus"] integerValue] == 0 ) {
            if (![[Platform Instance] lockAct:ACTION_GOODS_ADD]) {
                [wself selectGoodsDetail:nil];
            }
        } else {
            if (![[Platform Instance] lockAct:ACTION_GOODS_ADD]) {
                GoodsVo* vo = [goodsArray objectAtIndex:0];
                [wself selectGoodsDetail:vo];
            }
        }
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}

- (void)searchBarScanStart {
    [self showScanEvent];
}

#pragma mark 工具栏点击时间
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    } else if ([footerType isEqualToString:kFootExport]) {
        [self showExportEvent];
    } else if ([footerType isEqualToString:kFootScan]) {
        [self showScanEvent];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        if (buttonIndex == 1) {
            LSGoodsEditView *vc = [[LSGoodsEditView alloc] init];
            vc.synShopId = self.shopId;
            vc.synShopName = self.lsShop.lblVal.text;
            vc.addGoodsVo = [[GoodsVo alloc] init];
            vc.addGoodsVo.barCode = self.barCode;
            vc.goodsId = nil;
            vc.shopId = self.shopId;
            vc.action = ACTION_CONSTANTS_ADD;
            vc.viewTag = GOODS_INFO_SELECT_VIEW;
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
            [self.navigationController pushViewController:vc animated:NO];
        }
    } else if (alertView.tag == 102) {
        if (buttonIndex == 1) {
            LSGoodsEditView *vc = [[LSGoodsEditView alloc] init];
            vc.synShopId = self.shopId;
            vc.synShopName = self.lsShop.lblVal.text;
            if (_addGoodsVo == nil) {
                _addGoodsVo = [[GoodsVo alloc] init];
            }
            vc.addGoodsVo = _addGoodsVo;
            vc.goodsId = nil;
            //如果输入的是数字默认赋值到详情添加页
            if ([NSString isValidNumber:self.searchCode]) {
                vc.addGoodsVo.barCode = self.searchCode;
            }
            vc.shopId = self.shopId;
            vc.searchStatus = self.searchStatus;
            vc.action = ACTION_CONSTANTS_ADD;
            vc.viewTag = GOODS_INFO_SELECT_VIEW;
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
            [self.navigationController pushViewController:vc animated:NO];
        }
    }
    
}


@end
