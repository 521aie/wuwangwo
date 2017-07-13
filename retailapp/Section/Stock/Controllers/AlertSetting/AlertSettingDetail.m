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
#import "AlertSettingView.h"
#import "EditItemView.h"
#import "GoodsVo.h"
#import "AlertDetailVo.h"
#import "IEditItemListEvent.h"
#import "SymbolNumberInputBox.h"
#import "IEditItemRadioEvent.h"
#import "GoodsVo.h"
#import "LSGoodsInfoView.h"
@interface AlertSettingDetail()<IEditItemListEvent,SymbolNumberInputClient,IEditItemRadioEvent> {
    StockService *service;
}
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *container;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) NSMutableDictionary *param1;
@property (strong, nonatomic) LSEditItemRadio *rdoAlertNum;
@property (strong, nonatomic) LSEditItemList *lstAlertNum;
@property (strong, nonatomic) LSEditItemRadio *rdoDay;
@property (strong, nonatomic) LSEditItemList *lstDay;
/** <#注释#> */
@property (nonatomic, strong) LSGoodsInfoView *viewGoodsInfo;
@property (nonatomic, assign) int action;
@end
@implementation AlertSettingDetail
- (void)viewDidLoad {
    [super viewDidLoad];
     service = [ServiceFactory shareInstance].stockService;
    [self initNavigate];
    [self initMainView];
    [self initNotification];
    [self configHelpButton:HELP_STOCK_ALERT_SETTING];
    [self loadData];
    
}
- (void)initNavigate {
    [self configTitle:@"提醒设置" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
    if (event == LSNavigationBarButtonDirectLeft) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[AlertSettingView class]]) {
                AlertSettingView *as = (AlertSettingView *)vc;
                as.currentPage = 1;
                [as loadData];
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                [self.navigationController popViewControllerAnimated:NO];
            }
        }
    } else {
        [service alertEdit:self.param1 CompletionHandler:^(id json) {
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
    self.viewGoodsInfo = [LSGoodsInfoView goodsInfoView];
    [self.container addSubview:self.viewGoodsInfo];
    
    self.rdoAlertNum = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoAlertNum];
    
    self.lstAlertNum = [LSEditItemList editItemList];
    [self.container addSubview:self.lstAlertNum];
    
    self.rdoDay = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoDay];
    
    self.lstDay = [LSEditItemList editItemList];
    [self.container addSubview:self.lstDay];
    [self.viewGoodsInfo setGoodsName:self.obj.goodsName barCode:self.obj.barCode retailPrice:self.obj.retailPrice filePath:self.obj.filePath goodsStatus:self.obj.upDownStatus type:self.obj.type];
    [self.rdoAlertNum initLabel:@"库存预警" withHit:nil delegate:self];
    [self.lstAlertNum initLabel:@"▪︎ 库存下限" withHit:nil delegate:self];
    [self.rdoDay initLabel:@"过期提醒" withHit:nil delegate:self];
    [self.lstDay initLabel:@"▪︎ 保质期下限" withHit:nil delegate:self];
    self.lstAlertNum.tag = TAG_LST_ALERT_NUMBER;
    self.lstDay.tag = TAG_LST_DAY;
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
    
}

- (void)initAleryDetailVo:(AlertDetailVo *)alertDetailVo {
    [self.rdoDay initData:alertDetailVo.isAlertDay.stringValue];
    [self.rdoAlertNum initData:alertDetailVo.isAlertNum.stringValue];
    [self.lstDay initData:[NSString stringWithFormat:@"%@",alertDetailVo.alertDay] withVal:[NSString stringWithFormat:@"%@",alertDetailVo.alertDay]];
     [self.lstAlertNum initData:[NSString stringWithFormat:@"%@",alertDetailVo.alertNum] withVal:[NSString stringWithFormat:@"%@",alertDetailVo.alertNum]];
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

- (void)loadData {
    [service alertDetail:self.param CompletionHandler:^(id json) {
        AlertDetailVo *alertDetailVo = [[AlertDetailVo alloc] initWithDictionary:json[@"stockInfoAlertVo"]];
        [self initAleryDetailVo:alertDetailVo];
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
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
    [_param setValue:self.obj.goodsId forKey:@"goodsId"];
    return _param;
}

- (NSMutableDictionary *)param1 {
    if (_param1 == nil) {
        _param1 = [[NSMutableDictionary alloc] init];
    }
    [_param removeAllObjects];
    [_param1 setValue:self.shopId forKey:@"shopId"];
    NSMutableArray *goodsIds = [[NSMutableArray alloc] init];
    [goodsIds addObject:self.obj.goodsId];
    [_param1 setValue:goodsIds forKey:@"goodsIds"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSNumber numberWithInt:[[self.rdoAlertNum getStrVal] intValue]] forKey:@"isAlertNum"];
    [dict setValue:[NSNumber numberWithInt:[[self.rdoDay getStrVal] intValue]] forKey:@"isAlertDay"];
    if (self.lstAlertNum.hidden == NO) {
        [dict setValue:[NSNumber numberWithInt:[[self.lstAlertNum getStrVal] intValue]] forKey:@"alertNum"];
    }
    if (self.lstDay.hidden == NO) {
        [dict setValue:[NSNumber numberWithInt:[[self.lstDay getStrVal] intValue]] forKey:@"alertDay"];
    }
    [_param1 setValue:dict forKey:@"stockInfoAlertVo"];
    return _param1;
}


@end
