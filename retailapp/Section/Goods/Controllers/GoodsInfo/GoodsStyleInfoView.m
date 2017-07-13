//
//  GoodsStyleInfoView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/10/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsStyleInfoView.h"
#import "UIHelper.h"
#import "SearchBar2.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "GoodsModuleEvent.h"
#import "SelectOrgShopListView.h"
#import "ShopVo.h"
#import "XHAnimalUtil.h"
#import "Platform.h"
#import "CategoryVo.h"
#import "JsonHelper.h"
#import "ExportView.h"
#import "ListStyleVo.h"
#import "GoodsStyleListView.h"
#import "StyleTopSelectView.h"
#import "GoodsStyleEditView.h"
#import "ColorHelper.h"
#import "DateUtils.h"
#import "StyleVo.h"
#import "UIView+Sizes.h"
#import "LSEditItemList.h"

@interface GoodsStyleInfoView ()

@property (nonatomic, strong) GoodsService* goodsService;
@property (nonatomic, retain) NSString *searchCode;
@property (nonatomic, retain) NSString *shopId;
@property (nonatomic) int styleCount;
@property (nonatomic, retain) NSMutableArray *categoryList;
@property (nonatomic, retain)  StyleVo* addStyleVo;
@end

@implementation GoodsStyleInfoView



- (void)viewDidLoad {
    [super viewDidLoad];
    _goodsService = [ServiceFactory shareInstance].goodsService;
    [self initMainView];
    [self initHead];
    [self configViews];
    [self loaddatas];
}

- (void)configViews {
    //初始化标题栏
    CGFloat y = kNavH;
    
    
    if ([[Platform Instance] getShopMode] == 3) {
        //初始化机构门店
        self.lsShopName = [LSEditItemList editItemList];
        [self.lsShopName initLabel:@"机构/门店" withHit:nil delegate:self];
        [self.lsShopName.line setHidden:YES];
        [self.lsShopName.imgMore setImage:[UIImage imageNamed:@"ico_next"]];
        self.lsShopName.ls_top = y;
        self.lsShopName.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        [self.view addSubview:self.lsShopName];
        [self.lsShopName initData:[[Platform Instance] getkey:SHOP_NAME] withVal:[[Platform Instance] getkey:SHOP_ID]];
        y = y + self.lsShopName.ls_height;
    }
    
    //初始化搜索框
    self.searchBar = [SearchBar2 searchBar2];
    self.searchBar.ls_top = y;
    [self.searchBar initDelagate:self placeholder:@"名称/款号"];
    [self.view addSubview:self.searchBar];
    y = y + self.searchBar.ls_height;
    
    //款式总数
    self.lstTotalNum = [LSEditItemList editItemList];
    [self.lstTotalNum initLabel:@"款式总数" withHit:nil delegate:self];
    [self.lstTotalNum.line setHidden:YES];
    [self.lstTotalNum.imgMore setImage:[UIImage imageNamed:@"ico_next"]];
    self.lstTotalNum.ls_top = y;
    self.lstTotalNum.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:self.lstTotalNum];

    //初始化工具栏
    self.footView = [LSFooterView footerView];
    y = self.view.ls_height - self.footView.ls_height;
    self.footView.ls_top = y;
    NSMutableArray* arr= nil;
    if (![[Platform Instance] lockAct:ACTION_GOODS_STYLE_ADD]) {
        arr=[[NSMutableArray alloc] initWithObjects:kFootAdd, kFootExport, nil];
    } else {
        arr=[[NSMutableArray alloc] initWithObjects: kFootExport, nil];
    }
    [self.footView initDelegate:self btnsArray:arr];
    [self.view addSubview:self.footView];
    self.shopId = [[Platform Instance] getkey:SHOP_ID];
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootExport]) {
        [self showExportEvent];
    } else if ([footerType isEqualToString:kFootAdd]) {
        [self showAddEvent];
    }
}

- (void)loaddatas
{
    self.searchBar.keyWordTxt.text = @"";
    _shopId = [[Platform Instance] getkey:SHOP_ID];
    [self.lsShopName initData:[[Platform Instance] getkey:SHOP_NAME] withVal:[[Platform Instance] getkey:SHOP_ID]];
    [self selectStyleCount];
    
    [UIHelper refreshUI:self.container];
}

- (void)loadDatasFromEdit
{
    [self selectStyleCount];
}

- (void)selectStyleCount
{
    __weak GoodsStyleInfoView* weakSelf = self;
    [_goodsService selectStyleCount:[weakSelf.lsShopName getStrVal] completionHandler:^(id json) {
        [weakSelf responseSuccess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)responseSuccess:(id)json
{
    _styleCount = [[json objectForKey:@"styleCount"] intValue];
    [self fillModel];
}

- (void)showAddEvent
{
    GoodsStyleEditView* vc = [[GoodsStyleEditView alloc] init];
    vc.styleId = nil;
    vc.shopId = _shopId;
    vc.action = ACTION_CONSTANTS_ADD;
    vc.viewTag = GOODS_STYLE_INFO_VIEW;
    vc.synShopId = [self.lsShopName getStrVal];
    vc.synShopName = self.lsShopName.lblVal.text;
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    [self.navigationController pushViewController:vc animated:NO];
}

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

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event == LSNavigationBarButtonDirectLeft) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else {
        [self loadStyleTopSelectView];
        self.styleTopSelectView.delegate = self;
        self.styleTopSelectView.shopId = _shopId;
        self.styleTopSelectView.shopName = self.lsShopName.lblVal.text;
        self.styleTopSelectView.fromViewTag = GOODS_STYLE_INFO_VIEW;
        NSMutableDictionary* condition = [[NSMutableDictionary alloc] init];
        [condition setValue:@"" forKey:@"categoryId"];
        [condition setValue:@"" forKey:@"applySex"];
        [condition setValue:@"" forKey:@"prototypeValId"];
        [condition setValue:@"" forKey:@"auxiliaryValId"];
        [condition setValue:@"" forKey:@"year"];
        [condition setValue:@"" forKey:@"seasonValId"];
        [condition setValue:@"" forKey:@"minHangTagPrice"];
        [condition setValue:@"" forKey:@"maxHangTagPrice"];
        self.styleTopSelectView.conditionOfInit = condition;
        [self.styleTopSelectView loaddatas];
        [self.styleTopSelectView oper];
    }
}

/*加载商品款式筛选页面*/
- (void)loadStyleTopSelectView
{
    if (self.styleTopSelectView) {
        self.styleTopSelectView.view.hidden = NO;
    }else{
        self.styleTopSelectView = [[StyleTopSelectView alloc] initWithNibName:[SystemUtil getXibName:@"StyleTopSelectView"] bundle:nil];
        [self.view addSubview:self.styleTopSelectView.view];
    }
}

- (void)showStyleListView:(NSMutableDictionary *)condition
{
    GoodsStyleListView* vc = [[GoodsStyleListView alloc] init];
    vc.synShopId = [self.lsShopName getStrVal];
    vc.synShopName = self.lsShopName.lblVal.text;
    vc.condition = condition;
    vc.conditionOfInit = condition;
    vc.conditionOfBatchView = condition;
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    [self.navigationController pushViewController:vc animated:NO];
    [vc.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)fillModel
{
    self.lstTotalNum.lblVal.text = [NSString stringWithFormat:@"%d", _styleCount];
}

- (void)initHead
{
    [self configTitle:@"款式" leftPath:Head_ICON_BACK rightPath:nil];
    [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"筛选" filePath:Head_ICON_CHOOSE];
}

- (void)initMainView
{
    [self.lsShopName initLabel:@"机构/门店" withHit:nil delegate:self];
    [self.lsShopName.line setHidden:YES];
    [self.lsShopName.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    
    self.lsShopName.tag = GOODS_STYLE_INFO_SHOPNAME;
    
    if ([[Platform Instance] getShopMode] != 3) {
        [self.lsShopName visibal:NO];
        self.searchBar.view.frame = CGRectMake(0, 64, 320, 44);
    }else{
        [self.lsShopName visibal:YES];
        [self.lsShopName setLs_height:48];
        self.searchBar.view.frame = CGRectMake(0, 106, 320, 44);
    }
    [UIHelper refreshUI:self.container];
}

- (void)onItemListClick:(LSEditItemList *)obj
{
    if (obj == self.lsShopName) {
        //跳转页面至选择门店
        SelectOrgShopListView* vc = [[SelectOrgShopListView alloc] init];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [self.navigationController pushViewController:vc animated:NO];
        __weak GoodsStyleInfoView* weakSelf = self;
        [vc loadData:[obj getStrVal] withModuleType:3 withCheckMode:SINGLE_CHECK callBack:^(NSMutableArray *selectArr, id<ITreeItem> item) {
            if (item) {
                ShopVo* vo1 = [[ShopVo alloc] init];
                vo1.shopName = [item obtainItemName];
                vo1.shopId = [item obtainItemId];
                [weakSelf.lsShopName initData:vo1.shopName withVal:vo1.shopId];
                weakSelf.shopId = vo1.shopId;
                [weakSelf selectStyleCount];
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
        }];
    } else if (obj == self.lstTotalNum) {
        [self clickGoodsNum];
    }
}

- (void)clickGoodsNum
{
    if (_styleCount == 0) {
        [AlertBox show:@"未查找到款式!"];
        return ;
    }
    if (_styleCount == 1) {
        __weak GoodsStyleInfoView *weakSelf = self;
        self.searchCode = @"";
        NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
        [condition setValue:@"1" forKey:@"searchType"];
        [condition setValue:[weakSelf.lsShopName getStrVal] forKey:@"shopId"];
        [condition setValue:@"" forKey:@"searchCode"];
        [condition setValue:@"" forKey:@"categoryId"];
        [condition setValue:@"" forKey:@"applySex"];
        [condition setValue:@"" forKey:@"prototypeValId"];
        [condition setValue:@"" forKey:@"auxiliaryValId"];
        [condition setValue:@"" forKey:@"year"];
        [condition setValue:@"" forKey:@"seasonValId"];
        [condition setValue:@"" forKey:@"minHangTagPrice"];
        [condition setValue:@"" forKey:@"maxHangTagPrice"];
        [condition setValue:@"" forKey:@"createTime"];
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
            ListStyleVo* vo = [styleArray objectAtIndex:0];
            GoodsStyleEditView* vc = [[GoodsStyleEditView alloc] init];
            vc.styleId = vo.styleId;
            vc.shopId = _shopId;
            vc.action = ACTION_CONSTANTS_EDIT;
            vc.viewTag = GOODS_STYLE_INFO_VIEW;
            vc.synShopId = [self.lsShopName getStrVal];
            vc.synShopName = self.lsShopName.lblVal.text;
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
            [weakSelf.navigationController pushViewController:vc animated:NO];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }else {
        NSMutableDictionary* condition = [[NSMutableDictionary alloc] init];
        [condition setValue:@"2" forKey:@"searchType"];
        [condition setValue:_shopId forKey:@"shopId"];
        [condition setValue:self.lsShopName.lblVal.text forKey:@"shopName"];
        [condition setValue:@"" forKey:@"searchCode"];
        [condition setValue:@"" forKey:@"categoryId"];
        [condition setValue:@"" forKey:@"applySex"];
        [condition setValue:@"" forKey:@"prototypeValId"];
        [condition setValue:@"" forKey:@"auxiliaryValId"];
        [condition setValue:@"" forKey:@"year"];
        [condition setValue:@"" forKey:@"seasonValId"];
        [condition setValue:@"" forKey:@"minHangTagPrice"];
        [condition setValue:@"" forKey:@"maxHangTagPrice"];
        [condition setValue:@"" forKey:@"createTime"];
        GoodsStyleListView* vc = [[GoodsStyleListView alloc] init];
        vc.synShopId = [self.lsShopName getStrVal];
        vc.synShopName = self.lsShopName.lblVal.text;
        vc.condition = condition;
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [self.navigationController pushViewController:vc animated:NO];
    }
}

#pragma mark 搜索框输入完成方法
- (void)imputFinish:(NSString *)keyWord
{  
    self.searchCode = keyWord;
    [self remoteFinish];
}

- (void)remoteFinish
{
    __weak GoodsStyleInfoView* weakSelf = self;
    NSMutableDictionary* condition = [[NSMutableDictionary alloc] init];
    [condition setValue:@"1" forKey:@"searchType"];
    [condition setValue:[weakSelf.lsShopName getStrVal] forKey:@"shopId"];
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
        
        if ([[json objectForKey:@"searchStatus"] integerValue] == 1) {
            if (styleArray.count == 1) {
                ListStyleVo* vo = [styleArray objectAtIndex:0];
                GoodsStyleEditView* vc = [[GoodsStyleEditView alloc] init];
                vc.styleId = vo.styleId;
                vc.shopId = _shopId;
                vc.action = ACTION_CONSTANTS_EDIT;
                vc.viewTag = GOODS_STYLE_INFO_VIEW;
                vc.synShopId = [self.lsShopName getStrVal];
                vc.synShopName = self.lsShopName.lblVal.text;
                [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                [weakSelf.navigationController pushViewController:vc animated:NO];
            }else if (styleArray.count == 0){
                if (![[Platform Instance] lockAct:ACTION_GOODS_STYLE_ADD]) {
                    static UIAlertView *alertView;
                    if (alertView != nil) {
                        [alertView dismissWithClickedButtonIndex:0 animated:NO];
                        alertView = nil;
                    }
                    alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您查询的款式不存在，是否添加该款式?" delegate:self cancelButtonTitle:@"是"  otherButtonTitles:@"否", nil];
                    [alertView show];
                }
            }else{
                NSString* time = nil;
                if ([ObjectUtil isNotNull:[json objectForKey:@"createTime"]]) {
                    time = [[json objectForKey:@"createTime"] stringValue];
                }
                NSMutableDictionary* condition = [[NSMutableDictionary alloc] init];
                [condition setValue:@"1" forKey:@"searchType"];
                [condition setValue:_shopId forKey:@"shopId"];
                [condition setValue:weakSelf.lsShopName.lblVal.text forKey:@"shopName"];
                [condition setValue:_searchCode forKey:@"searchCode"];
                [condition setValue:@"" forKey:@"categoryId"];
                [condition setValue:@"" forKey:@"applySex"];
                [condition setValue:@"" forKey:@"prototypeValId"];
                [condition setValue:@"" forKey:@"auxiliaryValId"];
                [condition setValue:@"" forKey:@"year"];
                [condition setValue:@"" forKey:@"seasonValId"];
                [condition setValue:@"" forKey:@"minHangTagPrice"];
                [condition setValue:@"" forKey:@"maxHangTagPrice"];
                [condition setValue:time forKey:@"createTime"];
                [condition setValue:styleArray forKey:@"styleList"];
                GoodsStyleListView* vc = [[GoodsStyleListView alloc] init];
                vc.synShopId = [self.lsShopName getStrVal];
                vc.synShopName = self.lsShopName.lblVal.text;
                vc.condition = condition;
                [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
                [weakSelf.navigationController pushViewController:vc animated:NO];
                [vc.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
        } else if ([[json objectForKey:@"searchStatus"] integerValue] == 0) {
            if (![[Platform Instance] lockAct:ACTION_GOODS_STYLE_ADD]) {
                [weakSelf selectStyleBaseInfo:nil];
            }
        } else {
            if (![[Platform Instance] lockAct:ACTION_GOODS_STYLE_ADD]) {
                ListStyleVo* vo = [styleArray objectAtIndex:0];
                [weakSelf selectStyleBaseInfo:vo];
            }
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark 查询款式基础信息
- (void)selectStyleBaseInfo:(ListStyleVo*) listStyleVo
{
    if (listStyleVo == nil) {
        _addStyleVo = nil;
        static UIAlertView *alertView;
        if (alertView != nil) {
            [alertView dismissWithClickedButtonIndex:0 animated:NO];
            alertView = nil;
        }
        alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您查询的款式不存在，是否添加该款式?" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
        [alertView show];
    } else {
        __weak GoodsStyleInfoView* weakSelf = self;
        [_goodsService selectStyleBaseInfo:listStyleVo.styleId completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            _addStyleVo = [StyleVo convertToStyleVo:[json objectForKey:@"styleVo"]];
            static UIAlertView *alertView;
            if (alertView != nil) {
                [alertView dismissWithClickedButtonIndex:0 animated:NO];
                alertView = nil;
            }
            alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您查询的款式不存在，是否添加该款式?" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
            [alertView show];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        GoodsStyleEditView* vc = [[GoodsStyleEditView alloc] init];
        vc.styleId = nil;
        vc.shopId = _shopId;
        vc.action = ACTION_CONSTANTS_ADD;
        vc.viewTag = GOODS_STYLE_INFO_VIEW;
        if (_addStyleVo == nil) {
            _addStyleVo = [[StyleVo alloc] init];
        }
        vc.addStyleVo = _addStyleVo;
        //如果输入的是数字默认赋值到详情添加页
        if ([NSString isValidNumber:self.searchCode]) {
            vc.addStyleVo.styleCode = self.searchCode;
        }
        vc.synShopId = [self.lsShopName getStrVal];
        vc.synShopName = self.lsShopName.lblVal.text;
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController pushViewController:vc animated:NO];
    }
}


@end
