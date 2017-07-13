//
//  LSEmployeePerformanceViewController.m
//  retailapp
//
//  Created by guozhi on 2017/1/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define TAG_LST_TRANSACTION_TIME 1
#define TAG_LST_TRANSACTION_START_TIME 2
#define TAG_LST_TRANSACTION_END_TIME 3
#define TAG_LST_ROLE 4
#import "LSEmployeePerformanceViewController.h"
#import "IEditItemListEvent.h"
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
#import "DatePickerBox.h"
#import "SelectShopListView.h"
#import "LSEmployeePerformanceListController.h"
#import "AlertBox.h"
#import "NSString+Estimate.h"
#import "ServiceFactory.h"
#import "NameItemVO.h"
#import "ObjectUtil.h"
#import "LSEmployeePerformanceListController.h"
@interface LSEmployeePerformanceViewController ()<IEditItemListEvent,OptionPickerClient,DatePickerClient>
/***/
@property (strong, nonatomic) LSEditItemText *txtPhoneNumber;
@property (strong, nonatomic) LSEditItemList *LstTransactionTime;
@property (strong, nonatomic) LSEditItemList *LstStartTime;
@property (strong, nonatomic) LSEditItemList *LstEndTime;
@property (strong, nonatomic) LSEditItemList *LstTransactionShop;
@property (strong, nonatomic) LSEditItemList *lstRole;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *container;
@property (nonatomic, strong) NSMutableDictionary *param;
/** 选择的shopEntityId */
@property (nonatomic, copy) NSString *shopEntityId;

@end

@implementation LSEmployeePerformanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configContainerViews];
    [self initData];
}
- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //标题
    [self configTitle:@"员工业绩报表" leftPath:Head_ICON_BACK rightPath:nil];
    //scollVIew
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H)];
    [self.view addSubview:self.scrollView];
    //container
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
}



- (void)configContainerViews {
    self.LstTransactionShop = [LSEditItemList editItemList];
    [self.LstTransactionShop initLabel:@"门店" withHit:nil delegate:self];
    [self.container addSubview:self.LstTransactionShop];
    
    self.LstTransactionTime = [LSEditItemList editItemList];
    [self.LstTransactionTime initLabel:@"时间" withHit:nil delegate:self];
    [self.container addSubview:self.LstTransactionTime];
    
    self.LstStartTime = [LSEditItemList editItemList];
    [self.LstStartTime initLabel:@"▪︎ 开始日期" withHit:nil delegate:self];
    [self.container addSubview:self.LstStartTime];
    
    self.LstEndTime = [LSEditItemList editItemList];
    [self.LstEndTime initLabel:@"▪︎ 结束日期" withHit:nil delegate:self];
    [self.container addSubview:self.LstEndTime];
    
    self.lstRole = [LSEditItemList editItemList];
    [self.lstRole initLabel:@"类型" withHit:nil delegate:self];
    [self.container addSubview:self.lstRole];

    
    self.txtPhoneNumber = [LSEditItemText editItemText];
    [self.txtPhoneNumber initLabel:@"查询条件" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    self.txtPhoneNumber.isShowStatus = NO;
    [self.container addSubview:self.txtPhoneNumber];
    self.txtPhoneNumber.txtVal.placeholder = @"员工姓名/工号/手机号";
    
    UIButton *btn = [LSViewFactor addGreenButton:self.container title:@"查询" y:0];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *text = @"提示：可以根据上面的条件查询相应的员工业绩报表。";
    [LSViewFactor addExplainText:self.container text:text y:0];
    
    self.LstTransactionTime.tag = TAG_LST_TRANSACTION_TIME;
    self.LstStartTime.tag = TAG_LST_TRANSACTION_START_TIME;
    self.LstEndTime.tag = TAG_LST_TRANSACTION_TIME;
    self.lstRole.tag = TAG_LST_ROLE;
    self.txtPhoneNumber.tag = 1000;

    
}

- (void)initData {
    self.shopEntityId = [[Platform Instance] getkey:RELEVANCE_ENTITY_ID];
    [self.txtPhoneNumber initMaxNum:50];
    [self.LstTransactionTime initData:@"昨天" withVal:@"0"];
    
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSString* dateStr=[DateUtils formateDate2:yesterday];
    [self.LstStartTime initData:dateStr withVal:dateStr];
    [self.LstStartTime visibal:NO];
    [self.LstEndTime initData:dateStr withVal:dateStr];
    [self.LstEndTime visibal:NO];
    
    self.LstTransactionShop.imgMore.image = [UIImage imageNamed:@"ico_next"];
    if ([[Platform Instance] getShopMode] == 3) {
        [self.LstTransactionShop initData:@"请选择" withVal:@""];
    } else {
        [self.LstTransactionShop visibal:NO];
        [self.LstTransactionShop initData:[[Platform Instance] getkey:SHOP_NAME] withVal:[[Platform Instance] getkey:SHOP_ID]];
    }
    [self.lstRole initData:@"导购员业绩" withVal:@"2"];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
}

- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [[NSMutableDictionary alloc] init];
    }
    [_param removeAllObjects];
    if ([NSString isNotBlank:self.txtPhoneNumber.txtVal.text]) {
        [_param setValue:self.txtPhoneNumber.txtVal.text forKey:@"keyWord"];
    }
    if ([self.LstTransactionTime.lblVal.text isEqualToString:@"自定义"]) {
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converStartTime:self.LstStartTime.lblVal.text]/1000] forKey:@"startTime"];
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converEndTime:self.LstEndTime.lblVal.text]/1000] forKey:@"endTime"];
    } else {
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converStartTime:self.LstTransactionTime.lblVal.text]/1000] forKey:@"startTime"];
        [_param setValue:[NSNumber numberWithLongLong:[DateUtils converEndTime:self.LstTransactionTime.lblVal.text]/1000] forKey:@"endTime"];
    }
    if ([[Platform Instance] getShopMode] == 3) {
        [_param setValue:[self.LstTransactionShop getStrVal] forKey:@"shopId"];
    } else {
        [_param setValue:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
    }
    [_param setValue:[self.lstRole getStrVal] forKey:@"optType"];
    if (self.LstTransactionShop.hidden == NO) {
        [_param setValue:self.shopEntityId forKey:@"shopEntityId"];
    } else {
        [_param setValue:[[Platform Instance] getkey:RELEVANCE_ENTITY_ID] forKey:@"shopEntityId"];
    }
    
    
    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    [_param setValue:entityId forKey:@"entityId"];
    
    return _param;
}
- (void)onItemListClick:(LSEditItemList *)obj {
    if (obj == self.LstStartTime || obj == self.LstEndTime) {
        NSDate *date = [NSDate date];
        if ([NSString isNotBlank:obj.lblVal.text]) {
            date = [DateUtils parseDateTime4:obj.lblVal.text];
        }
        [DatePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
    } else if(obj == self.LstTransactionShop) {
        SelectShopListView *vc = [[SelectShopListView alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        __strong typeof(self) strongself = self;
        [vc loadShopList:[obj getStrVal] withType:2 withViewType:NOT_CONTAIN_ALL withIsPush:YES callBack:^(id<ITreeItem> shop) {
            [strongself.navigationController popViewControllerAnimated:NO];
            if (shop) {
                [strongself.LstTransactionShop initData:[shop obtainItemName] withVal:[shop obtainItemId]];
                strongself.shopEntityId = [shop obtainShopEntityId];
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }];
        
    } else if (obj == self.LstTransactionTime) {
        NSArray *listItems = @[@"昨天", @"本周", @"上周", @"本月", @"上月", @"自定义"];
        [OptionPickerBox initData:[MenuList list1FromArray:listItems] itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    } else if (obj == self.lstRole) {
        NSMutableArray *items = [[NSMutableArray alloc] init];
        NameItemVO *item = [[NameItemVO alloc] initWithVal:@"导购员业绩" andId:@"2"];
        [items addObject:item];
        item = [[NameItemVO alloc] initWithVal:@"收银员业绩" andId:@"1"];
        [items addObject:item];
        [OptionPickerBox initData:items itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == TAG_LST_TRANSACTION_TIME) {
        [self.LstTransactionTime initData:[item obtainItemName] withVal:[item obtainItemId]];
        if ([[item obtainItemName] isEqualToString:@"自定义"]) {
            [self.LstStartTime visibal:YES];
            [self.LstEndTime visibal:YES];
        } else {
            [self.LstStartTime visibal:NO];
            [self.LstEndTime visibal:NO];
        }
    } else if (eventType == TAG_LST_ROLE) {
        [self.lstRole initData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event {
    NSString *dateStr = [DateUtils formateDate2:date];
    if (event == TAG_LST_TRANSACTION_START_TIME) {
        [self.LstStartTime initData:dateStr withVal:dateStr];
    } else {
        [self.LstEndTime initData:dateStr withVal:dateStr];
    }
    return YES;
}

- (void)btnClick:(UIButton *)btn {
    if ([self isValid]){
        LSEmployeePerformanceListController *vc = [[LSEmployeePerformanceListController alloc] init];
        vc.param = self.param;
        vc.exportParam = [NSMutableDictionary dictionaryWithDictionary:self.param];
        vc.title1 = [self.lstRole getDataLabel];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }
}

- (BOOL)isValid {
    if ([self.LstTransactionShop.lblVal.text isEqualToString:@"请选择"]) {
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

@end
