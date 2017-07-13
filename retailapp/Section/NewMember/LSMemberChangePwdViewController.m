//
//  LSMemberChangePwdViewController.m
//  retailapp
//
//  Created by taihangju on 16/9/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberChangePwdViewController.h"
#import "NavigateTitle2.h"
#import "LSMemberInfoView.h"
#import "LSMemberAccessView.h"
#import "EditItemText.h"
#import "LSMemberInfoVo.h"
#import "LSAlertHelper.h"
#import "LSMemberConst.h"
#import "LSMemberTypeVo.h"
#import "LSMemberCardVo.h"
#import "LSEditItemRadio.h"

@interface LSMemberChangePwdViewController ()<INavigateEvent ,MBAccessViewDelegate ,LSMemberInfoViewDelegate ,EditItemTextDelegate,IEditItemRadioEvent>

@property (nonatomic ,strong) NavigateTitle2 *titleBox;/*<>*/
@property (nonatomic ,strong) LSMemberInfoView *infoView;/* <二维火会员信息*/
@property (nonatomic ,strong) LSMemberAccessView *cardsSummary;/* <会员卡栏*/
@property (nonatomic, strong) LSEditItemRadio *isChangPass;/* <是否修改卡密码>*/
@property (nonatomic ,strong) EditItemText *inputPassword;/* <输入卡 密码*/
@property (nonatomic ,strong) EditItemText *ensurePassword;/* <确认卡 密码*/
@property (nonatomic ,strong) UILabel *noticeLabel;/*<提示>*/
@property (nonatomic ,strong) UIButton *ensureButton;/*<<#说明#>>*/
@property (nonatomic ,strong) UIScrollView *scrollView;/*<<#说明#>>*/

@property (nonatomic ,strong) NSString *phoneNum;/*<查询手机号>*/
@property (nonatomic ,strong) LSMemberPackVo *memberPackVo;/*<会员相关信息vo>*/
@property (nonatomic ,strong) LSMemberCardVo *memberCardVo;/*<当前选择的 会员卡vo>*/
@property (nonatomic ,strong) NSArray *memberCardTypes;/*<卡类型>*/
@property (nonatomic ,strong) NSArray *memberCards;/*<已发了的会员卡>*/
@property (nonatomic ,strong) NSString *selectCardId;/*<指定初始化要操作的卡id>*/
@end

@implementation LSMemberChangePwdViewController

- (instancetype)init:(id)vo cardId:(NSString *)sId {
    
    self = [super init];
    if (self) {
        self.memberPackVo = (LSMemberPackVo *)vo;
        self.selectCardId = sId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self configSubviews];
    [self initNavigate];
    [self queryMemberInfo];
    [self configHelpButton:HELP_MEMBER_MEMBER_CHANGE_PASSWORD];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - NavigateTitle2 代理
//初始化导航栏
- (void)initNavigate {
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
    [self.titleBox initWithName:@"改卡密码" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:self.titleBox];
}

//导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        [self popToLatestViewController:kCATransitionFromLeft];
    }
}

- (void)configSubviews {
    
    if (!self.scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:
                           CGRectMake(0, 64.0, SCREEN_W, SCREEN_H - 64.0)];
        self.scrollView.backgroundColor  = [UIColor clearColor];
        [self.view addSubview:self.scrollView];
    }
    
    
    CGFloat topY = 0.0;
    // 会员信息
    if (!self.infoView) {
        self.infoView = [[LSMemberInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 86) delegate:self];
        [self.scrollView addSubview:self.infoView];
    }
    self.infoView.ls_top = topY;
    topY += self.infoView.ls_height;
    
    // 卡信息
    if (!self.cardsSummary) {
        self.cardsSummary = [LSMemberAccessView memberAccessView:MBAccessCardsInfo delegate:self];
        [self.scrollView addSubview:self.cardsSummary];
    }
    self.cardsSummary.ls_top = topY;
    topY += self.cardsSummary.ls_height;
    
    
    //是否修改卡密码开关
    if (!self.isChangPass) {
        self.isChangPass = [LSEditItemRadio editItemRadio];
        [self.isChangPass initLabel:@"" withVal:@"1"];
        [self.isChangPass initLabel:@"设置卡密码" withHit:@"若设置了卡密码，当收银员为顾客线下结账时需要输入卡密码。" delegate:self];
        [self.scrollView addSubview:self.isChangPass];
    }
    self.isChangPass.ls_top = topY;
    topY += self.isChangPass.ls_height;
    
    // 新密码
    if (!self.inputPassword) {
        self.inputPassword = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
        [self.inputPassword initLabel:@"▪︎ 新密码" withHit:nil isrequest:YES type:UIKeyboardTypeNumberPad];
        [self.inputPassword initMaxNum:kCardPasswordMaxNum];
        self.inputPassword.delegate = self;
        [self.inputPassword initData:@""];
        [self.scrollView addSubview:self.inputPassword];
        
    }
    self.inputPassword.ls_top = topY;
    topY += 48.0;
    
    // 确认新密码
    if (!self.ensurePassword) {
        self.ensurePassword = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
        [self.ensurePassword initLabel:@"▪︎ 确认新密码" withHit:nil isrequest:YES type:UIKeyboardTypeNumberPad];
        [self.ensurePassword initMaxNum:kCardPasswordMaxNum];
        self.ensurePassword.delegate = self;
        [self.ensurePassword initData:@""];
        [self.scrollView addSubview:self.ensurePassword];
    }
    self.ensurePassword.ls_top = topY;
    topY += 48.0;

//    // 提示文案
//    if (!self.noticeLabel) {
//        
//        self.noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_W-20.0, 55.0)];
//        self.noticeLabel.textColor = [ColorHelper getTipColor6];
//        self.noticeLabel.font = [UIFont systemFontOfSize:13.0];
//        self.noticeLabel.numberOfLines = 0;
//        self.noticeLabel.text = PasswordSetText;
//        [self.scrollView addSubview:self.noticeLabel];
//    }
//    self.noticeLabel.ls_top = topY;
//    topY = self.noticeLabel.ls_bottom;

    // button
    if (!self.ensureButton) {
        self.ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.ensureButton setTitle:@"确认" forState:0];
        [self.ensureButton setBackgroundColor:RGB(0, 170, 34)];// 屎绿色#00AA22
        [self.ensureButton.titleLabel setTextColor:RGB(192, 0, 0)];
        [self.ensureButton addTarget:self action:@selector(buttonTapAction) forControlEvents:UIControlEventTouchUpInside];
        self.ensureButton.frame = CGRectMake(12, 0, SCREEN_W - 24, 44);
        self.ensureButton.layer.cornerRadius = 4.0;
        [self.scrollView addSubview:self.ensureButton];
    }
    self.ensureButton.ls_top = topY + 5.0;
    topY += self.ensureButton.ls_height;
    
    // 非正常状态
    if (self.memberCardVo && self.memberCardVo.status.integerValue == 2) {
        self.isChangPass.hidden = YES;
        self.inputPassword.hidden = YES;
        self.ensurePassword.hidden = YES;
        self.ensureButton.hidden = YES;
//        self.noticeLabel.hidden = YES;
        topY = self.cardsSummary.ls_bottom;
    }
    else {
        self.isChangPass.hidden = NO;
        self.inputPassword.hidden = NO;
        self.ensurePassword.hidden = NO;
        self.ensureButton.hidden = NO;
//        self.noticeLabel.hidden = NO;
    }

    // 整体高度的基础上加上50，保持界面可滑动
    if (self.scrollView.ls_height < topY+50) {
        [self.scrollView setContentSize:CGSizeMake(SCREEN_W, topY + 50)];
    }
}

// 点击确定按钮
- (void)buttonTapAction {
    if ([self.isChangPass getVal]) {
        if ([self isVaild]) {
            [self changePassword];
        }
    }else{
        [self changePassword];
    }
}

-(void)onItemRadioClick:(id)obj
{

    if ([obj getVal]) {
        [self refreshUIWithType:1];
    }else{
        [self refreshUIWithType:0];
    }
}

-(void)refreshUIWithType:(int)type
{
    CGFloat topY = 0.0;
    if (type) {
        self.inputPassword.hidden = NO;
        self.ensurePassword.hidden = NO;
        topY = self.ensurePassword.ls_bottom;
    }else{
        self.inputPassword.hidden = YES;
        self.ensurePassword.hidden = YES;
        topY = self.isChangPass.ls_bottom;
    }
    self.ensureButton.ls_top = topY + 5.0;
    topY += self.ensureButton.ls_height;
    [self.scrollView setContentSize:CGSizeMake(SCREEN_W, topY + 50)];
}

//#pragma mark - 通知
//- (void)registerNotification {
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIDataChanged:) name:Notification_UI_Change object:nil];
//}
//
//- (void)UIDataChanged:(NSNotification *)not {
//    
//    EditItemText *text = (EditItemText *)not.object;
//    if ([NSString isNotBlank:text.currentVal]) {
//        
//        if ([text isEqual:self.inputPassword]) {
//            self.memberCardVo.pwdVo.passward = text.currentVal;
//        }
//        else if ([text isEqual:self.ensurePassword]) {
//            self.memberCardVo.pwdVo.surePassward = text.currentVal;
//        }
//    }
//}
//
//- (void)dealloc {
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

#pragma mark - 数据处理

- (void)fillData {
    
    // 会员信息
    if ([NSString isBlank:self.infoView.statusLabel.attributedText.string]) {
        
        [self.infoView fillMemberInfo:self.memberPackVo cards:self.memberCards cardTypes:self.memberCardTypes phone:self.phoneNum];
        [self.cardsSummary setCardDatas:self.memberCards initPage:[self.memberCards indexOfObject:self.memberCardVo]];
    }
//    [self.infoView fillMemberInfo:self.memberPackVo phone:self.phoneNum];
//    [self.cardsSummary setCardDatas:self.memberCards initPage:[self.memberCards indexOfObject:self.memberCardVo]];

    if (self.memberCardVo.status.integerValue == 1) {
        [self configSubviews];
    }
}

#pragma mark - delegate

/** MBAccessViewDelegate
 *  滑动选择了要操作的会员卡
*/
- (void)memberAccessView:(LSMemberAccessView *)view selectdPage:(id)obj {
    LSMemberCardVo *vo = (LSMemberCardVo *)obj;
    if ([self hasChanged] && ![vo isLost]) {
        [LSAlertHelper showAlert:@"换卡后将对另外一张卡进行操作！" block:nil];
    }

    self.memberCardVo = vo;
    [self configSubviews];
//    if ([NSString isNotBlank:vo.pwdVo.passward]) {
//        [self.inputPassword changeData:vo.pwdVo.passward];
//    }
//    else
//    {
//        [self.inputPassword initData:@""];
//    }
//    
//    if ([NSString isNotBlank:vo.pwdVo.surePassward]) {
//        [self.ensurePassword changeData:vo.pwdVo.surePassward];
//    }
//    else
//    {
//        [self.ensurePassword initData:@""];
//    }
}


// LSMemberInfoViewDelegate
- (void)memberInfoViewHeightChaged {
    [self configSubviews];
}


// EditItemTextDelegate
- (void)editItemTextEndEditing:(EditItemText *)editItem currentVal:(NSString *)val {
    
    if ([NSString isNotBlank:val]) {
        
        if ([editItem isEqual:self.inputPassword]) {
            self.memberCardVo.pwdVo.passward = val;
        }
        else if ([editItem isEqual:self.ensurePassword]) {
            self.memberCardVo.pwdVo.surePassward = val;
        }
    }
}

#pragma mark - 网络请求

// 查询会员基本信息
- (void)queryMemberInfo {
    
    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:3];
    [param setValue:entityId forKey:@"entityId"];
    [param setValue:[_memberPackVo getMemberPhoneNum] forKey:@"keyword"];
    [param setValue:@(NO) forKey:@"isOnlySearchMobile"];
    [param setValue:_memberPackVo.customerRegisterId forKey:@"twodfireMemberId"];
    [param setValue:_memberPackVo.customer.sId forKey:@"customerId"];
    
    [BaseService getRemoteLSOutDataWithUrl:@"card/v2/queryCustomerInfo" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([json[@"code"] boolValue]) {
            
            NSArray *customerList = json[@"data"][@"customerList"];
            if ([ObjectUtil isNotEmpty:customerList]) {
                
                if (customerList.count == 1) {
                    self.memberPackVo = [LSMemberPackVo getMemberPackVo:customerList[0]];
                    [self loadMemberCards];
                }
            }
        }
        
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
    
}


// 获取会员所有的会员卡信息
- (void)loadMemberCards {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:_memberPackVo.customerRegisterThirdPartyPojo.customerRegisterId forKey:@"customerRegisterId"];
    [param setValue:_memberPackVo.customer.sId forKey:@"customerId"];
    [param setValue:[[Platform Instance]  getkey:ENTITY_ID] forKey:@"entityId"];
    
    [BaseService getRemoteLSDataWithUrl:@"customer/v1/queryCustomerCard" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        //        if ([json[@"code"] boolValue]) {
        
        NSMutableArray *types = [[NSMutableArray alloc] init];
        NSMutableArray *cards = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in json[@"data"]) {
            
            LSMemberTypeVo *type = [LSMemberTypeVo getMemberTypeVo:dic[@"kindCard"]];
            LSMemberCardVo *card = [LSMemberCardVo getMemberCardVo:dic[@"card"]];
            card.cardTypeVo = type;
            card.kindCardName = type.name;
            card.filePath = type.filePath;
            card.mode = @(type.mode);
            card.pwdVo = [[LSMemberCardPwdVo alloc] init];
            card.pwdVo.cardId = card.sId;
            [types addObject:type];
            [cards addObject:card];
        }
        self.memberCardTypes = [types copy];
        self.memberCards = [cards copy];
        if ([NSString isNotBlank:self.selectCardId]) {
            [self.memberCards enumerateObjectsUsingBlock:^(LSMemberCardVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.sId isEqualToString:self.selectCardId]) {
                    self.memberCardVo = obj;
                    *stop = YES;
                }
            }];
        }
        else {
            self.memberCardVo = self.memberCards.firstObject;
        }
        [self fillData];
        //        }

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
    
//    AFHTTPRequestOperation *op = [BaseService getRemoteLSOperationWithparams:param withUrlStr:@"customer/queryCustomerCard" completionHandler:^(id json) {
//        
////        if ([json[@"code"] boolValue]) {
//        
//            NSMutableArray *types = [[NSMutableArray alloc] init];
//            NSMutableArray *cards = [[NSMutableArray alloc] init];
//            for (NSDictionary *dic in json[@"data"]) {
//                
//                LSMemberTypeVo *type = [LSMemberTypeVo getMemberTypeVo:dic[@"kindCard"]];
//                LSMemberCardVo *card = [LSMemberCardVo getMemberCardVo:dic[@"card"]];
//                card.cardTypeVo = type;
//                card.kindCardName = type.name;
//                card.filePath = type.filePath;
//                card.mode = @(type.mode);
//                card.pwdVo = [[LSMemberCardPwdVo alloc] init];
//                card.pwdVo.cardId = card.sId;
//                [types addObject:type];
//                [cards addObject:card];
//            }
//            self.memberCardTypes = [types copy];
//            self.memberCards = [cards copy];
//            if ([NSString isNotBlank:self.selectCardId]) {
//                [self.memberCards enumerateObjectsUsingBlock:^(LSMemberCardVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    if ([obj.sId isEqualToString:self.selectCardId]) {
//                        self.memberCardVo = obj;
//                        *stop = YES;
//                    }
//                }];
//            }
//            else {
//                self.memberCardVo = self.memberCards.firstObject;
//            }
//            [self fillData];
////        }
//        
//    } errorHandler:^(id json) {
//        [LSAlertHelper showAlert:json block:nil];
//    }];
//    [BaseService startOperationQueue:@[op] withMessage:@"" show:YES];
}

// 更改会员卡密码
- (void)changePassword {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
//    [param setValue:[[Platform Instance]  getkey:ENTITY_ID] forKey:@"entityId"];
    [param addEntriesFromDictionary:[self.memberCardVo.pwdVo dictionary]];
    
    [BaseService crossDomanRequestWithUrl:@"card/v2/reset_card_pwd" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        if ([json[@"code"] boolValue]) {
            [LSAlertHelper showStatus:@"修改成功" afterDeny:2 block:^{
                if (self.selectCardId) {
                    // 有selectCardId，成功后返回详情页。
                    [self popToLatestViewController:kCATransitionFromLeft];
                }
                else {
                   [self popToViewControllerNamed:@"LSMemberModule" popDirection:kCATransitionFromLeft];
                }
            }];
        }

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
//    AFHTTPRequestOperation *op = [BaseService getRemoteLSOutOperationWithparams:param withUrlStr:@"card/resetCardPassword" completionHandler:^(id json) {
//        
//        if ([json[@"code"] boolValue]) {
//            
//            [LSAlertHelper showStatus:@"修改成功" afterDeny:2 block:^{
//                if (self.selectCardId) {
//                    // 有selectCardId，成功后返回详情页。
//                    [self popToLatestViewController:kCATransitionFromLeft];
//                }
//                else {
//                    [self popToViewControllerNamed:@"LSMemberModule" popDirection:kCATransitionFromLeft];
//                }
//            }];
//        }
//    } errorHandler:^(id json) {
//        [LSAlertHelper showAlert:json block:nil];
//    }];
//    [BaseService startOperationQueue:@[op] withMessage:nil show:YES];
}

#pragma mark - relation check 

- (BOOL)isVaild {
        if ([NSString isNotBlank:[self.inputPassword getStrVal]] && [NSString isNotBlank:[self.ensurePassword getStrVal]]) {
            
            if ([self.inputPassword.txtVal.text length] > 6 || self.ensurePassword.txtVal.text.length > 6) {
                [LSAlertHelper showAlert:@"限制输入6位及其以下的数字！" block:nil];
                return NO;
            }
            else if (![[self.inputPassword getStrVal] isEqualToString:[self.ensurePassword getStrVal]]) {
                [LSAlertHelper showAlert:@"两次密码不一致！" block:nil];
                return NO;
            }
        }
        else {
            if ([NSString isBlank:[self.inputPassword getStrVal]]) {
                [LSAlertHelper showAlert:@"新密码不能为空！" block:nil];
                return NO;
            }
            if ([NSString isBlank:[self.ensurePassword getStrVal]]) {
                [LSAlertHelper showAlert:@"确认新密码不能为空！" block:nil];
                return NO;
            }
        }
    return YES;
}


- (BOOL)hasChanged {
    if (self.inputPassword.baseChangeStatus || self.ensurePassword.baseChangeStatus) {
        return YES;
    }
    return NO;
}
@end
