//
//  OrderLogisticsInfoView.m
//  retailapp
//
//  Created by Jianyong Duan on 16/1/12.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrderLogisticsInfoView.h"
#import "SellReturnService.h"
#import "ServiceFactory.h"
#import "TracesVos.h"
#import "AlertBox.h"
#import "LogisticsInfoCell.h"
#import "XHAnimalUtil.h"
#import "EditItemView.h"
#import "UIHelper.h"
#import "ColorHelper.h"
#import "Platform.h"
@interface OrderLogisticsInfoView ()<INavigateEvent>

@property (nonatomic, strong) SellReturnService *sellReturnService;

@property (nonatomic, strong) TracesVos *tracesVos;

@end

@implementation OrderLogisticsInfoView

- (TracesVos *)tracesVos {
    if ([ObjectUtil isNull:_tracesVos]) {
        _tracesVos = [[TracesVos alloc] init];
    }
    return _tracesVos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    [self initNotification];
    [self initMainView];
    [self configHelpButton:HELP_WECHAT_SALE_ORDER_SEND_INFO];
}

- (void)initNavigate {
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"配送信息" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

- (void)initMainView {
    self.sellReturnService = [ServiceFactory shareInstance].sellReturnService;
    [self.vewDealShop initLabel:@"处理门店" withHit:nil];
    [self.vewOutType initLabel:@"配送类型" withHit:nil];
    [self.vewLogisticName initLabel:@"快递公司" withHit:nil];
    [self.vewLogisticNo initLabel:@"快递单号" withHit:nil];
    [self.vewOutFee initLabel:@"配送费(元)" withHit:nil];
    [self.vewOutFee initData:self.sendFee withVal:self.sendFee];
    [self.vewSendMan initLabel:@"配送员" withHit:nil];
    [self.vewDealShop visibal:NO];
    [self.vewDealShop initData:[NSString stringWithFormat:@"%@",self.sendFee] withVal:[NSString stringWithFormat:@"%@",self.sendFee]];
    if ([[Platform Instance] getShopMode] !=1 && self.orderType == 1) {
        [self.vewDealShop visibal:YES];
        [self.vewDealShop initData:self.dealShop withVal:nil];
    }
    
    if ([NSString isNotBlank:self.logisticsNo]) {
        [self.vewOutType initData:@"第三方物流配送" withVal:nil];
        [self.vewLogisticName initData:self.logisticsName withVal:nil];
        [self.vewLogisticNo initData:self.logisticsNo withVal:nil];
        [self.vewSendMan visibal:NO];
        self.viewMain.hidden = NO;
        [self loadData];
    } else {
        [self.vewOutType initData:@"店家配送" withVal:nil];
        [self.vewSendMan initData:self.sendMan withVal:nil];
        [self.vewLogisticName visibal:NO];
        [self.vewLogisticNo visibal:NO];
        self.viewMain.hidden = YES;
    }
    if (self.type == 1) {
        [self.titleBox initWithName:@"物流信息" backImg:Head_ICON_BACK moreImg:nil];
        [self.vewDealShop visibal:NO];
        [self.vewOutFee visibal:NO];
        [self.vewOutType visibal:NO];
    }
    
    // 默认开微店后不需要 处理门店一栏了
    [self.vewDealShop visibal:NO];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];

}


#pragma mark - 初始化通知
- (void)initNotification {
    [UIHelper initNotification:self.container event:Notification_UI_KindPayEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_KindPayEditView_Change object:nil];
}

#pragma mark - 页面里面的值改变时调用
- (void)dataChange:(NSNotification *)notification {
    
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];
}


-(void) onNavigateEvent:(Direct_Flag)event {
    if (event == 1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)loadData {
    __weak OrderLogisticsInfoView *weakSelf = self;
    [self.sellReturnService logisticsMessage:self.logisticsNo logisticsName:self.logisticsName completionHandler:^(id json) {
                               [weakSelf responceToJson:json];
                               
                           } errorHandler:^(id json) {
                               [AlertBox show:json];
                           }];
}

- (void)responceToJson:(id)json {
    //快递公司
    NSString *name = [json objectForKey:@"logisticsName"];
    if ([NSString isNotBlank:name]) {
       [self.vewLogisticName initData:name withVal:nil];
    }
    
    self.tracesVos = [TracesVos converToVo:json[@"tracesVos"]];
    if ([ObjectUtil isNull:self.tracesVos.traces]) {
        UILabel *labTip = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        if ([self.logisticsName isEqual:@"中通快递"]) {
            labTip.text = @"暂无物流信息哦...";
        }else{
            labTip.text = @"其他快递公司暂未支持...";
        }
        
        labTip.textColor = [ColorHelper getTipColor3];
        labTip.textAlignment = NSTextAlignmentCenter;
        labTip.font = [UIFont boldSystemFontOfSize:11];
        [self.container addSubview:labTip];
    } else {
        int i = 0;
        for (TracesVo *trace in self.tracesVos.traces) {
            LogisticsInfoCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"LogisticsInfoCell" owner:nil options:nil] lastObject];
            if (trace.scanDate.length > 16 ) {
                cell.lblDate.text = [trace.scanDate substringToIndex:10];
                cell.lblTime.text = [trace.scanDate substringWithRange:NSMakeRange(11, 5)];
            } else {
                cell.lblDate.text = @"";
                cell.lblTime.text = @"";
            }
            
            if (i == 0) {
                cell.viewLineUp.hidden = YES;
            } else {
                cell.viewLineUp.hidden = NO;
            }
            if (i == self.tracesVos.traces.count - 1) {
                cell.viewLineDown.hidden = YES;
            } else {
                cell.viewLineDown.hidden = NO;
            }
            
            cell.tvMessage.text = trace.desc;
            i++;
            [self.container addSubview:cell];
        }
        
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];

}

@end
