//
//  LSSystemParameterController.m
//  retailapp
//
//  Created by guozhi on 2017/1/6.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSSystemParameterController.h"
#import "SettingModuleEvent.h"
#import "LSEditItemTitle.h"
#import "LSEditItemList.h"
#import "LSEditItemRadio.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "SymbolNumberInputBox.h"
#import "OptionPickerBox.h"
#import "SetRender.h"
#import "GlobalRender.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "ConfigItemOptionVo.h"
#import "GlobalRender.h"
#import "SalaryDateVo.h"
#import "LSBarCodeIdentificationController.h"
#import "LSBarCodeMark.h"
@interface LSSystemParameterController ()<IEditItemListEvent,IEditItemRadioEvent,OptionPickerClient,SymbolNumberInputClient>


@property (nonatomic,strong) UIScrollView* scrollView;

@property (nonatomic,strong) UIView* container;
/**收银设置标题*/
@property (nonatomic,strong) LSEditItemTitle* cashTitle;
/**收银时导购员必选*/
@property (nonatomic,strong) LSEditItemRadio *rdoGuider;
/**总金额零头处理*/
@property (nonatomic,strong) LSEditItemList *lsZero;
/**每项金额零头处理*/
@property (nonatomic,strong) LSEditItemList *lsPartZero;
/**是否整单折扣*/
@property (nonatomic,strong) LSEditItemRadio *rdoWholeDiscount;
/**最大折扣*/
@property (nonatomic,strong) LSEditItemList *lsMaxDiscount;
/**是否单品折扣*/
@property (nonatomic,strong) LSEditItemRadio *rdoSingleDiscount;
/**单品折扣*/
@property (nonatomic,strong) LSEditItemList *lsSingleDis;
/**出入库库存设置标题*/
@property (nonatomic,strong) LSEditItemTitle* rdoTitle;
/**是否查看同级店铺库存*/
@property (nonatomic,strong) LSEditItemRadio *rdoIsPeer;
/**是否启用装箱单*/
@property (nonatomic,strong) LSEditItemRadio *rdoPickBox;
/**是否积分商品库存*/
//@property (nonatomic,strong) EditItemRadio *rdoPointGoodsStock;
/**是否允许对配送中的收货单拒绝收货*/
@property (nonatomic,strong) LSEditItemRadio *rdoRefuse;
/**是否允许对配送中的收货单进行修改*/
@property (nonatomic,strong) LSEditItemRadio *rdoEdit;
@property (nonatomic,strong) SettingService* settingService;
/**支付方式列表*/
@property (nonatomic,strong) NSMutableArray* configItemVoList;
/**零头处理方式列表*/
@property (nonatomic,strong) NSMutableArray* remnantModelList;
/**会计期列表*/
@property (nonatomic,strong) NSMutableArray* salaryDateVoList;
/**负库存状态值*/
@property (nonatomic,copy) NSString* negativestoreStatus;
/** 客单相同商品合并数量 */
@property (nonatomic, strong) LSEditItemRadio *rdoGuestSameMergeGoods;

/** 门店调拨单需要上级审核 */
@property (strong, nonatomic) LSEditItemRadio *rdoNeedConfirm;
/** 启用条码秤 */
@property (nonatomic, strong) LSEditItemRadio *rdoEnableBarCodeScale;
/** 条码标识 */
@property (nonatomic, strong) LSEditItemList *lstBarCodeIdentification;
/** <#注释#> */
@property (nonatomic, strong) NSArray *barCodeMarkList;
/** 是否打印小票次数 */
@property (nonatomic, strong) LSEditItemRadio *rdoPrintfSmallTicketCount;
@end

@implementation LSSystemParameterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self initMainView];
    [self registerNotification];
    [self showView];
    [self selecrSysParam];
    [self configHelpButton:HELP_SETTING_SYSTEM_PARAMETER];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)configViews {
    //设置背景透明度
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //设置标题
    [self configTitle:@"系统参数" leftPath:Head_ICON_BACK rightPath:nil];
    //设置scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    
}


- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        [self removeNotification];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self save];
    }
}

#pragma mark - 初始化主视图
- (void)initMainView {
    
    //收银设置
    self.cashTitle = [LSEditItemTitle editItemTitle];
    [self.cashTitle configTitle:@"收银设置"];
    [self.container addSubview:self.cashTitle];
    //收银时导购员必选
    self.rdoGuider = [LSEditItemRadio editItemRadio];
    [self.rdoGuider initLabel:@"收银时导购员必选" withHit:nil];
    [self.container addSubview:self.rdoGuider];
    //总金额零头处理
    self.lsZero = [LSEditItemList editItemList];
    [self.lsZero initLabel:@"总金额零头处理" withHit:nil delegate:self];
    [self.container addSubview:self.lsZero];
    //每项金额零头处理
    self.lsPartZero = [LSEditItemList editItemList];
    [self.lsPartZero initLabel:@"每项金额零头处理" withHit:nil delegate:self];
    [self.container addSubview:self.lsPartZero];
    //允许整单折扣
    self.rdoWholeDiscount = [LSEditItemRadio editItemRadio];
    if ([[Platform Instance] lockAct:ACTION_WHOLE_DISCOUNT]) {
        [self.rdoWholeDiscount initLabel:@"允许整单折扣" withHit:@"如需使用，请设置整单折扣权限"];
    }else{
        [self.rdoWholeDiscount initLabel:@"允许整单折扣" withHit:@"如需使用，请设置整单折扣权限" delegate:self];
    }
    [self.container addSubview:self.rdoWholeDiscount];
    //▪︎ 最低折扣额度(%)
    self.lsMaxDiscount = [LSEditItemList editItemList];
    [self.lsMaxDiscount initLabel:@"▪︎ 最低折扣额度(%)" withHit:nil isrequest:YES delegate:self];
    [self.container addSubview:self.lsMaxDiscount];
    //允许单品折扣
    self.rdoSingleDiscount = [LSEditItemRadio editItemRadio];
    if ([[Platform Instance] lockAct:ACTION_PRODUCT_DISCOUNT]) {
        [self.rdoSingleDiscount initLabel:@"允许单品折扣" withHit:@"如需使用，请设置单品折扣权限"];
    }else{
        [self.rdoSingleDiscount initLabel:@"允许单品折扣" withHit:@"如需使用，请设置单品折扣权限" delegate:self];
    }
    [self.container addSubview:self.rdoSingleDiscount];
    
    // 最低折扣额度(%)
    self.lsSingleDis = [LSEditItemList editItemList];
    [self.lsSingleDis initLabel:@"▪︎ 最低折扣额度(%)" withHit:nil isrequest:YES delegate:self];
    [self.container addSubview:self.lsSingleDis];
    //交接时询问打印小票
    self.rdoPrintfSmallTicketCount = [LSEditItemRadio editItemRadio];
    [self.rdoPrintfSmallTicketCount initLabel:@"交接时询问打印小票" withHit:@"收银完成交接后，弹出询问打印小票份数窗口"];
    //默认关闭
    [self.rdoPrintfSmallTicketCount initData:@"0"];
    [self.container addSubview:self.rdoPrintfSmallTicketCount];
    
    
    //客单相同商品合并数量
    self.rdoGuestSameMergeGoods = [LSEditItemRadio editItemRadio];
    [self.rdoGuestSameMergeGoods initLabel:@"客单相同商品合并数量" withHit:nil];
    [self.rdoGuestSameMergeGoods initData:@"1"];
    [self.container addSubview:self.rdoGuestSameMergeGoods];
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 102) {//商超
        //启用条码秤
        self.rdoEnableBarCodeScale = [LSEditItemRadio editItemRadio];
        [self.rdoEnableBarCodeScale initLabel:@"启用条码秤" withHit:@"开启后，以条码标识开头的13或18位商品条码将被识别为条码秤打印的条形码" delegate:self];
        [self.rdoEnableBarCodeScale initData:@"1"];
        [self.container addSubview:self.rdoEnableBarCodeScale];
        //条码标识
        self.lstBarCodeIdentification = [LSEditItemList editItemList];
        [self.lstBarCodeIdentification initLabel:@"▪︎ 条码标识" withHit:nil delegate:self];
        self.lstBarCodeIdentification.lblDetail.textAlignment = NSTextAlignmentRight;
        self.lstBarCodeIdentification.imgMore.image = [UIImage imageNamed:@"ico_next"];
        [self.container addSubview:self.lstBarCodeIdentification];
        
    }
    [LSViewFactor addClearView:self.container y:0 h:20];
    //其它设置
    self.rdoTitle = [LSEditItemTitle editItemTitle];
    [self.rdoTitle configTitle:@"其它设置"];
    [self.container addSubview:self.rdoTitle];
    //启用装箱单
    self.rdoPickBox = [LSEditItemRadio editItemRadio];
    [self.rdoPickBox initLabel:@"启用装箱单" withHit:nil];
    [self.container addSubview:self.rdoPickBox];
    //允许查看同级店铺库存
    self.rdoIsPeer = [LSEditItemRadio editItemRadio];
    [self.rdoIsPeer initLabel:@"允许查看同级店铺库存" withHit:@"例如：同属于杭州分公司的自营店铺可以互相查看库存"];
    [self.container addSubview:self.rdoIsPeer];
//    //启用实体门店积分商品库存
//    self.rdoPointGoodsStock = [EditItemRadio itemRadio];
//    [self.rdoPointGoodsStock initLabel:@"启用实体门店积分商品库存" withHit:@"开启后只有积分商品库存数大于0的积分商品才能在实体门店进行兑换，请先在库存-积分商品库存中设置积分商品可兑换库存数"];
//    [self.container addSubview:self.rdoPointGoodsStock];
    //允许修改配送中的收货单
    self.rdoEdit = [LSEditItemRadio editItemRadio];
    [self.rdoEdit initLabel:@"允许修改配送中的收货单" withHit:nil];
    [self.container addSubview:self.rdoEdit];
    //允许拒绝配送中的收货单
    self.rdoRefuse = [LSEditItemRadio editItemRadio];
    [self.rdoRefuse initLabel:@"允许拒绝配送中的收货单 " withHit:nil];
    [self.container addSubview:self.rdoRefuse];
    //门店调拨单需要上级审核
    self.rdoNeedConfirm = [LSEditItemRadio editItemRadio];
    [self.rdoNeedConfirm initLabel:@"门店调拨单需要上级审核" withHit:nil delegate:self];
    [self.container addSubview:self.rdoNeedConfirm];
      
    self.lsZero.tag = ZERO;
    self.lsPartZero.tag = PART_ZERO;
    self.rdoWholeDiscount.tag = WHOLE_DIS;
    self.lsMaxDiscount.tag = MAX_DIS;
    self.rdoSingleDiscount.tag = SINGLE_DIS;
    self.lsSingleDis.tag = LS_SINGLE_DIS;
}

#pragma mark - 显示视图
- (void)showView
{
    short shopMode = [[Platform Instance] getShopMode];
    [self.rdoIsPeer visibal:shopMode!=1];
    [self.rdoRefuse visibal:shopMode!=1];
    [self.rdoEdit visibal:shopMode!=1];
    [self.rdoNeedConfirm visibal:shopMode!=1];
}

#pragma mark - UI变化通知
//注册
- (void)registerNotification
{
    [UIHelper initNotification:self.container event:Notification_UI_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_Change object:nil];
}

- (void)dataChange:(NSNotification*)notification
{
    [self editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];
}
//移除
- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 网络数据处理
- (void)selecrSysParam
{
    __strong typeof(self) strongSelf = self;
    NSString *url = @"config/detail";
    self.container.hidden = YES;
    [BaseService getRemoteLSDataWithUrl:url param:nil withMessage:nil show:YES CompletionHandler:^(id json) {
        strongSelf.container.hidden = NO;
        strongSelf.negativestoreStatus = [json objectForKey:@"negativestoreStatus"];
        strongSelf.remnantModelList = [ConfigItemOptionVo converToArr:[json objectForKey:@"remnantModelList"]];
        strongSelf.configItemVoList = [ConfigItemOptionVo converToArr:[json objectForKey:@"configItemVoList"]];
        strongSelf.salaryDateVoList = [SalaryDateVo converToArr:[json objectForKey:@"salaryDateVoList"]];
       
        //导购员必选
        NSString *flg = [ObjectUtil isNotNull:[json objectForKey:@"configShoppingGuideChoice"]]&&[[json objectForKey:@"configShoppingGuideChoice"] isEqualToString:@"1"]?@"1":@"0";
        [strongSelf.rdoGuider initData:flg];
        //零头处理
        NSString* remnantVal = [NSString stringWithFormat:@"%@",[json objectForKey:@"remnantModel"]];
        NSString* remnantName = [GlobalRender obtainItem:strongSelf.remnantModelList itemId:remnantVal];
        [strongSelf.lsZero initData:remnantName withVal:remnantVal];
        //每项金额零头处理
        remnantVal = [NSString stringWithFormat:@"%@",[json objectForKey:@"dealWithEachAmount"]];
        remnantName = [GlobalRender obtainItem:strongSelf.remnantModelList itemId:remnantVal];
        [strongSelf.lsPartZero initData:remnantName withVal:remnantVal];
        //整单折扣开关
        [strongSelf.rdoWholeDiscount initData:[json objectForKey:@"wholeDiscountconfigValFlg"]];
        [strongSelf.rdoWholeDiscount editable:![[Platform Instance] lockAct:ACTION_WHOLE_DISCOUNT]];
        //整单折扣
        [strongSelf.lsMaxDiscount visibal:[strongSelf.rdoWholeDiscount getVal]];
        [strongSelf.lsMaxDiscount initData:[json objectForKey:@"wholeDiscountconfigVal"] withVal:[json objectForKey:@"wholeDiscountconfigVal"]];
        //门店调拨单需要上级审核
        [strongSelf.rdoNeedConfirm initData:[json objectForKey:@"allocateNeedConfirm"]];
        //单品折扣开关
        [strongSelf.rdoSingleDiscount initData:[json objectForKey:@"singleDiscountConfigValFlg"]];
        [strongSelf.rdoSingleDiscount editable:![[Platform Instance] lockAct:ACTION_PRODUCT_DISCOUNT]];
        //单品折扣
        [strongSelf.lsSingleDis visibal:[strongSelf.rdoSingleDiscount getVal]];
        [strongSelf.lsSingleDis initData:[json objectForKey:@"singleDiscountConfigVal"] withVal:[json objectForKey:@"singleDiscountConfigVal"]];
        //查看同级店铺库存
        [strongSelf.rdoIsPeer visibal:!([[Platform Instance] getShopMode]==1)];
        flg = [ObjectUtil isNotNull:[json objectForKey:@"shopStoreCheckFlg"]]&&[[json objectForKey:@"shopStoreCheckFlg"] isEqualToString:@"1"]?@"1":@"0";
        [strongSelf.rdoIsPeer initData:flg];
        //装箱单
        [strongSelf.rdoPickBox visibal:([[Platform Instance] getShopMode]!=1&&[[[Platform Instance] getkey:SHOP_MODE] integerValue]==CLOTHESHOES_MODE)];
        flg = [ObjectUtil isNotNull:[json objectForKey:@"openPackageStatus"]]&&[[json objectForKey:@"openPackageStatus"] isEqualToString:@"1"]?@"1":@"0";
        [strongSelf.rdoPickBox initData:flg];
//        //积分商品库存
//        flg = [ObjectUtil isNotNull:[json objectForKey:@"pointsGoodsStockStatus"]]&&[[json objectForKey:@"pointsGoodsStockStatus"] isEqualToString:@"1"]?@"1":@"0";
//        [strongSelf.rdoPointGoodsStock initData:flg];
        
        //允许对配送中的收货单拒绝收货
        flg = [ObjectUtil isNotNull:[json objectForKey:@"configAllowSendingRefuse"]]&&[[json objectForKey:@"configAllowSendingRefuse"] isEqualToString:@"1"]?@"1":@"0";
        [strongSelf.rdoRefuse initData:flg];
        //允许对配送中的收货单进行修改
        flg = [ObjectUtil isNotNull:[json objectForKey:@"configAllowSendingUpdate"]]&&[[json objectForKey:@"configAllowSendingUpdate"] isEqualToString:@"1"]?@"1":@"0";
        [strongSelf.rdoEdit initData:flg];
        //客单相同商品合并数量
        if ([[json[@"sameGoodsMergeNum"] stringValue] isEqualToString:@"1"]) {
             [strongSelf.rdoGuestSameMergeGoods initData:@"1"];
        } else {
             [strongSelf.rdoGuestSameMergeGoods initData:@"0"];
        }
        //交接时询问打印小票 1打开  2关闭
        if ([json[@"configHandOverPrintCount"] intValue] == 1 ) {
            [strongSelf.rdoPrintfSmallTicketCount initData:@"1"];
        } else {
            [strongSelf.rdoPrintfSmallTicketCount initData:@"0"];
        }
        
        //是否显示交接时询问打印小票 1显示 2不显示
        if ([json[@"showHandOverPrintCount"] intValue] == 1 ) {
            [strongSelf.rdoPrintfSmallTicketCount visibal:YES];
        } else {
            [strongSelf.rdoPrintfSmallTicketCount visibal:NO];
        }

        
       
        
        //启用条码秤开关
        [strongSelf.rdoEnableBarCodeScale initData:[json[@"openScaleBarCode"] stringValue]];
        [strongSelf.lstBarCodeIdentification visibal:[strongSelf.rdoEnableBarCodeScale getVal]];
        strongSelf.barCodeMarkList = [LSBarCodeMark mj_objectArrayWithKeyValuesArray:json[@"barCodeMarkList"]];
        [strongSelf loadBarCodeIndentificationHit:NO];
        
        // 如果“其他设置”中无可设置项，隐藏“其他设置”一栏
        if (self.rdoIsPeer.hidden && self.rdoRefuse.hidden && self.rdoNeedConfirm.hidden && self.rdoEdit.hidden && self.rdoPickBox.hidden) {
            [self.rdoTitle visibal:NO];
        }

        [UIHelper refreshUI:strongSelf.container scrollview:strongSelf.scrollView];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}


/**
 刷新条码秤标志数据

 @param isChange 是初始化还是修改 第一次赋值的时候是初始化
 */
- (void)loadBarCodeIndentificationHit:(BOOL)isChange {
    __block NSString *hit = @"";
    __block int count = 0;
    [self.barCodeMarkList enumerateObjectsUsingBlock:^(LSBarCodeMark *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.flag == 1) {
            hit = [hit stringByAppendingString:[NSString stringWithFormat:@"、%d", obj.val]];
            count ++;
        }
    }];
    if ([hit hasPrefix:@"、"]) {
        hit = [hit substringFromIndex:1];
    }
    NSString *val = [NSString stringWithFormat:@"%d种", count];
    if (isChange) {
        [self.lstBarCodeIdentification changeData:val withVal:hit];
    } else {
        [self.lstBarCodeIdentification initData:val withVal:hit];
    }
    [self.lstBarCodeIdentification initHit:hit];
}

#pragma mark - IEditItemListEvent协议
- (void)onItemListClick:(LSEditItemList *)obj
{
    if (obj.tag==ZERO) {
        //总金额零头处理
        [OptionPickerBox initData:self.remnantModelList itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }else if (obj.tag==PART_ZERO) {
        //每项金额零头处理
        [OptionPickerBox initData:self.remnantModelList itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }else if (obj.tag==MAX_DIS) {
        //整单折扣
        [SymbolNumberInputBox initData:[obj getStrVal]];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:3 digitLimit:0];
    }else if (obj.tag==LS_SINGLE_DIS) {
        //单品折扣
        [SymbolNumberInputBox initData:[obj getStrVal]];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:NO isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:3 digitLimit:0];
    }else if (obj.tag==AC_PERIOD) {
        //会计期设置
        [OptionPickerBox initData:self.salaryDateVoList itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    } else if (obj == self.lstBarCodeIdentification) {//条码标识
        LSBarCodeIdentificationController *vc = [[LSBarCodeIdentificationController alloc] init];
        __weak typeof(self) wself = self;
        [vc loadBarCodeList:self.barCodeMarkList callBlock:^(NSArray<LSBarCodeMark *> *barCodeMarks) {
            //点击保存时调用
            wself.barCodeMarkList = barCodeMarks;
            [wself loadBarCodeIndentificationHit:YES];
            
        }];
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        
    }
}

#pragma mark - OptionPickerClient协议
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> vo = (id<INameItem>)selectObj;
    if (eventType==ZERO) {
        //零头处理
        [self.lsZero changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
    }else if (eventType==PART_ZERO) {
        //单项零头处理
        [self.lsPartZero changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
    }
    return YES;
}

#pragma mark - SymbolNumberInputClient协议
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    if ([NSString isNotBlank:val]) {
        val = [NSString stringWithFormat:@"%d",[val intValue]];
    }
    if (eventType==MAX_DIS) {
        
        if ([val integerValue]>100) {
            [AlertBox show:@"整单最低折扣额度(%)不能超过100%!"];
            return;
        }
        [self.lsMaxDiscount changeData:val withVal:val];
        
    }else if (eventType==LS_SINGLE_DIS) {
        
        if ([val integerValue]>100) {
            [AlertBox show:@"单品最低折扣额度(%)不能超过100%!"];
            return;
        }
        [self.lsSingleDis changeData:val withVal:val];
        
    }
    
}

#pragma mark - IEditItemRadioEvent协议
- (void)onItemRadioClick:(LSEditItemRadio *)obj
{
    if (obj.tag==WHOLE_DIS) {
        //整单折扣开关
        [self.lsMaxDiscount visibal:[obj getVal]];
    }else if (obj.tag==SINGLE_DIS) {
        //单品折扣开关
        [self.lsSingleDis visibal:[obj getVal]];
    } else if (obj == self.rdoEnableBarCodeScale) {
        [self.lstBarCodeIdentification visibal:[self.rdoEnableBarCodeScale getVal]];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma mark - 保存系统参数验证
- (BOOL)isValide
{
    if ([NSString isBlank:[self.lsMaxDiscount getStrVal]]) {
        [AlertBox show:@"整单最低折扣额度(%)不能为空，请输入!"];
        return NO;
    }
    if ([NSString isBlank:[self.lsSingleDis getStrVal]]) {
        [AlertBox show:@"单品最低折扣额度(%)不能为空，请输入!"];
        return NO;
    }
    return YES;
}

#pragma mark - 保存系统参数修改
- (void)save
{
    if (![self isValide]) {
        return;
    }
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param setValue:self.negativestoreStatus forKey:@"negativestoreStatus"];
    [param setValue:[self.lsZero getStrVal] forKey:@"remnantModel"];
    [param setValue:[self.lsPartZero getStrVal] forKey:@"dealWithEachAmount"];
    if ([self.rdoWholeDiscount getVal]) {
        [param setValue:[self.lsMaxDiscount getStrVal] forKey:@"wholeDiscountconfigVal"];
    }else{
        [param setValue:@"" forKey:@"wholeDiscountconfigVal"];
    }
    if ([self.rdoNeedConfirm getVal]) {
        [param setValue:@"1" forKey:@"allocateNeedConfirm"];
    }else{
        [param setValue:@"2" forKey:@"allocateNeedConfirm"];
    }
    if ([self.rdoSingleDiscount getVal]) {
        [param setValue:[self.lsSingleDis getStrVal] forKey:@"singleDiscountConfigVal"];
    }else{
        [param setValue:@"" forKey:@"singleDiscountConfigVal"];
    }
    NSString *flg = [self.rdoIsPeer getVal]?@"1":@"2";
    [param setValue:flg forKey:@"shopStockConfigVal"];
    flg = [self.rdoPickBox getVal]?@"1":@"2";

    [param setObject:flg forKey:@"openPackageStatus"];
    
    flg = [self.rdoPrintfSmallTicketCount getVal]?@"1":@"2";
    [param setValue:flg forKey:@"configHandOverPrintCount"];
//    flg = [self.rdoPointGoodsStock getVal]?@"1":@"2";
//    [param setValue:flg forKey:@"pointsGoodsStockStatus"];
    flg = [self.rdoGuider getVal]?@"1":@"2";
    [param setValue:flg forKey:@"configShoppingGuideChoice"];
    flg = [self.rdoRefuse getVal]?@"1":@"2";
    [param setValue:flg forKey:@"configAllowSendingRefuse"];
    flg = [self.rdoEdit getVal]?@"1":@"2";
    [param setValue:flg forKey:@"configAllowSendingUpdate"];
    //客单相同商品合并数量
    flg = [self.rdoGuestSameMergeGoods getVal]?@"1":@"2";
    [param setValue:flg forKey:@"sameGoodsMergeNum"];
    //启用条码秤开关
    flg = [self.rdoEnableBarCodeScale getVal]?@"1":@"2";
    [param setValue:flg forKey:@"openScaleBarCode"];
    //条码标识
    NSArray *list = [LSBarCodeMark mj_keyValuesArrayWithObjectArray:self.barCodeMarkList];
    [param setValue:list forKey:@"barCodeMarkList"];
    __strong typeof(self) strongSelf = self;
    NSString *url = @"config/setting";
    //更新系统参数
     [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        [strongSelf removeNotification];
        //保存装箱单开关值至本地|1 打开|0 关闭|
        [[Platform Instance] saveKeyWithVal:PACK_BOX_FLAG withVal:[strongSelf.rdoPickBox getStrVal]];
        //保存同级店铺库存开关值至本地|1 打开|0 关闭|
        [[Platform Instance] saveKeyWithVal:STORE_CHECK_FLAG withVal:[strongSelf.rdoIsPeer getStrVal]];
//        //保存积分商品库存开关值至本地|1 打开|0 关闭|
//        [[Platform Instance] saveKeyWithVal:POINT_STOCK withVal:[strongSelf.rdoPointGoodsStock getStrVal]];
        //拒绝配送中的收货单|1 打开|0 关闭|
        [[Platform Instance] saveKeyWithVal:DISTRIBUTION_REFUSE_FLAG withVal:[strongSelf.rdoRefuse getStrVal]];
        //修改配送中的收货单|1 打开|0 关闭|
        [[Platform Instance] saveKeyWithVal:DISTRIBUTION_EDIT_FLAG withVal:[strongSelf.rdoEdit getStrVal]];
        [XHAnimalUtil animal:strongSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [strongSelf.navigationController popViewControllerAnimated:NO];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
