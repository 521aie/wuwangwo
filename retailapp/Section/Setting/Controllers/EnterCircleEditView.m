//
//  EnterCircleEditView.m
//  retailapp
//
//  Created by qingmei on 15/12/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "EnterCircleEditView.h"
#import "ServiceFactory.h"
#import "LSEditItemTitle.h"
#import "LSEditItemText.h"
#import "EditItemText2.h"
#import "LSEditItemList.h"
#import "LsEditItemRadio.h"
#import "EditItemImage2.h"
#import "XHAnimalUtil.h"
#import "ESPShopVo.h"
#import "ESPShopIntro.h"
#import "ESPSettledMallVo.h"
#import "ObjectUtil.h"
#import "AlertBox.h"
#import "Platform.h"
#import "UIHelper.h"
#import "OptionPickerBox.h"
#import "NameItemVO.h"
#import "SymbolNumberInputBox.h"
#import "NSString+Estimate.h"
#import "DatePickerBox.h"
#import "DateUtils.h"
#import "EditImageBox.h"
#import "ImageVo.h"
#import "EnterCircleListView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ColorHelper.h"
#import "ShopInfoVO.h"
#import "SelectItemList.h"

#define ITEM_TAG_SELECT_CODE 999
#define TAG_LST_BANK 1
#define TAG_LST_PROVINCE 2
#define TAG_LST_CITY 3
#define TAG_LST_SUB_BANK 4
#define TAG_LST_BANK_NUMBER 5
#define TAG_LST_PAYDAY 6
#define TAG_LST_SETTLEMENT_RATIO 7
#define TAG_LST_MEMBER_RATIO 8
#define TAG_LST_DUEDATE 9


@interface EnterCircleEditView ()<EditItemText2Delegate,IEditItemImageEvent,IEditItemListEvent,IEditItemRadioEvent,OptionPickerClient,SymbolNumberInputClient,DatePickerClient,IEditItemImageEvent>
@property (strong, nonatomic) UIScrollView     *scroll;
@property (strong, nonatomic) UIView           *container;

@property (strong, nonatomic) LSEditItemTitle        *itemTitleMallIfno;//商圈信息
@property (strong, nonatomic) EditItemText2    *itemTxtMallInfo;//商圈编号
@property (strong, nonatomic) LSEditItemText     *itemTxtMallName;//商圈名
@property (strong, nonatomic) LSEditItemText     *itemTxtLinkMan;//联系人
@property (strong, nonatomic) LSEditItemText     *itemTxtLinkTel;//联系电话
@property (strong, nonatomic) LSEditItemText     *itemTxtAccountantDate;//会计期



@property (strong, nonatomic) LSEditItemTitle        *itemTitleAccountInfo;//结账信息
@property (strong, nonatomic) LSEditItemText     *txtName;//持卡人
@property (strong, nonatomic) LSEditItemList     *lstBank;//开户银行
@property (strong, nonatomic) LSEditItemList     *lstProvince;//开户省份
@property (strong, nonatomic) LSEditItemList     *lstCity;//开户城市
@property (strong, nonatomic) LSEditItemList     *lstSubBank;//开户支行
@property (strong, nonatomic) LSEditItemList     *lstBankNumber;//银行账号

@property (strong, nonatomic) LSEditItemTitle        *itemTitleProtocolInfo;//协议信息
@property (strong, nonatomic) LSEditItemText     *itemTxtProtocolCode;//协议编号
@property (strong, nonatomic) EditImageBox     *itemTxtProtocolPic;//协议照片
@property (strong, nonatomic) LSEditItemList     *itemListDueDate;//到期时间
@property (strong, nonatomic) LSEditItemList     *itemListPayDate;//结算周期
@property (strong, nonatomic) LSEditItemRadio    *itemRadioIsAllowCheck;//是否允许查看营业数据
@property (strong, nonatomic) LSEditItemList     *itemListMemberDisscount;//会员消费折扣
@property (strong, nonatomic) LSEditItemList     *itemListPoundage;//园区结算手续费

@property (strong, nonatomic) LSEditItemList *linesLstSubBank;

@property (strong, nonatomic) LSEditItemTitle        *itemTitleParkReturn;//园区反馈
@property (strong, nonatomic) LSEditItemText     *itemTxtReturnInfo;//反馈信息

@property (strong, nonatomic) UIView *buttionDiv;
@property (strong, nonatomic) UIButton *button;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(id)parent applyType:(NSInteger)type;

@property (strong, nonatomic) UILabel *lblDetail;
@property (nonatomic, strong) id                    parent;
@property (nonatomic, assign) NSInteger             applyType;
@property (nonatomic, strong) SettingService        *service;
@property (nonatomic, strong) OtherService          *otherService;
@property (nonatomic, strong) NSMutableArray        *shopList;
@property (nonatomic, strong) ESPShopVo             *shopInfo;//申请入住商家的信息 ..每次进页面时使用
@property (nonatomic, strong) ESPShopIntro          *shopIntro;//商圈信息..申请时使用
@property (nonatomic, strong) ESPSettledMallVo      *settledMallVo;//商圈信息..申请中、被拒绝、成功时使用
@property (nonatomic, strong) NSMutableDictionary   *settledMallParam; //申请入驻请求需要的参数

@property (nonatomic, strong) NSMutableArray *pickImgList;
@property (nonatomic, strong) UIImage *goodsImage;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) NSString* imgFilePathTemp;

@property (nonatomic, strong) NSMutableArray *changeImgList;
@end

@implementation EnterCircleEditView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    [self configViews];
    [self initMainView];
    [self loadSelfInfo];
    [self loadDetailData];
    
    [UIHelper refreshPos:self.container scrollview:self.scroll];
}

- (id)initWithParent:(id)parent applyType:(NSInteger)type{
    self = [super init];
    if (self) {
        self.parent = parent;
        self.service = [ServiceFactory shareInstance].settingService;
        self.applyType = type;
        self.otherService = [ServiceFactory shareInstance].otherService;
        
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
        _imagePickerController.allowsEditing = YES;
        _imagePickerController.delegate = self;
        _changeImgList = nil;
        _changeImgList = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scroll];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scroll.ls_width, self.scroll.ls_height)];
    [self.scroll addSubview:self.container];
    
    self.itemTitleMallIfno = [LSEditItemTitle editItemTitle];
    [self.container addSubview:self.itemTitleMallIfno];
    
    self.itemTxtMallInfo = [EditItemText2 editItemText];
    [self.container addSubview:self.itemTxtMallInfo];
    
    self.itemTxtMallName = [LSEditItemText editItemText];
    [self.container addSubview:self.itemTxtMallName];
    
    self.itemTxtLinkMan = [LSEditItemText editItemText];
    [self.container addSubview:self.itemTxtLinkMan];
    
    self.itemTxtLinkTel = [LSEditItemText editItemText];
    [self.container addSubview:self.itemTxtLinkTel];
    
    self.itemTxtAccountantDate = [LSEditItemText editItemText];
    [self.container addSubview:self.itemTxtAccountantDate];
    
    self.itemTitleAccountInfo = [LSEditItemTitle editItemTitle];
    [self.container addSubview:self.itemTitleAccountInfo];
    
    self.txtName = [LSEditItemText editItemText];
    [self.container addSubview:self.txtName];
    
    self.lstBank = [LSEditItemList editItemList];
    [self.container addSubview:self.lstBank];
    
    self.lstProvince = [LSEditItemList editItemList];
    [self.container addSubview:self.lstProvince];
    
    self.lstCity = [LSEditItemList editItemList];
    [self.container addSubview:self.lstCity];
    
    self.linesLstSubBank = [LSEditItemList editItemList];
    [self.linesLstSubBank editEnable:NO];
    self.linesLstSubBank.lblVal1.hidden = NO;
    self.linesLstSubBank.lblVal1.hidden = YES;
    [self.container addSubview:self.linesLstSubBank];
    
    self.lstSubBank = [LSEditItemList editItemList];
    [self.container addSubview:self.lstSubBank];
    
    self.lstBankNumber = [LSEditItemList editItemList];
    [self.container addSubview:self.lstBankNumber];
    
    self.itemTitleProtocolInfo = [LSEditItemTitle editItemTitle];
    [self.container addSubview:self.itemTitleProtocolInfo];
    
    self.itemTxtProtocolCode = [LSEditItemText editItemText];
    [self.container addSubview:self.itemTxtProtocolCode];
    
    self.itemTxtProtocolPic = [EditImageBox editItemBox];
    [self.container addSubview:self.itemTxtProtocolPic];
    
    self.itemListDueDate = [LSEditItemList editItemList];
    [self.container addSubview:self.itemListDueDate];
    
    self.itemListPayDate = [LSEditItemList editItemList];
    [self.container addSubview:self.itemListPayDate];
    
    self.itemRadioIsAllowCheck = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.itemRadioIsAllowCheck];
    
    self.itemListMemberDisscount = [LSEditItemList editItemList];
    [self.container addSubview:self.itemListMemberDisscount];
    
    self.itemListPoundage = [LSEditItemList editItemList];
    [self.container addSubview:self.itemListPoundage];
    
    self.itemTxtReturnInfo = [LSEditItemText editItemText];
    [self.container addSubview:self.itemTxtReturnInfo];
    
    self.button = [LSViewFactor addRedButton:self.container title:@"删除" y:0];
    [self.button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.buttionDiv = self.button.superview;
    
    [LSViewFactor addClearView:self.container y:0 h:20];
    
    self.lblDetail = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_W - 20, 100)];
    [self.container addSubview:self.lblDetail];
    self.lblDetail.font = [UIFont systemFontOfSize:11];
    self.lblDetail.textColor = [ColorHelper getTipColor6];
    self.lblDetail.numberOfLines = 0;
    
    [UIHelper refreshUI:self.container scrollview:self.scroll];
    
    
}



- (void)initNavigate{
    [self configTitle:@"" leftPath:Head_ICON_BACK rightPath:nil];
    if (self.applyType == State_Apply) {
        [self configTitle:@"申请入驻"];
    }else if (self.applyType == State_Success){
        [self configTitle:@"入驻详情"];
    }else {
        [self configTitle:@"申请详情"];
    }
}

- (void)initMainView{
    
    /**禁用所有的输入框*/
    for (UIView *view in self.container.subviews) {
        if ([view isKindOfClass:[LSEditItemText class]]) {
            LSEditItemText *itemTxt = (LSEditItemText *)view;
            [itemTxt editEnabled:NO];
        }
    }
    //持卡人和协议编号可编辑
    [self.txtName editEnabled:YES];
    [self.itemTxtProtocolCode editEnabled:YES];
    /**/
    
    self.itemTitleMallIfno.lblName.text = @"商圈信息";
    [self.itemTxtMallInfo initLabel:@"商圈编号"  withHit:nil withType:nil showTag:ITEM_TAG_SELECT_CODE delegate:self];
    [self.itemTxtMallName initLabel:@"商圈名" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.itemTxtLinkMan initLabel:@"联系人" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.itemTxtLinkTel initLabel:@"联系电话" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.itemTxtAccountantDate initLabel:@"会计期" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    
    
    
    self.itemTitleAccountInfo.lblName.text = @"结账信息";
    [self.txtName initLabel:@"持卡人" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtName initData:@""];
    [self.lstBank initLabel:@"开户银行" withHit:nil isrequest:YES delegate:self];
    [self.lstProvince initLabel:@"开户省份" withHit:nil isrequest:YES delegate:self];
    [self.lstCity initLabel:@"开户城市" withHit:nil isrequest:YES delegate:self];
    self.lstSubBank.imgMore.image = [UIImage imageNamed:@"ico_next"];
    [self.lstSubBank initLabel:@"开户支行" withHit:nil isrequest:YES delegate:self];
    [self.linesLstSubBank initLabel:@"开户支行" withHit:nil delegate:self];
    [self.lstBankNumber initLabel:@"银行账号" withHit:nil isrequest:YES delegate:self];
    self.lstBank.tag =TAG_LST_BANK;
    self.lstProvince.tag = TAG_LST_PROVINCE;
    self.lstCity.tag = TAG_LST_CITY;
    self.lstSubBank.tag = TAG_LST_SUB_BANK;
    self.lstBankNumber.tag = TAG_LST_BANK_NUMBER;
    
    self.itemTitleProtocolInfo.lblName.text = @"协议信息";
    [self.itemTxtProtocolCode initLabel:@"协议编号" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.itemTxtProtocolPic initLabel:@"协议拍照" delegate:self];
    [self.itemTxtProtocolPic initImgList:nil];
    [self.itemListDueDate initLabel:@"到期时间" withHit:nil isrequest:NO delegate:self];
    [self.itemListPayDate initLabel:@"结算周期" withHit:nil isrequest:NO delegate:self];
    [self.itemRadioIsAllowCheck initLabel:@"允许查看营业数据" withHit:nil delegate:self];
    [self.itemListMemberDisscount initLabel:@"会员消费折扣(%)" withHit:nil isrequest:YES delegate:self];
//    [self.itemListMemberDisscount initLabel:@"会员消费折扣(%)" withHit:nil isrequest:NO delegate:self];
    [self.itemListPoundage initLabel:@"园区结算费率(%)" withHit:nil isrequest:NO delegate:self];
    self.itemListDueDate.tag = TAG_LST_DUEDATE;
    self.itemListPayDate.tag = TAG_LST_PAYDAY;
    self.itemListMemberDisscount.tag = TAG_LST_MEMBER_RATIO;
    self.itemListPoundage.tag = TAG_LST_SETTLEMENT_RATIO;
    
    self.itemTitleParkReturn.lblName.text = @"园区反馈";
    self.itemTitleParkReturn.hidden = YES;
    [self.itemTxtReturnInfo initLabel:@"反馈信息" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.itemTxtReturnInfo editEnabled:NO];
    self.itemTxtReturnInfo.hidden = YES;
    
    if (self.applyType == State_Apply) {
        //按钮变为"申请"
        [self.button setBackgroundImage:[UIImage imageNamed:@"btn_full_g.png"] forState:UIControlStateNormal];
        [self.button setTitle:@"申请" forState:UIControlStateNormal];
       
        //店家信息通过接口加载
        //结账信息
        [self.itemListDueDate initData:@"请选择" withVal:nil];
        [self.itemListPayDate initData:@"请选择" withVal:nil];
//        self.itemListMemberDisscount.lblVal.placeholder = @"不填表示无折扣";
        self.itemListPoundage.lblVal.placeholder = @"不填表示无结算费率";
        
        //
        
    }else if (self.applyType == State_Appling){
        [self.button setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];
        [self.button setTitle:@"取消申请" forState:UIControlStateNormal];
    }else if (self.applyType == State_Success){
        self.buttionDiv.hidden = YES;
        self.button.hidden = YES;
    }else {
        //State_Refuse
        [self.button setBackgroundImage:[UIImage imageNamed:@"btn_full_g.png"] forState:UIControlStateNormal];
        [self.button setTitle:@"再次申请" forState:UIControlStateNormal];
        
        self.itemTitleParkReturn.hidden = NO;
        self.itemTxtReturnInfo.hidden = NO;
    }
    self.lblDetail.text = @"※会员消费折扣：用商圈卡在该门店消费结算时，享受结算总金额上折扣优惠。\n  例如：该门店原有的金卡（8折）的会员，在结算时用商圈卡，还能再打折，享受折上折。\n\n※商圈结算费率：指商圈定期给门店结算时，扣除的服务费。";
    self.lblDetail.textColor = [ColorHelper getTipColor6];
    [self.lblDetail sizeToFit];
    
    if (self.applyType != 0) {
        self.lblDetail.hidden = YES;
    }

      [self.itemTxtMallInfo editEnabled:NO];
    if (self.applyType == 1 || self.applyType == 2) {
        [self.itemTxtMallInfo editEnabled:NO];
        [self.txtName editEnabled:NO];
        [self.lstBank editEnable:NO];
        [self.lstBankNumber editEnable:NO];
        [self.lstCity editEnable:NO];
        [self.lstProvince editEnable:NO];
        [self.lstSubBank editEnable:NO];
        [self.itemTxtProtocolCode editEnabled:NO];
        [self.itemListDueDate editEnable:NO];
        [self.itemListPayDate editEnable:NO];
        [self.itemRadioIsAllowCheck editable:NO];
        [self.itemListMemberDisscount editEnable:NO];
        [self.itemListPoundage editEnable:NO];
        self.itemTxtProtocolPic.userInteractionEnabled = NO;
        [self.lstSubBank visibal:NO];
    } else {
        [self.linesLstSubBank visibal:NO];
    }
    [UIHelper refreshUI:self.container scrollview:self.scroll];
}


- (void)setCircleItems:(ESPShopIntro *)shopIntro{
    [self.itemTxtMallName initData:shopIntro.shopName];//商圈名
    [self.itemTxtLinkMan initData:shopIntro.shopName];//联系人
    [self.itemTxtLinkTel initData:shopIntro.shopName];//联系电话
    [self.itemTxtAccountantDate initData:shopIntro.shopName];//会计期

}

- (void)setDetailItems:(ESPSettledMallVo *)settledMallVo{
    [self.itemTxtMallInfo initData:settledMallVo.code];
    [self.itemTxtMallName initData:settledMallVo.shopName];
    [self.itemTxtLinkMan initData:settledMallVo.linkman];
    [self.itemTxtLinkTel initData:settledMallVo.phone1];
    if ([ObjectUtil isNull:settledMallVo.reportCycle] || [settledMallVo.reportCycle isEqualToString:@""]) {
        [self.itemTxtAccountantDate initData:@"-"];
    }else{
        [self.itemTxtAccountantDate initData:settledMallVo.reportCycle];
    }
    
    
    //银行信息
    [self.txtName initData:settledMallVo.accountName];
    [self.lstBank initData:settledMallVo.bankName withVal:settledMallVo.bank];
    [self.lstProvince initData:settledMallVo.provinceName withVal:settledMallVo.provinceId];
    [self.lstCity initData:settledMallVo.cityName withVal:settledMallVo.cityId];
    [self.lstSubBank initData:settledMallVo.subBranchName withVal:settledMallVo.subBranch];
    [self.linesLstSubBank initData:settledMallVo.subBranchName withVal:settledMallVo.subBranch];
    [self.lstBankNumber initData:settledMallVo.account withVal:settledMallVo.account];
    
    //协议编号
    [self.itemTxtProtocolCode initData:settledMallVo.protocolCode];
    
    //协议照片
    if ([ObjectUtil isNotEmpty:settledMallVo.imageVoList]) {
        NSMutableArray *imgList = [NSMutableArray array];
        for (NSDictionary *dic in settledMallVo.imageVoList) {
            ImageVo *imgVo = [ImageVo converToVo:dic];
            [imgList addObject:imgVo];
        }
        [self.itemTxtProtocolPic initImgList:imgList];
    }
    
    //到期时间
    if ([ObjectUtil isNull:settledMallVo.endTime]) {
        [self.itemListDueDate initData:[DateUtils formateDate2:[NSDate date]] withVal:[DateUtils formateDate2:[NSDate date]]];
    }else{
        [self.itemListDueDate initData:[DateUtils formateTime2:settledMallVo.endTime.longLongValue] withVal:[DateUtils formateTime2:settledMallVo.endTime.longLongValue]];
    }
    

    //结算日期
    if ([ObjectUtil isNull:settledMallVo.cycle]) {
        [self.itemListPayDate initData:[NSString stringWithFormat:@"每月%@号",@1] withVal:@"1"];
    }else{
        [self.itemListPayDate initData:[NSString stringWithFormat:@"每月%@号",settledMallVo.cycle] withVal:[NSString stringWithFormat:@"%@",settledMallVo.cycle]];
    }
    
    
    //是否允许查看营业数据
    NSString *isShow;
    if (settledMallVo.isLookData.intValue == 1) {
        isShow = @"1";
    }else{
        isShow = @"0";
    }
    [self.itemRadioIsAllowCheck initData:isShow];
    
    //会员消费折扣itemListMemberDisscount;
    if ([ObjectUtil isNull:settledMallVo.ratio]) {
//        self.itemListMemberDisscount.lblVal.placeholder = @"不填表示无折扣";
    
       
        
    }else{
        [self.itemListMemberDisscount initData:[NSString stringWithFormat:@"%@",settledMallVo.ratio] withVal:nil];
    }
    
    //园区结算手续费itemListPoundage;
    if ([ObjectUtil isNull:settledMallVo.settlementRatio]) {
       self.itemListPoundage.lblVal.placeholder = @"不填表示无结算费率";
    }else{
        [self.itemListPoundage initData:[NSString stringWithFormat:@"%@",settledMallVo.settlementRatio] withVal:nil];
    }
    
    
    [UIHelper refreshPos:self.container scrollview:self.scroll];
    [UIHelper refreshUI:self.container scrollview:self.scroll];
}

#pragma mark - NetWork
- (void)loadDetailData{
    __weak EnterCircleEditView *weakSelf = self;
    [_service settledMallShopDetail:self.detailParams completionHandler:^(id json) {
        NSDictionary *dic = [json objectForKey:@"settledMallVo"];
        if ([ObjectUtil isNotEmpty:dic]) {
            weakSelf.settledMallVo = [[ESPSettledMallVo alloc]initWithDictionary:dic];
        }
        [weakSelf setDetailItems:weakSelf.settledMallVo];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)loadSelfInfo{
    __weak EnterCircleEditView *weakSelf = self;
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    NSString *shopId = [[Platform Instance]getkey:SHOP_ID];
    [paramDic setValue:shopId forKey:@"shopId"];
    
    [_service getSelfShopInfo:paramDic completionHandler:^(id json) {
        NSDictionary *dic = [json objectForKey:@"shopVo"];
        if ([ObjectUtil isNotEmpty:dic]) {
            weakSelf.shopInfo = [[ESPShopVo alloc]initWithDictionary:dic];
        }
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];

}

-(void)save{
    
}



#pragma mark - IEditItemListEvent代理
- (void)onItemListClick:(LSEditItemList*)obj{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (obj.tag == TAG_LST_BANK) {
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        NSString *url = @"pay/area/v1/get_banks";
        [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {//查询银行列表
            NameItemVO *itemVo;
            for (NSDictionary *obj in  json[@"data"]) {
                itemVo = [[NameItemVO alloc] initWithVal:obj[@"bankDisplayName"] andId:obj[@"bankName"]];
                [arr addObject:itemVo];
            }
            [OptionPickerBox initData:arr itemId:[obj getStrVal]];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];

        
    } else if (obj.tag == TAG_LST_PROVINCE) {
        if ([NSString isBlank:[self.lstBank getStrVal]]) {
            [AlertBox show:@"请选择开户银行"];
            return;
        }
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        [param setValue:[self.lstBank getStrVal] forKey:@"bankName"];
        NSString *url = @"userBank/selectProvinceList";
        [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {//查询银行开户省份
            NameItemVO *itemVo;
            for (NSDictionary *obj in  json[@"provinceList"]) {
                itemVo = [[NameItemVO alloc] initWithVal:obj[@"provinceName"] andId:obj[@"provinceNo"]];
                [arr addObject:itemVo];
            }
            [OptionPickerBox initData:arr itemId:[obj getStrVal]];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    } else if (obj.tag == TAG_LST_CITY) {
        if ([NSString isBlank:[self.lstProvince getStrVal]]) {
            [AlertBox show:@"请选择开户省份"];
            return;
        }
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:[self.lstBank getStrVal] forKey:@"bankName"];
        [param setValue:[self.lstProvince getStrVal] forKey:@"provinceNo"];
        NSString *url = @"pay/area/v1/get_bank_cities";
        [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {//查询银行开户城市
            NameItemVO *itemVo;
            for (NSDictionary *obj in  json[@"data"]) {
                itemVo = [[NameItemVO alloc] initWithVal:obj[@"cityName"] andId:obj[@"cityNo"]];
                [arr addObject:itemVo];
            }
            [OptionPickerBox initData:arr itemId:[obj getStrVal]];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    } else if (obj.tag == TAG_LST_SUB_BANK) {
        if ([NSString isBlank:[self.lstCity getStrVal]]) {
            [AlertBox show:@"请选择开户城市"];
            return;
        }
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:[self.lstBank getStrVal] forKey:@"bankName"];
        [param setValue:[self.lstCity getStrVal] forKey:@"cityNo"];
        NSString *url = @"pay/area/v1/get_sub_banks";
        [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {//查询银行开户支行
            NSArray *array = json[@"data"];
            NSMutableArray *optionList = [[NSMutableArray alloc] init];
            for (NSDictionary *obj in array) {
                ShopInfoVO *shopInfoVO = [ShopInfoVO mj_objectWithKeyValues:obj];
                NameItemVO *nameItem = [[NameItemVO alloc] initWithVal:shopInfoVO.subBankName andId:shopInfoVO.subBankNo];
                [optionList addObject:nameItem];
                
            }
            SelectItemList *vc = [[SelectItemList alloc] initWithtxtTitle:@"开户支行" txtPlaceHolder:@"输入支行关键字"];
            __weak EnterCircleEditView *weakSelf = self;
            [vc selectId:[obj getStrVal] list:optionList callBlock:^(id<INameItem> item) {
                if (item) {
                    [weakSelf.lstSubBank changeData:[item obtainItemName] withVal:[item obtainItemId]];
                }
            }];
            [self.navigationController pushViewController:vc animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];

    } else if (obj.tag == TAG_LST_BANK_NUMBER) {
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:30 digitLimit:0];
        [SymbolNumberInputBox initData:self.lstBankNumber.lblVal.text];
    }else if (obj.tag == TAG_LST_DUEDATE){//到期时间
        NSDate *date=[DateUtils parseDateTime4:obj.lblVal.text];
        [DatePickerBox show:obj.lblName.text date:date client:self event:(int)obj.tag];
    }else if (obj.tag == TAG_LST_PAYDAY){//结算周期
        //销售时间、订单来源选择
        NSMutableArray *arr = [NSMutableArray array];
        NameItemVO *itemVo;
        for (NSInteger i = 1; i<31 ;i++)  {
            NSString *text = [NSString stringWithFormat:@"每月%ld号",(long)i];
            itemVo = [[NameItemVO alloc] initWithVal:text andId:[NSString stringWithFormat:@"%ld",(long)i]];
            [arr addObject:itemVo];
        }
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        [OptionPickerBox initData:arr itemId:[obj getStrVal]];

    }else if (obj.tag == TAG_LST_MEMBER_RATIO){//会员折扣
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:3 digitLimit:0];
        [SymbolNumberInputBox initData:self.itemListMemberDisscount.lblVal.text];

    }else if (obj.tag == TAG_LST_SETTLEMENT_RATIO){//商圈结算费率
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
         [SymbolNumberInputBox initData:self.itemListPoundage.lblVal.text];

    }
    

}

#pragma mark - OptionPickerClient (下拉框选中)
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == TAG_LST_BANK) {
        [self.lstBank initData:[item obtainItemName] withVal:[item obtainItemId]];
    } else if (eventType == TAG_LST_PROVINCE) {
        [self.lstProvince initData:[item obtainItemName] withVal:[item obtainItemId]];
    } else if (eventType == TAG_LST_CITY) {
        [self.lstCity initData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if (eventType == TAG_LST_PAYDAY){
        [self.itemListPayDate initData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if (eventType == TAG_LST_SETTLEMENT_RATIO){
        [self.itemListPoundage initData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    return YES;
}

#pragma mark - SymbolNumberInputClient (数字输入框选中)
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    if (eventType == TAG_LST_BANK_NUMBER) {
//        if (![NSString isValidCreditNumber:val]) {
//            [AlertBox show:@"请输入正确的银行卡号"];
//            return;
//        }
        [self.lstBankNumber initData:val withVal:val];
    }else if (eventType == TAG_LST_SETTLEMENT_RATIO){
        if ([val doubleValue] >100) {
            [AlertBox show:@"园区结算费率不能超过100%"];
            return;
        }
        
        [self.itemListPoundage initData:val withVal:val];
    }else if (eventType == TAG_LST_MEMBER_RATIO){
        if ([val doubleValue] >100) {
            [AlertBox show:@"会员消费折扣率不能超过100%"];
            return;
        }
        [self.itemListMemberDisscount initData:val withVal:val];
    }
}
#pragma mark - DatePickerClient (日期选择器)
- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event{
    NSString *currentDateStr = [DateUtils formateDate2:date];
    if (TAG_LST_DUEDATE == event) {
        [self.itemListDueDate initData:currentDateStr withVal:currentDateStr];
    }
    return YES;
}

#pragma mark - IEditItemRadioEvent代理
-(void) onItemRadioClick:(LSEditItemRadio*)obj{
    [obj.currentVal isEqualToString:@"1"];
    [obj.lblTip setHidden:YES];
}
#pragma mark - EditItemText2Delegate
- (void)showButtonTag:(NSInteger)tag{
    if (ITEM_TAG_SELECT_CODE == tag) {
        NSString *code = nil;
//        NSString *entityId;
        if ([ObjectUtil isNull:self.itemTxtMallInfo.txtVal.text]) {
            [AlertBox show:@"请输入商圈编号."];
        }else{
            code = self.itemTxtMallInfo.txtVal.text;
        }
        
//        entityId = [[Platform Instance]getkey:ENTITY_ID];
        
        NSMutableDictionary *dicParam = nil;
        if (code) {
            [dicParam setValue:code forKey:@"code"];
        }
        
        __weak EnterCircleEditView *weakSelf = self;
        [self.service settledMallById:dicParam completionHandler:^(id json) {
            NSDictionary *dic = [json objectForKey:@"shopIntroVo"];
            if ([ObjectUtil isNotEmpty:dic]) {
                weakSelf.shopIntro = [[ESPShopIntro alloc]initWithDictionary:dic];
                [weakSelf setCircleItems:weakSelf.shopIntro];
            }

        } errorHandler:^(id json) {
            
        }];
    }

}

#pragma mark - 点击事件
- (void)btnClick:(id)sender {
    if (self.applyType == State_Apply || self.applyType == State_Refuse || self.applyType == State_Unbind) {
        if ([self isVaild]) {
            [self.service saveSettledMall:self.settledMallParam completionHandler:^(id json) {
                [AlertBox show:@"申请提交成功,请等待审批结果."];
                
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[EnterCircleListView class]]) {
                        EnterCircleListView *listView = (EnterCircleListView *)vc;
                        [listView loadData];
                    }
                }
                [self.navigationController popViewControllerAnimated:NO];
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }
    }else if (self.applyType == State_Appling ){
        NSMutableDictionary *dicParam = [[NSMutableDictionary alloc]init];
        [dicParam setValue:self.settledMallVo.Id forKey:@"settledMallId"];
        [self.service delSettleMall:dicParam completionHandler:^(id json) {
            
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[EnterCircleListView class]]) {
                    EnterCircleListView *listView = (EnterCircleListView *)vc;
                    [listView loadData];
                }
            }
            [self.navigationController popViewControllerAnimated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        } errorHandler:^(id json) {
            
        }];
    }else {
        
    }
    
//    if ([self isVaild]) {
//        [self.service saveSettledMall:self.settledMallParam completionHandler:^(id json) {
//            [AlertBox show:@"申请提交成功,请等待审批结果."];
//            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
//            [self.navigationController popViewControllerAnimated:NO];
//
//        } errorHandler:^(id json) {
//            [AlertBox show:json];
//        }];
//    }

    
}

#pragma mark - params
- (NSMutableDictionary *)settledMallParam{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    [params setValue:self.settledMallVo.Id forKey:@"id"];
    [params setValue:self.settledMallVo.entityId forKey:@"entityId"];
    [params setValue:self.settledMallVo.shopId forKey:@"shopId"];
    [params setValue:self.settledMallVo.agreeEntityId forKey:@"agreeEntityId"];
    [params setValue:self.settledMallVo.agreeShopId forKey:@"agreeShopId"];
    //[params setValue:self.settledMallVo.agreeShopName forKey:@"agreeShopName"];
    //[params setValue:self.settledMallVo.agreeShopCode forKey:@"agreeShopCode"];
    
    [params setValue:self.txtName.txtVal.text forKey:@"accountName"];//持卡人
    [params setValue:self.lstBank.getStrVal forKey:@"bank"];//开户行
    [params setValue:self.lstProvince.getStrVal forKey:@"provinceId"];//开户省份ID
    [params setValue:self.lstCity.getStrVal forKey:@"cityId"];//开户城市ID
    [params setValue:self.lstSubBank.getStrVal forKey:@"subBranch"];//开户支行
    [params setValue:self.lstBankNumber.getStrVal forKey:@"account"];//银行账号
    
    [params setValue:self.lstBank.lblVal.text forKey:@"bankName"];
    [params setValue:self.lstSubBank.lblVal.text forKey:@"subBranchName"];
    [params setValue:self.lstProvince.lblVal.text forKey:@"provinceName"];
    [params setValue:self.lstCity.lblVal.text forKey:@"cityName"];
    
    [params setValue:self.itemTxtProtocolCode.txtVal.text forKey:@"protocolCode"];
    [params setValue:[NSNumber numberWithLongLong:[DateUtils formateDateTime3:self.itemListDueDate.lblVal.text]] forKey:@"endTime"];
    [params setValue:[NSNumber numberWithInteger:self.itemListPayDate.getStrVal.integerValue] forKey:@"cycle"];
    [params setValue:[NSNumber numberWithInteger:1] forKey:@"status"];
    
    [params setValue:[NSNumber numberWithDouble:self.itemListPoundage.lblVal.text.doubleValue] forKey:@"settlementRatio"];
    [params setValue:[NSNumber numberWithInteger:self.itemListMemberDisscount.lblVal.text.integerValue] forKey:@"ratio"];
    
    BOOL isOpen = [self.itemRadioIsAllowCheck.currentVal isEqualToString:@"1"];
    if (isOpen) {
        [params setValue:@"1" forKey:@"isLookData"];
    }else{
        [params setValue:@"0" forKey:@"isLookData"];
    }
    
    if ([self.itemTxtProtocolPic getFileImageMap] != nil) {
        NSMutableArray *infoImageVoList = [[NSMutableArray alloc] init];
        if ([self.itemTxtProtocolPic getFilePathList] != nil && [self.itemTxtProtocolPic getFilePathList].count > 0){
            for (NSString* imgStr in [self.itemTxtProtocolPic getFilePathList]) {
                NSMutableDictionary* vo = [[NSMutableDictionary alloc] init];
                UIImage *img = [[self.itemTxtProtocolPic getFileImageMap] objectForKey:imgStr];
                
                if ([ObjectUtil isNull:img]) {
                    //什么也不做
                }else{
                    NSData *data = UIImageJPEGRepresentation(img, 0.1);
                    NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
                    [vo setValue:base64Encoded forKey:@"file"];
                    [vo setValue:imgStr forKey:@"fileName"];
                    [vo setValue:@"add" forKey:@"opType"];
                    [infoImageVoList addObject:vo];
                }
            }
        }
        [infoImageVoList addObjectsFromArray:_changeImgList];
        [params setValue:infoImageVoList forKey:@"imageVoList"];
        [params setValue:self.shopInfo.industry forKey:@"industry"];
        [params setValue:self.shopInfo.code forKey:@"agreeShopCode"];
    }
    
    
    //外面再包一层
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:params forKey:@"settledMallVo"];

    return param;
}

- (BOOL)isVaild {
    
    if ([NSString isBlank:self.itemTxtMallInfo.txtVal.text]) {
        [AlertBox show:@"商圈编号不能为空"];
        return NO;
    }
    
    
    if ([NSString isBlank:self.txtName.txtVal.text]) {
        [AlertBox show:@"持卡人不能为空"];
        return NO;
    }
    
    /**账户信息*/
    if ([NSString isBlank:[self.lstBank getStrVal]]) {
        [AlertBox show:[NSString stringWithFormat:@"%@不能为空",self.lstBank.lblName.text]];
        return NO;
    }
    if ([NSString isBlank:[self.lstProvince getStrVal]]) {
        [AlertBox show:[NSString stringWithFormat:@"%@不能为空",self.lstProvince.lblName.text]];
        return NO;
    }
    if ([NSString isBlank:[self.lstCity getStrVal]]) {
        [AlertBox show:[NSString stringWithFormat:@"%@不能为空",self.lstCity.lblName.text]];
        return NO;
    }
    if ([NSString isBlank:[self.lstSubBank getStrVal]]) {
        [AlertBox show:[NSString stringWithFormat:@"%@不能为空",self.lstSubBank.lblName.text]];
        return NO;
    }
    if ([NSString isBlank:[self.lstBankNumber getStrVal]]) {
        [AlertBox show:[NSString stringWithFormat:@"%@不能为空",self.lstBankNumber.lblName.text]];
        return NO;
    }
    /***/
    
    if ([NSString isBlank:self.itemTxtProtocolCode.txtVal.text]) {
        [AlertBox show:@"协议编号不能为空"];
        return NO;
    }
    if ([NSString isBlank:[self.itemListDueDate getStrVal]]) {
        [AlertBox show:@"到期日期不能为空"];
        return NO;
    }
    if ([NSString isBlank:[self.itemListPayDate getStrVal]]) {
        [AlertBox show:@"结算周期不能为空"];
        return NO;
    }
    if([NSString isBlank:self.itemListMemberDisscount.lblVal.text]) {
        [AlertBox show:@"会员消费折扣不能为空"];
        return NO;
    }
    if ([self.itemListMemberDisscount.lblVal.text doubleValue] == 0.0) {
        [AlertBox show:@"会员消费折扣不能为0%"];
        return NO;

    }
    return YES;
    
}

#pragma mark - 协议照片
//添加图片
- (void)onConfirmImgClickWithTag:(NSInteger)btnIndex tag:(NSInteger)tag
{
    if (btnIndex==1) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [AlertBox show:@"相机好像不能用哦!"];
            return;
        }
        NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
        if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:_imagePickerController animated:YES completion:nil];
        }
    } else if(btnIndex==0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [AlertBox show:@"相册好像不能访问哦!"];
            return;
        }
        NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:_imagePickerController animated:YES completion:nil];
        }
    }
}
//删除图片
- (void)onDelImgClickWithPath:(NSString *)path
{
    
    if ([self.itemTxtProtocolPic getFilePathList] != nil && [self.itemTxtProtocolPic getFilePathList].count > 0)
    {
        NSArray *keys= [[self.itemTxtProtocolPic getfilePathMap] allKeys];
        for (NSString* imgStr in keys) {
            if ([imgStr isEqualToString:path]) {
                ImageVo *imageData = [[self.itemTxtProtocolPic getfilePathMap] objectForKey:path];
                if ([ObjectUtil isNotNull:imageData.objectId] || (![imageData.objectId isEqualToString:@""])) {
                    NSMutableDictionary* vo = [[NSMutableDictionary alloc] init];
                    [vo setValue:imageData.objectId forKey:@"imageId"];
                    [vo setValue:@"del" forKey:@"opType"];
                    [_changeImgList addObject:vo];
                }
            }
        }
    
    }
    [self.itemTxtProtocolPic removeFilePath:path];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    _goodsImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString* filePath = [NSString stringWithFormat:@"%@/menu/%@.png",@"001",[NSString getUniqueStrByUUID]];
    self.imgFilePathTemp = filePath;
    [self uploadImgFinsh];
//        [self uploadImage:filePath image:menuImage width:1024 heigth:768 event:REMOTE_KABAWMENU_MENUIMG_UPLOAD];
}

-(void) uploadImgFinsh
{
    [self.itemTxtProtocolPic changeImg:self.imgFilePathTemp img:_goodsImage];
    [UIHelper refreshPos:self.container scrollview:self.scroll];
    [UIHelper refreshUI:self.container scrollview:self.scroll];
}

- (void)updateViewSize
{
    [UIHelper refreshPos:self.container scrollview:self.scroll];
    [UIHelper refreshUI:self.container scrollview:self.scroll];
}




@end
