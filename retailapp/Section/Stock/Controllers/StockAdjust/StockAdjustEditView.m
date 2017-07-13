//
//  StockAdjustEditView.m
//  retailapp
//
//  Created by hm on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//
#define kAdjustCountName @"调整数量"
#define kAdjustCountVal @"0"
#define kAdjustAfterCountName @"调整后库存数"
#define kAdjustAfterCountVal @"1"
#import "StockAdjustEditView.h"
#import "StockModuleEvent.h"
#import "ServiceFactory.h"
#import "LSEditItemTitle.h"
#import "LSEditItemList.h"
#import "LSEditItemText.h"
#import "UIHelper.h"
#import "ColorHelper.h"
#import "XHAnimalUtil.h"
#import "TimePickerBox.h"
#import "LSEditItemView.h"
#import "DatePickerBox.h"
#import "DateUtils.h"
#import "OptionPickerBox.h"
#import "INameItem.h"
#import "NameItemVO.h"
#import "PaperGoodsCell.h"
#import "AdjustStyleCell.h"
#import "StockAdjustVo.h"
#import "StockAdjustDetailVo.h"
#import "AdjustGoodsEditView.h"
#import "PaperGoodsVo.h"
#import "GoodsBatchChoiceView1.h"
#import "GoodsVo.h"
#import "AdjustStyleEditView.h"
#import "SelectStoreListView.h"
#import "LSDealRecordController.h"
#import "LSDealRecordVo.h"
#import "PaperGooodsCellEnum.h"
#define Notification_UI_Change_STOCK_ADJUST @"Notification_UI_Change_STOCK_ADJUST"
@interface StockAdjustEditView ()<IEditItemListEvent,TimePickerClient,DatePickerClient,OptionPickerClient,PaperCellGoodsDelagate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) LSEditItemTitle *baseTitle;
@property (nonatomic, strong) LSEditItemText *txtNo;
/** 调整单状态 */
@property (nonatomic, strong) LSEditItemView *vewStatus;
@property (nonatomic, strong) LSEditItemList *lsShop;
@property (nonatomic, strong) LSEditItemList *lsDate;
@property (nonatomic, strong) LSEditItemList *lsTime;
@property (nonatomic, strong) LSEditItemText *txtMemo;
@property (nonatomic, strong) LSEditItemTitle *goodsTitle;
@property (nonatomic, strong) LSEditItemList *lsCondition;
/** 处理记录 */
@property (nonatomic, strong) LSEditItemList *lstDealRecord;

@property (nonatomic,weak) IBOutlet UITableView* mainGrid;

@property (nonatomic,weak) IBOutlet UIView* sumView;
@property (nonatomic,weak) IBOutlet UILabel* lblTotal;

@property (nonatomic,weak) IBOutlet UIView* footerView;
@property (nonatomic,weak) IBOutlet UIView* addView;
@property (nonatomic,weak) IBOutlet UIView* conView;
@property (nonatomic,weak) IBOutlet UIView* delView;
@property (nonatomic,weak) IBOutlet UIView* subView;
@property (nonatomic,weak) IBOutlet UIButton* subBtn;
@property (nonatomic, strong) StockService *stockService;
/**调整商品列表*/
@property (nonatomic,strong) NSMutableArray* goodsList;
/**删除商品列表*/
@property (nonatomic,strong) NSMutableArray* delList;
/**门店|仓库id*/
@property (nonatomic, copy) NSString *shopId;
/**门店|仓库名称*/
@property (nonatomic, copy) NSString *shopName;
/**商品列表展示模式*/
@property (nonatomic,assign) PaperGoodsCellType mode;
/**页面显示模式*/
@property (nonatomic,assign) NSInteger action;
/**调整单状态值 1 未提交  2 待确认 */
@property (nonatomic,assign) short billStatus;
/**|1 单店|2 门店|3 机构|*/
@property (nonatomic,assign) short shopMode;
/**调整单号*/
@property (nonatomic,copy)  NSString *adjustCode;
@property (nonatomic, strong) NSString *adjustShopId;/**<首次添加商品时返回，提交check时需要>*/
/**页面回调block*/
@property (nonatomic,copy)  AdjustPaperHandler adjustHandler;
/**页面是否可编辑*/
@property (nonatomic,assign) BOOL isEdit;
/**是否第一次添加*/
@property (nonatomic,assign) BOOL isFirstAdd;
/**是否第一次添加保存后退出页面*/
@property (nonatomic,assign) BOOL isSave;
/**是否折叠基本信息*/
@property (nonatomic,assign) BOOL isFold;
/**是否服鞋*/
@property (nonatomic,assign) BOOL isCloShoes;
/**调整单模型*/
@property (nonatomic,strong) StockAdjustVo *stockAdjustVo;
/**调整详情商品模型*/
@property (nonatomic,strong) StockAdjustDetailVo *stockDeatilVo;
/**版本号*/
@property (nonatomic, assign) NSInteger lastVer;
/**页面标识*/
@property (nonatomic, assign) NSInteger flag;
/**调整原因*/
@property (nonatomic, copy) NSString *adjustReason;
/**唯一性*/
@property (nonatomic,copy) NSString *token;
/** 处理记录 */
@property (nonatomic, strong) NSArray *dealRecords;
@property (weak, nonatomic) IBOutlet UIButton *btnRefuse;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;
@end

@implementation StockAdjustEditView


- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainGrid.frame = CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH);
    self.stockService = [ServiceFactory shareInstance].stockService;
    [self initNavigate];
    [self setupHeaderView];
    [self initMainView];
    [self loadData];
    [self configHelpButton:HELP_STOCK_ADJUST];
    [UIHelper clearColor:self.footerView];
}

- (void)setupHeaderView {
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 100)];
    self.baseTitle = [LSEditItemTitle editItemTitle];
    [_headerView addSubview:self.baseTitle];
    
    self.txtNo = [LSEditItemText editItemText];
    [_headerView addSubview:self.txtNo];
    
    self.vewStatus = [LSEditItemView editItemView];
    [self.vewStatus initLabel:@"调整单状态" withHit:nil];
    [_headerView addSubview:self.vewStatus];
    
    self.lsShop = [LSEditItemList editItemList];
    [_headerView addSubview:self.lsShop];
    
    self.lsDate = [LSEditItemList editItemList];
    [_headerView addSubview:self.lsDate];
    
    self.lsTime = [LSEditItemList editItemList];
    [_headerView addSubview:self.lsTime];
    
    self.txtMemo = [LSEditItemText editItemText];
    [_headerView addSubview:self.txtMemo];
    
    self.lstDealRecord = [LSEditItemList editItemList];
    [self.lstDealRecord initLabel:@"处理记录" withHit:nil delegate:self];
    self.lstDealRecord.lblVal.hidden = YES;
    self.lstDealRecord.imgMore.image = [UIImage imageNamed:@"ico_next"];
    [_headerView addSubview:self.lstDealRecord];
    
    [LSViewFactor addClearView:_headerView y:0 h:20];
    
    self.goodsTitle = [LSEditItemTitle editItemTitle];
    [_headerView addSubview:self.goodsTitle];
    
    self.lsCondition = [LSEditItemList editItemList];
    [_headerView addSubview:self.lsCondition];
    
    [UIHelper refreshUI:_headerView];

}
#pragma mark - 初始化导航栏
- (void)initNavigate
{
    [self configTitle:@"" leftPath:Head_ICON_BACK rightPath:nil];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        [self removeNotification];
        if (!self.isFirstAdd&&self.flag==ACTION_CONSTANTS_ADD) {
            self.adjustHandler(nil,ACTION_CONSTANTS_ADD);
        }
        [XHAnimalUtil animalEdit:self.navigationController action:self.action];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self save];
    }

}

#pragma mark - 初始化主视图
- (void)initMainView
{
    __weak typeof(self) wself = self;
    [self.baseTitle configTitle:@"基本信息" type:LSEditItemTitleTypeOpen rightClick:^(LSEditItemTitle *view) {
        [wself expandBaseInfo];
    }];
    [self.txtNo initLabel:@"调整单号" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtNo editEnabled:NO];
    [self.lsShop initLabel:@"仓库" withHit:nil isrequest:YES delegate:self];
    [self.lsShop.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    [self.lsDate initLabel:@"调整日期" withHit:nil delegate:self];
    [self.lsTime initLabel:@"调整时间" withHit:nil delegate:self];
    [self.txtMemo initLabel:@"备注" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtMemo initMaxNum:100];
    [self.goodsTitle configTitle:@"调整商品" type:LSEditItemTitleTypeDown rightClick:^(LSEditItemTitle *view) {
        float cHeight = self.mainGrid.contentSize.height;
        float mHeight = self.mainGrid.bounds.size.height;
        if (cHeight>mHeight) {
            [wself.mainGrid setContentOffset:CGPointMake(0, cHeight - mHeight) animated:YES];
        }
    }];
    [self.lsCondition initLabel:@"展示内容" withHit:nil delegate:self];
    
    self.lsShop.tag = SHOP;
    self.lsDate.tag = DATE;
    self.lsTime.tag = TIME;
    self.lsCondition.tag = CONDITION;
}

#pragma mark - UI变化通知
- (void)registerNotification
{
    [UIHelper initNotification:self.headerView event:Notification_UI_Change_STOCK_ADJUST];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_Change_STOCK_ADJUST object:nil];
}

- (void)dataChange:(NSNotification *)notification
{
    [self editTitle:[UIHelper currChange:self.headerView] act:_action];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 参数设置
- (void)showDetail:(StockAdjustVo*)stockAdjustVo withEditable:(BOOL)enable withAction:(NSInteger)action callBack:(AdjustPaperHandler)handler
{
    self.adjustCode = stockAdjustVo.adjustCode;
    self.billStatus = stockAdjustVo.billStatus;
    self.stockAdjustVo = stockAdjustVo;
    self.shopMode = [[Platform Instance] getShopMode];
    self.isEdit = self.billStatus==1 || action==ACTION_CONSTANTS_ADD || (self.billStatus == 2 && self.hasStockAdjust);
    self.action = action;
    self.adjustHandler = handler;
    self.mode = PaperGoodsCellTypeCount;
    self.isFold = NO;
    self.isCloShoes = [[[Platform Instance] getkey:SHOP_MODE] integerValue]==CLOTHESHOES_MODE;
    self.goodsList = [NSMutableArray array];
    self.delList = [NSMutableArray array];
}

#pragma mark - 加载页面数据
- (void)loadData
{
    [self registerNotification];
    [self showHeaderView:self.action];
    [self showFooterView:self.action];
    [self expandBaseInfo];
    if (self.action==ACTION_CONSTANTS_ADD) {
        self.flag = ACTION_CONSTANTS_ADD;
        [self configTitle:@"添加库存调整单"];
        [self clearDo];
    }else{
        self.flag = ACTION_CONSTANTS_EDIT;
        [self selectAdjustGoodsList:self.adjustCode];
    }
}

#pragma mark - 显示视图
//显示基本信息项
- (void)showHeaderView:(NSInteger)action
{
    [self.txtNo visibal:!(action==ACTION_CONSTANTS_ADD)];
    [self.vewStatus visibal:!(action==ACTION_CONSTANTS_ADD)];
    [self.lstDealRecord visibal:!(action==ACTION_CONSTANTS_ADD)];
    [self.lsShop editEnable:(action==ACTION_CONSTANTS_ADD)];
    [self.lsShop visibal:(self.shopMode==3)];
    [self.lsDate editEnable:(self.billStatus==1 || action==ACTION_CONSTANTS_ADD)];
    [self.lsTime editEnable:(self.billStatus==1 || action==ACTION_CONSTANTS_ADD)];
    if (!(self.billStatus==1 || action==ACTION_CONSTANTS_ADD)) {
        self.txtMemo.txtVal.placeholder = @"";
    }
    [self.txtMemo editEnabled:(self.billStatus==1 || action==ACTION_CONSTANTS_ADD)];
    [self.lsCondition visibal:(!self.isCloShoes&&self.isEdit)];
    [UIHelper refreshUI:self.headerView];
    self.mainGrid.tableHeaderView = self.headerView;
}

//显示底部按钮
- (void)showFooterView:(NSInteger)action
{
    //只有未提交和待确认时显示添加按钮并且有库存调整的权限
    //添加调整商品按钮   1.添加模式时，表示
//    2.编辑模式时，调整单状态是“未提交”时表示
//    3.调整单状态是“待确认”时，根据登录者角色权限判断是否可表示（有“库存调整权限”时表示）
    self.addView.hidden = !(self.billStatus == 1 || (self.billStatus == 2 && self.hasStockAdjust) || action==ACTION_CONSTANTS_ADD);
    self.subView.hidden = !(self.billStatus == 1 && self.goodsList.count>0);
    self.delView.hidden = !(self.billStatus == 1);
    self.conView.hidden = !(self.billStatus == 2 && self.hasStockAdjust && self.goodsList.count > 0);
    __weak typeof(self) wself = self;
    if (self.billStatus == 2 && self.hasStockAdjust && self.goodsList.count == 0) {
        self.conView.hidden = NO;
        self.btnConfirm.hidden = YES;
        [self.btnRefuse remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wself.conView).offset(10);
            make.right.equalTo(wself.conView).offset(-10);
            make.height.equalTo(44);
            make.centerY.equalTo(wself.conView);
        }];
    } else {
        self.btnConfirm.hidden = NO;
        [self.btnConfirm remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wself.conView).offset(10);
            make.right.equalTo(wself.btnRefuse.left).offset(-10);
            make.height.equalTo(44);
            make.width.equalTo(wself.btnRefuse);
            make.height.equalTo(wself.btnRefuse);
            make.centerY.equalTo(wself.btnRefuse);
            make.centerY.equalTo(wself.conView);
        }];
        [self.btnRefuse remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wself.conView).offset(-10);
        }];
    }
    if (self.shopMode == 1) {
        [self.subBtn setTitle:@"确认调整" forState:UIControlStateNormal];
        if ([[Platform Instance] lockAct:ACTION_STOCK_ADJUST_CHECK]) {//库存调整权限关闭时确认调整按钮不显示
            self.subView.hidden = YES;
            
        }
    }
    [self.addView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.addView.hidden ? 0 : 48);
    }];
    [self.subView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.subView.hidden ? 0 : 64);
    }];
    [self.delView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.delView.hidden ? 0 : 64);
    }];
    [self.conView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.conView.hidden ? 0 : 64);
    }];
    [self.footerView layoutIfNeeded];
    [UIHelper refreshUI:self.footerView];
    self.mainGrid.tableFooterView = self.footerView;
}

#pragma mark - 添加时设置默认值
- (void)clearDo
{
    if (self.shopMode!=3) {
        self.shopId = [[Platform Instance] getkey:SHOP_ID];
    }
    self.isFirstAdd = YES;
    NSDate* date = [NSDate date];
    NSString* dateStr = [DateUtils formateDate2:date];
    NSString* timeStr = [DateUtils formateChineseTime:date];
    [self.lsDate initData:dateStr withVal:dateStr];
    [self.lsTime initData:timeStr withVal:timeStr];
    [self.txtMemo initData:nil];
    [self.lsCondition initData:kAdjustCountName withVal:kAdjustCountVal];
    [self.mainGrid reloadData];
    [self statisticsData];
}


#pragma mark - 查询调整单详情
- (void)selectAdjustGoodsList:(NSString*)adjustCode
{
    __weak typeof(self) weakSelf = self;
    [self.stockService selectStockAdjustDetailByCode:adjustCode CompletionHandler:^(id json) {
        weakSelf.goodsList = [StockAdjustDetailVo converToArr:[json objectForKey:@"stockAdjustDetailVoList"]];
        weakSelf.stockAdjustVo = [StockAdjustVo converToVo:[json objectForKey:@"stockAdjustVo"]];
        weakSelf.dealRecords = [LSDealRecordVo dealRecordVoWithArray:json[@"billsOpLogVoList"]];
      
        if ([ObjectUtil isEmpty:weakSelf.dealRecords]) {//老数据有可能没有处理记录需要做一下兼容
            [weakSelf.lstDealRecord visibal:NO];
        }
        [weakSelf configTitle:weakSelf.stockAdjustVo.adjustCode];
        [weakSelf.txtNo initData:weakSelf.stockAdjustVo.adjustCode];
        weakSelf.shopId = weakSelf.stockAdjustVo.shopId;
        if (weakSelf.shopMode==3) {
            [weakSelf.lsShop initData:weakSelf.stockAdjustVo.shopName withVal:weakSelf.stockAdjustVo.shopId];
        }
        NSString *status = @"";
        UIColor *color = nil;
        if (weakSelf.stockAdjustVo.billStatus == 1) {
            status = @"未提交";
            color = [ColorHelper getBlueColor];
        } else if (weakSelf.stockAdjustVo.billStatus == 2) {
            status = @"待确认";
            color = [ColorHelper getGreenColor];
        } else if (weakSelf.stockAdjustVo.billStatus == 3) {
            status = @"已调整";
            color = [ColorHelper getTipColor6];
        } else if (weakSelf.stockAdjustVo.billStatus == 4) {
            status = @"已拒绝";
            color = [ColorHelper getRedColor];
        }
        [weakSelf.vewStatus initData:status];
//        weakSelf.vewStatus.lblVal.textColor = color;
        weakSelf.lastVer = weakSelf.stockAdjustVo.lastVer;
        NSString *dateStr = [DateUtils formateTime2:weakSelf.stockAdjustVo.createTime];
        [weakSelf.lsDate initData:dateStr withVal:dateStr];
        NSString *timeStr = [DateUtils formateShortTime2:weakSelf.stockAdjustVo.createTime];
        [weakSelf.lsTime initData:timeStr withVal:timeStr];
        if (weakSelf.stockAdjustVo.shopType == 1) {//门店
            weakSelf.lsShop.lblName.text = @"门店";
        } else if (weakSelf.stockAdjustVo.shopType == 2) {//仓库
            weakSelf.lsShop.lblName.text = @"仓库";
        }
        [weakSelf.txtMemo initData:weakSelf.stockAdjustVo.memo];
        [weakSelf.lsCondition initData:kAdjustCountName withVal:kAdjustCountVal];
        [weakSelf statisticsData];
        [UIHelper refreshUI:weakSelf.headerView];
        [weakSelf.mainGrid reloadData];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}


#pragma mark - 统计数量和金额
- (void)statisticsData
{
    NSInteger num = self.goodsList.count;
    double totalMoney = 0.00;
    double sum = 0.00;
    BOOL type = NO;
    for (StockAdjustDetailVo *vo  in self.goodsList) {
        if (self.isCloShoes) {
            totalMoney += [vo.sumAdjustMoney doubleValue];
        }else{
            if (self.shopMode==1) {
                totalMoney += [vo.adjustStore doubleValue]*[vo.purchasePrice doubleValue];
            }else{
                totalMoney += [vo.adjustStore doubleValue]*[vo.retailPrice doubleValue];
            }
        }
        sum += [vo.adjustStore doubleValue];
        if (vo.type==4) {
            type = YES;
        }
    }
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"本次调整合计 "];
    NSString* str = [NSString stringWithFormat:@"%tu 项, ",num];
    NSMutableAttributedString *amoutAttr = [[NSMutableAttributedString alloc] initWithString:str];
    [amoutAttr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getRedColor] range:NSMakeRange(0,str.length-4)];
    [attrString appendAttributedString:amoutAttr];
    
    NSString *sumStr = type?[NSString stringWithFormat:@"%.3f 件 ",sum]:[NSString stringWithFormat:@"%.0f 件 ",sum];
    NSMutableAttributedString *sumAttr = [[NSMutableAttributedString alloc] initWithString:sumStr];
    [sumAttr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getRedColor] range:NSMakeRange(0,sumStr.length-3)];
    [attrString appendAttributedString:sumAttr];
    
//    NSString* priceStr = [NSString stringWithFormat:@"¥%.2f ",totalMoney];
//    NSMutableAttributedString *priceAttr = [[NSMutableAttributedString alloc] initWithString:priceStr];
//    [priceAttr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getRedColor] range:NSMakeRange(0,priceStr.length-1)];
//    
//    [priceAttr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:16.0] range:NSMakeRange(1, priceStr.length-1)];
//    [attrString appendAttributedString:priceAttr];
    self.lblTotal.attributedText = attrString;
    amoutAttr = nil;
    sumAttr = nil;
//    priceAttr = nil;
    attrString = nil;
    [self showFooterView:self.action];
}

#pragma mark - IEditItemListEvent
- (void)onItemListClick:(LSEditItemList *)obj
{
    NSDate* date = nil;
    if (obj.tag==SHOP) {
        SelectStoreListView *storeList = [[SelectStoreListView alloc] init];
        __weak typeof(self) weakSelf = self;
        [storeList loadData:[obj getStrVal] withOrgId:[[Platform Instance] getkey:ORG_ID] withIsSelf:YES callBack:^(id<INameCode> item) {
            if (item) {
                [obj changeData:[item obtainItemName] withVal:[item obtainItemId]];
                weakSelf.shopId = [item obtainItemId];
            }
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
        [self.navigationController pushViewController:storeList animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        storeList = nil;
    }else if (obj.tag==DATE) {
        date = [DateUtils parseDateTime4:[obj getStrVal]];
        [DatePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
    }else if (obj.tag==TIME){
        date=[DateUtils parseDateTime6:[obj getStrVal]];
        [TimePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
    }else if (obj.tag==CONDITION){
        NSMutableArray* vos = [NSMutableArray arrayWithCapacity:1];
        NameItemVO *item=[[NameItemVO alloc] initWithVal:kAdjustCountName andId:kAdjustCountVal];
        [vos addObject:item];
        item=[[NameItemVO alloc] initWithVal:kAdjustAfterCountName andId:kAdjustAfterCountVal];
        [vos addObject:item];
        [OptionPickerBox initData:vos itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    } else if (obj == self.lstDealRecord) {//处理记录
        LSDealRecordController *vc = [[LSDealRecordController alloc] initWithDealRecords:self.dealRecords];
        [self pushViewController:vc];
    }
}

- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event
{
    NSString* dateStr=[DateUtils formateDate2:date];
    
    [self.lsDate changeData:dateStr withVal:dateStr];
    return YES;
}

- (BOOL)pickTime:(NSDate *)date event:(NSInteger)event
{
    NSString* timeStr=[DateUtils formateChineseTime:date];
    
    [self.lsTime changeData:timeStr withVal:timeStr];
    return YES;
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    id<INameItem> vo = (id<INameItem>)selectObj;
    if (eventType==CONDITION) {
        [self.lsCondition changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
        if ([self.lsCondition isChange]) {
            if ([[vo obtainItemName] isEqualToString:kAdjustAfterCountName]) {
                 self.mode = PaperGoodsCellTypeAdjustAfterCount;
                [self.goodsList enumerateObjectsUsingBlock:^(StockAdjustDetailVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.totalStore = [NSNumber numberWithDouble:(obj.nowStore.doubleValue + obj.adjustStore.doubleValue)];
                    
                }];
            } else if ([[vo obtainItemName] isEqualToString:kAdjustCountName]) {
                self.mode = PaperGoodsCellTypeCount;
                [self.goodsList enumerateObjectsUsingBlock:^(StockAdjustDetailVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.adjustStore = [NSNumber numberWithDouble:(obj.totalStore.doubleValue - obj.nowStore.doubleValue)];
                    
                }];
            }
        }
        
        [self.mainGrid reloadData];
    }
    return YES;
}

- (void)expandBaseInfo
{
    [self.txtNo visibal:(_action==ACTION_CONSTANTS_EDIT)&&!_isFold];
    [self.vewStatus visibal:(_action==ACTION_CONSTANTS_EDIT)&&!_isFold];
    [self.lstDealRecord visibal:(_action==ACTION_CONSTANTS_EDIT)&&!_isFold];
    [self.lsShop visibal:!_isFold&&(self.shopMode==3)];
    [self.lsDate visibal:!_isFold];
    [self.lsTime visibal:!_isFold];
    [self.txtMemo visibal:!_isFold];
    _isFold = !_isFold;
    [UIHelper refreshUI:self.headerView];
    self.mainGrid.tableHeaderView = self.headerView;
}


#pragma mark -PaperGoodsCellDelegate协议
//改变导航栏状态
- (void)changeNavigateUI
{
    __block BOOL flag =NO;
    [self.goodsList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        StockAdjustDetailVo * vo = (StockAdjustDetailVo*)obj;
        if (vo.changeFlag==1||[vo.operateType isEqualToString:@"add"]||vo.reasonFlag==1) {
            flag = YES;
            *stop = YES;
        }
    }];
    [self editTitle:([UIHelper currChange:self.headerView]||flag||self.delList.count>0) act:_action];
    [self statisticsData];
}


#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodsList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isCloShoes) {
        static NSString* adjustStyleCellId = @"AdjustStyleCell";
        AdjustStyleCell* cell = [tableView dequeueReusableCellWithIdentifier:adjustStyleCellId];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"AdjustStyleCell" bundle:nil] forCellReuseIdentifier:adjustStyleCellId];
            cell = [tableView dequeueReusableCellWithIdentifier:adjustStyleCellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setNeedsDisplay];
        return cell;
    }else{
        return [self tableView:tableView marketCellForRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView marketCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *paperGoodsCellId = @"PaperGoodsCell";
    PaperGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:paperGoodsCellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"PaperGoodsCell" bundle:nil] forCellReuseIdentifier:paperGoodsCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:paperGoodsCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.goodsList.count>0) {
        if (self.isCloShoes) {
            AdjustStyleCell *detailItem = (AdjustStyleCell *)cell;
            self.stockDeatilVo = [self.goodsList objectAtIndex:indexPath.row];
            detailItem.lblName.text = self.stockDeatilVo.styleName;
            detailItem.lblNo.text = [NSString stringWithFormat:@"款号：%@",self.stockDeatilVo.styleCode];
            if (self.billStatus == 3) {
                detailItem.lblStoreCount.text = [NSString stringWithFormat:@"调整前：%.0f",[self.stockDeatilVo.nowStore doubleValue]];
            }else{
                detailItem.lblStoreCount.text = [NSString stringWithFormat:@"当前库存：%.0f",[self.stockDeatilVo.nowStore doubleValue]];
            }
            detailItem.lblActualCount.text = [NSString stringWithFormat:@"调整后：%.0f",[self.stockDeatilVo.totalStore doubleValue]];
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"调整数量："];
            NSString* str = [NSString stringWithFormat:@"%@",self.stockDeatilVo.adjustStore];
            NSMutableAttributedString *amoutAttr = [[NSMutableAttributedString alloc] initWithString:str];
            [amoutAttr addAttribute:NSForegroundColorAttributeName value:(([self.stockDeatilVo.adjustStore doubleValue]>0)?[ColorHelper getRedColor]:[ColorHelper getGreenColor]) range:NSMakeRange(0,str.length)];
            [attrString appendAttributedString:amoutAttr];
            detailItem.lblAdjustCount.attributedText = attrString;
            attrString = nil;
            str = nil;
            amoutAttr = nil;
        }else{
            PaperGoodsCell* detailItem = (PaperGoodsCell*)cell;
            self.stockDeatilVo = [self.goodsList objectAtIndex:indexPath.row];
            detailItem.lblName.text = self.stockDeatilVo.goodsName;
            detailItem.lblCode.text = self.stockDeatilVo.barCode;
            detailItem.stepper.isStockAdjust = YES;
            if (self.billStatus == 3) {
                if ([self.stockDeatilVo.nowStore.stringValue containsString:@"."]) {//称重商品
                    detailItem.lblPrice.text = [NSString stringWithFormat:@"调整前：%.3f",[self.stockDeatilVo.nowStore  doubleValue]];
                } else {
                    detailItem.lblPrice.text = [NSString stringWithFormat:@"调整前：%d",[self.stockDeatilVo.nowStore intValue]];
                }
            }else{
                if ([self.stockDeatilVo.nowStore.stringValue containsString:@"."]) {//称重商品
                     detailItem.lblPrice.text = [NSString stringWithFormat:@"当前库存：%.3f",[self.stockDeatilVo.nowStore  doubleValue]];
                } else {
                     detailItem.lblPrice.text = [NSString stringWithFormat:@"当前库存：%d",[self.stockDeatilVo.nowStore intValue]];
                }
                
            }
            [detailItem initDelegate:self count:[self.stockDeatilVo.totalStore doubleValue] adjustCount:[self.stockDeatilVo.adjustStore doubleValue]];
            [detailItem loadStockItem:self.stockDeatilVo mode:self.mode isEdit:self.isEdit];
        }
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.stockDeatilVo = [self.goodsList objectAtIndex:indexPath.row];
    if (self.isCloShoes) {
        //查看服鞋款式详情
        [self showSelectStyleView:ACTION_CONSTANTS_EDIT];
    }else{
       //查看商超商品详情
        AdjustGoodsEditView *vc = [[AdjustGoodsEditView alloc] init];
        __weak typeof(self) weakSelf = self;
        [vc loadDataWithVo:self.stockDeatilVo withEdit:self.isEdit callBack:^(StockAdjustDetailVo *item, NSInteger action) {
            if (action==ACTION_CONSTANTS_DEL) {
                if (![item.operateType isEqualToString:@"add"]) {
                    item.operateType = @"del";
                    [weakSelf.delList addObject:item];
                }
                [weakSelf.goodsList removeObject:item];
            }
            [weakSelf changeNavigateUI];
            [weakSelf.mainGrid reloadData];
        }];
        
        [self pushViewController:vc];
    }
    
}


#pragma mark - 添加商品
- (IBAction)onAddEventClick:(id)sender
{

    if (self.isFirstAdd) {
        if (![self isValide]) {
            return;
        }
        [UIHelper clearChange:self.headerView];
        [self saveForFirstAdd];
    }else{
        if (self.isCloShoes) {
            [self showSelectStyleView:ACTION_CONSTANTS_ADD];
        }else{
            [self showSelectGoodsView];
        }
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.token = nil;
}

#pragma mark -第一次添加保存
- (void)saveForFirstAdd
{
    if ([NSString isBlank:self.token]) {
        self.token = [[Platform Instance] getToken];
    }
    NSString *dateTime = [NSString stringWithFormat:@"%@ %@",[self.lsDate getStrVal],[self.lsTime getStrVal]];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:6];
    [param setValue:self.shopId forKey:@"shopId"];
    [param setValue:[NSNumber numberWithLongLong:[DateUtils formateDateTime4:dateTime]] forKey:@"adjustTime"];
    [param setValue:[self.txtMemo getStrVal] forKey:@"memo"];
    [param setValue:self.adjustCode forKey:@"adjustCode"];
    [param setValue:[NSNumber numberWithLong:self.lastVer] forKey:@"lastVer"];
    [param setValue:self.token forKey:@"token"];
    NSString *url = @"stockAdjust/save";
    //添加t调整单 门店/机构(只能选仓库)区分：shopType 选择门店传1，选择仓库传2
    if ([[Platform Instance] getShopMode] == 3) {
        [param setValue:@2 forKey:@"shopType"];
    } else if ([[Platform Instance] getShopMode] == 2) {
        [param setValue:@1 forKey:@"shopType"];
    } else if ([[Platform Instance] getShopMode] == 1) {
        [param setValue:@1 forKey:@"shopType"];
    }
    
    __weak typeof(self) weakSelf = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        weakSelf.token = nil;
        weakSelf.action = ACTION_CONSTANTS_EDIT;
        weakSelf.isFirstAdd = NO;
        weakSelf.billStatus = 1;
        weakSelf.dealRecords = [LSDealRecordVo dealRecordVoWithArray:json[@"billsOpLogVoList"]];
        if ([ObjectUtil isNotNull:json[@"shopType"]]) {
            weakSelf.stockAdjustVo.shopType = [json[@"shopType"] intValue];
        }
        weakSelf.adjustCode = [json objectForKey:@"adjustCode"];
        weakSelf.adjustShopId = [json objectForKey:@"adjustShopId"];
        weakSelf.lastVer = [[json objectForKey:@"lastver"] integerValue];
        [weakSelf.txtNo visibal:YES];
        [weakSelf.lstDealRecord visibal:YES];
        [weakSelf.lsShop editEnable:NO];
        [weakSelf configTitle:weakSelf.adjustCode];
        [weakSelf.txtNo initData:weakSelf.adjustCode];
        [weakSelf.vewStatus initData:@"未提交"];
        [weakSelf.vewStatus visibal:YES];
//        weakSelf.vewStatus.lblVal.textColor = [ColorHelper getBlueColor];
        [UIHelper clearChange:weakSelf.headerView];
        [UIHelper refreshUI:weakSelf.headerView];
        [weakSelf showFooterView:ACTION_CONSTANTS_EDIT];
        weakSelf.mainGrid.tableHeaderView = weakSelf.headerView;
        [UIHelper clearChange:weakSelf.headerView];
        if (weakSelf.isSave) {
            weakSelf.adjustHandler(nil,ACTION_CONSTANTS_ADD);
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf.navigationController popViewControllerAnimated:NO];
        }else{
            if (weakSelf.isCloShoes) {
                [weakSelf showSelectStyleView:ACTION_CONSTANTS_ADD];
            }else{
                [weakSelf showSelectGoodsView];
            }
        }
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}

//服鞋商品详情
- (void)showSelectStyleView:(NSInteger)action
{
    if (action == ACTION_CONSTANTS_ADD) {
        if (self.goodsList.count==200) {
            [LSAlertHelper showAlert:@"最多只能添加200款商品!"];
            return ;
        }
    }
    
    AdjustStyleEditView *styleEditView = [[AdjustStyleEditView alloc] init];
    __weak typeof(self) weakSelf = self;
    NSString *dateTime = [NSString stringWithFormat:@"%@ %@",[self.lsDate getStrVal],[self.lsTime getStrVal]];
    styleEditView.adjustTime = [DateUtils formateDateTime4:dateTime];
    styleEditView.memo = [self.txtMemo getStrVal];
    styleEditView.action = action;
    styleEditView.isEdit = self.isEdit;
    styleEditView.billStatus = self.billStatus;
    styleEditView.shopType = @(self.stockAdjustVo.shopType);
    styleEditView.price = ([[Platform Instance] getShopMode]!=1)?[self.stockDeatilVo.hangTagPrice doubleValue]:[self.stockDeatilVo.purchasePrice doubleValue];
    [styleEditView loadData:self.shopId withStyleId:self.stockDeatilVo.styleId withCode:self.adjustCode withLastVer:self.lastVer callBack:^{
        [weakSelf selectAdjustGoodsList:weakSelf.adjustCode];
    }];
    [self.navigationController pushViewController:styleEditView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

//添加商超商品
- (void)showSelectGoodsView
{
    if (self.goodsList.count==200) {
        [LSAlertHelper showAlert:@"最多只能添加200种商品!"];
        return ;
    }
    GoodsBatchChoiceView1 *goodsView = [[GoodsBatchChoiceView1 alloc] init];
    goodsView.mode = 2;
    goodsView.getStockFlg = YES;
    goodsView.warehouseId = self.shopMode==3?[self.lsShop getStrVal]:@"";
    goodsView.validTypeList = [NSMutableArray arrayWithObjects:@"1",@"2",@"4", nil];
    __weak typeof(self) weakSelf = self;
    [goodsView loaddatas:[[Platform Instance] getkey:SHOP_ID] callBack:^(NSMutableArray *goodsList) {
         if (goodsList.count>0) {
             //有选择商品
             NSMutableArray *addArr = [NSMutableArray arrayWithCapacity:goodsList.count];
            for (GoodsVo* vo in goodsList) {
                BOOL flag = NO;
                BOOL isHave = NO;
                if (weakSelf.delList.count>0) {
                    //添加删除队列中存在的商品
                    for (StockAdjustDetailVo* detailVo in weakSelf.delList) {
                        if ([vo.goodsId isEqualToString:detailVo.goodsId]) {
                            flag = YES;
                            [addArr addObject:detailVo];
                            [weakSelf.delList removeObject:detailVo];
                            break;
                        }
                    }
                }
                if (weakSelf.goodsList.count>0) {
                    //已经存在的商品不添加
                    for (StockAdjustDetailVo* detailVo in weakSelf.goodsList) {
                        if ([vo.goodsId isEqualToString:detailVo.goodsId]) {
                            isHave = YES;
                            break;
                        }
                    }
                }
                if (!flag&&!isHave) {
                    //添加不存在以上两种情况的商品
                    StockAdjustDetailVo *detailVo = [[StockAdjustDetailVo alloc] init];
                    detailVo.goodsId = vo.goodsId;
                    detailVo.goodsName = vo.goodsName;
                    detailVo.barCode = vo.barCode;
                    detailVo.type = vo.type;
                    detailVo.goodsType = vo.type;
                    detailVo.goodsStatus = vo.upDownStatus;
                    detailVo.filePath = vo.filePath;
                    detailVo.powerPrice = vo.powerPrice;
                    detailVo.purchasePrice = [NSNumber numberWithDouble:vo.purchasePrice];
                  
                    detailVo.retailPrice = [NSNumber numberWithDouble:vo.retailPrice];
                    detailVo.adjustStore = [NSNumber numberWithDouble:1];
                    detailVo.nowStore = vo.type==2?vo.splitStore:vo.number;
                    if ([vo.number.stringValue containsString:@"."]) {
                        detailVo.totalStore = @(vo.number.doubleValue + 1.000);
                    } else {
                        detailVo.totalStore = @(vo.number.intValue + 1);
                    }
                    
                    detailVo.oldAdjustStore = detailVo.adjustStore;
                    detailVo.operateType  = @"add";
                    [addArr addObject:detailVo];
                }
            }
             
             if ((weakSelf.goodsList.count+addArr.count) > 200) {
                 //选择的商品总数超过200件,放回原删除的商品
                 for (StockAdjustDetailVo* detailVo in addArr) {
                     if ([detailVo.operateType isEqualToString:@"del"]) {
                         [weakSelf.delList addObject:detailVo];
                     }
                 }
                 [LSAlertHelper showAlert:@"最多只能添加200种商品!"];
                 return ;
             }
             
             if (addArr.count>0) {
                 //未超过200件，将原删除的商品重置
                 for (StockAdjustDetailVo* detailVo in addArr) {
                     if ([detailVo.operateType isEqualToString:@"del"]) {
                         detailVo.operateType = @"edit";
                         detailVo.adjustStore = [NSNumber numberWithDouble:0];
                         detailVo.oldAdjustStore = [NSNumber numberWithDouble:0];
                     }
                 }
                 [weakSelf.goodsList addObjectsFromArray:addArr];
             }
             
            [weakSelf.mainGrid reloadData];
            [weakSelf changeNavigateUI];
            [weakSelf statisticsData];
        }
        
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
    }];
    [self.navigationController pushViewController:goodsView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

#pragma mark - 提交
- (IBAction)onSubEventClick:(UIButton *)sender
{
    // 单店    
    if (self.shopMode == 1) {
        NSString *title = [NSString stringWithFormat:@"确认调整[%@]吗?",[self.txtNo getStrVal]];
        [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"]
                    selectdblock:^(NSInteger index) {
                        [self paperDetailGoodsDeleteCheck:3 actionName:@"确认调整"];
        }];
    } else {
        NSString *title = [NSString stringWithFormat:@"提交调整单[%@]吗?",[self.txtNo getStrVal]];
        [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"]
                    selectdblock:^(NSInteger index) {
                        [self paperDetailGoodsDeleteCheck:2 actionName:@"提交"];
        }];
    }
}

#pragma mark - 确认调整单
- (IBAction)onConEventClick:(UIButton *)sender
{
    NSString *title = [NSString stringWithFormat:@"确认调整[%@]吗?",[self.txtNo getStrVal]];
    [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"]
                selectdblock:^(NSInteger index) {
                    [self paperDetailGoodsDeleteCheck:3 actionName:@"确认调整"];
    }];
}

#pragma mark - 拒绝调整
- (IBAction)onRefEventClick:(id)sender
{
    NSString *title = [NSString stringWithFormat:@"拒绝调整[%@]吗?",[self.txtNo getStrVal]];
    [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"]
                selectdblock:^(NSInteger index) {
                    [self operatePaperByType:4 withMessage:@"正在拒绝..."];
    }];
}

#pragma mark - 删除调整单
- (IBAction)onDelEventClick:(id)sender
{
    __weak typeof(self) weakSelf = self;
    NSString *title = [NSString stringWithFormat:@"删除调整单[%@]吗?",[self.txtNo getStrVal]];
    [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"]
                selectdblock:^(NSInteger index) {
                   
                    weakSelf.token = weakSelf.token?:[[Platform Instance] getToken];
                    //删除调整单
                    [weakSelf.stockService deleteAdjustPaperByCode:self.adjustCode withToken:self.token CompletionHandler:^(id json) {
                        weakSelf.token = nil;
                        weakSelf.adjustHandler(weakSelf.stockAdjustVo,ACTION_CONSTANTS_DEL);
                        [XHAnimalUtil animalEdit:weakSelf.navigationController action:weakSelf.action];
                        [weakSelf.navigationController popViewControllerAnimated:NO];
                    } errorHandler:^(id json) {
                        [LSAlertHelper showAlert:json];
                    }];
    }];
}

#pragma mark - 删除调整商品
- (void)delStockObject:(StockAdjustDetailVo *)item
{
    self.stockDeatilVo = item;
    NSString *title = [NSString stringWithFormat:@"删除商品[%@]吗?",item.goodsName];
    [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:^{
        self.stockDeatilVo.adjustStore = [NSNumber numberWithDouble:1];
        [self.mainGrid reloadData];
    } selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
        [self.goodsList removeObject:self.stockDeatilVo];
        if (![self.stockDeatilVo.operateType isEqualToString:@"add"]) {
            self.stockDeatilVo.operateType = @"del";
            [self.delList addObject:self.stockDeatilVo];
        }
        [self changeNavigateUI];
        [self.mainGrid reloadData];
    }];
}

- (NSMutableArray *)obtainGoodsList
{
    NSMutableArray *goodsList = [NSMutableArray array];
    if (self.delList.count>0) {
        [goodsList addObjectsFromArray:self.delList];
    }
    [goodsList addObjectsFromArray:self.goodsList];
    return goodsList;
}

- (void)operatePaperByType:(short)opType withMessage:(NSString *)message
{
    
    if ([NSString isBlank:self.token]) {
        self.token = [[Platform Instance] getToken];
    }
    short modifyStatus = self.isCloShoes?1:0;
    NSString *dateTime = [NSString stringWithFormat:@"%@ %@",[self.lsDate getStrVal],[self.lsTime getStrVal]];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:8];
    [param setValue:self.adjustCode forKey:@"adjustCode"];
    [param setValue:[NSNumber numberWithShort:opType] forKey:@"opType"];
    [param setValue:[NSNumber numberWithShort:modifyStatus] forKey:@"modifyStatusOnly"];
    [param setValue:[NSNumber numberWithLong:self.lastVer] forKey:@"lastver"];
    [param setValue:[NSNumber numberWithLongLong:[DateUtils formateDateTime4:dateTime]] forKey:@"adjustTime"];
    [param setValue:[self.txtMemo getStrVal] forKey:@"memo"];
    [param setValue:[StockAdjustDetailVo converArrToDicArr:[self obtainGoodsList]] forKey:@"stockAdjustDetailList"];
    [param setValue:self.token forKey:@"token"];
    [param setValue:self.stockAdjustVo.shopOrOrgId forKey:@"shopOrOrgId"];
    [param setValue:@(self.stockAdjustVo.shopType) forKey:@"shopType"];
    NSString *url = @"stockAdjust/saveStockAdjustDetail";
    __weak typeof(self) weakSelf = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        weakSelf.token = nil;
        if (weakSelf.flag==ACTION_CONSTANTS_ADD) {
            weakSelf.adjustHandler(nil,ACTION_CONSTANTS_ADD);
        }else if (opType==1){
            //未提交状态 会更改操作人信息 调整单的添加、保存、提交，需更新单据的制单人信息调整单的审核，不需更新单据的制单人信息
            weakSelf.stockAdjustVo.opName = [[Platform Instance] getkey:EMPLOYEE_NAME];
            weakSelf.stockAdjustVo.opStaffid = [[Platform Instance] getkey:STAFF_ID];
            weakSelf.stockAdjustVo.createTime = [DateUtils formateDateTime4:dateTime];
            weakSelf.adjustHandler(weakSelf.stockAdjustVo,ACTION_CONSTANTS_EDIT);
        }else if (opType==2){
            weakSelf.stockAdjustVo.billStatus = 2;
            weakSelf.stockAdjustVo.createTime = [DateUtils formateDateTime4:dateTime];
            weakSelf.adjustHandler(weakSelf.stockAdjustVo,ACTION_CONSTANTS_EDIT);
        }else if (opType==3){
            weakSelf.stockAdjustVo.billStatus = 3;
            weakSelf.stockAdjustVo.createTime = [DateUtils formateDateTime4:dateTime];
            weakSelf.adjustHandler(weakSelf.stockAdjustVo,ACTION_CONSTANTS_EDIT);
        }else if (opType==4){
            weakSelf.stockAdjustVo.billStatus = 4;
            weakSelf.stockAdjustVo.createTime = [DateUtils formateDateTime4:dateTime];
            weakSelf.adjustHandler(weakSelf.stockAdjustVo,ACTION_CONSTANTS_EDIT);
        }
        [XHAnimalUtil animalEdit:weakSelf.navigationController action:weakSelf.action];
        [weakSelf.navigationController popViewControllerAnimated:NO];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];

}

#pragma mark - 验证
- (BOOL)isValide
{
    if ((self.shopMode==3)&&[NSString isBlank:[self.lsShop getStrVal]]) {
        [LSAlertHelper showAlert:@"请选择仓库！"];
        return NO;
    }
    return YES;

}

#pragma mark - 保存
- (void)save
{
    if (![self isValide]) {
        return;
    }
    if (self.isFirstAdd) {
        self.isSave = YES;
        [self saveForFirstAdd];
    }else{
        [self operatePaperByType:1 withMessage:@"正在保存..."];
    }
}


// 进行提交和重新申请提交前check 单子中的商品 删除状况
- (void)paperDetailGoodsDeleteCheck:(NSInteger)opType actionName:(NSString *)actionName {
    
    __weak typeof(self) wself = self;
    NSArray *array = [[StockAdjustDetailVo converArrToDicArr:[self obtainGoodsList]] copy];
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 102) {
        NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"stockAdjust/checkGoods"];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:array forKey:@"stockAdjustDetailList"];
        // shopOrOrgId只是编辑时有值
        [param setValue:self.stockAdjustVo.shopOrOrgId forKey:@"shopOrOrgId"];
        [param setValue:self.adjustShopId forKey:@"adjustShopId"];
        [self.stockService checkStockAdjustPaperGoods:url params:param completionHandler:^(id json) {
            
            NSString *code = json[@"code"];
            if (code) {

                if ([code isEqualToString:@"MS_MSI_000004"]) {
                    [LSAlertHelper showAlert:[NSString stringWithFormat:@"所有商品已被删除，无法%@!",actionName]];
                } else if ([code isEqualToString:@"MS_MSI_000005"]) {
                    NSString *newActionName = actionName;
                    if ([actionName containsString:@"确认"]) {
                        newActionName = [actionName stringByReplacingOccurrencesOfString:@"确认" withString:@""];
                    }
                    [LSAlertHelper showAlert:[NSString stringWithFormat:@"存在商品已被删除，操作将对这部分商品无效，确认%@吗？",newActionName] block:nil block:^{
                        
                        if (opType == 2) {
                            [wself operatePaperByType:opType withMessage:@"正在提交..."];
                        } else {
                            [wself operatePaperByType:opType withMessage:@"正在确认..."];
                        }
                    }];
                }
            } else if ([json[@"returnCode"] isEqualToString:@"success"]) {
                if (opType == 2) {
                    [wself operatePaperByType:opType withMessage:@"正在提交..."];
                } else {
                    [wself operatePaperByType:opType withMessage:@"正在确认..."];
                }
            }
            
        } errorHandler:^(id json) {
            
            [LSAlertHelper showAlert:json];
            
        } withMessage:@""];
    } else {
        if (opType == 2) {
            [wself operatePaperByType:opType withMessage:@"正在提交..."];
        } else {
            [wself operatePaperByType:opType withMessage:@"正在确认..."];
        }
    }
}

@end
