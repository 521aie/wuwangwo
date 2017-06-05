//
//  GoodsBatchChoiceView1.m
//  retailapp
//
//  Created by zhangzhiliang on 15/11/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsBatchChoiceView1.h"
#import "GoodsVo.h"
#import "ObjectUtil.h"
#import "UIImageView+WebCache.h"
#import "NSString+Estimate.h"
#import "NavigateTitle2.h"
#import "SearchBar.h"
#import "XHAnimalUtil.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "LSFooterView.h"
#import "ViewFactory.h"
#import "GoodsGiftVo.h"
#import "KindMenuView.h"
#import "TreeNode.h"
#import "GoodsBatchChoiceCell.h"
#import "GoodsChoiceView.h"
#import "ScanViewController.h"
#import "StockService.h"
#import "LSWechatGoodListViewController.h"
#import "LSWechatGoodManageViewController.h"
#import "LSGoodsEditView.h"

@interface GoodsBatchChoiceView1 ()<LSScanViewDelegate,SingleCheckHandle, UIActionSheetDelegate, LSFooterViewDelegate, ISearchBarEvent, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) GoodsService* goodsService;
@property (nonatomic, strong) CommonService *commonService;
@property (nonatomic, strong) LogisticService *logisticService;
@property (nonatomic, strong) NSMutableArray *categoryList;
@property (nonatomic, strong) NSMutableArray *goodsList;
@property (nonatomic, strong) UITableView *mainGrid;
@property (nonatomic, strong) LSFooterView *footerView;
@property (nonatomic, strong) SearchBar *searchBar;
@property (nonatomic, strong) KindMenuView *kindMenuView;
@property (nonatomic, strong) GoodsVo *goodsVo;
/**
 跳转页面的tag
 */
@property (nonatomic, assign) int goodsChoiceViewTag;

/**
 1表示为从搜索框搜索，当查询出来为一条信息时，跳转到下一个页面
 */
@property (nonatomic) short isJump;
@property (nonatomic, strong) GoodsVo *addGoodsVo;
@end

@implementation GoodsBatchChoiceView1

- (instancetype)init {
    self = [super init];
    if (self) {
        self.goodsService = [ServiceFactory shareInstance].goodsService;
        self.commonService = [ServiceFactory shareInstance].commonService;
        self.logisticService = [ServiceFactory shareInstance].logisticService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubviews];
    _mode = _mode==0?1:_mode;
    [self loadDatas];
}

- (void)configSubviews {
    [self configTitle:@"选择商品" leftPath:Head_ICON_BACK rightPath:nil];
    [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"分类" filePath:Head_ICON_CATE];
    
    // 搜索框
    _searchBar = [SearchBar searchBar];
    _searchBar.ls_top = kNavH;
    [_searchBar initDeleagte:self placeholder:@"条形码/简码/拼音码"];
    if ([NSString isNotBlank:_searchCode]) {
        _searchBar.keyWordTxt.text = _searchCode;
    }
    [self.view addSubview:_searchBar];
    
    // TableView
    _mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchBar.ls_bottom, SCREEN_W, SCREEN_H-_searchBar.ls_bottom) style:UITableViewStylePlain];
    _mainGrid.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainGrid.backgroundColor = [UIColor clearColor];
    _mainGrid.tableFooterView = [ViewFactory generateFooter:88];
    _mainGrid.rowHeight = 64.0;
    _mainGrid.delegate = self;
    _mainGrid.dataSource = self;
    [self.view addSubview:_mainGrid];
    __weak typeof(self) weakSelf = self;
    [weakSelf.mainGrid ls_addHeaderWithCallback:^{
        weakSelf.createTime = @"";
        if ([NSString isBlank:weakSelf.inShopId]) {
            if (self.alertGoodListParam) {
                weakSelf.currentPage = 1;
                [weakSelf selectAlertGoodsList];
            } else {
                [weakSelf selectGoodsList];
            }
        } else {
            [weakSelf selectAllocateGoodsList];
        }
    }];
    [weakSelf.mainGrid ls_addFooterWithCallback:^{
        
        if ([NSString isBlank:weakSelf.inShopId]) {
            if (self.alertGoodListParam) {
                weakSelf.currentPage ++;
                [weakSelf selectAlertGoodsList];
            } else {
                [weakSelf selectGoodsList];
            }
        } else {
            [weakSelf selectAllocateGoodsList];
        }
    }];
    
    _footerView = [LSFooterView footerView];
    [_footerView initDelegate:self btnsArray:@[kFootSelectAll,kFootSelectNo]];
    [self.view addSubview:_footerView];
}

- (void)loadDatas {
    if (_goodsChoiceViewTag == GOODS_CHOICE_VIEW) {
        [self configTitle:@"选择商品" leftPath:Head_ICON_CANCEL rightPath:nil];
        [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"分类" filePath:Head_ICON_CATE];
        [_mainGrid reloadData];
        _mainGrid.ls_show = YES;
        
    } else {
        [self.mainGrid headerBeginRefreshing];
    }
    
}

- (void)loaddatas:(NSString *)shopId callBack:(SelectGoodsBatchBack)callBack {
   
    _selectGoodsBatchBack = callBack;
    self.searchBar.keyWordTxt.text = @"";
    self.shopId = shopId;
    self.searchType = @"1";
    self.categoryId = @"";
    self.createTime = @"";
    self.barCode = @"";
    self.searchCode = @"";
    _goodsList = [[NSMutableArray alloc] init];

    if (self.mode == 2 && self.alertGoodListParam.count)
    {
        self.datas = [[NSMutableArray alloc] init];
//        [self selectAlertGoodsList];
    }
    
    [self selectCategory];
}

- (void)loaddatas:(NSString *)shopId condition:(NSMutableDictionary *)condition goodsList:(NSMutableArray *)goodsList callBack:(SelectGoodsBatchBack)callBack {
   
    _goodsChoiceViewTag = GOODS_CHOICE_VIEW;
    self.selectGoodsBatchBack = callBack;
    self.searchBar.keyWordTxt.text = @"";
    self.shopId = shopId;
    self.searchType = [condition objectForKey:@"searchType"];
    self.createTime = [condition objectForKey:@"createTime"];
    self.categoryId = [condition objectForKey:@"categoryId"];
    self.barCode = [condition objectForKey:@"barCode"];
    self.datas = [[NSMutableArray alloc] init];
    self.goodsList = [[NSMutableArray alloc] init];
    if (goodsList != nil && goodsList.count > 0) {
        self.datas = goodsList;
        for (GoodsVo *vo in self.datas) {
            vo.isCheck =@"0";
        }
    }
    [self selectCategory];
}

//<<<<<<< HEAD
//=======
//- (void)selectGoodsList {
//    
//    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:8];
//    [param setValue:self.searchType forKey:@"searchType"];
//    if ([NSString isNotBlank:self.shopId]) {
//        [param setValue:self.shopId forKey:@"shopId"];
//    }
//    if ([NSString isNotBlank:self.searchCode]) {
//        [param setValue:self.searchCode forKey:@"searchCode"];
//    }
//    if ([NSString isNotBlank:self.barCode]) {
//        [param setValue:self.barCode forKey:@"barCode"];
//    }
//    if ([NSString isNotBlank:self.categoryId]) {
//        [param setValue:self.categoryId forKey:@"categoryId"];
//    }
//    if ([NSString isNotBlank:self.createTime]) {
//        [param setValue:self.createTime forKey:@"createTime"];
//    }
//    if ([NSString isNotBlank:self.supplyId]) {
//        //供应商Id
//        [param setValue:self.supplyId forKey:@"supplyId"];
//    }
//    if ([NSString isNotBlank:self.isReturn]) {
//        //标示当前是否获取退货价 1为获取 2 不获取
//        [param setValue:self.isReturn forKey:@"isReturn"];
//    }
//    [param setValue:[NSNumber numberWithInteger:self.mode] forKey:@"mode"];
//    [param setValue:[NSNumber numberWithBool:self.getStockFlg] forKey:@"getStockFlg"];
//    [param setValue:self.warehouseId forKey:@"warehouseId"];
//    [param setValue:self.validTypeList forKey:@"validTypeList"];
//    __weak GoodsBatchChoiceView1* weakSelf = self;
//    [self.commonService selectGoodsList:param completionHandler:^(id json) {
//        [weakSelf responseSuccess:json];
//        [weakSelf.mainGrid headerEndRefreshing];
//        [weakSelf.mainGrid footerEndRefreshing];
//    } errorHandler:^(id json) {
//        [AlertBox show:json];
//        [weakSelf.mainGrid headerEndRefreshing];
//        [weakSelf.mainGrid footerEndRefreshing];
//    }];
//}
//
//
//// 获取可以添加库存提醒的商品列表
//- (void)selectAlertGoodsList {
//    
//    __weak typeof(self) weakself = self;
//  
//    NSMutableDictionary *param = [self.alertGoodListParam mutableCopy];
//    [param removeObjectForKey:@"showIsSetAlert"];
//    [param setValue:@(self.currentPage) forKey:@"currentPage"];
//    [[ServiceFactory shareInstance].stockService alertList:param CompletionHandler:^(id json) {
//       
//        [weakself.mainGrid headerEndRefreshing];
//        [weakself.mainGrid footerEndRefreshing];
//        weakself.datas  = [GoodsVo converToDicArr:json[@"goodsList"]];
//        [weakself.mainGrid reloadData];
//        weakself.mainGrid.ls_show = YES;
//    } errorHandler:^(id json) {
//        [AlertBox show:json];
//    }];
//}
//
//- (void)selectAllocateGoodsList {
//    __weak typeof(self) weakSelf = self;
//    [self.commonService selectAllocateGoodsList:self.searchType shopId:self.shopId toShopId:self.inShopId searchCode:self.searchCode barCode:self.barCode categoryId:self.categoryId createTime:self.createTime completionHandler:^(id json) {
//        NSMutableArray *array = [json objectForKey:@"goodsVoList"];
//        if ([NSString isBlank:weakSelf.createTime]) {
//            weakSelf.datas = [[NSMutableArray alloc] init];
//        }
//        
//        if ([ObjectUtil isNotNull:array] && array.count > 0) {
//            for (NSDictionary* dic in array) {
//                [weakSelf.datas addObject:[GoodsVo convertToGoodsVo:dic]];
//            }
//        }
//        
//        if ([NSString isBlank:weakSelf.createTime]) {
//            _goodsList = [[NSMutableArray alloc] init];
//            
//            if (_goodsChoiceViewTag == GOODS_CHOICE_VIEW) {
//                [weakSelf.titleBox initWithName:@"选择商品" backImg:Head_ICON_CANCEL moreImg:Head_ICON_CATE];
//                weakSelf.titleBox.lblRight.text = @"分类";
//            } else {
//                [weakSelf.titleBox initWithName:@"选择商品" backImg:Head_ICON_BACK moreImg:Head_ICON_CATE];
//                weakSelf.titleBox.lblRight.text = @"分类";
//            }
//        }
//        
//        if ([ObjectUtil isNotNull:[json objectForKey:@"createTime"]]) {
//            weakSelf.createTime = [[json objectForKey:@"createTime"] stringValue];
//        }
//        
//        if (weakSelf.datas.count == 1 && _isJump == 1) {
//            _selectGoodsBatchBack(self.datas);
//        }
//        [weakSelf.mainGrid reloadData];
//        weakSelf.mainGrid.ls_show = YES;
//        [weakSelf.mainGrid headerEndRefreshing];
//        [weakSelf.mainGrid footerEndRefreshing];
//    } errorHandler:^(id json) {
//        [AlertBox show:json];
//        [weakSelf.mainGrid headerEndRefreshing];
//        [weakSelf.mainGrid footerEndRefreshing];
//    }];
//
//}
//>>>>>>> dev
//

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[Platform Instance] lockAct:ACTION_GOODS_ADD]) {
        [AlertBox show:@"登录用户无该权限!"];
        return ;
    }
    else
    {
        if (alertView.tag == 101)
        {
            if (buttonIndex == 1) {
                LSGoodsEditView *vc = [[LSGoodsEditView alloc] init];
                vc.addGoodsVo = [[GoodsVo alloc] init];
                vc.addGoodsVo.barCode = self.barCode;
                vc.goodsId = nil;
                vc.shopId = nil;
                vc.action = ACTION_CONSTANTS_ADD;
                vc.viewTag = GOODS_BATCH_CHOICE_VIEW1;
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                [self.navigationController pushViewController:vc animated:NO];
                __weak GoodsBatchChoiceView1* weakSelf = self;
                [vc loaddatas:weakSelf.shopId shopName:weakSelf.shopName callBack:^(BOOL flg) {
                    [weakSelf.navigationController popToViewController:weakSelf animated:NO];
                    [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                    if (flg) {
                        self.createTime = @"";
                        [weakSelf searchGoodsList];
                    }
                }];
            }
        }
        else if (alertView.tag == 102)
        {
            if (buttonIndex == 1)
            {               
                LSGoodsEditView *vc = [[LSGoodsEditView alloc] init];
                vc.addGoodsVo = _addGoodsVo;
                vc.goodsId = nil;
                vc.shopId = nil;
                vc.action = ACTION_CONSTANTS_ADD;
                vc.viewTag = GOODS_BATCH_CHOICE_VIEW1;
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                [self.navigationController pushViewController:vc animated:NO];
                __weak GoodsBatchChoiceView1* weakSelf = self;
                [vc loaddatas:weakSelf.shopId shopName:weakSelf.shopName callBack:^(BOOL flg) {
                    [weakSelf.navigationController popToViewController:weakSelf animated:NO];
                    [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                    if (flg) {
                        self.createTime = @"";
                        [weakSelf searchGoodsList];
                    }
                }];
            }
        }
    }
}



- (void)clearCheckStatus {
    
    for (GoodsVo* tempVo in self.datas) {
        tempVo.isCheck = @"0";
    }
    [_goodsList removeAllObjects];
    [self configTitle:@"选择商品" leftPath:Head_ICON_BACK rightPath:nil];
    [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"分类" filePath:Head_ICON_CATE];
    [self.mainGrid reloadData];
}


- (NSMutableArray *)obtainGoodsId {
    NSMutableArray *datas = [NSMutableArray arrayWithCapacity:self.goodsList.count];
    for (GoodsVo *vo  in self.goodsList) {
        [datas addObject:vo.goodsId];
    }
    return datas;
}

#pragma mark - 代理方法 -
// INavigateEvent
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
    
    if (event == LSNavigationBarButtonDirectLeft) {
        _selectGoodsBatchBack(nil);
    } else {
        if (_goodsList.count == 0) {
            [self showKindMenuView];
        } else {
            /**************start************/
            //这段代码是为了判断微店商品页面点击添加时批量选择实体商品如果商品已下架弹出提示
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[LSWechatGoodManageViewController class]] || [vc isKindOfClass:[LSWechatGoodListViewController class]]) {
                    for (GoodsVo *goodsVo in _goodsList) {
                        if (goodsVo.upDownStatus == 2) {//商品在实体下架
                            [AlertBox show:@"在商品详情中设为已下架的商品不能再微店中销售"];
                            return;
                        }
                    }
                }
            }
             /**************end************/
            _selectGoodsBatchBack(_goodsList);
        }
    }
}

- (void)showKindMenuView {
    [self showView:KIND_MENU_VIEW];
    [self.kindMenuView initDelegate:self event:0 isShowManagerBtn:NO];
    [self.kindMenuView loadData:nil nodes:nil endNodes:_categoryList];
}

- (void)singleCheck:(NSInteger)event item:(id<INameItem>)item {
    
    TreeNode* node=(TreeNode*)item;
    if ([node.itemId isEqualToString:@"noCategory"]) {
        node.itemId = @"0";
    }
    self.categoryId = node.itemId;
    self.searchCode = @"";
    self.searchType = @"2";
    self.createTime = @"";
    self.barCode = @"";
    self.searchBar.keyWordTxt.text = @"";
    [self searchGoodsList];
}

- (void)closeSingleView:(NSInteger)event {

}

// ISearchBarEvent
- (void)imputFinish:(NSString *)keyWord {
    if (keyWord.length > 50) {
        [AlertBox show:@"检索字数不能超过50字，请重新输入!"];
        return ;
    }
    
    self.searchCode = keyWord;
    self.categoryId = @"";
    self.searchType = @"1";
    self.createTime = @"";
    self.barCode = @"";
    _isJump = 1;
    [self searchGoodsList];
}

// 扫一扫
- (void)scanStart {
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    
    _isJump = 1;
    self.searchBar.keyWordTxt.text = scanString;
    self.categoryId = @"";
    self.searchType = @"1";
    self.createTime = @"";
    self.barCode = scanString;
    
    if ([_viewType isEqualToString:@"1"]) {
        __weak GoodsBatchChoiceView1* weakSelf = self;
        NSString *url = @"goods/list";
        NSMutableDictionary* param = [NSMutableDictionary dictionary];
        
        [param setValue:self.searchType forKey:@"searchType"];
        [param setValue:self.shopId forKey:@"shopId"];
        if (![NSString isBlank:self.searchCode]) {
            [param setValue:self.searchCode forKey:@"searchCode"];
        }
        if (![NSString isBlank:self.barCode]) {
            [param setValue:self.barCode forKey:@"barCode"];
        }
        if ([NSString isNotBlank:self.supplyId]) {
            //供应商Id
            [param setValue:self.supplyId forKey:@"supplyId"];
        }
        if ([NSString isNotBlank:self.isReturn]) {
            //标示当前是否获取退货价 1为获取 2 不获取
            [param setValue:self.isReturn forKey:@"isReturn"];
        }
        //是否查询实际库存数
        [param setValue:@(self.getStockFlg) forKey:@"getStockFlg"];
                [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
            NSMutableArray *goodsArray = [[NSMutableArray alloc] init];
            if ([ObjectUtil isNotNull:[json objectForKey:@"goodsVoList"]]) {
                for (NSDictionary* dic in [json objectForKey:@"goodsVoList"]) {
                    [goodsArray addObject:[GoodsVo convertToGoodsVo:dic]];
                }
            }
            
            if ([[json objectForKey:@"searchStatus"] integerValue] == 1) {
                if ([NSString isBlank:weakSelf.createTime]) {
                    weakSelf.datas = [[NSMutableArray alloc] init];
                    weakSelf.datas = goodsArray;
                }
                if ([ObjectUtil isNotNull:[json objectForKey:@"createTime"]]) {
                    weakSelf.createTime = [[json objectForKey:@"createTime"] stringValue];
                }
            } else {
                [weakSelf.datas removeAllObjects];
            }
            
            [weakSelf.mainGrid reloadData];
            
            self.mainGrid.ls_show = YES;
            
            if (goodsArray.count == 1) {
                GoodsVo* vo = [goodsArray objectAtIndex:0];
                if ([[json objectForKey:@"searchStatus"] integerValue] == 1) {
                    _selectGoodsBatchBack(self.datas);
                } else {
                    [weakSelf selectGoodsDetail:vo];
                }
            } else if (goodsArray.count == 0) {
                UIAlertView *alertView;
                if (alertView != nil) {
                    [alertView dismissWithClickedButtonIndex:0 animated:NO];
                    alertView = nil;
                }
                alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您查询的商品不存在，是否添加该商品?" delegate:weakSelf cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
                alertView.tag = 101;
                [alertView show];
            }
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    } else {
        [self searchGoodsList];
    }
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [AlertBox show:message];
}

//
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootSelectAll]) {
       
        _goodsList = [[NSMutableArray alloc] init];
        if (self.datas.count > 0) {
            for (GoodsVo *vo in self.datas) {
                vo.isCheck =@"1";
                [_goodsList addObject:vo];
            }
        }
        if (_goodsList.count > 0) {
            [self configTitle:@"选择商品" leftPath:Head_ICON_CANCEL rightPath:nil];
            [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"确认" filePath:Head_ICON_OK];
        }
        [self.mainGrid reloadData];
        
    } else if ([footerType isEqualToString:kFootSelectNo]) {
        
        if (self.datas.count > 0) {
            for (GoodsVo *vo in self.datas) {
                vo.isCheck =@"0";
            }
        }
        [_goodsList removeAllObjects];
        if (_goodsChoiceViewTag == GOODS_CHOICE_VIEW) {
            [self configTitle:@"选择商品" leftPath:Head_ICON_CANCEL rightPath:nil];
            [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"分类" filePath:Head_ICON_CATE];
        } else {
            [self configTitle:@"选择商品" leftPath:Head_ICON_BACK rightPath:nil];
            [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"分类" filePath:Head_ICON_CATE];
        }
        [self.mainGrid reloadData];
    }
}

// UITableViewDelegate、 UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id obj = [self.datas objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[GoodsVo class]]) {
        GoodsVo* editObj = (GoodsVo *)obj;
        if ([editObj.isCheck isEqualToString:@"1"]) {
            editObj.isCheck = @"0";
            [_goodsList removeObject:editObj];
        } else {
            editObj.isCheck = @"1";
            [_goodsList addObject:editObj];
        }
    }
    if (_goodsList.count == 0) {
        if (_goodsChoiceViewTag == GOODS_CHOICE_VIEW) {
            [self configTitle:@"选择商品" leftPath:Head_ICON_CANCEL rightPath:nil];
            [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"分类" filePath:Head_ICON_CATE];
        } else {
            [self configTitle:@"选择商品" leftPath:Head_ICON_BACK rightPath:nil];
            [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"分类" filePath:Head_ICON_CATE];
        }
    } else {
        [self configTitle:@"选择商品" leftPath:Head_ICON_CANCEL rightPath:nil];
        [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"确认" filePath:Head_ICON_OK];
    }
    [self.mainGrid reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsBatchChoiceCell *cell = [GoodsBatchChoiceCell goodsBatchChoiceCellWithTableView:tableView];
    GoodsVo *goodsVo = self.datas[indexPath.row];
    cell.goodsVo = goodsVo;
    id obj = [self.datas objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[GoodsVo class]]) {
        GoodsVo *item = (GoodsVo *)obj;
        cell.goodsVo = item;
    }
    if (goodsVo.upDownStatus == 2) {
        cell.imgUpDown.hidden = NO;
    } else {
        cell.imgUpDown.hidden = YES;
    }
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}


- (void)selectGoodsDetail:(GoodsVo*)goodsVo {
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
//        __weak GoodsBatchChoiceView1* weakSelf = self;
//        [_goodsService selectGoodsBaseInfo:goodsVo.goodsId completionHandler:^(id json) {
//            if (!(weakSelf)) {
//                return ;
//            }
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
//            alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您查询的商品不存在，是否添加该商品?" delegate:weakSelf cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
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

- (void)searchGoodsList {
    if ([NSString isBlank:self.inShopId]) {
        [self selectGoodsList];
    } else {
        [self selectAllocateGoodsList];
    }
}

- (void)showView:(int)viewTag {
    if (viewTag == KIND_MENU_VIEW) {
        [self.view bringSubviewToFront:self.kindMenuView.view];
        [self loadKindMenuView];
        [self.kindMenuView showMoveIn];
        return;
    }
}

- (void)loadKindMenuView
{
    if (self.kindMenuView) {
        self.kindMenuView.view.hidden = NO;
    }else{
        self.kindMenuView = [[KindMenuView alloc] init];
        self.kindMenuView.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        [self.view addSubview:self.kindMenuView.view];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 网络请求 -

- (void)selectGoodsList {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:8];
    [param setValue:self.searchType forKey:@"searchType"];
    if ([NSString isNotBlank:self.shopId]) {
        [param setValue:self.shopId forKey:@"shopId"];
    }
    if ([NSString isNotBlank:self.searchCode]) {
        [param setValue:self.searchCode forKey:@"searchCode"];
    }
    if ([NSString isNotBlank:self.barCode]) {
        [param setValue:self.barCode forKey:@"barCode"];
    }
    if ([NSString isNotBlank:self.categoryId]) {
        [param setValue:self.categoryId forKey:@"categoryId"];
    }
    if ([NSString isNotBlank:self.createTime]) {
        [param setValue:self.createTime forKey:@"createTime"];
    }
    if ([NSString isNotBlank:self.supplyId]) {
        //供应商Id
        [param setValue:self.supplyId forKey:@"supplyId"];
    }
    if ([NSString isNotBlank:self.isReturn]) {
        //标示当前是否获取退货价 1为获取 2 不获取
        [param setValue:self.isReturn forKey:@"isReturn"];
    }
    [param setObject:[NSNumber numberWithInteger:self.mode] forKey:@"mode"];
    //是否查询实际库存数
    [param setValue:@(self.getStockFlg) forKey:@"getStockFlg"];
    [param setValue:self.warehouseId forKey:@"warehouseId"];
    [param setValue:self.validTypeList forKey:@"validTypeList"];
    __weak GoodsBatchChoiceView1* weakSelf = self;
    [self.commonService selectGoodsList:param completionHandler:^(id json) {
        [weakSelf responseSuccess:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
    }];
}


// 获取可以添加库存提醒的商品列表
- (void)selectAlertGoodsList {
    
    __weak typeof(self) weakself = self;
    
    NSMutableDictionary *param = [self.alertGoodListParam mutableCopy];
    [param removeObjectForKey:@"showIsSetAlert"];
    [param setValue:@(self.currentPage) forKey:@"currentPage"];
    [[ServiceFactory shareInstance].stockService alertList:param CompletionHandler:^(id json) {
        
        [weakself.mainGrid headerEndRefreshing];
        [weakself.mainGrid footerEndRefreshing];
        weakself.datas  = [GoodsVo converToDicArr:json[@"goodsList"]];
        [weakself.mainGrid reloadData];
        weakself.mainGrid.ls_show = YES;
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)selectAllocateGoodsList {
    __weak typeof(self) weakSelf = self;
    [self.commonService selectAllocateGoodsList:self.searchType shopId:self.shopId toShopId:self.inShopId searchCode:self.searchCode barCode:self.barCode categoryId:self.categoryId createTime:self.createTime completionHandler:^(id json) {
        NSMutableArray *array = [json objectForKey:@"goodsVoList"];
        if ([NSString isBlank:weakSelf.createTime]) {
            weakSelf.datas = [[NSMutableArray alloc] init];
        }
        
        if ([ObjectUtil isNotNull:array] && array.count > 0) {
            for (NSDictionary* dic in array) {
                [weakSelf.datas addObject:[GoodsVo convertToGoodsVo:dic]];
            }
        }
        
        if ([NSString isBlank:weakSelf.createTime]) {
            _goodsList = [[NSMutableArray alloc] init];
            
            if (_goodsChoiceViewTag == GOODS_CHOICE_VIEW) {
                [weakSelf configTitle:@"选择商品" leftPath:Head_ICON_CANCEL rightPath:nil];
                [weakSelf configNavigationBar:LSNavigationBarButtonDirectRight title:@"分类" filePath:Head_ICON_CATE];
            } else {
                [weakSelf configTitle:@"选择商品" leftPath:Head_ICON_BACK rightPath:nil];
                [weakSelf configNavigationBar:LSNavigationBarButtonDirectRight title:@"分类" filePath:Head_ICON_CATE];
            }
        }
        
        if ([ObjectUtil isNotNull:[json objectForKey:@"createTime"]]) {
            weakSelf.createTime = [[json objectForKey:@"createTime"] stringValue];
        }
        
        if (weakSelf.datas.count == 1 && _isJump == 1) {
            _selectGoodsBatchBack(self.datas);
        }
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

- (void)responseSuccess:(id)json {
    if ([[json objectForKey:@"searchStatus"] integerValue] == 1) {
        NSMutableArray *array = [json objectForKey:@"goodsVoList"];
        if ([NSString isBlank:self.createTime]) {
            self.datas = [[NSMutableArray alloc] init];
        }
        
        if ([ObjectUtil isNotNull:array] && array.count > 0) {
            for (NSDictionary* dic in array) {
                [self.datas addObject:[GoodsVo convertToGoodsVo:dic]];
            }
        }
        
        if ([NSString isBlank:self.createTime]) {
            _goodsList = [[NSMutableArray alloc] init];
            
            if (_goodsChoiceViewTag == GOODS_CHOICE_VIEW) {
                [self configTitle:@"选择商品" leftPath:Head_ICON_CANCEL rightPath:nil];
                [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"分类" filePath:Head_ICON_CATE];
            } else {
                [self configTitle:@"选择商品" leftPath:Head_ICON_BACK rightPath:nil];
                [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"分类" filePath:Head_ICON_CATE];
            }
        }
        
        if ([ObjectUtil isNotNull:[json objectForKey:@"createTime"]]) {
            self.createTime = [[json objectForKey:@"createTime"] stringValue];
        }
        
        if (self.datas.count == 1 && _isJump == 1) {
            _selectGoodsBatchBack(self.datas);
        }
        [self.mainGrid reloadData];
    } else {
        self.createTime = nil;
        [self.datas removeAllObjects];
        [self.mainGrid reloadData];
    }
    
    if (([[json objectForKey:@"searchStatus"] integerValue] == 1 && ([json objectForKey:@"goodsVoList"] == nil || [[json objectForKey:@"goodsVoList"] count] == 0)) || [[json objectForKey:@"searchStatus"] integerValue] != 1) {
        if ([_viewType isEqualToString:@"1"] && _isJump == 1) {
            // 商超采购单、收货单页面进入时
            UIAlertView *alertView;
            if (alertView != nil) {
                [alertView dismissWithClickedButtonIndex:0 animated:NO];
                alertView = nil;
            }
            alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您查询的商品不存在，是否添加该商品?" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
            alertView.tag = 101;
            [alertView show];
        }
    }
    _isJump = 0;
}

- (void)selectCategory {
    __weak GoodsBatchChoiceView1* weakSelf = self;
    [_goodsService selectLastCategoryInfo:@"1" completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [weakSelf responseSuccess2:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)responseSuccess2:(id)json {
    
    NSMutableArray* list = [JsonHelper transList:[json objectForKey:@"categoryList"] objName:@"CategoryVo"];
    _categoryList = [[NSMutableArray alloc] init];
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
@end
