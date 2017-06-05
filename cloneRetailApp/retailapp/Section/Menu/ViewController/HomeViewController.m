//
//  MainViewController.m
//  retailapp
//
//  Created by taihangju on 16/6/4.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "HomeViewController.h"
// 控制器
#import "LoginViewController.h"
#import "LSSystemParameterController.h"
//#import "MemberTypeListView.h"
#import "LSMemberCardTypeListViewController.h"
#import "EmployeeManageView.h"
#import "GoodsCategoryListView.h"
#import "LSGoodsInfoSelectViewController.h"
#import "GoodsStyleInfoView.h"
#import "PaperListView.h"
#import "AboutInfoView.h"
#import "BgViewController.h"
#import "UserEditPassView.h"
#import "SmsNoticeListView.h"
#import "MessageCenterListView.h"
#import "LSGoodsModuleController.h"
#import "LSEmployeeModuleController.h"

//#import "SmsMainListView.h"
#import "LSSmsMainListController.h"

#import "PaymentView.h"
#import "PaymentTypeView.h"
#import "LSMarketModuleController.h"
#import "LSLogisticModuleController.h"
#import "LSStockModuleController.h"
#import "LSReportModuleController.h"
#import "ScanPayView.h"
#import "LSWechatModuleController.h"
#import "LSCommentModuleController.h"
#import "BusinessDetailView.h"
#import "LSMemberModule.h"

// 类别
#import "UIView+Sizes.h"

#import "ReailAppDefine.h"
//view
#import "ShopIncomeView.h"
#import "ModuleConfigView.h"
#import "ShopReatedManInfoView.h"
#import "MenuRightView.h"
#import "LSMenuLeftView.h"
//model
#import "Platform.h"
#import "OptionPickerBox.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "ShopInfoVO.h"
#import "LSInfoAlertController.h"
#import "PaymentEditView.h"
#import "LSSystemNotificationController.h"
#import "LSSyetemNotificationView.h"
#import "LSSystemNotificationVo.h"

#import "LSShopInfoSetController.h"
#import "LSChainShopInfoController.h"
#import "LSOrgInfoController.h"

#import "TicketSetViewController.h"
#import "GuestNoteListView.h"
#import "SmsSetController.h"
#import "LSDataClearController.h"
#import "LSKindPayListController.h"
#import "EnterCircleListView.h"
#import "LSScreenAdvertisingController.h"
#import "MainPageShowView.h"
#import "LSHelpVideoListController.h"
#import "LSCommonProblemTypeListController.h"
#import "TDFCustomerServiceButtonController.h" // 智齿云客服
#import "TDFSobotChat.h"
#import "LSVideoVo.h"

const CGFloat kMarginValue = 100.0f;
@interface HomeViewController ()<ModuleConfigViewDelegate,LoginViewDelegate,MenuRightViewDelegate,ShopIncomeViewDelegate, LSInfoAlertDelegate, LSSystemNotificationViewDelegate, LSMenuLeftViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel      *navTitle;/*<导航栏title、店铺名称>*/
@property (weak, nonatomic) IBOutlet UIButton     *leftMenuButton;/*<显示左边栏button>*/
@property (weak, nonatomic) IBOutlet UIButton     *rightMenuButton;/*<显示右边栏button>*/
@property (weak, nonatomic) IBOutlet UIView       *contentView;
@property (weak, nonatomic) IBOutlet UIImageView  *contentViewBgImgv;/*<contentView的背景图>*/

@property (nonatomic, strong) ShopIncomeView   *incomeView;/*<收入显示view>*/
@property (nonatomic, strong) ModuleConfigView *dailyRunView;/*<日常运维>*/
@property (nonatomic, strong) ModuleConfigView *backgroundSetView;/*<后台设置>*/
@property (nonatomic, strong) MenuRightView    *rightView;/*<<#说明#>>*/
/** 左边View */
@property (nonatomic, strong) LSMenuLeftView *leftView;
/**推送消息*/
@property (weak, nonatomic) IBOutlet UIImageView *img_notice;


/**
 *  scrollView的子视图(为了避免移除下拉刷新控件需要记录一下)
 */
@property (nonatomic, strong) NSMutableArray *scrollViewSubViews;
/**
 *  门店电子收款账户
 */
@property (nonatomic, strong) ShopInfoVO *shopInfoVO;

/** 门店收入数据源 */
@property (nonatomic, strong) NSArray *incomeDatas;

/** 系统通知对象 */
@property (nonatomic, strong) LSSystemNotificationVo *systemNotificationVo;
/** 是否是新消息 */
@property (nonatomic, assign) BOOL isNewSms;
@property (nonatomic, strong) TDFCustomerServiceButtonController *customerServiceController; /**<智齿云客服button>*/
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLoginViewController];
    [self addMenuRightView];
    [self addMeunLeftView];
    [self changeBackgroundImage];
    [self addTapGesture];
    [self addHeaderRefresh];
    [self initNotification];
    [self.customerServiceController addCustomerServiceButtonToView:self.view];
}

- (TDFCustomerServiceButtonController *)customerServiceController {
    if (!_customerServiceController) {
        _customerServiceController = [[TDFCustomerServiceButtonController alloc] init];
    }
    return _customerServiceController;
}

/**极光推送消息监听 有消息时显示红点*/
- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messagePushed:) name:Notification_Message_Push object:nil];
}

- (void)messagePushed:(NSNotification *)notification {
    //系统通知
    NSString *userId = [[Platform Instance] getkey:USER_ID];
    NSString *notificationId = [[Platform Instance] getkey:NOFITICATION_ID];
    NSString *key = [NSString stringWithFormat:@"%@ %@ %@", SYSTEM_NOFITICATION, userId, notificationId];

    if ([[[Platform Instance] getkey:STOCK_WARNNING] isEqualToString:@"1"] || [[[Platform Instance] getkey:OVERDUE_ALERT] isEqualToString:@"1"] || [[[Platform Instance] getkey:NOTICE_SMS] isEqualToString:@"1"] || [[[Platform Instance] getkey:NOTICE_SYSTEM] isEqualToString:@"1"] || ([NSString isNotBlank:key] && [[[Platform Instance] getkey:key] isEqualToString:@"1"])) {
        self.img_notice.hidden = NO;
    } else {
        self.img_notice.hidden = YES;
    }
    if ([NSString isNotBlank:key] && [[[Platform Instance] getkey:key] isEqualToString:@"1"] ) {
        self.isNewSms = YES;
    } else {
        self.isNewSms = NO;
    }
    [self configSubviewModules];
}


// 记录变换登陆用户需要删除的scrollow的子views
- (NSMutableArray *)scrollViewSubViews {
    if (_scrollViewSubViews == nil) {
        _scrollViewSubViews = [NSMutableArray array];
    }
    return _scrollViewSubViews;
}

- (void)addLoginViewController
{
    LoginViewController *loginVc = [LoginViewController controllerFromStroryboard:@"Other" storyboardId:nil];
    loginVc.delegate = self;
    [self addChildViewController:loginVc];
    [self.view addSubview:loginVc.view];
    self.loginVc = loginVc;
}

- (void)addHeaderRefresh{
    __weak typeof(self) wself = self;
    [self.scrollView ls_addHeaderWithCallback:^{
        [wself loadData];
        [wself loadSystemNotificationInfo];
    }];
}

#pragma mark -LoginViewDelegate-
- (void)loginViewWillDisAppear
{
    [self clearDatas];
    // 切换登录用户，需要重新刷新左边栏，主页面和右边栏登录用户信息
    [self.leftView reloadData];
    [self.rightView refreshUserInfo];
    
    [self loadThePaymentInfo];
    [self loadSystemNotificationInfo];
    [self loadWechatStatus];
    [self loadData];
    [self loadHelpVideoList];
}

#pragma mark - clear数据
- (void)clearDatas {
    self.incomeDatas = nil;
    //清空门店电子收款账户
    self.shopInfoVO = nil;
    //清空通知数据
    self.systemNotificationVo = nil;
    self.isNewSms = NO;
}


#pragma mark - 主界面(contentView)相关子view配置

- (void)cleanSubViews
{
    // 特殊情况(如切换用户)先重置页面，和数据源dailyRunMoudles，和backgoreunSetModules，
    //  因为数据源会根据当前登录的用户权限等发生变化，所以界面也要每次进行调整
    [self.scrollViewSubViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.scrollViewSubViews removeAllObjects];
    self.dailyRunView = nil;
    self.backgroundSetView = nil;
    self.incomeView = nil;
}

// 配置主页面子模块
- (void)configSubviewModules {
    [self cleanSubViews];
    
    CGFloat topY = 0;
    UIView *view = nil;
    
    //添加顶部的用户和日期
    view = [self addUserInfoView:topY];
    topY += CGRectGetHeight(view.frame);
    [self.scrollViewSubViews addObject:view];
    
    if (self.systemNotificationVo != nil) {
        //添加系统通知
        view = [self addSystemNotificationView:topY];
        topY = topY + CGRectGetHeight(view.frame) + 2;
        [self.scrollViewSubViews addObject:view];
    }
   
    if ([NSString isNotBlank:[[Platform Instance] getkey:ROLE_ID]] && [ObjectUtil isNotEmpty:self.incomeDatas]) {
        
        //配置门店信息
        view = [self addIncomeView:self.incomeDatas top:topY];
        topY += CGRectGetHeight(view.frame)+5;
        [self.scrollViewSubViews addObject:view];
        
        //配置个人信息
        if (!([[Platform Instance] getShopMode] == 3 || ([[Platform Instance] getShopMode] == 1 && [[[Platform Instance] getkey:USER_NAME] isEqualToString:@"ADMIN"]) || [[Platform Instance] lockAct:ACTION_USER_INCOME_SEARCH])) {
            view = [self addShopSaleInfoView:topY];
            topY += CGRectGetHeight(view.frame);
            [self.scrollViewSubViews addObject:view];
        }
    }
    view = [self addDailyRunView:topY];
    topY += CGRectGetHeight(view.frame);
    [self.scrollViewSubViews addObject:view];
    UIView *view5 = [self addBackgroundSetView:topY];
    topY = topY + CGRectGetHeight(view5.frame) + 100;
    if ([ObjectUtil isNotNull:view5]) {
        [self.scrollViewSubViews addObject:view5];
    }
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), topY);
}

// 顶部user信息和时间显示
- (ShopReatedManInfoView *)addUserInfoView:(CGFloat)topY
{
    NSString *employeeName = [[Platform Instance] getkey:EMPLOYEE_NAME];
    ShopReatedManInfoView *userInfoView = [ShopReatedManInfoView userInfoView:topY user:employeeName];
    [self.scrollView addSubview:userInfoView];
    return userInfoView;
}

#pragma mark 系统通知控件
- (LSSyetemNotificationView *)addSystemNotificationView:(CGFloat)topY {
    LSSyetemNotificationView *systemNotificationView = [LSSyetemNotificationView systemNotificationView:topY];
    [self.scrollView addSubview:systemNotificationView];
    systemNotificationView.imgNewsStatus.hidden = !self.isNewSms;
    systemNotificationView.lblTitle.text = [NSString stringWithFormat:@"通知：%@", self.systemNotificationVo.name];
    systemNotificationView.delegate = self;
    return systemNotificationView;
}

//系统通知点击事件
#pragma mark <LSSyetemNotificationViewDelegate> 
- (void)systemNotificationViewDidEndClick:(LSSyetemNotificationView *)systemNotification {
    LSSystemNotificationController *vc = [[LSSystemNotificationController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

// 导购员个人销售总业绩指南
- (ShopReatedManInfoView *)addShopSaleInfoView:(CGFloat)topY
{
    ShopReatedManInfoView *shopSaleInfoView = [ShopReatedManInfoView shopSaleInfoView:topY backBlock:^{
        // 跳转到导购员个人营业汇总界面
        BusinessDetailView *businessDetailView = [[BusinessDetailView alloc] initWithNibName:[SystemUtil getXibName:@"BusinessDetailView"] bundle:nil];
        businessDetailView.shopFlag = 2;
        [self.navigationController pushViewController:businessDetailView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }];
    [self.scrollView addSubview:shopSaleInfoView];
    return shopSaleInfoView;
}

// 配置门店营业信息 view
- (ShopIncomeView *)addIncomeView:(NSArray *)titles top:(CGFloat)topY
{
    // 添加当前收益显示view
    //判断有没有主页门店营业统计的权限 如果没有则门店上的数据-表示 且门店营业统计隐藏不能进入下一个页面
    BOOL isShow = ![[Platform Instance] lockAct:ACTION_INCOME_SEARCH];
    self.incomeView = [ShopIncomeView shopIncomeView:isShow top:topY displayItems:titles owner:self];
    [self.scrollView addSubview:self.incomeView];
    return self.incomeView;
}

// 日常运维模块
- (ModuleConfigView *)addDailyRunView:(CGFloat)topY
{
    ModuleConfigView *dailyView = [[ModuleConfigView alloc] init:ModuleDailyRun top:topY title:@"日常运营" owner:self shopInfoVo:self.shopInfoVO];
    [self.scrollView addSubview:dailyView];
    self.dailyRunView = dailyView;
    return dailyView;
    
}

// 后台设置
- (ModuleConfigView *)addBackgroundSetView:(CGFloat)topY
{
    ModuleConfigView *backgroundSetView = [[ModuleConfigView alloc] init:ModuleBackgroundSet top:topY title:@"基础数据" owner:self shopInfoVo:self.shopInfoVO];
    [self.scrollView addSubview:backgroundSetView];
    self.backgroundSetView = backgroundSetView;
    return backgroundSetView;
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // 登出
        [self signOut];
    }
}

#pragma mark - 登出
- (void)signOut {
    
    [self addLoginViewController];
    [self sobotChatSignOut];
    [self backHomePage];
    [self cleanSubViews];
    [self clearDatas];
}

// 云客服登出
- (void)sobotChatSignOut {
    
    // 云客服按钮放在最上面
    [self.view bringSubviewToFront:[self.customerServiceController valueForKey:@"customerServiceButton"]];
    [[TDFSobotChat shareInstance] removeCurrentAccount];
}

#pragma mark - 获取收入数据
/**加载营业数据
 *  应该在登录成功，获取用户信息成功后才主动去加载收入数据
 */
- (void)loadData {

    // 这里更新下店名
    self.navTitle.text = [[Platform Instance] getkey:SHOP_NAME];
    if ([NSString isBlank:[[Platform Instance] getkey:ROLE_ID]]) {
        [self.scrollView headerEndRefreshing];
        [self configSubviewModules];
        return;
    }
    __weak typeof(self) weakself = self;
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[[Platform Instance] getkey:ROLE_ID] forKey:@"roleId"];
    NSString* url = @"income/msg";
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        [weakself.scrollView headerEndRefreshing];
        weakself.incomeDatas = json[@"incomeVoList"];
        [weakself configSubviewModules];
    } errorHandler:^(id json) {
        [weakself.scrollView headerEndRefreshing];
        [AlertBox show:json];
        
    }];
}

#pragma mark - 获得系统通知
- (void)loadSystemNotificationInfo {
    //取得最新的一条记录
    __weak typeof(self) wself = self;
    NSString *url = @"get_sys_notification/v1/last_notification";
    [BaseService getRemoteLSOutDataWithUrl:url param:nil withMessage:nil show:NO CompletionHandler:^(id json) {
        if ([ObjectUtil isNotNull:json[@"data"]]) {
            NSMutableArray *list = [LSSystemNotificationVo mj_objectArrayWithKeyValuesArray:json[@"data"]];
            if (list.count > 0) {
                wself.systemNotificationVo = list[0];
                [[Platform Instance] saveKeyWithVal:NOFITICATION_ID withVal:wself.systemNotificationVo.id];
                NSString *userId = [[Platform Instance] getkey:USER_ID];
                NSString *notificationId = [[Platform Instance] getkey:NOFITICATION_ID];
                NSString *key = [NSString stringWithFormat:@"%@ %@ %@", SYSTEM_NOFITICATION, userId, notificationId];
                NSString *value = [[Platform Instance] getkey:key];
                if ([NSString isNotBlank:value]) {
                    if ([[[Platform Instance] getkey:key] isEqualToString:@"1"]) {
                        wself.isNewSms = YES;
                    } else {
                        wself.isNewSms = NO;
                    }
                } else {
                    [[Platform Instance] saveKeyWithVal:key withVal:@"1"];//1是新消息 0不是新消息
                    wself.isNewSms = YES;
                }
            }
        }
        //当有新消息时右上角有红点显示
        [wself messagePushed:nil];
        //下拉刷新时右边需要显示数字2个接口需要同步 因为2个接口的数据需要同时用到 不知道哪个先调用完毕
        [wself.rightView reloadData];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    //最新的消息条数
    url = @"get_sys_notification/v1/get_count";
    [BaseService getRemoteLSOutDataWithUrl:url param:nil withMessage:nil show:NO CompletionHandler:^(id json) {
        NSNumber *data = json[@"data"];
        [[Platform Instance] saveKeyWithVal:SYSTEM_NOFITICATION_NUM withVal:data];
        [wself.rightView reloadData];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark - menu
/* 关于view的transform属性在iOS7与iOS8之后的区别，参考http://www.tuicool.com/articles/qEZzIrA，
 * 所以这里为了兼容iOS7，Storyboard中本页面的布局采用autosizingMask
 */
- (void)addMeunLeftView
{
    self.leftView = [[LSMenuLeftView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W - kMarginValue, SCREEN_H)];
    self.leftView.hidden = YES;
    self.leftView.delegate = self;
    [self.view insertSubview:self.leftView aboveSubview:self.rightView];

}

- (void)addMenuRightView
{
    self.rightView = [MenuRightView menuRightView:self];
    self.rightView.frame = CGRectMake(kMarginValue, 0, SCREEN_W - kMarginValue, SCREEN_H);
    self.rightView.hidden = YES;
    [self.view insertSubview:self.rightView belowSubview:self.contentView];
}

// 尝试显示左边栏
- (IBAction)showStoreViewController:(UIButton *)sender {
    
    if (![self backHomePage]) {
        self.leftView.hidden = NO;
        self.scrollView.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.transform = CGAffineTransformMakeTranslation(kScreenWidth-kMarginValue, 0);
        }];
    }
}

// 尝试显示右边栏
- (IBAction)showMyViewController:(UIButton *)sender {
    
    if (![self backHomePage]) {
        self.rightView.hidden = NO;
        self.scrollView.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.transform = CGAffineTransformMakeTranslation(-(kScreenWidth-kMarginValue), 0);
        }];
    }
}

- (BOOL)backHomePage
{
    if (self.contentView.transform.tx != 0) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.leftView.hidden = YES;
            self.rightView.hidden = YES;
            self.scrollView.userInteractionEnabled = YES;
        }];
        
        return YES;
        
    }else return NO;
}

#pragma mark - 手势,回到主界面
- (void)addTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.contentView addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)gesture {
    if (!self.contentView.transform.tx)return;
    [self backHomePage];
}
#pragma mark - <LSMenuLeftViewDelegate>
- (void)menuLeftView:(LSMenuLeftView *)menuLeftView didSelectobj:(LSModuleModel *)obj {
    NSString *code = obj.code;
    UIViewController *vc = nil;
    if ([code isEqualToString:ACTION_SYS_CONFIG_SETTING]) {//系统参数
        vc = [[LSSystemParameterController alloc] init];
    } else if ([code isEqualToString:ACTION_SHOP_INFO]) {//店家信息
        if ([[Platform Instance] getShopMode]==1) {//单店店家信息
            vc = [[LSShopInfoSetController alloc] init];
        } else if ([[Platform Instance] getShopMode]==2) {//门店店家信息
            vc = [[LSChainShopInfoController alloc] init];
            LSChainShopInfoController *chainShopInfoView = (LSChainShopInfoController *)vc;
            chainShopInfoView.isLogin = YES;
            chainShopInfoView.action = ACTION_CONSTANTS_EDIT;
            chainShopInfoView.shopId = [[Platform Instance] getkey:SHOP_ID];
            chainShopInfoView.shopEntityId = [[Platform Instance] getkey:RELEVANCE_ENTITY_ID];
        } else {//机构信息
            vc = [[LSOrgInfoController alloc] init];
            LSOrgInfoController *orgInfoView = (LSOrgInfoController *)vc;
            orgInfoView.isLogin = YES;
            orgInfoView.action = ACTION_CONSTANTS_EDIT;
            orgInfoView.organizationId = [[Platform Instance] getkey:ORG_ID];
        }
    } else if ([code isEqualToString:ACTION_RECEIPT_SETTING]) { //小票设置
        vc = [[TicketSetViewController alloc] init];
    } else if ([code isEqualToString:ACTION_ORDER_MEMO]) {//客单备注
        vc = [[GuestNoteListView alloc] init];
    } else if ([code isEqualToString:ACTION_SMS_SET]) {//短信设置
        vc = [[SmsSetController alloc] init];
    }else if ([code isEqualToString:ACTION_CLEAN_DATA]) {//数据清理
        vc = [[LSDataClearController alloc] init];
    } else if ([code isEqualToString:ACTION_PAYMENT_TYPE]) {//支付方式
        vc = [[LSKindPayListController alloc] init];
    } else if ([code isEqualToString:ACTION_SETTLED_MALL]){//入驻商圈
        vc = [[EnterCircleListView alloc] init];
    } else if ([code isEqualToString:ACTION_SCREEN_ADVERTISING]) {//店内屏幕广告
        vc = [[LSScreenAdvertisingController alloc] init];
    } else if ([code isEqualToString:ACTION_HOMEPAGE_SET]){// 主页显示设置 -> 主页显示设置
        vc = [[MainPageShowView alloc] init];
    } else if ([code isEqualToString:ACTION_NOTICE_INFO]) {//发布公告
        vc = [[LSSmsMainListController alloc] init];
    }
    [self pushViewController:vc];
}
- (void)menuLeftView:(LSMenuLeftView *)menuLeftView didSelectType:(LSMenuLeftViewType)type {
    UIViewController *vc = [[UIViewController alloc] init];
    if (type == LSMenuLeftViewTypeHelpVideo) {//帮助视频
        vc = [[LSHelpVideoListController alloc] init];
    } else if (type == LSMenuLeftViewTypeCommonProblem) {//常见问题
        vc = [[LSCommonProblemTypeListController alloc] init];
    }
    [self pushViewController:vc];
}

#pragma mark - ModuleConfigViewDelegate
// 代理方法统一处理 backgroundSetView 和 dailyView 中模块点击事件
- (void)moduleConfigView:(ModuleConfigView *)view action:(NSString *)code actionName:(NSString *)item
{
    // 主界面模块权限控制
    BOOL isLockFlag=[[Platform Instance] lockAct:code];
    if (isLockFlag) {
        [AlertBox show:[NSString stringWithFormat:@"您没有[%@]的权限",item]];
        return;
    }
    
    if ([view isEqual:self.dailyRunView]) {
        
        if ([code isEqualToString:PAD_PAYMENT]) {
            
            // 电子收款账户 -> 电子收款账户
            //连锁模式，只有总部admin用户登录时才显示电子收款账户;门店用户需要显示“电子收款明细”模块
            if ( [[Platform Instance] isTopOrg] || [[Platform Instance] getShopMode] != 3){
                UIViewController *vc = nil;
                vc = [[PaymentView alloc] init];
                PaymentView *payView = (PaymentView *)vc;
                if (self.shopInfoVO.displayWxPay == 1 && self.shopInfoVO.displayAlipay != 1 && self.shopInfoVO.displayQQ != 1) {
                    [payView initDataView:@"微信" isShowAccount:YES];
                } else if (self.shopInfoVO.displayWxPay != 1 && self.shopInfoVO.displayAlipay == 1 && self.shopInfoVO.displayQQ != 1) {
                    [payView initDataView:@"支付宝" isShowAccount:YES];
                } else if (self.shopInfoVO.displayWxPay != 1 && self.shopInfoVO.displayAlipay != 1 && self.shopInfoVO.displayQQ == 1) {
                    [payView initDataView:@"QQ钱包" isShowAccount:YES];
                } else {
                    vc = [[PaymentTypeView alloc] init];
                }
                [self.navigationController pushViewController:vc animated:NO];
            }
        }else if ([code isEqualToString:PAD_MEMBER]){
            
            // 会员 -> 会员管理
            LSMemberModule *memberModule = [[LSMemberModule alloc] init];
            [self.navigationController pushViewController:memberModule animated:NO];
            
        }else if ([code isEqualToString:PAD_MARKET]){
            
            // 营销 -> 营销管理
            LSMarketModuleController *vc = [[LSMarketModuleController alloc] init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }else if ([code isEqualToString:PAD_REPORT]){
            
            // 报表 -> 报表中心
            LSReportModuleController *reportModule =  [[LSReportModuleController alloc] init];
            [self.navigationController pushViewController:reportModule animated:NO];
            
        }else if ([code isEqualToString:PAD_WECHAT]){
            
            // 微店 -> 微店管理
            LSWechatModuleController *wechatModule = [[LSWechatModuleController alloc] init];
            [self.navigationController pushViewController:wechatModule animated:NO];
            
        }else if ([code isEqualToString:PAD_COMMENT]){
            
            // 顾客评价 -> 顾客评价
            LSCommentModuleController *vc = [[LSCommentModuleController alloc] init];
            [self.navigationController pushViewController:vc animated:NO];
        }else if ([code isEqualToString:PAD_DISTRIBUTE]){
            
        }
        
    }else if ([view isEqual:self.backgroundSetView]){
       if ([code isEqualToString:PAD_GOODS]){
            
            // 商品 -> 商品管理
            LSGoodsModuleController *goodsModule = [[LSGoodsModuleController alloc] init];
            [self.navigationController pushViewController:goodsModule animated:NO];
            
        }else if ([code isEqualToString:PAD_EMPLOYEE]){
            
            // 员工 -> 员工管理
            LSEmployeeModuleController *employeeModule = [[LSEmployeeModuleController alloc] init];
            [self.navigationController pushViewController:employeeModule animated:NO];
            
        }else if ([code isEqualToString:PAD_SCANCODE]){
            
            // 扫码结账 -> 扫码收款
            ScanPayView *scanPayView = [[ScanPayView alloc] init];
            [self.navigationController pushViewController:scanPayView animated:NO];
        }else if ([code isEqualToString:MODULE_MATERIAL_FLOW]){
            
            // 出入库 -> 出入库管理
            LSLogisticModuleController *logisticModule = [[LSLogisticModuleController alloc] init];
            [self.navigationController pushViewController:logisticModule animated:NO];
            
        }else if ([code isEqualToString:MODULE_STOCK]){
            
            // 库存 -> 库存管理
            LSStockModuleController *stockModule = [[LSStockModuleController alloc] init];
            [self.navigationController pushViewController:stockModule animated:NO];
            
        }
    }
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}


#pragma mark - ShopIncomeViewDelegate
-(void)showShopIncomeView{
    BusinessDetailView *businessDetailView = [[BusinessDetailView alloc] initWithNibName:[SystemUtil getXibName:@"BusinessDetailView"] bundle:nil];
    businessDetailView.shopFlag = 1;
    [self.navigationController pushViewController:businessDetailView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

#pragma mark - 左右侧边栏代理，处理跳转 -

// MenuRightView Delegate
- (void)rightMenu:(MenuRightView *)leftView selectType:(MRSelectItemType)type
{
    UIViewController *vc = nil;
    if (type == MRChangePassword) {
        // 修改密码
        vc = [[UserEditPassView alloc] init];
        __weak typeof(self) weakSelf = self;
        [(UserEditPassView *)vc loadData:[[Platform Instance] getkey:USER_ID] userName:[[Platform Instance] getkey:USER_NAME] callBack:^{
            [weakSelf signOut];
        }];
    }else if (type == MRChangeBackgroundPhoto){
        
        // 更换背景图片
        vc = (BgViewController *)[BgViewController controllerFromStroryboard:@"Other" storyboardId:nil];
    }else if (type == MRSystemNotification){
        // 系统通知
        vc = [[LSSystemNotificationController alloc] init];
    }else if (type == MRMessageCenter){
        // 消息中心
        [[Platform Instance] saveKeyWithVal:NOTICE_SMS withVal:@"0"];
        vc = (MessageCenterListView *)[MessageCenterListView controllerFromStroryboard:@"Other" storyboardId:nil];
    }else if (type == MRAbout){
        // 关于
        vc = (AboutInfoView *)[AboutInfoView controllerFromStroryboard:@"Other" storyboardId:nil];
    }else if (type == MRSignOut){
        // 退出
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认要退出吗？退出登录不会删除任何数据，重新登录后可继续使用。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert1.tag=1;
        [alert1 show];
        return;
        
    }
    [self pushViewController:vc];
}
#pragma mark - 更改当前window中控制器的背景图片

- (void)changeBackgroundImage
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIImage *image = [Platform getBgImage];
    self.contentViewBgImgv.image = image;
    appDelegate.bgImageView.image = image;
}

#pragma mark - 获取微店状态及扫码支付状态
- (void)loadWechatStatus {
    //获取微店状态
    NSString *url = @"microShop/selectStauts";
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:NO CompletionHandler:^(id json) {
        [[Platform Instance] setMicroShopStatus:[[json objectForKey:@"status"] shortValue]];
        [wself configSubviewModules];
    } errorHandler:^(id json) {
        [[Platform Instance] setMicroShopStatus:0];
        [AlertBox show:json];
    }];
     //获取扫码支付状态
    url = @"settledMall/booleanSettled";
    [param removeAllObjects];
    [param setValue:[[Platform Instance] getkey:RELEVANCE_ENTITY_ID] forKey:@"entityId"];
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:NO CompletionHandler:^(id json) {
        [[Platform Instance] setScanPayStatus:[[json objectForKey:@"booleanSettled"] shortValue]];
        [wself configSubviewModules];
        //显示入驻商圈
        [wself.leftView reloadData];
    } errorHandler:^(id json) {
        [[Platform Instance] setScanPayStatus:0];
        [AlertBox show:json];
    }];
}

#pragma mark - 获得帮助视频列表
- (void)loadHelpVideoList {
    NSString *url = @"help/v1/vedio_types";
    [BaseService crossDomanRequestWithUrl:url param:nil withMessage:nil show:NO CompletionHandler:^(id json) {
        if ([ObjectUtil isNotNull:json[@"data"]]) {
            //获得帮助视频 为什么在这里获取 因为每个模块左下角有一个问号帮助 点击里面有一个视频链接 这个链接需要从这个接口获取
            [Platform Instance].helpVideoList = [LSVideoVo ls_objectArrayWithKeyValuesArray:json[@"data"]];
            
        }
        
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}
#pragma mark 查询门店电子收款账户
- (void)loadThePaymentInfo{
    NSString *shopEntityId = nil;
    if ([[Platform Instance] isTopOrg] || [[Platform Instance] getShopMode] == 1) {
        shopEntityId = [[Platform Instance] getkey:ENTITY_ID];
    } else if ([[Platform Instance] getShopMode] == 2) {
        shopEntityId = [[Platform Instance] getkey:RELEVANCE_ENTITY_ID];
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    __weak typeof(self) wself = self;
    if ([NSString isNotBlank:shopEntityId]) {
        //获取分账实体Id
        NSString *url = @"h5ShopPay/getByEntityId";
        [param setValue:shopEntityId forKey:@"entityId"];
        [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:NO CompletionHandler:^(id json) {
            NSString *shopEntiyId = json[@"shopEntityId"];
            [[Platform Instance] saveKeyWithVal:PAY_ENTITY_ID withVal:shopEntiyId];
            if ([NSString isNotBlank:shopEntiyId]) {
                [param removeAllObjects];
                [param setValue:shopEntiyId forKey:@"entity_id"];
                ///查询店铺(微信/支付宝)电子支付信息
                NSString *url = @"pay/online/v1/get_shop_status";
                //获取店家信息看有么有绑卡
                [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:NO CompletionHandler:^(id json) {
                    wself.shopInfoVO = [ShopInfoVO mj_objectWithKeyValues:json[@"data"]];
                    wself.shopInfoVO.displayQQ = 0;//隐藏QQ支付
                    [wself refreshView];
                } errorHandler:^(id json) {
                    [AlertBox show:json];
                }];
                
            }
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

#pragma mark 电子收款账户信息加载成功够重新刷新页面
- (void)refreshView {
    [self configSubviewModules];
    [self loadAlertInfoView];
}

#pragma mark - 门店电子收款账户不完成时提示
- (void)loadAlertInfoView {
    /** 账户状态：0，未进件；1，已进件；2，进件失败 */
    int autoStatus = 0;
    if ([ObjectUtil isNotNull:self.shopInfoVO.authStatus]) {
        autoStatus = self.shopInfoVO.authStatus.intValue;
    }
    if (self.shopInfoVO.displayWxPay == 1 || self.shopInfoVO.displayAlipay == 1 || self.shopInfoVO.displayQQ == 1)
    {
        if (([[Platform Instance] getShopMode] != 1 && (([[[Platform Instance] getkey:USER_NAME] isEqualToString:@"ADMIN"] &&
               [[Platform Instance] getMicroShopStatus] == 2) || ([[Platform Instance] getShopMode] == 2 &&
               ![[Platform Instance] lockAct:ACTION_BANK_BINDING]))) || ([[Platform Instance] getShopMode] == 1 &&
               [[[Platform Instance] getkey:USER_NAME] isEqualToString:@"ADMIN"])) {
                  if (autoStatus == 0)
                  {//账户未进件
                      LSInfoAlertController *vc = [[LSInfoAlertController alloc] init];
//                      LSInfoAlertVo *infoAlertVo = [LSInfoAlertVo infoAlertVo:@"请尽快绑定收款账户" content:@"绑定收款账户后才能收到电子支付的钱。另外，根据央行政策，若未绑定账户，电子支付将不能使用！" buttonTitle:@"立即绑定" imagePath:@"shop_bank_img_top"];
                      LSInfoAlertVo *infoAlertVo = [LSInfoAlertVo infoAlertVo:@"请尽快绑定收款账户" content:@"根据央行政策，若未绑定账户，电子支付将不能使用！您还未绑定收款账户，您的顾客将无法使用支付宝、微信等电子支付方式在收银台或微店进行支付！" buttonTitle:@"立即绑定" imagePath:@"shop_bank_img_top"];
                      infoAlertVo.tag = 1;
                      vc.datas = @[infoAlertVo];
                      vc.delegate = self;
                      [self.navigationController presentViewController:vc animated:YES completion:nil];

                  } else if (autoStatus == 2) {//进件失败
                      LSInfoAlertController *vc = [[LSInfoAlertController alloc] init];
                      LSInfoAlertVo *infoAlertVo = [LSInfoAlertVo infoAlertVo:@"收款账户有误，请修改" content:@"账户有误将不能收到电子支付的钱。另外，根据央行政策，若未绑定正确的账户，电子支付将不能使用！" buttonTitle:@"立即修改收款账户" imagePath:@"shop_bank_warn_top"];
                      infoAlertVo.tag = 1;
                      vc.datas = @[infoAlertVo];
                      vc.delegate = self;
                      [self.navigationController presentViewController:vc animated:YES completion:nil];
                  }
              }
    }
}

#pragma mark - <LSInfoAlertDelegate> 
- (void)infoAlert:(LSInfoAlertVo *)infoAlertVo {
    if (infoAlertVo.tag == 1) {//前往电子收款账户模块
        if ([[Platform Instance] lockAct:ACTION_WEI_PAY_SUMMARIZE_SEARCH] && [[Platform Instance] lockAct:ACTION_WEI_PAY_SEARCH]) {
            [AlertBox show:@"您没有电子收款账户的权限"];
            return;
        }
        if ([[Platform Instance] getShopMode] != 1) {
            if ([[Platform Instance] lockAct:ACTION_BANK_BINDING]) {
                [AlertBox show:@"您没有完善电子收款账户的权限"];
                return;
            }
        }
        PaymentEditView *vc = [[PaymentEditView alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }
}

@end
