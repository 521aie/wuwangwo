//
//  AdjustGoodsEditView.m
//  retailapp
//
//  Created by hm on 15/9/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "AdjustGoodsEditView.h"
#import "StockModuleEvent.h"
#import "ServiceFactory.h"
#import "LSEditItemList.h"
#import "LSEditItemText.h"
#import "UIHelper.h"
#import "ColorHelper.h"
#import "AlertBox.h"
#import "XHAnimalUtil.h"
#import "NumberUtil.h"
#import "OptionPickerBox.h"
#import "SymbolNumberInputBox.h"
#import "INameItem.h"
#import "AdjustReasonListView.h"
#import "StockAdjustDetailVo.h"
#import "AdjustReasonVo.h"
#import "LSGoodsInfoView.h"

@interface AdjustGoodsEditView ()<IEditItemListEvent,OptionPickerClient,SymbolNumberInputClient>

@property (nonatomic, strong) StockService *stockService;

@property (nonatomic,strong) NSMutableArray* reasonList;

@property (nonatomic, copy) AdjustGoodsHandler adjustHandler;

@property (nonatomic,strong) StockAdjustDetailVo *detailVo;

@property (nonatomic,assign) NSInteger action;

@property (nonatomic,assign) short shopMode;

@property (nonatomic,assign) BOOL isCloShoes;
@property (nonatomic,assign) BOOL isEdit;
/** 是否显示成本价 */
@property (nonatomic, assign) BOOL isShowCostPrice;
/** 商品信息 */
@property (nonatomic, strong) LSGoodsInfoView *vewGoods;

@property (nonatomic,strong) UIScrollView* scrollView;
@property (nonatomic,strong) UIView* container;
@property (nonatomic,strong) LSEditItemText* txtPrice;
@property (nonatomic,strong) LSEditItemText* txtStoreCount;
@property (nonatomic,strong) LSEditItemList* lsActualCount;
@property (nonatomic,strong) LSEditItemList* lsAdjustCount;
@property (nonatomic,strong) LSEditItemText* txtAdjustAmount;
@property (nonatomic,strong) LSEditItemList* lsAdjustReason;
@property (nonatomic,strong) UIView* delView;
@end

@implementation AdjustGoodsEditView


- (void)viewDidLoad {
    [super viewDidLoad];
    self.stockService = [ServiceFactory shareInstance].stockService;
    [self initNavigate];
    [self configViews];
    //有权限显示成本价 没有权限 商超显示零售价 服鞋显示吊牌价
    self.isShowCostPrice = ![[Platform Instance] lockAct:ACTION_COST_PRICE_SEARCH];
    [self initMainView];
    [self getAdjustResons];
    [self fillMode];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}
- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    
    self.txtPrice = [LSEditItemText editItemText];
    [self.container addSubview:self.txtPrice];
    
    self.txtStoreCount = [LSEditItemText editItemText];
    [self.container addSubview:self.txtStoreCount];
    
    self.lsActualCount = [LSEditItemList editItemList];
    [self.container addSubview:self.lsActualCount];
    
    self.lsAdjustCount = [LSEditItemList editItemList];
    [self.container addSubview:self.lsAdjustCount];
    
    self.txtAdjustAmount = [LSEditItemText editItemText];
    [self.container addSubview:self.txtAdjustAmount];
    
    self.lsAdjustReason = [LSEditItemList editItemList];
    [self.container addSubview:self.lsAdjustReason];
    
    UIButton *btn = [LSViewFactor addRedButton:self.container title:@"删除" y:0];
    self.delView = btn.superview;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
#pragma mark - 接收前一页面数据
- (void)loadDataWithVo:(StockAdjustDetailVo *)detailVo withEdit:(BOOL)isEdit callBack:(AdjustGoodsHandler)callBack
{
    self.detailVo = detailVo;
    self.adjustHandler = callBack;
    self.action = ACTION_CONSTANTS_EDIT;
    self.isEdit = isEdit;
    self.isCloShoes = [[[Platform Instance] getkey:SHOP_MODE] integerValue]==CLOTHESHOES_MODE;
    self.shopMode = [[Platform Instance] getShopMode];
}

#pragma mark - 初始化导航栏
- (void)initNavigate
{
    [self configTitle:@"库存调整商品详情" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event == LSNavigationBarButtonDirectLeft) {
        [self removeNotification];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self save];
    }
}

#pragma mark - 初始化主视图
- (void)initMainView
{
    self.vewGoods = [LSGoodsInfoView goodsInfoView];
    [self.container insertSubview:self.vewGoods atIndex:0];
    
    [self.txtPrice initLabel:@"成本价(元)" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtPrice editEnabled:NO];
    if (!self.isShowCostPrice) {
        [self.txtPrice visibal:NO];
    }
    
    [self.txtStoreCount initLabel:@"调整前库存数" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtStoreCount editEnabled:NO];
    
    [self.lsActualCount initLabel:@"调整后库存数" withHit:nil delegate:self];
    
    [self.lsAdjustCount initLabel:@"调整数量" withHit:nil delegate:self];
    
    [self.txtAdjustAmount initLabel:@"调整金额(元)" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtAdjustAmount editEnabled:NO];
    
    [self.lsAdjustReason initLabel:@"调整原因" withHit:nil delegate:self];
    
    self.lsActualCount.tag = ACTUAL_COUNT;
    self.lsAdjustCount.tag = ADJUST_COUNT;
    self.lsAdjustReason.tag = ADJUST_REASON;
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

#pragma mark - 填充详情页面
- (void)fillMode
{
    [self.lsActualCount editEnable:self.isEdit];
    [self.lsAdjustCount editEnable:self.isEdit];
    BOOL flg = self.isEdit&&![[Platform Instance] lockAct:ACTION_STOCK_ADJUST_CHECK];
    self.delView.hidden = !flg;
    [self registerNotification];
    [self.vewGoods setGoodsName:self.detailVo.goodsName barCode:self.detailVo.barCode retailPrice:self.detailVo.retailPrice.doubleValue filePath:self.detailVo.filePath goodsStatus:self.detailVo.goodsStatus type:self.detailVo.goodsType];
    if (self.detailVo.goodsType == 4) {//散称
         [self.txtStoreCount initData:[NSString stringWithFormat:@"%.3f", [self.detailVo.nowStore doubleValue]]];
        [self.lsActualCount initData:[NSString stringWithFormat:@"%.3f", [self.detailVo.totalStore doubleValue]] withVal:[NSString stringWithFormat:@"%.3f", [self.detailVo.totalStore doubleValue]]];
        [self.lsAdjustCount initData:[NSString stringWithFormat:@"%.3f", [self.detailVo.adjustStore doubleValue]] withVal:[NSString stringWithFormat:@"%.3f", [self.detailVo.adjustStore doubleValue]]];
    } else {
        [self.txtStoreCount initData:[NSString stringWithFormat:@"%.f", [self.detailVo.nowStore doubleValue]]];
        [self.lsActualCount initData:[NSString stringWithFormat:@"%.f", [self.detailVo.totalStore doubleValue]] withVal:[NSString stringWithFormat:@"%.f", [self.detailVo.totalStore doubleValue]]];
        [self.lsAdjustCount initData:[NSString stringWithFormat:@"%.f", [self.detailVo.adjustStore doubleValue]] withVal:[NSString stringWithFormat:@"%.f", [self.detailVo.adjustStore doubleValue]]];
    }
    
    
    [self changeTotalMoney];
    [self.lsAdjustReason initData:self.detailVo.adjustReason withVal:self.detailVo.adjustReason];    [self.lsAdjustReason editEnable:self.isEdit];
    if (!self.isEdit) {
        self.lsAdjustReason.lblVal.placeholder = @"";
    }
}

#pragma mark - 联动更改总金额
- (void)changeTotalMoney
{
    double totalMoney = 0.00;
    if (self.isShowCostPrice) {
        [self.txtPrice initData:[NSString stringWithFormat:@"%.2f", self.detailVo.powerPrice.doubleValue]];
        totalMoney = [self.detailVo.powerPrice doubleValue]*[[self.lsAdjustCount getStrVal] doubleValue];
    }else{
        totalMoney = [self.detailVo.retailPrice doubleValue]*[[self.lsAdjustCount getStrVal] doubleValue];
    }
    [self.txtAdjustAmount initData:[NSString stringWithFormat:@"%.2f",totalMoney]];
}

#pragma mark - IEditItemListEvent协议
- (void)onItemListClick:(LSEditItemList *)obj
{
    if (obj.tag==ADJUST_COUNT) {
        //调整数量
        BOOL isFloat = self.detailVo.type==4;
        [SymbolNumberInputBox initData:[obj getStrVal]];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:isFloat isSymbol:YES event:obj.tag];
        if (self.detailVo.goodsType == 4) {//散称
            [SymbolNumberInputBox limitInputNumber:6 digitLimit:3];
        } else {
            [SymbolNumberInputBox limitInputNumber:6 digitLimit:0];
        }
        
    }else if (obj.tag==ADJUST_REASON){
       
        //调整原因
        [OptionPickerBox initData:self.reasonList itemId:[obj getStrVal]];
        [OptionPickerBox showManager:obj.lblName.text managerName:@"调整原因管理" client:self event:obj.tag];
    }else if (obj.tag==ACTUAL_COUNT) {
        BOOL isFloat = self.detailVo.type==4;
        [SymbolNumberInputBox initData:[obj getStrVal]];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:isFloat isSymbol:YES event:obj.tag];
        if (self.detailVo.goodsType == 4) {//散称
            [SymbolNumberInputBox limitInputNumber:6 digitLimit:3];
        } else {
            [SymbolNumberInputBox limitInputNumber:6 digitLimit:0];
        }
    }

}

- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    val = (self.detailVo.type==4)?[NSString stringWithFormat:@"%.3f",val.doubleValue]:[NSString stringWithFormat:@"%.0f",val.doubleValue];
    if (eventType==ADJUST_COUNT) {
        double maxCount = self.detailVo.type == 4 ? 999999.999 : 999999;
        double totalCount = [[self.txtStoreCount getStrVal] doubleValue] + [val doubleValue];
        if (totalCount > maxCount) {
            [LSAlertHelper showAlert:@"调整后库存数整数位不能超过6位、小数位不能超过3位，请重新输入!"];
            return;
        }
        [self.lsAdjustCount changeData:val withVal:val];
        double actualCount = [val doubleValue]+[[self.txtStoreCount getStrVal] doubleValue];
        val = (self.detailVo.type==4)?[NSString stringWithFormat:@"%.3f",actualCount]:[NSString stringWithFormat:@"%.0f",actualCount];
        [self.lsActualCount changeData:val withVal:val];
    }else if (eventType==ACTUAL_COUNT) {
        [self.lsActualCount changeData:val withVal:val];
        double adjustCount = [val doubleValue]-[[self.txtStoreCount getStrVal] doubleValue];
        val = (self.detailVo.type==4)?[NSString stringWithFormat:@"%.3f",adjustCount]:[NSString stringWithFormat:@"%.0f",adjustCount];
        [self.lsAdjustCount changeData:val withVal:val];
    }
    [self changeTotalMoney];
}

//调整原因管理
- (void)managerOption:(NSInteger)eventType
{
    __strong typeof(self) strongSelf = self;
    AdjustReasonListView *vc = [[AdjustReasonListView alloc] initWithType:AdjustReasonListViewTypeStockAdjust];
    [vc loadData:^(NSMutableArray *reasonList) {
//        BOOL isDel = YES;
//        for (id<INameItem> vo in reasonList) {
//            if ([[strongSelf.lsAdjustReason getStrVal] isEqualToString:[vo obtainItemId]]) {
//                isDel = NO;
//                break;
//            }
//        }
//        if (isDel) {
//            [strongSelf.lsAdjustReason changeData:@"" withVal:nil];
//        }
        strongSelf.reasonList = reasonList;
        [strongSelf onItemListClick:self.lsAdjustReason];
    }];
    [self pushViewController:vc];
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> vo = (id<INameItem>)selectObj;
    [self.lsAdjustReason changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
    return YES;
}


#pragma mark - 删除调整商品
- (void)btnClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"删除商品[%@]吗?",self.detailVo.goodsName]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        self.adjustHandler(self.detailVo,ACTION_CONSTANTS_DEL);
        [self removeNotification];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - 编辑保存
- (void)save
{
    self.detailVo.totalStore = [NSNumber numberWithDouble:[[self.lsActualCount getStrVal] doubleValue]];
    self.detailVo.adjustStore = [NSNumber numberWithDouble:[[self.lsAdjustCount getStrVal] doubleValue]];
    self.detailVo.adjustReasonId = [self.lsAdjustReason getStrVal];
    self.detailVo.adjustReason = self.lsAdjustReason.lblVal.text;
    self.detailVo.reasonFlag = ![self.detailVo.oldReasonId isEqualToString:self.detailVo.adjustReasonId];
    if (![self.detailVo.operateType isEqualToString:@"add"]) {
        //不是添加的商品更改操作状态
        self.detailVo.operateType = @"edit";
    }
    self.adjustHandler(self.detailVo,ACTION_CONSTANTS_EDIT);
    [self removeNotification];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)getAdjustResons {
    
    __strong typeof(self) strongSelf = self;
    [self.stockService selectAdjustReasonListWithCallBack:^(id json) {
        
        strongSelf.reasonList = [AdjustReasonVo converToArr:[json objectForKey:@"reasonList"]];
        
        if ([ObjectUtil isNotEmpty:strongSelf.reasonList]) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"typeName=='%@'" ,self.detailVo.adjustReason]];
            AdjustReasonVo *vo = [[strongSelf.reasonList filteredArrayUsingPredicate:predicate] firstObject];
            if (vo != nil) {
                [self.lsAdjustReason initData:vo.typeName withVal:vo.typeVal];
            }
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}
@end
