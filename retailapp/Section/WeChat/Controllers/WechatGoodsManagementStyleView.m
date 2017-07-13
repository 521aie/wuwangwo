//
//  WechatGoodsManagementStyleView.m
//  retailapp
//
//  Created by zhangzt on 15/10/12.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "WechatGoodsManagementStyleView.h"
#import "NavigateTitle2.h"
#import "WechatGoodsManagementStyleAddChooseView.h"
#import "WechatGoodsManagementStyleDetailViewViewController.h"
#import "WechatGoodsTopSelectView.h"
#import "StyleChoiceView.h"
//#import "GoodsBatchChoiceView2.h"
#import "WechatGoodsManagementStyleAddChooseView.h"
#import "WechatGoodsManagementStyleBatchSelectView.h"
#import "ThemeRecommendedStyleViewController.h"
#import "GoodsFooterListView.h"
#import "SearchBar2.h"
#import "MyUILabel.h"
#import "LSWechatGoodCell.h"

#import "WechatService.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "ViewFactory.h"
#import "XHAnimalUtil.h"
#import "LSWechatGoodCell.h"
#import "Wechat_StyleVo.h"
#import "EditItemList.h"
#import "MicroBasicSetVo.h"
#import "ListStyleVo.h"
#import "DateUtils.h"
#import "GoodsService.h"
#import "ColorHelper.h"
#import "LSFooterView.h"
#import "LSSelectCategoryListViewController.h"
#import "LSOneClickView.h"
#import "LSWechatStyleManageViewController.h"
@interface WechatGoodsManagementStyleView ()<LSFooterViewDelegate>

@property (nonatomic , strong) WechatService* wechatService;
@property (nonatomic, strong) GoodsService* goodsService;
@property (nonatomic , strong) MicroShopVo* microShopVo;

@property (nonatomic, strong) NSString* createTime;

@property (nonatomic, strong) NSString* shopId;

@property (nonatomic, strong) Wechat_StyleVo* tempVo;

@property (nonatomic, retain) NSString *searchCode;

@property (nonatomic, strong) MicroBasicSetVo *microBasicSetVo;

//微店商品管理 筛选页面
@property (nonatomic, strong)WechatGoodsTopSelectView *wechatGoodsTopSelectView;

//添加选择页面
@property (nonatomic, strong)WechatGoodsManagementStyleAddChooseView *wechatGoodsManagementStyleAddChooseView;

@property (nonatomic, strong) LSFooterView *footView;

@end

@implementation WechatGoodsManagementStyleView


- (void)loaddatas {
    
    _shopId = [_condition objectForKey:@"shopId"];
    if ([[Platform Instance] getShopMode] != 3) {
        //   [self.lsShopName initData:[_condition objectForKey:@"shopName"] withVal:[_condition objectForKey:@"shopId"]];
    }
    if ([[_condition objectForKey:@"searchType"] isEqualToString:@"2"]) {
        [self.tableview headerBeginRefreshing];
    }else {
        _createTime = [_condition objectForKey:@"createTime"];
        if (!([_condition objectForKey:@"styleList"] == nil)) {
            self.datas = [_condition objectForKey:@"styleList"];
            [self.tableview reloadData];
        }else {
             [self.tableview headerBeginRefreshing];
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self initHead];
    [self initGrid];
    [self.searchBar initDelagate:self placeholder:@"名称/款号"];
    [self.view addSubview:self.searchBar.view];
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootBatch, kFootOneClick,kFootAdd]];
    [self.view addSubview:self.footView];
    self.footView.ls_bottom = SCREEN_H;
    self.searchBar.view.frame = CGRectMake(0, 64, 320, 44);
    
    _wechatService = [ServiceFactory shareInstance].wechatService;
    _goodsService= [ServiceFactory shareInstance].goodsService;
    __weak WechatGoodsManagementStyleView *weakSelf = self;
    [weakSelf.tableview ls_addHeaderWithCallback:^{
        _createTime = nil;
        [weakSelf selectStyleList];
    }];
    [weakSelf.tableview ls_addFooterWithCallback:^{
        [weakSelf selectStyleList];
    }];
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    } else if ([footerType isEqualToString:kFootBatch]) {
        [self showBatchEvent];
    } else if ([footerType isEqualToString:kFootOneClick]) {
        [self showOneClickEvent];
    }
}

- (void)showOneClickEvent {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"所有款式" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    NSString *str = [NSString stringWithFormat:@"此次共有%d种商品按“与零售价相同”的售价策略上架到微店销售！上架需要花费几分钟时间，请耐心等待～～\n为了保证商品数据的一致性，一键上架过程中，将无法添加或修改商品信息，建议此操作在非营业时间进行！", count];
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) wself = self;
    [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *url = @"microGoods/quickSetSale";
        [BaseService getRemoteLSDataWithUrl:url param:nil withMessage:nil show:YES CompletionHandler:^(id json) {
            if ([ObjectUtil isNotNull:json[@"quickSetStatus"]]) {
                if ([json[@"quickSetStatus"] intValue] == 1) {//正在一键上架时才返回值1
                    for (UIViewController *vc in wself.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[LSWechatStyleManageViewController class]]) {
                            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
                            [self.navigationController popToViewController:vc animated:NO];
                            LSWechatStyleManageViewController *wechatStyleVc = (LSWechatStyleManageViewController *)vc;
                            wechatStyleVc.oneClickView.hidden = NO;

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


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.datas.count == 1){
        self.searchBar.keyWordTxt.text = @"";
        [_condition setValue:@"" forKey:@"searchCode"];
    } else {
        self.searchBar.keyWordTxt.text = self.condition[@"searchCode"];
    }
    [self loaddatas];
//    [self checkCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initGrid
{
    self.tableview.rowHeight = 88.0;
    UIView *view = [ViewFactory generateFooter:60];
    [self.tableview setTableFooterView:view];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)selectStyleList
{
    __weak WechatGoodsManagementStyleView *weakSelf = self;
    [_wechatService selectMicroStyleList:[_condition objectForKey:@"searchType"] shopId:[_condition objectForKey:@"shopId"] searchCode:[_condition objectForKey:@"searchCode"] categoryId:[_condition objectForKey:@"categoryId"] applySex:[_condition objectForKey:@"applySex"] year:[_condition objectForKey:@"year"] seasonValId:[_condition objectForKey:@"seasonValId"] minHangTagPrice:[_condition objectForKey:@"minHangTagPrice"] maxHangTagPrice:[_condition objectForKey:@"maxHangTagPrice"] createTime:_createTime != nil? [NSNumber numberWithLongLong:[_createTime longLongValue]]:nil completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        [weakSelf responseSuccess:json];
        [weakSelf.tableview headerEndRefreshing];
        [weakSelf.tableview footerEndRefreshing];
    } errorHandler:^(id json) {
        [AlertBox show:json];
        [weakSelf.tableview headerEndRefreshing];
        [weakSelf.tableview footerEndRefreshing];
    }];
}

- (void)responseSuccess:(id)json
{
    NSMutableArray *array = [json objectForKey:@"styleVoList"];
    if (_createTime == nil || [_createTime isEqualToString:@""]) {
        self.datas = [[NSMutableArray alloc] init];
    }
    if ([ObjectUtil isNotNull:array]) {
        for (NSDictionary* dic in array) {
            [self.datas addObject:[Wechat_StyleVo convertToListStyleVo:dic]];
        }
    }
    if ([ObjectUtil isNotNull:[json objectForKey:@"createTime"]]) {
        _createTime = [[json objectForKey:@"createTime"] stringValue];
    }
    
    if (self.datas.count==1 && ![self.searchBar.keyWordTxt.text isEqual:@""]) {
        WechatGoodsManagementStyleDetailViewViewController *wechatGoodsManagementStyleDetailViewViewController = [[WechatGoodsManagementStyleDetailViewViewController alloc]initWithNibName:[SystemUtil getXibName:@"WechatGoodsManagementStyleDetailView"] bundle:nil];
        
        for (NSDictionary* dic in [json objectForKey:@"styleVoList"]) {
            wechatGoodsManagementStyleDetailViewViewController.styleId =dic[@"styleId"];
        }
        
        wechatGoodsManagementStyleDetailViewViewController.shopId = _shopId;
        wechatGoodsManagementStyleDetailViewViewController.action = ACTION_CONSTANTS_EDIT;
        wechatGoodsManagementStyleDetailViewViewController.detai = WECHAT_STYLE_MicroInfo;
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [self.navigationController pushViewController:wechatGoodsManagementStyleDetailViewViewController animated:NO];
    }else if (self.datas.count==0 && ![self.searchBar.keyWordTxt.text isEqual:@""]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该款式未在微店销售，确认要在微店设置销售吗？" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
        alertView.tag = 1;
        [alertView show];
    }
    [self.tableview reloadData];
}

// 搜索框输入完成方法
- (void)imputFinish:(NSString *)keyWord
{
    self.searchCode = keyWord;
    _searchCode = keyWord;
    NSMutableDictionary* condition = [[NSMutableDictionary alloc] init];
    [condition setValue:@"1" forKey:@"searchType"];
    [condition setValue:_shopId forKey:@"shopId"];
    [condition setValue:_searchCode forKey:@"searchCode"];
    [condition setValue:@"" forKey:@"categoryId"];
    [condition setValue:@"" forKey:@"applySex"];
    [condition setValue:@"" forKey:@"year"];
    [condition setValue:@"" forKey:@"season"];
    [condition setValue:@"" forKey:@"minHangTagPrice"];
    [condition setValue:@"" forKey:@"maxHangTagPrice"];
    [condition setValue:@"" forKey:@"createTime"];
    _condition = condition;
    [self.tableview headerBeginRefreshing];
}

#pragma navigateTitle.
- (void)initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"微店款式" backImg:Head_ICON_BACK moreImg:Head_ICON_CHOOSE];
    self.titleBox.lblRight.text = @"筛选";
    self.titleBox.lblRight.hidden = NO;
    [self.titleDiv addSubview:self.titleBox];
}


//查看是否启用主题销售包
//- (void)checkCode {
//    __weak WechatGoodsManagementStyleView *weakSelf = self;
//    [_wechatService SelectCode:@"CONFIG_START_THEMEPACKAGE" completionHandler:^(id json) {
//        // [self responseSuccess:json];
//        self.microBasicSetVo = [MicroBasicSetVo converToVo:[json objectForKey:@"microBasicSetVo"]];
//    } errorHandler:^(id json) {
//        [AlertBox show:json];
//    }];
//}

- (void)showAddEvent
{

    if ([[Platform Instance] getShopMode] == 1) {
        //单店 进入款式选择共通页面
        StyleChoiceView *styleChoiceView = [[StyleChoiceView alloc]init];
        [styleChoiceView loaddatas:self.shopId type:@"2" callBack:^(NSMutableArray *styleList) {
            if (nil == styleList) {
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                [self.navigationController popViewControllerAnimated:NO];
            }else{
                ListStyleVo *vo= (ListStyleVo*)[styleList objectAtIndex:0];
                WechatGoodsManagementStyleDetailViewViewController *wechatGoodsManagementStyleDetailViewViewController = [[WechatGoodsManagementStyleDetailViewViewController alloc]initWithNibName:[SystemUtil getXibName:@"WechatGoodsManagementStyleDetailView"] bundle:nil];
                wechatGoodsManagementStyleDetailViewViewController.styleId = vo.styleId;
                wechatGoodsManagementStyleDetailViewViewController.shopId = self.shopId;
                wechatGoodsManagementStyleDetailViewViewController.action = ACTION_CONSTANTS_EDIT;
                [self.navigationController pushViewController:wechatGoodsManagementStyleDetailViewViewController animated:NO];
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
            }
            
        }];
        [self.navigationController pushViewController:styleChoiceView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    } else if ([[Platform Instance] getShopMode] == 2 || [[Platform Instance] getShopMode] == 3) {
        //门店 微店设置中的“启用主题销售包”开关状态，关闭进入款式选择共通页面，开，进入选择状态
//        if ([self.microBasicSetVo.value isEqualToString:@"1"]) {
//            //开启
//            UIActionSheet *menu = [[UIActionSheet alloc]
//                                   initWithTitle:nil
//                                   delegate:self
//                                   cancelButtonTitle:@"取消"
//                                   destructiveButtonTitle:nil
//                                   otherButtonTitles: @"自选款式", @"主题推荐款式", nil];
//            [menu showInView:self.view];
//        }else if ([self.microBasicSetVo.value isEqualToString:@"2"]) {
            //关闭
            StyleChoiceView *styleChoiceView = [[StyleChoiceView alloc]init];
           _shopId = [[Platform Instance] getkey:SHOP_ID];
            [styleChoiceView loaddatas:self.shopId type:@"2" callBack:^(NSMutableArray *styleList) {
                if (nil == styleList) {
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                    [self.navigationController popViewControllerAnimated:NO];
                }else{
                    ListStyleVo *vo= (ListStyleVo*)[styleList objectAtIndex:0];
                    WechatGoodsManagementStyleDetailViewViewController *wechatGoodsManagementStyleDetailViewViewController = [[WechatGoodsManagementStyleDetailViewViewController alloc]initWithNibName:[SystemUtil getXibName:@"WechatGoodsManagementStyleDetailView"] bundle:nil];
                    wechatGoodsManagementStyleDetailViewViewController.styleId = vo.styleId;
                    wechatGoodsManagementStyleDetailViewViewController.shopId = self.shopId;
                    wechatGoodsManagementStyleDetailViewViewController.action = ACTION_CONSTANTS_EDIT;
                    [self.navigationController pushViewController:wechatGoodsManagementStyleDetailViewViewController animated:NO];
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                }
            }];
            [self.navigationController pushViewController:styleChoiceView animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
//        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self btnSelfChooseclick];
    }else if (buttonIndex == 1) {
        [self btnSubjectclick];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            [self selectGoodStylelist];
        }
    }
}

- (void)selectGoodStylelist{
    __weak WechatGoodsManagementStyleView* weakSelf = self;
    NSMutableDictionary* condition = [[NSMutableDictionary alloc] init];
    [condition setValue:@"1" forKey:@"searchType"];
    _shopId = [[Platform Instance] getkey:SHOP_ID];
    [condition setValue:weakSelf.shopId forKey:@"shopId"];
    [condition setValue:_searchCode forKey:@"searchCode"];
    [condition setValue:@"" forKey:@"categoryId"];
    [condition setValue:@"" forKey:@"applySex"];
    [condition setValue:@"" forKey:@"prototypeValId"];
    [condition setValue:@"" forKey:@"auxiliaryValId"];
    [condition setValue:@"" forKey:@"year"];
    [condition setValue:@"" forKey:@"seasonValId"];
    [condition setValue:@"" forKey:@"minHangTagPrice"];
    [condition setValue:@"" forKey:@"maxHangTagPrice"];
    [condition setValue:@"" forKey:@"createTime"];
    
    if([[Platform Instance] getShopMode]==2){
        [condition setValue:@"0" forKey:@"isSearchTopOrg"];
    }
    
    [_goodsService selectStyleList:condition completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        NSMutableArray *styleArray = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:[json objectForKey:@"styleVoList"]]) {
            for (NSDictionary* dic in [json objectForKey:@"styleVoList"]) {
                [styleArray addObject:[ListStyleVo convertToListStyleVo:dic]];
            }
        }
        
        if (styleArray.count == 1) {
            ListStyleVo *vo= [styleArray objectAtIndex:0];
            //一条数据进入微店款式详情
            WechatGoodsManagementStyleDetailViewViewController *wechatGoodsManagementStyleDetailViewViewController = [[WechatGoodsManagementStyleDetailViewViewController alloc]initWithNibName:[SystemUtil getXibName:@"WechatGoodsManagementStyleDetailView"] bundle:nil];
            //   [wechatGoodsManagementStyleDetailViewViewController loaddatas:_shopId goodsId:vo.styleId action:ACTION_CONSTANTS_EDIT];
            
            wechatGoodsManagementStyleDetailViewViewController.styleId = vo.styleId;
            wechatGoodsManagementStyleDetailViewViewController.shopId = self.shopId;
            wechatGoodsManagementStyleDetailViewViewController.action = ACTION_CONSTANTS_EDIT;
            [self.navigationController pushViewController:wechatGoodsManagementStyleDetailViewViewController animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        }else if (styleArray.count == 0){
            static UIAlertView *alertView;
            if (alertView != nil) {
                [alertView dismissWithClickedButtonIndex:0 animated:NO];
                alertView = nil;
            }
            alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未查询到款式信息，请先在款式管理中添加该款式！" delegate:self cancelButtonTitle:nil  otherButtonTitles:@"确认", nil];
            alertView.tag = 2;
            [alertView show];
        }else {
            //多条数据进入选择款式(单选)共通页面
            StyleChoiceView *styleChoiceView = [[StyleChoiceView alloc]init];
            styleChoiceView.searchCode=self.searchBar.keyWordTxt.text;
            [styleChoiceView loaddatas:self.shopId type:@"2" callBack:^(NSMutableArray *styleList) {
                if (nil == styleList) {
                    NSLog(@"1234567890");
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                    [self.navigationController popViewControllerAnimated:NO];
                }else{
                    ListStyleVo *vo= (ListStyleVo*)[styleList objectAtIndex:0];
                    WechatGoodsManagementStyleDetailViewViewController *wechatGoodsManagementStyleDetailViewViewController = [[WechatGoodsManagementStyleDetailViewViewController alloc]initWithNibName:[SystemUtil getXibName:@"WechatGoodsManagementStyleDetailView"] bundle:nil];
                    wechatGoodsManagementStyleDetailViewViewController.styleId = vo.styleId;
                    wechatGoodsManagementStyleDetailViewViewController.shopId = self.shopId;
                    wechatGoodsManagementStyleDetailViewViewController.action = ACTION_CONSTANTS_EDIT;
                    [self.navigationController pushViewController:wechatGoodsManagementStyleDetailViewViewController animated:NO];
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                }
            }];
            [self.navigationController pushViewController:styleChoiceView animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
            
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}

- (void)btnSelfChooseclick {
    _shopId = [[Platform Instance] getkey:SHOP_ID];
    [self.wechatGoodsManagementStyleAddChooseView.view removeFromSuperview];
    StyleChoiceView *styleChoiceView = [[StyleChoiceView alloc]init];
    [styleChoiceView loaddatas:self.shopId type:@"2" callBack:^(NSMutableArray *styleList) {
        if (nil == styleList) {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
        }else{
            ListStyleVo *vo= (ListStyleVo*)[styleList objectAtIndex:0];
            WechatGoodsManagementStyleDetailViewViewController *wechatGoodsManagementStyleDetailViewViewController = [[WechatGoodsManagementStyleDetailViewViewController alloc]initWithNibName:[SystemUtil getXibName:@"WechatGoodsManagementStyleDetailView"] bundle:nil];
            wechatGoodsManagementStyleDetailViewViewController.styleId = vo.styleId;
            wechatGoodsManagementStyleDetailViewViewController.shopId = self.shopId;
            wechatGoodsManagementStyleDetailViewViewController.action = ACTION_CONSTANTS_EDIT;
            [self.navigationController pushViewController:wechatGoodsManagementStyleDetailViewViewController animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        }
    }];
    [self.navigationController pushViewController:styleChoiceView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

//主题推荐款式进入选择主题销售包
- (void)btnSubjectclick {
    [self.wechatGoodsManagementStyleAddChooseView.view removeFromSuperview];
    ThemeRecommendedStyleViewController *themeRecommendedStyleViewController = [[ThemeRecommendedStyleViewController alloc]initWithNibName:[SystemUtil getXibName:@"ThemeRecommendedStyleViewController"] bundle:nil];
    [self.navigationController pushViewController:themeRecommendedStyleViewController animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

- (void)showBatchEvent
{
    WechatGoodsManagementStyleBatchSelectView *wechatGoodsManagementStyleBatchSelectView =[[WechatGoodsManagementStyleBatchSelectView alloc]initWithNibName:[SystemUtil getXibName:@"WechatGoodsManagementStyleBatchSelectView"] bundle:nil];
    [_condition setValue:self.searchBar.keyWordTxt.text forKey:@"searchCode"];
    if (self.createTime == nil) {
        [_condition setValue:@"" forKey:@"createTime"];
    }else{
        [_condition setValue:self.createTime forKey:@"createTime"];
    }
    
    wechatGoodsManagementStyleBatchSelectView.condition = self.condition;
    for (Wechat_StyleVo *styleVo in self.datas) {
        styleVo.isCheck = @"0";
    }
    wechatGoodsManagementStyleBatchSelectView.datas = self.datas;
    [self.navigationController pushViewController:wechatGoodsManagementStyleBatchSelectView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}


- (void)onNavigateEvent:(Direct_Flag)event
{
    if (event == 1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else {
        [self loadStyleChoiceTopView];
        self.styleChoiceTopView.delegate = self;
        self.styleChoiceTopView.shopId = _shopId;
        self.styleChoiceTopView.fromViewTag = STYLE_CHOICE_VIEW;
        self.styleChoiceTopView.conditionOfInit = self.condition;
        [self.styleChoiceTopView loaddatas];
        [self.styleChoiceTopView oper];
    }
    
}

/*加载商品款式筛选页面*/
- (void)loadStyleChoiceTopView
{
    if (self.styleChoiceTopView) {
        self.styleChoiceTopView.view.hidden = NO;
    }else{
        self.styleChoiceTopView = [[StyleChoiceTopView alloc] initWithNibName:[SystemUtil getXibName:@"StyleChoiceTopView"] bundle:nil];
        [self.view addSubview:self.styleChoiceTopView.view];
    }
}

- (void)showStyleListView:(NSMutableDictionary *)condition
{
    self.searchBar.keyWordTxt.text = nil;
    self.condition = condition;
    [self.tableview headerBeginRefreshing];
    //    [self.searchBar initDelagate:self placeholder:@"名称/款号"];
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSWechatGoodCell *cell = [LSWechatGoodCell wechatGoodCellAtTableView:tableView];
    Wechat_StyleVo *styleVo = [self.datas objectAtIndex:indexPath.row];
    cell.styleVo = styleVo;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // --> 微店款式详情
    WechatGoodsManagementStyleDetailViewViewController *wechatGoodsManagementStyleDetailViewViewController = [[WechatGoodsManagementStyleDetailViewViewController alloc]initWithNibName:[SystemUtil getXibName:@"WechatGoodsManagementStyleDetailView"] bundle:nil];
    _tempVo = [self.datas objectAtIndex:indexPath.row];
    wechatGoodsManagementStyleDetailViewViewController.styleId =_tempVo.styleId;
    wechatGoodsManagementStyleDetailViewViewController.shopId = _shopId;
    wechatGoodsManagementStyleDetailViewViewController.action = ACTION_CONSTANTS_EDIT;
    wechatGoodsManagementStyleDetailViewViewController.detai = WECHAT_STYLE_MicroInfo;
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    [self.navigationController pushViewController:wechatGoodsManagementStyleDetailViewViewController animated:NO];
    
}
- (void)showEditNVItemEvent:(NSString *)event withObj:(id<INameValueItem>)obj
{
    //    WechatGoodsManagementStyleDetailViewViewController *wechatGoodsManagementStyleDetailViewViewController = [[WechatGoodsManagementStyleDetailViewViewController alloc]initWithNibName:[SystemUtil getXibName:@"WechatGoodsManagementStyleDetailView"] bundle:nil];
    //    _tempVo = (Wechat_StyleVo*) obj;
    //    //[wechatGoodsManagementStyleDetailViewViewController loaddatas:_shopId goodsId:_tempVo.styleId action:ACTION_CONSTANTS_EDIT];
    //    wechatGoodsManagementStyleDetailViewViewController.styleId =_tempVo.styleId;
    //    wechatGoodsManagementStyleDetailViewViewController.shopId = _shopId;
    //    wechatGoodsManagementStyleDetailViewViewController.action = ACTION_CONSTANTS_EDIT;
    //    wechatGoodsManagementStyleDetailViewViewController.detai = WECHAT_STYLE_MicroInfo;
    //    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    //    [self.navigationController pushViewController:wechatGoodsManagementStyleDetailViewViewController animated:NO];
    
}

@end
