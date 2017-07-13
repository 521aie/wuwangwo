//
//  OrderListView.m
//  retailapp
//
//  Created by guozhi on 16/5/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrderListView.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"
#import "OrderPayListData.h"
#import "UIView+Sizes.h"
#import "OrderPayListCell.h"
#import "LSOnlineReceiptVo.h"
#import "ObjectUtil.h"
#import "LSPaymentOrderDetailController.h"
#import "LSPaymentOrderDetailRechargeController.h"

static NSString *listCellId = @"OrderPayListCell";
@interface OrderListView () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *mainGrid;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *entityId;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, copy) NSString *payment;
@property (nonatomic, strong) UIView *viewHeader;
@end
@implementation OrderListView

- (instancetype)initWithDate:(NSString *)date entityId:(NSString *)entityId payment:(NSString *)payment {
    self = [super init];
    if (self) {
        self.date = date;
        self.entityId = entityId;
        self.payment = payment;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTitle];
    [self setupMainGrid];
    [self loadData];
    [self configHelpButton:HELP_PAYMENT_ACCOUNT];
}
- (void)setupTitle {
    [self configTitle:[NSString stringWithFormat:@"%@收款明细", self.payment] leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)setupMainGrid {
    self.mainGrid = [[UITableView alloc] init];
    [self.mainGrid registerClass:[OrderPayListCell class] forCellReuseIdentifier:listCellId];
    self.mainGrid.backgroundColor = [UIColor clearColor];
    self.mainGrid.delegate = self;
    self.mainGrid.dataSource = self;
    self.mainGrid.tableHeaderView = self.viewHeader;
    
    self.mainGrid.rowHeight = UITableViewAutomaticDimension;
    self.mainGrid.estimatedRowHeight=88.0f;
    [self.view addSubview:self.mainGrid];
    
    __weak typeof(self) wself = self;
    [self.mainGrid makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wself.view);
        make.top.equalTo(wself.view).offset(kNavH);
    }];
    
    self.currentPage = 1;
    self.mainGrid.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.mainGrid ls_addHeaderWithCallback:^{
        wself.currentPage = 1;
        [wself loadData];
    }];
    [self.mainGrid ls_addFooterWithCallback:^{
        wself.currentPage++;
        [wself loadData];
    }];
}


- (void)loadData {
    NSString *url = @"onlineReceipt/detailList";
    __weak OrderListView *weakSelf = self;
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
        if (weakSelf.currentPage == 1) {
            [weakSelf.datas removeAllObjects];
        }
        
        NSMutableArray *receiptList = json[@"receiptList"];
        if ([ObjectUtil isNotNull:receiptList]) {
            for (NSDictionary *map in receiptList) {
                LSOnlineReceiptVo *receiptVo = [LSOnlineReceiptVo onlineReceiptVoWithMap:map];
                [weakSelf.datas addObject:receiptVo];
            }
        }
        [weakSelf.mainGrid reloadData];
        weakSelf.mainGrid.ls_show = YES;
        
    } errorHandler:^(id json) {
        [weakSelf.mainGrid headerEndRefreshing];
        [weakSelf.mainGrid footerEndRefreshing];
        [AlertBox show:json];
    }];
    
}

- (UIView *)viewHeader {
    if (_viewHeader == nil) {
        _viewHeader  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 100)];
        UILabel *lbl = [[UILabel alloc] init];
        lbl.font = [UIFont systemFontOfSize:11];
        lbl.textColor = [UIColor whiteColor];
        lbl.numberOfLines = 0;
        lbl.text = @"目前我们有两种转账方式，“已到账”代表二维火公司转账，“已划账”代表兴业银行转账，若是已划账，具体到账时间依据银行操作时间。";
        [_viewHeader addSubview:lbl];
        [lbl makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(_viewHeader).offset(10);
            make.right.equalTo(_viewHeader).offset(-10);
        }];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
        [_viewHeader addSubview:bgView];
        [bgView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_viewHeader).offset(5);
            make.right.equalTo(_viewHeader).offset(-5);
            make.top.equalTo(lbl.bottom).offset(10);
            make.height.equalTo(40);
        }];
        UILabel *lblLeft = [[UILabel alloc] init];
        lblLeft.font = [UIFont boldSystemFontOfSize:14];
        lblLeft.textColor = [UIColor whiteColor];
        lblLeft.text = @"当日账户明细";
        [bgView addSubview:lblLeft];
        [lblLeft makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).offset(5);
            make.centerY.equalTo(bgView);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"ico_next_down_w"];
        [bgView addSubview:imgView];
        [imgView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bgView).offset(-5);
            make.centerY.equalTo(bgView);
            make.size.equalTo(22);
        }];
        UILabel *lblRight= [[UILabel alloc] init];
        lblRight.font = [UIFont boldSystemFontOfSize:14];
        lblRight.textColor = [UIColor whiteColor];
        lblRight.text = @"详情";
        [bgView addSubview:lblRight];
        [lblRight makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(imgView.left);
            make.centerY.equalTo(bgView);
        }];
        [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)]];
        [_viewHeader layoutIfNeeded];
        _viewHeader.ls_height = bgView.ls_bottom;
        
    }
    return _viewHeader;
}

- (void)tapClick:(UITapGestureRecognizer *)ges {
    [self popViewControllerDirect:AnimationDirectionV];
}

- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [NSMutableDictionary dictionary];
    }
    [_param removeAllObjects];
    [_param setValue:@(self.currentPage) forKey:@"page"];
    [_param setValue:@"20" forKey:@"pageSize"];
    [_param setValue:self.date forKey:@"findDate"];
    if ([self.payment isEqualToString:@"支付宝"]) {
        [_param setValue:@2 forKey:@"pay_type"];
    } else if ([self.payment isEqualToString:@"微信"]) {
         [_param setValue:@1 forKey:@"pay_type"];
    } else if ([self.payment isEqualToString:@"QQ钱包"]) {
        [_param setValue:@5 forKey:@"pay_type"];
    }
    return _param;
}

- (NSMutableArray *)datas {
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (IBAction)btnClick:(UIButton *)sender {
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
    [self popViewController];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderPayListCell *orderCell =  [tableView dequeueReusableCellWithIdentifier:listCellId];
    LSOnlineReceiptVo *receiptVo = self.datas[indexPath.row];
    [orderCell initWithData:receiptVo payType:self.payment];
    return orderCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LSOnlineReceiptVo *receiptVo = self.datas[indexPath.row];
    
    if (receiptVo.orderCode == nil || [receiptVo.orderCode isEqualToString:@""] || [receiptVo.orderCode isEqual:[NSNull null]]) {
//<<<<<<< HEAD
//        
//        [AlertBox show:@"此账单还未经过收银员的同意，暂时无法查看详情哦！"];
//=======
        [AlertBox show:@"该收银订单暂未上传，请在收银机同步数据后查看订单详情！"];
//>>>>>>> develop
        return;
    }
//<<<<<<< HEAD
//    
//=======
//    LSPaymentOrderDetailController *vc = [[LSPaymentOrderDetailController alloc] init];
//    vc.customerId = receiptVo.customerId;
//    vc.customerRegisterId = receiptVo.customerRegisterId;
//    vc.orderCode = receiptVo.orderCode;
//    vc.orderId = receiptVo.orderId;
//    vc.entityId = self.entityId;
//    vc.channelType = receiptVo.channelType;
//>>>>>>> feature/daily
    if ([receiptVo.payFor isEqualToString:@"pay_for_order"]) {//订单
        
        LSPaymentOrderDetailController *vc = [[LSPaymentOrderDetailController alloc] init];
        vc.payMsgTag = receiptVo.payMsgTag;
        vc.customerId = receiptVo.customerId;
        vc.customerRegisterId = receiptVo.customerRegisterId;
        vc.orderCode = receiptVo.orderCode;
        vc.orderId = receiptVo.orderId;
        vc.entityId = self.entityId;
        vc.type = TypeConsume;
        [self pushViewController:vc];
    } else if ([receiptVo.payFor isEqualToString:@"pay_for_charge"]) {//充值
        
        LSPaymentOrderDetailRechargeController *vc = [[LSPaymentOrderDetailRechargeController alloc] init];
        vc.payMsgTag = receiptVo.payMsgTag;
        vc.customerId = receiptVo.customerId;
        vc.customerRegisterId = receiptVo.customerRegisterId;
        vc.orderCode = receiptVo.orderCode;
        vc.orderId = receiptVo.orderId;
        vc.entityId = self.entityId;
//        vc.type = TypeRecharge;
        [self pushViewController:vc];
    } else {
        
        LSPaymentOrderDetailController *vc = [[LSPaymentOrderDetailController alloc] init];
        vc.payMsgTag = receiptVo.payMsgTag;
        vc.customerId = receiptVo.customerId;
        vc.customerRegisterId = receiptVo.customerRegisterId;
        vc.orderCode = receiptVo.orderCode;
        vc.orderId = receiptVo.orderId;
        vc.entityId = self.entityId;
        vc.type = TypeConsume;
        [self pushViewController:vc];
    }
    
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

@end

