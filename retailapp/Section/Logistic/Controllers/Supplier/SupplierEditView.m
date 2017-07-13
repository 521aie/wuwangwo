//
//  SupplierEditView.m
//  retailapp
//
//  Created by hm on 15/12/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SupplierEditView.h"
#import "LSEditItemTitle.h"
#import "LSEditItemText.h"
#import "LSEditItemList.h"
#import "ServiceFactory.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "OptionPickerBox.h"
#import "SupplyManageVo.h"
#import "SupplyVo.h"
#import "SupplyTypeVo.h"
#import "SupplierKindListView.h"

@interface SupplierEditView ()<IEditItemListEvent,OptionPickerClient>

@property (nonatomic, strong) LogisticService *logisticService;

@property (nonatomic, strong) CommonService *commonService;

@property (nonatomic, assign) BOOL isWarehouse;

@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, copy) NSString *supplyId;

@property (nonatomic, assign) NSInteger action;

@property (nonatomic, copy) EditSupplyHandler supplyHandler;

@property (nonatomic, strong) SupplyManageVo *supplyManageVo;

@property (nonatomic, strong) NSMutableArray *supplyTypeList;

@end

@implementation SupplierEditView
- (id)init
{
    self = [super init];
    if (self) {
        self.logisticService = [ServiceFactory shareInstance].logisticService;
        self.commonService = [ServiceFactory shareInstance].commonService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    [self configViews];
    [self initMainView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    [self loadMainView];
    [self configHelpButton:HELP_OUTIN_SUPPLIER];
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    
    self.baseTitle = [LSEditItemTitle editItemTitle];
    [self.container addSubview:self.baseTitle];
    
    self.txtSupplyName = [LSEditItemText editItemText];
    [self.container addSubview:self.txtSupplyName];
    
    self.txtShorName = [LSEditItemText editItemText];
    [self.container addSubview:self.txtShorName];
    
    self.txtCode = [LSEditItemText editItemText];
    [self.container addSubview:self.txtCode];
    
    self.lsSupplyType = [LSEditItemList editItemList];
    [self.container addSubview:self.lsSupplyType];
    
    self.txtRelation = [LSEditItemText editItemText];
    [self.container addSubview:self.txtRelation];
    
    self.txtMobile = [LSEditItemText editItemText];
    [self.container addSubview:self.txtMobile];
    
    self.txtPhone = [LSEditItemText editItemText];
    [self.container addSubview:self.txtPhone];
    
    self.txtWechat = [LSEditItemText editItemText];
    [self.container addSubview:self.txtWechat];
    
    self.txtMail = [LSEditItemText editItemText];
    [self.container addSubview:self.txtMail];
    
    self.txtFax = [LSEditItemText editItemText];
    [self.container addSubview:self.txtFax];
    
    self.txtAddress = [LSEditItemText editItemText];
    [self.container addSubview:self.txtAddress];
    
    [LSViewFactor addClearView:self.container y:0 h:20];
    
    self.infoTitle = [LSEditItemTitle editItemTitle];
    [self.container addSubview:self.infoTitle];
    
    self.txtBank = [LSEditItemText editItemText];
    [self.container addSubview:self.txtBank];
    
    self.txtBankAccount = [LSEditItemText editItemText];
    [self.container addSubview:self.txtBankAccount];
    
    self.txtUserName = [LSEditItemText editItemText];
    [self.container addSubview:self.txtUserName];
    
    UIButton *btn = [LSViewFactor addRedButton:self.container title:@"删除" y:0];
    [btn addTarget:self action:@selector(OnDelClick:) forControlEvents:UIControlEventTouchUpInside];
    self.delView = btn.superview;
    
    
}

- (void)loadDataWithId:(NSString *)supplyId withIsWarehouse:(BOOL)isWarehouse withAction:(NSInteger)action callBack:(EditSupplyHandler)handler
{
    self.supplyId = supplyId;
    self.isWarehouse = isWarehouse;
    self.action = action;
    self.supplyHandler = handler;
    self.isEdit = !self.isWarehouse;
}

#pragma mark - 初始化导航栏
- (void)initNavigate
{
    [self configTitle:@"" leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        [self removeNotification];
        [XHAnimalUtil animalEdit:self.navigationController action:self.action];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self save];
    }
}

#pragma mark - 初始化主视图
- (void)initMainView
{
    self.baseTitle.lblName.text = @"基本信息";
    [self.txtSupplyName initLabel:@"供应商名称" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtSupplyName initMaxNum:50];
    [self.txtShorName initLabel:@"供应商简称" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtShorName initMaxNum:20];
    [self.txtCode initLabel:@"供应商编号" withHit:nil isrequest:YES type:UIKeyboardTypeASCIICapable];
    [self.txtCode initMaxNum:20];
    [self.lsSupplyType initLabel:@"类别" withHit:nil isrequest:YES delegate:self];
    [self.txtRelation initLabel:@"联系人" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtRelation initMaxNum:50];
    [self.txtMobile initLabel:@"联系电话" withHit:nil isrequest:NO type:UIKeyboardTypeNumbersAndPunctuation];
    [self.txtMobile initMaxNum:13];
    [self.txtPhone initLabel:@"手机号码" withHit:nil isrequest:YES type:UIKeyboardTypeNumberPad];
    [self.txtPhone initMaxNum:11];
    [self.txtWechat initLabel:@"微信" withHit:nil isrequest:NO type:UIKeyboardTypeASCIICapable];
    [self.txtWechat initMaxNum:50];
    [self.txtMail initLabel:@"邮箱" withHit:nil isrequest:NO type:UIKeyboardTypeEmailAddress];
    [self.txtMail initMaxNum:50];
    [self.txtFax initLabel:@"传真" withHit:nil isrequest:NO type:UIKeyboardTypeNumbersAndPunctuation];
    [self.txtFax initMaxNum:13];
    [self.txtAddress initLabel:@"联系地址" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtAddress initMaxNum:100];
    self.infoTitle.lblName.text = @"账户信息";
    [self.txtBank initLabel:@"开户行" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtBank initMaxNum:50];
    [self.txtBankAccount initLabel:@"银行账户" withHit:nil isrequest:NO type:UIKeyboardTypeNumberPad];
    [self.txtBankAccount initMaxNum:50];
    [self.txtUserName initLabel:@"户名" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtUserName initMaxNum:50];
    [self.txtSupplyName.txtVal addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingDidEnd];
    [self.txtMobile.txtVal addTarget:self action:@selector(textFieldEditingChange:) forControlEvents:UIControlEventEditingChanged];
    [self.txtFax.txtVal addTarget:self action:@selector(textFieldEditingChange:) forControlEvents:UIControlEventEditingChanged];
    self.txtMobile.txtVal.tag = 10;
    self.txtFax.txtVal.tag = 11;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (self.action==ACTION_CONSTANTS_EDIT) {
        return;
    }
    if ([NSString isBlank:[self.txtShorName getStrVal]]||[[self.txtShorName getStrVal] isEqualToString:[self.txtSupplyName getStrVal]]) {
        [self.txtShorName changeData:textField.text];
    }
}

- (void)textFieldEditingChange:(UITextField *)textField
{
    NSString *text = textField.text;
    if (textField.tag==10) {
        if ([text length]==4) {
        }
    }
    
}

#pragma mark - 注册|移除UI变化通知
- (void)registerNotification
{
    [UIHelper initNotification:self.container event:Notification_UI_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_Change object:nil];
}

- (void)dataChange:(NSNotification *)notification
{
    [self editTitle:[UIHelper currChange:self.container] act:self.action];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 页面是否可编辑
- (void)showView
{
    [self.txtSupplyName editEnabled:self.isEdit];
    [self.txtShorName editEnabled:self.isEdit];
    [self.txtCode editEnabled:self.isEdit];
    [self.lsSupplyType editEnable:self.isEdit];
    [self.txtRelation editEnabled:self.isEdit];
    [self.txtMobile editEnabled:self.isEdit];
    [self.txtPhone editEnabled:self.isEdit];
    [self.txtWechat editEnabled:self.isEdit];
    [self.txtMail editEnabled:self.isEdit];
    [self.txtFax editEnabled:self.isEdit];
    [self.txtAddress editEnabled:self.isEdit];
    [self.txtBank editEnabled:self.isEdit];
    [self.txtBankAccount editEnabled:self.isEdit];
    [self.txtUserName editEnabled:self.isEdit];
}

#pragma mark - 设置页面值
- (void)loadMainView
{
    [self showView];
    [self registerNotification];
    if (self.action==ACTION_CONSTANTS_ADD) {
//        self.titleBox.lblTitle.text = @"添加";
        [self configTitle:@"添加供应商"];
        [self clearDo];
    }else{
        [self loadSupplyDetail];
    }
}

//添加模式
- (void)clearDo
{
    self.delView.hidden = YES;
    [self.txtSupplyName initData:nil];
    [self.txtShorName initData:nil];
    [self.txtCode initData:nil];
    [self.lsSupplyType initData:@"请选择" withVal:nil];
    [self.txtRelation initData:nil];
    [self.txtMobile initData:nil];
    [self.txtPhone initData:nil];
    [self.txtWechat initData:nil];
    [self.txtMail initData:nil];
    [self.txtFax initData:nil];
    [self.txtAddress initData:nil];
    [self.txtBank initData:nil];
    [self.txtBankAccount initData:nil];
    [self.txtUserName initData:nil];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

//编辑模式
- (void)loadSupplyDetail
{
    __weak typeof(self) weakSelf = self;
    [self.logisticService selectSupplyDetailById:self.supplyId completionHandler:^(id json) {
        weakSelf.supplyManageVo = [SupplyManageVo converToVo:[json objectForKey:@"supplyManageVo"]];
        [weakSelf configTitle:weakSelf.supplyManageVo.name];
        [weakSelf.txtSupplyName initData:weakSelf.supplyManageVo.name];
        if (weakSelf.isWarehouse) {
            [weakSelf.txtShorName initData:weakSelf.supplyManageVo.name];
        }else{
            [weakSelf.txtShorName initData:weakSelf.supplyManageVo.shortName];
        }
        [weakSelf.txtCode initData:weakSelf.supplyManageVo.code];
        [weakSelf.lsSupplyType initData:weakSelf.supplyManageVo.typeName withVal:weakSelf.supplyManageVo.typeVal];
        [weakSelf.txtRelation initData:weakSelf.supplyManageVo.relation];
        [weakSelf.txtMobile initData:weakSelf.supplyManageVo.mobile];
        [weakSelf.txtPhone initData:weakSelf.supplyManageVo.phone];
        [weakSelf.txtWechat initData:weakSelf.supplyManageVo.weixin];
        [weakSelf.txtMail initData:weakSelf.supplyManageVo.email];
        [weakSelf.txtFax initData:weakSelf.supplyManageVo.fax];
        [weakSelf.txtAddress initData:weakSelf.supplyManageVo.address];
        [weakSelf.txtBank initData:weakSelf.supplyManageVo.bankname];
        [weakSelf.txtBankAccount initData:weakSelf.supplyManageVo.bankcardno];
        [weakSelf.txtUserName initData:weakSelf.supplyManageVo.bankaccountname];
        weakSelf.delView.hidden = weakSelf.isWarehouse;
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark - 选择供应商类别
- (void)onItemListClick:(LSEditItemList *)obj
{
    if (self.supplyTypeList!=nil&&self.supplyTypeList.count>0) {
        [OptionPickerBox initData:self.supplyTypeList itemId:[obj getStrVal]];
        [OptionPickerBox showManager:obj.lblName.text managerName:@"类别管理" client:self event:obj.tag];
    }else{
        __weak typeof(self) weakSelf = self;
        [self.commonService selectSupplyTypeList:^(id json) {
            weakSelf.supplyTypeList = [SupplyTypeVo converToArr:[json objectForKey:@"listMap"]];
            [OptionPickerBox initData:weakSelf.supplyTypeList itemId:[obj getStrVal]];
            [OptionPickerBox showManager:obj.lblName.text managerName:@"类别管理" client:weakSelf event:obj.tag];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameValue> obj = (id<INameValue>)selectObj;
    [self.lsSupplyType changeData:[obj obtainItemName] withVal:[obj obtainItemValue]];
    return YES;
}

- (void)managerOption:(NSInteger)eventType
{
    SupplierKindListView *kindListView = [[SupplierKindListView alloc] init];
    __weak typeof(self) weakSelf = self;
    [kindListView loadDataWithCallBack:^(NSMutableArray *kindList) {
        BOOL isDel = YES;
        for (id<INameValue> obj in kindList) {
            if ([[weakSelf.lsSupplyType getStrVal] isEqualToString:[obj obtainItemValue]]) {
                isDel = NO;
                break;
            }
        }
        weakSelf.supplyTypeList = kindList;
        if (isDel) {
            [weakSelf.lsSupplyType changeData:@"请选择" withVal:nil];
        }
    }];
    [self.navigationController pushViewController:kindListView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

#pragma mark - 验证页面项
- (BOOL)isValide
{
    if ([NSString isBlank:[self.txtSupplyName getStrVal]]) {
        [AlertBox show:@"供应商名称不能为空，请输入!"];
        return NO;
    }
    if ([NSString isBlank:[self.txtShorName getStrVal]]) {
        [AlertBox show:@"供应商简称不能为空，请输入!"];
        return NO;
    }
    if ([NSString isBlank:[self.txtCode getStrVal]]) {
        [AlertBox show:@"供应商编号不能为空，请输入!"];
        return NO;
    }
    if ([NSString isNotNumAndLetter:[self.txtCode getStrVal]]) {
        [AlertBox show:@"供应商编号格式不正确，请重新输入!"];
        return NO;
    }
    if ([NSString isBlank:[self.lsSupplyType getStrVal]]) {
        [AlertBox show:@"请选择供应商类别!"];
        return NO;
    }
    if ([NSString isBlank:[self.txtRelation getStrVal]]) {
        [AlertBox show:@"联系人不能为空，请输入!"];
        return NO;
    }
    if ([NSString isNotBlank:[self.txtMobile getStrVal]]&&![NSString isValidateFax:[self.txtMobile getStrVal]]) {
        [AlertBox show:@"联系电话格式不正确，请重新输入!"];
        return NO;
    }
    if ([NSString isBlank:[self.txtPhone getStrVal]]) {
        [AlertBox show:@"手机号码不能为空，请输入!"];
        return NO;
    }
    if (![NSString validateMobile:[self.txtPhone getStrVal]]) {
        [AlertBox show:@"手机号码格式不正确，请重新输入!"];
        return NO;
    }
    if ([NSString isNotBlank:[self.txtMail getStrVal]]&&![NSString isValidateEmail:[self.txtMail getStrVal]]) {
        [AlertBox show:@"邮箱格式不正确，请重新输入!"];
        return NO;
    }
    if ([NSString isNotBlank:[self.txtFax getStrVal]]&&![NSString isValidateFax:[self.txtFax getStrVal]]) {
        [AlertBox show:@"传真格式不正确，请重新输入!"];
        return NO;
    }
    if ([NSString isBlank:[self.txtAddress getStrVal]]) {
        [AlertBox show:@"联系地址不能为空，请输入!"];
        return NO;
    }
    if ([NSString isNotBlank:[self.txtBankAccount getStrVal]]&&![NSString isValidCreditNumber:[self.txtBankAccount getStrVal]]) {
        [AlertBox show:@"银行账户格式不正确，请重新输入！"];
        return NO;
    }
    return YES;
}

#pragma mark - 数据模型转换
- (SupplyManageVo *)transMode
{
    SupplyManageVo *manageVo = [[SupplyManageVo alloc] init];
    manageVo.name = [self.txtSupplyName getStrVal];
    manageVo.shortName = [self.txtShorName getStrVal];
    manageVo.code = [self.txtCode getStrVal];
    manageVo.typeName = self.lsSupplyType.lblVal.text;
    manageVo.typeVal = [self.lsSupplyType getStrVal];
    manageVo.relation = [self.txtRelation getStrVal];
    manageVo.mobile = [self.txtMobile getStrVal];
    manageVo.phone = [self.txtPhone getStrVal];
    manageVo.weixin = [self.txtWechat getStrVal];
    manageVo.email = [self.txtMail getStrVal];
    manageVo.fax = [self.txtFax getStrVal];
    manageVo.address = [self.txtAddress getStrVal];
    manageVo.bankname = [self.txtBank getStrVal];
    manageVo.bankcardno = [self.txtBankAccount getStrVal];
    manageVo.bankaccountname = [self.txtUserName getStrVal];
    if (self.action==ACTION_CONSTANTS_EDIT) {
        manageVo.supplyId = self.supplyManageVo.supplyId;
        manageVo.entityid = self.supplyManageVo.entityid;
        manageVo.lastver = self.supplyManageVo.lastver;
        manageVo.opuserid = self.supplyManageVo.opuserid;
    }
    return manageVo;
}

#pragma mark - 更新供应商信息
- (void)save
{
    if (![self isValide]) {
        return;
    }
    if (self.action==ACTION_CONSTANTS_ADD) {
        [self addSupply];
    }else{
        [self updateSupply];
    }
}

//添加供应商
- (void)addSupply
{
    __weak typeof(self) weakSelf = self;
    [self.logisticService addSupplyByDic:[SupplyManageVo converToDic:[self transMode]] completionHandler:^(id json) {
        [weakSelf removeNotification];
        weakSelf.supplyHandler(nil,ACTION_CONSTANTS_ADD);
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

//修改供应商
- (void)updateSupply
{
    __weak typeof(self) weakSelf = self;
    [self.logisticService updateSupplyByDic:[SupplyManageVo converToDic:[self transMode]] completionHandler:^(id json) {
        [weakSelf removeNotification];
        SupplyVo *supplyVo = [[SupplyVo alloc] init];
        SupplyManageVo *manageVo = [weakSelf transMode];
        supplyVo.supplyId = manageVo.supplyId;
        supplyVo.supplyName = manageVo.name;
        supplyVo.relation = manageVo.relation;
        supplyVo.phone = manageVo.phone;
        weakSelf.supplyHandler(supplyVo,ACTION_CONSTANTS_EDIT);
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark - 删除供应商
- (void)OnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"删除供应商[%@]吗?",self.supplyManageVo.name]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self delSupply];
    }
}

- (void)delSupply
{
    __weak typeof(self) weakSelf = self;
    [self.logisticService deleteSupplyById:self.supplyManageVo.supplyId withLastver:self.supplyManageVo.lastver completionHandler:^(id json) {
        [weakSelf removeNotification];
        SupplyVo *supplyVo = [[SupplyVo alloc] init];
        supplyVo.supplyId = weakSelf.supplyManageVo.supplyId;
        weakSelf.supplyHandler(supplyVo,ACTION_CONSTANTS_DEL);
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}
@end
