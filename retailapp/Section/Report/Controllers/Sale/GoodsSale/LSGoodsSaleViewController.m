//
//  LSGoodsSaleViewController.m
//  retailapp
//
//  Created by guozhi on 2017/1/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#define TAG_LST_SaleShop 1
#define TAG_LST_SaleTime 2
#define TAG_LST_StartTime 3
#define TAG_LST_EndTime 4
#define TAG_LST_SALE_MODLE 5
#define TAG_LST_SALE_PARTNER 6
#define TAG_LST_CATEGORY 7

#define ENTITY_SALE @"实体销售"
#define WECHAT_SALE @"微店销售"
#define ENTITY_SALE_ID @"1"
#define WECHAT_SALE_ID @"2"
#import "LSGoodsSaleViewController.h"
#import "LSReportSaleStatisticController.h"
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
#import "DateMonthPickerBox.h"
#import "LSGoodsSaleListController.h"
#import "SelectShopListView.h"
#import "NameItemVO.h"
#import "CategoryVo.h"


@interface LSGoodsSaleViewController () <IEditItemListEvent,OptionPickerClient,DatePickerClient,DateMonthPickerClient>
@property (strong, nonatomic) UIView       *container;         //滚动栏中子view容器
/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollView;
@property (strong, nonatomic) LSEditItemList *LstSaleShop;       //店家选择
@property (strong, nonatomic) LSEditItemList *LstSaleTime;       //销售时间选择
@property (strong, nonatomic) LSEditItemList *LstStartTime;      //自定义开始时间
@property (strong, nonatomic) LSEditItemList *LstEndTime;        //自定义接受时间
@property (strong, nonatomic) LSEditItemList *lstSaleMode;
@property (strong, nonatomic) LSEditItemList *lstCategory;   // 统计方式
/** 是否是门店 */
@property (nonatomic, assign) BOOL isShop;
/** <#注释#> */
@property (nonatomic, copy) NSString *shopEntityId;

@property (nonatomic ,strong) NSArray<NameItemVO *> *saleTypeItems;/*<销售方式>*/
@property (nonatomic ,strong) NSArray<NameItemVO *> *stasticTypeItems;/*<统计方式>*/

@end

@implementation LSGoodsSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configContainerViews];
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //标题
    [self configTitle:@"商品销售报表" leftPath:Head_ICON_BACK rightPath:nil];
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
    [self.LstSaleShop initData:@"请选择" withVal:nil];
    self.LstSaleShop.imgMore.image = [UIImage imageNamed:@"ico_next.png"];
    [self.container addSubview:self.LstSaleShop];
    
    self.lstSaleMode = [LSEditItemList editItemList];
    [self.lstSaleMode initLabel:@"来源" withHit:nil delegate:self];
    [self.lstSaleMode initData:@"全部" withVal:@""]; // 默认
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
    
    self.lstCategory = [LSEditItemList editItemList];
    [self.lstCategory initLabel:@"统计方式" withHit:nil delegate:self];
    [self.lstCategory initData:@"按商品统计" withVal:@"3"]; // 默认
    [self.container addSubview:self.lstCategory];
    
    UIButton *btn = [LSViewFactor addGreenButton:self.container title:@"查询" y:0];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *text = @"提示：可以根据上面的条件查询相应的商品销售报表。";
    [LSViewFactor addExplainText:self.container text:text y:0];
    
    self.LstSaleShop.tag = TAG_LST_SaleShop;
    self.LstSaleTime.tag = TAG_LST_SaleTime;
    self.LstStartTime.tag = TAG_LST_StartTime;
    self.LstEndTime.tag = TAG_LST_EndTime;
    self.lstSaleMode.tag = TAG_LST_SALE_MODLE;
    self.lstCategory.tag = TAG_LST_CATEGORY;
    self.shopEntityId = [[Platform Instance] getkey:RELEVANCE_ENTITY_ID];
    
    //销售时间
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSString* dateStr=[DateUtils formateDate2:yesterday];
    [self.LstSaleTime initData:@"昨天" withVal:@"0"];
    
    //开始时间 结束时间
    [self.LstStartTime initData:dateStr withVal:dateStr];
    [self.LstStartTime visibal:NO];
    [self.LstEndTime initData:dateStr withVal:dateStr];
    [self.LstEndTime visibal:NO];
    [self settingShopShow];
    [UIHelper refreshUI:self.container];
}


#pragma mark - 设置门店及销售方式显示
- (void)settingShopShow {
    //销售门店
    //只有连锁模式机构用户登录时显示
    if ([[Platform Instance] getShopMode] == 3) {
        [self.LstSaleShop visibal:YES];
    }else{
        [self.LstSaleShop visibal:NO];
    }
}

- (void)showType {
    //连锁机构用户登录时显示；
    if ([[Platform Instance] getShopMode] == 3) {
        [self.lstSaleMode visibal:YES];
    }else{
        if ([[Platform Instance] getMicroShopStatus] == 2) {//单店和门店开通微店显示
            [self.lstSaleMode visibal:YES];
        }else{
            [self.lstSaleMode visibal:NO];
        }
    }
}


#pragma mark - IEditItemListEvent协议
- (void)onItemListClick:(LSEditItemList *)obj {
    if (obj == self.lstSaleMode) {
        NSArray *saleMode = @[@"全部",@"实体门店",@"微店"];
        [OptionPickerBox initData:[MenuList list1FromArray:saleMode] itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }
    else if (obj == self.LstSaleTime) {
        NSArray *listItems = @[@"昨天", @"本周", @"上周", @"本月", @"上月", @"自定义"];
        [OptionPickerBox initData:[MenuList list1FromArray:listItems] itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }
    else if(obj == self.LstSaleShop) {
        SelectOrgShopListView *vc = [[SelectOrgShopListView alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        __strong typeof(self) wself  = self;
        [vc loadData:[obj getStrVal] withModuleType:3 withCheckMode:SINGLE_CHECK callBack:^(NSMutableArray *selectArr, id<ITreeItem> item) {
            [self.navigationController popViewControllerAnimated:NO];
            if (item) {
                [wself.LstSaleShop initData:[item obtainItemName] withVal:[item obtainItemId]];
                wself.shopEntityId = [item obtainShopEntityId];
                NSInteger selectShopType = [item obtainItemType];
                if (selectShopType == 2) {
                    //门店
                    wself.isShop = YES;
                }else{
                    //公司、部门
                    wself.isShop = NO;
                }
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }];
    }
    else if (obj == self.LstStartTime || obj == self.LstEndTime) {
        NSDate *date = [NSDate date];
        if ([NSString isNotBlank:obj.lblVal.text]) {
            date = [DateUtils parseDateTime4:obj.lblVal.text];
        }
        [DatePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
    }
    else if (obj == self.lstCategory) {
        [OptionPickerBox initData:self.stasticTypeItems itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }
}
#pragma mark - OptionPickerClient协议
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {    
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == TAG_LST_SaleTime) {
        [self.LstSaleTime initData:[item obtainItemName] withVal:[item obtainItemId]];
        if ([[item obtainItemName] isEqualToString:@"自定义"]) {
            [self.LstStartTime visibal:YES];
            [self.LstEndTime visibal:YES];
        } else {
            [self.LstStartTime visibal:NO];
            [self.LstEndTime visibal:NO];
        }
    } else if (eventType == TAG_LST_SALE_MODLE) {
        //订单来源选择之后的事件
        [self.lstSaleMode initData:[item obtainItemName] withVal:[item obtainItemId]];
        [self settingShopShow];
        
    } else if (eventType == TAG_LST_CATEGORY) {
        [self.lstCategory initData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    [UIHelper refreshUI:self.container];
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
    
    if (![self isValid]) { return ;}
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:10];
    
    // 来源选择全部时，不传
    if (self.lstSaleMode.hidden == NO) {
        if (![[self.lstSaleMode getDataLabel] isEqualToString:@"全部"]) {
            [param setValue:[self.lstSaleMode getStrVal] forKey:@"orderSrc"];
        } else {
            [param setValue:[NSNull null] forKey:@"orderSrc"];
        }
    }

    
    // entityId,
    [param setValue:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
    if ([[Platform Instance] getShopMode] == 3) {
        
        if (self.isShop) {
            // 选择了机构下的门店
            [param setValue:self.shopEntityId forKey:@"shopEntityId"];
            [param setValue:[self.LstSaleShop getStrVal] forKey:@"shopId"];
        } else {
            // 选择了机构
            [param setValue:[self.LstSaleShop getStrVal] forKey:@"organizationId"];
            [param setValue:[self.LstSaleShop getStrVal] forKey:@"shopId"];

        }
        
    } else {
        // 门店、单店
        [param setObject:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
        [param setValue:[[Platform Instance] getkey:RELEVANCE_ENTITY_ID] forKey:@"shopEntityId"];
    }
    
    // 查询时间 段（报表：精确到秒）
    if (![[self.LstSaleTime getDataLabel] isEqualToString:@"自定义"]) {
        long long startTime = [DateUtils converStartTime:self.LstSaleTime.lblVal.text];
        long long endTime = [DateUtils converEndTime:self.LstSaleTime.lblVal.text];
        [param setValue:@(startTime/1000) forKey:@"startTime"];
        [param setValue:@(endTime/1000) forKey:@"endTime"];
    } else {
        long long startTime = [DateUtils formateDateTime2:[NSString stringWithFormat:@"%@ 00:00:00",[self.LstStartTime getStrVal]]];
        long long endTime = [DateUtils formateDateTime2:[NSString stringWithFormat:@"%@ 23:59:59",[self.LstEndTime getStrVal]]];
        [param setValue:@(startTime/1000) forKey:@"startTime"];
        [param setValue:@(endTime/1000) forKey:@"endTime"];
    }
    
    
    // 默认排序方式为1
    [param setValue:@(1) forKey:@"goodsSortType"];
    
    // 统计方式
    [param setValue:@([self.lstCategory getStrVal].integerValue) forKey:@"categoryType"];
    
    if ([[self.lstCategory getDataLabel] isEqualToString:@"按商品统计"]) {
        LSGoodsSaleListController* vc = [[LSGoodsSaleListController alloc] init];
        vc.param = param;
        [self pushController:vc from:kCATransitionFromRight];
    } else {
        LSReportSaleStatisticController *vc = [[LSReportSaleStatisticController alloc] initWithParams:param];
        [self pushController:vc from:kCATransitionFromRight];
    }
}

//检查查询条件
- (BOOL)isValid {
    
    if (self.LstSaleShop.hidden == NO && [[self.LstSaleShop getDataLabel] isEqualToString:@"请选择"]) {
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

#pragma mark - NameItemVO
// 销售方式，类型
- (NSArray<NameItemVO *> *)saleTypeItems {
    if (!_saleTypeItems) {
        _saleTypeItems = @[[[NameItemVO alloc] initWithVal:@"全部" andId:@"0"], // 全部时不传 null
                           [[NameItemVO alloc] initWithVal:@"实体销售" andId:@"1"],
                           [[NameItemVO alloc] initWithVal:@"微店销售" andId:@"2"]
                           ];
    }
    return _saleTypeItems;
}

// 统计方式类型
- (NSArray<NameItemVO *> *)stasticTypeItems {
    if (!_stasticTypeItems) {
        if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {
            // 服鞋
            _stasticTypeItems = @[[[NameItemVO alloc] initWithVal:@"按品牌统计" andId:@"1"],
                                  [[NameItemVO alloc] initWithVal:@"按品类统计" andId:@"2"],
                                  [[NameItemVO alloc] initWithVal:@"按商品统计" andId:@"3"],
                                  ];
        }
        else {
            // 商超
            _stasticTypeItems = @[[[NameItemVO alloc] initWithVal:@"按品牌统计" andId:@"1"],
                                  [[NameItemVO alloc] initWithVal:@"按分类统计" andId:@"2"],
                                  [[NameItemVO alloc] initWithVal:@"按商品统计" andId:@"3"],
                                  ];
        }
    }
    return _stasticTypeItems;
}

@end
