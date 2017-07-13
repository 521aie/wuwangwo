//
//  LSStockBalanceViewController.m
//  retailapp
//
//  Created by guozhi on 2017/1/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define TAG_LST_TIME 1
#define TAG_LST_CATEGORY 3
#define TAG_LST_SelectKeyword 2
#import "LSStockBalanceViewController.h"
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
#import "LSStockBalanceListController.h"
#import "LSStockBalanceVo.h"
#import "LSStockBalanceDetailController.h"
#import "DatePickerView.h"


@interface LSStockBalanceViewController ()<LSFooterViewDelegate, IEditItemListEvent, OptionPickerClient, LSScanViewDelegate, DatePickerViewEvent>
/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollView;
/** <#注释#> */
@property (nonatomic, strong) UIView *container;
/** <#注释#> */
@property (nonatomic, strong) LSFooterView *footerView;
/** 门店/仓库 */
@property (nonatomic, strong) LSEditItemList *lstShop;
/** 时间 */
@property (nonatomic, strong) LSEditItemList *lstTime;
/** 商品分类 */
@property (nonatomic, strong) LSEditItemList *lstCategory;
/** 查询条件 */
@property (nonatomic, strong) LSEditItemText *txtQueryCondition;
/** 商品分类列表 */
@property (nonatomic, strong) NSMutableArray *categoryList;
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, copy) NSString *currYear;    //当前年.
@property (nonatomic, copy) NSString *currMonth;   //当年月份.
@property (nonatomic, strong) DatePickerView *datePickerView;
/**  */
@property (nonatomic, copy) NSString *shopEntityId;
@property (strong, nonatomic) LSEditItemList         *lstSelectKeyWord;  //关键字类型选择,服鞋版显示
/** 区分门店仓库 */
@property (nonatomic, assign) short shopType;
/** 1 店内吗  2 条形码 3 款号  4 拼音码 */
@property (nonatomic, assign) int searchType;
@end

@implementation LSStockBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configConstraints];
    [self configContainerViews];
    [self loadCategoryList];
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.datePickerView = [[DatePickerView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width,self.view.bounds.size.height) title:@"选择时间" client:self];
    self.datePickerView.minYear = 2017;
    //标题
    [self configTitle:@"库存结存报表" leftPath:Head_ICON_BACK rightPath:nil];
    //scollVIew
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    //container
    self.container = [[UIView alloc] init];
    self.container.ls_width = SCREEN_W;
    [self.scrollView addSubview:self.container];
    
    self.footerView = [LSFooterView footerView];
    [self.footerView initDelegate:self btnsArray:@[kFootScan]];
    [self.view addSubview:self.footerView];
}

- (void)configConstraints {
    //标题
    UIView *superView = self.view;
    __weak typeof(self) wself = self;
    //scrollView
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(superView);
        make.top.equalTo(wself.view.top).offset(kNavH);
    }];
    [self.footerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(superView);
        make.height.equalTo(60);
    }];
    
}

- (void)configContainerViews {
    //门店/仓库
    self.lstShop = [LSEditItemList editItemList];
    [self.lstShop initLabel:@"门店/仓库" withHit:nil delegate:self];
    [self.lstShop initData:@"请选择" withVal:nil];
    self.lstShop.imgMore.image = [UIImage imageNamed:@"ico_next.png"];
    if ([[Platform Instance] getShopMode] != 3) {
        [self.lstShop visibal:NO];
    }
    [self.container addSubview:self.lstShop];
    
    NSDate *date = [NSDate date];
    NSString *dateStr = [DateUtils formateDate5:date];
    self.currYear = [dateStr componentsSeparatedByString:@"-"][0];
    self.currMonth = [dateStr componentsSeparatedByString:@"-"][1];
    //开始时间默认开始时间、结束时间都显示昨天的日期
    self.lstTime = [LSEditItemList editItemList];
    [self.lstTime initLabel:@"时间" withHit:nil delegate:self];
    [self.lstTime initData:dateStr withVal:dateStr];
    self.lstTime.tag = TAG_LST_TIME;
    [self.container addSubview:self.lstTime];
    
    //商品分类
    self.lstCategory = [LSEditItemList editItemList];
    NSString *categoryName = [[[Platform Instance] getkey:SHOP_MODE] intValue] == 101 ? @"中品类" : @"商品分类";
    [self.lstCategory initLabel:categoryName withHit:nil delegate:self];
    [self.lstCategory initData:@"全部" withVal:@""];
    self.lstCategory.tag = TAG_LST_CATEGORY;
    [self.container addSubview:self.lstCategory];
    
    //查询条件
    self.lstSelectKeyWord = [LSEditItemList editItemList];
    [self.lstSelectKeyWord initLabel:@"查询条件" withHit:nil delegate:self];
    self.lstSelectKeyWord.tag = TAG_LST_SelectKeyword;
    [self.container addSubview:self.lstSelectKeyWord];
    //查询条件
    self.txtQueryCondition = [LSEditItemText editItemText];
    [self.txtQueryCondition initLabel:@"查询条件" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
        [self.lstSelectKeyWord initData:@"店内码" withVal:@"1"];
        self.searchType = 1;
        [self.txtQueryCondition initLabel:@"▪︎ 店内码" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
        [self.txtQueryCondition.lblName sizeToFit];
        self.txtQueryCondition.txtVal.placeholder = @"输入店内码";
    } else {
        [self.lstSelectKeyWord visibal:NO];
        [self.txtQueryCondition initPlaceholder:@"条形码/简码/拼音码"];
    }
    [self.txtQueryCondition showStatus:NO];
    [self.container addSubview:self.txtQueryCondition];
    
    UIButton *btn = [LSViewFactor addGreenButton:self.container title:@"查询" y:0];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *text = @"提示：可以根据上面的条件查询相应的库存结存报表。";
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
    if (obj == self.lstShop) {//选择门店仓库
        SelectShopStoreListView *vc = [[SelectShopStoreListView alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        __weak typeof(self) wself = self;
        [vc loadData:[obj getStrVal] checkMode:SINGLE_CHECK isPush:YES callBack:^(id<INameCode> item) {
            [self.navigationController popViewControllerAnimated:NO];
            if (item) {
                [wself.lstShop initData:[item obtainItemName] withVal:[item obtainItemId]];
                wself.shopEntityId = [item obtainItemEntityId];
                wself.shopType = [item obtainItemType];
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }];
    } else if (obj == self.lstTime) {
        //时间
        NSString *dateStr = [obj getStrVal];
        self.currYear = [dateStr componentsSeparatedByString:@"-"][0];
        self.currMonth = [dateStr componentsSeparatedByString:@"-"][1];
        [self.datePickerView initDate:self.currYear.integerValue  month:self.currMonth.integerValue];
        } else if (obj == self.lstCategory) {//分类
        [OptionPickerBox initData:self.categoryList itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    } else if (obj == self.lstSelectKeyWord) {
        NSArray *list = @[[[NameItemVO alloc] initWithVal:@"店内码" andId:@"1"],
                          [[NameItemVO alloc] initWithVal:@"条形码" andId:@"2"],
                          [[NameItemVO alloc] initWithVal:@"款号" andId:@"3"],
                          [[NameItemVO alloc] initWithVal:@"拼音码" andId:@"4"]];
        [OptionPickerBox initData:list itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
            
    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == TAG_LST_CATEGORY) {//分类
        [self.lstCategory initData:[item obtainItemName] withVal:[item obtainItemId]];
    } else if (eventType == TAG_LST_SelectKeyword) {
        [self.lstSelectKeyWord initData:[item obtainItemName] withVal:[item obtainItemId]];
        NSString *strTemp = [NSString stringWithFormat:@"▪︎ %@",[item obtainItemName]];
        [self.txtQueryCondition changeLabel:strTemp withVal:nil];
        [self.txtQueryCondition.lblName sizeToFit];
        self.txtQueryCondition.txtVal.placeholder = [NSString stringWithFormat:@"输入%@",[item obtainItemName]];
        self.searchType = [[item obtainItemId] intValue];
    }
    return YES;
}

- (void)pickerOption:(DatePickerView *)obj eventType:(NSInteger)evenType {
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%02ld", obj.year, obj.month];
    [self.lstTime initData:dateStr withVal:dateStr];
    
}

- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootScan]) {
        [self showScanEvent];
    }
}

- (void)showScanEvent {
    if ([self isVaild]) {
        ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    }
}
- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    self.txtQueryCondition.txtVal.text = scanString;
    [self btnClick:nil];
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [LSAlertHelper showAlert:message];
}

- (void)btnClick:(UIButton *)btn {
    if ([self isVaild]) {
        LSStockBalanceListController *vc = [[LSStockBalanceListController alloc] init];
        vc.param = self.param;
        NSString *time = [NSString stringWithFormat:@"%@", [self.lstTime getDataLabel]];
        vc.time = time;
        vc.keyWord = self.txtQueryCondition.txtVal.text;
        vc.searchType = self.searchType;
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }
    
}

- (BOOL)isVaild {
    if (self.lstShop.hidden == NO && [NSString isBlank:[self.lstShop getStrVal]]) {
        [LSAlertHelper showAlert:@"请先选择门店/仓库！"];
        return NO;
    }
    NSDate *date = [NSDate date];
    NSString *currentTime = [DateUtils formateDate5:date];
    NSString *selectTime = [self.lstTime getDataLabel];
    NSString *year = [currentTime componentsSeparatedByString:@"-"][0];
    NSString *month = [currentTime componentsSeparatedByString:@"-"][1];
    NSString *oneYearAgoTime = [NSString stringWithFormat:@"%ld-%@", year.integerValue - 1, month];
    NSString *beginTime = @"2017-04";
    if ([selectTime compare:currentTime] == NSOrderedDescending) {
        [LSAlertHelper showAlert:@"时间只能选择历史月份！"];
        return NO;
    }
    if ([selectTime compare:oneYearAgoTime] != NSOrderedDescending) {
        [LSAlertHelper showAlert:@"只能选择最近一年内的月份！"];
        return NO;
    }
    
    if ([selectTime compare:beginTime] == NSOrderedAscending) {
        [LSAlertHelper showAlert:@"历史数据最早可查询17年4月的记录!"];
        return NO;
    }

    
    return YES;
}

- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [NSMutableDictionary dictionary];
    }
    [_param removeAllObjects];
    [_param setValue:[self.lstCategory getStrVal] forKey:@"categoryId"];
    if ([[Platform Instance] getShopMode] == 3) {
         [_param setValue:[self.lstShop getStrVal] forKey:@"shopId"];
        [_param setValue:self.shopEntityId forKey:@"shopEntityId"];
        //1是门店2是仓库
        [_param setValue:@(self.shopType) forKey:@"type"];
        
    } else {
        [_param setValue:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
        [_param setValue:[[Platform Instance] getkey:RELEVANCE_ENTITY_ID] forKey:@"shopEntityId"];
        //1是门店2是仓库
        [_param setValue:@1 forKey:@"type"];
    }
    NSString *startTime = [self.lstTime.lblVal.text stringByAppendingString:@"-01"];
    [_param setValue:[NSNumber numberWithLongLong:[DateUtils converStartTime:startTime]/1000] forKey:@"startTime"];
    NSString *endTime = [self.lstTime.lblVal.text stringByAppendingString:[NSString stringWithFormat:@"-%02ld", [DateUtils getNumberOfDaysInMonth:[DateUtils parseDateTime7:self.lstTime.lblVal.text]]]];
    [_param setValue:[NSNumber numberWithLongLong:[DateUtils converEndTime:endTime]/1000] forKey:@"endTime"];
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
        self.searchType = [[self.lstSelectKeyWord getStrVal] intValue];
        [_param setValue:@(self.searchType) forKey:@"searchType"];
    }
    NSString *keyWord = self.txtQueryCondition.txtVal.text;
    [_param setValue:keyWord forKey:@"keyWord"];
    return _param;
}



@end
