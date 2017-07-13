//
//  LSStockQueryViewController.m
//  retailapp
//
//  Created by guozhi on 2017/2/6.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSStockQueryViewController.h"
#import "StockModuleEvent.h"
#import "LSEditItemList.h"
#import "SearchBar.h"
#import "SearchBar2.h"
#import "LSFooterView.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "OptionPickerBox.h"
#import "SymbolNumberInputBox.h"
#import "DateUtils.h"
#import "CategoryVo.h"
#import "AttributeValVo.h"
#import "GoodsRender.h"
#import "SelectShopStoreListView.h"
#import "SelectShopListView.h"
#import "LSStockQueryListController.h"
#import "ScanViewController.h"
#import "SRender.h"
#import "XHAnimalUtil.h"

@interface LSStockQueryViewController ()<ISearchBarEvent,IEditItemListEvent,OptionPickerClient,SymbolNumberInputClient,LSScanViewDelegate, LSFooterViewDelegate>

@property (nonatomic, assign) NSInteger shopMode;
//分类、中品类
@property (nonatomic, strong) NSMutableArray *categoryList;
//主型
@property (nonatomic, strong) NSMutableArray *principalTypeList;
//辅型
@property (nonatomic, strong) NSMutableArray *accessoryTypeList;
//季节库
@property (nonatomic, strong) NSMutableArray *seasonList;
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, copy) NSString *scanCode;
@property (nonatomic, copy) NSString *shopStoreId;
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *season;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) SearchBar *searchBar;
@property (nonatomic, strong) SearchBar2 *searchBar2;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) LSEditItemList *lsShopStore;
@property (nonatomic, strong) LSEditItemList *lsShop;
@property (nonatomic, strong) LSEditItemList *lsCategory;
@property (nonatomic, strong) LSEditItemList *lsPrincipalType;
@property (nonatomic, strong) LSEditItemList *lsAccessoryType;
@property (nonatomic, strong) LSEditItemList *lsSex;
@property (nonatomic, strong) LSEditItemList *lsYear;
@property (nonatomic, strong) LSEditItemList *lsSeason;
@property (nonatomic, strong) LSFooterView *footView;
@end

@implementation LSStockQueryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.shopMode = [[Platform Instance] getShopMode];
    self.seasonList = [NSMutableArray array];
    self.principalTypeList = [NSMutableArray array];
    self.accessoryTypeList = [NSMutableArray array];
    [self configViews];
    [self configConstraints];
    [self configContainerViews];
    [self showView];
    [self configHelpButton:HELP_STOCK_QUERY];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}


- (void)configViews {
    self.view.backgroundColor = [UIColor clearColor];
    //标题
    [self configTitle:@"库存查询" leftPath:Head_ICON_BACK rightPath:nil];
    //搜索
    self.searchBar = [SearchBar searchBar];
    [self.view addSubview:self.searchBar];
    self.searchBar2 = [SearchBar2 searchBar2];
    [self.view addSubview:self.searchBar2];
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootScan]];
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == CLOTHESHOES_MODE) {
        //服鞋
        self.searchBar.hidden = YES;
        [self.searchBar2 initDelagate:self placeholder:@"名称/款号"];
        self.footView.hidden = YES;
    }else {
        //商超
        self.searchBar2.hidden = YES;
        [self.searchBar initDeleagte:self placeholder:@"条形码/简码/拼音码"];    }
    //scollVIew
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    //container
    self.container = [[UIView alloc] init];
    self.container.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.container.ls_width = SCREEN_W;
    [self.scrollView addSubview:self.container];
     [self.view addSubview:self.footView];
}

- (void)configConstraints {
    //标题
    UIView *superView = self.view;
    __weak typeof(self) wself = self;
    //搜索
    [self.searchBar makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.view.top).offset(kNavH);
        make.left.right.equalTo(wself.view);
        make.height.equalTo(44);
    }];
    [self.searchBar2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wself.view.top).offset(kNavH);
        make.left.right.equalTo(wself.view);
        make.height.equalTo(44);
    }];
    [self.footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.height.equalTo(64);
    }];
    //scrollView
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(superView);
        make.top.equalTo(wself.searchBar.bottom);
    }];
    
    
}

- (void)configContainerViews {
    // shopModel: 1 单店 2门店 3组织机构, 组织机构才有该项
    self.lsShopStore = [LSEditItemList editItemList];
    [self.container addSubview:self.lsShopStore];
    
    self.lsShop = [LSEditItemList editItemList];
    [self.container addSubview:self.lsShop];
    
    self.lsCategory = [LSEditItemList editItemList];
    [self.container addSubview:self.lsCategory];
    
    self.lsSex = [LSEditItemList editItemList];
    [self.container addSubview:self.lsSex];
    
    
    self.lsPrincipalType = [LSEditItemList editItemList];
    [self.container addSubview:self.lsPrincipalType];
    
    self.lsAccessoryType = [LSEditItemList editItemList];
    [self.container addSubview:self.lsAccessoryType];
    
    self.lsYear = [LSEditItemList editItemList];
    [self.container addSubview:self.lsYear];
    
    self.lsSeason = [LSEditItemList editItemList];
    [self.container addSubview:self.lsSeason];
    
    UIButton *btn = [LSViewFactor addGreenButton:self.container title:@"查询" y:0];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.lsShopStore initLabel:@"门店/仓库" withHit:nil delegate:self];
    self.lsShopStore.imgMore.image = [UIImage imageNamed:@"ico_next"];
    [self.lsShopStore visibal:(self.shopMode == 3)];
    
    
    [self.lsShop initLabel:@"门店" withHit:nil delegate:self];
    self.lsShop.imgMore.image = [UIImage imageNamed:@"ico_next"];
    [self.lsShop visibal:(self.shopMode == 2 && [[[Platform Instance] getkey:STORE_CHECK_FLAG] isEqualToString:@"1"])];
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == CLOTHESHOES_MODE) {
        [self.lsCategory initLabel:@"中品类" withHit:nil delegate:self];
    }else {
        [self.lsCategory initLabel:@"分类" withHit:nil delegate:self];
    }
    [self.lsPrincipalType initLabel:@"主型" withHit:nil delegate:self];
    [self.lsAccessoryType initLabel:@"辅型" withHit:nil delegate:self];
    [self.lsSex initLabel:@"性别" withHit:nil delegate:self];
    [self.lsYear initLabel:@"年份" withHit:nil delegate:self];
    [self.lsSeason initLabel:@"季节" withHit:nil delegate:self];
    
    self.lsShopStore.tag = SHOP_STORE;
    self.lsShop.tag = SHOP;
    self.lsCategory.tag = CATEGORY;
    self.lsPrincipalType.tag = PRINCIPAL_TYPE;
    self.lsAccessoryType.tag = ACCESSORY_TYPE;
    self.lsSex.tag = SEX;
    self.lsYear.tag = YEAR;
    self.lsSeason.tag = SEASON;

}



- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootScan]) {
        [self showScanEvent];
    }
}
#pragma mark - 显示查询条件项
- (void)showView
{
    [self.lsShopStore visibal:(self.shopMode == 3)];
    [self.lsShopStore initData:@"请选择" withVal:nil];
    if ((self.shopMode == 2)&&([[[Platform Instance] getkey:STORE_CHECK_FLAG] integerValue] == 1)) {
        [self.lsShop visibal:YES];
        [self.lsShop initData:[[Platform Instance] getkey:SHOP_NAME] withVal:[[Platform Instance] getkey:SHOP_ID]];
    }
    [self.lsCategory initData:@"全部" withVal:nil];
    [self.lsPrincipalType visibal:[[[Platform Instance] getkey:SHOP_MODE] integerValue]==CLOTHESHOES_MODE];
    [self.lsPrincipalType initData:@"全部" withVal:nil];
    [self.lsAccessoryType visibal:[[[Platform Instance] getkey:SHOP_MODE] integerValue]==CLOTHESHOES_MODE];
    [self.lsAccessoryType initData:@"全部" withVal:nil];
    [self.lsSex visibal:[[[Platform Instance] getkey:SHOP_MODE] integerValue]==CLOTHESHOES_MODE];
    [self.lsSex initData:@"全部" withVal:nil];
    [self.lsYear visibal:[[[Platform Instance] getkey:SHOP_MODE] integerValue]==CLOTHESHOES_MODE];
    [self.lsYear initData:@"请输入" withVal:nil];
    [self.lsSeason visibal:[[[Platform Instance] getkey:SHOP_MODE] integerValue]==CLOTHESHOES_MODE];
    [self.lsSeason initData:@"全部" withVal:nil];
}

#pragma mark - ISearchEvent协议
- (void)imputFinish:(NSString *)keyWord
{
    self.scanCode = nil;
    self.keyWord = keyWord;
}

#pragma mark - 条形码扫描
- (void)showScanEvent {
    [self scanStart];
}
//开始扫码
- (void)scanStart {
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
}

// LSScanViewDelegate
- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    self.keyWord = nil;
    self.scanCode = scanString;
    self.searchBar.keyWordTxt.text = scanString;
    [self btnClick:nil];
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [AlertBox show:message];
}




#pragma mark - 查询条件
- (void)onItemListClick:(EditItemList *)obj
{
    if (obj.tag == SHOP_STORE) {
        SelectShopStoreListView *shopStoreListView = [[SelectShopStoreListView alloc] init];
        __strong typeof(self) strongSelf = self;
        [shopStoreListView loadData:[obj getStrVal] checkMode:SINGLE_CHECK isPush:YES callBack:^(id<INameCode> item) {
            if (item) {
                [obj initData:[item obtainItemName] withVal:[item obtainItemId]];
            }
            [XHAnimalUtil animal:strongSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [strongSelf.navigationController popToViewController:strongSelf animated:NO];
        }];
        [self.navigationController pushViewController:shopStoreListView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        shopStoreListView = nil;
        
    }else if (obj.tag == SHOP){
        
        SelectShopListView *shopListView = [[SelectShopListView alloc] init];
        __strong typeof(self) strongSelf = self;
        [shopListView loadShopList:[obj getStrVal] withType:1 withViewType:NOT_CONTAIN_ALL withIsPush:YES callBack:^(id<ITreeItem> shop) {
            if (shop) {
                [obj initData:[shop obtainItemName] withVal:[shop obtainItemId]];
            }
            [XHAnimalUtil animal:strongSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [strongSelf.navigationController popViewControllerAnimated:NO];
        }];
        [self.navigationController pushViewController:shopListView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }else if (obj.tag == CATEGORY) {
        if (self.categoryList==nil||self.categoryList.count==0) {
            __strong typeof(self) strongSelf = self;
            if ([[[Platform Instance] getkey:SHOP_MODE] integerValue]==CLOTHESHOES_MODE) {
                NSString *url = @"category/firstCategoryInfo";
                [BaseService getRemoteLSDataWithUrl:url param:nil withMessage:nil show:CGRectMaxYEdge CompletionHandler:^(id json) {
                     strongSelf.categoryList = [CategoryVo converToArr:[json objectForKey:@"categoryList"]];
                    CategoryVo *vo = [[CategoryVo alloc] init];
                    vo.categoryId = @"";
                    vo.name = @"全部";
                    [strongSelf.categoryList insertObject:vo atIndex:0];
                    [OptionPickerBox initData:strongSelf.categoryList itemId:[obj getStrVal]];
                    [OptionPickerBox show:obj.lblName.text client:strongSelf event:obj.tag];
                } errorHandler:^(id json) {
                     [AlertBox show:json];
                }];
            }else{
                NSString* url = @"category/lastCategoryInfo";
                NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
                [param setValue:@"1" forKey:@"hasNoCategory"];
                [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:CGRectMaxYEdge CompletionHandler:^(id json) {
                    strongSelf.categoryList = [CategoryVo converToArr:[json objectForKey:@"categoryList"]];
                    CategoryVo *vo = [[CategoryVo alloc] init];
                    vo.categoryId = @"";
                    vo.name = @"全部";
                    [strongSelf.categoryList insertObject:vo atIndex:0];
                    [OptionPickerBox initData:strongSelf.categoryList itemId:[obj getStrVal]];
                    [OptionPickerBox show:obj.lblName.text client:strongSelf event:obj.tag];
                } errorHandler:^(id json) {
                    [AlertBox show:json];
                }];
            }
        }else{
            [OptionPickerBox initData:self.categoryList itemId:[obj getStrVal]];
            [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        }
    }else if (obj.tag == YEAR) {
        [SymbolNumberInputBox initData:[obj getStrVal]];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:4 digitLimit:0];
    }else if (obj.tag == SEASON) {
        //季节
        if (self.seasonList!=nil&&self.seasonList.count>0) {
            [OptionPickerBox initData:self.seasonList itemId:[obj getStrVal]];
            [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        }else{
            __strong typeof(self) strongSelf = self;
            NSString* url = @"attribute/baseVal/list";
            NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
            [param setValue:@"2" forKey:@"baseAttributeType"];
            [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
                NSArray *list = [json objectForKey:@"attributeValList"];
                AttributeValVo *vo = [[AttributeValVo alloc] init];
                vo.attributeValId = @"";
                vo.attributeVal = @"全部";
                [strongSelf.seasonList addObject:vo];
                if ([ObjectUtil isNotEmpty:list]) {
                    for (NSDictionary* dic in list) {
                        [strongSelf.seasonList addObject:[AttributeValVo convertToAttributeValVo:dic]];
                    }
                }
                [OptionPickerBox initData:strongSelf.seasonList itemId:[obj getStrVal]];
                [OptionPickerBox show:obj.lblName.text client:strongSelf event:obj.tag];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }
    }else if (obj.tag == PRINCIPAL_TYPE) {
        if (self.principalTypeList!=nil&&self.principalTypeList.count>0) {
            [OptionPickerBox initData:self.principalTypeList itemId:[obj getStrVal]];
            [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        }else{
            __strong typeof(self) strongSelf = self;
            NSString* url = @"attribute/baseVal/list";
            NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
            [param setValue:@"5" forKey:@"baseAttributeType"];
            [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
                NSArray *list = [json objectForKey:@"attributeValList"];
                AttributeValVo *vo = [[AttributeValVo alloc] init];
                vo.attributeValId = @"";
                vo.attributeVal = @"全部";
                [strongSelf.principalTypeList addObject:vo];
                if ([ObjectUtil isNotEmpty:list]) {
                    for (NSDictionary* dic in list) {
                        [strongSelf.principalTypeList addObject:[AttributeValVo convertToAttributeValVo:dic]];
                    }
                }
                [OptionPickerBox initData:strongSelf.principalTypeList itemId:[obj getStrVal]];
                [OptionPickerBox show:obj.lblName.text client:strongSelf event:obj.tag];
            } errorHandler:^(id json) {
                 [AlertBox show:json];
            }];
        }
    }else if (obj.tag == ACCESSORY_TYPE) {
        if (self.accessoryTypeList!=nil&&self.accessoryTypeList.count>0) {
            [OptionPickerBox initData:self.accessoryTypeList itemId:[obj getStrVal]];
            [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        }else{
            __strong typeof(self) strongSelf = self;
            NSString* url = @"attribute/baseVal/list";
            NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
            [param setValue:@"6" forKey:@"baseAttributeType"];
            [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
                NSArray *list = [json objectForKey:@"attributeValList"];
                AttributeValVo *vo = [[AttributeValVo alloc] init];
                vo.attributeValId = @"";
                vo.attributeVal = @"全部";
                [strongSelf.accessoryTypeList addObject:vo];
                if ([ObjectUtil isNotEmpty:list]) {
                    for (NSDictionary* dic in list) {
                        [strongSelf.accessoryTypeList addObject:[AttributeValVo convertToAttributeValVo:dic]];
                    }
                }
                [OptionPickerBox initData:strongSelf.accessoryTypeList itemId:[obj getStrVal]];
                [OptionPickerBox show:obj.lblName.text client:strongSelf event:obj.tag];
            } errorHandler:^(id json) {
                 [AlertBox show:json];
            }];
        }
    }else if (obj.tag == SEX) {
        [OptionPickerBox initData:[SRender listSex] itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }
}


- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem>item = (id<INameItem>)selectObj;
    if (eventType==CATEGORY) {
        [self.lsCategory initData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if (eventType==SEASON) {
        [self.lsSeason initData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if (eventType==PRINCIPAL_TYPE) {
        [self.lsPrincipalType initData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if (eventType==ACCESSORY_TYPE) {
        [self.lsAccessoryType initData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if (eventType==SEX) {
        [self.lsSex initData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    return YES;
}

//暂时保留
- (void)managerOption:(NSInteger)eventType
{
    if (eventType==CATEGORY) {
        //商品分类管理
    }else if (eventType==SEASON) {
        //季节库管理
    }
}

- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event
{
    NSString* dateStr = [DateUtils formateDate4:date];
    [self.lsYear initData:dateStr withVal:dateStr];
    return YES;
}

- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    if (val.length>4) {
        [AlertBox show:@"输入的年度不能超过4位数!"];
        return;
    }
    if ([NSString isBlank:val]) {
        [self.lsYear initData:@"请选择" withVal:nil];
    }else{
        [self.lsYear initData:val withVal:val];
    }
}


#pragma mark - 库存查询按钮
- (void)btnClick:(id)sender
{
    if ([NSString isBlank:[self.lsShopStore getStrVal]]&&(self.shopMode==3)) {
        [AlertBox show:@"请选择门店/仓库！"];
        return;
    }
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:6];
    self.categoryId = [self.lsCategory getStrVal];
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue]==CLOTHESHOES_MODE) {
        if ([NSString isNotBlank:[self.lsSex getStrVal]]) {
            [param setValue:[self.lsSex getStrVal] forKey:@"applySex"];
        }
        [param setValue:[self.lsPrincipalType getStrVal] forKey:@"prototypeId"];
        [param setValue:[self.lsAccessoryType getStrVal] forKey:@"auxiliaryId"];
        self.year = [self.lsYear getStrVal];
        self.season = [self.lsSeason getStrVal];
    }
    
    if (self.shopMode==3) {
        self.shopStoreId = [self.lsShopStore getStrVal];
        [param setValue:self.shopStoreId forKey:@"shopId"];
    }
    if (self.shopMode==2) {
        if ([[[Platform Instance] getkey:STORE_CHECK_FLAG] integerValue]==1) {
            self.shopId = [self.lsShop getStrVal];
            [param setValue:self.shopId forKey:@"shopId"];
        }else{
            [param setValue:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
        }
    }
    if (self.shopMode==1) {
        [param setValue:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
    }
    [param setValue:self.categoryId forKey:@"categoryId"];
    if ([NSString isBlank:self.scanCode]) {
        if ([[[Platform Instance] getkey:SHOP_MODE] integerValue]==CLOTHESHOES_MODE) {
            //服鞋
            [param setValue:self.searchBar2.keyWordTxt.text forKey:@"keywords"];
        }else{
            //商超
            [param setValue:self.searchBar.keyWordTxt.text forKey:@"keywords"];
        }
    }
    [param setValue:self.scanCode forKey:@"scanCode"];
    if ([NSString isNotBlank:self.year]) {
        [param setValue:self.year forKey:@"year"];
    }
    [param setValue:self.season forKey:@"seasonId"];
    
    LSStockQueryListController *vc = [[LSStockQueryListController alloc] init];
    __strong typeof(self) strongSelf = self;
    [vc loadDataWithCondition:param callBack:^(NSString *keyWord) {
        strongSelf.keyWord = keyWord;
        strongSelf.searchBar.keyWordTxt.text = keyWord;
        strongSelf.searchBar2.keyWordTxt.text = keyWord;
    }];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}


@end
