//
//  LSSettingSystemParameterController.m
//  retailapp
//
//  Created by guozhi on 2017/2/23.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#define TAG_LST_TOTAL_AMOUNT_DEAL 1
#import "LSSettingSystemParameterController.h"
#import "SettingModuleEvent.h"
#import "EditItemList.h"
#import "EditItemRadio.h"
#import "SymbolNumberInputBox.h"
#import "OptionPickerBox.h"
#import "SetRender.h"
#import "GlobalRender.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "ConfigItemOptionVo.h"
#import "GlobalRender.h"
#import "SalaryDateVo.h"
#import "HomeViewController.h"
#import "LSAddShopInfoController.h"

@interface LSSettingSystemParameterController ()<IEditItemListEvent,IEditItemRadioEvent,OptionPickerClient,SymbolNumberInputClient>

@property (nonatomic,strong) UIScrollView *scrollView;
/**收银时导购员必选*/
@property (nonatomic,strong) EditItemRadio *rdoGuider;
/**总金额零头处理*/
@property (nonatomic,strong) EditItemList *lsZero;
/**每项金额零头处理*/
@property (nonatomic,strong) EditItemList *lsPartZero;
/**是否整单折扣*/
@property (nonatomic,strong) EditItemRadio *rdoWholeDiscount;
/**最大折扣*/
@property (nonatomic,strong) EditItemList *lsMaxDiscount;
/**是否单品折扣*/
@property (nonatomic,strong) EditItemRadio *rdoSingleDiscount;
/**单品折扣*/
@property (nonatomic,strong) EditItemList *lsSingleDis;
/**零头处理方式列表*/
@property (nonatomic,strong) NSMutableArray* remnantModelList;
@end

@implementation LSSettingSystemParameterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTitle:@"设置系统参数" leftPath:Head_ICON_BACK rightPath:nil];
    [self configViews];
    [self selecrSysParam];
    [UIHelper refreshUI:self.scrollView];
}

- (void)configViews {
    //设置背景透明度
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    //收银时导购员必选
    self.rdoGuider = [EditItemRadio itemRadio];
    [self.rdoGuider initLabel:@"收银时导购员必选" withHit:nil delegate:self];
    [self.scrollView addSubview:self.rdoGuider];
    //总金额零头处理
    self.lsZero = [EditItemList editItemList];
    [self.lsZero initLabel:@"总金额零头处理" withHit:nil delegate:self];
    [self.scrollView addSubview:self.lsZero];
    //每项金额零头处理
    self.lsPartZero = [EditItemList editItemList];
    [self.lsPartZero initLabel:@"每项金额零头处理" withHit:nil delegate:self];
    [self.scrollView addSubview:self.lsPartZero];
    //允许整单折扣
    self.rdoWholeDiscount = [EditItemRadio itemRadio];
    if ([[Platform Instance] lockAct:ACTION_WHOLE_DISCOUNT]) {
        [self.rdoWholeDiscount initLabel:@"允许整单打折" withHit:@"如需使用，请设置整单打折权限"];
    }else{
        [self.rdoWholeDiscount initLabel:@"允许整单打折" withHit:@"如需使用，请设置整单打折权限" delegate:self];
    }
    [self.scrollView addSubview:self.rdoWholeDiscount];
    //▪︎ 最低折扣额度(%)
    self.lsMaxDiscount = [EditItemList editItemList];
    [self.lsMaxDiscount initLabel:@"▪︎ 最低折扣额度(%)" withHit:@"最多给顾客优惠几折" isrequest:YES delegate:self];
    [self.scrollView addSubview:self.lsMaxDiscount];
    //允许单品折扣
    self.rdoSingleDiscount = [EditItemRadio itemRadio];
    if ([[Platform Instance] lockAct:ACTION_PRODUCT_DISCOUNT]) {
        [self.rdoSingleDiscount initLabel:@"允许单品打折" withHit:@"如需使用，请设置单品打折权限"];
    }else{
        [self.rdoSingleDiscount initLabel:@"允许单品打折" withHit:@"如需使用，请设置单品打折权限" delegate:self];
    }
    [self.scrollView addSubview:self.rdoSingleDiscount];
    // 最低折扣额度(%)
    self.lsSingleDis = [EditItemList editItemList];
    [self.lsSingleDis initLabel:@"▪︎ 最低折扣额度(%)" withHit:@"最多给顾客优惠几折" isrequest:YES delegate:self];
    [self.scrollView addSubview:self.lsSingleDis];
    
    UIButton *btn = [LSViewFactor addRedButton:self.scrollView title:@"开店完成" y:0];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.lsZero.tag = ZERO;
    self.lsPartZero.tag = PART_ZERO;
    self.rdoWholeDiscount.tag = WHOLE_DIS;
    self.lsMaxDiscount.tag = MAX_DIS;
    self.rdoSingleDiscount.tag = SINGLE_DIS;
    self.lsSingleDis.tag = LS_SINGLE_DIS;
   
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)direct {
    if (direct == LSNavigationBarButtonDirectLeft) {
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[LSAddShopInfoController class]]) {
                 // 此时点击返回进入到此页面需要请求新的数据 如果不请求版本号会不一致会报错 如若修改 请慎重
                [(LSAddShopInfoController *)obj loadData];
                *stop = YES;
            }
        }];
        [self popViewController];
    }
}

#pragma mark - 网络数据处理
- (void)selecrSysParam {
    __weak typeof(self) wself = self;
    NSString *url = @"config/detail";
    self.scrollView.hidden = YES;
    [BaseService getRemoteLSDataWithUrl:url param:nil withMessage:nil show:YES CompletionHandler:^(id json) {
        wself.scrollView.hidden = NO;
        wself.remnantModelList = [ConfigItemOptionVo converToArr:[json objectForKey:@"remnantModelList"]];
       //导购员必选
        NSString *flg = [ObjectUtil isNotNull:[json objectForKey:@"configShoppingGuideChoice"]]&&[[json objectForKey:@"configShoppingGuideChoice"] isEqualToString:@"1"]?@"1":@"0";
        [wself.rdoGuider initData:flg];
        //零头处理
        NSString* remnantVal = [NSString stringWithFormat:@"%@",[json objectForKey:@"remnantModel"]];
        NSString* remnantName = [GlobalRender obtainItem:wself.remnantModelList itemId:remnantVal];
        [wself.lsZero initData:remnantName withVal:remnantVal];
        //每项金额零头处理
        remnantVal = [NSString stringWithFormat:@"%@",[json objectForKey:@"dealWithEachAmount"]];
        remnantName = [GlobalRender obtainItem:wself.remnantModelList itemId:remnantVal];
        [wself.lsPartZero initData:remnantName withVal:remnantVal];
        //整单折扣开关
        [wself.rdoWholeDiscount initData:[json objectForKey:@"wholeDiscountconfigValFlg"]];
        [wself.rdoWholeDiscount isEditable:![[Platform Instance] lockAct:ACTION_WHOLE_DISCOUNT]];
        //整单折扣
        [wself.lsMaxDiscount visibal:[wself.rdoWholeDiscount getVal]];
        [wself.lsMaxDiscount initData:[json objectForKey:@"wholeDiscountconfigVal"] withVal:[json objectForKey:@"wholeDiscountconfigVal"]];
        //单品折扣开关
        [wself.rdoSingleDiscount initData:[json objectForKey:@"singleDiscountConfigValFlg"]];
        [wself.rdoSingleDiscount isEditable:![[Platform Instance] lockAct:ACTION_PRODUCT_DISCOUNT]];
        //单品折扣
        [wself.lsSingleDis visibal:[wself.rdoSingleDiscount getVal]];
        [wself.lsSingleDis initData:[json objectForKey:@"singleDiscountConfigVal"] withVal:[json objectForKey:@"singleDiscountConfigVal"]];
        [UIHelper refreshUI:wself.scrollView];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark - IEditItemListEvent协议
- (void)onItemListClick:(EditItemList *)obj
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
    }
}

#pragma mark - OptionPickerClient协议
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> vo = (id<INameItem>)selectObj;
    if (eventType==ZERO) {
        //零头处理
        [self.lsZero initData:[vo obtainItemName] withVal:[vo obtainItemId]];
    }else if (eventType==PART_ZERO) {
        //单项零头处理
        [self.lsPartZero initData:[vo obtainItemName] withVal:[vo obtainItemId]];
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
        [self.lsMaxDiscount initData:val withVal:val];
        
    }else if (eventType==LS_SINGLE_DIS) {
        
        if ([val integerValue]>100) {
            [AlertBox show:@"单品最低折扣额度(%)不能超过100%!"];
            return;
        }
        [self.lsSingleDis initData:val withVal:val];
        
    }
    
}

#pragma mark - IEditItemRadioEvent协议
- (void)onItemRadioClick:(EditItemRadio *)obj
{
    obj.lblTip.hidden = YES;
    if (obj.tag==WHOLE_DIS) {
        //整单折扣开关
        [self.lsMaxDiscount visibal:[obj getVal]];
    }else if (obj.tag==SINGLE_DIS) {
        //单品折扣开关
        [self.lsSingleDis visibal:[obj getVal]];
    }
    [UIHelper refreshUI:self.scrollView];
}

#pragma mark - 保存系统参数验证
- (BOOL)isValide
{
    if ([NSString isBlank:[self.lsMaxDiscount getStrVal]]) {
        [AlertBox show:@"整单最低折扣额度(%)不能为空，请重新输入!"];
        return NO;
    }
    if ([NSString isBlank:[self.lsSingleDis getStrVal]]) {
        [AlertBox show:@"单品最低折扣额度(%)不能为空，请重新输入!"];
        return NO;
    }
    return YES;
}



#pragma mark - 保存系统参数修改
- (void)btnClick:(UIButton *)btn
{
    if (![self isValide]) {
        return;
    }
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    [param setValue:[self.lsZero getStrVal] forKey:@"remnantModel"];
    [param setValue:[self.lsPartZero getStrVal] forKey:@"dealWithEachAmount"];
    if ([self.rdoWholeDiscount getVal]) {
        [param setValue:[self.lsMaxDiscount getStrVal] forKey:@"wholeDiscountconfigVal"];
    }else{
        [param setValue:@"" forKey:@"wholeDiscountconfigVal"];
    }
    if ([self.rdoSingleDiscount getVal]) {
        [param setValue:[self.lsSingleDis getStrVal] forKey:@"singleDiscountConfigVal"];
    }else{
        [param setValue:@"" forKey:@"singleDiscountConfigVal"];
    }
    NSString *flg = [self.rdoGuider getVal]?@"1":@"2";
    [param setValue:flg forKey:@"configShoppingGuideChoice"];
    __strong typeof(self) wself = self;
    NSString *url = @"config/setting";
    //更新系统参数
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        [wself.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[HomeViewController class]]) {
                [wself popToViewController:obj];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOpenShopSucessed object:nil];
                *stop = YES;
            }
        }];
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}


@end
