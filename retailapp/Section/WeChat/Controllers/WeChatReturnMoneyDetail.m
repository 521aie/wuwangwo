//
//  WeChatReturnMoneyDetail.m
//  retailapp
//
//  Created by diwangxie on 16/4/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "WeChatReturnMoneyDetail.h"
#import "WechatOrderDetailView.h"
#import "DateUtils.h"
#import "SellReturnService.h"
#import "ServiceFactory.h"
#import "CustomerReturnPayVo.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "UIHelper.h"
#import "NameItemVO.h"
#import "ShopInfoVO.h"
#import "SelectItemList.h"
#import "NavigateTitle2.h"
#import "RetailSellReturnVo.h"
#import "ItemTitle.h"
#import "LSViewFactor.h"
#import "JsonHelper.h"
#import "OptionPickerBox.h"

@interface WeChatReturnMoneyDetail ()<INavigateEvent,IEditItemListEvent,OptionPickerClient>

@property (nonatomic, strong) SellReturnService *sellReturnService;
@property (nonatomic, strong) CustomerReturnPayVo *customerReturnPayVo;
@property (nonatomic, strong) NavigateTitle2 *titileBox;
@property (nonatomic, strong) EditItemText *lsState;        // 退货状态
@property (nonatomic, strong) EditItemText *lsOrderCode;    // 退货单号
@property (nonatomic, strong) EditItemText *lsReturnTime;   // 退货时间
@property (nonatomic, strong) EditItemText *lsReturnMan;    // 退货人
@property (nonatomic, strong) EditItemText *lsPhone;        // 手机号码
@property (nonatomic, strong) EditItemList *lsOrderDetail;  // 原订单详情
@property (nonatomic, strong) EditItemList *lsPayTypeName;   // 退款方式：银行卡，微信，支付宝
@property (nonatomic, strong) EditItemList *lsBankName;      // 银行类型名称
@property (nonatomic, strong) EditItemList *lstProvince;     // 省份
@property (nonatomic, strong) EditItemList *lstCity;         // 城市
@property (nonatomic, strong) EditItemList *lsBrachBankName; // 分行名称
@property (nonatomic, strong) EditItemText *lsAccount;       // 退款账号：微信账号，银行卡账号，支付宝账号
@property (nonatomic, strong) EditItemText *lsName;          // 账号开户人
@property (nonatomic, strong) EditItemText *lsReturnMoney;   // 退款金额
@property (nonatomic, strong) EditItemText *lsOpUserName;    // 操作人(已退款的单子才有)
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *actionButton;        // 操作button
@property (nonatomic, strong) UILabel *lblTip;
//@property (nonatomic, strong) NSMutableArray *sellReturnVoList;
@property (nonatomic ,strong) NSArray *payTypeItems;/*<退款方式items>*/
@end

@implementation WeChatReturnMoneyDetail

- (NSArray *)payTypeItems {
    
    if (!_payTypeItems) {
        _payTypeItems = @[[[NameItemVO alloc] initWithVal:@"银行卡" andId:@"1"],
                          [[NameItemVO alloc] initWithVal:@"微信" andId:@"2"],
                          [[NameItemVO alloc] initWithVal:@"支付宝" andId:@"3"],];
    }
    return _payTypeItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
//    _sellReturnVoList = [[NSMutableArray alloc]init];
    self.sellReturnService = [ServiceFactory shareInstance].sellReturnService;
    self.customerReturnPayVo=[CustomerReturnPayVo convertToCustomerReturnPayVo:self.sellReturnVo.customerReturnPayVo];
    [self configSubViews];
    [self configHelpButton:HELP_WECHAT_REFUND_MANAGEMENT];
}

- (void)configSubViews {
    
    // 导航栏
    self.titileBox = [NavigateTitle2 navigateTitle:self];
    [self.titileBox initWithName:_sellReturnVo.customerName backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:self.titileBox];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.titileBox.ls_bottom, SCREEN_W, SCREEN_H-self.titileBox.ls_bottom)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    ItemTitle *baseInfo = [[ItemTitle alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
    [baseInfo awakeFromNib];
    baseInfo.lblName.text = @"基本信息";
    [self.scrollView addSubview:baseInfo];


    // 退款状态
    self.lsState = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
    [self.lsState initLabel:@"退款状态" withHit:nil isrequest:YES type:0];
    [self.lsState editEnabled:NO];
    [self.lsState initData:[self getStatusString:_sellReturnVo.status]];
    [self.scrollView addSubview:self.lsState];
 
    // 退货单号
    self.lsState = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
    [self.lsState initLabel:@"退款单号" withHit:nil isrequest:NO type:0];
    [self.lsState editEnabled:NO];
    NSString *code = _sellReturnVo.code;
    if ([code hasPrefix:@"RBW"]) {
        code = [code substringFromIndex:3];
    }
    [self.lsState initData:code];
    [self.scrollView addSubview:self.lsState];
    
    // 退货时间
    self.lsReturnTime = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
    [self.lsReturnTime initLabel:@"退款状态" withHit:nil isrequest:NO type:0];
    [self.lsReturnTime editEnabled:NO];
    [self.lsReturnTime initData:[DateUtils formateTime:_sellReturnVo.createTime]];
    [self.scrollView addSubview:self.lsReturnTime];
    
    // 退货人
    self.lsReturnMan = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
    [self.lsReturnMan initLabel:@"退款人" withHit:nil isrequest:NO type:0];
    [self.lsReturnMan editEnabled:NO];
    [self.lsReturnMan initData:_sellReturnVo.customerName];
    [self.scrollView addSubview:self.lsReturnMan];
    
    // 手机号码
    self.lsPhone = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
    [self.lsPhone initLabel:@"手机号码" withHit:nil isrequest:NO type:0];
    [self.lsPhone editEnabled:NO];
    [self.lsPhone initData:_sellReturnVo.customerMobile];
    [self.scrollView addSubview:self.lsPhone];
    
    //原订单详情
    self.lsOrderDetail = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
    [self.lsOrderDetail initLabel:@"原订单详情" withHit:@"" isrequest:NO delegate:self];
    self.lsOrderDetail.lblVal.hidden = YES;
    self.lsOrderDetail.imgMore.image = [UIImage imageNamed:@"ico_next"];
    [self.lsOrderDetail initData:@"" withVal:nil];
    [self.scrollView addSubview:self.lsOrderDetail];
    
    // 退款信息
    ItemTitle *refundInfo = [[ItemTitle alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
    [refundInfo awakeFromNib];
    refundInfo.lblName.text = @"退款信息";
    [self.scrollView addSubview:refundInfo];
    
    
    BOOL editable = NO;
    if ((_sellReturnVo.status != 2 && ([ObjectUtil isNotNull:_customerReturnPayVo] && [NSString isBlank:_customerReturnPayVo.accountName])) || [ObjectUtil isNull:_customerReturnPayVo]) {
        editable = YES;
    }
    
    //退款方式
    self.lsPayTypeName = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
    [self.lsPayTypeName initLabel:@"退款方式" withHit:@"" isrequest:NO delegate:self];
    [self.lsPayTypeName initData:@"微信" withVal:@"2"];  // 默认通过 微信退款
    [self.scrollView addSubview:self.lsPayTypeName];
    [self.lsPayTypeName editEnable:editable];
    self.lsPayTypeName.tag = 11;
    
    //账号
    self.lsAccount = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
    [self.lsAccount initLabel:@"微信账号" withHit:@"" isrequest:NO type:0];
    [self.scrollView addSubview:self.lsAccount];
    [self.lsAccount editEnabled:editable];
    
    //开户人
    self.lsName = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
    [self.lsName initLabel:@"姓名" withHit:@"" isrequest:NO type:0];
    [self.scrollView addSubview:self.lsName];
    [self.lsName editEnabled:editable];
    
    //开户银行
    self.lsBankName = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
    [self.lsBankName initLabel:@"开户银行" withHit:@"" isrequest:NO delegate:self];
//    [self.lsBankName initData:@"请选择" withVal:nil];
    [self.scrollView addSubview:self.lsBankName];
    [self.lsBankName editEnable:editable];
    self.lsBankName.tag = 12;
    
    // 开户省份
    if (editable) {
        self.lstProvince = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
        [self.lstProvince initLabel:@"开户省份" withHit:@"" isrequest:NO delegate:self];
        [self.lstProvince initData:@"请选择" withVal:nil];
        [self.scrollView addSubview:self.lstProvince];
        self.lstProvince.tag = 13;
        
        // 开户城市
        self.lstCity = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
        [self.lstCity initLabel:@"开户城市" withHit:@"" isrequest:NO delegate:self];
        [self.lstCity initData:@"请选择" withVal:nil];
        [self.scrollView addSubview:self.lstCity];
        self.lstCity.tag = 14;
    }

    //开户支行Ø
    self.lsBrachBankName = [[EditItemList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
    [self.lsBrachBankName initLabel:@"开户支行" withHit:@"" isrequest:NO delegate:self];
    self.lsBrachBankName.imgMore.image = [UIImage imageNamed:@"ico_next"];
//    [self.lsBrachBankName initData:@"请选择" withVal:nil];
    [self.scrollView addSubview:self.lsBrachBankName];
    self.lsBrachBankName.tag = 15;
    [self.lsBrachBankName editEnable:editable];
    
    //退款金额
    self.lsReturnMoney = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
    [self.lsReturnMoney initLabel:@"退款金额(元)" withHit:@"" isrequest:NO type:0];
    [self.lsReturnMoney editEnabled:NO];
    [self.lsReturnMoney initData:[NSString stringWithFormat:@"%.2f",_sellReturnVo.discountAmount]];
    [self.scrollView addSubview:self.lsReturnMoney];
    
    if (_sellReturnVo.status == 2) {
        //操作人(退款成功的单子才会有此项)
        self.lsOpUserName = [[EditItemText alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 48.0)];
        [self.lsOpUserName initLabel:@"操作人" withHit:@"" isrequest:NO type:0];
        [self.lsOpUserName editEnabled:NO];
        [self.lsOpUserName initData:[NSString isNotBlank:_sellReturnVo.opUserName]?_sellReturnVo.opUserName:@""];
        self.lsOpUserName.txtVal.placeholder = @"";
        [self.scrollView addSubview:self.lsOpUserName];
    }

    if (_sellReturnVo.status == 5) {
        self.actionButton = [LSViewFactor addGreenButton:self.scrollView title:@"手动退款成功" y:0];
        [self.actionButton addTarget:self action:@selector(manulRefundAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 待退款，且未提供退款账号情况下
    if (_sellReturnVo.status == 5 && [NSString isBlank:_customerReturnPayVo.accountName]) {
        //提示信息
        self.lblTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_W - 20.0, 20.0)];
        self.lblTip.font = [UIFont systemFontOfSize:11.0];
        self.lblTip.textColor = [ColorHelper getRedColor];
        self.lblTip.text = @"退款账户不存在，请联系退货人！";
        [self.scrollView addSubview:self.lblTip];
    }
    
    // 根据退款方式来显示对应的退款账户信息(默认退款方式为，微信)
    NSInteger payType = 2;
    if (_customerReturnPayVo.payType >= 1 && _customerReturnPayVo.payType <= 3) {
        payType = _customerReturnPayVo.payType;
    }
    [self showRefundAccountInfoByPayType:payType];
}

// 根据退款方式 显示对应的退款账户项
- (void)showRefundAccountInfoByPayType:(NSInteger)payType {
   
    if (payType == 1) {
        
        // 开户银行
        NSString *bankName = [NSString isNotBlank:_customerReturnPayVo.bankName]?_customerReturnPayVo.bankName:@"-";
        // 开户支行
        NSString *branchName = [NSString isNotBlank:_customerReturnPayVo.branchName]?_customerReturnPayVo.branchName:@"-";
        if (_sellReturnVo.status != 5) {
            [self.lsBrachBankName visibal:YES];
            [self.lsBankName visibal:YES];
            [self.lsPayTypeName initData:_customerReturnPayVo.payTypeName withVal:[NSString stringWithFormat:@"%hd",_customerReturnPayVo.payType]];
            [self.lsAccount initLabel:@"银行账号" withVal:_customerReturnPayVo.payAccount?:@""];
            [self.lsName initLabel:@"持卡人" withVal:_customerReturnPayVo.accountName?:@""];
            [self.lsBankName initData:bankName withVal:bankName];
            [self.lsBrachBankName initData:branchName withVal:branchName];
            // 防止为空显示:"可不填"字样
            [self.lsAccount initPlaceholder:@""];
            [self.lsName initPlaceholder:@""];
        } else {
            
            [self.lsBrachBankName visibal:YES];
            [self.lsBankName visibal:YES];
            [self.lstProvince visibal:YES];
            [self.lstCity visibal:YES];
            [self.lsAccount initLabel:@"银行账号" withHit:nil isrequest:NO type:0];
            [self.lsName initLabel:@"持卡人" withHit:nil isrequest:NO type:0];
            [self.lsBankName initData:@"请选择" withVal:nil];
            [self.lsBrachBankName initData:@"请选择" withVal:nil];
            
            // 用户在微店指定了退款方式的
            if (_customerReturnPayVo && [NSString isNotBlank:_customerReturnPayVo.payAccount]) {
                [self.lsAccount initData:_customerReturnPayVo.payAccount];
                 [self.lsPayTypeName initData:_customerReturnPayVo.payTypeName withVal:[NSString stringWithFormat:@"%hd",_customerReturnPayVo.payType]];
                [self.lsName initData:_customerReturnPayVo.accountName];
                [self.lsBankName initData:bankName withVal:bankName];
                [self.lsBrachBankName initData:branchName withVal:branchName];
            }
        }
        
    } else if (payType == 2) {
            
        if (_sellReturnVo.status != 5) {
            
            [self.lsBrachBankName visibal:NO];
            [self.lsBankName visibal:NO];
            [self.lsAccount initData:_customerReturnPayVo.payAccount];
            [self.lsName initData:_customerReturnPayVo.accountName];
            [self.lsAccount initPlaceholder:@""];
            [self.lsName initPlaceholder:@""];
        } else {
            
            [self.lsBrachBankName visibal:NO];
            [self.lsBankName visibal:NO];
            [self.lstProvince visibal:NO];
            [self.lstCity visibal:NO];
            [self.lsAccount initLabel:@"微信账号" withHit:nil isrequest:NO type:0 ];
            [self.lsName initLabel:@"姓名" withHit:nil isrequest:NO type:0];
            
            // 用户在微店指定了退款方式的
            if (_customerReturnPayVo && [NSString isNotBlank:_customerReturnPayVo.payAccount]) {
                [self.lsAccount initData:_customerReturnPayVo.payAccount];
                [self.lsPayTypeName initData:_customerReturnPayVo.payTypeName withVal:[NSString stringWithFormat:@"%hd",_customerReturnPayVo.payType]];
                [self.lsName initData:_customerReturnPayVo.accountName];
            }
        }
        
    } else if (payType == 3) {
        
        if (_sellReturnVo.status != 5) {
            
            [self.lsBrachBankName visibal:NO];
            [self.lsBankName visibal:NO];
            [self.lsAccount initData:_customerReturnPayVo.payAccount];
            [self.lsName initData:_customerReturnPayVo.accountName];
            [self.lsAccount initPlaceholder:@""];
            [self.lsName initPlaceholder:@""];
       
        } else {
            
            [self.lsBrachBankName visibal:NO];
            [self.lsBankName visibal:NO];
            [self.lstProvince visibal:NO];
            [self.lstCity visibal:NO];
            [self.lsAccount initLabel:@"支付宝账号" withHit:nil isrequest:NO type:0 ];
            [self.lsName initLabel:@"姓名" withHit:nil isrequest:NO type:0];
            
            // 用户在微店指定了退款方式的
            if (_customerReturnPayVo && [NSString isNotBlank:_customerReturnPayVo.payAccount]) {
                [self.lsAccount initData:_customerReturnPayVo.payAccount];
                [self.lsPayTypeName initData:_customerReturnPayVo.payTypeName withVal:[NSString stringWithFormat:@"%hd",_customerReturnPayVo.payType]];
                [self.lsName initData:_customerReturnPayVo.accountName];
            }
        }
    }
    
     [UIHelper refreshUI:self.scrollView scrollview:self.scrollView];
}


#pragma mark - delegate -

// @protocol INavigateEvent
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        [self popToLatestViewController:kCATransitionFromLeft];
    }
}

// @protocol IEditItemListEvent
- (void)onItemListClick:(EditItemList *)obj {
    
    if ([obj isEqual:self.lsOrderDetail]) {
       
        WechatOrderDetailView *detailView = [[WechatOrderDetailView alloc] initWithNibName:[SystemUtil getXibName:@"WechatOrderDetailView"] bundle:nil];
        detailView.orderId = self.sellReturnVo.orignId;
        detailView.orderType = 1;
        detailView.shopId = self.sellReturnVo.shopId;
        detailView.receiverName = self.sellReturnVo.customerName;
        [self pushController:detailView from:kCATransitionFromRight];
    
    } else if ([obj isEqual:self.lsPayTypeName]) {
        
        [OptionPickerBox initData:self.payTypeItems itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    
    } else if ([obj isEqual:self.lsBankName]) {
    
        [self selectBankType];
   
    } else if ([obj isEqual:self.lsBrachBankName]) {
    
        [self selectBranchBank];
    
    } else if ([obj isEqual:self.lstProvince]) {
      
        [self selectAccountProvince];
    
    } else if ([obj isEqual:self.lstCity]) {
    
        [self selectAccountCity];
    }
}

// 选择对应的
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    
    NameItemVO *item = (NameItemVO *)selectObj;
    if (eventType == self.lsPayTypeName.tag) {
        
        [self.lsPayTypeName initData:item.itemName withVal:item.itemId];
        [self showRefundAccountInfoByPayType:item.itemId.integerValue];
        _customerReturnPayVo.payType = item.itemId.integerValue;
        _customerReturnPayVo.payTypeName = item.itemName;

    } else if (eventType == self.lsBankName.tag) {
        
        [self.lsBankName initData:item.itemName withVal:item.itemId];
        _customerReturnPayVo.bankName = item.itemName;
    } else if (eventType == self.lstProvince.tag) {
        
        [self.lstProvince initData:item.itemName withVal:item.itemId];
        _customerReturnPayVo.bankProvince = item.itemName;
    } else if (eventType == self.lstCity.tag) {
        
        [self.lstCity initData:item.itemName withVal:item.itemId];
        _customerReturnPayVo.bankCity = item.itemName;
    } else if (eventType == self.lsBrachBankName.tag) {
        
        [self.lsBrachBankName initData:item.itemName withVal:item.itemId];
        _customerReturnPayVo.branchName = item.itemName;
    }
    return YES;
}


- (void)loadSellReturnMoney:(BOOL)isPush callBack:(SellReturnMoneyDetail)callBack{
    self.sellReturnMoneyDetailBlock = callBack;
}

// 验证必填项
- (BOOL)checkRequireItems {
    
    if ([ObjectUtil isNotNull:_customerReturnPayVo]) {
        return YES;
    }
    if ([self.lsPayTypeName getStrVal].intValue == 1) {//银行卡
        if ([NSString isBlank:[self.lsAccount getStrVal]] && [NSString isBlank:[self.lsName getStrVal]] && [NSString isBlank:[self.lsBankName getStrVal]] && [NSString isBlank:[self.lstProvince getStrVal]] && [NSString isBlank:[self.lstCity getStrVal]] && [NSString isBlank:[self.lsBrachBankName getStrVal]]) {
            return YES;
        }
        if ([NSString isBlank:[self.lsAccount getStrVal]]) {
            [LSAlertHelper showAlert:@"银行账号不能为空，请输入!"];
            return NO;
        }
        if (self.lsAccount.txtVal.text.length < 16) {
            [LSAlertHelper showAlert:@"银行账号不能少于16位，请输入!"];
            return NO;
        }
        if ([NSString isBlank:[self.lsName getStrVal]]) {
            [LSAlertHelper showAlert:@"持卡人不能为空，请输入!"];
            return NO;
        }
        if ([NSString isBlank:[self.lsBankName getStrVal]]) {
            [LSAlertHelper showAlert:@"开户银行不能为空，请输入!"];
            return NO;
        }
        if ([NSString isBlank:[self.lstProvince getStrVal]]) {
            [LSAlertHelper showAlert:@"开户省份不能为空，请输入!"];
            return NO;
        }
        
        if ([NSString isBlank:[self.lstCity getStrVal]]) {
            [LSAlertHelper showAlert:@"开户城市不能为空，请输入!"];
            return NO;
        }
        
        if ([NSString isBlank:[self.lsBrachBankName getStrVal]]) {
            [LSAlertHelper showAlert:@"开户支行不能为空，请输入!"];
            return NO;
        }
        _customerReturnPayVo.bankName=[self.lsBankName getDataLabel];
        _customerReturnPayVo.branchName=[self.lsBrachBankName getDataLabel];
    } else {
        if ([self.lsPayTypeName getStrVal].intValue == 2) {//微信
            if ([NSString isBlank:[self.lsAccount getStrVal]] && [NSString isBlank:[self.lsName getStrVal]]) {
                return YES;
            }
            if ([NSString isBlank:[self.lsAccount getStrVal]]) {
                [LSAlertHelper showAlert:@"微信账号不能为空，请输入!"];
                return NO;
            }
            
            if ([NSString isBlank:[self.lsName getStrVal]]) {
                [LSAlertHelper showAlert:@"姓名不能为空，请输入!"];
                return NO;
            }
        } else if ([self.lsPayTypeName getStrVal].intValue == 3) {//支付宝
            if ([NSString isBlank:[self.lsAccount getStrVal]] && [NSString isBlank:[self.lsName getStrVal]]) {
                return YES;
            }
            if ([NSString isBlank:[self.lsAccount getStrVal]]) {
                [LSAlertHelper showAlert:@"支付宝账号不能为空，请输入!"];
                return NO;
            }
            
            if ([NSString isBlank:[self.lsName getStrVal]]) {
                [LSAlertHelper showAlert:@"姓名不能为空，请输入!"];
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - 网络请求 -
// 获取银行类型列表
- (void)selectBankType {
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [BaseService getRemoteLSOutDataWithUrl:@"pay/area/v1/get_banks" param:nil withMessage:nil show:YES CompletionHandler:^(id json) {
        
        for (NSDictionary *obj in json[@"data"]) {
            NameItemVO *itemVo = [[NameItemVO alloc] initWithVal:obj[@"bankDisplayName"] andId:obj[@"bankName"]];
            [arr addObject:itemVo];
        }
        [OptionPickerBox initData:arr itemId:[self.lsBankName getStrVal]];
        [OptionPickerBox show:self.lsBankName.lblName.text client:self event:self.lsBankName.tag];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}

// 选择开卡市
- (void)selectAccountCity {
    if ([NSString isBlank:[self.lstProvince getStrVal]]) {
        [LSAlertHelper showAlert:@"请选择开户省份"];
        return;
    }
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSDictionary *param = @{@"bankName":[self.lsBankName getStrVal],
                            @"provinceNo":[self.lstProvince getStrVal]};
    [BaseService getRemoteLSOutDataWithUrl:@"pay/area/v1/get_bank_cities" param:[param mutableCopy] withMessage:nil show:YES CompletionHandler:^(id json) {
        
        for (NSDictionary *obj in  json[@"data"]) {
            NameItemVO *itemVo = [[NameItemVO alloc] initWithVal:obj[@"cityName"] andId:obj[@"cityNo"]];
            [arr addObject:itemVo];
        }
        [OptionPickerBox initData:arr itemId:[self.lstCity getStrVal]];
        [OptionPickerBox show:self.lstCity.lblName.text client:self event:self.lstCity.tag];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}

// 选择开卡省份
- (void)selectAccountProvince {
    if ([NSString isBlank:[self.lsBankName getStrVal]]) {
        [LSAlertHelper showAlert:@"请选择开户银行"];
        return;
    }
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:6];
    [param setValue:[self.lsBankName getStrVal] forKey:@"bankName"];
    [BaseService getRemoteLSDataWithUrl:@"userBank/selectProvinceList" param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        
        for (NSDictionary *obj in  json[@"provinceList"]) {
            NameItemVO *itemVo = [[NameItemVO alloc] initWithVal:obj[@"provinceName"] andId:obj[@"provinceNo"]];
            [arr addObject:itemVo];
        }
        [OptionPickerBox initData:arr itemId:[self.lstProvince getStrVal]];
        [OptionPickerBox show:self.lstProvince.lblName.text client:self event:self.lstProvince.tag];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}

// 选择开户支行
- (void)selectBranchBank {
    
    if ([NSString isBlank:[self.lstCity getStrVal]]) {
        [LSAlertHelper showAlert:@"请选择开户城市"];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[self.lsBankName getStrVal] forKey:@"bankName"];
    [param setValue:[self.lstCity getStrVal] forKey:@"cityNo"];
    [BaseService getRemoteLSOutDataWithUrl:@"pay/area/v1/get_sub_banks" param:param withMessage:nil show:YES CompletionHandler:^(id json) {//查询银行开户支行
        NSArray *array = json[@"data"];
        NSMutableArray *optionList = [[NSMutableArray alloc] init];
        for (NSDictionary *obj in array) {
            ShopInfoVO *shopInfoVO =[ShopInfoVO mj_objectWithKeyValues:obj];
            NameItemVO *nameItem = [[NameItemVO alloc] initWithVal:shopInfoVO.subBankName andId:shopInfoVO.subBankNo];
            [optionList addObject:nameItem];
        }
        
        SelectItemList *vc = [[SelectItemList alloc] initWithtxtTitle:@"开户支行" txtPlaceHolder:@"输入支行关键字"];
        __weak WeChatReturnMoneyDetail *weakSelf = self;
        [vc selectId:[self.lsBrachBankName getStrVal] list:optionList callBlock:^(id<INameItem> item) {
            if (item) {
                [weakSelf.lsBrachBankName changeData:[item obtainItemName] withVal:[item obtainItemId]];
            }
        }];
        [self pushController:vc from:kCATransitionFromRight];
        
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}

// 手动退款操作
- (void)manulRefundAction {
  
    if([self checkRequireItems]) {
        // 账号和账户人姓名，是非必填项，提交退款信息时先保存
        _customerReturnPayVo.payAccount = [self.lsAccount getStrVal]; // 账号
        _customerReturnPayVo.accountName = [self.lsName getStrVal]; // 账户拥有人姓名
        _customerReturnPayVo.branchName = [self.lsBrachBankName getDataLabel]; // 开户支行
        _sellReturnVo.customerReturnPayVo = [CustomerReturnPayVo getDictionaryData:_customerReturnPayVo];
        [_sellReturnService sellReturnMoneyBatchOpera:@[[self.sellReturnVo convertToDic]]
                                                 flag:1
                                    completionHandler:^(id json) {
                                        [self popToLatestViewController:kCATransitionFromLeft];
                                        if (self.sellReturnMoneyDetailBlock) {
                                             self.sellReturnMoneyDetailBlock(nil);
                                        }
                                    } errorHandler:^(id json) {
                                        [LSAlertHelper showAlert:json];
                                    }];
    }
}

// 获取当前订单状态
- (NSString *)getStatusString:(short)status {
    NSDictionary *statusDic = @{@"1":@"待审核", @"2":@"退款成功", @"3":@"同意退货", @"4":@"退货中", @"5":@"待退款", @"6":@"拒绝退货", @"7":@"拒绝退款", @"8":@"取消退货", @"9":@"退款失败"};
    NSString *statusString = [statusDic objectForKey:[NSString stringWithFormat:@"%i", status]];
    if ([NSString isNotBlank:statusString]) {
        return statusString;
    }
    return @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
