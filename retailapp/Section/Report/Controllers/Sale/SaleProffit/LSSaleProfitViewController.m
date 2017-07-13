//
//  LSSaleProfitViewController.m
//  retailapp
//
//  Created by guozhi on 2017/1/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define TAG_LST_SaleShop 1
#define TAG_LST_SaleTime 2
#define TAG_LST_StartTime 3
#define TAG_LST_EndTime 4
#define TAG_LST_SALE_MODE 5
#import "LSSaleProfitViewController.h"
#import "OptionPickerClient.h"
#import "INameItem.h"
#import "DatePickerBox.h"
#import "XHAnimalUtil.h"
#import "LSEditItemList.h"
#import "LSEditItemText.h"
#import "UIHelper.h"
#import "OptionPickerBox.h"
#import "MenuList.h"
#import "DateUtils.h"
#import "NSString+Estimate.h"
#import "SelectOrgShopListView.h"
#import "AlertBox.h"
#import "ServiceFactory.h"
#import "NameItemVO.h"

#import "DateMonthPickerBox.h"
#import "LSSaleProfitDetailController.h"


@interface LSSaleProfitViewController ()<IEditItemListEvent,OptionPickerClient,DatePickerClient,DateMonthPickerClient>
@property (assign, nonatomic) NSInteger             shoptype;           /**1门店用户登录查询 2机构用户登录查询*/
@property (strong, nonatomic) UIScrollView *scrollView;        //滚动栏
@property (strong, nonatomic) UIView       *container;         //滚动栏中子view容器
@property (strong, nonatomic) LSEditItemList *LstSaleShop;       //店家选择
@property (strong, nonatomic) LSEditItemList *LstSaleTime;       //销售时间选择
@property (strong, nonatomic) LSEditItemList *LstStartTime;      //自定义开始时间
@property (strong, nonatomic) LSEditItemList *LstEndTime;        //自定义接受时间
@property (strong, nonatomic) UILabel      *lblTip;            //提示
@property (strong, nonatomic) NSMutableDictionary   *param;             //详情页面的参数
@property (nonatomic,assign) NSInteger selectShopType;
@property (nonatomic,assign) BOOL isTopOrg;
/** <#注释#> */
@property (nonatomic, copy) NSString *shopEntityId;
/** 是选择了机构门店 */
@property (nonatomic, assign) BOOL isShop;

@end

@implementation LSSaleProfitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configContainerViews];
}

- (void)configViews {
    self.isTopOrg = [[Platform Instance] isTopOrg];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //标题
    [self configTitle:@"销售收益报表" leftPath:Head_ICON_BACK rightPath:nil];
    //scollVIew
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    //container
    self.container = [[UIView alloc] init];
    self.container.ls_width = SCREEN_W;
    [self.scrollView addSubview:self.container];
}

- (void)configContainerViews {

    self.LstSaleShop = [LSEditItemList editItemList];
    [self.LstSaleShop initLabel:@"机构/门店" withHit:nil delegate:self];
    self.LstSaleShop.imgMore.image = [UIImage imageNamed:@"ico_next.png"];
    [self.container addSubview:self.LstSaleShop];
    
    self.lstSaleMode = [LSEditItemList editItemList];
    [self.lstSaleMode initLabel:@"来源" withHit:nil delegate:self];
    [self.container addSubview:self.lstSaleMode];
    [self showType];
    
    self.LstSaleTime = [LSEditItemList editItemList];
    [self.LstSaleTime initLabel:@"时间" withHit:nil delegate:self];
    [self.container addSubview:self.LstSaleTime];
    
    self.LstStartTime = [LSEditItemList editItemList];
    [self.LstStartTime initLabel:@"▪︎ 开始日期" withHit:nil delegate:self];
    [self.container addSubview:self.LstStartTime];
    
    self.LstEndTime = [LSEditItemList editItemList];
    [self.LstEndTime initLabel:@"▪︎ 结束日期" withHit:nil delegate:self];
    [self.container addSubview:self.LstEndTime];
    
    UIButton *btn = [LSViewFactor addGreenButton:self.container title:@"查询" y:0];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *text = @"提示：可以根据上面的条件查询相应的销售收益报表。";
    [LSViewFactor addExplainText:self.container text:text y:0];
    
    self.lstSaleMode.tag = TAG_LST_SALE_MODE;
    self.LstSaleShop.tag = TAG_LST_SaleShop;
    self.LstSaleTime.tag = TAG_LST_SaleTime;
    self.LstStartTime.tag = TAG_LST_StartTime;
    self.LstEndTime.tag = TAG_LST_EndTime;
    
    [self.LstSaleShop initData:@"请选择" withVal:nil];
    [self.lstSaleMode initData:@"全部" withVal:@""];

    self.shopEntityId = [[Platform Instance] getkey:RELEVANCE_ENTITY_ID];
    [self showShop];
    
    //销售时间
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSString* dateStr=[DateUtils formateDate2:yesterday];
    [self.LstSaleTime initData:@"昨天" withVal:@"0"];
    
    self.lblTip.text = @"提示：可以根据上面的条件查询相应的销售收益报表。";

    //开始时间 结束时间
    [self.LstStartTime initData:dateStr withVal:dateStr];
    [self.LstStartTime visibal:NO];
    [self.LstEndTime initData:dateStr withVal:dateStr];
    [self.LstEndTime visibal:NO];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)showType {
    //连锁机构用户登录时显示；
    if ([[Platform Instance] getShopMode] == 3) {
        [self.lstSaleMode visibal:YES];
    } else {
        if ([[Platform Instance] getMicroShopStatus] == 2) {//单店/门店开通微店显示
            [self.lstSaleMode visibal:YES];
        } else {
            [self.lstSaleMode visibal:NO];
        }
    }
}

#pragma mark - IEditItemListEvent协议
- (void)onItemListClick:(LSEditItemList *)obj {
    if (obj == self.lstSaleMode) {
        NSMutableArray *modes = [NSMutableArray array];
        NameItemVO *itemVo = [[NameItemVO alloc] initWithVal:@"全部" andId:nil];
        [modes addObject:itemVo];
        itemVo = [[NameItemVO alloc] initWithVal:@"实体门店" andId:@"1"];
        [modes addObject:itemVo];
        itemVo = [[NameItemVO alloc] initWithVal:@"微店" andId:@"2"];
        [modes addObject:itemVo];
        [OptionPickerBox initData:modes itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }
    
    if (obj == self.LstSaleTime) {
        NSArray *listItems;
        if (obj == self.LstSaleTime) {
            listItems = @[@"昨天", @"本周", @"上周", @"本月",@"上月", @"自定义"];
        }
        [OptionPickerBox initData:[MenuList list1FromArray:listItems] itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }
    
    else if(obj == self.LstSaleShop)
    {
        SelectOrgShopListView *vc = [[SelectOrgShopListView alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        __weak typeof(self) wself = self;
        [vc loadData:[obj getStrVal] withModuleType:3 withCheckMode:SINGLE_CHECK callBack:^(NSMutableArray *selectArr, id<ITreeItem> item) {
            [self.navigationController popViewControllerAnimated:NO];
            if (item) {
                [wself.LstSaleShop initData:[item obtainItemName] withVal:[item obtainItemId]];
                wself.shopEntityId = [item obtainShopEntityId];
                NSInteger selectShopType = [item obtainItemType];
                if (selectShopType == 2) {
                    //门店
                    wself.selectShopType = 1;
                    wself.isShop = YES;
                }else{
                    //公司、部门
                    wself.selectShopType = 2;
                    wself.isShop = NO;
                }
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }];
        
    }else if (obj == self.LstStartTime || obj == self.LstEndTime) {
        NSDate *date = [NSDate date];
        if ([NSString isNotBlank:obj.lblVal.text]) {
            date = [DateUtils parseDateTime4:obj.lblVal.text];
        }
        [DatePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
    }
}

#pragma mark - 判断门店是否显示 单店不显示 连锁门店不显示  连锁机构显示  连锁总部只有选择实体门店显示选择其他不显示
- (void)showShop {
    //只有连锁模式机构用户登录时显示
    if ([[Platform Instance] getShopMode] == 3) {
        [self.LstSaleShop visibal:YES];
    } else {
        [self.LstSaleShop visibal:NO];
    }
}

#pragma mark - OptionPickerClient协议
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == TAG_LST_SALE_MODE) {
        [self.lstSaleMode initData:[item obtainItemName] withVal:[item obtainItemId]];
        //连锁机构用户登录时固定显示；
        [self showShop];
    }
    if (eventType == TAG_LST_SaleTime) {
        [self.LstSaleTime initData:[item obtainItemName] withVal:[item obtainItemId]];
        if ([[item obtainItemName] isEqualToString:@"自定义"]) {
            [self.LstStartTime visibal:YES];
            [self.LstEndTime visibal:YES];
        } else {
            [self.LstStartTime visibal:NO];
            [self.LstEndTime visibal:NO];
        }
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

#pragma mark - DatePickerClient协议
- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event{
    NSString *dateStr = [DateUtils formateDate2:date];
    if (event == TAG_LST_StartTime) {
        [self.LstStartTime initData:dateStr withVal:dateStr];
    } else {
        [self.LstEndTime initData:dateStr withVal:dateStr];
    }
    return YES;
}

#pragma mark - DateMonthPickerClient协议
- (BOOL)pickMonthDate:(NSDate *)date event:(NSInteger)event {
    NSString *dateStr = [DateUtils formateDate5:date];
    [self.LstSaleTime initData:dateStr withVal:dateStr];
    return YES;
}

#pragma mark - click
- (void)btnClick:(id)sender {
    if ([self isValid]){
        LSSaleProfitDetailController *vc = [[LSSaleProfitDetailController alloc] init];
        vc.param = self.param;
        vc.shopName = _LstSaleShop.lblVal.text;
        vc.selectShopType = _selectShopType;
        NSMutableString *text = [NSMutableString string];
        if ([self.LstSaleTime.lblVal.text isEqualToString:@"自定义"]) {
            [text appendString:self.LstStartTime.lblVal.text];
            [text appendString:@"∼"];
            [text appendString:self.LstEndTime.lblVal.text];
        }else{
            [text appendString:self.LstSaleTime.lblVal.text];
        }
        vc.saleTime = text;
        vc.saleMode = [self.lstSaleMode getDataLabel];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }
}

#pragma mark - param GET
- (NSMutableDictionary *)param {
    
    _param = [[NSMutableDictionary alloc] init];
    if ([self.LstSaleTime.lblVal.text isEqualToString:@"自定义"]) {
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converStartTime:self.LstStartTime.lblVal.text]/1000] forKey:@"startTime"];
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converEndTime:self.LstEndTime.lblVal.text]/1000] forKey:@"endTime"];
    } else {
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converStartTime:self.LstSaleTime.lblVal.text]/1000] forKey:@"startTime"];
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converEndTime:self.LstSaleTime.lblVal.text]/1000] forKey:@"endTime"];
    }
    
    // 来源
    [_param removeObjectForKey:@"orderSrc"];
    if (self.lstSaleMode.hidden == NO) {
        if (![[self.lstSaleMode getDataLabel] isEqualToString:@"全部"]) {
            [_param setValue:[self.lstSaleMode getStrVal] forKey:@"orderSrc"];
        } else {
            [_param setObject:[NSNull null] forKey:@"orderSrc"];
        }
    }

    if ([[Platform Instance] getShopMode] == 3) {

        if (self.isShop) {
            // 选择了机构下的门店
            [_param setValue:self.shopEntityId forKey:@"shopEntityId"];
            [_param setValue:[self.LstSaleShop getStrVal] forKey:@"shopId"];
        } else {
            [_param setValue:[self.LstSaleShop getStrVal] forKey:@"organizationId"];
        }

    } else {
        // 门店、单店
        [_param setObject:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
        [_param setValue:[[Platform Instance] getkey:RELEVANCE_ENTITY_ID] forKey:@"shopEntityId"];
    }

    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    [_param setObject:entityId forKey:@"entityId"];

    return _param;
}

//检查查询条件
- (BOOL)isValid {
    
    if (self.LstSaleShop.hidden == NO && [NSString isBlank:[self.LstSaleShop getStrVal]]) {
        [AlertBox show:@"请选择门店！"];
        return NO;
    }
    
    if (self.LstStartTime.hidden == NO) {
        NSDate *startDate = [DateUtils parseDateTime4:[self.LstStartTime getStrVal]];
        NSDate *endDate = [DateUtils parseDateTime4:[self.LstEndTime getStrVal]];
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

//计算开始时间方法
- (long long)getStartTime{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [DateUtils parseDateTime4:_LstSaleTime.currentVal];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:date];    
    
    NSDate *day = [calendar dateFromComponents:dateComponents];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval =[zone secondsFromGMTForDate:day];
    NSDate *localeDate = [day dateByAddingTimeInterval: interval];
    
    long long beginTime = 0;
    if (nil != day) {
        beginTime = [DateUtils getStartTimeOfDate:localeDate];
    }
    return beginTime;
}

//计算结束时间方法
- (long long)getEndTime{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [DateUtils parseDateTime4:_LstSaleTime.currentVal];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:date];
    NSDate *day = [calendar dateFromComponents:dateComponents];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval =[zone secondsFromGMTForDate:day];
    NSDate *localeDate = [day dateByAddingTimeInterval: interval];
    long long endTime = 0;
    if (nil != day) {
        endTime = [DateUtils getEndTimeOfDate:localeDate];
    }
    return endTime;    
}

@end
