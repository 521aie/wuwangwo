//
//  DistributionView.m
//  retailapp
//
//  Created by  diwangxie on 16/03/14.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "DistributionView.h"
#import "UIHelper.h"
#import "SymbolNumberInputBox.h"
#import "LSEditItemRadio.h"
#import "LSEditItemText.h"
#import "LSEditItemList.h"

#import "WechatService.h"
#import "ServiceFactory.h"

#import "ExpressVo.h"
#import "JsonHelper.h"
#import "AlertBox.h"

#import "OptionPickerBox.h"
#import "IEditItemListEvent.h"
#import "SendTimeListView.h"
#import "DicVo.h"
//#import "CheckUnit.h"
#import "NSString+Estimate.h"
#import "NameItemVO.h"


#define SELF_PICK_UP 1
//#define FREE_SEND 2
#define ORDER_SEND_STRATEGY 2
#define ORDER_SEND_TYPE 3
#define ORDER_SEND_COMPANY 4
#define ORDER_SEND_DELIVERY 5
#define ORDER_SEND_CONDITION 6
#define ORDER_SEND_COST 7
#define ORDER_SEND_NUMBER 8
#define ORDER_SEND_SUM 9
#define TAG_ORDER_TIME 10
#define TAG_HOME_DEILVERY 11
#define TAG_SEND_FEE 12
#define SEND_TIME 10

@interface DistributionView () <IEditItemRadioEvent, OptionPickerClient, SymbolNumberInputClient, IEditItemListEvent>

@property (strong, nonatomic) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *container;

@property (strong, nonatomic) LSEditItemRadio *radSelfPickUp;

@property (strong, nonatomic) LSEditItemList *lstSendStrategy;

@property (strong, nonatomic) LSEditItemList *lstSendType;

@property (strong, nonatomic) LSEditItemList *lstSendCompany;

@property (strong, nonatomic) LSEditItemList *txtSendTime;

@property (strong, nonatomic) LSEditItemList *lstSendDelivery;

@property (strong, nonatomic) LSEditItemList *lstSendCondition;

@property (strong, nonatomic) LSEditItemList *lstSendCost;
@property (strong, nonatomic) LSEditItemList *lstSendNumber;
@property (strong, nonatomic) LSEditItemList *lstSendSum;
/** 配送范围 */
@property (nonatomic, strong) LSEditItemText *txtSendRange;
@property (strong, nonatomic) UIView *messageView;
//预约时间
@property (strong, nonatomic) LSEditItemList *lstTOrderTime;
//配送到家
@property (strong, nonatomic) LSEditItemRadio *rdoHomeDelivery;
//起送金额
@property (strong, nonatomic) LSEditItemList *lstSendFee;

@property (nonatomic, strong) WechatService* wechatService;
@property (nonatomic, strong) ExpressVo *express;

@property (nonatomic, strong) NSArray *distributionStrategyList;

@property (nonatomic, strong) NSArray *distributionTypeList;

@property (nonatomic, strong) NSArray *logisticsCompanyList;

@property (nonatomic, strong) NSArray *isFreeShippingList;

@property (nonatomic, strong) NSArray *freeShippingConditionList;

@end

@implementation DistributionView


- (void)viewDidLoad {
    [super viewDidLoad];
    self.wechatService = [ServiceFactory shareInstance].wechatService;
    [self initNavigate];
    [self configViews];
    [self initMainView];
    [self registerNotification];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
//    [UIHelper clearColor:self.container];
    [self loadData];
    [self configHelpButton:HELP_WECHAT_DISTRIBUTION_MANAGEMENT];
}
- (void)initNavigate {
    [self configTitle:@"配送管理" leftPath:Head_ICON_BACK  rightPath:nil];
}



- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    
    self.radSelfPickUp = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.radSelfPickUp];
    
    self.lstTOrderTime = [LSEditItemList editItemList];
    [self.container addSubview:self.lstTOrderTime];
    
    self.rdoHomeDelivery = [LSEditItemRadio editItemRadio];
    [self.container addSubview:self.rdoHomeDelivery];
    
    self.txtSendRange = [LSEditItemText editItemText];
    [self.container addSubview:self.txtSendRange];
    
    self.lstSendStrategy = [LSEditItemList editItemList];
    [self.container addSubview:self.lstSendStrategy];
    
    self.lstSendFee = [LSEditItemList editItemList];
    [self.container addSubview:self.lstSendFee];
    
    self.lstSendType = [LSEditItemList editItemList];
    [self.container addSubview:self.lstSendType];
    
    self.lstSendCompany = [LSEditItemList editItemList];
    [self.container addSubview:self.lstSendCompany];
    
    self.txtSendTime = [LSEditItemList editItemList];
    [self.container addSubview:self.txtSendTime];
    
    self.lstSendDelivery = [LSEditItemList editItemList];
    [self.container addSubview:self.lstSendDelivery];
    
    self.lstSendCondition = [LSEditItemList editItemList];
    [self.container addSubview:self.lstSendCondition];
    
    self.lstSendSum = [LSEditItemList editItemList];
    [self.container addSubview:self.lstSendSum];
    
    self.lstSendNumber = [LSEditItemList editItemList];
    [self.container addSubview:self.lstSendNumber];
    
    self.lstSendCost = [LSEditItemList editItemList];
    [self.container addSubview:self.lstSendCost];
    
    UILabel *lbl = [LSViewFactor addExplainText:self.container text:@"提示：\n1、配送策略选择“系统自动分单”时，系统自动按整单隶属、整单利润最大化、拆单隶属、拆单利润最大化进行分单。\n2、若选择“系统自动分单”，请打开微店-微店设置中的“启用微店虚拟库存”开关，并在微店-微店虚拟库存中设置微店商品的虚拟库存，否则系统将无法正常分单。" y:0];
    self.messageView = lbl;
    
}
- (void)registerNotification
{
    [UIHelper initNotification:self.container event:Notification_UI_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_Change object:nil];
}

- (void)dataChange:(NSNotification*)notification
{
    [self editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];
}

- (void)initMainView {
    [self.radSelfPickUp initLabel:@"允许上门自提" withHit:@"" delegate:self];
    self.radSelfPickUp.tag = SELF_PICK_UP;
    [self.lstTOrderTime initLabel:@"▪︎ 预约时间" withHit:nil delegate:self];
    self.lstTOrderTime.imgMore.image = [UIImage imageNamed:@"ico_next"];
    self.lstTOrderTime.tag = TAG_ORDER_TIME;
    [self.rdoHomeDelivery initLabel:@"允许配送到家" withHit:@"" delegate:self];
    self.rdoHomeDelivery.tag = TAG_HOME_DEILVERY;
    //微店配送管理新增“配送范围”输入项，必填，最多可输入25个汉字
    [self.txtSendRange initLabel:@"配送范围" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtSendRange initMaxNum:25];
    [self.lstSendStrategy initLabel:@"配送策略" withHit:nil isrequest:NO delegate:self];
    self.lstSendStrategy.tag = ORDER_SEND_STRATEGY;
    [self.lstSendFee initLabel:@"起送金额(元)" withHit:nil isrequest:NO delegate:self];
    self.lstSendFee.tag = TAG_SEND_FEE;
    [self.lstSendType initLabel:@"配送类型" withHit:nil isrequest:YES delegate:self];
    self.lstSendType.tag = ORDER_SEND_TYPE;
    
    [self.lstSendCompany initLabel:@"▪︎ 默认物流公司" withHit:nil isrequest:NO delegate:self];
    self.lstSendCompany.tag = ORDER_SEND_COMPANY;
    
    [self.txtSendTime initLabel:@"▪︎ 配送时间" withHit:nil isrequest:NO delegate:self];
    self.txtSendTime.tag = SEND_TIME;
    self.txtSendTime.imgMore.image=[UIImage imageNamed:@"ico_next.png"];
    [self.lstSendDelivery initLabel:@"是否包邮" withHit:nil isrequest:YES delegate:self];
    self.lstSendDelivery.tag = ORDER_SEND_DELIVERY;
    [self.lstSendCondition initLabel:@"▪︎ 包邮条件" withHit:nil isrequest:YES delegate:self];
    self.lstSendCondition.tag = ORDER_SEND_CONDITION;
    [self.lstSendCost initLabel:@"▪︎ 默认配送费(元)" withHit:nil isrequest:YES delegate:self];
    self.lstSendCost.tag = ORDER_SEND_COST;
    
    [self.lstSendNumber initLabel:@"▪︎ 件数" withHit:nil isrequest:YES delegate:self];
    self.lstSendNumber.tag = ORDER_SEND_NUMBER;
    
    [self.lstSendSum initLabel:@"▪︎ 金额(元)" withHit:nil isrequest:YES delegate:self];
    self.lstSendSum.tag = ORDER_SEND_SUM;
    if ([[Platform Instance] getShopMode] == 1 || [[Platform Instance] getShopMode] == 2) {
        self.messageView.hidden=YES;
    } else {
        self.messageView.hidden=NO;
    }
    self.container.hidden = YES;
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];

}


#pragma mark - 控制什么条件下显示
- (void)initData {
    //避免干扰数据默认全部隐藏式为了控制什么条件下显示不可去掉
    for (UIView *obj in self.container.subviews) {
        if ([obj isKindOfClass:[EditItemBase class]]) {
            EditItemBase *item = (EditItemBase *)obj;
            [item visibal:NO];
        }
    }
    //上门自提开关显示
    [self.radSelfPickUp visibal:YES];
    //上门自提开关打开时预约时间显示
    if ([self.radSelfPickUp getVal]) {
        //预约时间
        [self.lstTOrderTime visibal:YES];
    } else {
        [self.lstTOrderTime visibal:NO];
    }
    
    //允许配送到家开关显示
    [self.rdoHomeDelivery visibal:YES];
    //允许配送到家开关打开时其下方的显示 反之则关闭
    if ([self.rdoHomeDelivery getVal]) {
        //配送策略单店, 门店不显示
        if ([[Platform Instance] getShopMode] == 3 ) {
            [self.lstSendStrategy visibal:YES];
        }
        //起送金额
        [self.lstSendFee visibal:YES];
        //配送类型
        [self.lstSendType visibal:YES];
        //配送范围
        [self.txtSendRange visibal:YES];
        
        //配送类型选择店家配送时显示配送时间
        if ([[self.lstSendType getDataLabel] isEqualToString:@"店家配送"]) {
            [self.txtSendTime visibal:YES];
        } else if ([[self.lstSendType getDataLabel] isEqualToString:@"第三方物流配送"]) {
            //默认物流公司
            [self.lstSendCompany visibal:YES];
        }
        //是否包邮
        [self.lstSendDelivery visibal:YES];
        if ([[self.lstSendDelivery getDataLabel] isEqualToString:@"指定条件包邮"]) {
            //指定条件包邮时显示包邮条件 金额
            //包邮条件
             [self.lstSendCondition visibal:YES];
            //包邮条件选择金额时显示金额 选择件数时显示件数 选择件数加金额时 显示 金额件数
            if ([[self.lstSendCondition getDataLabel] isEqualToString:@"金额"]) {
                [self.lstSendSum visibal:YES];
            } else if ([[self.lstSendCondition getDataLabel] isEqualToString:@"件数"]) {
                [self.lstSendNumber visibal:YES];
            } else if ([[self.lstSendCondition getDataLabel] isEqualToString:@"件数+金额"]) {
                [self.lstSendNumber visibal:YES];
                 [self.lstSendSum visibal:YES];
            }
            //指定条件包邮显示默认配送费
             [self.lstSendCost visibal:YES];
        } else if ([[self.lstSendDelivery getDataLabel] isEqualToString:@"不包邮"]) {
            [self.lstSendCost visibal:YES];
        }
        

    } else {
        [self.lstSendStrategy visibal:NO];
        [self.lstSendFee visibal:NO];
        [self.lstSendType visibal:NO];
        [self.lstSendCompany visibal:NO];
        [self.lstSendDelivery visibal:NO];
        [self.lstSendCondition visibal:NO];
        [self.lstSendSum visibal:NO];
        [self.lstSendNumber visibal:NO];
        [self.lstSendCost visibal:NO];
    }
    
    [self.txtSendRange visibal:NO];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}
- (void)viewWillAppear:(BOOL)animated {
    
}
- (void)loadData {
    __strong typeof(self) wself = self;
    NSString *url = @"microShop/selectDicList";
    [BaseService getRemoteLSDataWithUrl:url param:nil withMessage:nil show:NO CompletionHandler:^(id json) {
        wself.distributionStrategyList=[JsonHelper transList:[json objectForKey:@"distributionStrategyList"] objName:@"DicVo"];
        
        wself.distributionTypeList=[JsonHelper transList:[json objectForKey:@"distributionTypeList"] objName:@"DicVo"];
        
        wself.logisticsCompanyList=[JsonHelper transList:[json objectForKey:@"logisticsCompanyList"] objName:@"DicVo"];
        
        wself.isFreeShippingList=[JsonHelper transList:[json objectForKey:@"isFreeShippingList"] objName:@"DicVo"];
        wself.freeShippingConditionList=[JsonHelper transList:[json objectForKey:@"freeShippingConditionList"] objName:@"DicVo"];
        [_wechatService selectExpress:[[Platform Instance] getkey:SHOP_ID] completionHandler:^(id json) {
            [wself responseToSucessed:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)responseToSucessed:(NSMutableDictionary *)json {
    self.container.hidden = NO;
    self.express = [JsonHelper dicTransObj:[json objectForKey:@"express"] obj:[ExpressVo new]];
    if(self.express && self.express.entityId){
        //赋值顺序不允许变动 会影响显示
        //允许上门自提
        [self.radSelfPickUp initData:self.express.isSelfPickUp==1?@"1":@"0"];
        //预约时间后台默认是0需要排除
        if (self.express.reservationTime.length > 0 && ![self.express.reservationTime isEqualToString:@"0"]) {
            [self.lstTOrderTime initHit:self.express.reservationTime];
            NSArray *array = [self.express.reservationTime componentsSeparatedByString:@","];
            [self.lstTOrderTime initData:[NSString stringWithFormat:@"%lu项", (unsigned long)[array count]] withVal:self.express.reservationTime];
        } else {
            [self.lstTOrderTime initData:@"0项" withVal:nil];
        }
        //允许配送到家开关
        [self.rdoHomeDelivery initData:self.express.isSendHome==1?@"1":@"0"];
        //配送策略
        for (DicVo *dicVo in self.distributionStrategyList) {
            if (dicVo.val == self.express.sendStrategy) {
                [self.lstSendStrategy initData:dicVo.name withVal:[NSString stringWithFormat:@"%ld", (long)dicVo.val]];
                break;
            }
        }
        //起送金额
        [self.lstSendFee initData:[NSString stringWithFormat:@"%.2f",self.express.sendStartMoney] withVal:nil];
        //配送类型
        for (DicVo *dicVo in self.distributionTypeList) {
            if (dicVo.val == self.express.sendType) {
                [self.lstSendType initData:dicVo.name withVal:[NSString stringWithFormat:@"%ld", (long)dicVo.val]];
                break;
            }
        }
        //配送范围
        [self.txtSendRange initData:self.express.sendRange];
        //配送时间
        if (self.express.sendTime.length > 0) {
            [self.txtSendTime initHit:self.express.sendTime];
            NSArray *array = [self.express.sendTime componentsSeparatedByString:@","];
            [self.txtSendTime initData:[NSString stringWithFormat:@"%lu项", (unsigned long)[array count]] withVal:self.express.sendTime];
        } else {
            [self.txtSendTime initData:@"0项" withVal:nil];
        }
        
        //物流公司
        if ([[self.lstSendType getDataLabel] isEqualToString:@"店家配送"]) {
            for (DicVo *dicVo in self.logisticsCompanyList) {
                if ([dicVo.name isEqualToString:@"中通快递"]) {
                    [self.lstSendCompany  initData:dicVo.name withVal:[NSString stringWithFormat:@"%ld", (long)dicVo.val]];
                    break;
                }
            }
        } else {
            for (DicVo *dicVo in self.logisticsCompanyList) {
                if (dicVo.val == self.express.logisticsCompany) {
                    [self.lstSendCompany  initData:dicVo.name withVal:[NSString stringWithFormat:@"%ld", (long)dicVo.val]];
                    break;
                }
            }
        }
        //是否包邮
        for (DicVo *dicVo in self.isFreeShippingList) {
            if (dicVo.val == self.express.isFreeShipping) {
                //是否包邮
                [self.lstSendDelivery  initData:dicVo.name withVal:[NSString stringWithFormat:@"%ld", (long)dicVo.val]];
                break;
            }
        }
        //包邮条件
        for (DicVo *dicVo in self.freeShippingConditionList) {
            if (dicVo.val == self.express.freeShippingType) {
                //包邮条件
                [self.lstSendCondition  initData:dicVo.name withVal:[NSString stringWithFormat:@"%ld", (long)dicVo.val]];
                break;
            }
        }
        //新店第一次的时候包邮条件给的是0我们默认请选择
        if ([NSString isBlank:[self.lstSendCondition getStrVal]]) {
             [self.lstSendCondition  initData:@"请选择" withVal:nil];
        }
        
        //件数
        [self.lstSendNumber initData:[NSString stringWithFormat:@"%d", self.express.freeShippingCount] withVal:[NSString stringWithFormat:@"%d", self.express.freeShippingCount]];
        
        //金额
         [self.lstSendSum initData:[NSString stringWithFormat:@"%.2f", self.express.freeShippingMoney] withVal:[NSString stringWithFormat:@"%.2f", self.express.freeShippingMoney]];
        //默认配送费
        [self.lstSendCost initData:[NSString stringWithFormat:@"%.2f",self.express.sendCost] withVal:[NSString stringWithFormat:@"%.2f",self.express.sendCost]];
          [self initData];
    }
}


- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event == LSNavigationBarButtonDirectLeft) {
        [self popViewController];
    } else {
        [self saveSendManage];
    }
}

-(void) onItemRadioClick:(LSEditItemRadio*)obj {
    [self initData];
}

- (void)onItemListClick:(LSEditItemList*)obj {
    if(obj == self.lstSendStrategy){
        //配送策略弹出框
        NameItemVO *item = nil;
        NSMutableArray *list = [NSMutableArray array];
        for (DicVo *obj in self.distributionStrategyList) {
            item = [[NameItemVO alloc] initWithVal:obj.name andId:[NSString stringWithFormat:@"%ld",obj.val]];
            if([obj.name isEqual:@"总部统一配送"]){
                
            }else{
                [list addObject:item];
            }
        }
        [OptionPickerBox initData:list itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }else if(obj==self.lstSendType){
        //配送类型弹出框
        //根据设计书，调整数据顺序
        DicVo* dicVo = nil;
        NSMutableArray *typeList=[[NSMutableArray alloc] init];
        NSInteger s = self.distributionTypeList.count;
        for(int x=0;x<self.distributionTypeList.count;x++){
            s=s-1;
            dicVo=[self.distributionTypeList objectAtIndex:s];
            [typeList addObject:dicVo];
        }
        [OptionPickerBox initData:typeList itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }else if (obj==self.lstSendCompany){
        //默认物流公司弹出框
        DicVo* dicVo = nil;
        NSMutableArray *typeList=[[NSMutableArray alloc] init];
        for(int x=0;x<self.logisticsCompanyList.count-1;x++){
            dicVo=[self.logisticsCompanyList objectAtIndex:x];
            [typeList addObject:dicVo];
        }
        [OptionPickerBox initData:typeList  itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }else if (obj==self.lstSendDelivery){
        //是否包邮弹出框
        DicVo* dicVo1=[[DicVo alloc]init];
        DicVo* dicVo2=[[DicVo alloc]init];
        DicVo* dicVo3=[[DicVo alloc]init];
        NSMutableArray *typeList=[[NSMutableArray alloc] init];
        for(int x=0;x<self.isFreeShippingList.count;x++){
            if(x==0){
                dicVo1=[self.isFreeShippingList objectAtIndex:x];
            }else if(x==1){
                dicVo2=[self.isFreeShippingList objectAtIndex:x];
            }else{
                dicVo3=[self.isFreeShippingList objectAtIndex:x];
            }
        }
        [typeList addObject:dicVo2];
        [typeList addObject:dicVo3];
        [typeList addObject:dicVo1];
        [OptionPickerBox initData:typeList itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        
    }else if (obj==self.lstSendCondition){
        //包邮条件弹出框
        [OptionPickerBox initData:[self.freeShippingConditionList mutableCopy] itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        
    }else if (obj==self.lstSendNumber){
        //件数弹出框
        [SymbolNumberInputBox initData:[self.lstSendNumber getDataLabel]];
        [SymbolNumberInputBox show:@"件数" client:self isFloat:NO isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:0];
        
    }else if (obj==self.lstSendSum){
        //金额弹出框
        [SymbolNumberInputBox initData:[self.lstSendSum getDataLabel]];
        [SymbolNumberInputBox show:@"金额(元)" client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
    }else if (obj==self.lstSendFee){//起送金额
        //起送金额弹出框
        [SymbolNumberInputBox initData:[self.lstSendFee getDataLabel]];
        [SymbolNumberInputBox show:@"起送金额(元)" client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
    }else if(obj==self.lstSendCost){
        //配送费用输入框
        [SymbolNumberInputBox initData:[self.lstSendCost getDataLabel]];
        [SymbolNumberInputBox show:@"默认配送费(元)" client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
    }else if(obj==self.txtSendTime || obj==self.lstTOrderTime){
        SendTimeListView *sendTimeListView = [[SendTimeListView alloc] initWithNibName:[SystemUtil getXibName:@"SendTimeListView"] bundle:nil parent:nil];
        self.view.hidden = YES;
        if (obj == self.txtSendTime) {
            sendTimeListView.navTitle = @"配送时间";
        } else if (obj == self.lstTOrderTime) {
            sendTimeListView.navTitle = @"预约时间";
        }
        [sendTimeListView setCallBack:^(NSArray *sendTimeList){
            self.view.hidden = NO;
            
            NSString *sendtime = nil;
            
            for (NSDictionary *dic in sendTimeList) {
                if (sendtime == nil) {
                    sendtime = [NSString stringWithFormat:@"%@~%@",dic[@"startTime"], dic[@"endTime"]];
                } else {
                    sendtime = [NSString stringWithFormat:@"%@,%@~%@", sendtime, dic[@"startTime"], dic[@"endTime"]];
                }
            }
            if (obj == self.txtSendTime) {
                [self.txtSendTime changeData:[NSString stringWithFormat:@"%ld项", sendTimeList.count] withVal:sendtime];
                [self.txtSendTime initHit:sendtime];
            } else if (obj == self.lstTOrderTime) {
                [self.lstTOrderTime changeData:[NSString stringWithFormat:@"%ld项", sendTimeList.count] withVal:sendtime];
                [self.lstTOrderTime initHit:sendtime];
            }
           
            
            [UIHelper refreshUI:self.container scrollview:self.scrollView];
        }];
        if (obj == self.txtSendTime) {
           sendTimeListView.sendTime = self.txtSendTime.lblDetail.text ;
        } else if (obj == self.lstTOrderTime) {
            sendTimeListView.sendTime = self.lstTOrderTime.lblDetail.text ;
        }
        
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [self.navigationController pushViewController:sendTimeListView animated:NO];
    }
}


- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = selectObj;
    if (eventType == ORDER_SEND_STRATEGY) {
        [self.lstSendStrategy changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if(eventType == ORDER_SEND_TYPE){
        [self.lstSendType changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if(eventType == ORDER_SEND_DELIVERY){
        [self.lstSendDelivery changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if(eventType == ORDER_SEND_COMPANY){
        [self.lstSendCompany changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }else if (eventType==ORDER_SEND_CONDITION){
        [self.lstSendCondition changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    [self initData];
    return YES;
}
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    
    if (eventType == ORDER_SEND_NUMBER) {
        [self.lstSendNumber changeData:val withVal:val];
    }else if (eventType==ORDER_SEND_SUM){
        [self.lstSendSum changeData:val withVal:val];
    }else if(eventType==ORDER_SEND_COST){
        [self.lstSendCost changeData:val withVal:val];
    }else if(eventType==TAG_SEND_FEE){
        [self.lstSendFee changeData:val withVal:val];
    }
    
}
- (void)saveSendManage {
    
    if (self.express == nil) {
        self.express = [[ExpressVo alloc] init];
    }
    if ([NSString isBlank:[self.txtSendRange getStrVal]] && self.txtSendRange.hidden == NO) {
        [LSAlertHelper showAlert:@"请输入配送范围！"];
        return;
    }
    if ([NSString isBlank:[self.lstSendCondition getStrVal]] && self.lstSendCondition.hidden == NO) {
        [AlertBox show:@"请选择包邮条件！"];
        return;
    }
    if (!self.lstSendSum.hidden&&[NSString isBlank:self.lstSendSum.lblVal.text]) {
        [AlertBox show:@"请输入金额"];
        return;
    }
    
    if (!self.lstSendNumber.hidden&&[NSString isBlank:self.lstSendNumber.lblVal.text]) {
        [AlertBox show:@"请输入件数"];
        return;
    }
    
    if (!self.lstSendCost.hidden&&[NSString isBlank:self.lstSendCost.lblVal.text]) {
        [AlertBox show:@"请输入配送费"];
        return;
    }
    if ((![self.radSelfPickUp getVal]) && (![self.rdoHomeDelivery getVal]) ) {
        [AlertBox show:@"允许上门自提\"和\"允许配送到家\"，两个开关不能同时关闭，必须保证至少一个开关为打开状态！"];
        return;
    }
    
    self.express.entityId = [[Platform Instance] getkey:ENTITY_ID];
    self.express.shopId = [[Platform Instance] getkey:SHOP_ID];
    self.express.isSelfPickUp = self.radSelfPickUp.getVal?1:0;
    if ([[Platform Instance] getShopMode] == 3 || [[Platform Instance] getShopMode] == 2) {
        self.express.sendStrategy= [[self.lstSendStrategy getStrVal] intValue];
        self.express.sendStrategyName=[self.lstSendStrategy getDataLabel];
    }
    //配送范围
    self.express.sendRange = [self.txtSendRange getStrVal];
    self.express.sendType=[[self.lstSendType getStrVal] intValue];
    self.express.sendTypeName=[self.lstSendType getDataLabel];
    if([[self.lstSendType getDataLabel] isEqualToString:@"第三方物流配送"]){
        self.express.logisticsCompany=[[self.lstSendCompany getStrVal] intValue];
        if([[self.lstSendCompany getStrVal] intValue]==0){
            self.express.logisticsCompany=[[self.lstSendCompany getStrVal] intValue]+1;
        }
        self.express.logisticsCompanyName=[self.lstSendCompany getDataLabel];
    }else if([[self.lstSendType getStrVal] intValue]==1){
        self.express.sendTime=self.txtSendTime.lblDetail.text;
    }
    self.express.reservationTime = self.lstTOrderTime.lblDetail.text;
    self.express.isFreeShipping=[[self.lstSendDelivery getStrVal] intValue];
    self.express.isFreeShippingName=[self.lstSendDelivery getDataLabel];
    self.express.sendCost=[[self.lstSendCost getDataLabel] doubleValue];
        self.express.freeShippingType=[[self.lstSendCondition getStrVal] intValue];
        if([[self.lstSendCondition getStrVal] intValue]==0){
            self.express.freeShippingType=[[self.lstSendCondition getStrVal] intValue]+1;
        }
        self.express.freeShippingTypeName=[self.lstSendCondition getDataLabel];
        if ([[self.lstSendCondition getStrVal] intValue]==1) {
            //金额条件包邮
            self.express.freeShippingMoney=[[self.lstSendSum getDataLabel] doubleValue];
            self.express.sendCost=[[self.lstSendCost getDataLabel] doubleValue];
            
        }else if ([[self.lstSendCondition getStrVal] intValue]==2){
            //件数条件包邮
            self.express.freeShippingCount=[[self.lstSendNumber getDataLabel] intValue];
            self.express.sendCost=[[self.lstSendCost getDataLabel] doubleValue];
        }else if([[self.lstSendCondition getStrVal] intValue]==3){
            //两个条件包邮
            self.express.freeShippingMoney=[[self.lstSendSum getDataLabel] doubleValue];
            self.express.freeShippingCount=[[self.lstSendNumber getDataLabel] intValue];
            self.express.sendCost=[[self.lstSendCost getDataLabel] doubleValue];
        }
        self.express.sendStartMoney=[[self.lstSendFee getDataLabel] doubleValue];
      self.express.isSendHome = self.rdoHomeDelivery.getVal?1:0;

    __strong DistributionView* strongSelf = self;
    //配送管理
    [_wechatService editExpress:self.express completionHandler:^(id json) {
        if (!(strongSelf)) {
            return ;
        }
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

@end
