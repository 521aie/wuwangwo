//
//  KindPayEditView.m
//  retailapp
//
//  Created by 果汁 on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "KindPayEditView.h"
#import "LSEditItemList.h"
#import "LSEditItemRadio.h"
#import "LSEditItemText.h"
#import "LSEditItemView.h"
#import "PaymentVo.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "OptionPickerBox.h"
#import "MenuList.h"
#import "INameItem.h"
#import "NSString+Estimate.h"
#import "AlertBox.h"
#import "ServiceFactory.h"
#import "SettingService.h"
#import "JsonHelper.h"
#import "LSKindPayListController.h"
#import "NameItemVO.h"

@implementation KindPayEditView

- (instancetype)initWithAction:(int)action paymentVo:(PaymentVo *)paymentVo payList:(NSMutableArray *)payList {
    if (self = [super init]) {
        self.action = action;
        self.paymentVo = paymentVo;
        self.payList = payList;
        service = [ServiceFactory shareInstance].settingService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    [self configViews];
    [self initMainView];
    [self loadData];
    [self initNotification];
    [self configHelpButton:HELP_SETTING_PAYMENT_METHOD];
    
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    
    self.lstKind = [LSEditItemList editItemList];
    [self.container addSubview:self.lstKind];
    
    self.txtName = [LSEditItemText editItemText];
    [self.container addSubview:self.txtName];
    
    self.rdoSale = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoSale];
    
    self.vewSale = [LSEditItemView editItemView];
    [self.container addSubview:self.vewSale];
                    
    self.rdoCashBox = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoCashBox];
    
    self.lblNote = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_W - 20, 100)];
    self.lblNote.font = [UIFont systemFontOfSize:12];
    self.lblNote.numberOfLines = 0;
    [self.container addSubview:self.lblNote];
    
    UIButton *btn = [LSViewFactor addRedButton:self.container title:@"删除" y:0];
    self.btnDel = btn.superview;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    
    
}

#pragma mark - 初始化导航栏
- (void)initNavigate {
    [self configTitle:@"店家信息" leftPath:Head_ICON_BACK rightPath:nil];
}

#pragma mark - 导航栏点击事件
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
    if (event == LSNavigationBarButtonDirectLeft) {
        if (self.action == ACTION_CONSTANTS_ADD) {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        } else {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        [self save];
    }
}

#pragma mark - 初始化页面
- (void)initMainView {
    [self.lstKind initLabel:@"支付类型" withHit:nil delegate:self];
    [self.txtName initLabel:@"支付方式名称" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.rdoSale initLabel:@"收入计入销售额" withHit:nil];
    [self.rdoSale initData:@"1"];
    [self.vewSale initLabel:@"收入计入销售额" withHit:nil];
    [self.vewSale visibal:NO];
    self.vewSale.lblVal.textColor =[ColorHelper getTipColor6];
    self.txtName.num = 10;
    [self.rdoCashBox initLabel:@"支付完成后自动打开钱箱" withHit:nil];
    self.lblNote.textColor = [ColorHelper getTipColor6];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"提示："];
    [attr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"【收入计入销售额】开关状态的变更直接影响到销售额的统计，建议不要随意修改。" attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}]];
    [attr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"以“其他”为例，将开关由关闭修改为开启，然后更新收银机数据。在统计时，更新收银机数据之前用“其他”支付的金额都不计入；更新之后用“其他”支付的金额都计入。"]];
    self.lblNote.attributedText = attr;
    
    
}

#pragma mark - 初始化通知
- (void)initNotification {
    [UIHelper initNotification:self.container event:Notification_UI_KindPayEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_KindPayEditView_Change object:nil];
    
}

#pragma mark - 页面里面的值改变时调用
- (void)dataChange:(NSNotification *)notification {
   
    [self editTitle:[UIHelper currChange:self.container] act:self.action];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 加载数据
- (void)loadData {
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self isVisibal:YES];
        [self clearDo];
    } else {
        [self isVisibal:NO];
        [self fillModel];
    }
    [self editTitle:NO act:self.action];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
    
}


#pragma mark - 添加模式和编辑模式页面是否显示
- (void)isVisibal:(BOOL)visibal {
    self.btnDel.hidden = visibal;
    [self.lstKind editEnable:(self.action == ACTION_CONSTANTS_ADD)];
    [self configTitle: visibal ? @"添加" : @"现金"];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma mark - 添加模式页面初始化
- (void)clearDo {
    for (NameItemVO *item in self.payList) {
        if ([[item obtainItemName] isEqualToString:@"现金"]) {
            [self.lstKind initData:[item obtainItemName] withVal:[item obtainItemId]];
        }
    }
    [self.txtName initData:@"现金"];
    [self.rdoCashBox initData:@"0"];
    [self.rdoSale initData:@"1"];
    [self configTitle:@"添加"];
}

#pragma mark - 编辑模式页面初始化
- (void)fillModel {
    [self configTitle:self.paymentVo.payMentName];
    [self.lstKind initData:self.paymentVo.payTyleName withVal:self.paymentVo.payTyleId];
    [self.txtName initData:self.paymentVo.payMentName];
    if ([ObjectUtil isNull:self.paymentVo.joinSalesMoney] || [self.paymentVo.joinSalesMoney intValue]== 1) {
        [self.rdoSale initData:@"1"];
    } else {
         [self.rdoSale initData:@"0"];
    }
    /*
     支付方式列表页内，网络支付方式 [支付宝]跟 [微信]支持点击进入详情页；
     网络支付的详情页，不支持修改支付类型、支付方式名称；
     开关“收入计入销售额”初始默认为打开状态；
     开关“支付完成后自动打开钱箱”初始默认为关闭状态； *
     */
    if ([self.paymentVo.payTyleVal isEqualToString:Wxpay] || [self.paymentVo.payTyleVal isEqualToString:Alipay]) {
        [self.txtName editEnabled:NO];
        [self.rdoCashBox initData:@"0"];
        self.lblNote.hidden = YES;
        self.btnDel.hidden = YES;
        [self.rdoCashBox visibal:NO];
        [self.rdoSale visibal:NO];
        [self.vewSale visibal:YES];
        [self.vewSale initData:@"计入"];
    } else if ([self.paymentVo.payTyleName isEqualToString:@"会员卡"] ||[self.paymentVo.payTyleName isEqualToString:@"优惠券"]) {
        self.lblNote.hidden = YES;
        [self.rdoSale visibal:NO];
        [self.vewSale visibal:YES];
        if ([self.paymentVo.payTyleName isEqualToString:@"会员卡"]) {
             [self.rdoSale initData:@"1"];
             [self.vewSale initData:@"计入"];
        } else {
             [self.vewSale initData:@"不计入"];
             [self.rdoSale initData:@"1"];
        }
    }
    [self.rdoCashBox initData:[NSString stringWithFormat:@"%d",self.paymentVo.isAutoOpenCashBox]];
    
}

#pragma mark - 点击支付类型
- (void)onItemListClick:(LSEditItemList *)obj {
    if (obj == self.lstKind) {
        [OptionPickerBox initData:self.payList itemId:[obj getStrVal]];
        [OptionPickerBox show:@"支付类型" client:self event:obj.tag];
    }
}

#pragma mark - 选择支付类型
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;
    [self.lstKind changeData:[item obtainItemName] withVal:[item obtainItemId]];
    NSString *name = [item obtainItemName];
    /*
     优惠券，开关“收入计入销售额”初始默认为关闭状态；其余支付方式，初始默认为打开状态
     */
    if ([name isEqualToString:@"储值卡"] ||[name isEqualToString:@"优惠券"]) {
        self.lblNote.hidden = YES;
        [self.rdoSale visibal:NO];
        [self.vewSale visibal:YES];
        if ([name isEqualToString:@"储值卡"]) {
            [self.vewSale initData:@"计入" ];
            [self.rdoSale changeData:@"1"];
        } else {
            [self.vewSale initData:@"不计入"];
            [self.rdoSale changeData:@"0"];
        }
    } else {
        self.lblNote.hidden = NO;
        [self.rdoSale visibal:YES];
        [self.vewSale visibal:NO];
        [self.rdoSale initData:@"1"];
    }
    [self.txtName changeData:[item obtainItemName]];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

#pragma mark - 保存数据
- (void)save{
    if (![self isValid]) {
        return;
    }
    PaymentVo *paymentVo = [[PaymentVo alloc] init];
    NSString *oprateType = (self.action == ACTION_CONSTANTS_ADD) ? @"add":@"edit";
    paymentVo.payTyleId = [self.lstKind getStrVal];
    paymentVo.payTyleName = [self.lstKind getDataLabel];
    paymentVo.payMentName = [self.txtName getStrVal];
    paymentVo.isAutoOpenCashBox = [[self.rdoCashBox getStrVal] intValue];
    if (!(self.action == ACTION_CONSTANTS_ADD) ) {
        paymentVo.lastVer = self.paymentVo.lastVer;
        paymentVo.payId = self.paymentVo.payId;
    }
    //收入计入销售额
    if ([self.rdoSale getVal]) {
        paymentVo.joinSalesMoney = @1;
    } else {
         paymentVo.joinSalesMoney = @0;
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[JsonHelper transDictionary:paymentVo] forKey:@"payMentVo"];
    [param setValue:oprateType forKey:@"operateType"];
    [service payMentSave:param completionHandler:^(id json) {
        if (self.action == ACTION_CONSTANTS_ADD) {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        } else {
             [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[LSKindPayListController class]]) {
                LSKindPayListController *kindPayListView = (LSKindPayListController *)vc;
                [kindPayListView loadData];
            }
        }
        [self.navigationController popViewControllerAnimated:NO];
        
    } errorHandler:^(id json) {
         [AlertBox show:json];
    }];
    
    
}

#pragma mark - 判断是否满足保存条件
- (BOOL)isValid {
        if ([NSString isBlank:[self.txtName getStrVal]]) {
            [AlertBox show:@"支付方式名称不能为空，请输入！"];
            return NO;
        }
    if (self.txtName.txtVal.text.length > 10) {
        [AlertBox show:@"支付方式名称字数限制在10字以内"];
         return NO;
    }
   
    return YES;
}
- (void)showHelpEvent {
    
}


- (void)deleteKindPayEvent {
    __weak typeof(self) weakself = self;
    [service paymentDelete:self.paymentVo.payId completionHandler:^(id json) {
        LSKindPayListController *kindListVc = nil;
        for (UIViewController *vc in weakself.navigationController.viewControllers) {
            if ([vc isKindOfClass:[LSKindPayListController class]]) {
                kindListVc = (LSKindPayListController *)vc;
            }
        }
        [kindListVc loadData];
        [weakself.navigationController popViewControllerAnimated:YES];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}
#pragma mark - 点击删除按钮
- (void)btnClick:(UIButton *)sender {
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"确认要删除[%@]吗?",self.paymentVo.payMentName]];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (self.count == 1) {
            [AlertBox show:@"支付方式全部被删除后，将无法收银！"];
            return;
        }
        [self deleteKindPayEvent];
    }
}



@end
