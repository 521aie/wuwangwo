//
//  LSCostChangeRecordDetailController.m
//  retailapp
//
//  Created by guozhi on 2017/1/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSCostChangeRecordDetailController.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "MemberTransactionListVo.h"
#import "SVProgressHUD.h"
#import "DateUtils.h"
#import "SystemUtil.h"
#import "UIHelper.h"
#import "LSEditItemView.h"
#import "LSCostChangeRecordVo.h"

@interface LSCostChangeRecordDetailController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *container;       //子view容器
/** 商品名称 */
@property (nonatomic, strong) LSEditItemView *vewGoodsName;
/** 条形码/店内码 */
@property (nonatomic, strong) LSEditItemView *vewCode;
/** 颜色 */
@property (nonatomic, strong) LSEditItemView *vewColor;
/** 尺码 */
@property (nonatomic, strong) LSEditItemView *vewSize;
/** 操作类型 */
@property (nonatomic, strong) LSEditItemView *vewOperateType;
/** 变更前成本价 */
@property (nonatomic, strong) LSEditItemView *vewCostChangeBefore;
/** 变更后成本价 */
@property (nonatomic, strong) LSEditItemView *vewCostChangeAfter;
/** 长本届差异 */
@property (nonatomic, strong) LSEditItemView *vewCostChange;
/** 单号 */
@property (nonatomic, strong) LSEditItemView *vewNo;
/** 操作人 */
@property (nonatomic, strong) LSEditItemView *vewOpUser;
/** 操作时间 */
@property (nonatomic, strong) LSEditItemView *vewOpTime;
@end

@implementation LSCostChangeRecordDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configConstraints];
    [self configContainerViews];
}


- (void)configViews {
    [self configTitle:self.obj.changeType leftPath:Head_ICON_BACK rightPath:nil];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //scollVIew
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    //container
    self.container = [[UIView alloc] init];
    self.container.ls_width = SCREEN_W;
    [self.scrollView addSubview:self.container];
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
}

- (void)configContainerViews {
    self.vewGoodsName = [LSEditItemView editItemView];
    self.vewGoodsName.lblDetail.font = [UIFont systemFontOfSize:15];
    [self.vewGoodsName initLabel:@"商品名称" withHit:self.obj.goodsName];
    [self.container addSubview:self.vewGoodsName];
    
    self.vewCode = [LSEditItemView editItemView];
    if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
       [self.vewCode initLabel:@"店内码" withHit:nil];
        [self.vewCode initData:self.obj.innerCode];
    } else {
       [self.vewCode initLabel:@"条形码" withHit:nil];
        [self.vewCode initData:self.obj.barCode];
    }
    [self.container addSubview:self.vewCode];
    if ([[Platform Instance]getkey:SHOP_MODE].integerValue == 101) {
        self.vewColor = [LSEditItemView editItemView];
        [self.vewColor initLabel:@"颜色" withHit:nil];
        [self.vewColor initData:self.obj.goodsColor];
        [self.container addSubview:self.vewColor];
        
        self.vewSize = [LSEditItemView editItemView];
        [self.vewSize initLabel:@"尺码" withHit:nil];
        [self.vewSize initData:self.obj.goodsSize];
        [self.container addSubview:self.vewSize];
       
    }
    self.vewOperateType = [LSEditItemView editItemView];
    [self.vewOperateType initLabel:@"操作类型" withHit:nil];
    [self.vewOperateType initData:self.obj.changeType];
    [self.container addSubview:self.vewOperateType];
    
    self.vewCostChangeBefore = [LSEditItemView editItemView];
    [self.vewCostChangeBefore initLabel:@"变更前成本价(元)" withHit:nil];
    [self.vewCostChangeBefore initData:[NSString stringWithFormat:@"%.2f", self.obj.beforeCostPrice.doubleValue]];
    [self.container addSubview:self.vewCostChangeBefore];
     self.vewCostChangeAfter = [LSEditItemView editItemView];
    [self.vewCostChangeAfter initLabel:@"变更后成本价(元)" withHit:nil];
    [self.vewCostChangeAfter initData:[NSString stringWithFormat:@"%.2f", self.obj.laterCostPrice.doubleValue]];
    [self.container addSubview:self.vewCostChangeAfter];
    
    if ([ObjectUtil isNotNull:self.obj.difCostPrice]) {
        self.vewCostChange = [LSEditItemView editItemView];
        [self.vewCostChange initLabel:@"成本价差异(元)" withHit:nil];
        [self.vewCostChange initData:[NSString stringWithFormat:@"%.2f", self.obj.difCostPrice.doubleValue]];
        [self.container addSubview:self.vewCostChange];
    }
   
    
    if ([ObjectUtil isNotNull:self.obj.billsNo]) {
        self.vewCode = [LSEditItemView editItemView];
        [self.vewCode initLabel:@"单号" withHit:nil];
        [self.vewCode initData:self.obj.billsNo];
        [self.container addSubview:self.vewCode];
    }
   
    
    self.vewOpUser = [LSEditItemView editItemView];
    [self.vewOpUser initLabel:@"操作人" withHit:nil];
    [self.vewOpUser initData:self.obj.opUser];
    [self.container addSubview:self.vewOpUser];
    
    self.vewOpTime = [LSEditItemView editItemView];
    [self.vewOpTime initLabel:@"操作时间" withHit:nil];
    [self.vewOpTime initData:self.obj.opTime];
    [self.container addSubview:self.vewOpTime];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}



@end
