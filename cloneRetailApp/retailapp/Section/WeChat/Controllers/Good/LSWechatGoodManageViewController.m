//
//  LSWechatGoodManageViewController.m
//  retailapp
//
//  Created by guozhi on 16/8/27.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSWechatGoodManageViewController.h"
#import "CategoryVo.h"
#import "EditItemList.h"
#import "NavigateTitle2.h"
#import "UIHelper.h"
#import "GoodsVo.h"
#import "ViewFactory.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "GoodsModuleEvent.h"
#import "SelectOrgShopListView.h"
#import "ShopVo.h"
#import "XHAnimalUtil.h"
#import "Platform.h"
#import "CategoryVo.h"
#import "JsonHelper.h"
#import "TreeNode.h"
#import "KindMenuView.h"
#import "GoodsCategoryListView.h"
//#import "MemberModule.h"
#import "FooterListView6.h"
#import "ListStyleVo.h"
#import "GoodsChoiceView.h"
#import "WechatGoodsDetailsView.h"
#import "ScanViewController.h"
#import "MicroWechatGoodsVo.h"
#import "LSSearchBar.h"
#import "LSFooterView.h"
#import "LSWechatGoodListViewController.h"
#import "ColorHelper.h"
#import "LSSelectCategoryListViewController.h"
#import "LSOneClickView.h"

@interface LSWechatGoodManageViewController () <FooterListEvent, INavigateEvent, ISearchBarEvent, IEditItemListEvent,SingleCheckHandle, LSScanViewDelegate, LSSearchBarDelegate, LSFooterViewDelegate>
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) LSSearchBar *searchBar;


//门店
@property (nonatomic, strong) IBOutlet EditItemList *lsShopName;
/**
 *  seaechType 1：按输入关键字查询 2：按筛选条件查询
 */
@property (nonatomic, assign) int searchType;
/**
 *  搜索关键字
 */
@property (nonatomic, strong) NSString *searchCode;
/**
 *  扫码关键字
 */
@property (nonatomic, strong) NSString *scanCode;
/**
 *  分类Id
 */
@property (nonatomic, strong) NSString *categoryId;

@property (nonatomic, retain) NSString *shopId;

@property (nonatomic) int goodsCount;

/**
 *  商品总数view
 */
@property (nonatomic, strong) UIView *goodsNumBgView;

/**
 *  商品总数文本
 */
@property (nonatomic, weak)  UILabel *lblGoodsNum;

/**
 *  分页时间 默认传0
 */
@property (nonatomic, assign) long createTime;

/**
 *  请求微店商品参数
 */
@property (nonatomic, strong) NSMutableDictionary *param;

@property (nonatomic, strong) LSFooterView *footerView;


@property (nonatomic,retain) NSMutableArray* categoryList;

@property (nonatomic, retain) NSString *barCode;

@property (nonatomic, retain) NSString *distributionShopId;

@property (nonatomic) int action;

@property (nonatomic, strong) WechatService *wechatService;
//分类页面
@property (nonatomic, strong) KindMenuView *kindMenuView;
@property (nonatomic,strong) GoodsCategoryListView *goodsCategoryListView;
@property (nonatomic,strong) GoodsChoiceView *goodsChoiceView;
@property (nonatomic,strong) WechatGoodsDetailsView *wechatGoodsDetail;
@end

@implementation LSWechatGoodManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self initNotification];
    [self initData];
    _wechatService = [ServiceFactory shareInstance].wechatService;
    [self selectCategory];
    [self configHelpButton:HELP_WECHAT_GOODS_INFO];
}
#pragma mark -初始化数据

- (void)initNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messagePushed:) name:Notification_System_Message_Push object:nil];
}

- (LSOneClickView *)oneClickView {
    if (_oneClickView == nil) {
        _oneClickView = [LSOneClickView show:self];
        _oneClickView.hidden = YES;
    }
    return _oneClickView;
}
- (void)messagePushed:(NSNotification *)notification {
    if (self.oneClickView) {
        self.oneClickView.hidden = YES;
    }
    [self loadData];
}
- (void)initData {
    self.shopId = [[Platform Instance] getkey:SHOP_ID];
}


#pragma mark - 网络请求
#pragma mark 查询商品总数

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [self loadData];
}
- (void)loadData {
    NSString* url = @"microGoods/saleCount";
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:self.shopId forKey:@"shopId"];
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself responseSuccess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}
- (void)responseSuccess:(id)json {
     self.lblGoodsNum.hidden = NO;
    if ([ObjectUtil isNotNull:json[@"quickSetStatus"]]) {
        if ([json[@"quickSetStatus"] intValue] == 1) {//正在一键上架时才返回值1
            self.oneClickView.hidden = NO;
            self.lblGoodsNum.hidden = YES;
        }
    }
    if ([ObjectUtil isNotNull:json[@"count"]]) {//正在一键上架时不返回值
        int goodsCount = [[json objectForKey:@"count"] intValue];
        self.lblGoodsNum.text = [NSString stringWithFormat:@"%d", goodsCount];
    }   
}

#pragma mark 查询商品分类
- (void)selectCategory {
    NSString* url = @"category/lastCategoryInfo";
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:@"1" forKey:@"hasNoCategory"];
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself responseCategorryList:json];
    } errorHandler:^(id json) {
         [AlertBox show:json];
    }];
}

- (void)responseCategorryList:(id)json
{
    NSMutableArray *categoryList = json[@"categoryList"];
    if ([ObjectUtil isNotNull:categoryList]) {
        NSMutableArray *list = [CategoryVo mj_objectArrayWithKeyValuesArray:categoryList];
        self.categoryList = [[NSMutableArray alloc] init];
        TreeNode *item = [[TreeNode alloc] init];
        item.itemName = @"全部";
        item.itemId = @"";
        [self.categoryList addObject:item];
        for (CategoryVo* vo in list) {
            item = [[TreeNode alloc] init];
            item.itemName = vo.microname;
            item.itemId = vo.categoryId;
            [self.categoryList addObject:item];
        }
    }
}

#pragma mark 查询微店商品列表
- (void)selectMicGoodsList {
    __weak typeof(self) wself = self;
    NSString *url = @"microGoods/list";
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        NSMutableArray *goodsArray = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:json[@"goodsVoList"]]){
            goodsArray = [MicroWechatGoodsVo mj_objectArrayWithKeyValuesArray:json[@"goodsVoList"]];
        }
        //点击分类某一类查询
        if (self.searchType == 2) {
            if (goodsArray.count > 0) {
                [wself gotoWechatGoodManagementListView];
            } else {
                [AlertBox show:@"该分类下暂无商品！"];
            }
            
        } else if (goodsArray.count < 2 && [NSString isNotBlank:self.searchBar.txtField.text]) {//搜索框查询
            [wself remoteWithArray:goodsArray ];
        } else if (goodsArray.count > 1) {
             [wself gotoWechatGoodManagementListView];
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}

/**
 按输入条件查询
 根据条件输入框内容进行相对应的在微店销售商品的前方精确查询。
 如果只查询出一条数据，页面跳转到微店商品详情页面。
 如果没有查询到数据，弹出“商品未在微店销售，确定要在微店设置销售吗？”
 点击确定按钮，如果查询商品在商品信息中存在且只有一条数据，直接进入微店商品详情页面；如果有多条数据，则进入选择商品共通页面。
 点击确定按钮，如果查询商品在商品信息中不存在，则弹出“未查询到商品，请先在商品管理里添加该商品！”
 */
- (void)remoteWithArray:(NSMutableArray *)goodsArray {
    //查出一条商品纪录
    if (goodsArray.count == 1) {
        MicroWechatGoodsVo* vo = [goodsArray objectAtIndex:0];
        [self gotoWechatGoodDetailWithShopId:self.shopId goodsId:vo.goodsId];
    }else if (goodsArray.count == 0){
        //未查出商品纪录
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该商品未在微店销售，确认要在微店设置销售吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action];
        action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self selectGoodsList];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}
#pragma mark 查询商品列表
- (void)selectGoodsList {
    NSString *url = @"goods/list";
    __weak typeof(self) wself = self;
    self.searchCode = self.scanCode;
    [self.view resignFirstResponder];
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        NSMutableArray *goodsArray=[[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:[json objectForKey:@"goodsVoList" ]]) {
            for (NSDictionary *dic in [json objectForKey:@"goodsVoList"]) {
                [goodsArray addObject:[GoodsVo convertToGoodsVo:dic]];
            }
        }
        if (goodsArray.count == 1) {
            GoodsVo *vo=[goodsArray objectAtIndex:0];
            //一条数据进入微店商品详情
            [wself gotoWechatGoodDetailWithShopId:wself.shopId goodsId:vo.goodsId];
        } else if (goodsArray.count == 0)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"未找到商品，请先在商品管理里添加该商品！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        } else
        {
            wself.goodsChoiceView = [[GoodsChoiceView alloc]initWithNibName:[SystemUtil getXibName:@"GoodsChoiceView" ] bundle:nil];
            wself.goodsChoiceView.searchType = @"1";
            wself.goodsChoiceView.barCode = wself.barCode;
            wself.goodsChoiceView.searchCode = wself.searchBar.txtField.text;
            [wself.goodsChoiceView loaddatas:self.shopId callBack:^(NSMutableArray *goodList) {
                
                if (!goodList) {
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                    [wself.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    GoodsVo *vo=(GoodsVo *)[goodList objectAtIndex:0];
                    WechatGoodsDetailsView *wechatGoodsDetailsView = [[WechatGoodsDetailsView alloc]
                                                                      initWithNibName:[SystemUtil getXibName:@"WechatGoodsDetailsView" ] bundle:nil];
                    wechatGoodsDetailsView.shopId = self.shopId;
                    wechatGoodsDetailsView.goodsId = vo.goodsId;
                    [wself.navigationController pushViewController:wechatGoodsDetailsView animated:NO];
                    [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush
                               direction:kCATransitionFromRight];
                }
            }];
            [wself.navigationController pushViewController:wself.goodsChoiceView animated:NO];
            [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        }
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}
#pragma mark - 查询商品
//- (void)selectMicroGoods
//{
//    __weak typeof(self) wself = self;
//    [_wechatService selectWechatCommonGoods:@"1" shopId:self.shopId searchCode:self.searchCode barCode:self.barCode categoryId:@"" createTime:@"" completionHandler:^(id json) {
//        
//        NSMutableArray *goodsArray=[[NSMutableArray alloc] init];
//        if ([ObjectUtil isNotNull:[json objectForKey:@"goodsVoList" ]]) {
//            for (NSDictionary *dic in [json objectForKey:@"goodsVoList"]) {
//                [goodsArray addObject:[GoodsVo convertToGoodsVo:dic]];
//            }
//        }
//        
//        if (goodsArray.count == 1)
//        {
//            GoodsVo *vo=[goodsArray objectAtIndex:0];
//            //一条数据进入微店商品详情
//            [wself gotoWechatGoodDetailWithShopId:wself.shopId goodsId:vo.goodsId];
//        }
//        else if (goodsArray.count == 0)
//        {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"未找到商品，请先在商品管理里添加该商品！" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//            }];
//            [alert addAction:action];
//            [self presentViewController:alert animated:YES completion:nil];
//        }
//        else
//        {
//            wself.goodsChoiceView = [[GoodsChoiceView alloc]initWithNibName:[SystemUtil getXibName:@"GoodsChoiceView" ] bundle:nil];
//            wself.goodsChoiceView.searchType = @"1";
//            [wself.goodsChoiceView loaddatas:self.shopId callBack:^(NSMutableArray *goodList) {
//                
//                if (!goodList) {
//                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
//                    [wself.navigationController popViewControllerAnimated:NO];
//                }
//                else
//                {
//                    GoodsVo *vo=(GoodsVo *)[goodList objectAtIndex:0];
//                    WechatGoodsDetailsView *wechatGoodsDetailsView = [[WechatGoodsDetailsView alloc]
//                                                                      initWithNibName:[SystemUtil getXibName:@"WechatGoodsDetailsView" ] bundle:nil];
//                    wechatGoodsDetailsView.shopId = self.shopId;
//                    wechatGoodsDetailsView.goodsId = vo.goodsId;
//                    [wself.navigationController pushViewController:wechatGoodsDetailsView animated:NO];
//                    [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush
//                               direction:kCATransitionFromRight];
//                }
//            }];
//            [wself.navigationController pushViewController:wself.goodsChoiceView animated:NO];
//            [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
//        }
//    }errorHandler:^(id json) {
//        [AlertBox show:json];
//    }];
//}



#pragma mark - 页面切换
//前往微店商品详情页面
- (void)gotoWechatGoodDetailWithShopId:(NSString *)shopId goodsId:(NSString *)goodsId {
    WechatGoodsDetailsView *vc = [[WechatGoodsDetailsView alloc] initWithNibName:[SystemUtil getXibName:@"WechatGoodsDetailsView"] bundle:nil];
    vc.shopId = shopId;
    vc.goodsId = goodsId;
    vc.action = ACTION_CONSTANTS_EDIT;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    
}

#pragma mark 前往微店商品列表页面
- (void)gotoWechatGoodManagementListView {
    LSWechatGoodListViewController *vc = [[LSWechatGoodListViewController alloc] init];
    vc.shopId = self.shopId;
    vc.categoryId = self.categoryId;
    vc.searchType = self.searchType;
    vc.searchCode = self.searchCode;
    vc.scanCode = self.scanCode;
    vc.barCode = self.barCode;
    vc.createTime = 0;
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    
}
#pragma mark 点击商品总数
- (void)btnClick:(UIButton *)btn {
    self.searchType = 1;
    self.searchCode = @"";
    self.scanCode = @"";
    self.categoryId = @"";
    [self gotoWechatGoodManagementListView];
}

#pragma mark 显示分类管理页面
- (void)showKindMenuView {
    self.kindMenuView = [[KindMenuView alloc] init];
    self.kindMenuView.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    [self.view addSubview:self.kindMenuView.view];
    [self.kindMenuView showMoveIn];
    [self.kindMenuView initDelegate:self event:0 isShowManagerBtn:NO];
    [self.kindMenuView loadData:nil nodes:nil endNodes:self.categoryList];
}



#pragma mark - <代理事件>
#pragma mark <LSFSearchBarDelegate
- (void)searchBarImputFinish:(NSString *)keyWord {
    self.searchCode = keyWord;
    self.searchType = 1;
    self.createTime = 0;
    [self selectMicGoodsList];
}
- (void)searchBarScanStart {
    [self showScanView];
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootScan]) {
        [self showScanView];
    } else if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    } else if ([footerType isEqualToString:kFootOneClick]) {
        [self showOneClickEvent];
    }
}

- (void)showOneClickEvent {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"所有商品" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *url = @"microGoods/quickSetCount";
        [BaseService getRemoteLSDataWithUrl:url param:nil withMessage:nil show:YES CompletionHandler:^(id json) {
            if ([ObjectUtil isNotNull:json[@"count"]]) {//正在一键上架时不返回值
                int count = [json[@"count"] intValue];
                if (count == 0) {
                    [AlertBox show:@"没有可上架的商品！"];
                } else {
                    [self showOneClickAlert:count];
                }
            }
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
        
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"按分类上架" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LSSelectCategoryListViewController *vc = [[LSSelectCategoryListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
        
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVc animated:YES completion:nil];
}


- (void)showOneClickAlert:(int)count {
    NSString *str = [NSString stringWithFormat:@"此次共有%d种商品（不包含散装称重商品）按“与零售价相同”的售价策略上架到微店销售！上架需要花费几分钟时间，请耐心等待～～\n为了保证商品数据的一致性，一键上架过程中，将无法添加或修改商品信息，建议此操作在非营业时间进行！", count];
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) wself = self;
    [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *url = @"microGoods/quickSetSale";
        [BaseService getRemoteLSDataWithUrl:url param:nil withMessage:nil show:YES CompletionHandler:^(id json) {
            if ([ObjectUtil isNotNull:json[@"quickSetStatus"]]) {
                if ([json[@"quickSetStatus"] intValue] == 1) {//正在一键上架时才返回值1
                    for (UIViewController *vc in wself.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[LSWechatGoodManageViewController class]]) {
                            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
                            [wself.navigationController popToViewController:vc animated:NO];
                            wself.oneClickView.hidden = NO;
                        }
                    }
                }
            }
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
        
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVc animated:YES completion:nil];
}




- (void)showAddEvent {
    GoodsChoiceView *vc = [[GoodsChoiceView alloc]init];
    vc.searchType = @"1";
    __weak typeof(self) wself = self;
    [vc loaddatas:self.shopId callBack:^(NSMutableArray *goodList) {
        if (nil ==  goodList) {
            [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [wself.navigationController popViewControllerAnimated:NO];
        }else if (goodList.count == 1){
            GoodsVo *vo=(GoodsVo *)[goodList objectAtIndex:0];
            [self gotoWechatGoodDetailWithShopId:self.shopId goodsId:vo.goodsId];
        } else if (goodList.count > 1) {
            NSMutableArray *goodIdList = [NSMutableArray array];
            [goodList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GoodsVo *goodsVo = (GoodsVo *)obj;
                [goodIdList addObject:goodsVo.goodsId];
            }];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setValue:goodIdList forKey:@"goodsIdList"];
            [param setValue:self.shopId forKey:@"shopId"];
            NSString *url = @"microGoods/saveBatch";//批量添加商品到微店
            [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
                [wself loadData];//请求成功后刷新数据
                [wself.navigationController popToViewController:self animated:NO];//添加成功后跳转到汇总页面
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
            
        }
    }];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

- (void)showScanView {
    
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

// LSScanViewDelegate
- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    self.scanCode = scanString;
    self.searchType = 1;
    self.searchCode = @"";
    self.searchBar.txtField.text = scanString;
    [self selectMicGoodsList];
    
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [AlertBox show:message];
}

#pragma mark - 标题点击
- (void)onNavigateEvent:(Direct_Flag)event
{
    if (event==1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        if (self.oneClickView.hidden == NO) {
            [AlertBox show:@"一键上架微店商品正在进行中，暂时无法进行该操作！"];
            return;
        }
        [self showKindMenuView];
    }
}

#pragma mark 点击分类管理的某一类
- (void)singleCheck:(NSInteger)event item:(id<INameItem>)item
{
    TreeNode* node=(TreeNode*)item;
    self.categoryId = node.itemId;
    self.searchType = 2;
    //清掉原有数据 seaechCode只有搜索框输入才有值
    self.searchCode = @"";
    //输入框清空
    self.searchBar.searchCode = @"";
    //第一页开始请求
    self.createTime = 0;
    [self selectMicGoodsList];

    
}
#pragma mark - 初始化布局
- (void)setup {
    //设置导航栏
    CGFloat y = 0;
    self.titleBox.ls_top = 0;
    
    //设置搜索框
    y = y + self.titleBox.ls_height;
    self.searchBar.ls_top = y;
    
    //设置商品总数
    y = y + self.searchBar.ls_height;
    self.goodsNumBgView.ls_top = y;
    
    //设置底部工具栏
    self.footerView.ls_bottom = self.view.ls_height;
}
#pragma mark - setter ang getter
#pragma mark 设置标题
- (NavigateTitle2 *)titleBox {
    if (!_titleBox) {
        _titleBox=[NavigateTitle2 navigateTitle:self];
        [_titleBox initWithName:@"微店商品" backImg:Head_ICON_BACK moreImg:Head_ICON_CATE];
        _titleBox.lblRight.text = @"分类";
        [self.view addSubview:_titleBox];
    }
    return _titleBox;
}

#pragma mark 设置搜索框
- (LSSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [LSSearchBar searchBar];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"条形码/简码/拼音码";
        [self.view addSubview:_searchBar];
    }
    return _searchBar;
}

#pragma mark 设置商品总数背景图
- (UIView *)goodsNumBgView {
    if (!_goodsNumBgView) {
        _goodsNumBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.ls_width, 44)];
        _goodsNumBgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        [self.view addSubview:_goodsNumBgView];
        //设置商品总数标签
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, _goodsNumBgView.ls_height)];
        lab.text = @"商品总数";
        lab.textColor = [UIColor blackColor];
        lab.font = [UIFont systemFontOfSize:15];
        [_goodsNumBgView addSubview:lab];
        
        //设置下一个图标
        CGFloat y = 0;
        CGFloat w = 22;
        CGFloat x = self.goodsNumBgView.ls_width - 10 - w;
        y = (_goodsNumBgView.ls_height - w)/2;
        UIImageView *nextImg = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, w)];
        nextImg.image = [UIImage imageNamed:@"ico_next"];
        [_goodsNumBgView addSubview:nextImg];
        
        //设置商品总数
        w = 100;
        x = nextImg.ls_right - w - 20;
        UILabel *lblGoodsNum = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, w, self.goodsNumBgView.ls_height)];
        lblGoodsNum .textColor = [UIColor darkGrayColor];
        lblGoodsNum .font = [UIFont systemFontOfSize:15];
        lblGoodsNum.textColor = [ColorHelper getBlueColor];
        lblGoodsNum.textAlignment = NSTextAlignmentRight;
        [_goodsNumBgView addSubview:lblGoodsNum];
        self.lblGoodsNum = lblGoodsNum;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, self.goodsNumBgView.ls_width, self.goodsNumBgView.ls_height);
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_goodsNumBgView addSubview:btn];

    }
    return _goodsNumBgView;
}

#pragma mark 设置底部工具栏
- (LSFooterView *)footerView {
    if (!_footerView) {
        _footerView = [LSFooterView footerView];
        [_footerView initDelegate:self btnsArray:@[kFootScan, kFootOneClick, kFootAdd]];
        [self.view addSubview:_footerView];

    }
    return _footerView;
}

#pragma mark 请求参数
- (NSMutableDictionary *)param {
    if (!_param) {
        _param = [[NSMutableDictionary alloc] init];
    }
    [_param removeAllObjects];
    //搜索类型
    [_param setValue:@(self.searchType) forKey:@"searchType"];
    //扫码关键字
    if ([NSString isNotBlank:self.scanCode]) {
        [_param setValue:self.scanCode forKey:@"barcode"];
    }
    //搜索关键字
    if ([NSString isNotBlank:self.searchBar.txtField.text]) {
        [_param setValue:self.searchBar.txtField.text forKey:@"searchCode"];
    }
    //分类id
    if ([NSString isNotBlank:self.categoryId]) {
        [_param setValue:self.categoryId forKey:@"categoryId"];
    }
    //分页时间
    if (self.createTime != 0) {
        [_param setValue:@(self.createTime) forKey:@"createTime"];
    }
    //查询门店
    [_param setValue:self.shopId forKey:@"shopId"];
    return _param;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_System_Message_Push object:nil];
}


@end
