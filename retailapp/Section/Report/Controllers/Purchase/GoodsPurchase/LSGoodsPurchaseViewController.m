//
//  LSGoodsPurchaseViewController.m
//  retailapp
//
//  Created by guozhi on 2017/1/13.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define kTagLstTime 3
#define kTagLstStartDate 1
#define kTagLstEndDate 2
#define kTagLstCategory 4

#import "LSGoodsPurchaseViewController.h"
#import "LSFooterView.h"
#import "ScanViewController.h"
#import "LSEditItemList.h"
#import "LSEditItemText.h"
#import "OptionPickerBox.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "SelectShopStoreListView.h"
#import "DateUtils.h"
#import "DatePickerBox.h"
#import "NameItemVO.h"
#import "CategoryVo.h"
#import "SelectSupplierListView.h"
#import "LSGoodsPurchaseListController.h"
#import "AllShopVo.h"

@interface LSGoodsPurchaseViewController ()< LSFooterViewDelegate, IEditItemListEvent, OptionPickerClient, DatePickerClient,LSScanViewDelegate>
/** 标题 */
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) LSFooterView *footerView;
/** 门店/仓库 */
@property (nonatomic, strong) LSEditItemList *lstShop;
/** 时间 */
@property (nonatomic, strong) LSEditItemList *lstTime;
/** 开始时间 */
@property (nonatomic, strong) LSEditItemList *lstStartDate;
/** 结束时间 */
@property (nonatomic, strong) LSEditItemList *lstEndDate;
/** 供应商 */
@property (nonatomic, strong) LSEditItemList *lstSuppiler;
/** 商品分类 */
@property (nonatomic, strong) LSEditItemList *lstCategory;
/** 查询条件 */
@property (nonatomic, strong) LSEditItemText *txtQueryCondition;
/** 商品分类列表 */
@property (nonatomic, strong) NSMutableArray *categoryList;
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *param;
/** list导出所需参数： */
//1：门店；2：仓库
@property (nonatomic, copy) NSString *shopIdExport;
@property (nonatomic, copy) NSString *entityIdExport;
@property (nonatomic,assign) short shopTypeExport;
@end

@implementation LSGoodsPurchaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configContainerViews];
    [self loadCategoryList];
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    
    //标题
    [self configTitle:@"商品采购报表" leftPath:Head_ICON_BACK rightPath:nil];
    
    //scollVIew
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    
    //container
    self.container = [[UIView alloc] init];
    self.container.ls_width = SCREEN_W;
    [self.scrollView addSubview:self.container];
    
    self.footerView = [LSFooterView footerView];
    [self.footerView initDelegate:self btnsArray:@[kFootScan]];
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {//服鞋
        self.footerView.hidden = YES;
    }
    [self.view addSubview:self.footerView];
    self.footerView.ls_bottom = SCREEN_H;
}


- (void)configContainerViews {
    //门店/仓库 连锁模式下的机构用户登录时显示(包括总部)
    //限连锁模式下的机构用户登录时显示；
    //必选项，默认显示“请选择”，点击跳转至“选择门店/仓库”页面，限单选
    self.lstShop = [LSEditItemList editItemList];
    [self.lstShop initLabel:@"门店/仓库" withHit:nil delegate:self];
    [self.lstShop initData:@"请选择" withVal:nil];
    self.lstShop.imgMore.image = [UIImage imageNamed:@"ico_next.png"];
    if ([[Platform Instance] getShopMode] != 3) {
        [self.lstShop visibal:NO];
    }
    [self.container addSubview:self.lstShop];
    
    //选项修改：今天、昨天、本周、上周、本月、上月、自定义
    self.lstTime = [LSEditItemList editItemList];
    self.lstTime.tag = kTagLstTime;
    [self.lstTime initLabel:@"时间" withHit:nil delegate:self];
    [self.lstTime initData:@"昨天" withVal:@"0"];
    [self.container addSubview:self.lstTime];
    
    //开始日期
    self.lstStartDate = [LSEditItemList editItemList];
    self.lstStartDate.tag = kTagLstStartDate;
    [self.container addSubview:self.lstStartDate];
//    NSDate* date=[NSDate date];
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSString* dateStr=[DateUtils formateDate2:yesterday];
    [self.lstStartDate initLabel:@"▪︎ 开始日期" withHit:nil delegate:self];
    [self.lstStartDate initData:dateStr withVal:dateStr];
    [self.lstStartDate visibal:NO];
    
    //结束日期
    self.lstEndDate = [LSEditItemList editItemList];
    self.lstEndDate.tag = kTagLstEndDate;
    [self.container addSubview:self.lstEndDate];
    [self.lstEndDate initLabel:@"▪︎ 结束日期" withHit:nil delegate:self];
    [self.lstEndDate initData:dateStr withVal:dateStr];
    [self.lstEndDate visibal:NO];
    
    //供应商默认选择“全部”，点击跳转至供应商选择页面；
    //选择供应商前，若未选择门店/仓库，提示“请先选择门店/仓库！”
    //温馨提示：供应商选择页面显示所选择的门店/仓库下的供应商
    self.lstSuppiler = [LSEditItemList editItemList];
    [self.lstSuppiler initLabel:@"供应商" withHit:nil delegate:self];
    [self.lstSuppiler initData:@"全部" withVal:nil];
    self.lstSuppiler.imgMore.image = [UIImage imageNamed:@"ico_next"];
    [self.container addSubview:self.lstSuppiler];
    
    //商品分类
    self.lstCategory = [LSEditItemList editItemList];
    self.lstCategory.tag = kTagLstCategory;
    NSString *categoryName = [[[Platform Instance] getkey:SHOP_MODE] intValue] == 101 ? @"中品类" : @"商品分类";
    [self.lstCategory initLabel:categoryName withHit:nil delegate:self];
    [self.lstCategory initData:@"全部" withVal:@""];
    [self.container addSubview:self.lstCategory];
    
    //查询条件
    self.txtQueryCondition = [LSEditItemText editItemText];
    [self.txtQueryCondition initLabel:@"查询条件" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
        [self.txtQueryCondition initPlaceholder:@"名称/款号"];
    } else {
        [self.txtQueryCondition initPlaceholder:@"条形码/简码/拼音码"];
    }
    [self.txtQueryCondition showStatus:NO];
    [self.container addSubview:self.txtQueryCondition];
    
    UIButton *btn = [LSViewFactor addGreenButton:self.container title:@"查询" y:0];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *text = @"提示：可以根据上面的条件查询相应的商品的采购明细。";
    [LSViewFactor addExplainText:self.container text:text y:0];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma mark 加载分类数据
- (void)loadCategoryList {
    NSString *url = [[[Platform Instance] getkey:SHOP_MODE] intValue] == 101 ? @"category/firstCategoryInfo" : @"category/lastCategoryInfo";
    
    NSDictionary *param = [[[Platform Instance] getkey:SHOP_MODE] intValue] == 101 ? nil : @{@"hasNoCategory" : @"1"};
    
    __weak typeof(self) wself = self;
    
    wself.categoryList = [NSMutableArray array];
    NameItemVO *itemVo = [[NameItemVO alloc] initWithVal:@"全部" andId:@""];
    [self.categoryList addObject:itemVo];
    
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        if ([ObjectUtil isNotNull:json[@"categoryList"]]) {
            NSArray *list = [CategoryVo mj_objectArrayWithKeyValuesArray:json[@"categoryList"]];
            [list enumerateObjectsUsingBlock:^(CategoryVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.categoryId isEqualToString:@"noCategory"]) {
                    obj.categoryId = @"0";
                }
                NameItemVO *itemVo = [[NameItemVO alloc] initWithVal:obj.name andId:obj.categoryId];
                [wself.categoryList addObject:itemVo];
            }];
        }
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}

- (void)onItemListClick:(LSEditItemList *)obj {
    if (obj == self.lstShop) {
        //选择门店仓库
        SelectShopStoreListView *vc = [[SelectShopStoreListView alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        
        __weak typeof(self) wself = self;
        
        [vc loadData:[obj getStrVal] checkMode:SINGLE_CHECK isPush:YES callBack:^(id<INameCode> item) {
            [self.navigationController popViewControllerAnimated:NO];
            if (item) {
                [wself.lstShop initData:[item obtainItemName] withVal:[item obtainItemId]];
            }
            AllShopVo *obj = [[AllShopVo alloc] init];
            obj = item ;
            self.shopIdExport = obj.shopId;
            self.entityIdExport = obj.shopEntityId;
            self.shopTypeExport = obj.shopType;
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }];
    } else if (obj == self.lstTime) {
        //时间
        NSMutableArray *list = [NSMutableArray array];
        NameItemVO *item = [[NameItemVO alloc] initWithVal:@"昨天" andId:@"0"];
        [list addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"本周" andId:@"1"];
        [list addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"上周" andId:@"2"];
        [list addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"本月" andId:@"3"];
        [list addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"上月" andId:@"4"];
        [list addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"自定义" andId:@"5"];
        [list addObject:item];
        [OptionPickerBox initData:list itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    } else if (obj == self.lstStartDate || obj == self.lstEndDate) {
        //开始时间和结束时间
        NSDate *date = [NSDate date];
        if ([NSString isNotBlank:obj.lblVal.text]) {
            date = [DateUtils parseDateTime4:obj.lblVal.text];
        }
        [DatePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
    }else if (obj == self.lstSuppiler) {//供应商
        if (self.lstShop.hidden == NO && [NSString isBlank:[self.lstShop getStrVal]]) {
            [LSAlertHelper showAlert:@"请先选择门店/仓库！"];
            return;
        }
        //选择供应商
        SelectSupplierListView *selectSupplyListView = [[SelectSupplierListView alloc] init];
        selectSupplyListView.isAll = YES;
        NSString *shopId = nil;
        if ([[Platform Instance] getShopMode] == 3) {
            shopId = [self.lstShop getStrVal];
        } else {
            [_param setValue:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
            shopId = [[Platform Instance] getkey:SHOP_ID];
        }
        selectSupplyListView.shopId = shopId;
        NSString *supplyFlg = @"all";
        __weak typeof(self) weakSelf = self;
        [selectSupplyListView loadDataBySupplyId:[obj getStrVal] supplyFlag:supplyFlg handler:^(id<INameValue> supplier) {
            if (supplier) {
                [weakSelf.lstSuppiler initData:[supplier obtainItemName] withVal:[supplier obtainItemId]];
            }
            if ([[supplier obtainItemName]  isEqual: @"全部"]) {
                [weakSelf.lstSuppiler initData:[supplier obtainItemName]  withVal:nil];
            }
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf.navigationController popViewControllerAnimated:NO];
        }];
        [self.navigationController pushViewController:selectSupplyListView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    } else if (obj == self.lstCategory) {
        //分类
        [OptionPickerBox initData:self.categoryList itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == kTagLstCategory) {
        //分类
        [self.lstCategory initData:[item obtainItemName] withVal:[item obtainItemId]];
    } else if (eventType == kTagLstTime){
        //自定义时间
        [self.lstTime initData:[item obtainItemName] withVal:[item obtainItemId]];
        if ([[item obtainItemName] isEqualToString:@"自定义"]) {
            [self.lstStartDate visibal:YES];
            [self.lstEndDate visibal:YES];
        } else {
            [self.lstStartDate visibal:NO];
            [self.lstEndDate visibal:NO];
        }
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event {
    NSString *dateStr = [DateUtils formateDate2:date];
    if (event == kTagLstStartDate) {
        [self.lstStartDate initData:dateStr withVal:dateStr];
    } else if (event == kTagLstEndDate) {
        [self.lstEndDate initData:dateStr withVal:dateStr];
    }
    return YES;
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootScan]) {
        if ([self ivVaild]) {
            [self scanStart];
        }
     }
}

#pragma mark - 扫码代理
- (void)scanStart {
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

// LSScanViewDelegate
- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    self.txtQueryCondition.txtVal.text = scanString;
    [self.param setValue:scanString forKey:@"keyWord"];
    [self btnClick:nil];
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [LSAlertHelper showAlert:message];
}

- (void)btnClick:(UIButton *)btn {
    if ([self ivVaild]) {
        LSGoodsPurchaseListController *vc = [[LSGoodsPurchaseListController alloc] init];
        vc.param = self.param;
        vc.shopIdExport = self.shopIdExport;
        vc.entityIdExport = self.entityIdExport;
        vc.shopTypeExport = self.shopTypeExport;
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }
}


- (BOOL)ivVaild {
    if (self.lstShop.hidden == NO && [NSString isBlank:[self.lstShop getStrVal]]) {
        [LSAlertHelper showAlert:@"请先选择门店/仓库！"];
        return NO;
    }
    if (self.lstStartDate.hidden == NO) {
        NSDate *startDate = [DateUtils parseDateTime4:[self.lstStartDate getStrVal]];
        NSDate *endDate = [DateUtils parseDateTime4:[self.lstEndDate getStrVal]];
        NSDate *tempStart = [NSDate dateWithTimeInterval:24*60*60 sinceDate:startDate];
        NSDate *tempEnd = [NSDate dateWithTimeInterval:24*60*60 sinceDate:endDate];
        if (![DateUtils daysToNowOneYear:tempStart]) {
            return NO;
        }
        if ([startDate compare:tempEnd] == NSOrderedDescending) {
            [LSAlertHelper showAlert:@"开始日期不能大于结束日期!"];
            return NO;
        }
    }
    return YES;
}

- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [NSMutableDictionary dictionary];
    }
    [_param removeAllObjects];
    
    //商品分类
    [_param setValue:[self.lstCategory getStrVal] forKey:@"categoryId"];
    
    //门店/仓库id; 1：门店；2：仓库
    if ([[Platform Instance] getShopMode] == 3) {
        [_param setValue:[self.lstShop getStrVal] forKey:@"shopId"];
    } else {
        [_param setValue:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
    }
    
    //供应商ID
    if ( [NSString isNotBlank:[self.lstSuppiler getStrVal]] ) {
        [_param setValue:[self.lstSuppiler getStrVal] forKey:@"supplierId"];
    }
    
    //查询时间:开始时间 结束时间精确到毫秒
    if ([self.lstTime.lblVal.text isEqualToString:@"自定义"]) {
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converStartTime:self.lstStartDate.lblVal.text]/1000] forKey:@"startTime"];
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converEndTime:self.lstEndDate.lblVal.text]/1000] forKey:@"endTime"];
    } else {
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converStartTime:self.lstTime.lblVal.text]/1000] forKey:@"startTime"];
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converEndTime:self.lstTime.lblVal.text]/1000] forKey:@"endTime"];
    }
    
    //查询条件：条形码/简码/拼音码
    NSString *keyWord = self.txtQueryCondition.txtVal.text;
    if ([NSString isNotBlank:keyWord]) {
        [_param setValue:keyWord forKey:@"keyWord"];
    }
    return _param;
}

@end
