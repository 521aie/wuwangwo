//
//  LSShopCollectionController.m
//  retailapp
//
//  Created by guozhi on 2016/11/22.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
#define kTagLstSaleType 1
#define kTagLstShop 2
#define kTagLstTime 3
#define kTagLstStartDate 4
#define kTagLstEndDate 5

#import "LSShopCollectionController.h"
#import "LSEditItemList.h"
#import "DateUtils.h"
#import "UIHelper.h"
#import "NameItemVO.h"
#import "OptionPickerBox.h"
#import "SelectShopListView.h"
#import "DatePickerBox.h"
#import "AlertBox.h"
#import "LSShopCollectionListController.h"

@interface LSShopCollectionController ()< IEditItemListEvent, OptionPickerClient, DatePickerClient>
/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollView;
/** <#注释#> */
@property (nonatomic, strong) UIView *container;
/** 销售来源 */
@property (nonatomic, strong) LSEditItemList *lstSaleType;
/** 门店 */
@property (nonatomic, strong) LSEditItemList *lstShop;
/** 时间 */
@property (nonatomic, strong) LSEditItemList *lstTime;
/** 开始日期 */
@property (nonatomic, strong) LSEditItemList *lstStartDate;
/** 结束日期 */
@property (nonatomic, strong) LSEditItemList *lstEndDate;
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *param;
/** <#注释#> */
@property (nonatomic, copy) NSString *shopEntityId;
@end

@implementation LSShopCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //标题
    [self configTitle:@"收款统计报表" leftPath:Head_ICON_BACK rightPath:nil];
    //
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 100)];
    [self.scrollView addSubview:self.container];
    
    /*“门店”选择栏
     选择“实体门店”时，连锁模式下总部户显示(全部和微店不显示)；
     连锁模式下机构用户门店显示
     必填，默认为“请选择”*/
    self.lstShop = [LSEditItemList editItemList];
    self.lstShop.tag = kTagLstShop;
    self.lstShop.imgMore.image = [UIImage imageNamed:@"ico_next"];
    [self.lstShop initLabel:@"门店" withHit:nil delegate:self];
    [self.lstShop initData:@"请选择" withVal:@""];
    [self.container addSubview:self.lstShop];
    //连锁总部只有选择实体门店时才显示门店机构用户都显示
    self.shopEntityId = [[Platform Instance] getkey:RELEVANCE_ENTITY_ID];
    [self showShop];
    
    //销售方式
    self.lstSaleType = [LSEditItemList editItemList];
    self.lstSaleType.tag = kTagLstSaleType;
    [self.lstSaleType initLabel:@"来源" withHit:nil delegate:self];
    //连锁机构用户登录，可按门店查询实体、微店收款统计
    [self.lstSaleType initData:@"全部" withVal:@""];
    [self.container addSubview:self.lstSaleType];
    [self showType];

    /*
     选项修改：昨天、本周、上周、本月、上月、自定义
     时间选择“自定义”时，开始日期不能大于结束日期，并且只能选择最近一年的日期，否则报错误消息“开始日期只能选择最近一年的日期！”
     */
    self.lstTime = [LSEditItemList editItemList];
    self.lstTime.tag = kTagLstTime;
    [self.lstTime initLabel:@"时间" withHit:nil delegate:self];
    [self.lstTime initData:@"今天" withVal:@"0"];
    [self.container addSubview:self.lstTime];
    //开始日期
    self.lstStartDate = [LSEditItemList editItemList];
    self.lstStartDate.tag = kTagLstStartDate;
    [self.container addSubview:self.lstStartDate];
    NSDate* date=[NSDate date];
    NSString* dateStr=[DateUtils formateDate2:date];
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
    
    //按钮背景
    UIButton *btn = [LSViewFactor addGreenButton:self.container title:@"查询" y:0];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    NSString *text = @"提示：可以根据上面的条件查询相应的收款统计报表。";
    [LSViewFactor addExplainText:self.container text:text y:0];
}


#pragma mark - 判断门店是否显示 只有连锁模式机构用户登录时显示
- (void)showShop {
    //将“门店”移至“来源”上方，连锁机构用户登录时固定显示；
     if ([[Platform Instance] getShopMode] == 3) {
         [self.lstShop visibal:YES];
     }else{
         [self.lstShop visibal:NO];
     }
}

- (void)showType {
    //连锁机构用户登录时显示；
    if ([[Platform Instance] getShopMode] == 3) {
        [self.lstSaleType visibal:YES];
    }else{
        if ([[Platform Instance] getMicroShopStatus] == 2) {//开通微店显示
            [self.lstSaleType visibal:YES];
        }else{
            [self.lstSaleType visibal:NO];
        }
    }
}


- (void)onItemListClick:(LSEditItemList *)obj {
    if (obj == self.lstSaleType) {//销售方式
        NSMutableArray *list = [NSMutableArray array];
        NameItemVO *item = [[NameItemVO alloc] initWithVal:@"全部" andId:@""];
        [list addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"实体门店" andId:@"1"];
        [list addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"微店" andId:@"2"];
        [list addObject:item];
        [OptionPickerBox initData:list itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    } else if (obj == self.lstShop) {//门店;总部用户登录时最上方显示“全部”，一般机构用户登录隐藏“全部”，只能选择具体门店
        SelectShopListView *vc = [[SelectShopListView alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        __weak typeof(self) wself = self;
        if ([[Platform Instance] isTopOrg]) {
            [vc loadShopList:[obj getStrVal] withType:0 withViewType:CONTAIN_ALL withIsPush:YES callBack:^(id<ITreeItem> shop) {
                [wself.navigationController popViewControllerAnimated:NO];
                if (shop) {
                    if ([[shop obtainItemId] isEqualToString:@"0"]) {
                        [wself.lstShop initData:[shop obtainItemName] withVal:@"0"];
                    } else {
                        [wself.lstShop initData:[shop obtainItemName] withVal:[shop obtainItemId]];
                        wself.shopEntityId = [shop obtainShopEntityId];
                    }
                }
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            }];
        }else{
            [vc loadShopList:[obj getStrVal] withType:0 withViewType:NOT_CONTAIN_ALL withIsPush:YES callBack:^(id<ITreeItem> shop) {
                [wself.navigationController popViewControllerAnimated:NO];
                if (shop) {
                    if ([[shop obtainItemId] isEqualToString:@"0"]) {
                        [wself.lstShop initData:[shop obtainItemName] withVal:@"0"];
                    } else {
                        [wself.lstShop initData:[shop obtainItemName] withVal:[shop obtainItemId]];
                        wself.shopEntityId = [shop obtainShopEntityId];
                    }
                }
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            }];
        }
    } else if (obj == self.lstTime) {//选择时间
        NSMutableArray *list = [NSMutableArray array];
        NameItemVO *item = [[NameItemVO alloc] initWithVal:@"今天" andId:@"0"];
        [list addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"昨天" andId:@"1"];
        [list addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"本周" andId:@"2"];
        [list addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"上周" andId:@"3"];
        [list addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"本月" andId:@"4"];
        [list addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"上月" andId:@"5"];
        [list addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"自定义" andId:@"6"];
        [list addObject:item];
        [OptionPickerBox initData:list itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    } else if (obj == self.lstStartDate || obj == self.lstEndDate) {//交易时间
        NSDate *date = [NSDate date];
        if ([NSString isNotBlank:obj.lblVal.text]) {
            date = [DateUtils parseDateTime4:obj.lblVal.text];
        }
        [DatePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == kTagLstSaleType) {
        [self.lstSaleType initData:[item obtainItemName] withVal:[item obtainItemId]];
        [self showShop];
    } else if (eventType == kTagLstTime){//时间
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

#pragma - 点击查询按钮
- (void)btnClick:(UIButton *)btn {
    if ([self isValid]) {
        LSShopCollectionListController *vc = [[LSShopCollectionListController alloc] init];
        vc.param = self.param;
        if ([[self.lstSaleType getDataLabel] isEqualToString:@"实体门店"]) {
            vc.show = YES;
        } else {
            vc.show = NO;
        }
        if ([[self.lstTime getDataLabel] isEqualToString:@"今天"]) {//只有今天查询的才有手动生成
            vc.isToday = YES;
        } else {
            vc.isToday = NO;
        }
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }
}

- (BOOL)isValid {
    NSDate *startDate = [DateUtils parseDateTime4:[self.lstStartDate getStrVal]];
    NSDate *endDate = [DateUtils parseDateTime4:[self.lstEndDate getStrVal]];
    if (self.lstStartDate.hidden == NO) {
        if (![DateUtils daysToNowOneYear:startDate]) {
            return NO;
        }
        if ([startDate compare:endDate] == NSOrderedDescending) {
            [AlertBox show:@"开始日期不能大于结束日期!"];
            return NO;
        }
    }
    
    if (self.lstShop.hidden == NO && [NSString isBlank:[self.lstShop getStrVal]]) {
        [AlertBox show:@"请选择门店!"];
        return NO;
    }
    return YES;
}

- (NSMutableDictionary *)param {
    
    if (_param == nil) {
        _param = [NSMutableDictionary dictionary];
    }
    [_param removeAllObjects];
    
    //shopId
    NSString *shopId = nil;
    if (self.lstShop.hidden == NO) {
        // lstShop 选择"全部"时，不传“shopEntityId”;  单店，门店必须要传“shopEntityId”
        if ([[self.lstShop getDataLabel] isEqualToString:@"全部"]) {
            shopId =  [[Platform Instance] getkey:SHOP_ID];
        } else {
            shopId = [self.lstShop getStrVal];
             [_param setObject:self.shopEntityId forKey:@"shopEntityId"];
        }
    } else {
        shopId = [[Platform Instance] getkey:SHOP_ID];
        [_param setObject:self.shopEntityId forKey:@"shopEntityId"];
    }
    [_param setValue:shopId forKey:@"shopId"];
    //开始时间 结束时间精确到毫秒
    if ([self.lstTime.lblVal.text isEqualToString:@"自定义"]) {
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converStartTime:self.lstStartDate.lblVal.text]/1000] forKey:@"startTime"];
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converEndTime:self.lstEndDate.lblVal.text]/1000] forKey:@"endTime"];
    } else {
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converStartTime:self.lstTime.lblVal.text]/1000] forKey:@"startTime"];
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converEndTime:self.lstTime.lblVal.text]/1000] forKey:@"endTime"];
    }
    //商户ID
    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    [_param setValue:entityId forKey:@"entityId"];
    //销售方式1.实体 2.微店
    NSString *shopType = [self.lstSaleType getStrVal];
    if ([[self.lstSaleType getDataLabel] isEqualToString:@"全部"]) {
        [_param removeObjectForKey:@"orderSrc"];
    } else {
         [_param setValue:shopType forKey:@"orderSrc"];
    }
    return _param;
}

@end
