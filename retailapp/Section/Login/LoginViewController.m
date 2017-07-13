//
//  LoginViewController.m
//  retailapp
//
//  Created by taihangju on 16/6/11.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LoginViewController.h"
#import "OpenShopViewController.h"
#import "ReailAppDefine.h"
#import "XHAnimalUtil.h"

#import "ServiceFactory.h"
#import "KeyBoardUtil.h"
#import "AlertBox.h"
#import "UserVo.h"
#import "SignUtil.h"
#import "ShopInfoVO.h"
#import "JPUSHService.h"

#import "MessageBox.h"
#import "AddressPickerBox.h"
#import "OrderInputBox.h"
#import "TimePickerBox.h"
#import "DatePickerBox2.h"
#import "AlertBox.h"
#import "DateMonthPickerBox.h"
#import "OptionPickerBox.h"
#import "SymbolNumberInputBox.h"
#import "OpenShopSucessViewController.h"
#import "LSAddShopInfoController.h"
#import "GlobalRender.h"
#import "TDFSobotChat.h"
#if DEBUG || DAILY
#import "LSServerSelectionButton.h"
#endif
@interface LoginViewController ()<UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet UITextField   *shopCodeTextField;
@property (nonatomic, weak) IBOutlet UITextField   *userNameTextField;
@property (nonatomic, weak) IBOutlet UITextField   *passwordTextField;
@property (nonatomic, weak) IBOutlet UIButton      *loginButton;

/**
 *  版本号显示
 */
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;

@property (nonatomic, strong) UIButton         *btn;/*<测试等版本添加的选择服务器按钮>*/
@property (nonatomic, strong) NSString         *userPass;/*<用户密码>*/
//@property (nonatomic, strong) BigCompanionVo   *bigCompanionVo;/*<大伙伴>*/

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBgImageView];
    [self initView];
    [self initMainBox];
    [self configNotification];
    [self loadShop];
    
}



// 添加背景图片
- (void)addBgImageView {
    
    UIImage *image = [Platform getBgImage];
    UIImageView *imgv = [[UIImageView alloc] initWithImage:image];
    imgv.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:imgv];
    [self.view sendSubviewToBack:imgv];
}


// 初始化全局需要的控件
- (void)initMainBox
{
    static dispatch_once_t oncetoken ;
    dispatch_once(&oncetoken, ^{
        [AlertBox initAlertBox];
        [MessageBox initMessageBox];
        [TimePickerBox initTimePickerBox];
        [DatePickerBox initDatePickerBox];
        [DateMonthPickerBox initDatePickerBox];
        [OptionPickerBox initOptionPickerBox];
        //新增带－号的数字键盘
        [SymbolNumberInputBox initNumberInputBox];
        [DatePickerBox2 initDatePickerBox];
        [AddressPickerBox initAddressPickerBox];
        [OrderInputBox initOrderInputBox];
    });
}


#pragma mark - 初始化导航栏
-(void) initNavigate{
#if DAILY || DEBUG
    [LSServerSelectionButton addSelfToView:self.view];
#endif
}

#pragma mark - 初始化登录页面
- (void)initView{
    
    [self initNavigate];
    self.lblVersion.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.shopCodeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"店家编号" attributes:@{NSForegroundColorAttributeName: [ColorHelper getPlaceholderColor]}];
    self.userNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"员工用户名" attributes:@{NSForegroundColorAttributeName: [ColorHelper getPlaceholderColor]}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"员工密码" attributes:@{NSForegroundColorAttributeName: [ColorHelper getPlaceholderColor]}];
    
    [KeyBoardUtil initWithTarget:self.shopCodeTextField];
    [KeyBoardUtil initWithTarget:self.userNameTextField];
    [KeyBoardUtil initWithTarget:self.passwordTextField];
    
    [self.shopCodeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.userNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.loginButton setEnabled:NO];
}

#pragma mark - 二次登录时保存上次登录信息
- (void)loadShop
{
    NSString *shopCode=[[Platform Instance] getkey:@"code"];
    NSString *userName=[[Platform Instance] getkey:@"user"];
#if DEBUG
    NSString *passWord = [[Platform Instance] getkey:PASS];
#endif
    if ([NSString isNotBlank:shopCode]) {
        self.shopCodeTextField.text = shopCode;
        self.userNameTextField.text = userName;
#if DEBUG
        self.passwordTextField.text = passWord;
#endif
        [self.loginButton setEnabled:YES];
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    // 限制输入长度，最大20个字长
    if ([textField.text length] > 20) {
        textField.text = [textField.text substringToIndex:20];
    }
    
    if ([NSString isNotBlank:self.shopCodeTextField.text] && [NSString isNotBlank:self.userNameTextField.text] && [NSString isNotBlank:self.passwordTextField.text]) {
        
        [self.loginButton setEnabled:YES];
    }else{
        [self.loginButton setEnabled:NO];
    }
}

#pragma mark - 登录
- (IBAction)loginButtonClick:(id)sender {
    [self.view endEditing:YES];
    if ([NSString isBlank:self.shopCodeTextField.text]) {
        [AlertBox show:@"请选择店家编号，完成店家登录!"];
        return;
    }
    
    if ([NSString isBlank:self.userNameTextField.text]) {
        [AlertBox show:@"用户名不能为空!"];
        return;
    }
    
    if ([NSString isBlank:self.passwordTextField.text]) {
        [AlertBox show:@"密码不能为空!"];
        return;
    }

    _userPass = self.passwordTextField.text;
    
    NSString* url                = @"login";
    NSString *entityCode         = self.shopCodeTextField.text;
    NSString *username           = self.userNameTextField.text;
    NSString *password           = [self.passwordTextField.text uppercaseString];
    NSMutableDictionary* param   = [NSMutableDictionary dictionaryWithCapacity:3];
    [param setValue:entityCode forKey:@"entityCode"];
    [param setValue:username forKey:@"username"];
    [param setValue:[SignUtil convertPassword:password] forKey:@"password"];
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself responseSuccess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];

}

//登录成功
- (void)responseSuccess:(id)json
{
    [[Platform Instance] saveKeyWithVal:USER withVal:self.userNameTextField.text];
    [[Platform Instance] saveKeyWithVal:CODE withVal:self.shopCodeTextField.text];
    [[Platform Instance] saveKeyWithVal:PASS withVal:self.passwordTextField.text];
     UserVo* user = [UserVo convertToUser:[json objectForKey:@"user"]];
    [[Platform Instance] saveKeyWithVal:USER_NAME withVal:user.userName];
    [[Platform Instance] saveKeyWithVal:USER_ID withVal:user.userId];
    [[Platform Instance] saveKeyWithVal:USER_PASS withVal:_userPass];
    [[Platform Instance] saveKeyWithVal:EMPLOYEE_NAME withVal:user.name];
    if (![NSString isBlank:user.name]) {
        [[Platform Instance] saveKeyWithVal:ROLE_NAME withVal:user.roleName];
    }
    if (![NSString isBlank:user.roleId]) {
        [[Platform Instance] saveKeyWithVal:ROLE_ID withVal:user.roleId];
    }
    [[Platform Instance] saveKeyWithVal:STAFF_ID withVal:user.staffId];
    [[Platform Instance] saveKeyWithVal:USER_PIC withVal:user.picture];
    NSString* entityType = [json objectForKey:@"entityType"];
    NSDictionary* userActionMap = [json objectForKey:@"userActionMap"];
    [[Platform Instance] setActDic:userActionMap];
    
    //总部用户
    BOOL isTopOrg = [[json objectForKey:@"isTopOrg"] boolValue];
    [[Platform Instance] setIsTopOrg:isTopOrg];
    
    //服鞋 101  商超 102
    [[Platform Instance] saveKeyWithVal:SHOP_MODE withVal:[json objectForKey:@"industryKind"]];
    
//    NSString *shopId = nil;
    
    //单店
    if ([[json objectForKey:@"entityModel"] integerValue]==1) {
        [[Platform Instance] setShopMode:1];
        ShopVo* shop = [ShopVo convertToShop:[json objectForKey:@"shop"]];
        [[Platform Instance] saveKeyWithVal:PHONE withVal:shop.phone1];
        [[Platform Instance] saveKeyWithVal:SHOP_CODE withVal:shop.code];
        [[Platform Instance] saveKeyWithVal:SHOP_NAME withVal:shop.shopName];
        [[Platform Instance] saveKeyWithVal:SHOP_ID withVal:shop.shopId];
        [[Platform Instance] saveKeyWithVal:LOGO_ID withVal:shop.attachmentId];
        [[Platform Instance] saveKeyWithVal:RELEVANCE_ENTITY_ID withVal:shop.entityId];
//        shopId = shop.shopId;
        //连锁门店
    }else if ([[json objectForKey:@"entityModel"] integerValue]==2&&[entityType integerValue]==3) {
        [[Platform Instance] setShopMode:2];
        ShopVo* shop = [ShopVo convertToShop:[json objectForKey:@"shop"]];
        [[Platform Instance] saveKeyWithVal:PHONE withVal:shop.phone1];
        [[Platform Instance] saveKeyWithVal:SHOP_CODE withVal:shop.code];
        [[Platform Instance] saveKeyWithVal:SHOP_NAME withVal:shop.shopName];
        [[Platform Instance] saveKeyWithVal:SHOP_ID withVal:shop.shopId];
        [[Platform Instance] saveKeyWithVal:FATHER_ORG_ID withVal:[json objectForKey:@"fatherOrgId"]];
        [[Platform Instance] saveKeyWithVal:LOGO_ID withVal:shop.attachmentId];
        [[Platform Instance] saveKeyWithVal:RELEVANCE_ENTITY_ID withVal:shop.entityId];
//        shopId = shop.shopId;
        //连锁组织机构
    }else{
        [[Platform Instance] setShopMode:3];
        OrganizationVo* organization = [OrganizationVo convertToOrganization:[json objectForKey:@"organization"]];
        [[Platform Instance] saveKeyWithVal:PHONE withVal:organization.mobile];
        [[Platform Instance] saveKeyWithVal:SHOP_CODE withVal:organization.code];
        [[Platform Instance] saveKeyWithVal:SHOP_NAME withVal:organization.name];
        [[Platform Instance] saveKeyWithVal:SHOP_ID withVal:organization.organizationId];
        [[Platform Instance] saveKeyWithVal:ORG_ID withVal:organization.organizationId];
        [[Platform Instance] saveKeyWithVal:ORG_NAME withVal:organization.name];
        [[Platform Instance] saveKeyWithVal:BRAND_ID withVal:organization.brandId];
        [[Platform Instance] saveKeyWithVal:FATHER_ORG_ID withVal:[json objectForKey:@"fatherOrgId"]];
        [[Platform Instance] saveKeyWithVal:LOGO_ID withVal:organization.attachmentId];
        [[Platform Instance] saveKeyWithVal:RELEVANCE_ENTITY_ID withVal:organization.entityId];
//        shopId = organization.organizationId;
    }
    //上级的shopId
    NSString *parentId = [json objectForKey:@"parentId"];
    [[Platform Instance] saveKeyWithVal:PARENT_ID withVal:parentId];
    NSString *entityId = [json objectForKey:@"entityId"];
    
    [[Platform Instance] saveKeyWithVal:ENTITY_ID withVal:entityId];
    [self setAliasAndTagsWithUserId:[[Platform Instance] getkey:USER_ID] withShopId:[[Platform Instance] getkey:SHOP_ID]];

    [self configSobotUserInfo];
    
    //加载店铺信息
    id isNeedAddInfo = json[@"isNeedAddInfo"];
    if ([ObjectUtil isNotNull:isNeedAddInfo] && [isNeedAddInfo intValue] == 1) {//是否弹出补全店铺信息
        [self goToShopInfo];
    } else {
        [self showMainView];
    }
    
}


- (void)showMainView {
    
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    // 由于可能是多次登录的情况，通知根控制器根据当前用户情况调整显示页面
    if ([self.delegate respondsToSelector:@selector(loginViewWillDisAppear)]) {
        [self.delegate loginViewWillDisAppear];
    }
}

// 定义智齿Userinfo信息
- (void)configSobotUserInfo {
    
    NSString *uuidString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    TDFSobotUserInfoModel *userInfoModel = [[TDFSobotUserInfoModel alloc] init];
    userInfoModel.userID = [NSString stringWithFormat:@"retail-%@-%@",
                            [[Platform Instance] getkey:USER_ID], uuidString];
    userInfoModel.shopName = [[Platform Instance] getkey:SHOP_NAME]; // 店铺名称
    userInfoModel.shopCode = [[Platform Instance] getkey:CODE]; // 登录账号
    userInfoModel.userName = [[Platform Instance] getkey:USER]; // 店铺编号
    userInfoModel.phone = [[Platform Instance] getkey:PHONE]; // 手机号
//    userInfoModel.entityId = [[Platform Instance] getkey:ENTITY_ID]; // entityId
    [TDFSobotChat shareInstance].chatUserInfoModel = userInfoModel;
}


// 请求新的登录信息前，重置以前存储在本地的有关信息，不清除密码栏
- (void)clearSettingInfo
{
    [[Platform Instance] resetDefaults];
}

#pragma mark - JPUSHService设置标签和(或)别名
- (void)setAliasAndTagsWithUserId:(NSString *)userId withShopId:(NSString *)shopId
{
    NSSet *tags = [[NSSet alloc] initWithObjects:shopId, nil];
    NSString *alias = userId;
    [JPUSHService setTags:tags alias:alias fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        DLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
    }];
}

#pragma mark - 我要开店点击事件
- (IBAction)btnClick:(UIButton *)sender {
    
    OpenShopViewController *vc = [[OpenShopViewController alloc] init];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - OpenShopSucessViewController
- (void)openShopSucessViewControllerAtIndex:(OpenShopSucessState)openShopSucessState param:(NSDictionary *)param {
    self.shopCodeTextField.text = param[@"shopCode"];
    self.userNameTextField.text = param[@"name"];
    self.passwordTextField.text = param[@"password"];
    if (openShopSucessState == OpenShopSucessStateLogin) {
        [self loginButtonClick:nil];
    }
}

#pragma mark - 前往添加店家信息页面

- (void)goToShopInfo {
    LSAddShopInfoController *vc = [[LSAddShopInfoController alloc] init];
    [self pushViewController:vc];
}

//开店完成会发出kNotificationOpenShopSucessed
- (void)configNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openShopSucess:) name:kNotificationOpenShopSucessed object:nil];
}

- (void)openShopSucess:(NSNotification *)notification {
    [self showMainView];
}


@end
