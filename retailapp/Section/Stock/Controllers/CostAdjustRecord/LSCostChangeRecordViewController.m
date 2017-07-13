//
//  LSCostChangeRecordViewController.m
//  retailapp
//
//  Created by guozhi on 2017/1/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define TAG_LST_SaleShop 1
#define TAG_LST_SaleTime 2
#define TAG_LST_StartTime 3
#define TAG_LST_EndTime 4
#define TAG_LST_SelectKeyword 5
#import "LSCostChangeRecordViewController.h"
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
#import "AlertBox.h"
#import "LSFooterView.h"
#import "LSCostChangeRecordListController.h"
#import "ScanViewController.h"
#import "SelectShopListView.h"
#import "NameItemVO.h"
@interface LSCostChangeRecordViewController ()<IEditItemListEvent,OptionPickerClient,DatePickerClient,LSFooterViewDelegate,ISearchBarEvent,LSScanViewDelegate>
@property (assign, nonatomic) NSInteger                     shoptype;           /**1 门店用户登录查询 2机构用户登录查询*/
@property (strong, nonatomic) LSFooterView  *footView;          //页脚
@property (strong, nonatomic) UIScrollView         *scrollView;        //滚动栏
@property (strong, nonatomic) UIView               *container;         //滚动栏中子view容器
@property (strong, nonatomic) LSEditItemList         *lstShop;          //门店选择
@property (strong, nonatomic) LSEditItemList         *lstTime;           //时间选择
@property (strong, nonatomic) LSEditItemList         *lstStartTime;      //开始时间
@property (strong, nonatomic) LSEditItemList         *lstEndTime;        //结束时间
@property (strong, nonatomic) LSEditItemList         *lstSelectKeyWord;  //关键字类型选择,服鞋版显示
@property (strong, nonatomic) LSEditItemText         *txtSelectKeyWord;  //关键字输入
@property (nonatomic, strong) NSMutableDictionary   *recordListParam;   //查询变更记录的参数
@property (nonatomic, strong) NSString              *code;              //扫一扫得到的编码

@end

@implementation LSCostChangeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configConstraints];
    [self configContainerViews];
    [self initData];
}
- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //标题
    [self configTitle:@"成本价变更记录" leftPath:Head_ICON_BACK rightPath:nil];
    //scollVIew
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    //container
    self.container = [[UIView alloc] init];
    self.container.ls_width = SCREEN_W;
    [self.scrollView addSubview:self.container];
    
    self.footView = [LSFooterView footerView];
    [self.footView initDelegate:self btnsArray:@[kFootScan]];
    [self.view addSubview:self.footView];
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
    [self.footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(superView);
        make.height.equalTo(60);
    }];
    
}

- (void)configContainerViews {
    self.lstShop = [LSEditItemList editItemList];
    [self.lstShop initLabel:@"门店" withHit:nil delegate:self];
    self.lstShop.imgMore.image = [UIImage imageNamed:@"ico_next.png"];
    [self.container addSubview:self.lstShop];
    
    self.lstTime = [LSEditItemList editItemList];
    [self.lstTime initLabel:@"时间" withHit:nil delegate:self];
    [self.container addSubview:self.lstTime];
    
    self.lstStartTime = [LSEditItemList editItemList];
    [self.lstStartTime initLabel:@"▪︎ 开始日期" withHit:nil delegate:self];
    [self.container addSubview:self.lstStartTime];
    
    self.lstEndTime = [LSEditItemList editItemList];
    [self.lstEndTime initLabel:@"▪︎ 结束日期" withHit:nil delegate:self];
    [self.container addSubview:self.lstEndTime];
    
    self.lstSelectKeyWord = [LSEditItemList editItemList];
    [self.lstSelectKeyWord initLabel:@"查询条件" withHit:nil delegate:self];
    [self.container addSubview:self.lstSelectKeyWord];
    
    self.txtSelectKeyWord = [LSEditItemText editItemText];
    [self.txtSelectKeyWord initLabel:@"查询条件" withHit:nil isrequest:NO type:UIKeyboardTypeNumbersAndPunctuation];
    [self.txtSelectKeyWord showStatus:NO];
    [self.container addSubview:self.txtSelectKeyWord];
    
    UIButton *btn = [LSViewFactor addGreenButton:self.container title:@"查询" y:0];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *text = @"提示：可以根据上面的条件查询相应的商品成本价变更明细。";
    [LSViewFactor addExplainText:self.container text:text y:0];
    
    self.lstShop.tag = TAG_LST_SaleShop;
    self.lstTime.tag = TAG_LST_SaleTime;
    self.lstStartTime.tag = TAG_LST_StartTime;
    self.lstEndTime.tag = TAG_LST_EndTime;
    self.lstSelectKeyWord.tag = TAG_LST_SelectKeyword;
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];

}

- (void)initData {
    
    [self.lstTime initData:@"今天" withVal:@"0"];
    NSDate* date=[NSDate date];
    NSString* dateStr=[DateUtils formateDate2:date];
    [self.lstStartTime initData:dateStr withVal:dateStr];
    [self.lstStartTime visibal:NO];
    [self.lstEndTime initData:dateStr withVal:dateStr];
    [self.lstEndTime visibal:NO];
    
    //服鞋 101, 商超 102
    if ([[Platform Instance]getkey:SHOP_MODE].integerValue == 101) {
        [self.lstSelectKeyWord visibal:YES];
        [self.lstSelectKeyWord initData:@"店内码" withVal:@"1"];
        [self.txtSelectKeyWord initLabel:@"▪︎ 店内码" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
        self.txtSelectKeyWord.txtVal.placeholder = @"输入店内码";
    } else {
        [self.lstSelectKeyWord visibal:NO];
        self.txtSelectKeyWord.txtVal.placeholder = @"条形码/简码/拼音码";
    }
    
    if ([[Platform Instance] getShopMode] == 3) {
        [self.lstShop initData:@"请选择" withVal:@""];
        self.shoptype = 2;
    } else if ([[Platform Instance] getShopMode] == 2) {
        [self.lstShop visibal:NO];
        [self.lstShop initData:[[Platform Instance] getkey:SHOP_NAME] withVal:[[Platform Instance] getkey:SHOP_ID]];
        self.shoptype = 1;
    } else {
        [self.lstShop visibal:NO];
        [self.lstShop initData:[[Platform Instance] getkey:SHOP_NAME] withVal:[[Platform Instance] getkey:SHOP_ID]];
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
}


#pragma mark - FooterListEvent协议
- (void)footViewdidClickAtFooterType:(NSString *)footerType {
    if ([footerType isEqualToString:kFootScan]) {
        [self showScanEvent];
    }
}
- (void)showScanEvent {
    if ([self isValid]) {
        ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    }
}
#pragma mark - 条形码扫描
// LSScanViewDelegate
- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    self.code = scanString;
    self.txtSelectKeyWord.txtVal.text = scanString;
    [self btnClick:nil];
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [AlertBox show:message];
}


#pragma mark - IEditItemListEvent协议
- (void)onItemListClick:(LSEditItemList *)obj {
    
    if (obj == self.lstStartTime || obj == self.lstEndTime) {
        //开始时间和结束时间
        NSDate *date = [NSDate date];
        if ([NSString isNotBlank:obj.lblVal.text]) {
            date = [DateUtils parseDateTime4:obj.lblVal.text];
        }
        [DatePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
    } else if(obj == self.lstShop) {
        //店家
        __weak typeof(self) wself = self;
        SelectShopListView *vc = [[SelectShopListView alloc] init];
        [vc loadShopList:[self.lstShop getStrVal] withType:0 withViewType:NOT_CONTAIN_ALL withIsPush:YES callBack:^(id<ITreeItem> shop) {
            if (shop) {
                [wself.lstShop initData:[shop obtainItemName] withVal:[shop obtainItemId]];
            }
            [wself popViewController];
        }];
        [self pushViewController:vc];
        
    }else{
        NSArray *listItems;
        if (obj == self.lstTime) {
            listItems = @[@"今天",@"昨天",@"本周",@"上周",@"本月",@"上月",@"自定义"];
              [OptionPickerBox initData:[MenuList list1FromArray:listItems] itemId:[obj getStrVal]];
        } else if (obj == self.lstSelectKeyWord) {
            listItems = @[[[NameItemVO alloc] initWithVal:@"款号" andId:@"3"],
                          [[NameItemVO alloc] initWithVal:@"条形码" andId:@"2"],
                          [[NameItemVO alloc] initWithVal:@"店内码" andId:@"1"],
                          [[NameItemVO alloc] initWithVal:@"拼音码" andId:@"4"]];
            [OptionPickerBox initData:listItems itemId:[obj getStrVal]];
        }
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }
    
}

#pragma mark - OptionPickerClient协议
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == TAG_LST_SaleTime) {
        [self.lstTime initData:[item obtainItemName] withVal:[item obtainItemName]];
        if ([[item obtainItemName] isEqualToString:@"自定义"]) {
            [self.lstStartTime visibal:YES];
            [self.lstEndTime visibal:YES];
        } else {
            [self.lstStartTime visibal:NO];
            [self.lstEndTime visibal:NO];
        }
    } else if (eventType == TAG_LST_SelectKeyword) {
        [self.lstSelectKeyWord initData:[item obtainItemName] withVal:[item obtainItemId]];
        NSString *strTemp = [NSString stringWithFormat:@"▪︎ %@",[item obtainItemName]];
        self.txtSelectKeyWord.lblName.text = strTemp;
        self.txtSelectKeyWord.txtVal.placeholder = [NSString stringWithFormat:@"输入%@",[item obtainItemName]];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

#pragma mark - DatePickerClient协议
- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event {
    NSString *dateStr = [DateUtils formateDate2:date];
    if (event == TAG_LST_StartTime) {
        [self.lstStartTime initData:dateStr withVal:dateStr];
    } else {
        [self.lstEndTime initData:dateStr withVal:dateStr];
    }
    return YES;
}
#pragma mark - paramGet
//获取变更列表的参数
- (NSMutableDictionary *)recordListParam{
    _recordListParam = [[NSMutableDictionary alloc] init];
    
    if ([self.lstTime.lblVal.text isEqualToString:@"自定义"]) {
        [_recordListParam setValue:[NSNumber numberWithLongLong:[DateUtils converStartTime:self.lstStartTime.lblVal.text]] forKey:@"startTime"];
        [_recordListParam setValue:[NSNumber numberWithLongLong:[DateUtils converEndTime:self.lstEndTime.lblVal.text]] forKey:@"endTime"];
    } else {
        [_recordListParam setValue:[NSNumber numberWithLongLong:[DateUtils converStartTime:self.lstTime.lblVal.text]] forKey:@"startTime"];
        [_recordListParam setValue:[NSNumber numberWithLongLong:[DateUtils converEndTime:self.lstTime.lblVal.text]] forKey:@"endTime"];
    }
    
    
    NSInteger shopMode = [[Platform Instance]getkey:SHOP_MODE].integerValue;//服鞋 101, 商超 102
    if (shopMode == 101) {
        [_recordListParam setValue:[self.lstSelectKeyWord getStrVal] forKey:@"findType"];
    }
    [_recordListParam setValue:self.txtSelectKeyWord.txtVal.text forKey:@"findParameter"];
    
    
    if ([[Platform Instance] getShopMode] == 3) {
        [_recordListParam setValue:[self.lstShop getStrVal] forKey:@"shopId"];
    } else if ([[Platform Instance] getShopMode] == 2){
        [_recordListParam setValue:[self.lstShop getStrVal] forKey:@"shopId"];
    } else {
        [_recordListParam setValue:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
    }
    
    [_recordListParam setValue:[NSNumber numberWithInteger:1] forKey:@"currentPage"];
    
    return _recordListParam;
}

#pragma mark - clickEvent
- (void)btnClick:(id)sender {
    if ([self isValid]){
        LSCostChangeRecordListController *vc = [[LSCostChangeRecordListController alloc] init];
        vc.param = self.recordListParam;
        vc.keyWord = self.txtSelectKeyWord.txtVal.text;
        [self pushViewController:vc];
    }
}

#pragma mark - check
//参数检查
- (BOOL)isValid {
    
    NSString *shopId;
    if ([[Platform Instance] getShopMode] == 3) {
        shopId = [self.lstShop getStrVal];
    } else if ([[Platform Instance] getShopMode] == 2){
        shopId = [self.lstShop getStrVal];
        
    } else {
        shopId =[[Platform Instance] getkey:SHOP_ID];
    }
    if (self.lstShop.hidden == NO && [NSString isBlank:[self.lstShop getStrVal]]) {
        [AlertBox show:@"请先选择门店！"];
        return NO;
    }

    NSDate *startDate = [DateUtils parseDateTime4:[self.lstStartTime getStrVal]];
    NSDate *endDate = [DateUtils parseDateTime4:[self.lstEndTime getStrVal]];
    if (self.lstStartTime.hidden == NO) {
        if (![DateUtils daysToNow:startDate]) {
            return NO;
        }
        if ([startDate compare:endDate] == NSOrderedDescending) {
            [AlertBox show:@"开始日期不能大于结束日期!"];
            return NO;
        }
        
    }
    return YES;
}


@end
