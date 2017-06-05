//
//  EmployeeEditView.m
//  retailapp
//
//  Created by qingmei on 15/9/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#define ITEM_TAG_INDATE         1
#define ITEM_TAG_BIRTHDAY       2
#define ITEM_TAG_ORGANIZATION   3
#define ITEM_TAG_ROLE           4
#define ITEM_TAG_SEX            5
#define ITEM_TAG_IDENTITYTYPE   6

#define ITEM_TAG_PORTAIT        14      //头像.
#define ITEM_TAG_CHANGE_PWD     15      //重置密码


#import "EmployeeEditView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ImageUtils.h"
#import "EmployeeService.h"
#import "EmployeeManageView.h"
#import "INavigateEvent.h"
#import "IEditItemListEvent.h"
#import "IEditItemImageEvent.h"
#import "DatePickerBox.h"
#import "OptionPickerBox.h"
#import "EditItemText2.h"
#import "UIHelper.h"
#import "LSEditItemText.h"
#import "LSEditItemTitle.h"
#import "LSEditItemList.h"
#import "EditItemImage2.h"
#import "EditItemCertId.h"
#import "ServiceFactory.h"
#import "NameItemVO.h"
#import "DateUtils.h"
#import "SignUtil.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "SelectOrgShopListView.h"
#import "EmployeeRender.h"
#import "LSImageVo.h"
#import "LSImageDataVo.h"
#import "ItemCertId.h"

@interface EmployeeEditView ()<IEditItemListEvent,IEditItemImageEvent,EditItemText2Delegate,DatePickerClient,OptionPickerClient,UITextFieldDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) UIScrollView     *scrollView;            //滚动栏
@property (strong, nonatomic) UIView           *container;             //滚动栏中子view容器

@property (strong, nonatomic) LSEditItemTitle        *itemTitleBase;         //基本设置title
@property (strong, nonatomic) LSEditItemText     *itemTxtName;           //姓名
@property (strong, nonatomic) LSEditItemList     *itemListOrganization;  //门店机构选择
@property (strong, nonatomic) LSEditItemText     *itemTxtStaffId;        //员工号
@property (strong, nonatomic) EditItemText2    *itemTxtPwd;            //密码
@property (strong, nonatomic) LSEditItemText *itemTxtUserName;        //用户名(连锁显示)
@property (strong, nonatomic) LSEditItemList     *itemListRole;          //角色选择
@property (strong, nonatomic) LSEditItemList     *itemListInDate;        //入职时间选择
@property (strong, nonatomic) LSEditItemText     *itemTxtMobile;         //电话
@property (strong, nonatomic) LSEditItemList     *itemListSex;           //性别选择
@property (strong, nonatomic) LSEditItemList     *itemListBirthday;      //生日选择
@property (strong, nonatomic) LSEditItemText     *itemTxtAddress;        //地址
@property (strong, nonatomic) EditItemImage2 *itemPortrait;          //头像
@property (strong, nonatomic) LSEditItemTitle        *itemTitleIdentity;     //证件title
@property (strong, nonatomic) LSEditItemList     *itemListIdentityType;  //证件类型
@property (strong, nonatomic) LSEditItemText     *itemTxtIdentityID;     //证件ID
@property (strong, nonatomic) EditItemCertId   *itemCertIdImg;         //证件图片
@property (strong, nonatomic) UIView           *delView;                //删除按钮容器ß

@property (nonatomic, strong) EmployeeUserVo            *userInfo;              //员工信息
@property (nonatomic, strong) EmployeeService           *service;
@property (nonatomic, weak) EmployeeManageView        *parent;
@property (nonatomic, assign) BOOL                      isAdd;
@property (nonatomic, assign) NSInteger                 shopMode;               //店铺类型 //1 单店 2门店 3组织机构
@property (nonatomic, assign) NSInteger                 selectShopType;         //选中的店铺类型
@property (nonatomic, assign) NSInteger                 roleType;               //读取角色的type 1.门店 2.机构
@property (nonatomic, strong) UIImagePickerController   *imagePickerController; //图片选择器
@property (nonatomic, assign) NSInteger                 imgCurrTag;             //当前的图形控件是那个.
@property (nonatomic, strong) NSMutableArray            *roleDicList;           //角色字典
@property (nonatomic, strong) NSMutableArray            *userAttachmentList;    //添加图片时用到
@property (nonatomic, assign) NSInteger                 alertType;              //区分什么操作弹出的alert
@property (nonatomic, strong) NSString                  *parentSelectShopname;  //上一页选中的店铺名,仅添加页面使用
@property (nonatomic, strong) NSString                  *parentSelectShopid;    //上一页选中的店铺ID,仅添加页面使用
@property (nonatomic, assign) NSInteger                 parentSelectShopType;   //上一页选中的店铺类型,仅添加页面使用
@property (nonatomic, strong) NSString                  *shopCode;              //门店编号
@property (nonatomic, strong) NSString                  *selectParentShopCode;  //选中店的上级机构编号
@end

@implementation EmployeeEditView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    
    self.shopMode = [[Platform Instance] getShopMode];
    [self initMainView];
    [self initNotification];
    [self configHelpButton:HELP_EMPLOYEE_INFORMATION_DETAIL];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (id)initWithParent:(id)parentTemp{
    self = [super init];
    if (self) {
        _service = [ServiceFactory shareInstance].employeeService;
        if ([parentTemp isKindOfClass:[EmployeeManageView class]]) {
            _parent = parentTemp;
        }
    }
    return self;
}
- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
   
    [self.scrollView addSubview:self.container];

    self.itemTitleBase = [LSEditItemTitle editItemTitle];
    [self.container addSubview:self.itemTitleBase];
    
    self.itemTxtName = [LSEditItemText editItemText];
    [self.container addSubview:self.itemTxtName];
    
    self.itemListOrganization = [LSEditItemList editItemList];
    [self.container addSubview:self.itemListOrganization];
    
    self.itemTxtStaffId = [LSEditItemText editItemText];
    [self.container addSubview:self.itemTxtStaffId];
    
    self.itemTxtUserName = [LSEditItemText editItemText];
    [self.container addSubview:self.itemTxtUserName];
    
    self.itemTxtPwd = [EditItemText2 editItemText];
    [self.container addSubview:self.itemTxtPwd];
    
    self.itemListRole = [LSEditItemList editItemList];
    [self.container addSubview:self.itemListRole];
    
    self.itemListInDate = [LSEditItemList editItemList];
    [self.container addSubview:self.itemListInDate];
    
    self.itemTxtMobile = [LSEditItemText editItemText];
    [self.container addSubview:self.itemTxtMobile];
    
    self.itemListSex = [LSEditItemList editItemList];
    [self.container addSubview:self.itemListSex];
    
    self.itemListBirthday = [LSEditItemList editItemList];
    [self.container addSubview:self.itemListBirthday];
    
    self.itemTxtAddress = [LSEditItemText editItemText];
    [self.container addSubview:self.itemTxtAddress];
    
    self.itemPortrait = [EditItemImage2 editItemImage];
    [self.container addSubview:self.itemPortrait];
    
    [LSViewFactor addClearView:self.container y:0 h:20];
    
    self.itemTitleIdentity = [LSEditItemTitle editItemTitle];
    [self.container addSubview:self.itemTitleIdentity];
    
    self.itemListIdentityType = [LSEditItemList editItemList];
    [self.container addSubview:self.itemListIdentityType];
    
    self.itemTxtIdentityID = [LSEditItemText editItemText];
    [self.container addSubview:self.itemTxtIdentityID];
    
    self.itemCertIdImg = [EditItemCertId editItemCartId];
    [self.container addSubview:self.itemCertIdImg];
    
    UIButton *btn = [LSViewFactor addRedButton:self.container title:@"删除" y:0];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.delView = btn.superview;
}

- (void)initMainView{
    //添加事件
    [self.itemTxtName.txtVal addTarget:self action:@selector(changeName:) forControlEvents:UIControlEventEditingDidEnd];
    [self.itemTxtStaffId.txtVal addTarget:self action:@selector(changeStuffId:) forControlEvents:UIControlEventEditingDidEnd];
    
    //
    [self initEditItems];
    [self reloadEditItems];
    
    
}

- (void)changeName:(UITextField *)textField
{
    if (!self.isAdd) {
        [self configTitle:textField.text];
    }
    
    
}
- (void)changeStuffId:(UITextField *)textField{
    NSString *userName;
    if (self.shopMode == 3) {//连锁机构
        if (_isAdd) {//添加页面
            //首先去拿上个页面选中的shop,自己选中了会把_parentSelectShopType和_selectShopType设为相同
            if (_parentSelectShopType == 2) {//选中的为组织机构
                userName = [self createUserName:textField.text shopCode:self.shopCode];//用选中自身的shopcode
            }else{//选中的为门店或者单店
                userName = [self createUserName:textField.text shopCode:self.selectParentShopCode];
            }
        }else{
            //编辑页面_selectShopType初始化为_parentSelectShopType
            if (_selectShopType == 2) {
                userName = [self createUserName:textField.text shopCode:self.shopCode];
            }else{
                userName = [self createUserName:textField.text shopCode:self.selectParentShopCode];
            }
            
        }
    }else if (self.shopMode == 2){//连锁门店
        userName = [self createUserName:textField.text shopCode:self.selectParentShopCode];//用上级组织的shopCode
    }else if (self.shopMode == 1){//单店
        //单店永远用自身的shopCode
        userName = [self createUserName:textField.text shopCode:self.shopCode];//用选中自身的shopcode
    }
    [self.itemTxtUserName changeData:userName];
    
//    if ([ObjectUtil isNull:self.shopCode]) {//shopcode为空。机构门店和单店才会为空
//        //门店和单店根据自身的shopcode或者自身上级的shopcode
//        if (self.shopMode == 3) {//机构
//            [AlertBox show:@"请选择所属门店/机构!"];//永远不会进
//        }else if (self.shopMode == 2){//机构门店
//            self.shopCode = [[Platform Instance] getkey:SHOP_CODE];
//            NSString *userName = [self createUserName:textField.text shopCode:self.shopCode];
//            [self.itemTxtUserName changeData:userName];
//
//        }else{//单店
//            self.shopCode = [[Platform Instance] getkey:SHOP_CODE];
//            NSString *userName = [self createUserName:textField.text shopCode:self.shopCode];
//            [self.itemTxtUserName changeData:userName];
//        }
//        
//    }else{//组织机构不会为空 默认shopCode根据上个页面选中的店家来确定
//        NSString *userName;
//        if (_parentSelectShopType == 2) {//选中的为组织机构
//            userName = [self createUserName:textField.text shopCode:self.shopCode];//用选中自身的shopcode
//        }else{//选中的为门店或者单店
//            userName = [self createUserName:textField.text shopCode:self.selectParentShopCode];
//        }
    
//        if (self.shopMode == 3) {//机构
//            [self.itemTxtUserName changeData:userName];
//        }else if (self.shopMode == 2){//机构门店
//            if ([ObjectUtil isNotNull:self.parentShopCode]) {
//                userName = [self createUserName:textField.text shopCode:self.parentShopCode];
//            }
//            [self.itemTxtUserName changeData:userName];
//            //test,牛肉那里服务没有发布 先用自身的shopcode
////            self.shopCode = [[Platform Instance] getkey:SHOP_CODE];
////            userName = [self createUserName:textField.text shopCode:self.shopCode];
////            [self.itemTxtUserName changeData:userName];
//            
//        }else{//单店
//            self.shopCode = [[Platform Instance] getkey:SHOP_CODE];
//            userName = [self createUserName:textField.text shopCode:self.shopCode];
//            [self.itemTxtUserName changeData:userName];
//        }

//    }
}

#pragma mark - 功能函数
- (void)initNotification {
    [UIHelper initNotification:self.container event:Notification_UI_EmployeeEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_EmployeeEditView_Change object:nil];
    
}

- (void)dataChange:(NSNotification *)notification {
    NSInteger action;
    if (_isAdd) {
        action = ACTION_CONSTANTS_ADD;
    }else{
        action = ACTION_CONSTANTS_EDIT;
    }
   [self editTitle:[UIHelper currChange:self.container] act:action];
}


- (void)initEditItems{
    //初始化数据
    
    self.itemTitleBase.lblName.text = @"基本设置";
    [self.itemTxtName initLabel:@"员工姓名" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.itemTxtName initMaxNum:50];
    
    if (self.shopMode != 1) {
        [self.itemTxtStaffId initLabel:@"工号" withHit:nil isrequest:YES type:UIKeyboardTypeNumbersAndPunctuation];
        [self.itemTxtUserName initLabel:@"用户名" withHit:nil isrequest:YES type:UIKeyboardTypeNumbersAndPunctuation];
        [self.itemTxtUserName visibal:YES];
        [self.itemTxtStaffId initMaxNum:12];
    }else{
        [self.itemTxtStaffId initLabel:@"用户名/工号" withHit:nil isrequest:YES type:UIKeyboardTypeNumbersAndPunctuation];
        [self.itemTxtUserName visibal:NO];
        [self.itemTxtStaffId initMaxNum:32];
    }
    //[self.itemTxtUserName editEnabled:NO];
    
     self.itemTxtUserName.txtVal.placeholder = @"请输入字母/数字";
    //密码
    [self.itemTxtPwd initLabel:@"登录密码" withHit:nil withType:nil showTag:ITEM_TAG_CHANGE_PWD delegate:self];
    self.itemTxtPwd.txtVal.keyboardType = UIKeyboardTypeASCIICapable;
    [self.itemTxtPwd initMaxNum:10];
    
    
    if (3 == self.shopMode) {
        [self.itemListOrganization visibal:YES];
        self.selectShopType = 2;
        self.roleType = 2;
    }else{
        [self.itemListOrganization visibal:NO];
        self.selectShopType = 1;
        self.roleType = 1;
    }
    
    if (_userInfo.shopType != 0) {
        self.selectShopType = _userInfo.shopType;
        self.roleType = _userInfo.shopType;
    }
    
    [self.itemListOrganization initLabel:@"所属机构/门店" withHit:nil delegate:self];
    self.itemListOrganization.imgMore.image = [UIImage imageNamed:@"ico_next.png"];
    self.itemListOrganization.tag = ITEM_TAG_ORGANIZATION;
    
    
    [self.itemListRole initLabel:@"员工角色" withHit:nil delegate:self];
    self.itemListRole.tag = ITEM_TAG_ROLE;
    
    [self.itemListInDate initLabel:@"入职时间" withHit:nil isrequest:NO delegate:self];
    self.itemListInDate.tag = ITEM_TAG_INDATE;
    
    [self.itemTxtMobile initLabel:@"手机号码" withHit:nil isrequest:NO type:UIKeyboardTypeNumberPad];
    [self.itemTxtMobile initMaxNum:11];
    
    [self.itemListSex initLabel:@"性别" withHit:nil delegate:self];
    self.itemListSex.tag = ITEM_TAG_SEX;
    [self.itemListBirthday initLabel:@"生日" withHit:nil delegate:self];
    self.itemListBirthday.tag = ITEM_TAG_BIRTHDAY;
    
    [self.itemTxtAddress initLabel:@"住址" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.itemTxtAddress initMaxNum:100];
    
    [self.itemPortrait initLabel:@"员工头像" delegate:self title:@"选择头像"];
    [self.itemPortrait initView:nil path:nil];
    [self.itemPortrait initImg:nil img:[UIImage imageNamed:@"img_stuff_male.png"]];
    
    self.itemPortrait.lblAdd.hidden = YES;
    self.itemPortrait.imgAdd.hidden = YES;
    self.itemPortrait.tag = ITEM_TAG_PORTAIT;
    
    self.itemTitleIdentity.lblName.text = @"身份信息";
    [self.itemListIdentityType initLabel:@"证件类型" withHit:nil delegate:self];
    self.itemListIdentityType.tag = ITEM_TAG_IDENTITYTYPE;
    [self.itemTxtIdentityID initLabel:@"证件号码" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.itemTxtIdentityID initMaxNum:18];
    [self.itemCertIdImg initLabel:@"证件图片" delegate:self];
    
    if (_isAdd) {
        
//        NSString *strTitle = @"添加";
        NSString *strTitle = @"添加员工";
        [self configTitle:strTitle leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
        
        
        [self.itemTxtName initData:nil];
        [self.itemTxtStaffId initData:nil];
        [self.itemTxtUserName initData:nil];
        
        NSString* hitStr=@"必填";
        UIColor *color = [UIColor redColor];
        if ([self.itemTxtPwd.txtVal respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            self.itemTxtPwd.txtVal.attributedPlaceholder = [[NSAttributedString alloc] initWithString:hitStr attributes:@{NSForegroundColorAttributeName: color}];
        }
        [self.itemTxtPwd initData:nil];
        self.itemTxtPwd.txtVal.placeholder = @"请输入6-10位字母/数字";
        if ([ObjectUtil isNotNull:self.parentSelectShopname] && [ObjectUtil isNotNull:self.parentSelectShopid] && self.shopMode == 3) {
            [self.itemListOrganization initData:self.parentSelectShopname withVal:self.parentSelectShopid];
            self.selectShopType = self.parentSelectShopType;
            self.roleType = self.parentSelectShopType;
        }else{
            [self.itemListOrganization initData:@"请选择" withVal:nil];
        }
        

        [self.itemListRole initData:@"请选择" withVal:nil];
        [self.itemListInDate initData:@"请选择" withVal:nil];
        [self.itemTxtMobile initData:nil];
        [self.itemListSex initData:@"请选择" withVal:nil];
        if ([ObjectUtil isNotNull:_parent.sexDicList] && _parent.sexDicList.count > 0) {
            NameItemVO *nameItemVo = nil;
            for (NameItemVO *item in _parent.sexDicList) {
                if ([[item obtainItemName] isEqualToString:@"男"]) {
                    nameItemVo = item;
                }
            }
            [self.itemListSex initData:[nameItemVo obtainItemName] withVal:[nameItemVo obtainItemId]];
        }
        
        [self.itemListBirthday initData:@"请选择" withVal:nil];
        [self.itemTxtAddress initData:nil];
       
//        [self.itemListIdentityType initData:@"身份证" withVal:@"1"];
        [self.itemListIdentityType initData:@"请选择" withVal:nil];
        [self.itemTxtIdentityID initData:nil];
        
        [self.itemCertIdImg initFrontImg:nil];
        [self.itemCertIdImg initBackImg:nil];
        
        self.delView.hidden = YES;
    }
    
    [UIHelper refreshPos:self.container scrollview:self.scrollView];

}

//为Item加载数据
- (void)reloadEditItems{
    
    
    if (_userInfo.shopType != 0) {
        self.selectShopType = _userInfo.shopType;
        self.roleType = _userInfo.shopType;
    }
    
    //导航栏
    NSString *strTitle;
    if (_isAdd) {
//        strTitle = @"添加";
        strTitle = @"添加员工";
        [self configTitle:strTitle leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
    }else{
        if (_userInfo) {
            strTitle = _userInfo.name;
             [self configTitle:strTitle leftPath:Head_ICON_BACK rightPath:nil];
        }
    }
    
    //更新数据
    if (!_isAdd) {//编辑
        
        [self.itemTxtName initData:_userInfo.name];
        
        
        //密码
        [self.itemTxtPwd initLabel:@"登录密码" withHit:nil withType:@"重置" showTag:ITEM_TAG_CHANGE_PWD delegate:self];
        self.itemTxtPwd.txtVal.hidden = YES;
        self.itemTxtPwd.btnButton.hidden = NO;
        [self.itemTxtPwd initData:_userInfo.pwd];
        
        //组织机构
        if (self.shopMode == 3) {
            [self.itemListOrganization initData:_userInfo.shopName withVal:_userInfo.shopId];
        }
        
        //用户名 工号
        if (self.shopMode != 1) {
            if ([ObjectUtil isNotNull:_userInfo.staffId]&&[ObjectUtil isNotNull:_userInfo.userName]) {
                [self.itemTxtUserName initData:_userInfo.userName];
                [self.itemTxtStaffId initData:_userInfo.staffId];
            }
        }else{
            [self.itemTxtStaffId initData:_userInfo.staffId];
            [self.itemTxtUserName initData:_userInfo.userName];
        }
       
        //角色
        NSString *strVal,*strName;
        for (NameItemVO *temp in _parent.roleDicList) {
            if ([temp.itemId isEqualToString:_userInfo.roleId] ) {
                strName = temp.itemName;
                strVal = temp.itemId;
            }
        }
        if ([ObjectUtil isNull:strVal]) {
            [self.itemListRole initData:@"请选择" withVal:nil];
        }else{
            [self.itemListRole initData:strName withVal:strVal];
        }

        
        //入职时间
        if (0 < _userInfo.inDate) {
              [self.itemListInDate initData:[DateUtils formateTime2:_userInfo.inDate] withVal:[DateUtils formateTime2:_userInfo.inDate]];
        }else{
            [self.itemListInDate initData:@"请选择" withVal:nil];
        }
      
        //手机
        [self.itemTxtMobile initData:_userInfo.mobile];
        
        //性别
        strVal = nil;strName = nil;
        for (NameItemVO *temp in _parent.sexDicList) {
            if (temp.itemId.integerValue == _userInfo.sex ) {
                strName = temp.itemName;
                strVal = temp.itemId;
            }
        }
        if ([ObjectUtil isNull:strVal]) {
            [self.itemListSex initData:@"请选择" withVal:nil];
        }else{
            [self.itemListSex initData:strName withVal:strVal];
        }
        
        //生日
        if (0 < _userInfo.birthday) {
            [self.itemListBirthday initData:[DateUtils formateTime2:_userInfo.birthday] withVal:[DateUtils formateTime2:_userInfo.birthday]];
        }else{
            [self.itemListBirthday initData:@"请选择" withVal:nil];
        }
        
        
        
        //地址
        [self.itemTxtAddress initData:_userInfo.address];
        
        
        
        //证件类型
        strVal = nil;strName = nil;
        NSArray *arrIdentityDicList = _parent.identityDicList;
        for (NameItemVO *temp in arrIdentityDicList) {
            if (temp.itemId.integerValue == _userInfo.identityTypeId ) {
                strName = temp.itemName;
                strVal = temp.itemId;
            }
        }
        if ([ObjectUtil isNull:strVal]) {
            [self.itemListIdentityType initData:@"请选择" withVal:nil];
             [self.itemTxtIdentityID initLabel:@"证件号码" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
        }else{
            [self.itemListIdentityType initData:strName withVal:strVal];
             [self.itemTxtIdentityID initLabel:@"证件号码" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
        }
        
        
        //证件号码
        [self.itemTxtIdentityID initData:_userInfo.identityNo];
        
        //头像、身份证正面、身份证反面
        if ([ObjectUtil isNotEmpty:_userInfo.userAttachmentList]) {
            BOOL isHadPortrait = NO;
            for (UserAttachmentVo *tempvo in _userInfo.userAttachmentList) {
                if (tempvo.sortCode == 1) {
                    //用户头像
                    [self.itemPortrait initView:tempvo.filePath path:tempvo.filePath];
                    isHadPortrait = YES;
                }else if (tempvo.sortCode == 2){
                    //证件图片正面
                    [self.itemCertIdImg initFrontImg:tempvo.filePath];
                }else if (tempvo.sortCode == 3){
                    //证件图片背面
                    [self.itemCertIdImg initBackImg:tempvo.filePath];
                }
            }
            if (!isHadPortrait) {//如果没有头像,设置默认头像
                if (_userInfo.sex == 2) {//女
                    [self.itemPortrait initImg:nil img:[UIImage imageNamed:@"img_stuff_female.png"]];
                }else{//男
                    [self.itemPortrait initImg:nil img:[UIImage imageNamed:@"img_stuff_male.png"]];
                }
            }
        }else{
            //没有附件 证件初始化
            [self.itemCertIdImg initFrontImg:nil];
            [self.itemCertIdImg initBackImg:nil];
            
            if (_userInfo.sex == 2) {//女
                [self.itemPortrait initImg:nil img:[UIImage imageNamed:@"img_stuff_female.png"]];
            }else{//男
                [self.itemPortrait initImg:nil img:[UIImage imageNamed:@"img_stuff_male.png"]];
            }


        }
        
        self.delView.hidden = NO;
        
    }
    
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
}
//清空控件
- (void)clearData{
    
    [self.itemTxtName initData:nil];
    [self.itemTxtStaffId initData:nil];
    [self.itemTxtPwd initData:nil];
    
    [self.itemListOrganization initData:nil withVal:nil];
    [self.itemListRole initData:nil withVal:nil];
    [self.itemListInDate initData:nil withVal:nil];
    [self.itemTxtMobile initData:nil];
    [self.itemListSex initData:nil withVal:nil];
    
    [self.itemListBirthday initData:nil withVal:nil];
    [self.itemTxtAddress initData:nil];
    [self.itemPortrait initView:nil path:nil];
    
    [self.itemListIdentityType initData:nil withVal:nil];
    [self.itemTxtIdentityID initData:nil];
    
    [self.itemCertIdImg initFrontImg:nil];
    [self.itemCertIdImg initBackImg:nil];
}

//将item中的数据打包成EmployeeUserVo
- (void)packageEmployeeUserVo{
    
    if ([ObjectUtil isNotNull:_userInfo]) {
        
        _userInfo.name = self.itemTxtName.txtVal.text;
        
        
        _userInfo.pwd = [SignUtil convertPassword:self.itemTxtPwd.txtVal.text];
        
        if (3 == self.shopMode) {
            _userInfo.shopId = self.itemListOrganization.getStrVal;
            _userInfo.shopName = self.itemListOrganization.lblVal.text;
            
        }else{
            _userInfo.shopId = [[Platform Instance]getkey:SHOP_ID];
            _userInfo.shopName = [[Platform Instance]getkey:SHOP_NAME];
            
        }
        
        if (1 != self.shopMode) {
            _userInfo.staffId = self.itemTxtStaffId.txtVal.text;
            _userInfo.userName = self.itemTxtUserName.txtVal.text;
        }else{
            _userInfo.staffId = self.itemTxtStaffId.txtVal.text;
            _userInfo.userName = _userInfo.staffId;//登录名就是工号
        }
        
        _userInfo.shopType = self.selectShopType;
        
       
        _userInfo.inDate = [NSNumber numberWithLongLong:[DateUtils formateDateTime3:self.itemListInDate.lblVal.text]].longLongValue;
        _userInfo.mobile = self.itemTxtMobile.txtVal.text;
        _userInfo.sex = [[self.itemListSex getStrVal] integerValue];
        _userInfo.birthday = [NSNumber numberWithLong:[DateUtils formateDateTime3:self.itemListBirthday.lblVal.text]].integerValue;
        _userInfo.address = self.itemTxtAddress.txtVal.text;
        
        _userInfo.identityNo = self.itemTxtIdentityID.txtVal.text;//
        _userInfo.identityTypeId = self.itemListIdentityType.currentVal.integerValue;//"身份证"索引
        
        //角色
        _userInfo.roleId = [self.itemListRole getStrVal];
        _userInfo.roleName = self.itemListRole.lblVal.text;
        
        if (self.isAdd) {
            _userInfo.userAttachmentList = self.userAttachmentList;
        }
        
        
        
    }
    
}

//
- (void)setShowType:(BOOL)isAdd{
    self.isAdd = isAdd;
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
}

//根据工号流水生成工号
- (NSString *)createUserName:(NSString *)stuffid shopCode:(NSString *)shopCode {
    
    if (!stuffid) {
        stuffid = @"";
    }
    if (!shopCode) {
        shopCode = @"";
    }
    NSMutableString *userName = [NSMutableString stringWithString:shopCode];
    [userName appendString:stuffid];
    return userName;
}

#pragma mark - 点击删除
- (void)btnClick:(id)sender {
    NSString *message = [NSString stringWithFormat:@"确认要删除[%@]吗?",self.itemTxtName.txtVal.text];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:message delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确认",nil];
    [actionSheet showInView:self.view];
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//    _alertType = 1;
//    [alert show];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {//确定
        __weak EmployeeEditView *weekSelf = self;
        [_service deleteUserByUserId:_userInfo.userId completionHandler:^(id json) {
            [weekSelf clearData];
            [XHAnimalUtil animal:weekSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weekSelf.navigationController popViewControllerAnimated:NO];
            [weekSelf.parent loadEmployeeList];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];

    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        switch (_alertType) {
            case 1://删除
            {
                __weak EmployeeEditView *weekSelf = self;
                [_service deleteUserByUserId:_userInfo.userId completionHandler:^(id json) {
                    [weekSelf clearData];
                    [XHAnimalUtil animal:weekSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                    [weekSelf.navigationController popViewControllerAnimated:NO];
                    [weekSelf.parent loadEmployeeList];
                } errorHandler:^(id json) {
                    [AlertBox show:json];
                }];

            }
            break;
            case 2://重置密码
            {
                [_service changePwd:_userInfo.userId pwd:@"123456" completionHandler:^(id json) {
                    _userInfo.lastVer += 1;//重置后版本号+1 ，与服务器端一致
                    [AlertBox show:@"重置密码成功!"];
                } errorHandler:^(id json) {
                    [AlertBox show:json];
                }];
            }
            break;
            default:
                break;
        }
    }
}
#pragma mark - network
- (void)loadDataWithUserID:(NSString *)userID WithParam:(NSDictionary *)param {
    self.shopCode = [ObjectUtil getStringValue:param key:@"shopCode"];
    self.selectParentShopCode = [ObjectUtil getStringValue:param key:@"parentShopCode"];
    __weak EmployeeEditView *weekSelf = self;
    [_service userInfoByUserId:userID completionHandler:^(id json) {
        if (!weekSelf)  return ;
        [weekSelf responseSuccess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}
- (void)initDataInAddTypeWithParam:(NSDictionary *)param{
    _userInfo = nil;
    _userInfo = [[EmployeeUserVo alloc]init];
    _userInfo.shopEntityId = [ObjectUtil getStringValue:param key:@"shopEntityId"];
    self.parentSelectShopname = [ObjectUtil getStringValue:param key:@"shopname"];
    self.parentSelectShopid = [ObjectUtil getStringValue:param key:@"shopid"];
    self.parentSelectShopType = [ObjectUtil getIntegerValue:param key:@"shoptype"];
    self.shopCode = [ObjectUtil getStringValue:param key:@"shopCode"];
    self.selectParentShopCode = [ObjectUtil getStringValue:param key:@"parentShopCode"];
    self.userAttachmentList = nil;
    self.userAttachmentList = [NSMutableArray array];
}

- (void)responseSuccess:(id)json{
    _userInfo = nil;
    _userInfo = [EmployeeUserVo convertToUser:[json objectForKey:@"user"]];
    if ([ObjectUtil isNotNull:_userInfo]&&[ObjectUtil isNotNull:_userInfo.shopCode]) {
        self.shopCode = _userInfo.shopCode;
    }
    self.userAttachmentList = nil;
    self.userAttachmentList = [NSMutableArray array];
    [self reloadEditItems];
    
}
- (void)responseSave:(id)json{
     [self.parent loadEmployeeList];
    if (_isAdd) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
    }else{
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    }
    [self.navigationController popViewControllerAnimated:NO];
   
}
#pragma mark - INavigateEvent代理  (导航)
-(void) onNavigateEvent:(LSNavigationBarButtonDirect)event{
    if (event==LSNavigationBarButtonDirectLeft) {
        [self clearData];
        if (_isAdd) {
            
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        }else{
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }
        
        [self.navigationController popViewControllerAnimated:NO];
    }
    else {//保存
        NSString *operateType = nil;
        if (_isAdd) {
            operateType = @"add";
        }else {
            operateType = @"edit";
        }
        
        //连锁模式下
        //先判断该角色是否正在盘点
//        if ([[Platform Instance] getShopMode] == 3) {
//            if (![self.itemListRole getStatueNosave]) {
//#warning 此处先请求服务器该角色是否正在做为主盘点人盘点
//                [LSAlertHelper showAlert:@"当前员工作为主盘点人正在盘点中，暂不支持修改所属机构/门店!"];
//                return;
//            }
//        }
        //存放图片对象
        NSMutableArray *imageVoList = [NSMutableArray array];
        //存放图片数据
        NSMutableArray *imageDataList = [NSMutableArray array];
        LSImageVo *imageVo = nil;
        LSImageDataVo *imageDataVo = nil;
        NSString *oldVal = nil;
        NSString *currentVal = nil;
        
        
        if (self.itemPortrait.isChange) {
            //删除商品
             oldVal = self.itemPortrait.oldVal;
            if ([NSString isNotBlank:oldVal]) {
                imageVo = [LSImageVo imageVoWithFileName:oldVal opType:2 type:@"user"];
                [imageVoList addObject:imageVo];
            }
            //添加商品
            currentVal = self.itemPortrait.currentVal;
            if ([NSString isNotBlank:currentVal]) {
                imageVo = [LSImageVo imageVoWithFileName:currentVal opType:1 type:@"user"];
                [imageVoList addObject:imageVo];
                UIImage *image = self.itemPortrait.img.image;
                NSData *data =  UIImageJPEGRepresentation(image, 0.1);
                imageDataVo = [LSImageDataVo imageDataVoWithData:data file:currentVal];
                [imageDataList addObject:imageDataVo];
            }

           
            //添加商品
        }
        if (self.itemCertIdImg.frontCertId.isChange) {
            //删除商品
            oldVal = self.itemCertIdImg.frontCertId.oldVal;
            if ([NSString isNotBlank:oldVal]) {
                imageVo = [LSImageVo imageVoWithFileName:oldVal opType:2 type:@"user"];
                [imageVoList addObject:imageVo];
            }
            //添加商品
            currentVal = self.itemCertIdImg.frontCertId.currentVal;
            if ([NSString isNotBlank:currentVal]) {
                imageVo = [LSImageVo imageVoWithFileName:currentVal opType:1 type:@"user"];
                [imageVoList addObject:imageVo];
                
                UIImage *image = self.itemCertIdImg.frontCertId.imgView.image;
                NSData *data =  UIImageJPEGRepresentation(image, 0.1);
                imageDataVo = [LSImageDataVo imageDataVoWithData:data file:currentVal];
                [imageDataList addObject:imageDataVo];
            }
        }
        if (self.itemCertIdImg.backCertId.isChange) {
            //删除商品
            oldVal = self.itemCertIdImg.backCertId.oldVal;
            if ([NSString isNotBlank:oldVal]) {
                imageVo = [LSImageVo imageVoWithFileName:oldVal opType:2 type:@"user"];
                [imageVoList addObject:imageVo];
            }
            //添加商品
            currentVal = self.itemCertIdImg.backCertId.currentVal;
            if ([NSString isNotBlank:currentVal]) {
                imageVo = [LSImageVo imageVoWithFileName:currentVal opType:1 type:@"user"];
                [imageVoList addObject:imageVo];
                
                UIImage *image = self.itemCertIdImg.backCertId.imgView.image;
                NSData *data =  UIImageJPEGRepresentation(image, 0.1);
                imageDataVo = [LSImageDataVo imageDataVoWithData:data file:currentVal];
                [imageDataList addObject:imageDataVo];
            }
        }
        
        if ([self isValid]) {
            [self packageEmployeeUserVo];
            //更新添加员工
            
            __weak EmployeeEditView *weekSelf = self;
            [_service saveEmployee:_userInfo operateType:operateType shopType:_userInfo.shopType completionHandler:^(id json) {
                if (!weekSelf)  return ;
                [weekSelf responseSave:json];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
            //上传图片
            [BaseService upLoadImageWithimageVoList:imageVoList imageDataVoList:imageDataList];

        }
        
    }
}



#pragma mark - IEditItemListEvent代理
- (void)onItemListClick:(LSEditItemList*)obj{
    if(obj == self.itemListOrganization){
        __weak EmployeeEditView *weakSelf = self;
        SelectOrgShopListView *vc = [[SelectOrgShopListView alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [vc loadData:[obj getStrVal] withModuleType:2 withCheckMode:SINGLE_CHECK callBack:^(NSMutableArray *selectArr, id<ITreeItem> item) {
            if (item) {
                [weakSelf.itemListOrganization changeData:[item obtainItemName] withVal:[item obtainItemId]];
                weakSelf.shopCode = [item obtainItemValue];
                weakSelf.selectParentShopCode = [item obtainParentCode];//
                
                NSInteger selectShopType = [item obtainItemType];
                if (selectShopType == 2) {
                    //门店
                    weakSelf.selectShopType = 1;
                    weakSelf.roleType = 1;
                    weakSelf.parentSelectShopType = 1;//自己选中,就置为相同
                }else{
                    //公司、部门
                    weakSelf.selectShopType = 2;
                    weakSelf.roleType = 2;
                    weakSelf.parentSelectShopType = 2;//自己选中,就置为相同
                }
                
                BOOL ischange = [weakSelf.itemListOrganization isChange];
                if (ischange) {
                    [weakSelf.itemListRole changeData:@"请选择" withVal:nil];
                }
                
                if ([ObjectUtil isNotNull:weakSelf.itemTxtStaffId.txtVal.text]) {
                    NSString *userName;
                    if (selectShopType == 2) {//机构门店 使用上级机构code
                        userName = [weakSelf createUserName:weakSelf.itemTxtStaffId.txtVal.text shopCode:weakSelf.selectParentShopCode];
                    }else{//公司、部门使用自身code
                        userName = [weakSelf createUserName:weakSelf.itemTxtStaffId.txtVal.text shopCode:weakSelf.shopCode];
                    }
                    
                    [self.itemTxtUserName changeData:userName];
                }

            }
            
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf.navigationController popViewControllerAnimated:NO];
            
        }];
        
        
    }else if(obj == self.itemListRole) {
        __weak EmployeeEditView *weakSelf = self;
        
        [_service roleListByRoleName:nil roleType:self.roleType WithCompletionHandler:^(id json) {
            if (!weakSelf) return ;
            NSArray *arrDicVoList = [json objectForKey:@"roleVoList"];
            self.roleDicList = nil;
            self.roleDicList = [EmployeeRender getItemVoListByRoleList:arrDicVoList];
            [OptionPickerBox initData:self.roleDicList itemId:[obj getStrVal]];
            [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
        
    }else if (obj == self.itemListIdentityType){
        
        [OptionPickerBox initData:_parent.identityDicList itemId:[obj getStrVal]];
        [OptionPickerBox showClearTitle:obj.lblName.text client:self event:obj.tag];
    }else if (obj == self.itemListSex){
        [OptionPickerBox initData:_parent.sexDicList itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }else if (obj == self.itemListOrganization){
        
    }else if (obj == self.itemListInDate){
        NSDate *date=[DateUtils parseDateTime4:obj.lblVal.text];
        [DatePickerBox show:obj.lblName.text date:date client:self event:(int)obj.tag];
    }else if (obj== self.itemListBirthday)
    {
        NSDate *date=[DateUtils parseDateTime4:obj.lblVal.text];
        if (date == nil) {
            date=[DateUtils parseDateTime4:@"1985-01-01"];
        }
        [DatePickerBox show:obj.lblName.text date:date client:self event:(int)obj.tag];
        [DatePickerBox setMinimumDate:[DateUtils parseDateTime4:@"1960-01-01"]];

        
    }

}

- (void)managerOption:(NSInteger)eventType {
    if (ITEM_TAG_IDENTITYTYPE == eventType) {
        [self.itemListIdentityType changeData:@"请选择" withVal:nil];
        [self.itemTxtIdentityID initLabel:@"证件号码" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
        [self.itemTxtIdentityID initData:nil];
    }
}

#pragma mark - OptionPickerClient
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType{
    
    NSString *strVal,*name;
    if ([selectObj isKindOfClass:[NameItemVO class]]) {
        NameItemVO *temp = selectObj;
        strVal = temp.itemId;
        name = temp.itemName;
        
    }
    if (ITEM_TAG_ROLE == eventType) {
        //修改对应item的内容
        [self.itemListRole changeData:name withVal:strVal];
    }else if (ITEM_TAG_IDENTITYTYPE == eventType){
        [self.itemListIdentityType changeData:name withVal:strVal];
         [self.itemTxtIdentityID initLabel:@"证件号码" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    }else if (ITEM_TAG_SEX == eventType){
        [self.itemListSex changeData:name withVal:strVal];
        if ([ObjectUtil isNull:self.itemPortrait.currentVal] || [self.itemPortrait.currentVal isEqualToString:@""]) {
            if ([strVal isEqualToString:@"1"]) {//男
                [self.itemPortrait initImg:nil img:[UIImage imageNamed:@"img_stuff_male.png"]];
            }else{//女
                [self.itemPortrait initImg:nil img:[UIImage imageNamed:@"img_stuff_female.png"]];
            }
        }
        
    }else if (ITEM_TAG_ORGANIZATION == eventType){
        
    }
    return YES;
}
#pragma mark - DatePickerClient (日期选择器)
- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event{
    
    NSString *currentDateStr = [DateUtils formateDate2:date];
  
    if (ITEM_TAG_INDATE == event) {
        [self.itemListInDate changeData:currentDateStr withVal:currentDateStr];
    }
    else if (ITEM_TAG_BIRTHDAY == event){
        [self.itemListBirthday changeData:currentDateStr withVal:currentDateStr];
    }
    return YES;
}

#pragma mark - IEditItemImageEvent
-(void)callSystemCamera:(NSInteger)btnIndex{
    //获取点击按钮的标题
    if (btnIndex==1)
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [AlertBox show:@"相机好像不能用哦!"];
            return;
        }
        NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
        if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
            _imagePickerController = [[UIImagePickerController alloc] init];
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            _imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
            _imagePickerController.allowsEditing = YES;
            _imagePickerController.delegate = self;
            [self presentViewController:_imagePickerController animated:YES completion:nil];
        }
        
    }
    else if(btnIndex==0)
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [AlertBox show:@"相册好像不能访问哦!"];
            return;
        }
        NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
            _imagePickerController = [[UIImagePickerController alloc] init];
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            _imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
            _imagePickerController.allowsEditing = YES;
            _imagePickerController.delegate = self;
            [self presentViewController:_imagePickerController animated:YES completion:nil];
        }
    }

}

/**
 * 图片确认.（头像）
 */
- (void)onConfirmImgClick:(NSInteger)btnIndex{
    
    self.imgCurrTag = ITEM_TAG_PORTAIT;
    
    [self callSystemCamera:btnIndex];
}
/**
 * 删除图片.(头像)
 */
- (void)onDelImgClick{
    
    if (_userInfo.sex == 2) {//女
        [self.itemPortrait changeImg:nil img:[UIImage imageNamed:@"img_stuff_female.png"]];
    }else{//男
        [self.itemPortrait changeImg:nil img:[UIImage imageNamed:@"img_stuff_male.png"]];
        
    }
    
    self.itemPortrait.btnDel.hidden = YES;
    self.itemPortrait.imgDel.hidden = YES;
    self.itemPortrait.lblAdd.hidden = YES;
    self.itemPortrait.imgAdd.hidden = YES;
    if (self.isAdd) {
        for (int i = 0; i<self.userAttachmentList.count; i++ ) {
            UserAttachmentVo *tempVo = _userInfo.userAttachmentList[i];
            if (tempVo.sortCode == 1) {
                [_userInfo.userAttachmentList removeObject:tempVo];
            }
        }
    }else{
        for (int i = 0; i<self.userInfo.userAttachmentList.count; i++ ) {
            UserAttachmentVo *tempVo = _userInfo.userAttachmentList[i];
            if (tempVo.sortCode == 1) {
                tempVo.fileOperate = @"del";
            }
            
        }
    }

}

/**
 * 图片确认，带标记(区分多个上传时使用).（证件）
 */
- (void)onConfirmImgClickWithTag:(NSInteger)btnIndex tag:(NSInteger)tag{
    
    self.imgCurrTag = tag;
    
    [self callSystemCamera:btnIndex];
}

/**
 * 删除图片,带标记.（证件）
 */
- (void)onDelImgClickWithTag:(NSInteger)tag{
    //添加完没有保存再删除,没有id，服务器如何操作？
    if (tag == TAG_FRONTCERTID) {
        [self.itemCertIdImg changeFrontImg:@"-1" img:nil];//UI取消未保存
        if (self.isAdd) {
            for (int i = 0; i<self.userAttachmentList.count; i++ ) {
                UserAttachmentVo *tempVo = _userInfo.userAttachmentList[i];
                if (tempVo.sortCode == 2) {
                    [_userInfo.userAttachmentList removeObject:tempVo];
                }
            }
        }else{
            for (int i = 0; i<self.userInfo.userAttachmentList.count; i++ ) {
                UserAttachmentVo *tempVo = _userInfo.userAttachmentList[i];
                if (tempVo.sortCode == 2) {
                    tempVo.fileOperate = @"del";
                }
                
            }
        }

    } else if (tag == TAG_BACKCERTID) {
        [self.itemCertIdImg changeBackImg:@"-1" img:nil];//UI取消未保存
    
        if (self.isAdd) {
            for (int i = 0; i<self.userAttachmentList.count; i++ ) {
                UserAttachmentVo *tempVo = _userInfo.userAttachmentList[i];
                if (tempVo.sortCode == 3) {
                    [_userInfo.userAttachmentList removeObject:tempVo];
                }
            }
        }else{
            for (int i = 0; i<self.userInfo.userAttachmentList.count; i++ ) {
                UserAttachmentVo *tempVo = _userInfo.userAttachmentList[i];
                if (tempVo.sortCode == 3) {
                    tempVo.fileOperate = @"del";
                }
                
            }
        }

    }

}

#pragma mark - UIImagePickerController代理方法
//完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (self.imgCurrTag == ITEM_TAG_PORTAIT) {
            image = [ImageUtils changeImageSize:image size:CGSizeMake(300, 308)];
        } else {
            image = [ImageUtils changeImageSize:image size:CGSizeMake(300, 208)];
        }
        
        if ([ObjectUtil isNotNull:image]) {
            [self saveCustomerImage:image];
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];

}
- (void)saveCustomerImage:(UIImage *)image
{
    NSString *filePath = self.userInfo.userId;
    if ([NSString isBlank:filePath]) {
        filePath = [NSString getUniqueStrByUUID];
    }
    NSString* fileName =[NSString stringWithFormat:@"%@/%@.png",filePath,[NSString getUniqueStrByUUID]];
    if (self.isAdd) {//添加页面
        UserAttachmentVo *attachment = [[UserAttachmentVo alloc]init];
        attachment.fileName = fileName;
        attachment.fileOperate = @"edit";//更新
        if (self.imgCurrTag == ITEM_TAG_PORTAIT) {
            //更新到UI
            [self.itemPortrait changeImg:fileName img:image];
            //保存到数据结构
            attachment.sortCode = 1;
            
        }else if(self.imgCurrTag == TAG_FRONTCERTID){
            [self.itemCertIdImg changeFrontImg:fileName img:image];
            attachment.sortCode = 2;
        }else if(self.imgCurrTag == TAG_BACKCERTID){
            [self.itemCertIdImg changeBackImg:fileName img:image];
            attachment.sortCode = 3;
        }
        [self.userAttachmentList addObject:attachment];
    }else{//详情编辑页面
        if (self.imgCurrTag == ITEM_TAG_PORTAIT) {
            if ([ObjectUtil isNotNull:[self isHadPic:1]]) {//如果存在则修改
                UserAttachmentVo *tempVo = [self isHadPic:1];
                tempVo.fileOperate = @"edit";
                tempVo.fileName = fileName;
            }
            else{//如果不存在则新增
                UserAttachmentVo *attachment = [[UserAttachmentVo alloc]init];
                attachment.fileName = fileName;
                attachment.fileOperate = @"edit";//更新
                attachment.sortCode = 1;
                [self.userInfo.userAttachmentList addObject:attachment];
            }
            [self.itemPortrait changeImg:fileName img:image];
        }else if(self.imgCurrTag == TAG_FRONTCERTID){
            if ([ObjectUtil isNotNull:[self isHadPic:2]]) {//如果存在则修改
                UserAttachmentVo *tempVo = [self isHadPic:2];
                tempVo.fileOperate = @"edit";
                tempVo.fileName = fileName;
            }
            else{//如果不存在则新增
                UserAttachmentVo *attachment = [[UserAttachmentVo alloc]init];
                attachment.fileName = fileName;
                attachment.fileOperate = @"edit";//更新
                attachment.sortCode = 2;
                [self.userInfo.userAttachmentList addObject:attachment];
            }
            [self.itemCertIdImg changeFrontImg:fileName img:image];
        }else if(self.imgCurrTag == TAG_BACKCERTID){
            if ([ObjectUtil isNotNull:[self isHadPic:3]]) {//如果存在则修改
                UserAttachmentVo *tempVo = [self isHadPic:3];
                tempVo.fileOperate = @"edit";
                tempVo.fileName = fileName;
            }
            else{//如果不存在则新增
                UserAttachmentVo *attachment = [[UserAttachmentVo alloc]init];
                attachment.fileName = fileName;
                attachment.fileOperate = @"edit";//更新
                attachment.sortCode = 3;
                [self.userInfo.userAttachmentList addObject:attachment];
            }
            [self.itemCertIdImg changeBackImg:fileName img:image];

        }
    }
    
}
//根据sortCode判断图片是否存在。存在返回对应的vo,不存在返回nil
- (UserAttachmentVo *)isHadPic:(NSInteger)sortCode{
    for (int i = 0; i<self.userInfo.userAttachmentList.count; i++ ) {
        UserAttachmentVo *tempVo = _userInfo.userAttachmentList[i];
        if (tempVo.sortCode == sortCode) {
            return tempVo;
        }
    }
    return nil;
}

#pragma mark - EditItemText2Delegate
- (void)showButtonTag:(NSInteger)tag{
    if (ITEM_TAG_CHANGE_PWD == tag) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认重置登录密码吗？重置后登录密码为123456" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        _alertType = 2;
        [alert show];
    }
}

#pragma mark - 参数检查
- (BOOL)isValid {
    
    if ([ObjectUtil isNull:self.itemTxtName.txtVal.text] || [self.itemTxtName.txtVal.text isEqualToString:@""]) {
        [AlertBox show:@"员工姓名不能为空!"];
        return NO;
    }

    if ([ObjectUtil isNull:self.itemTxtStaffId.txtVal.text] || [self.itemTxtStaffId.txtVal.text isEqualToString:@""])
    {
        [AlertBox show:@"工号不能为空!"];
        return NO;
    }else{
        if ([NSString isNotNumAndLetter:self.itemTxtStaffId.txtVal.text]) {
            [AlertBox show:@"工号必须为英数字!"];
            return NO;
        }
    }
    if ([self.itemTxtStaffId.txtVal.text isEqualToString:@"000"]) {
        [AlertBox show:@"工号是000的用户不能添加!"];
        return NO;
    }
    
    if ([ObjectUtil isNull:self.itemTxtUserName.txtVal.text] || [self.itemTxtUserName.txtVal.text isEqualToString:@""])
    {
        [AlertBox show:@"用户名不能为空!"];
        return NO;
    }else{
        if ([NSString isNotNumAndLetter:self.itemTxtUserName.txtVal.text]) {
            [AlertBox show:@"用户名必须为英数字!"];
            return NO;
        }
    }
    
    if (_isAdd) {//密码只有添加时才会检查
        if ([ObjectUtil isNull:self.itemTxtPwd.txtVal.text] || [self.itemTxtPwd.txtVal.text isEqualToString:@""]) {
            [AlertBox show:@"密码不能为空!"];
            return NO;
        }else{
            if (self.itemTxtPwd.txtVal.text.length>10 || self.itemTxtPwd.txtVal.text.length < 6) {
                [AlertBox show:@"密码长度为6-10位!"];
                return NO;
            }else{
                if ([NSString isNotNumAndLetter:self.itemTxtPwd.txtVal.text]) {
                    [AlertBox show:@"密码只能为字母或数字!"];
                    return NO;
                }

            }
        }
    }
    
    if (3 == self.shopMode) {
        if ([ObjectUtil isNull:self.itemListOrganization.getStrVal] || [self.itemListOrganization.getStrVal isEqualToString:@""]) {
            [AlertBox show:@"请选择所属机构/门店!"];
            return NO;
        }
    }
        
    if ([ObjectUtil isNull:self.itemListRole.getStrVal] || [self.itemListRole.getStrVal isEqualToString:@""]) {
        [AlertBox show:@"请选择员工角色!"];
        return NO;
    }
    
    if ([ObjectUtil isNotNull:self.itemTxtMobile.txtVal.text] && ![self.itemTxtMobile.txtVal.text isEqualToString:@""])
    {
        //非必填，不为空才会去验证有效性
        if (![NSString validateMobile:self.itemTxtMobile.txtVal.text]) {
            [AlertBox show:@"请输入正确的手机号码!"];
            return NO;
        }
        
    }
    //证件类型和证件号码非必填 证件类型默认请选择 如果证件类型和证件号码有一个有值得话则都是必填的
    if ([NSString isBlank:[self.itemListIdentityType getStrVal]] && [NSString isNotBlank:self.itemTxtIdentityID.txtVal.text]) {
        [AlertBox show:@"请选择证件类型!"];
        return NO;
    }
    if ([NSString isNotBlank:[self.itemListIdentityType getStrVal]] && [NSString isBlank:self.itemTxtIdentityID.txtVal.text]) {
        [AlertBox show:@"证件号码不能为空!"];
        return NO;
    }else if ([NSString isNotBlank:self.itemTxtIdentityID.txtVal.text]){
        if (self.itemListIdentityType.currentVal.integerValue == 1) {
            //身份证
            if (![NSString validateIDCardNumber:self.itemTxtIdentityID.txtVal.text]) {
                [AlertBox show:@"请输入合法的证件号码!"];
                return NO;
            }
        }
        
    }

    
    return YES;
}

@end
