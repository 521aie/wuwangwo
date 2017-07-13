//
//  UserEditPassView.m
//  retailapp
//
//  Created by hm on 15/8/4.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "UserEditPassView.h"
#import "SystemUtil.h"
#import "LSEditItemText.h"
#import "LSEditItemView.h"
#import "AlertBox.h"
#import "UserVo.h"
#import "UIHelper.h"
#import "SystemService.h"

@interface UserEditPassView ()

@property (nonatomic, strong) LSEditItemView *lblName;
@property (nonatomic, strong) LSEditItemText *txtOldPwd;
@property (nonatomic, strong) LSEditItemText *txtNewPwd;
@property (nonatomic, strong) LSEditItemText *txtNewPwdCon;
/**  */
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic,copy) NSString* userName;
@property (nonatomic,copy) NSString* userId;
@property (nonatomic,copy) CallBack callBack;
/** <#注释#> */
@property (nonatomic, strong) SystemService *systemServic;


@end
@implementation UserEditPassView


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTitle];
    [self setupScrollView];
    [self show:self.userName withId:self.userId];
    [self initNotification];
    [UIHelper refreshUI:self.scrollView];
}
- (void)setupTitle {
    [self configTitle:@"密码修改" leftPath:Head_ICON_BACK rightPath:nil];
    self.systemServic = [[SystemService alloc] init];
}

- (void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.scrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:self.scrollView];
    
    self.lblName = [LSEditItemView editItemView];
    [self.lblName initLabel:@"用户名" withHit:nil];
    [self.scrollView addSubview:self.lblName];
    
    self.txtOldPwd = [LSEditItemText editItemText];
    [self.txtOldPwd initLabel:@"旧密码" withHit:nil isrequest:YES type:UIKeyboardTypeASCIICapable];
    [self.txtOldPwd initMaxNum:10];
    [self.scrollView addSubview:self.txtOldPwd];
    
    self.txtNewPwd = [LSEditItemText editItemText];
    [self.scrollView addSubview:self.txtNewPwd];
    [self.txtNewPwd initLabel:@"新密码" withHit:nil isrequest:YES type:UIKeyboardTypeASCIICapable];
    [self.txtNewPwd initMaxNum:10];
    
    self.txtNewPwdCon = [LSEditItemText editItemText];
    [self.scrollView addSubview:self.txtNewPwdCon];
    [self.txtNewPwdCon initLabel:@"重复新密码" withHit:nil isrequest:YES type:UIKeyboardTypeASCIICapable];
    [self.txtNewPwdCon initMaxNum:10];
    self.txtOldPwd.txtVal.secureTextEntry=YES;
    self.txtNewPwd.txtVal.secureTextEntry=YES;
    self.txtNewPwdCon.txtVal.secureTextEntry=YES;
    
    [LSViewFactor addExplainText:self.scrollView text:@"提示：新密码最少6位，最多不超过10位" y:0];
    
    
    
}
#pragma mark - 设置页面参数及回调
- (void)loadData:(NSString*)userId userName:(NSString*)userName callBack:(CallBack)callBack
{
    self.userName = userName;
    self.userId = userId;
    self.callBack = callBack;
}



-(void) onNavigateEvent:(LSNavigationBarButtonDirect)event{
    
    if (event == LSNavigationBarButtonDirectLeft) {
        // 自定义导航栏左侧button, "取消"或者"返回"
        [self popViewController];
       
    }else if (event == LSNavigationBarButtonDirectRight){
        
        [self save];
    }
    
}


#pragma mark - 注册|移除UI变化通知
- (void)initNotification
{
    [UIHelper initNotification:self.scrollView event:Notification_UI_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_Change object:nil];
}

- (void)dataChange:(NSNotification*)notificaiton
{
    [self editTitle:[UIHelper currChange:self.scrollView] act:ACTION_CONSTANTS_EDIT];
}


#pragma mark - 显示页面视图
- (void)show:(NSString*)userName withId:(NSString*)userId
{
    [self.lblName initData:userName];
    [self.txtOldPwd initData:nil];
    [self.txtNewPwd initData:nil];
    [self.txtNewPwdCon initData:nil];
}

#pragma mark - 验证密码
-(BOOL)isValid{
    
    if ([NSString isBlank:[self.txtOldPwd getStrVal]]) {
        [AlertBox show:@"原密码不能为空，请输入!"];
        return NO;
    }
    
    if ([NSString isBlank:[self.txtNewPwd getStrVal]]) {
        [AlertBox show:@"新密码不能为空，请输入!"];
        return NO;
    }
    
    if ([NSString isBlank:[self.txtNewPwdCon getStrVal]]) {
        [AlertBox show:@"重复新密码不能为空，请输入!"];
        return NO;
    }
    
    if ([[self.txtOldPwd getStrVal] length]<6) {
        [AlertBox show:@"原密码不能少于6位,请重新输入!"];
        return NO;
    }
    if ([[self.txtNewPwd getStrVal] length]<6) {
        [AlertBox show:@"新密码不能少于6位,请重新输入!"];
        return NO;
    }
    if ([[self.txtNewPwdCon getStrVal] length]<6) {
        [AlertBox show:@"重复新密码不能少于6位,请重新输入!"];
        return NO;
    }
    if ([NSString isNotNumAndLetter:[self.txtNewPwd getStrVal]]) {
        [AlertBox show:@"输入的新密码不能有符号!"];
        return NO;
    }
    if ([NSString isNotNumAndLetter:[self.txtNewPwdCon getStrVal]]) {
        [AlertBox show:@"输入的的重复新密码不能有符号!"];
        return NO;
    }
    if (![[[self.txtNewPwd getStrVal] uppercaseString] isEqualToString:[[self.txtNewPwdCon getStrVal] uppercaseString]] ) {
        [AlertBox show:@"两次输入的密码不一致,请重新输入!"];
        return NO;
    }
    
    return YES;
}

#pragma mark - 更新密码
-(void)save{
    if (![self isValid]) {
        return;
    }
    NSString *oldPwd = [[self.txtOldPwd getStrVal] uppercaseString];
    NSString *newPwd = [[self.txtNewPwd getStrVal] uppercaseString];
    __strong UserEditPassView* strongSelf = self;
    [self.systemServic editUserPass:oldPwd withNewPassword:newPwd completionHandler:^(id json) {
        strongSelf.callBack();
        [strongSelf popViewController];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

@end
