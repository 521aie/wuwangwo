//
//  GoodsDetailEditView.m
//  retailapp
//
//  Created by hm on 15/7/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GoodsDetailEditView.h"
#import "ServiceFactory.h"
#import "UIHelper.h"
#import "LSEditItemList.h"
#import "LSEditItemText.h"
#import "SymbolNumberInputBox.h"
#import "XHAnimalUtil.h"
#import "OptionPickerBox.h"
#import "DatePickerBox.h"
#import "INameItem.h"
#import "PaperDetailVo.h"
#import "DateUtils.h"
#import "DicItemConstants.h"
#import "ReasonVo.h"
#import "AlertBox.h"
#import "ReasonListView.h"
#import "NumberUtil.h"
#import "ColorHelper.h"
#import "LSGoodsInfoView.h"

@interface GoodsDetailEditView ()<IEditItemListEvent,SymbolNumberInputClient,OptionPickerClient,DatePickerClient>

@property (nonatomic,strong) CommonService *commonService;
/**页面回调block*/
@property (nonatomic,copy) ChangeGoodsDetailHandler changeHandler;
/**退货原因列表*/
@property (nonatomic,strong) NSMutableArray *returnReasonList;
/**商品详情vo*/
@property (nonatomic,strong) PaperDetailVo* paperDetailVo;
/**单据类型*/
@property (nonatomic) NSInteger paperType;
/**是否可编辑*/
@property (nonatomic) BOOL isEdit;
/**原因diccode*/
@property (nonatomic,copy) NSString *dicCode;
//是否可以编辑价格
@property (nonatomic, assign) BOOL isEditPrice;
//是否可以查看价格
@property (nonatomic, assign) BOOL isSearchPrice;

/** <#注释#> */
@property (nonatomic, strong) LSGoodsInfoView *viewGoods;

@end

@implementation GoodsDetailEditView


- (void)viewDidLoad {
    [super viewDidLoad];
    self.commonService = [ServiceFactory shareInstance].commonService;
    [self initNavigate];
    [self configViews];
    self.viewGoods = [LSGoodsInfoView goodsInfoView];
    [self.container insertSubview:self.viewGoods atIndex:0];
    //进货价/退货价查看编辑 修改权限控制
    //1 进货价/退货价查看权限打开 进货价/退货价编辑权限打开时 显示的是采购价 可以编辑
    //2 进货价/退货价查看权限打开 进货价/退货价编辑权限关闭时 显示的是采购价 不可以编辑
    //3 进货价/退货价查看权限关闭 进货价/退货价编辑权限关闭/打开时 商超显示的是零售价 服鞋显示的是吊牌价 不可以编辑
    //编辑
    
    //查看
    self.isEditPrice = ![[Platform Instance] lockAct:ACTION_PURCHASE_RETURN_PRICE_EDIT] && ![[Platform Instance] lockAct:ACTION_PURCHASE_RETURN_PRICE_SEARCH];
    //查看
    self.isSearchPrice = ![[Platform Instance] lockAct:ACTION_PURCHASE_RETURN_PRICE_SEARCH];
    [self initMainView];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [self showView:self.paperType];
}
- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    
    self.lsPrice = [LSEditItemList editItemList];
    [self.container addSubview:self.lsPrice];
    
    self.txtStoreCount = [LSEditItemText editItemText];
    [self.container addSubview:self.txtStoreCount];
    
    self.lsCount = [LSEditItemList editItemList];
    [self.container addSubview:self.lsCount];
    
    self.lstAmount = [LSEditItemList editItemList];
    [self.container addSubview:self.lstAmount];
    
    self.lsProductionDate = [LSEditItemList editItemList];
    [self.container addSubview:self.lsProductionDate];
    
    self.lsReason = [LSEditItemList editItemList];
    [self.container addSubview:self.lsReason];
    
    UIButton *btn = [LSViewFactor addRedButton:self.container title:@"删除" y:0];
    [btn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.delBtn = btn.superview;
    
    
}
- (void)showGoodsDetail:(PaperDetailVo*)paperDetailVo paperType:(NSInteger)type isEdit:(BOOL)isEdit callBack:(ChangeGoodsDetailHandler)handler
{
    self.paperDetailVo = paperDetailVo;
    self.paperType = type;
    self.isEdit = isEdit;
    if (type==RETURN_PAPER_TYPE||type==CLIENT_RETURN_PAPER_TYPE) {
        self.dicCode = DIC_RETURN_RESON;
    }
    self.changeHandler = handler;
}

#pragma mark - 初始化导航
- (void)initNavigate
{
    NSString *title = nil;
    if (self.paperType == ORDER_PAPER_TYPE || self.paperType == CLIENT_ORDER_PAPER_TYPE) {
        title = @"采购商品详情";
    } else if (self.paperType == PURCHASE_PAPER_TYPE) {
        title = @"入库商品详情";
    } else if (self.paperType == RETURN_PAPER_TYPE) {
        title = @"退货商品详情";
    } else if (self.paperType == ALLOCATE_PAPER_TYPE) {
        title = @"调拨商品详情";
    } else if (self.paperType == CLIENT_RETURN_PAPER_TYPE) {
        title = @"退货商品详情";
    }
    [self configTitle:title leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    [self removeNotification];
    if (event==LSNavigationBarButtonDirectLeft) {
        self.changeHandler(ACTION_CONSTANTS_EDIT);
    }else{
        [self save];
    }
}
#pragma mark - 初始化主视图
- (void)initMainView
{
    [self.txtInnerCode initLabel:@"条形码" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtInnerCode editEnabled:NO];
    [self.lsPrice initLabel:@"采购单价(元)" withHit:nil delegate:self];
    [self.txtStoreCount initLabel:@"实库存数" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtStoreCount editEnabled:NO];
    [self.lsCount initLabel:@"采购数量" withHit:nil delegate:self];
    [self.lsProductionDate initLabel:@"生产日期" withHit:nil delegate:self];
    [self.lstAmount initLabel:@"金额(元)" withHit:nil delegate:self];
    [self.lstAmount editEnable:NO];
    [self.lsReason initLabel:@"退货原因" withHit:nil isrequest:NO delegate:self];
    self.lsPrice.tag = 100;
    self.lsCount.tag = 101;
    self.lsReason.tag = 102;
    self.lsProductionDate.tag = 103;
    self.lstAmount.tag = 104;
}

#pragma mark - UI变化通知
- (void)initNotification
{
    [UIHelper initNotification:self.container event:Notification_UI_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_Change object:nil];
}

- (void)dataChange:(NSNotification*)notification
{
    [self editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_EDIT];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 显示页面内容
- (void)showView:(NSInteger)type
{
    [self initNotification];
    [self.txtStoreCount visibal:(type==ORDER_PAPER_TYPE || type == CLIENT_ORDER_PAPER_TYPE)];
    [self.lsReason visibal:(type==RETURN_PAPER_TYPE||type==CLIENT_RETURN_PAPER_TYPE)];
    [self.lsProductionDate visibal:(type==PURCHASE_PAPER_TYPE)];
    [self.lsCount editEnable:self.isEdit];
   
    self.delBtn.hidden = !self.isEdit;
    [self.viewGoods setGoodsName:self.paperDetailVo.goodsName barCode:self.paperDetailVo.goodsBarcode retailPrice:self.paperDetailVo.retailPrice filePath:self.paperDetailVo.filePath goodsStatus:self.paperDetailVo.goodsStatus type:self.paperDetailVo.type];
    if (type == ORDER_PAPER_TYPE||type==CLIENT_ORDER_PAPER_TYPE) {
        //采购单 客户采购单
        NSString *price = nil;
//        NSString* totalPrice = nil;
        NSString *text = nil;
        if (self.isSearchPrice) {
            text = @"采购价(元)";
            price = [NSString stringWithFormat:@"%.2f",self.paperDetailVo.goodsPrice];
//            totalPrice = [NSString stringWithFormat:@"%.2f",self.paperDetailVo.goodsPurchaseTotalPrice];
        } else {
            text = @"零售价(元)";
            price = [NSString stringWithFormat:@"%.2f",self.paperDetailVo.retailPrice];
//            totalPrice = [NSString stringWithFormat:@"%.2f",self.paperDetailVo.goodsRetailTotalPrice];
        }
        [self.lsPrice editEnable:(self.isEditPrice &&self.isEdit)];
        [self.lstAmount editEnable:(self.isEditPrice &&self.isEdit)];
        
        self.lsPrice.lblName.text = text;
//        [self.txtMoney initData:totalPrice];
        
        [self.lsPrice initData:price withVal:price];
        
        NSString *totalAmount = self.isSearchPrice?[NSString stringWithFormat:@"%.2f",self.paperDetailVo.goodsTotalPrice]:[NSString stringWithFormat:@"%.2f",self.paperDetailVo.retailPrice * self.paperDetailVo.goodsSum];
        [self.lstAmount initData:totalAmount withVal:totalAmount];
        
        [self.txtStoreCount initData:[self.paperDetailVo.nowStore stringValue]];
        self.lsCount.lblName.text = @"采购数量";
        self.lblName.text = self.paperDetailVo.goodsName;
        [self.txtInnerCode initData:self.paperDetailVo.goodsBarcode];
        NSString* count = (self.paperDetailVo.type==4)?[NSString stringWithFormat:@"%.3f",self.paperDetailVo.goodsSum]:[NSString stringWithFormat:@"%.0f",self.paperDetailVo.goodsSum];
        [self.lsCount initData:count withVal:count];
        NSString* prodictionDate = [DateUtils formateTime2:self.paperDetailVo.productionDate];
        [self.lsProductionDate initData:prodictionDate withVal:prodictionDate];
        
    }else if (type==PURCHASE_PAPER_TYPE) {
        //收货入库单
        [self.lsPrice editEnable:(self.isEditPrice &&self.isEdit)];
         [self.lstAmount editEnable:(self.isEditPrice &&self.isEdit)];
        self.lsPrice.lblName.text = (self.isSearchPrice)?@"进货价(元)":@"零售价(元)";
        self.lsCount.lblName.text = @"入库数量";
        self.lblName.text = self.paperDetailVo.goodsName;
        [self.txtInnerCode initData:self.paperDetailVo.goodsBarcode];
        NSString* price = (self.isSearchPrice)?[NSString stringWithFormat:@"%.2f",self.paperDetailVo.goodsPrice]:[NSString stringWithFormat:@"%.2f",self.paperDetailVo.retailPrice];
        [self.lsPrice initData:price withVal:price];
        
        NSString *totalAmount = self.isSearchPrice?[NSString stringWithFormat:@"%.2f",self.paperDetailVo.goodsTotalPrice]:[NSString stringWithFormat:@"%.2f",self.paperDetailVo.retailPrice * self.paperDetailVo.goodsSum];
        [self.lstAmount initData:totalAmount withVal:totalAmount];
        NSString* count = (self.paperDetailVo.type==4)?[NSString stringWithFormat:@"%.3f",self.paperDetailVo.goodsSum]:[NSString stringWithFormat:@"%.0f",self.paperDetailVo.goodsSum];
        [self.lsCount initData:count withVal:count];
//        NSString* totalPrice = nil;
//        if (self.isSearchPrice) {
//            totalPrice = [NSString stringWithFormat:@"%.2f",self.paperDetailVo.goodsPurchaseTotalPrice];
//        } else {
//            totalPrice = [NSString stringWithFormat:@"%.2f",self.paperDetailVo.goodsRetailTotalPrice];
//        }
//        [self.txtMoney initData:totalPrice];
        if (self.paperDetailVo.productionDate>0) {
            NSString* prodictionDate = [DateUtils formateTime2:self.paperDetailVo.productionDate];
            [self.lsProductionDate initData:prodictionDate withVal:prodictionDate];
        }else{
            [self.lsProductionDate initData:@"请选择" withVal:nil];
        }
        
    }else if (type==RETURN_PAPER_TYPE || type==CLIENT_RETURN_PAPER_TYPE) {
        //退货出库单 客户退货单
        [self.lsPrice editEnable:(self.isEditPrice &&self.isEdit)];
         [self.lstAmount editEnable:(self.isEditPrice &&self.isEdit)];
        self.lsPrice.lblName.text = self.isSearchPrice?@"退货价(元)":@"零售价(元)";
        self.lsCount.lblName.text = @"退货数量";
        self.lblName.text = self.paperDetailVo.goodsName;
        [self.txtInnerCode initData:self.paperDetailVo.goodsBarcode];
        NSString* price = self.isSearchPrice?[NSString stringWithFormat:@"%.2f",self.paperDetailVo.goodsPrice]:[NSString stringWithFormat:@"%.2f",self.paperDetailVo.retailPrice];
        [self.lsPrice initData:price withVal:price];
        
        NSString *totalAmount = self.isSearchPrice?[NSString stringWithFormat:@"%.2f",self.paperDetailVo.goodsTotalPrice]:[NSString stringWithFormat:@"%.2f",self.paperDetailVo.retailPrice * self.paperDetailVo.goodsSum];
        [self.lstAmount initData:totalAmount withVal:totalAmount];
        
        
        NSString* count = (self.paperDetailVo.type==4)?[NSString stringWithFormat:@"%.3f",self.paperDetailVo.goodsSum]:[NSString stringWithFormat:@"%.0f",self.paperDetailVo.goodsSum];
        [self.lsCount initData:count withVal:count];
//        NSString* totalPrice = nil;
//        if (self.isSearchPrice) {
//            totalPrice = [NSString stringWithFormat:@"%.2f",self.paperDetailVo.goodsPurchaseTotalPrice];
//        } else {
//            totalPrice = [NSString stringWithFormat:@"%.2f",self.paperDetailVo.goodsRetailTotalPrice];
//        }
//        [self.txtMoney initData:totalPrice];
        [self.lsReason initData:self.paperDetailVo.resonName withVal:[NSString stringWithFormat:@"%tu",self.paperDetailVo.resonVal]];
//        if ([NSString isBlank:self.paperDetailVo.resonName]) {
//            [self.lsReason initData:@"请选择" withVal:nil];
//        }else{
//            [self.lsReason initData:self.paperDetailVo.resonName withVal:[NSString stringWithFormat:@"%tu",self.paperDetailVo.resonVal]];
//        }
        
    }else if (type==ALLOCATE_PAPER_TYPE){
        //调拨
        [self.lsPrice editEnable:NO];
         [self.lstAmount editEnable:NO];
        [self.lsPrice visibal:NO];
        self.lsPrice.lblName.text = @"零售价(元)";
        self.lsCount.lblName.text = @"调拨数量";
        self.lblName.text = self.paperDetailVo.goodsName;
        [self.txtInnerCode initData:self.paperDetailVo.goodsBarcode];
        NSString* price = [NSString stringWithFormat:@"%.2f",self.paperDetailVo.goodsPrice];
        [self.lsPrice initData:price withVal:price];
        NSString* count = (self.paperDetailVo.type==4)?[NSString stringWithFormat:@"%.3f",self.paperDetailVo.goodsSum]:[NSString stringWithFormat:@"%.0f",self.paperDetailVo.goodsSum];
        [self.lsCount initData:count withVal:count];
//        NSString* totalPrice = [NSString stringWithFormat:@"%.2f",self.paperDetailVo.goodsTotalPrice];
//        [self.txtMoney initData:totalPrice];
         [self.lstAmount initData:[NSString stringWithFormat:@"%6.2f",[[self.lsCount getStrVal] doubleValue]*[[self.lsPrice getStrVal] doubleValue]] withVal:[NSString stringWithFormat:@"%6.2f",[[self.lsCount getStrVal] doubleValue]*[[self.lsPrice getStrVal] doubleValue]]];
    }
    if (type == ALLOCATE_PAPER_TYPE) {//调拨单
        [self.lsPrice visibal:NO];
    } else {
        [self.lsPrice visibal:self.isSearchPrice];
    }
    
    [self.lsReason editEnable:self.isEdit];
    [self.lsProductionDate editEnable:self.isEdit];
    if ([NSString isBlank:[self.lsProductionDate getStrVal]]) {
        self.lsProductionDate.lblVal.hidden = !self.isEdit;
    } else {
        self.lsProductionDate.lblVal.hidden = NO;
    }
    if ([NSString isBlank:[self.lsReason getDataLabel]]) {
        self.lsReason.lblVal.hidden = !self.isEdit;
    } else {
        self.lsReason.lblVal.hidden = NO;
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}


#pragma mark - IEditItemListEvent协议
- (void)onItemListClick:(LSEditItemList *)obj
{
    if (obj.tag==100) {
         //价格
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
        
    }else if (obj.tag==101) {
        //数量
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:(self.paperDetailVo.type==4) isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:4 digitLimit:3];
    }else if (obj.tag==102) {
        //选择原因
        if (self.returnReasonList==nil||self.returnReasonList.count==0) {
            __weak typeof(self) weakSelf = self;
            [self.commonService selectReasonListByCode:self.dicCode completionHandler:^(id json) {
                weakSelf.returnReasonList = [ReasonVo converToArr:[json objectForKey:@"returnResonList"]];
                [OptionPickerBox initData:weakSelf.returnReasonList itemId:[obj getStrVal]];
                [OptionPickerBox showManager:obj.lblName.text managerName:@"退货原因管理" client:self event:obj.tag];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }else{
            [OptionPickerBox initData:self.returnReasonList itemId:[obj getStrVal]];
            [OptionPickerBox showManager:obj.lblName.text managerName:@"退货原因管理" client:self event:obj.tag];
        }

    }else if (obj.tag==103) {
        [DatePickerBox showClear:obj.lblName.text clearName:@"清空日期" date:[DateUtils parseDateTime4:obj.lblVal.text] client:self event:obj.tag];
    } else if (obj == self.lstAmount) {//金额
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:NO event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
    }
}
#pragma mark - SymbolNumberInputClient协议
- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType
{
    if (eventType==100) {
        //价格
        val = [NSString stringWithFormat:@"%6.2f",val.doubleValue];
        [self.lsPrice changeData:val withVal:val];
        
        //输入价格金额改变
        double amount = val.doubleValue * [self.lsCount getDataLabel].doubleValue;
        val = [NSString stringWithFormat:@"%.2f",amount];
        [self.lstAmount changeData:val withVal:val];
    }else if (eventType==101) {
        //数量
        if (self.paperDetailVo.type==4) {
            val = [NSString stringWithFormat:@"%.3f",val.doubleValue];
        }else{
            val = [NSString stringWithFormat:@"%.0f",val.doubleValue];
        }
        [self.lsCount changeData:val withVal:val];
        
        //输入数量金额改变
        double amount = val.doubleValue * [self.lsPrice getDataLabel].doubleValue;
        val = [NSString stringWithFormat:@"%.2f",amount];
        [self.lstAmount changeData:val withVal:val];
    } else if (eventType==104) {//金额
            //价格
            val = [NSString stringWithFormat:@"%.2f",val.doubleValue];
            [self.lstAmount changeData:val withVal:val];
        
        //输入金额单价改变
        //输入金额单价改变改变 不进行四舍五入
        double price = (int)((val.doubleValue  / [self.lsCount getDataLabel].doubleValue)*100)/100.0;
        val = [NSString stringWithFormat:@"%.2f",price];
        [self.lsPrice changeData:val withVal:val];

        }
}


- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameValue> item = (id<INameValue>)selectObj;
    [self.lsReason changeData:[item obtainItemName] withVal:[item obtainItemValue]];
    return YES;
}

- (void)managerOption:(NSInteger)eventType
{
    //退货原因管理
    ReasonListView *reasonListView = [[ReasonListView alloc] init];
    __weak typeof(self) weakSelf = self;
    [reasonListView loadDataWithCode:self.dicCode titleName:@"退货原因" CallBack:^(NSMutableArray *reasonList) {
        BOOL isDel = YES;
        for (id<INameValue> item in reasonList) {
            if ([[weakSelf.lsReason getStrVal] isEqualToString:[item obtainItemValue]]) {
                isDel = NO;
            }
        }
        if (isDel) {
            [weakSelf.lsReason changeData:nil withVal:nil];
        }
        weakSelf.returnReasonList = reasonList;
    }];
    [self.navigationController pushViewController:reasonListView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    reasonListView = nil;
}

- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event
{
    if ([date timeIntervalSince1970] > [[NSDate date] timeIntervalSince1970]) {
        [AlertBox show:@"生产日期不能大于今日，请重新选择!"];
        return NO;
    }
    NSString* dateStr=[DateUtils formateDate2:date];
    
    [self.lsProductionDate changeData:dateStr withVal:dateStr];
    
    return YES;

}

- (void)clearDate:(NSInteger)eventType
{
    [self.lsProductionDate changeData:@"请选择" withVal:nil];
}

#pragma mark - 删除商品
- (void)delBtnClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:@"删除商品[%@]吗?",self.paperDetailVo.goodsName]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        if (self.changeHandler) {
            [self removeNotification];
            self.changeHandler(ACTION_CONSTANTS_DEL);
        }
    }
}

#pragma mark - 保存商品数据
- (void)save
{
    if (self.isSearchPrice) {
        self.paperDetailVo.goodsPrice = [[self.lsPrice getStrVal] doubleValue];
        self.paperDetailVo.goodsTotalPrice = [[self.lstAmount getStrVal] doubleValue];
    } else {
        self.paperDetailVo.retailPrice = [[self.lsPrice getStrVal] doubleValue];
        self.paperDetailVo.goodsRetailTotalPrice = [self.lstAmount getStrVal].doubleValue;
    }
//    if (self.isThirdSupplier||self.paperType==CLIENT_ORDER_PAPER_TYPE||self.paperType==CLIENT_RETURN_PAPER_TYPE || self.paperType == ORDER_PAPER_TYPE) {
//        if (self.paperType == ORDER_PAPER_TYPE) {//采购单
//            if (self.isSearchPrice) {
//                 self.paperDetailVo.goodsPrice = [[self.lsPrice getStrVal] doubleValue];
//            }
//        } else {
//             self.paperDetailVo.goodsPrice = [[self.lsPrice getStrVal] doubleValue];
//        }
//    }
    self.paperDetailVo.goodsSum = [[self.lsCount getStrVal] doubleValue];
    self.paperDetailVo.resonVal = [[self.lsReason getStrVal] integerValue];
    self.paperDetailVo.resonName = self.lsReason.lblVal.text;
    self.paperDetailVo.productionDate = [DateUtils formateDateTime3:[self.lsProductionDate getStrVal]];
//    self.paperDetailVo.changeFlag = [NumberUtil isNotEqualNum:self.paperDetailVo.oldGoodsPrice num2:self.paperDetailVo.goodsPrice]||[NumberUtil isNotEqualNum:self.paperDetailVo.oldGoodsSum num2:self.paperDetailVo.goodsSum];
    self.paperDetailVo.changeFlag = [UIHelper currChange:self.container];
    if (![self.paperDetailVo.operateType isEqualToString:@"add"]) {
        self.paperDetailVo.operateType = ((self.paperDetailVo.changeFlag==1)||(self.paperDetailVo.oldResonVal!=self.paperDetailVo.resonVal))?@"edit":@"";
    }
    if (self.changeHandler) {
        [self removeNotification];
        self.changeHandler(ACTION_CONSTANTS_EDIT);
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
