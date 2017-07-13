//
//  AcountInformationList.m
//  retailapp
//
//  Created by guozhi on 15/11/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//


#import "CashRecordDetail.h"
#import "NavigateTitle2.h"
#import "SystemUtil.h"
#import "XHAnimalUtil.h"
#import "EditItemView.h"
#import "UIHelper.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "NSString+Estimate.h"
#import "Platform.h"
#import "DateUtils.h"
#import "ColorHelper.h"
#import "UIView+Sizes.h"
#import "WithdrawCheckVo.h"
#import "WithdrawRecord.h"

@implementation CashRecordDetail

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withdrawCheckVo:(WithdrawCheckVo *)withdrawCheckVo {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.withdrawCheckVo = withdrawCheckVo;
        service = [ServiceFactory shareInstance].otherService;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    [self initMainView];
    [self initData];
}

- (void)initNavigate {
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == 1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)initMainView {
    [self.vewName initLabel:@"持卡人" withHit:nil];
    [self.vewAcount initLabel:@"账户" withHit:nil];
    [self.vewCash initLabel:@"提现金额(元)" withHit:nil];
    [self.vewTime initLabel:@"申请时间" withHit:nil];
    [self.vewState initLabel:@"审核状态" withHit:nil];
    self.btnBgView.hidden = YES;
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)initData {
    self.titleBox.lblTitle.text = [NSString stringWithFormat:@"提现%.2f元",self.withdrawCheckVo.actionAmount];
    [self.vewName initData: self.withdrawCheckVo.accountName withVal:self.withdrawCheckVo.accountName];
    [self.vewAcount initData:[NSString stringWithFormat:@"%@  尾号%@",self.withdrawCheckVo.bankName,self.withdrawCheckVo.lastFourNum] withVal:[NSString stringWithFormat:@"%@  尾号%@",self.withdrawCheckVo.bankName,self.withdrawCheckVo.lastFourNum]];
    [self.vewCash initData:[NSString stringWithFormat:@"%.2f",self.withdrawCheckVo.actionAmount] withVal:[NSString stringWithFormat:@"%.2f",self.withdrawCheckVo.actionAmount]];
    [self.vewTime initData:[NSString stringWithFormat:@"%@",[DateUtils formateTime:self.withdrawCheckVo.createTime*1000]] withVal:[NSString stringWithFormat:@"%@",[DateUtils formateTime:self.withdrawCheckVo.createTime*1000]]];
    if (self.withdrawCheckVo.checkResult == 1) {
        [self.vewState initData:@"未审核" withVal:@"未审核"];
        self.labDetail.hidden = YES;
        self.labTitle.hidden = YES;
        self.btnBgView.hidden = NO;
    }
    if (self.withdrawCheckVo.checkResult == 2) {
        [self.vewState initData:@"审核不通过" withVal:@"审核不通过"];
        self.vewState.lblVal.textColor = [ColorHelper getRedColor];
    }
    if (self.withdrawCheckVo.checkResult == 3) {
        [self.vewState initData:@"审核通过" withVal:@"审核通过"];
        self.vewState.lblVal.textColor = [ColorHelper getGreenColor];
        self.labTitle.hidden = YES;
        self.labDetail.hidden = YES;
    }
    if (self.withdrawCheckVo.checkResult == 4) {
        [self.vewState initData:@"取消" withVal:@"取消"];
        self.vewState.lblVal.textColor = [ColorHelper getRedColor];
        self.labTitle.hidden = YES;
        self.labDetail.hidden = YES;
    }
    if ([NSString isBlank:self.withdrawCheckVo.refuseReason]) {
        self.labDetail.text = @"";
    } else {
        self.labDetail.text = self.withdrawCheckVo.refuseReason;
    }
    
    self.labDetail.ls_width = 300;
    [self.labDetail sizeToFit];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
}
- (IBAction)cancelWithdraw:(UIButton *)sender {
    [service applyCancel:[self param] completionBlock:^(id json) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[WithdrawRecord class]]) {
                WithdrawRecord *listView = (WithdrawRecord *)vc;
                [listView.mainGrid headerBeginRefreshing];
            }
        }
        [self.navigationController popViewControllerAnimated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [[NSMutableDictionary alloc] init];
    }
    [_param setValue:[self.withdrawCheckVo converToDic] forKey:@"withdrawCheck"];
    [_param setValue:@"cancel" forKey:@"operateType"];
    return _param;
}

- (NSMutableDictionary *)param1 {
    if (_param1 == nil) {
        _param1 = [[NSMutableDictionary alloc] init];
    }
    [_param1 setValue:self.shopWithdrawCheckId forKey:@"shopWithdrawCheckId"];
    [_param1 setValue:@"cancel" forKey:@"operateType"];
    return _param1;
}

@end
