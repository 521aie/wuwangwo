//
//  LSCostGoodsEditViewController.m
//  retailapp
//
//  Created by guozhi on 17/4/10.
//  Copyright (c) 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define TAG_LST_COST_AFTER 1
#define TAG_LST_COST_DIFF 2
#define TAG_LST_REASON 3
#import "LSCostGoodsEditViewController.h"
#import "StockModuleEvent.h"
#import "ServiceFactory.h"
#import "LSEditItemList.h"
#import "LSEditItemText.h"
#import "UIHelper.h"
#import "ColorHelper.h"
#import "XHAnimalUtil.h"
#import "NumberUtil.h"
#import "OptionPickerBox.h"
#import "SymbolNumberInputBox.h"
#import "INameItem.h"
#import "AdjustReasonListView.h"
#import "AdjustReasonVo.h"
#import "LSGoodsInfoView.h"
#import "LSCostAdjustDetailVo.h"
#import "LSEditItemView.h"
#import "StockService.h"


@interface LSCostGoodsEditViewController ()<IEditItemListEvent,OptionPickerClient,SymbolNumberInputClient>


@property (nonatomic,strong) NSMutableArray* reasonList;

@property (nonatomic, copy) CostGoodsEditCallBlock adjustHandler;

@property (nonatomic,strong) LSCostAdjustDetailVo *detailVo;
/** <#注释#> */
@property (nonatomic, strong) StockService *stockService;

@property (nonatomic,assign) NSInteger action;

@property (nonatomic,assign) BOOL isEdit;
/** 商品信息 */
@property (nonatomic, strong) LSGoodsInfoView *vewGoods;

@property (nonatomic,strong) UIScrollView* scrollView;
@property (nonatomic,strong) UIView* container;
/** 库存数 */
@property (nonatomic, strong) LSEditItemView *vewNowStore;
/** 调整前成本价 */
@property (nonatomic, strong) LSEditItemView *vewCostBefore;
/** 调整后成本价 */
@property (nonatomic, strong) LSEditItemList *lstCostAfter;
/** 成本价差异 */
@property (nonatomic, strong) LSEditItemList *lstCostDiff;
/** 调整原因 */
@property (nonatomic, strong) LSEditItemList *lstReason;
@property (nonatomic,strong) UIView* delView;
@end

@implementation LSCostGoodsEditViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.stockService = [[StockService alloc] init];
    [self initNavigate];
    [self configViews];
    [self initMainView];
    [self getAdjustResons];
    [self registerNotification];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}
- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    
    self.vewGoods = [LSGoodsInfoView goodsInfoView];
    [self.container addSubview:self.vewGoods];
    
    self.vewNowStore = [LSEditItemView editItemView];
    [self.container addSubview:self.vewNowStore];
    
    self.vewCostBefore = [LSEditItemView editItemView];
    [self.container addSubview:self.vewCostBefore];
    
    self.lstCostAfter = [LSEditItemList editItemList];
    [self.container addSubview:self.lstCostAfter];
    
    self.lstCostDiff = [LSEditItemList editItemList];
    [self.container addSubview:self.lstCostDiff];
    
    self.lstReason = [LSEditItemList editItemList];
    [self.container addSubview:self.lstReason];
    UIButton *btn = [LSViewFactor addRedButton:self.container title:@"删除" y:0];
    self.delView = btn.superview;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.lstCostAfter.tag = TAG_LST_COST_AFTER;
    self.lstCostDiff.tag = TAG_LST_COST_DIFF;
    self.lstReason.tag = TAG_LST_REASON;
    
    
}
#pragma mark - 接收前一页面数据
- (void)loadDataWithVo:(LSCostAdjustDetailVo *)detailVo withEdit:(BOOL)isEdit callBack:(CostGoodsEditCallBlock)callBack
{
    self.detailVo = detailVo;
    self.adjustHandler = callBack;
    self.action = ACTION_CONSTANTS_EDIT;
    self.isEdit = isEdit;
}

#pragma mark - 初始化导航栏
- (void)initNavigate
{
    [self configTitle:@"成本价调整商品详情" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event == LSNavigationBarButtonDirectLeft) {
        [self popViewController];
    }else{
        [self save];
    }
}

#pragma mark - 初始化主视图
- (void)initMainView {
    
    [self.vewGoods setGoodsName:self.detailVo.goodsName barCode:self.detailVo.barCode retailPrice:self.detailVo.retailPrice filePath:self.detailVo.filePath goodsStatus:self.detailVo.goodsStatus type:self.detailVo.goodsType];
    [self.vewNowStore initLabel:@"库存数" withHit:nil];
    if (self.detailVo.goodsType == 4) {//拆分
        [self.vewNowStore initData:[NSString stringWithFormat:@"%.3f", self.detailVo.nowStore]];
    } else {
        [self.vewNowStore initData:[NSString stringWithFormat:@"%.f", self.detailVo.nowStore]];
    }
    [self.vewCostBefore initLabel:@"调整前成本价(元)" withHit:nil];
    [self.vewCostBefore initData:[NSString stringWithFormat:@"%.2f", self.detailVo.beforeCostPrice]];
    
    [self.lstCostAfter initLabel:@"调整后成本价(元)" withHit:nil delegate:self];
    [self.lstCostAfter initData:[NSString stringWithFormat:@"%.2f", self.detailVo.laterCostPrice] withVal:[NSString stringWithFormat:@"%.2f", self.detailVo.laterCostPrice]];
    
    [self.lstCostDiff initLabel:@"成本价差异（元）" withHit:nil delegate:self];
    [self.lstCostDiff initData:[NSString stringWithFormat:@"%.2f", self.detailVo.laterCostPrice - self.detailVo.beforeCostPrice] withVal:[NSString stringWithFormat:@"%.2f", self.detailVo.laterCostPrice - self.detailVo.beforeCostPrice]];
    
    [self.lstReason initLabel:@"调整原因" withHit:nil isrequest:NO delegate:self];
   [self.lstReason initData:self.detailVo.adjustReason withVal:self.detailVo.adjustReason];
    
    if (!self.isEdit) {
        self.lstReason.lblVal.placeholder = @"";
    }
    
    [self.lstCostAfter editEnable:self.isEdit];
    [self.lstCostDiff editEnable:self.isEdit];
    [self.lstReason editEnable:self.isEdit];
    
    self.delView.hidden = !self.isEdit;
    
    
    
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




#pragma mark - IEditItemListEvent协议
- (void)onItemListClick:(LSEditItemList *)obj
{
    if (obj == self.lstCostAfter || obj == self.lstCostDiff) {
        //调整数量
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
        [SymbolNumberInputBox initData:[obj getStrVal]];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
    } else if (obj == self.lstReason){
        //调整原因
        [OptionPickerBox initData:self.reasonList itemId:[ obj getStrVal]];
        [OptionPickerBox showManager:obj.lblName.text managerName:@"调整原因管理" client:self event:obj.tag];
    }

}

- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    if (eventType == TAG_LST_COST_AFTER) {//调整后成本价
        double costAfter = val.doubleValue;
        [self.lstCostAfter changeData:[NSString stringWithFormat:@"%.2f", costAfter] withVal:[NSString stringWithFormat:@"%.2f", costAfter]];
        
        double costDiff = costAfter - [[self.vewCostBefore getStrVal] doubleValue];
        
        [self.lstCostDiff changeData:[NSString stringWithFormat:@"%.2f", costDiff] withVal:[NSString stringWithFormat:@"%.2f", costDiff]];

        
    } else if (eventType == TAG_LST_COST_DIFF) {//成本价差异
        double costDiff = val.doubleValue;
        double costAfter = costDiff + [self.vewCostBefore getStrVal].doubleValue;
        if (costAfter > 999999.99) {
            [LSAlertHelper showAlert:@"调整后成本价不能超过999999.99，请重新输入!"];
            return;
        }
        [self.lstCostDiff changeData:[NSString stringWithFormat:@"%.2f", costDiff] withVal:[NSString stringWithFormat:@"%.2f", costDiff]];
        
        [self.lstCostAfter changeData:[NSString stringWithFormat:@"%.2f", costAfter] withVal:[NSString stringWithFormat:@"%.2f", costAfter]];
    }
}

//调整原因管理
- (void)managerOption:(NSInteger)eventType
{
    __strong typeof(self) strongSelf = self;
    AdjustReasonListView *vc = [[AdjustReasonListView alloc] initWithType:AdjustReasonListViewTypeCostAdjust];
    [vc loadData:^(NSMutableArray *reasonList) {
//        BOOL isDel = YES;
//        for (id<INameItem> vo in reasonList) {
//            if ([[strongSelf.lstReason getStrVal] isEqualToString:[vo obtainItemId]]) {
//                isDel = NO;
//                break;
//            }
//        }
//        if (isDel) {
//            [strongSelf.lstReason changeData:@"" withVal:nil];
//        }
        strongSelf.reasonList = reasonList;
        [strongSelf onItemListClick:self.lstReason];
    }];
    [self pushViewController:vc];
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> vo = (id<INameItem>)selectObj;
    [self.lstReason changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
    return YES;
}


#pragma mark - 删除调整商品
- (void)btnClick:(id)sender
{
    __weak typeof(self) wself = self;
    [LSAlertHelper showSheet:[NSString stringWithFormat:@"删除商品[%@]吗?",self.detailVo.goodsName] cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
        wself.adjustHandler(self.detailVo,ACTION_CONSTANTS_DEL);
        [wself popViewController];
    }];
   
}


#pragma mark - 编辑保存
- (void)save
{
    self.detailVo.laterCostPrice = [[self.lstCostAfter getDataLabel] doubleValue];
    self.detailVo.adjustReasonId = [self.lstReason getStrVal];
    self.detailVo.adjustReason = [self.lstReason getDataLabel];
    if (![self.detailVo.operateType isEqualToString:@"add"]) {
        //不是添加的商品更改操作状态
        self.detailVo.operateType = @"edit";
    }
    self.adjustHandler(self.detailVo,ACTION_CONSTANTS_EDIT);
    [self popViewController];
}


- (void)getAdjustResons {
    
    __strong typeof(self) strongSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:@"" forKey:@"adjustReason"];
    NSString *url = @"costPriceOpBills/costReasonList";
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        strongSelf.reasonList = [AdjustReasonVo converToArr:[json objectForKey:@"reasonList"]];
        
        if ([ObjectUtil isNotEmpty:strongSelf.reasonList]) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"typeName=='%@'" ,self.detailVo.adjustReason]];
            AdjustReasonVo *vo = [[strongSelf.reasonList filteredArrayUsingPredicate:predicate] firstObject];
            if (vo != nil) {
                [self.lstReason initData:vo.typeName withVal:vo.typeVal];
            }
        }

    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}
@end
