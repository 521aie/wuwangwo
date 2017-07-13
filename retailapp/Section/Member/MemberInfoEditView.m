//
//  MemberInfoEditViewView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/7/14.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberInfoEditView.h"
#import "UIHelper.h"
#import "NavigateTitle2.h"
#import "CardVo.h"
#import "DateUtils.h"
#import "MemberModule.h"
#import "XHAnimalUtil.h"
#import "EditItemList.h"
#import "EditItemRadio.h"
#import "EditItemText.h"
#import "ItemTitle.h"
#import "EditItemImage2.h"
#import "EditItemText2.h"
#import "MemberModuleEvent.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "JsonHelper.h"
#import "MemberRender.h"
#import "OptionPickerBox.h"
#import "Platform.h"
#import "DatePickerBox.h"
#import "MemberInfoListView2.h"
#import "ColorHelper.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "CheckUnit.h"
#import "SymbolNumberInputBox.h"
#import "SignUtil.h"
#import "MemberInfoListView.h"
#import "MemberRechargeList.h"
#import "MemberTransactionList.h"
#import "MemberIntegralList.h"
#import "LSImagePickerController.h"

@interface MemberInfoEditView ()<LSImagePickerDelegate>

@property (nonatomic, strong) MemberService *memberService;
@property (nonatomic, strong) UIImage *memberImage;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *passwordFlg;
@property (nonatomic) BOOL inputFlg;
@property (nonatomic) int fromViewTag;
@property (nonatomic) int action;
@property (nonatomic, strong) CustomerVo *customerVo;
@property (nonatomic, strong) NSString *customerId;
@property (nonatomic, strong) NSString *oldBir;
@property (nonatomic) short companionType;
@property (nonatomic, copy) void(^callBlock)(id obj);/*<<#说明#>>*/
@property (nonatomic, strong) LSImagePickerController *imagePicker;/*<图片选择器>*/
@end


@implementation MemberInfoEditView

- (void)setCallBackBlock:(void (^)(id))block {
    self.callBlock = block;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
           customerId:(NSString *)customerId action:(int)action fromView:(int)fromViewTag {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _customerId = customerId;
        _action = action;
        _fromViewTag = fromViewTag;
        _memberService = [ServiceFactory shareInstance].memberService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNotifaction];
    [self initHead];
    [self initMainView];
    [self loaddatas];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loaddatas {
    
    [self.btnDel setHidden:_action == ACTION_CONSTANTS_ADD];
    if (_action == ACTION_CONSTANTS_EDIT) {
        __weak MemberInfoEditView* weakSelf = self;
        [_memberService selectMemberInfoDetail:_customerId completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            [weakSelf responseSuccess:json];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
        _inputFlg = NO;
    }else{
        if ([[Platform Instance] lockAct:ACTION_CARD_EDIT]) {
            [self.btnDel setHidden:YES];
        }
        _passwordFlg = @"0";
        [self clearDo];
        self.titleBox.lblTitle.text = @"添加";
        self.titleBox.lblRight.hidden = NO;
        self.titleBox.imgMore.hidden = NO;
        _inputFlg = YES;
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
    }
}

- (void)responseSuccess:(id)json
{
    self.customerVo = [JsonHelper dicTransObj:[json objectForKey:@"customer"] obj:[CustomerVo new]];
    _passwordFlg = [json objectForKey:@"passwordFlg"];
    _companionType = [[json objectForKey:@"companionType"] intValue];
    if (_companionType != 0) {
        [self.txtCertificate initLabel:@"身份证" withHit:nil isrequest:YES type:UIKeyboardTypeAlphabet];
    }
    
    self.titleBox.lblRight.hidden = YES;
    self.titleBox.imgMore.hidden = YES;
    self.titleBox.lblTitle.text = self.customerVo.name;
    [self fillModel];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"" backImg:Head_ICON_BACK moreImg:Head_ICON_OK];
    [self.titleDiv addSubview:self.titleBox];
}

- (void)isEdit:(BOOL)flg
{
    if (flg) {
        [self.txtCardCode editEnabled:YES];
        [self.txtMemberName editEnabled:YES];
        [self.lsSex editEnable:YES];
        [self.txtmobile editEnabled:YES];
        [self.lsKindCardName editEnable:YES];
        [self.txtPresentAmount editEnabled:YES];
        [self.txtActiveDate editEnabled:YES];
        [self.txtShop editEnabled:YES];
        [self.lsStatus editEnable:YES];
        [self.txtCertificate editEnabled:YES];
        [self.rdoIsNeedPwd isEditable:YES];
        [self.lsPwd editEnable:YES];
        [self.lsBirthday editEnable:YES];
        [self.txtWeixin editEnabled:YES];
        [self.txtAddress editEnabled:YES];
        [self.txtEmail editEnabled:YES];
        [self.lsZipcode editEnable:YES];
        [self.txtJob editEnabled:YES];
        [self.txtCorporatiion editEnabled:YES];
        [self.txtPost editEnabled:YES];
        [self.txtCarNo editEnabled:YES];
        [self.txtMemo editEnabled:YES];
        [self.imgMember isEditable:YES];
        [self.btnDel setHidden:NO];
    }else {
        [self.txtCardCode editEnabled:NO];
        [self.txtMemberName editEnabled:NO];
        [self.lsSex editEnable:NO];
        [self.txtmobile editEnabled:NO];
        [self.lsKindCardName editEnable:NO];
        [self.txtPresentAmount editEnabled:NO];
        [self.txtActiveDate editEnabled:NO];
        [self.txtShop editEnabled:NO];
        [self.lsStatus editEnable:NO];
        [self.txtCertificate editEnabled:NO];
        [self.rdoIsNeedPwd isEditable:NO];
        [self.lsPwd editEnable:NO];
        [self.lsBirthday editEnable:NO];
        [self.txtWeixin editEnabled:NO];
        [self.txtAddress editEnabled:NO];
        [self.txtEmail editEnabled:NO];
        [self.lsZipcode editEnable:NO];
        [self.txtJob editEnabled:NO];
        [self.txtCorporatiion editEnabled:NO];
        [self.txtPost editEnabled:NO];
        [self.txtCarNo editEnabled:NO];
        [self.txtMemo editEnabled:NO];
        [self.imgMember isEditable:NO];
        [self.btnDel setHidden:YES];
    }
}

- (void)clearDo {
    
    [self.txtBalance visibal:NO];
    
    [self.txtConsumeAmount visibal:NO];
    
    [self.txtPresentAmount visibal:NO];
    
    [self.txtPoint visibal:NO];
    
    [self.lsStatus visibal:NO];
    
    [self.lsPwd visibal:NO];
    
    [self.txtCardCode initData:nil];
    
    [self.txtMemberName initData:nil];
    
    [self.lsSex initData:@"请选择" withVal:@""];
    
    [self.txtmobile initData:nil];
    
    [self.lsKindCardName initData:@"请选择" withVal:@""];
    
    [self.txtActiveDate initData:[DateUtils formateDate2:[NSDate date]]];
    
    [self.txtShop initData:[[Platform Instance] getkey:SHOP_NAME]];
    
    [self.txtCertificate initData:nil];
    
    [self.rdoIsNeedPwd initData:@"0"];
    
    [self.lsPwd initData:@"" withVal:@""];
    self.lsPwd.lblVal.placeholder = @"必填";
    [self.lsPwd.lblVal setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.lsBirthday initData:@"请选择" withVal:@""];
    
    [self.txtWeixin initData:nil];
    
    [self.txtAddress initData:nil];
    
    [self.txtEmail initData:nil];
    
    [self.lsZipcode initData:@"" withVal:@""];
    
    [self.txtJob initData:nil];
    
    [self.txtCorporatiion initData:nil];
    
    [self.txtPost initData:nil];
    
    [self.txtCarNo initData:nil];
    
    [self.txtMemo initData:nil];

    [self.imgMember initView:nil path:nil];
    [self.imgMember.imgAdd setHidden:YES];
    [self.imgMember.lblAdd setHidden:YES];
    [self.imgMember.img setHidden:NO];
    [self.imgMember.img setImage:[UIImage imageNamed:@"img_stuff_male.png"]];
}

- (void)fillModel {
    
    [self.txtBalance visibal:YES];
    
    [self.txtConsumeAmount visibal:YES];
    
    [self.txtPresentAmount visibal:YES];
    
    [self.txtPoint visibal:YES];
    
    [self.lsStatus visibal:YES];
    [self.txtCardCode initLabel:@"会员卡号" withHit:nil isrequest:YES type:UIKeyboardTypeAlphabet];
    [self.txtCardCode initData:self.customerVo.card.code];
    
    [self.txtMemberName initData:self.customerVo.name];
    
    [self.lsSex initData:[MemberRender obtainSex:(int)self.customerVo.sex] withVal:[NSString stringWithFormat:@"%tu", self.customerVo.sex]];
    
    [self.txtmobile initData:self.customerVo.mobile];
    
    [self.lsKindCardName initData:self.customerVo.card.kindCardName withVal:self.customerVo.card.kindCardId];
    
    [self.txtBalance initData:[NSString stringWithFormat:@"%.2f", self.customerVo.card.balance]];
    
    [self.txtConsumeAmount initData:[NSString stringWithFormat:@"%.2f", self.customerVo.card.consumeAmount]];
    
    [self.txtPresentAmount initData:[NSString stringWithFormat:@"%.2f", self.customerVo.giftbalance]];
    
    [self.txtPoint initData:[NSString stringWithFormat:@"%tu", self.customerVo.card.point]];

    [self.txtActiveDate initData:[DateUtils formateTime2:self.customerVo.card.activeDate]];
    if (self.customerVo.card.cardshopname == nil) {
        self.txtShop.txtVal.text = @"";
        self.txtShop.txtVal.placeholder = @"";
    }else {
        [self.txtShop initData:self.customerVo.card.cardshopname];
  
    }
    
    [self.lsStatus initData:[MemberRender obtainCardStatus:self.customerVo.card.status] withVal:self.customerVo.card.status];
    
    [self.txtCertificate initData:self.customerVo.certificate];
    
    if ([_passwordFlg isEqualToString:@"0"]) {
        [self.rdoIsNeedPwd initData:@"0"];
        [self.lsPwd visibal:NO];
        self.lsPwd.lblVal.placeholder = @"必填";
        [self.lsPwd.lblVal setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    }else{
        [self.rdoIsNeedPwd initData:@"1"];
        [self.lsPwd visibal:YES];
        self.lsPwd.lblVal.placeholder = @"修改";
        [self.lsPwd.lblVal setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    }
    
    [self.lsPwd initData:@"" withVal:@""];
    
    if (self.customerVo.birthday == 0) {
        [self.lsBirthday initData:@"请选择" withVal:@""];
    }else{
        [self.lsBirthday initData:[DateUtils formateTime2:[self.customerVo.birthday longLongValue]] withVal:[DateUtils formateTime2:[self.customerVo.birthday longLongValue]]];
    }
    
    [self.txtWeixin initData:self.customerVo.weixin];
    
    [self.txtAddress initData:self.customerVo.address];
    
    [self.txtEmail initData:self.customerVo.email];
    
    [self.lsZipcode initData:self.customerVo.zipcode withVal:self.customerVo.zipcode];
    
    [self.txtJob initData:self.customerVo.job];
    
    [self.txtCorporatiion initData:self.customerVo.company];
    
    [self.txtPost initData:self.customerVo.pos];
    
    [self.txtCarNo initData:self.customerVo.licenseplateno];
    
    [self.txtMemo initData:self.customerVo.memo];
    
    if ([NSString isNotBlank:self.customerVo.fileName]) {
        [self.imgMember initView:self.customerVo.fileName path:self.customerVo.fileName];
    }else {
        [self.imgMember initView:nil path:nil];
        [self.imgMember.imgAdd setHidden:YES];
        [self.imgMember.lblAdd setHidden:YES];
        [self.imgMember.img setHidden:NO];
        if (_customerVo.sex == 2) {
            [self.imgMember.img setImage:[UIImage imageNamed:@"img_stuff_female.png"]];
        } else {
            [self.imgMember.img setImage:[UIImage imageNamed:@"img_stuff_male.png"]];
        }
        
    }

    if ([[Platform Instance] lockAct:ACTION_CARD_EDIT]) {
        [self isEdit:NO];
    }
    
    if ([[Platform Instance] lockAct:ACTION_CARD_CHARGE_SEARCH]) {
        [self.txtBalance initLabel:@"卡内余额(元)" withHit:nil withType:@"" showTag:MEMBER_INFO_EDIT_RECHARGE_BUTTON delegate:self];
    }
    
    if ([[Platform Instance] lockAct:ACTION_MEMBER_CONSUMPTION_SEARCH]) {
        [self.txtConsumeAmount initLabel:@"累计消费(元)" withHit:nil withType:@"" showTag:MEMBER_INFO_EDIT_DEAL_RECORD_SEARCH_BUTTON delegate:self];
    }
    
    if ([[Platform Instance] lockAct:ACTION_MEMBER_EXCHANGE_SEARCH]) {
        [self.txtPoint initLabel:@"卡内积分" withHit:nil withType:@"" showTag:MEMBER_INFO_EDIT_EXCHANGE_GOODS_BUTTON delegate:self];
    }
    
    // 从【他的会员】页面入口进入时，为不可编辑状态
    if ([self.isFromSubCustomerList isEqualToString:@"1"]) {
        self.imgMember.isShow = NO;
        [self isEdit:NO];
    }
}

- (void)initMainView {
    
    self.TitBaseInfo.lblName.text = @"基本信息";
    
    [self.txtCardCode initLabel:@"会员卡号" withHit:nil isrequest:NO type:UIKeyboardTypeAlphabet];
    [self.txtCardCode initMaxNum:32];
    
    [self.txtMemberName initLabel:@"会员名" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtMemberName initMaxNum:50];
    
    [self.lsSex initLabel:@"性别" withHit:nil delegate:self];
    
    [self.txtmobile initLabel:@"手机号码" withHit:nil isrequest:YES type:UIKeyboardTypeNumberPad];
    [self.txtmobile initMaxNum:11];
    
    [self.lsKindCardName initLabel:@"卡类型" withHit:nil delegate:self];
    
    [self.txtBalance initLabel:@"卡内余额(元)" withHit:nil withType:@"充值记录查询" showTag:MEMBER_INFO_EDIT_RECHARGE_BUTTON delegate:self];
    self.txtBalance.txtVal.enabled = NO;
    self.txtBalance.txtVal.textColor = [ColorHelper getTipColor6];
    
    [self.txtConsumeAmount initLabel:@"累计消费(元)" withHit:nil withType:@"交易记录查询" showTag:MEMBER_INFO_EDIT_DEAL_RECORD_SEARCH_BUTTON delegate:self];
    self.txtConsumeAmount.txtVal.enabled = NO;
    self.txtConsumeAmount.txtVal.textColor = [ColorHelper getTipColor6];
    
    [self.txtPresentAmount initLabel:@"累计赠送(元)" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtPresentAmount editEnabled:NO];
    
    [self.txtPoint initLabel:@"卡内积分" withHit:nil withType:@"兑换记录查询" showTag:MEMBER_INFO_EDIT_EXCHANGE_GOODS_BUTTON delegate:self];
    self.txtPoint.txtVal.enabled = NO;
    self.txtPoint.txtVal.textColor = [ColorHelper getTipColor6];
    
    [self.txtActiveDate initLabel:@"开卡日期" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtActiveDate editEnabled:NO];
    
    [self.txtShop initLabel:@"开卡门店" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtShop editEnabled:NO];
    
    [self.lsStatus initLabel:@"卡状态" withHit:nil delegate:self];
    
    self.TitExtendedInfo.lblName.text = @"扩展信息";
    
    [self.txtCertificate initLabel:@"身份证" withHit:nil isrequest:NO type:UIKeyboardTypeAlphabet];
    [self.txtCertificate initMaxNum:18];
    
    [self.rdoIsNeedPwd initLabel:@"储值消费密码" withHit:@"提醒：开启后密码默认为生日月日，如0801" delegate:self];
    
    [self.lsPwd initLabel:@"▪︎ 消费密码" withHit:nil isrequest:YES delegate:self];
    [self.lsPwd.lblVal setTextColor:[ColorHelper getTipColor6]];
    self.lsPwd.lblVal.secureTextEntry = YES;
    
    [self.lsBirthday initLabel:@"生日" withHit:nil delegate:self];
    
    [self.txtWeixin initLabel:@"微信" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtWeixin initMaxNum:50];
    
    [self.txtAddress initLabel:@"联系地址" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtAddress initMaxNum:100];
    
    [self.txtEmail initLabel:@"邮箱" withHit:nil isrequest:NO type:UIKeyboardTypeEmailAddress];
    [self.txtEmail initMaxNum:50];
    
    [self.lsZipcode initLabel:@"邮编" withHit:nil delegate:self];

    
    [self.txtJob initLabel:@"职业" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtJob initMaxNum:50];
    
    [self.txtCorporatiion initLabel:@"公司" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtCorporatiion initMaxNum:50];
    
    [self.txtPost initLabel:@"职务" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtPost initMaxNum:50];
    
    [self.txtCarNo initLabel:@"车牌号" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtCarNo initMaxNum:10];
    
    [self.txtMemo initLabel:@"备注" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtMemo initMaxNum:100];
    
    [self.imgMember initLabel:@"会员头像" delegate:self title:@"会员头像"];
    self.imgMember.lblAdd.text = @"上传头像";
    
    self.lsSex.tag = MEMBER_INFO_EDIT_SEX;
    self.lsKindCardName.tag = MEMBER_INFO_EDIT_KINSCARDNAME;
    self.lsStatus.tag = MEMBER_INFO_EDIT_STATUS;
    self.lsBirthday.tag = MEMBER_INFO_EDIT_BIRTHDAY;
    self.rdoIsNeedPwd.tag = MEMBER_INFO_EDIT_ISPWD;
    self.lsZipcode.tag = MEMBER_INFO_EDIT_ZIPCODE;
    self.lsPwd.tag = MEMBER_INFO_EDIT_PWD;
}

- (void)onItemListClick:(EditItemList *)obj {
    
    if (obj.tag == MEMBER_INFO_EDIT_SEX) {
        [OptionPickerBox initData:[MemberRender listSex]itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }else if (obj.tag == MEMBER_INFO_EDIT_KINSCARDNAME){
        __weak MemberInfoEditView* weakSelf = self;
        [_memberService selectKindCardList:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            NSMutableArray* list= [JsonHelper transList:[json objectForKey:@"kindCardList"] objName:@"KindCardVo"];
            [OptionPickerBox initData:[MemberRender listKindCardName2:list]itemId:[obj getStrVal]];
            [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }else if (obj.tag == MEMBER_INFO_EDIT_STATUS){
        [OptionPickerBox initData:[MemberRender listCardStatus2]itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }else if (obj.tag == MEMBER_INFO_EDIT_BIRTHDAY){
        NSDate *date=[DateUtils parseDateTime4:obj.lblVal.text];
        if (date == nil) {
            date=[DateUtils parseDateTime4:@"1985-01-01"];
        }
        [DatePickerBox showClear:@"生日" clearName:@"清除日期" date:date client:self event:MEMBER_INFO_EDIT_BIRTHDAY];
        [DatePickerBox setMinimumDate:[DateUtils parseDateTime4:@"1960-01-01"]];
    }else if (obj.tag == MEMBER_INFO_EDIT_ZIPCODE){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:0];
    }else if (obj.tag == MEMBER_INFO_EDIT_PWD){
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:0];
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)clearDate:(NSInteger)eventType
{
    if (eventType == MEMBER_INFO_EDIT_BIRTHDAY) {
        [self.lsBirthday changeData:@"请选择" withVal:@""];
    }
}

// 拾取器值更改
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == MEMBER_INFO_EDIT_SEX) {
        [self.lsSex changeData:[item obtainItemName] withVal:[item obtainItemId]];
        if ([NSString isBlank:[self.imgMember getImageFilePath]]) {
            if ([[item obtainItemId] isEqualToString:@"1"]) {
                [self.imgMember.img setImage:[UIImage imageNamed:@"img_stuff_male.png"]];
            } else if ([[item obtainItemId] isEqualToString:@"2"]) {
                [self.imgMember.img setImage:[UIImage imageNamed:@"img_stuff_female.png"]];
            }
        }
    }else if (eventType == MEMBER_INFO_EDIT_KINSCARDNAME){
        [self.lsKindCardName changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if (eventType == MEMBER_INFO_EDIT_STATUS){
        [self.lsStatus changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    return YES;
}

//选择日期
- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event
{
    
    if (event == MEMBER_INFO_EDIT_BIRTHDAY) {
         NSString* dateStr=[DateUtils formateDate2:date];
        [self.lsBirthday changeData:dateStr withVal:dateStr];
        
        NSArray *array = [dateStr componentsSeparatedByString:@"-"];
        NSString* pwd = [[array objectAtIndex:1] stringByAppendingString:[array objectAtIndex:2]];
        if (_inputFlg) {
            if (![self.rdoIsNeedPwd getVal]) {//储值消费密码开关打开时选择生日是密码才默认是生日
                [self.lsPwd initData:pwd withVal:pwd];
            }
            
        }
    }
    
    return YES;
}

#pragma mark - SymbolNumberInputClient协议
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    if (eventType == MEMBER_INFO_EDIT_ZIPCODE) {
        if ([NSString isBlank:val]) {
            val = @"";
            
        }else{
            
            val = [NSString stringWithFormat:@"%.d",val.intValue];
        }
        [self.lsZipcode changeData:val withVal:val];
        
    }else if (eventType == MEMBER_INFO_EDIT_PWD){
        if ([NSString isBlank:val]) {
            val = @"";
            
        } else{
            
            val = [NSString stringWithFormat:@"%.d",val.intValue];
        }
        [self.lsPwd changeData:val withVal:val];
        _inputFlg = YES;
    }
    
}

// Radio控件变换.
- (void)onItemRadioClick:(EditItemRadio*)obj
{
    BOOL result = [[obj getStrVal] isEqualToString:@"1"];
    
    if (obj.tag == MEMBER_INFO_EDIT_ISPWD) {
        if (result) {
            [self.lsPwd visibal:YES];
            if (!_inputFlg) {
                if (![NSString isBlank:[self.lsBirthday getStrVal]]) {
                    NSArray *array = [[self.lsBirthday getStrVal] componentsSeparatedByString:@"-"];
                    NSString* pwd = [[array objectAtIndex:1] stringByAppendingString:[array objectAtIndex:2]];
                    [self.lsPwd initData:pwd withVal:pwd];
                }
            }
        }else{
            [self.lsPwd visibal:NO];
        }
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma mark 跳转到3个记录查询页面
- (void)showButtonTag:(NSInteger)tag {
    
    if (tag == MEMBER_INFO_EDIT_RECHARGE_BUTTON) {
        if ([[Platform Instance] lockAct:ACTION_CARD_CHARGE_SEARCH]) {
            [AlertBox show:@"暂无权限查询会员充值记录!"];
            return ;
        }
        // 充值记录查询按钮
        MemberRechargeList* vc = [[MemberRechargeList alloc] initWithNibName:[SystemUtil getXibName:@"MemberRechargeList"] bundle:nil];
        NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
        [param setObject:_customerVo.mobile forKey:@"mobile"];
        [param setObject:[NSString stringWithFormat:@"%lld", [DateUtils converStartTime:@"本月"]] forKey:@"beginDate"];
        [param setObject:[NSString stringWithFormat:@"%lld", [DateUtils converEndTime:@"本月"]] forKey:@"endDate"];
        [param setObject:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
        vc.param = param;
        vc.exportParam = param;
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [self.navigationController pushViewController:vc animated:NO];
        
    }else if (tag == MEMBER_INFO_EDIT_DEAL_RECORD_SEARCH_BUTTON){
        if ([[Platform Instance] lockAct:ACTION_MEMBER_CONSUMPTION_SEARCH]) {
            [AlertBox show:@"暂无权限查询会员交易记录!"];
            return ;
        }
        // 交易记录查询按钮
        MemberTransactionList* vc = [[MemberTransactionList alloc] initWithNibName:[SystemUtil getXibName:@"MemberTransactionList"] bundle:nil];
        NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
        [param setObject:_customerVo.mobile forKey:@"mobile"];
        [param setObject:[NSString stringWithFormat:@"%lld", [DateUtils converStartTime:@"本月"]] forKey:@"dateFrom"];
        [param setObject:[NSString stringWithFormat:@"%lld", [DateUtils converEndTime:@"本月"]] forKey:@"dateTo"];
         [param setObject:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
        vc.param = param;
        vc.exportParam = param;
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [self.navigationController pushViewController:vc animated:NO];
    }else if (tag == MEMBER_INFO_EDIT_EXCHANGE_GOODS_BUTTON){
        if ([[Platform Instance] lockAct:ACTION_MEMBER_EXCHANGE_SEARCH]) {
            [AlertBox show:@"暂无权限查询会员积分兑换记录!"];
            return ;
        }
        // 兑换记录查询按钮
        MemberIntegralList* vc = [[MemberIntegralList alloc] initWithNibName:[SystemUtil getXibName:@"MemberTransactionList"] bundle:nil];
        NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
        [param setObject:_customerVo.mobile forKey:@"mobile"];
        [param setObject:[NSString stringWithFormat:@"%lld", [DateUtils converStartTime:@"本月"]] forKey:@"dateFrom"];
        [param setObject:[NSString stringWithFormat:@"%lld", [DateUtils converEndTime:@"本月"]] forKey:@"dateTo"];
         [param setObject:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
        vc.param = param;
        vc.exportParam = param;
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [self.navigationController pushViewController:vc animated:NO];
    }
}

#pragma notification 处理.
- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_MemberInfoEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_MemberInfoEditView_Change object:nil];
}

#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification*) notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
}

- (void)onNavigateEvent:(Direct_Flag)event
{
    if (event==1) {
        if (self.action == ACTION_CONSTANTS_ADD) {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        } else {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self save];
    }
}

#pragma save-data
- (BOOL)isValid
{
    if (_action == ACTION_CONSTANTS_EDIT && [NSString isBlank:[self.txtCardCode getStrVal]]) {
        [AlertBox show:@"会员卡号不能为空，请输入!"];
        return NO;
    }
    
    if ([NSString isNotBlank:[self.txtCardCode getStrVal]] && ([self.txtCardCode getStrVal].length < 4 ||[self.txtCardCode getStrVal].length > 32)) {
        [AlertBox show:@"会员卡号长度必须在4到32位之间，请重新输入!"];
        return NO;
    }
    
    if ([NSString isNotBlank:[self.txtCardCode getStrVal]] && [NSString isNotNumAndLetter:[self.txtCardCode getStrVal]]) {
        [AlertBox show:@"会员卡号必须为英数字，请重新输入!"];
        return NO;
    }
    
    if ([NSString isBlank:[self.txtMemberName getStrVal]]) {
        [AlertBox show:@"会员名不能为空，请输入!"];
        return NO;
    } else if ([self.txtMemberName getStrVal].length > 50) {
        [AlertBox show:@"会员名长度不能大于50，请重新输入!"];
        return NO;
    }
    
    if ([[self.lsSex getStrVal] isEqualToString:@""]) {
        [AlertBox show:@"请选择性别!"];
        return NO;
    }
    
    if ([NSString isBlank:[self.txtmobile getStrVal]]) {
        [AlertBox show:@"手机号码不能为空，请输入!"];
        return NO;
    }else if ([self.txtmobile getStrVal].length != 11){
        [AlertBox show:@"请输入正确的手机号!"];
        return NO;
    } else if (![NSString validateMobile:[self.txtmobile getStrVal]]) {
        [AlertBox show:@"请输入正确的手机号!"];
        return NO;
    }
    
    if ([[self.lsKindCardName getStrVal] isEqualToString:@""]) {
        [AlertBox show:@"请选择卡类型!"];
        return NO;
    }
    
    if (_companionType != 0 && [NSString isBlank:[self.txtCertificate getStrVal]]) {
        switch (_companionType) {
            case 1:
                [AlertBox show:@"大伙伴会员身份证号码不能为空，请输入!"];
                return NO;
                break;
            case 2:
                [AlertBox show:@"伙伴会员身份证号码不能为空，请输入!"];
                return NO;
                break;
            case 3:
                [AlertBox show:@"小伙伴会员身份证号码不能为空，请输入!"];
                return NO;
                break;
            default:
                break;
        }
    }
    
    if (![[self.txtCertificate getStrVal] isEqualToString:@""]) {
        if ([self.txtCertificate getStrVal].length != 15 && [self.txtCertificate getStrVal] .length != 18) {
            [AlertBox show:@"请输入正确的身份证号码!"];
            return NO;
        }else if (![CheckUnit validateIDCardNumber:[self.txtCertificate getStrVal]]){
            [AlertBox show:@"请输入正确的身份证号码!"];
            return NO;
        }
    }
    if (![self.lsPwd.lblVal.placeholder isEqualToString:@"修改"]) {
        if (self.lsPwd.hidden == NO && [NSString isBlank:self.lsPwd.lblVal.text]) {
            [AlertBox show:@"请输入消费密码!"];
            return NO;
        }
    }
    
    
    if (![[self.txtEmail getStrVal] isEqualToString:@""] && ![CheckUnit validateEmail:[self.txtEmail getStrVal]]) {
        [AlertBox show:@"请输入正确的邮箱!"];
        return NO;
    }
    
    return YES;
}

- (void)save
{
    if (![self isValid]){
        return;
    }
    
    // 添加新会员
    if (self.action == ACTION_CONSTANTS_ADD) {
        
        self.customerVo = [[CustomerVo alloc] init];
        self.customerVo.card = [[CardVo alloc] init];
        self.customerVo.cardCode = [self.txtCardCode getStrVal];
        self.customerVo.name = [self.txtMemberName getStrVal];
        self.customerVo.sex = [self.lsSex getStrVal].intValue;
        self.customerVo.mobile = [self.txtmobile getStrVal];
        self.customerVo.card.kindCardId = [self.lsKindCardName getStrVal];
        self.customerVo.card.kindCardName = self.lsKindCardName.lblVal.text;
        self.customerVo.card.code = [self.txtCardCode getStrVal];
        self.customerVo.card.status = @"1";
        self.customerVo.card.cardshopid = [[Platform Instance] getkey:SHOP_ID];
        self.customerVo.card.activeDate = [DateUtils formateDateTime3:[DateUtils formateDate2:[NSDate date]]];
        self.customerVo.certificate = [self.txtCertificate getStrVal];
        if ([[self.rdoIsNeedPwd getStrVal] isEqualToString:@"0"]) {
            self.customerVo.pwd = @"";
        }else{
            self.customerVo.pwd = [SignUtil convertPassword:[self.lsPwd getStrVal]];
        }
        if ([NSString isBlank:[self.lsBirthday getStrVal]]) {
            self.customerVo.birthday = 0;
        }else{
            self.customerVo.birthday = [NSNumber numberWithLongLong:[DateUtils formateDateTime2:[NSString stringWithFormat:@"%@ 00:00:00", [self.lsBirthday getStrVal]]]];
        }
        
        self.customerVo.weixin = [self.txtWeixin getStrVal];
        self.customerVo.address = [self.txtAddress getStrVal];
        self.customerVo.zipcode = [self.lsZipcode getStrVal];
        self.customerVo.email = [self.txtEmail getStrVal];
        self.customerVo.job = [self.txtJob getStrVal];
        self.customerVo.company = [self.txtCorporatiion getStrVal];
        self.customerVo.pos = [self.txtPost getStrVal];
        self.customerVo.licenseplateno = [self.txtCarNo getStrVal];
        self.customerVo.memo = [self.txtMemo getStrVal];
        
        if ([NSString isNotBlank:self.customerVo.fileName]&&[NSString isBlank:[self.imgMember getImageFilePath]]) {
            
            self.customerVo.fileOperate = 0;
            
        }else if([NSString isNotBlank:[self.imgMember getImageFilePath]]&&![self.customerVo.fileName isEqualToString:[self.imgMember getImageFilePath]]){
            
            self.customerVo.fileOperate = 1;
            self.customerVo.fileName = _fileName;
            
            NSData *data = UIImageJPEGRepresentation(_memberImage, 0.1);
            NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
            self.customerVo.file = base64Encoded;
            
        }else {
            
            self.customerVo.fileOperate = 2;
        }
        
        __weak MemberInfoEditView* weakSelf = self;
        [_memberService saveMemberInfo:@"add" passwordFlg:[self.rdoIsNeedPwd getStrVal] doCheck:@"true" customer:self.customerVo completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            
            BOOL flg = [[json objectForKey:@"saveResult"] boolValue];
            if (!flg) {
                [self show:@"相同手机号码的会员（卡状态：非正常）已存在，是否继续？"];
            }else{
                
                if (self.fromViewTag == MEMBER_INFO_LIST_VIEW) {
                   
                    if (self.callBlock) {
                        self.callBlock(nil);
                    }
                }else if (self.fromViewTag == MEMBER_INFO_LIST_VIEW2) {
                    
                    if (self.callBlock) {
                        self.callBlock(nil);
                    }
                }
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                [self.navigationController popViewControllerAnimated:NO];
            }
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
        
    }else if (self.action == ACTION_CONSTANTS_EDIT) {
        
        self.customerVo.name = [self.txtMemberName getStrVal];
        self.customerVo.sex = [self.lsSex getStrVal].intValue;
        self.customerVo.mobile = [self.txtmobile getStrVal];
        self.customerVo.card.code = [self.txtCardCode getStrVal];
        self.customerVo.card.kindCardId = [self.lsKindCardName getStrVal];
        self.customerVo.card.kindCardName = self.lsKindCardName.lblVal.text;
        self.customerVo.card.status = [self.lsStatus getStrVal];
        self.customerVo.certificate = [self.txtCertificate getStrVal];
        if ([[self.rdoIsNeedPwd getStrVal] isEqualToString:@"0"]) {
            self.customerVo.pwd = @"";
        }else {
            self.customerVo.pwd = [SignUtil convertPassword:[self.lsPwd getStrVal]];
            
        }
        if ([NSString isBlank:[self.lsBirthday getStrVal]]) {
            self.customerVo.birthday = 0;
        }else{
            self.customerVo.birthday = [NSNumber numberWithLongLong:[DateUtils formateDateTime2:[NSString stringWithFormat:@"%@ 00:00:00", [self.lsBirthday getStrVal]]]];
        }
        self.customerVo.weixin = [self.txtWeixin getStrVal];
        self.customerVo.address = [self.txtAddress getStrVal];
        self.customerVo.zipcode = [self.lsZipcode getStrVal];
        self.customerVo.email = [self.txtEmail getStrVal];
        self.customerVo.job = [self.txtJob getStrVal];
        self.customerVo.company = [self.txtCorporatiion getStrVal];
        self.customerVo.pos = [self.txtPost getStrVal];
        self.customerVo.licenseplateno = [self.txtCarNo getStrVal];
        self.customerVo.memo = [self.txtMemo getStrVal];
        
        
        if ([NSString isNotBlank:self.customerVo.fileName]&&[NSString isBlank:[self.imgMember getImageFilePath]]) {
            
            self.customerVo.fileOperate = 0;
            
        }else if([NSString isNotBlank:[self.imgMember getImageFilePath]]&&![self.customerVo.fileName isEqualToString:[self.imgMember getImageFilePath]]){
            
            self.customerVo.fileOperate = 1;
            self.customerVo.fileName = _fileName;
            
            NSData *data = UIImageJPEGRepresentation(_memberImage, 0.1);
            NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
            self.customerVo.file = base64Encoded;
            
        }else {
            
            self.customerVo.fileOperate = 2;
        }
        
        __weak MemberInfoEditView* weakSelf = self;
        [_memberService saveMemberInfo:@"edit" passwordFlg:[self.rdoIsNeedPwd getStrVal] doCheck:@"true" customer:self.customerVo completionHandler:^(id json) {
           
            if (!(weakSelf)) {
                return ;
            }
            
            if (self.fromViewTag == MEMBER_INFO_LIST_VIEW2) {
                if (self.callBlock) {
                     self.callBlock(_customerVo);
                }
            }
            
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

- (void)show:(NSString *)message
{
    static UIAlertView *alertView;
    if (alertView != nil) {
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
        alertView = nil;
    }
    
    alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        __weak MemberInfoEditView* weakSelf = self;
        [_memberService saveMemberInfo:@"add" passwordFlg:[self.rdoIsNeedPwd getStrVal] doCheck:@"false" customer:self.customerVo completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[MemberInfoListView2 class]]) {
                    MemberInfoListView2 *listView = (MemberInfoListView2 *)vc;
//                    [listView loaddatesFromEdit:nil action:ACTION_CONSTANTS_ADD];
                    [listView.mainGrid headerBeginRefreshing];
                }
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

-(IBAction)delClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"确认要删除[%@]吗？",self.customerVo.name]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        __weak MemberInfoEditView* weakSelf = self;
        [_memberService delMemberInfo:self.customerVo.customerId cardId:self.customerVo.card.cardId completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[MemberInfoListView2 class]]) {
                    MemberInfoListView2 *listView = (MemberInfoListView2 *)vc;
                    [listView loaddatesFromEdit:_customerVo action:ACTION_CONSTANTS_DEL];
                    [listView.mainGrid headerBeginRefreshing];
                }
            }
            
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
       
    }
}


#pragma mark - logo图片处理

- (void)onDelImgClick
{
    [self.imgMember changeImg:@"" img:nil];
    [self.imgMember.imgAdd setHidden:YES];
    [self.imgMember.lblAdd setHidden:YES];
    [self.imgMember.img setHidden:NO];
    if ([[self.lsSex getStrVal] isEqualToString:@"2"]) {
        [self.imgMember.img setImage:[UIImage imageNamed:@"img_stuff_female.png"]];
    } else {
        [self.imgMember.img setImage:[UIImage imageNamed:@"img_stuff_male.png"]];
    }
}

- (void)onConfirmImgClick:(NSInteger)btnIndex
{
    if (btnIndex == 1) {
        [self showImagePickerController:UIImagePickerControllerSourceTypeCamera];
    }else if(btnIndex == 0){
        [self showImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}


// LSImagePickerController, 选择处理照片
- (void)showImagePickerController:(UIImagePickerControllerSourceType)type {
    
    _imagePicker = [LSImagePickerController showImagePickerWith:type presenter:self];
    _imagePicker.cropSize = CGSizeMake(128, 128);
}

// LSImagePickerDelegate
- (void)imagePicker:(LSImagePickerController *)controller pickerImage:(UIImage *)image {
    
    _memberImage = image;
    if (_memberImage!=nil) {
        _fileName = [NSString stringWithFormat:@"%@.png" ,[NSString getUniqueStrByUUID]];
        [self.imgMember changeImg:_fileName img:_memberImage];
    }
    _imagePicker = nil;
}

- (void)imagePickerDidCancel:(LSImageMessageType)message {
    
    if (message == LSImageMessageNoSupportCamera) {
        [AlertBox show:@"相机好像不能用哦!"];
    }else if (message == LSImageMessageNoSupportPhotoLibrary) {
        [AlertBox show:@"相册好像不能访问哦!"];
    }
    _imagePicker = nil;
}


@end
