//
//  StockQueryView.m
//  retailapp
//
//  Created by guozhi on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#define TAG_LST_ALERT_NUMBER 1
#define TAG_LST_DAY 2
#import "AlertSettingDetail.h"
#import "XHAnimalUtil.h"
#import "UIHelper.h"
#import "LSEditItemRadio.h"
#import "LSEditItemList.h"
#import "Platform.h"
#import "SymbolNumberInputBox.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "NSString+Estimate.h"
#import "AlertSettingBatch.h"
#import "EditItemView.h"
#import "GoodsVo.h"
#import "AlertSettingView.h"

@implementation AlertSettingBatch
- (void)viewDidLoad {
    [super viewDidLoad];
    service = [ServiceFactory shareInstance].stockService;
    [self initNavigate];
    [self initMainView];
    [self initNotification];
    [self initData];
    
}
- (void)initNavigate {
    [self configTitle:@"提醒设置" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
    if (event == LSNavigationBarButtonDirectLeft) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
        
    } else {
        [service alertEdit:self.param CompletionHandler:^(id json) {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[AlertSettingView class]]) {
                    AlertSettingView *alertView = (AlertSettingView *)vc;
                    [alertView loadData];
                    [alertView loadSelectCategory];
                    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                    [self.navigationController popToViewController:alertView animated:NO];
                }
            }

        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

- (void)initMainView {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H)];
    [self.view addSubview:self.scrollView];
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    
    self.rdoAlertNum = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoAlertNum];
    
    self.lstAlertNum = [LSEditItemList editItemList];
    [self.container addSubview:self.lstAlertNum];
    
    self.rdoDay = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoDay];
    
    self.lstDay = [LSEditItemList editItemList];
    [self.container addSubview:self.lstDay];

    [self.rdoAlertNum initLabel:@"库存数量提醒" withHit:nil delegate:self];
    [self.lstAlertNum initLabel:@"库存数量提醒数量" withHit:nil delegate:self];
    [self.rdoDay initLabel:@"保质期提醒" withHit:nil delegate:self];
    [self.lstDay initLabel:@"保质期提醒天数" withHit:nil delegate:self];
    self.lstAlertNum.tag = TAG_LST_ALERT_NUMBER;
    self.lstDay.tag = TAG_LST_DAY;
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
    
}

- (void)initData {
    [self.rdoDay initData:@"0"];
    [self.rdoAlertNum initData:@"0"];
    [self.lstDay initData:@"0" withVal:@"0"];
    [self.lstAlertNum initData:@"0" withVal:@"0"];
    if ([[self.rdoAlertNum getStrVal] isEqualToString:@"1"]) {
        [self.lstAlertNum visibal:YES];
    } else {
        [self.lstAlertNum visibal:NO];
    }
    if ([[self.rdoDay getStrVal] isEqualToString:@"1"]) {
        [self.lstDay visibal:YES];
    } else {
        [self.lstDay visibal:NO];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}


- (void)initNotification
{
    [UIHelper initNotification:self.container event:Notification_UI_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_Change object:nil];
}

- (void)dataChange:(NSNotification *)notification
{
    [self editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];
    
}

- (void)onItemListClick:(LSEditItemList *)obj {
    if (obj == self.lstAlertNum) {
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:3];
    }
    if (obj == self.lstDay ){
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:0];
    }
    [SymbolNumberInputBox initData:obj.lblVal.text];
}

- (void)onItemRadioClick:(LSEditItemRadio *)obj {
    if (obj == self.rdoAlertNum) {
        if ([[obj getStrVal] isEqualToString:@"1"]) {
            [self.lstAlertNum visibal:YES];
        } else {
            [self.lstAlertNum visibal:NO];
        }
    }
    if (obj == self.rdoDay) {
        if ([[obj getStrVal] isEqualToString:@"1"]) {
            [self.lstDay visibal:YES];
        } else {
            [self.lstDay visibal:NO];
        }
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
}

- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    if (eventType == TAG_LST_ALERT_NUMBER) {
        [self.lstAlertNum changeData:val withVal:val];
    }
    if (eventType == TAG_LST_DAY) {
        [self.lstDay changeData:val withVal:val];
    }
    
}

- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [[NSMutableDictionary alloc] init];
    }
    [_param removeAllObjects];
    [_param setValue:self.shopId forKey:@"shopId"];
    NSMutableArray *goodsIds = [[NSMutableArray alloc] init];
    for (GoodsVo *goodsVo in self.goodsVos) {
         [goodsIds addObject:goodsVo.goodsId];
    }
    [_param setValue:goodsIds forKey:@"goodsIds"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSNumber numberWithInt:[[self.rdoAlertNum getStrVal] intValue]] forKey:@"isAlertNum"];
    [dict setValue:[NSNumber numberWithInt:[[self.rdoDay getStrVal] intValue]] forKey:@"isAlertDay"];
    if (self.lstAlertNum.hidden == NO) {
        [dict setValue:[NSNumber numberWithInt:[[self.lstAlertNum getStrVal] intValue]] forKey:@"alertNum"];
    }
    if (self.lstDay.hidden == NO) {
        [dict setValue:[NSNumber numberWithInt:[[self.lstDay getStrVal] intValue]] forKey:@"alertDay"];
    }
    [_param setValue:dict forKey:@"stockInfoAlertVo"];
    return _param;
}


@end
