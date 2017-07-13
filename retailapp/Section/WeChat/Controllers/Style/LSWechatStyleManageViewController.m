//
//  LSWechatStyleManageViewController.m
//  retailapp
//
//  Created by guozhi on 16/10/9.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSWechatStyleManageViewController.h"
#import "ISearchBarEvent.h"
#import "FooterListEvent.h"
#import "StyleChoiceTopView.h"
#import "NavigateTitle2.h"
#import "WechatGoodsTopSelectView.h"
#import "WechatGoodsManagementStyleView.h"
#import "WechatGoodsManagementStyleDetailViewViewController.h"
#import "WechatGoodsManagementStyleAddChooseView.h"
#import "ThemeRecommendedStyleViewController.h"
#import "LSFooterView.h"
#import "NavigateTitle2.h"
#import "UIHelper.h"
#import "SearchBar2.h"
#import "XHAnimalUtil.h"
#import "WechatService.h"
#import "GoodsService.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "Wechat_StyleVo.h"
#import "ListStyleVo.h"
#import "MicroBasicSetVo.h"
#import "EditItemList.h"
#import "StyleChoiceView.h"
#import "DateUtils.h"
#import "LSOneClickView.h"
#import "LSSelectCategoryListViewController.h"

@interface LSWechatStyleManageViewController ()<LSFooterViewDelegate, INavigateEvent,IEditItemListEvent, ISearchBarEvent,StyleChoiceTopViewDelegate,UIActionSheetDelegate>
@property (nonatomic)NavigateTitle2 *titleBox;
@property (strong, nonatomic)  SearchBar2 *searchbar;
@property (strong, nonatomic)  LSFooterView *footView;

@property (nonatomic, retain) NSString *action;
@property (nonatomic, retain) StyleChoiceTopView *styleChoiceTopView;
@property (nonatomic, strong) EditItemList *lstStyleCount;

@property (nonatomic , strong) WechatService* wechatService;



@property (nonatomic, strong) GoodsService* goodsService;

@property (nonatomic, retain) NSString *searchCode;

@property (nonatomic, retain) NSString *shopId;

@property (nonatomic) int styleCount;

@property (nonatomic, retain) NSMutableArray *categoryList;

@property (nonatomic, strong) MicroBasicSetVo *microBasicSetVo;

//微店商品管理 筛选页面
@property (nonatomic, strong)WechatGoodsTopSelectView *wechatGoodsTopSelectView;

@property (nonatomic, strong) NSMutableDictionary* condition;

//添加选择页面
@property (nonatomic, strong)WechatGoodsManagementStyleAddChooseView *wechatGoodsManagementStyleAddChooseView;


@end

@implementation LSWechatStyleManageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNotification];
    [self initMainView];
}

- (void)initMainView {
     _goodsService = [ServiceFactory shareInstance].goodsService;
    CGFloat y = 0;
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"微店款式" backImg:Head_ICON_BACK moreImg:Head_ICON_CHOOSE];
    self.titleBox.lblRight.text = @"筛选";
    [self.view addSubview:self.titleBox];
    self.titleBox.ls_top = y;
    y = y + self.titleBox.ls_height;
    
    self.searchbar = [SearchBar2 searchBar2];
    [self.searchbar initDelagate:self placeholder:@"名称/款号"];
    [self.view addSubview:self.searchbar];
    self.searchbar.ls_top = y;
    y = y + self.searchbar.ls_height;
    
    self.lstStyleCount = [EditItemList editItemList];
    [self.lstStyleCount initLabel:@"款式总数" withHit:nil delegate:self];
    self.lstStyleCount.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:self.lstStyleCount];
    self.lstStyleCount.imgMore.image = [UIImage imageNamed:@"ico_next"];
    self.lstStyleCount.ls_top = y;
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootOneClick, kFootAdd]];
    [self.view addSubview:self.footView];
    self.footView.ls_bottom = SCREEN_H;

}
- (void)initNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messagePushed:) name:Notification_System_Message_Push object:nil];
}
- (void)messagePushed:(NSNotification *)notification {
    if (self.oneClickView) {
        self.oneClickView.hidden = YES;
    }
    [self loaddatas];
}

- (void)onItemListClick:(EditItemList *)obj {
    if (obj == self.lstStyleCount) {
        NSMutableDictionary* condition = [[NSMutableDictionary alloc] init];
        [condition setValue:@"1" forKey:@"searchType"];
        [condition setValue:_shopId forKey:@"shopId"];
        [condition setValue:nil forKey:@"searchCode"];
        [condition setValue:nil forKey:@"categoryId"];
        [condition setValue:nil forKey:@"applySex"];
        [condition setValue:nil forKey:@"year"];
        [condition setValue:nil forKey:@"season"];
        [condition setValue:nil forKey:@"minHangTagPrice"];
        [condition setValue:nil forKey:@"maxHangTagPrice"];
        [condition setValue:nil forKey:@"createTime"];
        WechatGoodsManagementStyleView *wechatGoodsManagementStyleView = [[WechatGoodsManagementStyleView alloc] initWithNibName:[SystemUtil getXibName:@"WechatGoodsManagementStyleView"] bundle:nil];
        wechatGoodsManagementStyleView.condition = condition;
        [self.navigationController pushViewController:wechatGoodsManagementStyleView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }
}
- (LSOneClickView *)oneClickView {
    if (_oneClickView == nil) {
        _oneClickView = [LSOneClickView show:self];
        _oneClickView.hidden = YES;
    }
    return _oneClickView;
}
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    } else if ([footerType isEqualToString:kFootOneClick]) {
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
}

- (void)showOneClickAlert:(int)count {
    NSString *str = [NSString stringWithFormat:@"此次共有%d种商品按“与零售价相同”的售价策略上架到微店销售！上架需要花费几分钟时间，请耐心等待～～\n为了保证商品数据的一致性，一键上架过程中，将无法添加或修改商品信息，建议此操作在非营业时间进行！", count];
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *url = @"microGoods/quickSetSale";
        [BaseService getRemoteLSDataWithUrl:url param:nil withMessage:nil show:YES CompletionHandler:^(id json) {
            if ([ObjectUtil isNotNull:json[@"quickSetStatus"]]) {
                if ([json[@"quickSetStatus"] intValue] == 1) {//正在一键上架时才返回值1
                    self.oneClickView.hidden = NO;
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
    _wechatService = [ServiceFactory shareInstance].wechatService;
    [self loaddatas];
//    [self checkCode];
}


- (void)loaddatas
{
    _shopId = [[Platform Instance] getkey:SHOP_ID];

    [self selectStyleCount];
    
}

- (void)selectStyleCount
{
    __weak typeof(self) wself = self;
    [_wechatService selectStyleCount:self.shopId completionHandler:^(id json) {
        [wself responseSuccess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)responseSuccess:(id)json
{
    self.lstStyleCount.lblVal.hidden = NO;
    if ([ObjectUtil isNotNull:json[@"quickSetStatus"]]) {
        if ([json[@"quickSetStatus"] intValue] == 1) {//正在一键上架时才返回值1
            self.lstStyleCount.lblVal.hidden = YES;
        }
    }
    if ([ObjectUtil isNotNull:json[@"count"]]) {//正在一键上架时不返回值
        _styleCount = [json[@"count"] intValue];
        NSString *styleCount = [NSString stringWithFormat:@"%d", _styleCount];
        [self.lstStyleCount initData:styleCount withVal:styleCount];
    }
    
}
//查看是否启用主题销售包
//- (void)checkCode{
//     __weak typeof(self) wself = self;
//    [_wechatService SelectCode:@"CONFIG_START_THEMEPACKAGE" completionHandler:^(id json) {
//        wself.microBasicSetVo = [MicroBasicSetVo converToVo:[json objectForKey:@"microBasicSetVo"]];
//    } errorHandler:^(id json) {
//        [AlertBox show:json];
//    }];
//}

- (void)showAddEvent
{
//    NSLog(@"%hd",[[Platform Instance] getShopMode]);
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
    }
    else if ([[Platform Instance] getShopMode] == 2 || [[Platform Instance] getShopMode] == 3) {
        //门店 微店设置中的“启用主题销售包”开关状态，关闭进入款式选择共通页面，开，进入选择状态
//        if ([self.microBasicSetVo.value isEqualToString:@"1"]) { //开启
//            UIActionSheet *menu = [[UIActionSheet alloc]
//                                   initWithTitle:nil
//                                   delegate:self
//                                   cancelButtonTitle:@"取消"
//                                   destructiveButtonTitle:nil
//                                   otherButtonTitles: @"自选款式", @"主题推荐款式", nil];
//            [menu showInView:self.view];
//        }else if ([self.microBasicSetVo.value isEqualToString:@"2"]) { //关闭
        
            StyleChoiceView *styleChoiceView = [[StyleChoiceView alloc]init];
            
            _shopId = [[Platform Instance] getkey:SHOP_ID];
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
//    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self btnSelfChooseclick];
    }else if (buttonIndex ==1){
        [self btnSubjectclick];
    }
}
//自选款式进入款式选择共通页面
- (void)btnSelfChooseclick {
   _shopId = [[Platform Instance] getkey:SHOP_ID];
    [self.wechatGoodsManagementStyleAddChooseView.view removeFromSuperview];
    StyleChoiceView *styleChoiceView = [[StyleChoiceView alloc]init];
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
//主题推荐款式进入选择主题销售包
- (void)btnSubjectclick {
    
    [self.wechatGoodsManagementStyleAddChooseView.view removeFromSuperview];
    ThemeRecommendedStyleViewController *themeRecommendedStyleViewController = [[ThemeRecommendedStyleViewController alloc]initWithNibName:[SystemUtil getXibName:@"ThemeRecommendedStyleViewController"] bundle:nil];
    
    [self.navigationController pushViewController:themeRecommendedStyleViewController animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    
}

- (void)onNavigateEvent:(Direct_Flag)event
{
    if (event == 1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else {
        if (self.oneClickView.hidden == NO) {
            [AlertBox show:@"一键上架微店商品正在进行中，暂时无法进行该操作！"];
            return;
        }
        
        [self loadStyleChoiceTopView];
        self.styleChoiceTopView.delegate = self;
        self.styleChoiceTopView.shopId = _shopId;
        self.styleChoiceTopView.fromViewTag = STYLE_CHOICE_VIEW;
        NSMutableDictionary* condition = [[NSMutableDictionary alloc] init];
        [condition setValue:@"" forKey:@"categoryId"];
        [condition setValue:@"" forKey:@"applySex"];
        [condition setValue:@"" forKey:@"prototypeValId"];
        [condition setValue:@"" forKey:@"auxiliaryValId"];
        [condition setValue:@"" forKey:@"year"];
        [condition setValue:@"" forKey:@"seasonValId"];
        [condition setValue:@"" forKey:@"minHangTagPrice"];
        [condition setValue:@"" forKey:@"maxHangTagPrice"];
        self.styleChoiceTopView.conditionOfInit = condition;
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
    WechatGoodsManagementStyleView *wechatGoodsManagementStyleView = [[WechatGoodsManagementStyleView alloc] initWithNibName:[SystemUtil getXibName:@"WechatGoodsManagementStyleView"] bundle:nil];
    wechatGoodsManagementStyleView.condition = condition;
    self.searchbar.keyWordTxt.text=nil;
    [self.navigationController pushViewController:wechatGoodsManagementStyleView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}


// 搜索框输入完成方法
- (void)imputFinish:(NSString *)keyWord
{
    self.searchCode = keyWord;
    [self searchData:1];
}

- (void)searchData:(int)act
{
    [self remoteFinish];
    
}

- (void)remoteFinish
{
     __weak typeof(self) wself = self;
    [_wechatService selectMicroStyleList:@1 shopId:self.shopId searchCode:self.searchCode categoryId:nil applySex:nil year:nil seasonValId:nil minHangTagPrice:nil maxHangTagPrice:nil createTime:nil completionHandler:^(id json) {
        NSMutableArray *styleArray = [[NSMutableArray alloc] init];
        if ([ObjectUtil isNotNull:[json objectForKey:@"styleVoList"]]) {
            for (NSDictionary* dic in [json objectForKey:@"styleVoList"]) {
                [styleArray addObject:[Wechat_StyleVo convertToListStyleVo:dic]];
            }
        }
        
        if (styleArray.count == 1) {
            //只查询到一条直接跳转到微店款式详情页面
            WechatGoodsManagementStyleDetailViewViewController *wechatGoodsManagementStyleDetailViewViewController = [[WechatGoodsManagementStyleDetailViewViewController alloc]initWithNibName:[SystemUtil getXibName:@"WechatGoodsManagementStyleDetailView"] bundle:nil];
            
            //[wechatGoodsManagementStyleDetailViewViewController loaddatas:_shopId goodsId:_tempVo.styleId action:ACTION_CONSTANTS_EDIT];
            for (NSDictionary* dic in [json objectForKey:@"styleVoList"]) {
                wechatGoodsManagementStyleDetailViewViewController.styleId =dic[@"styleId"];
            }
            
            wechatGoodsManagementStyleDetailViewViewController.shopId = _shopId;
            wechatGoodsManagementStyleDetailViewViewController.action = ACTION_CONSTANTS_EDIT;
            wechatGoodsManagementStyleDetailViewViewController.detai = WECHAT_STYLE_MicroInfo;
            wself.searchbar.keyWordTxt.text=nil;
            [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
            [wself.navigationController pushViewController:wechatGoodsManagementStyleDetailViewViewController animated:NO];
            
        }else if (styleArray.count == 0){
            static UIAlertView *alertView;
            if (alertView != nil) {
                [alertView dismissWithClickedButtonIndex:0 animated:NO];
                alertView = nil;
            }
            alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该款式未在微店销售，确认要在微店设置销售吗？" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
            alertView.tag = 1;
            [alertView show];
        }else{
            NSString* time = nil;
            if ([ObjectUtil isNotNull:[json objectForKey:@"createTime"]]) {
                time = [[json objectForKey:@"createTime"] stringValue];
            }
            
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
            [condition setValue:time forKey:@"createTime"];
            [condition setValue:styleArray forKey:@"styleList"];
            
            WechatGoodsManagementStyleView *wechatGoodsManagementStyleView = [[WechatGoodsManagementStyleView alloc] initWithNibName:[SystemUtil getXibName:@"WechatGoodsManagementStyleView"] bundle:nil];
            //[wechatGoodsManagementStyleView loaddatas:condition];
            wechatGoodsManagementStyleView.condition = condition;
            [wechatGoodsManagementStyleView.tableview setContentOffset:CGPointMake(0, 0) animated:YES];
            [self.navigationController pushViewController:wechatGoodsManagementStyleView animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            [self selectstylelist];
        }
        
    } else if (alertView.tag == 2){
        
    }
}


- (void)selectstylelist{
    __weak typeof(self) wself = self;
    NSMutableDictionary* condition = [[NSMutableDictionary alloc] init];
    [condition setValue:@"1" forKey:@"searchType"];
   _shopId = [[Platform Instance] getkey:SHOP_ID];
    
    [condition setValue:wself.shopId forKey:@"shopId"];
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
        }else{
            //多条数据进入选择款式(单选)共通页面
            StyleChoiceView *styleChoiceView = [[StyleChoiceView alloc]init];
            styleChoiceView.searchCode=self.searchbar.keyWordTxt.text;
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_System_Message_Push object:nil];
}



@end
