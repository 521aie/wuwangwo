//
//  LSMemberElectronicCardStep2ViewController.m
//  retailapp
//
//  Created by byAlex on 16/9/12.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberElectronicCardSendViewController.h"
#import "NavigateTitle2.h"
#import "LSMemberInfoView.h"
#import "UIView+Sizes.h"
#import "ItemTitle.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "EditItemRadio.h"
#import "SymbolNumberInputBox.h"
#import "DatePickerBox.h"
#import "OptionPickerBox.h"
#import "DateUtils.h"
#import "NameItemVO.h"
#import "LSAlertHelper.h"
#import "LSMemberCardVo.h"
#import "LSMemberTypeVo.h"
#import "NameItemVO.h"
#import "LSMemberInfoVo.h"
#import "CocoaSecurity.h"
#import "JSONKit.h"
#import "LSMemberConst.h"


#define MemberCardType  11
#define MemberSexType   12
#define MemberBirthday  13

@interface LSMemberElectronicCardSendViewController ()<INavigateEvent ,IEditItemListEvent ,IEditItemListEvent ,IEditItemRadioEvent ,SymbolNumberInputClient ,DatePickerClient ,OptionPickerClient ,LSMemberInfoViewDelegate>

@property (nonatomic ,strong) UIScrollView *scrollView;/* <*/
@property (nonatomic ,strong) NavigateTitle2 *titleBox;/*<>*/
@property (nonatomic ,strong) EditItemList *memberCardType;/*<选择要发的卡*/
@property (nonatomic ,strong) EditItemText *memberCarNum;/*<会员卡号*/
@property (nonatomic ,strong) EditItemRadio *memberCardSet;/*<会员卡密码*/
@property (nonatomic ,strong) EditItemText *inputPassword;/* <输入卡 密码*/
@property (nonatomic ,strong) EditItemText *ensurePassword;/* <确认卡 密码*/

@property (nonatomic ,strong) EditItemText *memberName;/* <会员名*/
@property (nonatomic ,strong) EditItemList *memberSex;/* <会员性别*/
@property (nonatomic ,strong) EditItemList *memberBirthday;/* <会员生日*/
@property (nonatomic ,strong) EditItemText *memberIDNumber;/* <身份证*/
@property (nonatomic ,strong) EditItemText *wechatNumber;/* <微信*/
@property (nonatomic ,strong) EditItemText *email;/* <邮箱*/
@property (nonatomic ,strong) EditItemText *contactAddress;/* <联系地址*/
@property (nonatomic ,strong) EditItemText *postNumber;/* <邮编*/
@property (nonatomic ,strong) EditItemText *jobType;/* <职业*/
@property (nonatomic ,strong) EditItemText *company;/* <公司*/
@property (nonatomic ,strong) EditItemText *duty;/* <职务*/
@property (nonatomic ,strong) EditItemText *carPlateNumber;/* <车牌号*/
@property (nonatomic ,strong) EditItemText *remark;/* <备注*/

@property (nonatomic ,strong) LSMemberInfoView *infoView;/* <二维火会员信息*/
@property (nonatomic ,strong) ItemTitle *memberInfo;/* <二维火会员信息 栏*/
@property (nonatomic ,strong) ItemTitle *sendCardInfo;/* <发卡信息 栏*/
@property (nonatomic ,strong) ItemTitle *shopMemberInfo;/* <店铺会员信息 栏*/
@property (nonatomic ,strong) NSString *phoneNum;/*<上一步输入的手机号码>*/
@property (nonatomic ,strong) NSArray *memberCards;/*<当前会员已有的会员卡>*/
@property (nonatomic ,strong) NSArray *memberCardTypes;/*<会员卡类型>*/
@property (nonatomic ,strong) NSArray *memberCardTypeItems;/*<NameItemVO:会员卡类型>*/
@property (nonatomic ,strong) LSMemberPackVo *memberPackVo;/*<会员信息请求返回数据单个dic包含的所有信息>*/
//@property (nonatomic ,assign) NSInteger smsNum;/*<剩余短信条数>*/
@property (nonatomic ,assign) BOOL isFromDetailPage;/*<是否由会员详情页->当前页面>*/
@end

@implementation LSMemberElectronicCardSendViewController

- (instancetype)init:(NSString *)phoneStr member:(id)vo fromPage:(BOOL)isFromDetailPage {
    
    self = [super init];
    if (self) {
        self.memberPackVo = (LSMemberPackVo *)vo;
        self.phoneNum = phoneStr;
        self.isFromDetailPage = isFromDetailPage;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self initNavigate];
    if ([ObjectUtil isNotNull:_memberPackVo]) {
         [self checkMemberInfo];
    } else {
        _memberPackVo = [[LSMemberPackVo alloc] init];
    }
    [self configScrollViewAndSubItems];
    [self querySmsNumAndKindCardAndQueryCard];
    [self configHelpButton:HELP_MEMBER_SEND_MEMBER_CARD];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - NavigateTitle2 代理
//初始化导航栏
- (void)initNavigate {
    
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    self.titleBox.frame = CGRectMake(0, 0, SCREEN_W, 64.0);
    [self.titleBox initWithName:@"发电子会员卡" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    self.titleBox.lblRight.text = @"发卡";
    [self.view addSubview:self.titleBox];
}

//导航栏点击事件
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT)
    {
        if ([self hasChanged]) {
            [LSAlertHelper showAlert:@"提示" message:@"内容有变更尚未保存，确定要退出吗？" cancle:@"取消" block:nil ensure:@"确定" block:^{
                [self popToLatestViewController:kCATransitionFromLeft];
            }];
        }
        else {
             [self popToLatestViewController:kCATransitionFromLeft];
        }
    }
    else
    {
        [self confirmSendCard];
    }
}

// 创建scrollView的子控件 , 或者根据开关控制界面布局
- (void)configScrollViewAndSubItems {

    if (!self.scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:
                           CGRectMake(0, self.titleBox.ls_bottom, SCREEN_W, SCREEN_H - self.titleBox.ls_bottom)];
        self.scrollView.backgroundColor  = [UIColor clearColor];
        [self.view addSubview:self.scrollView];
    }
    
    
    CGFloat topY = 0.0;
// 二维火会员信息
    if (!self.memberInfo) {
        self.memberInfo = [[ItemTitle alloc] init];
        [self.memberInfo awakeFromNib];
        self.memberInfo.lblName.text = @"会员信息";
        [self.scrollView addSubview:self.memberInfo];
    }
    topY += 48.0;
    
    if (!self.infoView) {
        self.infoView = [[LSMemberInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 100) delegate:self];
        [self.scrollView addSubview:self.infoView];
    }
    self.infoView.ls_top = topY;
    topY = topY + self.infoView.ls_height + 10;
    
    
// 发卡信息
    if (!self.sendCardInfo) {
        self.sendCardInfo = [[ItemTitle alloc] init];
        [self.sendCardInfo awakeFromNib];
        self.sendCardInfo.lblName.text = @"发卡信息";
        [self.scrollView addSubview:self.sendCardInfo];
    }
    self.sendCardInfo.ls_top = topY;
    topY += 48.0;
    
    // 选择要发的卡
    if (!self.memberCardType) {
        self.memberCardType = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
//        self.memberCardType.notificationType = Notification_UI_Change;
        [self.memberCardType initLabel:@"选择要发的卡" withHit:@"" isrequest:YES delegate:self];
        [self.memberCardType initData:@"" withVal:@""];
        [self.scrollView addSubview:self.memberCardType];
    }
    self.memberCardType.ls_top = topY;
    topY += 48.0;
    
    // 会员卡号
    if (!self.memberCarNum) {
        self.memberCarNum = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
//        self.memberCarNum.notificationType = Notification_UI_Change;
//        self.memberCarNum.delegate = self;
        self.memberCarNum.num = 32;
        [self.memberCarNum initLabel:@"会员卡号" withHit:@"" isrequest:NO type:UIKeyboardTypeASCIICapable];
        [self.memberCarNum initData:@""];
        [self.scrollView addSubview:self.memberCarNum];
    }
    self.memberCarNum.ls_top = topY;
    topY += 48.0;
    
    // 设置卡密码
    if (!self.memberCardSet) {
        self.memberCardSet = [[EditItemRadio alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
//        self.memberCardType.notificationType = Notification_UI_Change;
        [self.memberCardSet awakeFromNib];
        [self.memberCardSet initLabel:@"设置卡密码" withHit:PasswordSetText delegate:self];
        [self.memberCardSet initData:@"0"];
        [self.scrollView addSubview:self.memberCardSet];
    }
    self.memberCardSet.ls_top = topY;
    topY += self.memberCardSet.ls_height;
    
    if (self.memberCardSet.imgOn.hidden == NO) {
        // 输入卡密码
        if (!self.inputPassword) {
            self.inputPassword = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
            [self.inputPassword initMaxNum:kCardPasswordMaxNum];
//            self.inputPassword.notificationType = Notification_UI_Change;
//            self.inputPassword.delegate = self;
            [self.inputPassword initIndent:@"输入卡密码" withHit:@"" isrequest:YES type:UIKeyboardTypeNumberPad];
            [self.inputPassword initData:@""];
            [self.scrollView addSubview:self.inputPassword];
            
        }
        self.inputPassword.hidden = NO;
        self.inputPassword.ls_top = topY;
        topY += 48.0;
        
        // 确认卡密码
        if (!self.ensurePassword) {
            self.ensurePassword = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
            [self.ensurePassword initMaxNum:kCardPasswordMaxNum];
//            self.inputPassword.notificationType = Notification_UI_Change;
//            self.ensurePassword.delegate = self;
            self.ensurePassword.line.hidden = YES;
            [self.ensurePassword initIndent:@"确认卡密码" withHit:@"" isrequest:YES type:UIKeyboardTypeNumberPad];
            [self.ensurePassword initData:@""];
            [self.scrollView addSubview:self.ensurePassword];
        }
        self.ensurePassword.hidden = NO;
        self.ensurePassword.ls_top = topY;
        topY += 48.0;
    }
    else
    {
        [self.inputPassword setHidden:YES];
        [self.ensurePassword setHidden:YES];
    }
    

    
// 店铺会员信息
    if (!self.shopMemberInfo) {
        self.shopMemberInfo = [[ItemTitle alloc] init];
        [self.shopMemberInfo awakeFromNib];
        self.shopMemberInfo.lblName.text = @"会员补充信息";
        [self.scrollView addSubview:self.shopMemberInfo];
    }
    self.shopMemberInfo.ls_top = topY + 10;
    topY = topY + 48.0 + 10;
    
    // 会员名
    if (!self.memberName) {
        self.memberName = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
//        self.memberName.notificationType = Notification_UI_Change;
        [self.memberName initLabel:@"会员名" withHit:@"" isrequest:YES type:0];
        [self.memberName initData:@""];
        [self.scrollView addSubview:self.memberName];
    }
    self.memberName.ls_top = topY;
    topY += 48.0;
    
    // 性别
    if (!self.memberSex) {
        self.memberSex = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
//        self.memberSex.notificationType = Notification_UI_Change;
        [self.memberSex initLabel:@"性别" withHit:@"" isrequest:NO delegate:self];
        [self.memberSex initData:@"男" withVal:@"1"];
        [self.scrollView addSubview:self.memberSex];
    }
    self.memberSex.ls_top = topY;
    topY += 48.0;
    
    // 生日
    if (!self.memberBirthday) {
        self.memberBirthday = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
//        self.memberBirthday.notificationType = Notification_UI_Change;
        [self.memberBirthday initLabel:@"生日" withHit:@"" delegate:self];
        [self.memberBirthday initData:@"请选择" withVal:@"请选择"];
        [self.scrollView addSubview:self.memberBirthday];
    }
    self.memberBirthday.ls_top = topY;
    topY += 48.0;
    
    // 身份证
    if (!self.memberIDNumber) {
        self.memberIDNumber = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
//        self.memberIDNumber.notificationType = Notification_UI_Change;
//        self.memberIDNumber.delegate = self;
        self.memberIDNumber.num = 18;
        [self.memberIDNumber initLabel:@"身份证" withHit:@"" isrequest:NO type:UIKeyboardTypeNumbersAndPunctuation];
        [self.memberIDNumber initData:@""];
        [self.scrollView addSubview:self.memberIDNumber];
    }
    self.memberIDNumber.ls_top = topY;
    topY += 48.0;
    
    // 微信
    if (!self.wechatNumber) {
        self.wechatNumber = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
//        self.wechatNumber.notificationType = Notification_UI_Change;
        [self.wechatNumber initLabel:@"微信" withHit:@"" isrequest:NO type:0];
        [self.wechatNumber initData:@""];
        [self.scrollView addSubview:self.wechatNumber];
    }
    self.wechatNumber.ls_top = topY;
    topY += 48.0;
    
    // 邮箱
    if (!self.email) {
        self.email = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
//        self.email.notificationType = Notification_UI_Change;
//        self.email.delegate = self;
        [self.email initLabel:@"邮箱" withHit:@"" isrequest:NO type:UIKeyboardTypeEmailAddress];
        [self.email initData:@""];
        [self.scrollView addSubview:self.email];
    }
    self.email.ls_top = topY;
    topY += 48.0;
    
    // 联系地址
    if (!self.contactAddress) {
        self.contactAddress = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
//        self.contactAddress.notificationType = Notification_UI_Change;
        [self.contactAddress initLabel:@"联系地址" withHit:@"" isrequest:NO type:0];
        [self.contactAddress initData:@""];
        [self.scrollView addSubview:self.contactAddress];
    }
    self.contactAddress.ls_top = topY;
    topY += 48.0;
    
    // 邮编
    if (!self.postNumber) {
        self.postNumber = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
//        self.postNumber.notificationType = Notification_UI_Change;
        self.postNumber.num = 6;
        [self.postNumber initLabel:@"邮编" withHit:@"" isrequest:NO type:UIKeyboardTypeNumberPad];
        [self.postNumber initData:@""];
        [self.scrollView addSubview:self.postNumber];
    }
    self.postNumber.ls_top = topY;
    topY += 48.0;
    
    // 职业
    if (!self.jobType) {
        self.jobType = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
//        self.jobType.notificationType = Notification_UI_Change;
        [self.jobType initLabel:@"职业" withHit:@"" isrequest:NO type:0];
        [self.jobType initData:@""];
        [self.scrollView addSubview:self.jobType];
    }
    self.jobType.ls_top = topY;
    topY += 48.0;
    
    // 公司
    if (!self.company) {
        self.company = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
//        self.company.notificationType = Notification_UI_Change;
        [self.company initLabel:@"公司" withHit:@"" isrequest:NO type:0];
        [self.company initData:@""];
        [self.scrollView addSubview:self.company];
    }
    self.company.ls_top = topY;
    topY += 48.0;
    
    // 职务
    if (!self.duty) {
        self.duty = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
//        self.duty.notificationType = Notification_UI_Change;
        [self.duty initLabel:@"职务" withHit:@"" isrequest:NO type:0];
        [self.duty initData:@""];
        [self.scrollView addSubview:self.duty];
    }
    self.duty.ls_top = topY;
    topY += 48.0;
    
    // 车牌号
    if (!self.carPlateNumber) {
        self.carPlateNumber = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
//        self.carPlateNumber.notificationType = Notification_UI_Change;
//        self.carPlateNumber.delegate = self;
        self.carPlateNumber.num = 10;
        [self.carPlateNumber initLabel:@"车牌号" withHit:@"" isrequest:NO type:0];
        [self.carPlateNumber initData:@""];
        [self.scrollView addSubview:self.carPlateNumber];
    }
    self.carPlateNumber.ls_top = topY;
    topY += 48.0;
    
    // 备注
    if (!self.remark) {
        self.remark = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
//        self.remark.notificationType = Notification_UI_Change;
        self.remark.num = 100; // 最大输入字数
        [self.remark initLabel:@"备注" withHit:@"" isrequest:NO type:0];
        [self.remark initData:@""];
        [self.scrollView addSubview:self.remark];
    }
    self.remark.ls_top = topY;
    topY += 48.0;
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_W ,topY + 30);
}


#pragma mark - 协议方法

//LSMemberInfoViewDelegate
- (void)memberInfoViewHeightChaged {
    [self configScrollViewAndSubItems];
}

// OptionPickerClient
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    
    NameItemVO *vo = (NameItemVO *)selectObj;
    if (eventType == MemberCardType) {
        
        [self.memberCardType changeData:vo.itemName withVal:vo.itemId];
    }
    else if (eventType == MemberSexType)
    {
        [self.memberSex changeData:vo.itemName withVal:vo.itemId];
    }
    return YES;
}

// IEditItemListEvent
- (void)onItemListClick:(EditItemList *)obj {
    
    if ([obj isEqual:self.memberBirthday])
    {
        NSDate *pastDate = [NSDate distantPast];
        NSDate *nowDate = [NSDate date];
        NSDate *birthDate = [DateUtils getDate:[obj getStrVal] format:@"yyyy年MM月dd日"];
        if ([ObjectUtil isNull:birthDate]) {
            birthDate = [NSDate date];
        }
        [DatePickerBox show:obj.lblName.text date:birthDate client:self startDate:pastDate endDate:nowDate event:MemberBirthday];
    }
    else if ([obj isEqual:self.memberSex])
    {
        NSArray *sexs = @[[[NameItemVO alloc] initWithVal:@"男" andId:@"1"],
                          [[NameItemVO alloc] initWithVal:@"女" andId:@"2"]
        ];
        
        NSString *initString = obj.lblVal.text ? : @"男";
        if ([initString isEqualToString:@"女"])
        {
            [OptionPickerBox initData:sexs itemId:@"2"];
        }
        else
        {
            [OptionPickerBox initData:sexs itemId:@"1"];
        }
        [OptionPickerBox show:obj.lblName.text client:self event:MemberSexType];
    }
    else if ([obj isEqual:self.memberCardType]) {
        
        [OptionPickerBox initData:self.memberCardTypeItems itemId:self.memberCardType.currentVal];
        [OptionPickerBox show:obj.lblName.text client:self event:MemberCardType];
    }
}

// DatePickerClient
- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event {
    
    if (event == MemberBirthday) {
        NSString *dateString = [DateUtils formateShortChineseDate:date];
        [self.memberBirthday changeData:dateString withVal:dateString];
    }
    
    return YES;
}

// SymbolNumberInputClient
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    
}


// IEditItemRadioEvent
- (void)onItemRadioClick:(id)obj {
    
    if ([obj isEqual:self.memberCardSet]) {
        
        // 打开会关闭卡密码会引起布局变换，动态显示和隐藏密码设置项，注意上传密码要必须开启才能上传
        if (self.memberCardSet.imgOn.hidden) {
            [self.inputPassword initData:@""];
            [self.ensurePassword initData:@""];
        }
        // 重新布局ScrollView的子views
        [self configScrollViewAndSubItems];
    }
}

#pragma mark - 数据处理

// 根据请求得到的卡类型生成对应的NameItemVO 对象, 同时剔除已经拥有的卡类型
- (NSArray *)createCardTypeItems:(NSArray<LSMemberTypeVo *> *)array {
   
    if ([ObjectUtil isNotEmpty:array]) {
        
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:array.count];
        NSInteger maxFontNum = 16.0;
        for (LSMemberTypeVo *obj in array) {
            
            if (![self checkRepeatedMemberNum:obj.s_Id]) {
                NSString *string1 = obj.name;
                NSString *string2 = [NSString stringWithFormat:@" (%@)" ,[obj getModeStringShowRatio]];
                if (string1.length + string2.length > maxFontNum) {
                    string1 = [NSString stringWithFormat:@"%@..." ,[string1 substringToIndex:maxFontNum-string2.length-2]];
                }
                NameItemVO *vo = [[NameItemVO alloc] initWithVal:[NSString stringWithFormat:@"%@%@" , string1 ,string2] andId:obj.s_Id andSortCode:obj.mode];
                [items addObject:vo];
            }
        }
        return items;
    }
    return nil;
}


- (void)fillData {
    
    // 会员信息
    [self.infoView fillMemberInfo:self.memberPackVo cards:self.memberCards cardTypes:self.memberCardTypes phone:self.phoneNum];
    
    // 发卡信息
    NameItemVO *vo = self.memberCardTypeItems.firstObject;
    if (vo) {
        [self.memberCardType initData:vo.itemName withVal:vo.itemId];
    }

    // 店铺会员信息
    LSMemberInfoVo *customer = self.memberPackVo.customer;
    [self.memberName initData:customer.name ? : @""];
    if (customer.sex.integerValue == 1) {
        [self.memberSex initData:@"男" withVal:@"1"];
    }
    else if (customer.sex.integerValue == 2) {
        [self.memberSex initData:@"女" withVal:@"2"];
    }
    
    if (customer.birthday.longLongValue > 1000 && [NSString isNotBlank:customer.birthdayStr]) {
        NSString *birthdayString = [DateUtils formateChineseDate2:[NSDate dateWithTimeIntervalSince1970:customer.birthday.longLongValue/1000]];
        [self.memberBirthday initData:birthdayString withVal:birthdayString];
    }
    [self.memberIDNumber initData:customer.certificate ? : @""];
    [self.wechatNumber initData:customer.weixin ? : @""];
    [self.email initData:customer.email ? : @""];
    [self.contactAddress initData:customer.address ? : @""];
    [self.postNumber initData:customer.zipcode ? : @""];
    [self.jobType initData:customer.job ? : @""];
    [self.company initData:customer.company ? : @""];
    [self.duty initData:customer.pos ? : @""];
    [self.carPlateNumber initData:customer.carNo ? : @""];
    [self.remark initData:customer.memo ? : @""];
}

- (NSMutableDictionary *)createUploadData {
    
    NSString *userId = [[Platform Instance] getkey:USER_ID];
    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    NSString *shopName = [[Platform Instance] getkey:SHOP_NAME];
    NSString *userName = [[Platform Instance] getkey:EMPLOYEE_NAME];
    
    // 发卡信息, 只有设置卡密码打开，才会上传卡密码
    NSMutableDictionary *cardInfoDic = [[NSMutableDictionary alloc] init];
    if (!self.memberCardSet.imgOn.hidden) {
        NSString *passWord = self.inputPassword.txtVal.text;
        [cardInfoDic setValue:[[CocoaSecurity md5:passWord] hexLower] forKey:@"pwd"];
    }
    
    // 会员卡号
    NSString *codeNum = [NSString isNotBlank:self.memberCarNum.currentVal] ? self.memberCarNum.currentVal : @"";
    [cardInfoDic setValue:codeNum forKey:@"code"];
    [cardInfoDic setValue:codeNum forKey:@"innerCode"];
//    [cardInfoDic setValue:@"" forKey:@"id"];
    NSTimeInterval timeBetween = [[NSDate date] timeIntervalSince1970] *1000;
    [cardInfoDic setValue:[NSNumber numberWithLong:timeBetween] forKey:@"activeDate"];
    [cardInfoDic setValue:self.memberCardType.currentVal forKey:@"kindCardId"];
    [cardInfoDic setValue:entityId forKey:@"shopEntityId"];
    [cardInfoDic setValue:userName forKey:@"operatorName"];
    [cardInfoDic setValue:userId forKey:@"operatorId"];
    [cardInfoDic setValue:shopName forKey:@"shopEntityName"];
    
    // 店铺会员信息
    NSMutableDictionary *memberInfoDic = [[NSMutableDictionary alloc] init];
    [memberInfoDic setValue:self.phoneNum forKey:@"mobile"];
    [memberInfoDic setValue:entityId forKey:@"entityId"];
    
    if ([NSString isNotBlank:self.memberPackVo.customer.sId]) {
         [memberInfoDic setValue:self.memberPackVo.customer.sId forKey:@"id"];
    }
   
    [memberInfoDic setValue:[self.memberName getStrVal] forKey:@"name"]; // 会员名
    [memberInfoDic setValue:[self.jobType getStrVal] forKey:@"job"]; // 职业
    [memberInfoDic setValue:[self.memberIDNumber getStrVal] forKey:@"certificate"]; // 身份证
    [memberInfoDic setValue:[self.email getStrVal] forKey:@"email"]; // 邮箱
    [memberInfoDic setValue:self.memberSex.currentVal.convertToNumber forKey:@"sex"]; // 性别
    [memberInfoDic setValue:self.memberSex.lblVal.text forKey:@"sexStr"];
    [memberInfoDic setValue:[self.remark getStrVal] forKey:@"memo"]; // 备注
    if ([ObjectUtil isNotEmpty:self.memberPackVo.customer.createTime]) {
        [memberInfoDic setValue:[NSString stringWithFormat:@"%@",self.memberPackVo.customer.createTime] forKey:@"createTime"];
    }
    
    if (self.memberBirthday.baseChangeStatus && [NSString isNotBlank:[self.memberBirthday getStrVal]]) {
        NSDate *date = [DateUtils getDate:[self.memberBirthday getStrVal] format:@"yyyy年MM月dd日"];
        [memberInfoDic setValue:[NSNumber numberWithLongLong:([date timeIntervalSince1970]*1000)] forKey:@"birthday"];
    }
    [memberInfoDic setValue:[self.wechatNumber getStrVal] forKey:@"weixin"];   // 微信
    [memberInfoDic setValue:[self.contactAddress getStrVal] forKey:@"address"]; // 联系地址
    [memberInfoDic setValue:[self.postNumber getStrVal] forKey:@"zipcode"]; // 邮编
    [memberInfoDic setValue:[self.duty getStrVal] forKey:@"pos"];    // 职务
    [memberInfoDic setValue:[self.carPlateNumber getStrVal] forKey:@"carNo"];   // 车牌号
    [memberInfoDic setValue:[self.company getStrVal] forKey:@"company"];   // 公司
   
    // moneyFlow
//    NSDictionary *moneyFlow = @{@"entityId":entityId};
    
    NSMutableDictionary *flowDic = [[NSMutableDictionary alloc] init];
    [flowDic setValue:memberInfoDic forKey:@"customer"];
    [flowDic setValue:cardInfoDic forKey:@"card"];
//    [flowDic setValue:moneyFlow forKey:@"moneyFlow"];
//    [flowDic setValue:@0 forKey:@"num"];
    NSString *flowStr = [flowDic JSONString];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:flowStr forKey:@"cardAndMoneyFlowVoStr"];
    [param setValue:userId forKey:@"operatorId"];
    [param setValue:entityId forKey:@"entityId"];
    return param;
}

#pragma mark - 网络请求

// 查询短信条数，卡类型，和会员已有会员卡
- (void)querySmsNumAndKindCardAndQueryCard {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    [param setValue:entityId forKey:@"entityId"];
    [param setValue:self.phoneNum forKey:@"mobile"];
    [param setValue:@(NO) forKey:@"isNeedAll"];
    
    [BaseService getRemoteLSDataWithUrl:@"customer/v1/querySmsNumAndKindCardAndQueryCard" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
        NSDictionary *dic = json[@"data"];
        if ([ObjectUtil isNotEmpty:dic]) {
            self.memberCards = [LSMemberCardVo getMemberCardVoList:dic[@"cardQueryVo"][@"cards"]];
            self.memberCardTypes = [LSMemberTypeVo getMemberTypeVos:dic[@"kindCardList"]];
            self.memberCardTypeItems = [self createCardTypeItems:self.memberCardTypes];
            [self fillData];
        }
        
        if ([self checkSendCard]) {
        }

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}


// 查询会员基本信息
- (void)checkMemberInfo {
    
    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    NSString *phone = [_memberPackVo getMemberPhoneNum];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:phone forKey:@"keyword"];
    [param setValue:entityId forKey:@"entityId"];
    [param setValue:@(YES) forKey:@"isOnlySearchMobile"];
    [param setValue:_memberPackVo.customerId forKey:@"customerId"];
    [param setValue:_memberPackVo.customerRegisterId forKey:@"twodfireMemberId"];
    
    [BaseService getRemoteLSOutDataWithUrl:@"card/v2/queryCustomerInfo" param:[param mutableCopy] withMessage:@"" show:YES CompletionHandler:^(id json) {
        NSArray *array = [LSMemberPackVo getMemberPackVoList:json[@"data"][@"customerList"]];
        if ([ObjectUtil isNotEmpty:array]) {
            self.memberPackVo = array.firstObject;
        }
        else {
            self.memberPackVo = [[LSMemberPackVo alloc] init];
        }
        [self fillData];

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json block:nil];
    }];
}

// 确认发卡
- (void)confirmSendCard {
    
    if ([self isValid]) {
        
        NSMutableDictionary *param = [self createUploadData];
        [BaseService getRemoteLSDataWithUrl:@"customer/v1/saveCard" param:param withMessage:@"" show:YES CompletionHandler:^(id json) {
            [LSAlertHelper showStatus:@" 发卡成功！" afterDeny:2 block:^{
                
                if ([json[@"returnCode"] isEqualToString:@"success"]) {
                    if (self.isFromDetailPage) {
                        [self popToLatestViewController:kCATransitionFromLeft];
                    }
                    else {
                        [self popToViewControllerNamed:@"LSMemberModule" popDirection:kCATransitionFromLeft];
                    }
                }
            }];
        } errorHandler:^(id json) {
            [LSAlertHelper showAlert:json block:nil];
        }];
    }
}

#pragma mark - 相关验证

- (BOOL)hasChanged {
    
    if (self.memberCardType.baseChangeStatus || self.memberCarNum.baseChangeStatus || self.memberCardSet.baseChangeStatus || self.inputPassword.baseChangeStatus || self.ensurePassword.baseChangeStatus || self.memberName.baseChangeStatus || self.memberSex.baseChangeStatus || self.memberBirthday.baseChangeStatus || self.memberIDNumber.baseChangeStatus || self.wechatNumber.baseChangeStatus || self.contactAddress.baseChangeStatus || self.email.baseChangeStatus || self.postNumber.baseChangeStatus || self.jobType.baseChangeStatus || self.company.baseChangeStatus || self.duty.baseChangeStatus || self.carPlateNumber.baseChangeStatus || self.remark.baseChangeStatus) {
        return YES;
    }
    return NO;
}

- (BOOL)isValid {
    
    NSString *alertString = nil;
    // 会员名称check（必填项）
    if ([NSString isBlank:[self.memberName getStrVal]]) {
        [LSAlertHelper showAlert:@"会员名不能为空！" block:nil];
        return NO;
    }
    
    // 选择卡类型
    if ([NSString isBlank:[self.memberCardType getStrVal]]) {
        [LSAlertHelper showAlert:@"会员卡类型不能为空！" block:nil];
        return NO;
    }
    
    // 会员卡号check
    if ([NSString isNotBlank:[self.memberCarNum getStrVal]]) {
       
        if ([NSString isNotNumAndLetter:[self.memberCarNum getStrVal]]) {
            [LSAlertHelper showAlert:@"会员卡号必须由英文字母或数字组成，请重新输入！" block:nil];
            return NO;
        }
        else if ([self.memberCarNum getStrVal].length < 4) {
            [LSAlertHelper showAlert:@"会员卡号长度必须大于4！" block:nil];
            return NO;
        }
    }
    
    // 会员卡密码check
    if (self.memberCardSet.imgOn.hidden == NO) {
        
        if ([NSString isBlank:[self.inputPassword getStrVal]] || [NSString isBlank:[self.ensurePassword getStrVal]]) {
             alertString = @"请设置会员卡密码！";
        }
        else if ([self.inputPassword getStrVal].length > 6 || [self.ensurePassword getStrVal].length > 6 || ![NSString isValidNumber:[self.inputPassword getStrVal]] || ![NSString isValidNumber:[self.ensurePassword getStrVal]]) {
                alertString = @"限输入6位及以下的数字！";
        }
        else if (![[self.inputPassword getStrVal] isEqualToString:[self.ensurePassword getStrVal]]) {
           alertString = @"两次设置的密码不一致！";
        }
        
        if ([NSString isNotBlank:alertString]) {
             [LSAlertHelper showAlert:alertString block:nil];
             return NO;
        }
       
    }
    
    // 身份证号验证
    if ([NSString isNotBlank:[self.memberIDNumber getStrVal]]) {
        
        if (![NSString validateIDCardNumber:self.memberIDNumber.currentVal]) {
            [LSAlertHelper showAlert:@"请输入正确的身份证号！" block:nil];
            return NO;
        }
    }
    
    // 邮箱验证
    if ([NSString isNotBlank:[self.email getStrVal]]) {
        if (![NSString isValidateEmail:self.email.currentVal]) {
            
            [LSAlertHelper showAlert:@"请输入正确的邮箱！" block:nil];
            return NO;
        }
    }
    
//    // 车牌号验证
//    if ([NSString isNotBlank:[self.carPlateNumber getStrVal]] && [self.carPlateNumber getStrVal].length > 10) {
//        [LSAlertHelper showAlert:@"请输入正确的车牌号！" block:nil];
//        return NO;
//    }
//    
//    // 邮编验证
//    if ([NSString isNotBlank:[self.postNumber getStrVal]] && [self.postNumber getStrVal].length > 6) {
//        [LSAlertHelper showAlert:@"请输入正确的邮编！" block:nil];
//        return NO;
//    }
    
    return YES;
}

// 检查是否能够发卡
- (BOOL)checkSendCard {
    
    BOOL enableSendCard = YES;
    if ([ObjectUtil isEmpty:self.memberCardTypes]) {
        // 如果没有卡类型，或者改会员拥有了所有会员类型的会员卡则给出提示信息
        enableSendCard = NO;
    }
    else if ([ObjectUtil isEmpty:self.memberCardTypeItems]) {
        // 检查是否所有的卡类型已经被发完
        enableSendCard = NO;
    }
    if (!enableSendCard) {
        [LSAlertHelper showAlert:@"您还没有设置卡类型,请先设置卡类型!" block:nil];
    }
    return enableSendCard;
}

// 检查是否有相同的会员卡， 避免重复发同类型的会员卡
- (BOOL)checkRepeatedMemberNum:(NSString *)number {
    
    NSMutableArray *owntypes = [[NSMutableArray alloc] initWithCapacity:self.memberCards.count];
    for (LSMemberCardVo *card in self.memberCards) {
        if (card.kindCardId) {
            [owntypes addObject:card.kindCardId];
        }
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF IN %@" ,[owntypes copy]];
    return [predicate evaluateWithObject:number];
}

@end
