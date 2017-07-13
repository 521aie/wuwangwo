//
//  LSGoodsTransactionFlowController.m
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
#define KTagLstStartTime 7
#define KTagLstEndTime 8
#define KTagLstOrderType 9
#import "LSGoodsTransactionFlowController.h"
#import "OptionPickerClient.h"
#import "INameItem.h"
#import "DatePickerBox.h"
#import "TimePickerBox.h"
#import "XHAnimalUtil.h"
#import "LSEditItemList.h"
#import "LSEditItemText.h"
#import "UIHelper.h"
#import "OptionPickerBox.h"
#import "MenuList.h"
#import "DateUtils.h"
#import "NSString+Estimate.h"
#import "SelectShopListView.h"
#import "AlertBox.h"
#import "ServiceFactory.h"
#import "LSGoodsTransactionFlowListController.h"
#import "NameItemVO.h"
#import "LSFooterView.h"
#import "ScanViewController.h"

@interface LSGoodsTransactionFlowController ()< IEditItemListEvent, OptionPickerClient, DatePickerClient,TimePickerClient,LSFooterViewDelegate,LSScanViewDelegate>
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
/** 开始时间 */
@property (nonatomic, strong) LSEditItemList *lstStartTime;
/** 结束日期 */
@property (nonatomic, strong) LSEditItemList *lstEndDate;
/** 结束时间*/
@property (nonatomic, strong) LSEditItemList *lstEndTime;
/** 订单类型*/
@property (nonatomic, strong) LSEditItemList *lstOrderType;
/** 查询条件*/
@property (nonatomic, strong) LSEditItemText *lstOrderSeek;

/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *param;
/** <#注释#> */
@property (nonatomic, copy) NSString *shopEntityId;
@end
//
@implementation LSGoodsTransactionFlowController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.shopEntityId = [[Platform Instance] getkey:RELEVANCE_ENTITY_ID];
    //标题
    [self configTitle:@"商品交易流水报表" leftPath:Head_ICON_BACK rightPath:nil];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    
    
    //门店
    self.lstShop = [LSEditItemList editItemList];
    self.lstShop.tag = kTagLstShop;
    self.lstShop.imgMore.image = [UIImage imageNamed:@"ico_next"];
    [self.lstShop initLabel:@"门店" withHit:nil delegate:self];
    [self.lstShop initData:@"请选择" withVal:nil];
    [self.container addSubview:self.lstShop];
    [self showShop];
    
    //方式
    self.lstSaleType = [LSEditItemList editItemList];
    self.lstSaleType.tag = kTagLstSaleType;
    [self.lstSaleType initLabel:@"来源" withHit:nil delegate:self];
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

    //开始时间
    self.lstStartTime = [LSEditItemList editItemList];
    self.lstStartTime.tag = KTagLstStartTime;
    [self.container addSubview:self.lstStartTime];
    NSString *startTim = [DateUtils formateChineseTime:[DateUtils parseDateTime3:@"2017-01-01 00:00:00"]];
    [self.lstStartTime initLabel:@"▪︎ 开始时间" withHit:nil delegate:self];
    [self.lstStartTime initData:startTim withVal:startTim];
    [self.lstStartTime visibal:NO];
    
    //结束日期
    self.lstEndDate = [LSEditItemList editItemList];
    self.lstEndDate.tag = kTagLstEndDate;
    [self.container addSubview:self.lstEndDate];
    [self.lstEndDate initLabel:@"▪︎ 结束日期" withHit:nil delegate:self];
    [self.lstEndDate initData:dateStr withVal:dateStr];
    [self.lstEndDate visibal:NO];
    
    //结束时间
    self.lstEndTime = [LSEditItemList editItemList];
    self.lstEndTime.tag = KTagLstEndTime;
    [self.container addSubview:self.lstEndTime];
    NSString *endTime = [DateUtils formateChineseTime:[DateUtils parseDateTime3:@"2017-01-01 23:59:00"]];
    [self.lstEndTime initLabel:@"▪︎ 结束时间" withHit:nil delegate:self];
    [self.lstEndTime initData:endTime withVal:endTime];
    [self.lstEndTime visibal:NO];
    
    //订单类型
    self.lstOrderType = [LSEditItemList editItemList];
    self.lstOrderType.tag = KTagLstOrderType;
    [self.lstOrderType initLabel:@"订单类型" withHit:nil delegate:self];
    [self.lstOrderType initData:@"全部" withVal:@""];
    [self.container addSubview:self.lstOrderType];
    
    //订单编号
    self.lstOrderSeek = [LSEditItemText editItemText];
    [self.lstOrderSeek initLabel:@"查询条件" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    self.lstOrderSeek.isShowStatus = NO;
    self.lstOrderSeek.txtVal.placeholder = @"单号";
    [self.container addSubview:self.lstOrderSeek];
    
    //按钮背景
    UIButton *btn = [LSViewFactor addGreenButton:self.container title:@"查询" y:0];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
   
    NSString *text = @"提示：可以根据上面的条件查询相应的商品销售明细。";
    [LSViewFactor addExplainText:self.container text:text y:0];
    
    LSFooterView *footer = [LSFooterView footerView];
    [footer initDelegate:self btnsArray:@[kFootScan]];
    [self.view addSubview:footer];
    footer.ls_bottom = SCREEN_H;
}


- (void)showShop {
    //只有连锁模式机构用户登录时显示
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


-(void)scanFail:(ScanViewController *)controller with:(NSString *)message
{
    
}

-(void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString
{
    [self.lstOrderSeek initData:scanString];
    if ([self isValid]) {
        NSString *url = @"orderDetailsReport/v2/getOrderList";
        LSGoodsTransactionFlowListController *vc = [[LSGoodsTransactionFlowListController alloc] init];
        vc.param = self.param;
        vc.url = url;
        vc.showExport = YES;
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }
}

#pragma mark
-(void)footViewdidClickAtFooterType:(NSString *)footerType
{
    if ([footerType isEqualToString:kFootScan]) {
        ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
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
    } else if (obj == self.lstShop) {//门店
        SelectShopListView *vc = [[SelectShopListView alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        __weak typeof(self) wself = self;
        [vc loadShopList:[obj getStrVal] withType:0 withViewType:NOT_CONTAIN_ALL withIsPush:YES callBack:^(id<ITreeItem> shop) {
            [wself.navigationController popViewControllerAnimated:NO];
            if (shop) {
                [wself.lstShop initData:[shop obtainItemName] withVal:[shop obtainItemId]];
                wself.shopEntityId = [shop obtainShopEntityId];
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }];
    } else if (obj == self.lstTime) {//选择时间
        NSMutableArray *list = [NSMutableArray array];
        NameItemVO *item = [[NameItemVO alloc] initWithVal:@"今天" andId:@"0"];
        [list addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"昨天" andId:@"0"];
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
    } else if (obj == self.lstStartDate || obj == self.lstEndDate) {//交易时间
        NSDate *date = [NSDate date];
        if ([NSString isNotBlank:obj.lblVal.text]) {
            date = [DateUtils parseDateTime4:obj.lblVal.text];
        }
        [DatePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
    }else if (obj == self.lstStartTime || obj == self.lstEndTime){
        NSString *date = @"";
        if (obj == self.lstStartTime) {
            date = @"00:00";
        }else
            date = @"24:00";
        NSDate *date1 = [DateUtils parseDateTime6:date];
        if ([NSString isNotBlank:obj.lblVal.text]) {
            date1 = [DateUtils parseDateTime6:obj.lblVal.text];
        }
        [TimePickerBox show:obj.lblName.text date:date1 client:self event:obj.tag];
    }else if (obj == self.lstOrderType){
        NSMutableArray *list = [NSMutableArray array];
        NameItemVO *item = [[NameItemVO alloc] initWithVal:@"全部" andId:@"0"];
        [list addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"销售订单" andId:@"1"];
        [list addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"退货订单" andId:@"2"];
        [list addObject:item];
        [OptionPickerBox initData:list itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
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
            [self.lstStartTime visibal:YES];
            [self.lstEndDate visibal:YES];
            [self.lstEndTime visibal:YES];
        } else {
            [self.lstStartDate visibal:NO];
            [self.lstStartTime visibal:NO];
            [self.lstEndDate visibal:NO];
            [self.lstEndTime visibal:NO];
        }
    }else if (eventType == KTagLstOrderType){
        [self.lstOrderType initData:[item obtainItemName] withVal:[item obtainItemId]];
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

-(BOOL)pickTime:(NSDate *)date event:(NSInteger)event
{
    NSString *dateStr = [DateUtils formateChineseTime:date];
    if (event == KTagLstStartTime){
        [self.lstStartTime initData:dateStr withVal:dateStr];
    }else if (event == KTagLstEndTime){
        [self.lstEndTime initData:dateStr withVal:dateStr];
    }
    return YES;
}



#pragma - 点击查询按钮
- (void)btnClick:(UIButton *)btn {
    if ([self isValid]) {
        NSString *url = @"orderDetailsReport/v2/getOrderList";
        LSGoodsTransactionFlowListController *vc = [[LSGoodsTransactionFlowListController alloc] init];
        vc.param = self.param;
        vc.url = url;
        vc.showExport = YES;
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }
}

- (BOOL)isValid {
    NSDate *startDate = [DateUtils parseDateTime4:[self.lstStartDate getStrVal]];
    NSDate *endDate = [DateUtils parseDateTime4:[self.lstEndDate getStrVal]];
    NSDate *startTime = [DateUtils parseDateTime6:[self.lstStartTime getStrVal]];
    NSDate *endTime = [DateUtils parseDateTime6:[self.lstEndTime getStrVal]];
    if (self.lstStartDate.hidden == NO) {
        if (![DateUtils daysToNow:startDate]) {
            return NO;
        }
        if ([startDate compare:endDate] == NSOrderedDescending) {
            [AlertBox show:@"开始日期不能大于结束日期!"];
            return NO;
        }else if ([startDate compare:endDate] == NSOrderedSame){
            if ([startTime compare:endTime] == NSOrderedDescending) {
                [AlertBox show:@"开始时间不能大于结束时间"];
                return NO;
            }
        }
    }
    
    if (self.lstShop.hidden == NO && [[self.lstShop getDataLabel] isEqualToString:@"请选择"]) {
        [AlertBox show:@"请选择门店！"];
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
        shopId = [self.lstShop getStrVal];
    } else {
        shopId = [[Platform Instance] getkey:SHOP_ID];
    }
    [_param setValue:shopId forKey:@"shopId"];
    //开始时间 结束时间精确到毫秒
    if ([self.lstTime.lblVal.text isEqualToString:@"自定义"]) {
        NSString *startDate = [self.lstStartDate.lblVal.text stringByAppendingString:[NSString stringWithFormat:@" %@",self.lstStartTime.lblVal.text]];
        NSString *endDate = [self.lstEndDate.lblVal.text stringByAppendingString:[NSString stringWithFormat:@" %@",self.lstEndTime.lblVal.text]];
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converStartTime1:startDate]] forKey:@"startTime"];
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converStartTime1:endDate]] forKey:@"endTime"];
    } else {
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converStartTime:self.lstTime.lblVal.text]] forKey:@"startTime"];
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converEndTime:self.lstTime.lblVal.text]] forKey:@"endTime"];
    }
    //订单类型
    if ([self.lstOrderType.lblVal.text isEqualToString:@"全部"]) {
        [_param setValue:[NSNumber numberWithInt:0] forKey:@"orderType"];
    }else if ([self.lstOrderType.lblVal.text isEqualToString:@"销售订单"]){
        [_param setValue:[NSNumber numberWithInt:1] forKey:@"orderType"];
    }
    else {
        [_param setValue:[NSNumber numberWithInt:2] forKey:@"orderType"];
    }
    
    //订单号
    if ([self.lstOrderSeek getStrVal].length > 0) {
        [_param setValue:[self.lstOrderSeek getStrVal] forKey:@"code"];
    }
    //商户ID
    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    [_param setValue:entityId forKey:@"entityId"];
    if (self.lstShop.hidden == NO) {
        [_param setValue:self.shopEntityId forKey:@"shopEntityId"];
    } else {
        [_param setValue:[[Platform Instance] getkey:RELEVANCE_ENTITY_ID] forKey:@"shopEntityId"];
    }
    //销售方式1.实体 2.微店
    NSString *shopType = [self.lstSaleType getStrVal];
    if ([[self.lstSaleType getDataLabel] isEqualToString:@"全部"]) {
        [_param removeObjectForKey:@"searchType"];
    } else {
        [_param setValue:shopType forKey:@"searchType"];
    }
    
    [_param setValue:@20 forKey:@"pageSize"];
    return _param;
}

@end
