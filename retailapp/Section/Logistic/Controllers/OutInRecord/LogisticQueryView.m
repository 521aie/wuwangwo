//
//  LogisticQueryView.m
//  retailapp
//
//  Created by hm on 15/8/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LogisticQueryView.h"
#import "LogisticModuleEvent.h"
#import "ServiceFactory.h"
#import "LSEditItemList.h"
#import "LSEditItemText.h"
#import "DateUtils.h"
#import "DatePickerBox.h"
#import "OptionPickerBox.h"
#import "XHAnimalUtil.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "LogisticRecordListView.h"
#import "LRender.h"
#import "DicVo.h"
#import "SelectShopStoreListView.h"
#import "SelectSupplierListView.h"
#import "SelectOrgShopListView.h"

@interface LogisticQueryView ()<IEditItemListEvent,DatePickerClient,OptionPickerClient,ISearchBarEvent>

@property (nonatomic, strong) SearchBar2 *searchBar2;
/** <#注释#> */
@property (nonatomic,strong) UIView* container;
/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong) LSEditItemList* lsShop;

@property (nonatomic,strong) LSEditItemList* lsSupplier;

@property (nonatomic,strong) LSEditItemList* lsPaperType;

@property (nonatomic,strong) LSEditItemList* lsDate;
@property (nonatomic,strong) LSEditItemList* lsStartTime;
@property (nonatomic,strong) LSEditItemList* lsEndTime;

@property (nonatomic,strong) LogisticService* logisticService;
/**|1 单店|2 门店|3 机构|*/
@property (nonatomic,assign) short shopMode;
//查询单号
@property (nonatomic, copy) NSString *paperNo;
//单据类型
@property (nonatomic, strong) NSMutableArray *billTypeList;
@end

@implementation LogisticQueryView


- (void)viewDidLoad {
    [super viewDidLoad];
    self.logisticService = [ServiceFactory shareInstance].logisticService;
    [self initNavigate];
    [self configViews];
    [self.searchBar2 initDelagate:self placeholder:@"单号"];
    [self initMainView];
    self.shopMode = [[Platform Instance] getShopMode];
    [self showView];
    [self clearCondition];
    self.billTypeList = [[NSMutableArray alloc] init];
    [self configHelpButton:HELP_OUTIN_RECORD];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)configViews {
    CGFloat y = kNavH;
    self.searchBar2 = [SearchBar2 searchBar2];
    self.searchBar2.ls_top = y;
    [self.view addSubview:self.searchBar2];
    
    y = self.searchBar2.ls_bottom;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, SCREEN_W, SCREEN_H - y)];
    self.scrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    
    self.lsShop = [LSEditItemList editItemList];
    [self.container addSubview:self.lsShop];
    
    self.lsPaperType = [LSEditItemList editItemList];
    [self.container addSubview:self.lsPaperType];
    
    self.lsSupplier = [LSEditItemList editItemList];
    [self.container addSubview:self.lsSupplier];
    
    self.lsDate = [LSEditItemList editItemList];
    [self.container addSubview:self.lsDate];
    
    self.lsStartTime = [LSEditItemList editItemList];
    [self.container addSubview:self.lsStartTime];
    
    self.lsEndTime = [LSEditItemList editItemList];
    [self.container addSubview:self.lsEndTime];
    
    UIButton *btn = [LSViewFactor addGreenButton:self.container title:@"查询" y:0];
    [btn addTarget:self action:@selector(queryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [LSViewFactor addExplainText:self.container text:@"提示：可以根据上面的条件查询相应的出入库记录" y:0];
    
    
    
    
}
#pragma mark - 初始化导航
- (void)initNavigate
{
    [self configTitle:@"出入库记录" leftPath:Head_ICON_BACK rightPath:nil];
}

#pragma mark - 初始化主视图
- (void)initMainView
{
    [self.lsShop initLabel:@"机构/门店" withHit:nil delegate:self];
    [self.lsShop.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    
    [self.lsSupplier initLabel:@"供应商" withHit:nil delegate:self];
    [self.lsSupplier.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    
    [self.lsPaperType initLabel:@"类型" withHit:nil delegate:self];
    
    [self.lsDate initLabel:@"时间" withHit:nil delegate:self];
    
    [self.lsStartTime initLabel:@"▪︎ 开始日期" withHit:nil delegate:self];
    
    [self.lsEndTime initLabel:@"▪︎ 结束日期" withHit:nil delegate:self];
    
    self.lsShop.tag = OUT_SHOP;
    self.lsSupplier.tag = SUPPLIER;
    self.lsPaperType.tag = PAPER_TYPE;
    self.lsDate.tag = DATE;
    self.lsStartTime.tag = START_DATE;
    self.lsEndTime.tag = END_DATE;
}
#pragma mark - 显示页面项
- (void)showView
{
    [self.lsShop visibal:(self.shopMode==3)];
    [self.lsStartTime visibal:NO];
    [self.lsEndTime visibal:NO];
    [UIHelper refreshUI:self.container];
}
#pragma mark - 设置初始条件
- (void)clearCondition
{
    [self.lsShop initData:@"请选择" withVal:@""];
    [self.lsSupplier initData:@"全部" withVal:@"0"];
    [self.lsPaperType initData:@"全部" withVal:@""];
    [self.lsDate initData:@"今天" withVal:@"0"];
}


#pragma mark - IEditItemEvent协议
- (void)onItemListClick:(EditItemList *)obj
{
    if (obj.tag==OUT_SHOP) {
        //选择机构门店
        SelectOrgShopListView *orgShopView = [[SelectOrgShopListView alloc] init];
        __strong typeof(self) strongSelf = self;
        [orgShopView loadData:[obj getStrVal] withModuleType:3 withCheckMode:SINGLE_CHECK callBack:^(NSMutableArray *selectArr, id<ITreeItem> item) {
            if (item) {
                [obj initData:[item obtainItemName] withVal:[item obtainItemId]];
            }
            [XHAnimalUtil animal:strongSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [strongSelf.navigationController popToViewController:strongSelf animated:NO];
        }];
        [self.navigationController pushViewController:orgShopView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        orgShopView = nil;
    }else if (obj.tag==SUPPLIER) {
        //选择供应商
        SelectSupplierListView* supplierListView = [[SelectSupplierListView alloc] init];
        supplierListView.isAll = YES;
        supplierListView.isCondition = YES;
        NSString *supplyFlag = [[Platform Instance] isTopOrg]?@"third":@"self";
        // 单店的，只有外部供应商，显示全部
        if ([[Platform Instance] getShopMode] == 1) {
            supplierListView.isCondition = NO;
            supplyFlag = @"third";
        }
        __strong typeof(self) strongSelf = self;
        [supplierListView loadDataBySupplyId:[obj getStrVal] supplyFlag:supplyFlag handler:^(id<INameValue> supplier) {
            if (supplier) {
                [strongSelf.lsSupplier initData:[supplier obtainItemName] withVal:[supplier obtainItemId]];
            }
            [XHAnimalUtil animal:strongSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [strongSelf.navigationController popToViewController:strongSelf animated:NO];
        }];
        [self.navigationController pushViewController:supplierListView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        supplierListView = nil;
    }else if (obj.tag==PAPER_TYPE) {
        //选中单据类型
        if (self.billTypeList!=nil&&self.billTypeList.count>0) {
            [OptionPickerBox initData:self.billTypeList itemId:[obj getStrVal]];
            [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        }else{
            __strong typeof(self) wself = self;
            NSString *dicCode = self.shopMode!=1?@"DIC_CHAIN_LOGISTICS_TYPE":@"DIC_SINGLE_LOGISTICS_TYPE";
            [self.logisticService selectBillTypeByCode:dicCode completionHandler:^(id json) {
                DicVo *dicVo = [[DicVo alloc] init];
                dicVo.name = @"全部";
                dicVo.val = 0;
                wself.billTypeList = [DicVo converToArr:[json objectForKey:@"configList"]];
                [wself.billTypeList insertObject:dicVo atIndex:0];
                [OptionPickerBox initData:wself.billTypeList itemId:[obj getStrVal]];
                [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }
    }else if (obj.tag==DATE) {
        //选择日期
        [OptionPickerBox initData:[LRender listDate] itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }else if (obj.tag==START_DATE) {
        //选择自定义开始日期
        [DatePickerBox show:obj.lblName.text date:[DateUtils parseDateTime4:[obj getStrVal]] client:self event:obj.tag];
    }else if (obj.tag==END_DATE) {
        //选择自定义结束日期
        [DatePickerBox show:obj.lblName.text date:[DateUtils parseDateTime4:[obj getStrVal]] client:self event:obj.tag];
    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> obj = (id<INameItem>)selectObj;
    if (eventType==PAPER_TYPE) {
        BOOL visible = ([[obj obtainItemId] integerValue]!=4);
        [self.lsSupplier visibal:visible];
        [UIHelper refreshUI:self.container];
        [self.lsPaperType initData:[obj obtainItemName] withVal:[obj obtainItemId]];
    }else if (eventType==DATE) {
        [self.lsDate initData:[obj obtainItemName] withVal:[obj obtainItemId]];
        //自定义
        [self.lsStartTime visibal:[[obj obtainItemId] isEqualToString:@"5"]];
        [self.lsEndTime visibal:[[obj obtainItemId] isEqualToString:@"5"]];
        NSString* dateStr = [DateUtils formateDate2:[NSDate date]];
        [self.lsStartTime initData:dateStr withVal:dateStr];
        [self.lsEndTime initData:dateStr withVal:dateStr];
        [UIHelper refreshUI:self.container];
    }
    return YES;
}

- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event
{
    NSString* dateStr=[DateUtils formateDate2:date];
    if (event==START_DATE) {
        [self.lsStartTime initData:dateStr withVal:dateStr];
    }else if (event==END_DATE) {
        [self.lsEndTime initData:dateStr withVal:dateStr];
    }
    return YES;
    
}

#pragma mark - 输入框
- (void)imputFinish:(NSString *)keyWord
{
    self.paperNo = keyWord;
}

#pragma mark - 验证是否选中门店|仓库
- (BOOL)isValide
{
    if ([NSString isBlank:[self.lsShop getStrVal]]&&self.shopMode==3) {
        [AlertBox show:@"请选择机构/门店!"];
        return NO;
    }
    return YES;
}

#pragma mark - 查询
- (IBAction)queryBtnClick:(id)sender
{
    if (![self isValide]) {
        return;
    }
    
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:7];
    if (self.shopMode==3) {
        [param setValue:[self.lsShop getStrVal] forKey:@"shopId"];
    }else{
        [param setValue:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
    }
    [param setValue:self.searchBar2.keyWordTxt.text forKey:@"logisticsNo"];
    if (![@"0" isEqualToString:[self.lsPaperType getStrVal]]) {
        [param setValue:[self.lsPaperType getStrVal] forKey:@"billType"];
    }
    if (![[self.lsSupplier getStrVal] isEqualToString:@"0"]) {
        [param setValue:[self.lsSupplier getStrVal] forKey:@"supplyId"];
    }
    if ([[self.lsDate getStrVal] isEqualToString:@"0"]) {
       //今天
        NSString* startTime = [NSString stringWithFormat:@"%@ 00:00:00",[DateUtils formateDate2:[NSDate date]]];
        long long time = [DateUtils formateDateTime2:startTime];
        [param setValue:[NSNumber numberWithLongLong:time] forKey:@"starttime"];
        [param setValue:[NSNumber numberWithLongLong:(time+(24*60*60-1)*1000)] forKey:@"endtime"];
    }else if ([[self.lsDate getStrVal] isEqualToString:@"1"]) {
       //昨天
        NSString* startTime = [NSString stringWithFormat:@"%@ 00:00:00",[DateUtils formateDate2:[NSDate date]]];
        long long time = [DateUtils formateDateTime2:startTime];
        [param setValue:[NSNumber numberWithLongLong:(time-24*60*60*1000)] forKey:@"starttime"];
        [param setValue:[NSNumber numberWithLongLong:(time-1*1000)] forKey:@"endtime"];
    }else if ([[self.lsDate getStrVal] isEqualToString:@"2"]) {
       //最近三天
        NSString* startTime = [NSString stringWithFormat:@"%@ 00:00:00",[DateUtils formateDate2:[NSDate date]]];
        long long time = [DateUtils formateDateTime2:startTime];
        [param setValue:[NSNumber numberWithLongLong:(time-2*24*60*60*1000)] forKey:@"starttime"];
        [param setValue:[NSNumber numberWithLongLong:(time+(24*60*60-1)*1000)] forKey:@"endtime"];
    }else if ([[self.lsDate getStrVal] isEqualToString:@"3"]) {
       //本周
       NSArray* thisWeek = [DateUtils getFirstAndLastDayOfThisWeek];
        NSString* timeStr = [NSString stringWithFormat:@"%@ 00:00:00",[DateUtils formateDate2:[thisWeek objectAtIndex:0]]];
        long long time = [DateUtils formateDateTime2:timeStr];
        [param setValue:[NSNumber numberWithUnsignedLongLong:time] forKey:@"starttime"];
        timeStr = [NSString stringWithFormat:@"%@ 23:59:59",[DateUtils formateDate2:[thisWeek objectAtIndex:1]]];
        time = [DateUtils formateDateTime2:timeStr];
        [param setValue:[NSNumber numberWithUnsignedLongLong:time] forKey:@"endtime"];
    }else if ([[self.lsDate getStrVal] isEqualToString:@"4"]) {
       //本月
        NSArray* thisMonth = [DateUtils getFirstAndLastDayOfThisMonth];
        NSString* timeStr = [NSString stringWithFormat:@"%@ 00:00:00",[DateUtils formateDate2:[thisMonth objectAtIndex:0]]];
        long long time = [DateUtils formateDateTime2:timeStr];
        [param setValue:[NSNumber numberWithUnsignedLongLong:time] forKey:@"starttime"];
        timeStr = [NSString stringWithFormat:@"%@ 23:59:59",[DateUtils formateDate2:[thisMonth objectAtIndex:1]]];
        time = [DateUtils formateDateTime2:timeStr];
        [param setValue:[NSNumber numberWithUnsignedLongLong:time] forKey:@"endtime"];
    }else if ([[self.lsDate getStrVal] isEqualToString:@"5"]) {
       //自定义
        long long startTime = [DateUtils formateDateTime2:[NSString stringWithFormat:@"%@ 00:00:00",[self.lsStartTime getStrVal]]];
        long long endTime = [DateUtils formateDateTime2:[NSString stringWithFormat:@"%@ 23:59:59",[self.lsEndTime getStrVal]]];
        if (startTime>endTime) {
            [AlertBox show:@"开始日期不能大于结束日期!"];
            return;
        }
        if ([DateUtils getMonthFromStartDate:[self.lsStartTime getStrVal] toEndDate:[self.lsEndTime getStrVal]]) {
            [AlertBox show:@"开始日期至结束日期的区间不能超过一年!"];
            return;
        }
        [param setValue:[NSNumber numberWithLongLong:startTime] forKey:@"starttime"];
        [param setValue:[NSNumber numberWithLongLong:endTime] forKey:@"endtime"];
    }
    
    LogisticRecordListView* recordListView = [[LogisticRecordListView alloc] init];
    recordListView.param = param;
    [self.navigationController pushViewController:recordListView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    recordListView = nil;
}

@end
