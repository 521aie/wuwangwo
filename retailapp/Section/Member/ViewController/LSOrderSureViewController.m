//
//  LSOrderSureViewController.m
//  retailapp
//
//  Created by guozhi on 16/9/2.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSOrderSureViewController.h"
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "UIView+Sizes.h"
#import "EditItemView.h"
#import "LSOrderPayTypeCell.h"
#import "AlertBox.h"
#import "MJExtension.h"
#import "LSEditItemTitle.h"
#import "LSPayVo.h"
#import "LSSmsPackageVo.h"
#import <AlipaySDK/AlipaySDK.h>
#import "LSAlipayUtil.h"
#import "LSSmsMarketingViewController.h"
#import "LSBrithdayReminderViewController.h"
#import "ObjectUtil.h"
#import "SmsSetController.h"

@interface LSOrderSureViewController ()<INavigateEvent, UITableViewDelegate, UITableViewDataSource, AlertBoxClient>
/**
 *  标题栏
 */
@property (nonatomic, strong) NavigateTitle2 *navigateTitle;
/**
 *  表格
 */
@property (nonatomic, strong) UITableView *tableView;
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray *datas;
/**
 *  区头
 */
@property (nonatomic, strong) UIView *headerView;
/**
 *  区尾
 */
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) NSString *payUrl;
@property (nonatomic, copy) NSString *outTradeNo;

@end

@implementation LSOrderSureViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self initNotification];
}
#pragma mark - 网络请求

#pragma mark - 确认充值事件
- (void)btnClick:(UIButton *)btn {
    //短信充值预处理
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //支付类型
    [param setValue:@1 forKey:@"recharge_type"];
    //购买数量
    [param setValue:@(self.smsPackageVo.num) forKey:@"package_num"];
    //短信列表ID
    [param setValue:@(self.smsPackageVo.id) forKey:@"sms_package_id"];
    NSString *url = @"sms/v1/smsPreRecharge";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        NSDictionary *dict = json[@"alipayAppPayResponse"];
        wself.payUrl = dict[@"payUrl"];
        wself.outTradeNo = dict[@"outTradeNo"];
        [wself startAlipay];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}
#pragma 消息处理部分.
- (void)initNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(smsPayFinish:) name:Notification_Sms_Pay_Finish object:nil];
}

- (void)smsPayFinish:(NSNotification*)notification {
    NSString *url = @"sms/v1/smsRechargeConfirm";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.outTradeNo forKey:@"pay_id"];
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        if ([ObjectUtil isNotNull:json[@"isPaid"]]) {
            if ([json[@"isPaid"] isKindOfClass:[NSNumber class]]) {
                BOOL isPaid = [json[@"isPaid"] boolValue];//是否支付成功
                if (isPaid) {
                    [AlertBox show:@"充值成功！" client:self];
                }
            }
            
        }
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}

-(void)understand {
    __weak typeof(self) wself = self;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {//短信充值页面充值成功为了刷新剩余短信数量
        if ([obj isKindOfClass:[LSSmsMarketingViewController class]]) {
            LSSmsMarketingViewController *vc = (LSSmsMarketingViewController *)obj;
            [vc loadData];
            [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [wself.navigationController popToViewController:vc animated:NO];
        } else if ([obj isKindOfClass:[LSBrithdayReminderViewController class]]) {
            LSBrithdayReminderViewController *vc = (LSBrithdayReminderViewController *)obj;
            [vc loadData];
            [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [wself.navigationController popToViewController:vc animated:NO];
        } else if ([obj isKindOfClass:[SmsSetController class]]) {
            SmsSetController *vc = (SmsSetController *)obj;
            [vc loadData];
            [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [wself.navigationController popToViewController:vc animated:NO];
        }
        
    }];
}
- (void)startAlipay {
    if ([NSString isNotBlank:self.payUrl]) {
       NSString *appScheme = @"retailapp";
        [[AlipaySDK defaultService] payOrder:self.payUrl fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            [LSAlipayUtil payFinish:resultDic];
        }];
    } else {
        [AlertBox show:@"支付数据好像有问题哦，请重新试一下看哦!"];
    }
}
#pragma mark - delegate
#pragma mark INavigateEvent
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
    
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSOrderPayTypeCell *cell = [LSOrderPayTypeCell orderPayTypeCellWithTableView:tableView];
    LSPayVo *payVo = self.datas[indexPath.row];
    cell.payVo = payVo;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.headerView.ls_height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.footerView.ls_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

#pragma mark - setup
//布局方式
- (void)setup {
    CGFloat y = 0;
    self.navigateTitle.ls_top = y;
    y = y + self.navigateTitle.ls_height;
    self.tableView.ls_top = y;
}
#pragma mark - setters and getters
#pragma mark 标题栏
- (NavigateTitle2 *)navigateTitle {
    if (!_navigateTitle) {
        _navigateTitle = [NavigateTitle2 navigateTitle:self];
        [_navigateTitle initWithName:@"订单确认" backImg:Head_ICON_BACK moreImg:nil];
        [self.view addSubview:_navigateTitle];
    }
    return _navigateTitle;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.ls_width, self.view.ls_height - self.navigateTitle.ls_height) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}

- (UIView *)headerView {
    if (!_headerView) {
        CGFloat y = 0;
        _headerView = [[UIView alloc] init];
        //订单内容
        LSEditItemTitle *titleOrder = [LSEditItemTitle editItemTitle];
        [titleOrder configTitle:@"订单内容"];
        [_headerView addSubview:titleOrder];

        //购买套餐
         y = y + titleOrder.ls_height;
        EditItemView *vewPackage = [EditItemView editItemView];
        [vewPackage initLabel:@"购买套餐" withHit:nil];
        [vewPackage initData:self.smsPackageVo.name withVal:nil];
        vewPackage.ls_top = y;
        [_headerView addSubview:vewPackage];
        //购买价格
        y = y + vewPackage.ls_height;
        EditItemView *vewPrice = [EditItemView editItemView];
        [vewPrice initLabel:@"购买价格" withHit:nil];
        [vewPrice initData:[NSString stringWithFormat:@"%.2f元", self.smsPackageVo.price] withVal:nil];
        vewPrice.ls_top = y;
        [_headerView addSubview:vewPrice];
        //支付方式
        y = y + vewPackage.ls_height;
        y = y + 20;
        LSEditItemTitle *titlePay = [LSEditItemTitle editItemTitle];
        [titlePay configTitle:@"支付方式"];
        titlePay.ls_top = y;
        [_headerView addSubview:titlePay];
        
        
        CGFloat headerViewH = y + titlePay.ls_height;
        _headerView.bounds = CGRectMake(0, 0, self.view.ls_width,headerViewH);
        
    }
    return _headerView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.ls_width, 64)];
        CGFloat margin = 10;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        CGFloat btnX = margin;
        CGFloat btnY = 10;
        CGFloat btnW = _footerView.ls_width - 2 * margin;
        CGFloat btnH = 44;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_full_g"] forState:UIControlStateNormal];
        [btn setTitle:@"确认支付" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:btn];
        _footerView.ls_height = btnH + 2 * margin;
    }
    return _footerView;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
        LSPayVo *payVo = [[LSPayVo alloc] init];
        payVo.name = @"支付宝支付";
        payVo.path = @"ico_alipay";
        payVo.isSelect = YES;
        [_datas addObject:payVo];
    }
    return _datas;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_Sms_Pay_Finish object:nil];
}
@end

