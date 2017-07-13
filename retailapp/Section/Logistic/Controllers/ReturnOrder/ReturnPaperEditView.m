//
//  ReturnPaperEditView.m
//  retailapp
//
//  Created by hm on 15/11/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//
#define kCountName @"数量"
#define kCountVal @"0"
#define kPriceName @"退货价"
#define kPriceVal @"1"
#define kAmountName @"金额"
#define kAmountVal @"2"
#import "ReturnPaperEditView.h"
#import "LogisticModuleEvent.h"
#import "ServiceFactory.h"
#import "UIHelper.h"
#import "ColorHelper.h"
#import "DateUtils.h"
//#import "AlertBox.h"
#import "LRender.h"
#import "LSEditItemList.h"
#import "LSEditItemText.h"
#import "LSEditItemTitle.h"
#import "DatePickerBox.h"
#import "TimePickerBox.h"
#import "OptionPickerBox.h"
#import "PaperGoodsCell.h"
#import "ShoesClothingCell.h"
#import "INameItem.h"
#import "XHAnimalUtil.h"
#import "NumberUtil.h"
#import "PaperDetailVo.h"
#import "SupplyVo.h"
#import "PaperGoodsVo.h"
#import "PaperVo.h"
#import "NameItemVO.h"
#import "ReturnTypeVo.h"
#import "HistoryPaperListView.h"
#import "GoodsDetailEditView.h"
#import "SelectSupplierListView.h"
#import "SelectShopListView.h"
#import "CloShoesEditView.h"
#import "ReturnPackBoxListView.h"
#import "GoodsBatchChoiceView1.h"
#import "GoodsVo.h"
#import "SelectStoreListView.h"
#import "UIView+Sizes.h"

@interface ReturnPaperEditView ()<IEditItemListEvent,DatePickerClient,TimePickerClient,OptionPickerClient,PaperCellGoodsDelagate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIView* headerView;
/** 历史入库单导入 */
@property (nonatomic, strong) LSEditItemList *lstHistoryInOrder;
/**历史退货单导入*/
@property (nonatomic,strong) LSEditItemList *lsHistoryReturnOrder;
/**装箱单导入*/
@property (nonatomic,strong)  LSEditItemList* lsImPackBox;
/**装箱单信息*/
@property (nonatomic,strong) LSEditItemList* lsPackBox;
/**基本信息标题*/
@property (nonatomic,strong) LSEditItemTitle* baseTitle;
/**单号*/
@property (nonatomic,strong) LSEditItemText* txtPaperNo;
/**供应商*/
@property (nonatomic,strong) LSEditItemList* lsSupplier;
/**收货仓库*/
@property (nonatomic,strong) LSEditItemList* lsReceiveWarehouse;
/**发货仓库*/
@property (nonatomic,strong) LSEditItemList* lsDeliveWarehouse;
/**退货类别*/
@property (nonatomic,strong) LSEditItemList* lsReturnType;
/**日期*/
@property (nonatomic,strong) LSEditItemList* lsDate;
/**时间*/
@property (nonatomic,strong) LSEditItemList* lsTime;
/**备注*/
@property (nonatomic,strong) LSEditItemText* txtMemo;
/**商品列表标题*/
@property (nonatomic,strong) LSEditItemTitle* goodsTitle;
/**显示模式*/
@property (nonatomic,strong) LSEditItemList* lsMode;

@property (nonatomic,strong) UITableView* mainGrid;

@property (nonatomic,weak) IBOutlet UIView* footerView;
@property (nonatomic,weak) IBOutlet UIView* addView;
/**添加名称*/
@property (nonatomic,weak) IBOutlet UILabel* lblName;
/**确认 拒绝*/
@property (nonatomic,weak) IBOutlet UIView* crView;
@property (nonatomic,weak) IBOutlet UIButton* comfirmBtn;
@property (nonatomic,weak) IBOutlet UIButton* refuseBtn;
/**确认退货*/
@property (nonatomic,weak) IBOutlet UIView* comView;
@property (nonatomic,weak) IBOutlet UIButton* comBtn;
/**提交*/
@property (nonatomic,weak) IBOutlet UIView* subView;
@property (nonatomic,weak) IBOutlet UIButton* subBtn;
/**删除*/
@property (nonatomic,weak) IBOutlet UIView* delView;
@property (nonatomic,weak) IBOutlet UIButton* delBtn;
/**合计*/
@property (nonatomic,weak) IBOutlet UIView* sumView;
/**总项数 价格*/
@property (nonatomic,weak) IBOutlet UILabel* lblAmount;
@property (nonatomic,copy) NSString* recordType;

@property (nonatomic,strong) LogisticService  * logisticService;
/**创建单据的shopid*/
@property (nonatomic,copy  ) NSString         * shopId;
@property (nonatomic,copy  ) NSString         * shopName;
@property (nonatomic,copy  ) NSString         * supplyId;
@property (nonatomic,copy  ) NSString         * supplyName;
@property (nonatomic,copy  ) NSString         * paperId;
@property (nonatomic,assign) long             lastVer;
@property (nonatomic,assign) NSInteger        paperType;
@property (nonatomic,assign) NSInteger        action;
@property (nonatomic,assign) BOOL             isEdit;
@property (nonatomic,assign) short            status;
@property (nonatomic,copy  ) EditReturnPaperHandler paperHandler;
// PRICE_MODE COUNT_MODE ;计数和价格模式
@property (nonatomic,assign) PaperGoodsCellType        mode;
@property (nonatomic,assign) BOOL             isFold;
/**UI变化标示位*/
@property (nonatomic,assign) BOOL             isChangeFlag;
@property (nonatomic,assign) NSInteger        shopMode;
/**1单店 2连锁 3机构*/
@property (nonatomic,assign) NSInteger        shopType;
@property (nonatomic,strong) NSMutableArray   * goodList;
@property (nonatomic,strong) NSMutableArray   * delGoodsList;
@property (nonatomic,strong) PaperDetailVo    * paperDetailVo;
@property (nonatomic,strong) PaperVo          * paperVo;
/**是否是机构*/
@property (nonatomic,assign) BOOL             isOrg;
/**是否是总机构*/
@property (nonatomic,assign) BOOL             isTopOrg;
/**是否启用装箱单*/
@property (nonatomic,assign) BOOL             isOpenPickBox;
/**是否第三方供应商 1是 0否*/
@property (nonatomic,assign) BOOL             isThirdSupplier;
/**是否是第一次添加*/
@property (nonatomic,assign) BOOL             isFirstAdd;
/**是否是装箱单导入*/
@property (nonatomic,assign) BOOL             isImportPack;
/**是否是历史单导入*/
@property (nonatomic,assign) BOOL             isHistory;
/**是否是添加标识位*/
@property (nonatomic,assign) NSInteger        flg;
/**历史单id*/
@property (nonatomic,copy  ) NSString         * historyPaperId;
/**单据类型*/
@property (nonatomic,assign  ) short         type;
/**退货类别列表*/
@property (nonatomic,strong) NSMutableArray   * typeList;
/**唯一性*/
@property (nonatomic,copy  ) NSString         * token;
//是否可以查看价格
@property (nonatomic, assign) BOOL isSearchPrice;
//价格是否更改
@property (nonatomic, assign) BOOL isEditPrice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintAddView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConatraintCrView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConatraintComView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConatraintSubView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintDelView;
/** 历史入库单Id */
@property (nonatomic, copy) NSString *historyInPaperId;
/** 历史入库单type */
@property (nonatomic, copy) NSString *historyInPaperType;
@end

@implementation ReturnPaperEditView


- (void)viewDidLoad {
    [super viewDidLoad];
    //收货入库单添加时默认是p
    self.historyInPaperType = @"p";
     _logisticService = [ServiceFactory shareInstance].logisticService;
    self.mainGrid.frame = CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH);;
    [self initNavigate];
    [self configHeaderView];
    [self initMainView];
    //进货价/退货价查看编辑 修改权限控制
    //1 进货价/退货价查看权限打开 进货价/退货价编辑权限打开时 显示的是采购价 可以编辑
    //2 进货价/退货价查看权限打开 进货价/退货价编辑权限关闭时 显示的是采购价 不可以编辑
    //3 进货价/退货价查看权限关闭 进货价/退货价编辑权限关闭/打开时 商超显示的是零售价 服鞋显示的是吊牌价 不可以编辑
    //编辑
    
    //查看
    self.isEditPrice = ![[Platform Instance] lockAct:ACTION_PURCHASE_RETURN_PRICE_EDIT] && ![[Platform Instance] lockAct:ACTION_PURCHASE_RETURN_PRICE_SEARCH];
    //查看
    self.isSearchPrice = ![[Platform Instance] lockAct:ACTION_PURCHASE_RETURN_PRICE_SEARCH];
    self.goodList = [[NSMutableArray alloc] init];
    self.delGoodsList = [[NSMutableArray alloc] init];
    self.typeList = [[NSMutableArray alloc] init];
    [self loadData];
    [self configHelpButton:HELP_OUTIN_RETURN_ORDER];
}

- (void)configHeaderView {
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 100)];
    self.lstHistoryInOrder = [LSEditItemList editItemList];
    [self.headerView addSubview:self.lstHistoryInOrder];
    
    self.lsHistoryReturnOrder = [LSEditItemList editItemList];
    [self.headerView addSubview:self.lsHistoryReturnOrder];
    
    self.lsImPackBox = [LSEditItemList editItemList];
    [self.headerView addSubview:self.lsImPackBox];
    
    self.lsPackBox = [LSEditItemList editItemList];
    [self.headerView addSubview:self.lsPackBox];
    
    self.baseTitle = [LSEditItemTitle editItemTitle];
    [self.headerView addSubview:self.baseTitle];
    
    self.txtPaperNo = [LSEditItemText editItemText];
    [self.headerView addSubview:self.txtPaperNo];
    
    self.lsSupplier = [LSEditItemList editItemList];
    [self.headerView addSubview:self.lsSupplier];
    
    self.lsReceiveWarehouse = [LSEditItemList editItemList];
    [self.headerView addSubview:self.lsReceiveWarehouse];
    
    self.lsDeliveWarehouse = [LSEditItemList editItemList];
    [self.headerView addSubview:self.lsDeliveWarehouse];
    
    self.lsReturnType = [LSEditItemList editItemList];
    [self.headerView addSubview:self.lsReturnType];
    
    self.lsDate = [LSEditItemList editItemList];
    [self.headerView addSubview:self.lsDate];
    
    self.lsTime = [LSEditItemList editItemList];
    [self.headerView addSubview:self.lsTime];
    
    self.txtMemo = [LSEditItemText editItemText];
    [self.headerView addSubview:self.txtMemo];
    
    [LSViewFactor addClearView:self.headerView y:0 h:20];
    
    self.goodsTitle = [LSEditItemTitle editItemTitle];
    [self.headerView addSubview:self.goodsTitle];
    
    self.lsMode = [LSEditItemList editItemList];
    [self.headerView addSubview:self.lsMode];
    
}



- (void)loadPaperId:(NSString*)paperId status:(short)billStatus paperType:(NSInteger)paperType action:(NSInteger)action isEdit:(BOOL)isEdit callBack:(EditReturnPaperHandler)callBack
{
    self.paperId = paperId;
    self.paperType = paperType;
    self.action = action;
    self.isEdit = isEdit;
    self.status = billStatus;
    self.paperHandler = callBack;
    self.mode = PaperGoodsCellTypeCount;
    self.shopType = [[Platform Instance] getShopMode];
    self.isFold = NO;
    self.isOrg = (self.shopType==3);
    self.isOpenPickBox = ([[[Platform Instance] getkey:PACK_BOX_FLAG] integerValue]==1);
    self.shopMode = [[[Platform Instance] getkey:SHOP_MODE] integerValue];
    self.type = (paperType==CLIENT_RETURN_PAPER_TYPE)?2:1;
    self.isThirdSupplier = YES;
    self.isTopOrg = [[Platform Instance] isTopOrg];
}

- (void)initNavigate
{
    [self configTitle:@"" leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
}

#pragma mark - INavigateEvent协议
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        [self removeNotification];
        if (!self.isFirstAdd&&self.flg==ACTION_CONSTANTS_ADD) {
            self.paperHandler(nil,ACTION_CONSTANTS_ADD);
        }
        [XHAnimalUtil animalEdit:self.navigationController action:_action];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self save];
    }
}

- (void)initMainView
{
     __weak typeof(self) wself = self;
    
    [self.lstHistoryInOrder.lblName setFont:[UIFont boldSystemFontOfSize:17]];
    [self.lstHistoryInOrder.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    //    [self.lsHistory initLabel:@"从历史收货单导入" withHit:@"快速导入历史收货单信息" delegate:self];
    [self.lstHistoryInOrder initLabel:@"从历史入库单导入" withHit:@"快速导入历史入库单信息" delegate:self];
    [self.lstHistoryInOrder.imgMore mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wself.lstHistoryInOrder);
        make.size.equalTo(22);
        make.right.equalTo(wself.lstHistoryInOrder.right).offset(-10);
    }];
    
    self.lstHistoryInOrder.lblVal.placeholder = @"";
    
    [self.lsHistoryReturnOrder.lblName setFont:[UIFont boldSystemFontOfSize:17]];
    [self.lsHistoryReturnOrder.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    [self.lsHistoryReturnOrder initLabel:@"从历史退货单导入" withHit:@"快速导入历史退货单信息" delegate:self];
    [self.lsHistoryReturnOrder.imgMore mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wself.lsHistoryReturnOrder);
        make.size.equalTo(22);
        make.right.equalTo(wself.lsHistoryReturnOrder.right).offset(-10);
    }];
    self.lsHistoryReturnOrder.lblVal.placeholder = @"";
    
    [self.lsImPackBox.lblName setFont:[UIFont boldSystemFontOfSize:17]];
    [self.lsImPackBox.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    [self.lsImPackBox initLabel:@"从装箱单导入" withHit:@"快速导入装箱单信息" delegate:self];
    self.lsImPackBox.lblVal.placeholder = @"";
    
    [self.lsImPackBox.imgMore mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wself.lsImPackBox);
        make.size.equalTo(22);
        make.right.equalTo(wself.lsImPackBox.right).offset(-10);
    }];
    
    [self.lsPackBox.lblName setFont:[UIFont boldSystemFontOfSize:17]];
    [self.lsPackBox.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    [self.lsPackBox initLabel:@"查看装箱单信息" withHit:@"快速查看与本退货单商品相关的装箱单信息" delegate:self];
    self.lsPackBox.lblVal.placeholder = @"";
    
    [self.baseTitle configTitle:@"基本信息" type:LSEditItemTitleTypeOpen rightClick:^(LSEditItemTitle *view) {
        [wself expandBaseInfo];
    }];
    
    [self.txtPaperNo initLabel:@"退货单号" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    self.txtPaperNo.txtVal.enabled = NO;
    self.txtPaperNo.txtVal.textColor = [UIColor darkGrayColor];
    
    if (self.paperType==CLIENT_RETURN_PAPER_TYPE) {
        [self.lsSupplier initLabel:@"退货机构/门店" withHit:nil isrequest:NO delegate:self];
    }else {
        [self.lsSupplier initLabel:@"供应商" withHit:nil isrequest:NO delegate:self];
    }
    [self.lsSupplier.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    
    [self.lsReceiveWarehouse initLabel:@"收货仓库" withHit:nil isrequest:YES delegate:self];
    [self.lsReceiveWarehouse.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    
    [self.lsDeliveWarehouse initLabel:@"发货仓库" withHit:nil isrequest:YES delegate:self];
    [self.lsDeliveWarehouse.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    
    [self.lsReturnType initLabel:@"退货类型" withHit:nil isrequest:YES delegate:self];
    
    [self.lsDate initLabel:@"退货日期" withHit:nil isrequest:YES delegate:self];
    
    [self.lsTime initLabel:@"退货时间" withHit:nil isrequest:YES delegate:self];
    
    [self.txtMemo initLabel:@"备注" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtMemo initMaxNum:100];
    [self.goodsTitle configTitle:@"退货商品" type:LSEditItemTitleTypeDown rightClick:^(LSEditItemTitle *view) {
        float cHeight = self.mainGrid.contentSize.height;
        float mHeight = self.mainGrid.bounds.size.height;
        if (cHeight>mHeight) {
            [wself.mainGrid setContentOffset:CGPointMake(0, cHeight - mHeight) animated:YES];
        }
    }];
    [self.lsMode initLabel:@"展示内容" withHit:nil delegate:self];
    
    self.lstHistoryInOrder.tag = HISTORY_IN;
    self.lsHistoryReturnOrder.tag = HISTORY;
    self.lsImPackBox.tag = IM_PACK_BOX;
    self.lsPackBox.tag = PACK_BOX;
    self.lsSupplier.tag = SUPPLIER;
    self.lsReceiveWarehouse.tag = RECEIVE_WAREHOUSE;
    self.lsDeliveWarehouse.tag = DELIVE_WAREHOUSE;
    self.lsReturnType.tag = RETURN_TYPE;
    self.lsDate.tag = DATE;
    self.lsTime.tag = TIME;
    self.lsMode.tag = MODE;
}

#pragma mark - UI变化通知
- (void)initNotification {
    [UIHelper initNotification:self.headerView event:Notification_UI_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_Change object:nil];
}

- (void)dataChange:(NSNotification*)notification {
    [self editTitle:[UIHelper currChange:self.headerView] act:_action];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 显示页面项(是否可编辑)
//显示基本信息项
- (void)showHeaderView:(NSInteger)action isEdit:(BOOL)isEdit
{
     [self.lstHistoryInOrder visibal:(action==ACTION_CONSTANTS_ADD)&&!self.isOpenPickBox];
    [self.lsHistoryReturnOrder visibal:(action==ACTION_CONSTANTS_ADD)&&!self.isOpenPickBox];
    [self.lsImPackBox visibal:(action==ACTION_CONSTANTS_ADD||self.status==4)&&self.isOpenPickBox];
    [self.lsPackBox visibal:(action==ACTION_CONSTANTS_EDIT&&self.status!=4)&&self.isOpenPickBox];
    [self.lsDeliveWarehouse visibal:(_paperType==RETURN_PAPER_TYPE&&self.isOrg)];
    [self.lsReceiveWarehouse visibal:(_paperType==CLIENT_RETURN_PAPER_TYPE||!self.isThirdSupplier)];
    [self.lsReturnType visibal:(self.shopMode==CLOTHESHOES_MODE&&!self.isThirdSupplier)];
    [self.lsSupplier editEnable:action==ACTION_CONSTANTS_ADD];
    [self.lsReceiveWarehouse editEnable:action==ACTION_CONSTANTS_ADD||self.status==4];
    [self.lsDeliveWarehouse editEnable:isEdit];
    [self.lsReturnType editEnable:isEdit&&_paperType!=CLIENT_RETURN_PAPER_TYPE];
    [self.lsDate editEnable:isEdit&&_paperType!=CLIENT_RETURN_PAPER_TYPE];
    [self.lsTime editEnable:isEdit&&_paperType!=CLIENT_RETURN_PAPER_TYPE];
    [self.txtMemo editEnabled:isEdit&&_paperType!=CLIENT_RETURN_PAPER_TYPE];
    if (!(isEdit&&_paperType!=CLIENT_RETURN_PAPER_TYPE)) {
        self.txtMemo.txtVal.placeholder = @"";
    }
    [self.lsMode visibal:(self.shopMode==SUPERMARKET_MODE&&((_paperType==RETURN_PAPER_TYPE&&self.status==4)||(_paperType==CLIENT_RETURN_PAPER_TYPE&&self.status==1)||action==ACTION_CONSTANTS_ADD))];
    [UIHelper refreshUI:self.headerView];
    self.mainGrid.tableHeaderView = self.headerView;
}
//显示底部按钮
- (void)showFooterView:(NSInteger)action isEdit:(BOOL)isEdit
{
    self.addView.hidden = self.isOpenPickBox?YES:!isEdit;
    self.crView.hidden = !(self.status==1&&self.paperType==CLIENT_RETURN_PAPER_TYPE&&isEdit&&self.goodList.count>0);
    self.comView.hidden = !(self.status==4&&self.isThirdSupplier&&self.goodList.count>0);
    
    self.subView.hidden = NO;
    self.subView.hidden = !((self.status == 4 && !self.isThirdSupplier && self.goodList.count > 0) || (self.status == 3 && self.paperType == RETURN_PAPER_TYPE));
    //补充： 客户退货单被拒绝，显示可"重新申请"按钮
    if (self.paperType == CLIENT_RETURN_PAPER_TYPE && self.status == 3) {
        self.subView.hidden = NO;
    }
    
    if (self.status == 4) {
        [self.subBtn setTitle:@"提交" forState:UIControlStateNormal];
    } else {
        [self.subBtn setTitle:@"重新申请" forState:UIControlStateNormal];
    }
    self.delView.hidden = !(self.status == 4);
    self.sumView.hidden = !(self.goodList.count > 0);
    self.heightConstraintAddView.constant = self.addView.hidden ? 0 : 48;
    self.heightConatraintCrView.constant = self.crView.hidden ? 0 : 64;
    self.heightConatraintSubView.constant = self.subView.hidden ? 0 : 64;
    self.heightConstraintDelView.constant = self.delView.hidden ? 0 : 64;
    self.heightConatraintComView.constant = self.comView.hidden ? 0 : 64;
    [self.footerView layoutIfNeeded];

    [UIHelper refreshUI:self.footerView];
    self.mainGrid.tableFooterView = self.footerView;
}
#pragma mark - 加载数据
- (void)loadData
{
    [self showHeaderView:_action isEdit:_isEdit];
    [self showFooterView:_action isEdit:_isEdit];
    [self expandBaseInfo];
    [self initNotification];
    if (_action==ACTION_CONSTANTS_ADD&&[NSString isBlank:_paperId]) {
        self.flg = ACTION_CONSTANTS_ADD;
//        self.titleBox.lblTitle.text = @"添加";
        [self configTitle:@"添加退货单"];
        [self clearDo];
    }else{
        self.flg = ACTION_CONSTANTS_EDIT;
        [self selectReturnPaperDetailById:_paperId isNeedDel:nil];
    }
}

//添加模式设置页面默认值
- (void)clearDo
{
    if (self.shopType==3) {
        self.shopId = [[Platform Instance] getkey:ORG_ID];
        self.shopName = [[Platform Instance] getkey:ORG_NAME];
    }else{
        self.shopId = [[Platform Instance] getkey:SHOP_ID];
        self.shopName = [[Platform Instance] getkey:SHOP_NAME];
    }
    self.isFirstAdd = YES;
    NSDate* date = [NSDate date];
    NSString* dateStr = [DateUtils formateDate2:date];
    NSString* timeStr = [DateUtils formateChineseTime:date];
    [self.lsSupplier initData:@"请选择" withVal:nil];
    [self.lsReceiveWarehouse initData:@"请选择" withVal:nil];
    [self.lsDeliveWarehouse initData:@"请选择" withVal:nil];
    [self.lsReturnType initData:@"请选择" withVal:nil];
    [self.lsDate initData:dateStr withVal:dateStr];
    [self.lsTime initData:timeStr withVal:timeStr];
    [self.txtMemo initData:nil];
    [self.lsMode initData:kCountName withVal:kCountVal];
    [self.mainGrid reloadData];
    [self caculateAmount];
}

#pragma mark - 查询退货单详情 isNeedDel

/**
 查询退货单详情

 @param paperId 单据id
 @param isNeedDel 是否需要查询收货仓库和发货仓库删除情况 @“1” 需要查询传@"1" 从历史单据导入需要查询
 */
- (void)selectReturnPaperDetailById:(NSString *)paperId isNeedDel:(NSString *)isNeedDel
{
    __weak typeof(self) weakSelf = self;
    [_logisticService selectReturnPaperDetail:paperId type:self.type isNeedDel:isNeedDel completionHandler:^(id json) {
        if (weakSelf.action==ACTION_CONSTANTS_EDIT) {
            [self configTitle:[json objectForKey:@"returnGoodsNo"]];
            [weakSelf.txtPaperNo initData:[json objectForKey:@"returnGoodsNo"]];
            weakSelf.lastVer = [[json objectForKey:@"lastVer"] longValue];
            [weakSelf.lsHistoryReturnOrder visibal:NO];
            [weakSelf.lstHistoryInOrder visibal:NO];
            [weakSelf.txtPaperNo visibal:YES];
            [UIHelper refreshUI:weakSelf.headerView];
            weakSelf.mainGrid.tableHeaderView = weakSelf.headerView;
        }
        weakSelf.supplyId = [json objectForKey:@"supplyId"];
        weakSelf.supplyName = [json objectForKey:@"supplyName"];
        weakSelf.shopId = [json objectForKey:@"shopId"];
        weakSelf.shopName = [json objectForKey:@"shopName"];
        if (weakSelf.paperType==CLIENT_RETURN_PAPER_TYPE) {
            [weakSelf.lsSupplier initData:[json objectForKey:@"shopName"] withVal:[json objectForKey:@"shopId"]];
        }else{
            [weakSelf.lsSupplier initData:[json objectForKey:@"supplyName"] withVal:[json objectForKey:@"supplyId"]];
        }
        weakSelf.isThirdSupplier = [[json objectForKey:@"thirdSupplier"] isEqualToString:@"1"];
        
        if ([NSString isBlank:[json objectForKey:@"inWarehouseId"]]) {
            [weakSelf.lsReceiveWarehouse initData:@"请选择" withVal:nil];
        }else{
            [weakSelf.lsReceiveWarehouse initData:[json objectForKey:@"inWarehouseName"] withVal:[json objectForKey:@"inWarehouseId"]];
        }
        
        if ([NSString isBlank:[json objectForKey:@"outWarehouseId"]]) {
            [weakSelf.lsDeliveWarehouse initData:@"请选择" withVal:nil];
        }else{
            [weakSelf.lsDeliveWarehouse initData:[json objectForKey:@"outWarehouseName"] withVal:[json objectForKey:@"outWarehouseId"]];
        }
        
        NSString *val = [ObjectUtil isNotNull:[json objectForKey:@"returnTypeVal"]]?[[json objectForKey:@"returnTypeVal"] stringValue]:nil;
        if ([ObjectUtil isNull:[json objectForKey:@"returnTypeVal"]] || [ObjectUtil isNull:[json objectForKey:@"returnTypeName"]]) {
            [self.lsReturnType initData:@"请选择" withVal:nil];
        }else{
            [self.lsReturnType initData:[json objectForKey:@"returnTypeName"] withVal:val];
        }
        NSString* dateTime = [DateUtils formateTime:[[json objectForKey:@"sendEndTime"] longLongValue]];
        NSString* date = [[dateTime componentsSeparatedByString:@" "] objectAtIndex:0];
        NSString* time = [[dateTime componentsSeparatedByString:@" "] objectAtIndex:1];
        if (![isNeedDel isEqualToString:@"1"]) {//不是从历史单据导入
            [weakSelf.lsDate initData:date withVal:date];
            [weakSelf.lsTime initData:time withVal:time];
        }
        [weakSelf.txtMemo initData:[json objectForKey:@"memo"]];
        weakSelf.goodList = [PaperDetailVo converToArr:[json objectForKey:@"returnGoodsDetailList"] paperType:weakSelf.paperType];
        if (weakSelf.isHistory) {
            //商超版历史单导入，修改商品操作状态
            for (PaperDetailVo *detailVo in weakSelf.goodList) {
                detailVo.operateType = @"add";
            }
        }
        [weakSelf.lsMode initData:kCountName withVal:kCountVal];
        [weakSelf.mainGrid reloadData];
        [weakSelf caculateAmount];
        [weakSelf showHeaderView:weakSelf.action isEdit:weakSelf.isEdit];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}

#pragma mark - 从历史入库单导入
- (void)onHistoryInOrderClick {
    HistoryPaperListView *vc = [[HistoryPaperListView alloc] init];
    __weak typeof(self) wself = self;
    if (self.shopMode==CLOTHESHOES_MODE) {
//        //服鞋版历史导入
//        [vc loadPaperId:self.historyInPaperId withType:HistoryPaperListViewTypeHistoryFromInToReturn callBack:^(NSString *paperId, NSString *recordType, id json) {
//            wself.historyPaperId = nil;
//            NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
//            [param setValue:paperId forKey:@"historyId"];
//            [param setValue:@"1" forKey:@"isNeedDel"];
//            //从历史入库单导入生成退货单
//            NSString *url = @"returnGoods/importReturnGoodsPurchase";
//            [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
//                wself.historyPaperId = paperId;
//                wself.action = ACTION_CONSTANTS_EDIT;
//                wself.isFirstAdd = NO;
//                wself.status = 4;
//                wself.paperId = [json objectForKey:@"returnGoodsId"];
//                [wself.lsSupplier editEnable:NO];
//                [wself selectReturnPaperDetailById:wself.paperId isNeedDel:nil];
//
//            } errorHandler:^(id json) {
//                [LSAlertHelper showAlert:json];
//            }];
//        }];
        [vc loadPaperId:self.historyInPaperId withType:HistoryPaperListViewTypeHistoryFromInToReturn callBack:^(NSString *paperId, NSString *recordType, id json) {
            wself.historyPaperId = nil;
            wself.historyPaperId = paperId;
            wself.action = ACTION_CONSTANTS_EDIT;
            wself.isFirstAdd = NO;
            wself.status = 4;
            wself.paperId = [json objectForKey:@"returnGoodsId"];
            [wself.lsSupplier editEnable:NO];
            [wself selectReturnPaperDetailById:wself.paperId isNeedDel:nil];        }];

    } else {
        //商超版历史导入
        [vc loadPaperId:wself.historyInPaperId withType:HistoryPaperListViewTypeHistoryFromInToReturn callBack:^(NSString *paperId, NSString *recordType, id json) {
            wself.historyPaperId = nil;
            wself.recordType = recordType;
            wself.isHistory = YES;
            wself.historyInPaperId = paperId;
            [wself selectPurchasePaperDetailById:paperId];
        }];
    }
    [self pushViewController:vc];
}
#pragma mark - 查询收货单详情
- (void)selectPurchasePaperDetailById:(NSString*)paperId
{
    __weak typeof(self) wself = self;
    [_logisticService selectPurchasePaperDetail:paperId recordType:self.recordType isNeedDel:@"1" completionHandler:^(id json) {
        if (wself.action==ACTION_CONSTANTS_EDIT) {
            [self configTitle:[json objectForKey:@"returnGoodsNo"]];
            [wself.txtPaperNo initData:[json objectForKey:@"returnGoodsNo"]];
            wself.lastVer = [[json objectForKey:@"lastVer"] longValue];
            [wself.lsHistoryReturnOrder visibal:NO];
            [wself.lstHistoryInOrder visibal:NO];
            [wself.txtPaperNo visibal:YES];
            [UIHelper refreshUI:wself.headerView];
            wself.mainGrid.tableHeaderView = wself.headerView;
        }
        wself.supplyId = [json objectForKey:@"supplyId"];
        wself.supplyName = [json objectForKey:@"supplyName"];
//        wself.shopId = [json objectForKey:@"shopId"];
//        wself.shopName = [json objectForKey:@"shopName"];
        wself.shopId = [[Platform Instance] getkey:SHOP_ID];
        wself.shopName = [[Platform Instance] getkey:SHOP_NAME];
       [wself.lsSupplier initData:wself.supplyName withVal:wself.supplyId];
       wself.isThirdSupplier = [[json objectForKey:@"thirdSupplier"] isEqualToString:@"1"];
        
        //发货仓库
        if ([NSString isBlank:[json objectForKey:@"inWareHouseName"]]) {
            [wself.lsDeliveWarehouse initData:@"请选择" withVal:nil];
        }else{
            [wself.lsDeliveWarehouse initData:[json objectForKey:@"inWareHouseName"] withVal:[json objectForKey:@"inWareHouseId"]];
        }
        //收货仓库
        if ([NSString isBlank:[json objectForKey:@"outWareHouseName"]]) {
            [wself.lsReceiveWarehouse initData:@"请选择" withVal:nil];
        }else{
            [wself.lsReceiveWarehouse initData:[json objectForKey:@"outWareHouseName"] withVal:[json objectForKey:@"outWareHouseId"]];
        }
        
        NSString *val = [ObjectUtil isNotNull:[json objectForKey:@"returnTypeVal"]]?[[json objectForKey:@"returnTypeVal"] stringValue]:nil;
        if ([ObjectUtil isNull:[json objectForKey:@"returnTypeVal"]] || [ObjectUtil isNull:[json objectForKey:@"returnTypeName"]]) {
            [wself.lsReturnType initData:@"请选择" withVal:nil];
        }else{
            [wself.lsReturnType initData:[json objectForKey:@"returnTypeName"] withVal:val];
        }
//        NSString* dateTime = [DateUtils formateTime:[[json objectForKey:@"sendEndTime"] longLongValue]];
//        NSString* date = [[dateTime componentsSeparatedByString:@" "] objectAtIndex:0];
//        NSString* time = [[dateTime componentsSeparatedByString:@" "] objectAtIndex:1];
//        [wself.lsDate initData:date withVal:date];
//        [wself.lsTime initData:time withVal:time];
//        [wself.txtMemo initData:[json objectForKey:@"memo"]];
        wself.goodList = [PaperDetailVo converToArr:[json objectForKey:@"stockInDetailList"] paperType:PURCHASE_PAPER_TYPE];
        if (wself.isHistory) {
            //商超版历史单导入，修改商品操作状态
            for (PaperDetailVo *detailVo in wself.goodList) {
                detailVo.operateType = @"add";
            }
        }
        [wself.lsMode initData:kCountName withVal:kCountVal];
        [wself.mainGrid reloadData];
        [wself caculateAmount];
        [wself showHeaderView:wself.action isEdit:wself.isEdit];
        } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}



#pragma mark - IEditItemListEvent协议
- (void)onItemListClick:(LSEditItemList *)obj
{
    NSDate* date = nil;
    if (obj == self.lstHistoryInOrder) {//从历史入库单导入
        [self onHistoryInOrderClick];
    } else if (obj.tag==HISTORY) {
        HistoryPaperListView* historyPaperListView = [[HistoryPaperListView alloc] init];
        __weak typeof(self) weakSelf = self;
        if (self.shopMode==CLOTHESHOES_MODE) {
            //服鞋历史导入
//            [historyPaperListView loadPaperId:self.historyPaperId withType:HistoryPaperListViewTypeHistoryReturn callBack:^(NSString *paperId, NSString *paperType, id json) {
//                weakSelf.historyInPaperId = nil;
//                [weakSelf.logisticService importReturnPaperById:paperId completionHandler:^(id json) {
//                    weakSelf.historyPaperId = paperId;
//                    weakSelf.action = ACTION_CONSTANTS_EDIT;
//                    weakSelf.isFirstAdd = NO;
//                    weakSelf.status = 4;
//                    weakSelf.paperId = [json objectForKey:@"returnGoodsId"];
//                    [weakSelf.lsSupplier editEnable:NO];
//                    [weakSelf selectReturnPaperDetailById:weakSelf.paperId isNeedDel:nil];
//                } errorHandler:^(id json) {
//                    [LSAlertHelper showAlert:json];
//                }];
//            }];
            [historyPaperListView loadPaperId:self.historyPaperId withType:HistoryPaperListViewTypeHistoryReturn callBack:^(NSString *paperId, NSString *paperType, id json) {
                weakSelf.historyInPaperId = nil;
                weakSelf.historyPaperId = paperId;
                weakSelf.action = ACTION_CONSTANTS_EDIT;
                weakSelf.isFirstAdd = NO;
                weakSelf.status = 4;
                weakSelf.paperId = [json objectForKey:@"returnGoodsId"];
                [weakSelf.lsSupplier editEnable:NO];
                [weakSelf selectReturnPaperDetailById:weakSelf.paperId isNeedDel:nil];

            }];

        }else{
            //商超历史导入
            [historyPaperListView loadPaperId:self.historyPaperId withType:HistoryPaperListViewTypeHistoryReturn callBack:^(NSString *paperId ,NSString *paperType, id json) {
                weakSelf.historyInPaperId = nil;
                weakSelf.historyPaperId = paperId;
                weakSelf.isHistory = YES;
                [weakSelf selectReturnPaperDetailById:paperId isNeedDel:@"1"];
            }];
        }
        [self.navigationController pushViewController:historyPaperListView animated:NO];
        historyPaperListView = nil;
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }
    if (obj.tag==IM_PACK_BOX) {
        //装箱单导入
        if (self.action==ACTION_CONSTANTS_ADD) {
            if (![self isValide]) {
                return;
            }
            [self saveForAddPaper:@"firstadd" message:@"正在保存..."];
        }else{
            [self importPackBox];
        }
    }
    
    if (obj.tag==PACK_BOX) {
        //查看装箱单信息
        [self importPackBox];
    }

    if (obj.tag==SUPPLIER) {
        //选择供应商
        SelectSupplierListView* selectSupplyListView = [[SelectSupplierListView alloc] init];
       NSString *supplyFlg = ([[[Platform Instance] getkey:PARENT_ID] isEqualToString:@"0"])?@"third":@"self";
        if (![[[Platform Instance] getkey:PARENT_ID] isEqualToString:@"0"]) {
             selectSupplyListView.isCondition = YES;
        }
        __weak typeof(self) weakSelf = self;
        [selectSupplyListView loadDataBySupplyId:[obj getStrVal] supplyFlag:supplyFlg handler:^(id<INameValue> supplier) {
            if (supplier) {
                weakSelf.isThirdSupplier = [[supplier obtainItemType] isEqualToString:@"0"];
                if (![[weakSelf.lsSupplier getStrVal] isEqualToString:[supplier obtainItemId]]) {
                    [weakSelf.goodList removeAllObjects];
                    [weakSelf.mainGrid reloadData];
                    [weakSelf caculateAmount];
                    [weakSelf.lsReceiveWarehouse changeData:@"请选择" withVal:nil];
                }
                weakSelf.supplyId = [supplier obtainItemId];
                weakSelf.supplyName = [supplier obtainItemName];
                [weakSelf.lsSupplier changeData:[supplier obtainItemName] withVal:[supplier obtainItemId]];
                [weakSelf showHeaderView:weakSelf.action isEdit:weakSelf.isEdit];
            }
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
        [self.navigationController pushViewController:selectSupplyListView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        selectSupplyListView = nil;
    }
    
    if (obj.tag==RECEIVE_WAREHOUSE) {
        //收货仓库
        SelectStoreListView *storeView = [[SelectStoreListView alloc] init];
        NSString *orgId = (_paperType==RETURN_PAPER_TYPE)?[self.lsSupplier getStrVal]:[[Platform Instance] getkey:ORG_ID];
        __weak typeof(self) wself = self;
        [storeView loadData:[obj getStrVal] withOrgId:orgId withIsSelf:YES callBack:^(id<INameCode> item) {
            if (item) {
                [obj changeData:[item obtainItemName] withVal:[item obtainItemId]];
            }
            [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [wself.navigationController popToViewController:wself animated:NO];
        }];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [self.navigationController pushViewController:storeView animated:NO];
        storeView = nil;
    }
    
    if (obj.tag==DELIVE_WAREHOUSE) {
        //发货仓库
        SelectStoreListView *storeView = [[SelectStoreListView alloc] init];
        NSString *orgId = (_paperType==RETURN_PAPER_TYPE)?[[Platform Instance] getkey:ORG_ID]:[self.lsSupplier getStrVal];
        __weak typeof(self) wself = self;
        [storeView loadData:[obj getStrVal] withOrgId:orgId withIsSelf:YES callBack:^(id<INameCode> item) {
            if (item) {
                [obj changeData:[item obtainItemName] withVal:[item obtainItemId]];
            }
            [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [wself.navigationController popToViewController:wself animated:NO];
        }];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        [self.navigationController pushViewController:storeView animated:NO];
        storeView = nil;
    }
    
    if (obj.tag==RETURN_TYPE) {
        if (self.typeList!=nil&&self.typeList.count>0) {
            [OptionPickerBox initData:self.typeList itemId:[obj getStrVal]];
            [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        }else{
            __weak typeof(self) wself = self;
            [self.logisticService selectReturnTypeList:^(id json) {
                wself.typeList = [ReturnTypeVo converToArr:[json objectForKey:@"returnTypeList"]];
                [OptionPickerBox initData:wself.typeList itemId:[obj getStrVal]];
                [OptionPickerBox show:obj.lblName.text client:wself event:obj.tag];
            } errorHandler:^(id json) {
                [LSAlertHelper showAlert:json];
            }];
        }
    }
    
    if (obj.tag==DATE) {
        //退货日期
        date = [DateUtils parseDateTime4:obj.lblVal.text];
        [DatePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
    }
    if (obj.tag==TIME) {
        //退货时间
        date=[DateUtils parseDateTime6:[obj getStrVal]];
        [TimePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
    }
    if (obj.tag==MODE) {
        //商品展示模式
        NSMutableArray* vos = [NSMutableArray arrayWithCapacity:2];
        NameItemVO *item=[[NameItemVO alloc] initWithVal:kCountName andId:kCountVal];
        [vos addObject:item];
        if (self.isEditPrice) {
            item=[[NameItemVO alloc] initWithVal:kPriceName andId:kPriceVal];
            [vos addObject:item];
            
            item = [[NameItemVO alloc] initWithVal:kAmountName andId:kAmountVal];
            [vos addObject:item];
        }
        [OptionPickerBox initData:vos itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
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
    
    if (eventType==MODE) {
        [self.lsMode initData:[vo obtainItemName] withVal:[vo obtainItemId]];
        if ([[self.lsMode getStrVal] isEqualToString:kCountVal]) {
            self.mode = PaperGoodsCellTypeCount;
        } else if ([[self.lsMode getStrVal] isEqualToString:kPriceVal]) {
            self.mode = PaperGoodsCellTypePrice;
        } else if ([[self.lsMode getStrVal] isEqualToString:kAmountVal]) {
            self.mode = PaperGoodsCellTypeAmount;
        }
        [self.mainGrid reloadData];
    }else if (eventType==RETURN_TYPE) {
        [self.lsReturnType changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
    }
    
    return YES;
}


- (void)expandBaseInfo
{
    [self.txtPaperNo visibal:(_action==ACTION_CONSTANTS_EDIT)&&!_isFold];
    [self.lsSupplier visibal:(!_isFold)];
    [self.lsReceiveWarehouse visibal:(!_isFold&&(_paperType==CLIENT_RETURN_PAPER_TYPE||!self.isThirdSupplier))];
    [self.lsDeliveWarehouse visibal:(!_isFold&&_paperType==RETURN_PAPER_TYPE&&self.isOrg)];
    [self.lsReturnType visibal:(!_isFold&&self.shopMode==CLOTHESHOES_MODE&&!self.isThirdSupplier)];
    [self.lsDate visibal:!_isFold];
    [self.lsTime visibal:!_isFold];
    [self.txtMemo visibal:!_isFold];
    _isFold= !_isFold;
    [UIHelper refreshUI:self.headerView];
    self.mainGrid.tableHeaderView = self.headerView;
}


//移动到页面底部
- (void)onTitleMoveToBottomClick:(NSInteger)event
{
    float cHeight = self.mainGrid.contentSize.height;
    float mHeight = self.mainGrid.bounds.size.height;
    if (cHeight>mHeight) {
        [self.mainGrid setContentOffset:CGPointMake(0, cHeight - mHeight) animated:YES];
    }
}

#pragma mark - 计算合计
- (void)caculateAmount
{
    NSInteger num = self.goodList.count;
    double amount = 0.00;
    double sum = 0.00;
    BOOL type = NO;
    if (self.shopMode==SUPERMARKET_MODE) {
        for (PaperDetailVo* detailVo in self.goodList) {
            amount+=self.isSearchPrice? detailVo.goodsTotalPrice:detailVo.retailPrice * detailVo.goodsSum;
            sum+=detailVo.goodsSum;
            if (detailVo.type==4) {
                type = YES;
            }
        }
    }else{
        for (PaperDetailVo* detailVo in self.goodList) {
            amount+= self.isSearchPrice ? detailVo.goodsReturnTotalPrice : detailVo.goodsHangTagTotalPrice;
            sum+=detailVo.goodsSum;
        }
    }

    //使用富文本显示合计后的文字
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"合计 "];
    NSString* str = [NSString stringWithFormat:@"%ld 项, ",(long)num];
    NSMutableAttributedString *amoutAttr = [[NSMutableAttributedString alloc] initWithString:str];
    [amoutAttr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getRedColor] range:NSMakeRange(0,str.length-4)];
    [attrString appendAttributedString:amoutAttr];
    
    NSString *sumStr = type?[NSString stringWithFormat:@"%.3f 件 ",sum]:[NSString stringWithFormat:@"%.0f 件 ",sum];
    NSMutableAttributedString *sumAttr = [[NSMutableAttributedString alloc] initWithString:sumStr];
    [sumAttr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getRedColor] range:NSMakeRange(0,sumStr.length-3)];
    [attrString appendAttributedString:sumAttr];
    
    NSString* priceStr = [NSString stringWithFormat:@"¥%.2f ",amount];
    NSMutableAttributedString *priceAttr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [priceAttr addAttribute:NSForegroundColorAttributeName value:[ColorHelper getRedColor] range:NSMakeRange(0,priceStr.length-1)];
    
    [priceAttr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:16.0] range:NSMakeRange(1, priceStr.length-1)];
    [attrString appendAttributedString:priceAttr];
    _lblAmount.attributedText = attrString;
    amoutAttr = nil;
    sumAttr = nil;
    priceAttr = nil;
    attrString = nil;
    
    [self showFooterView:self.action isEdit:self.isEdit];
}

#pragma mark - 改变导航按钮
- (void)changeNavigateUI
{
    __block BOOL flag =NO;
    [self.goodList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PaperDetailVo* vo = (PaperDetailVo*)obj;
        if (vo.changeFlag==1||[vo.operateType isEqualToString:@"add"]) {
            flag = YES;
            *stop = YES;
        }
    }];
    [self editTitle:([UIHelper currChange:self.headerView]||flag||self.delGoodsList.count>0) act:_action];
    [self caculateAmount];
    
}

#pragma mark - UITableview 商品列表
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_shopMode==CLOTHESHOES_MODE) {
        //服鞋版cell
       return [self tableView:tableView styleCellForRowAtIndexPath:indexPath];
    }else{
        //商超版cell
        static NSString* paperGoodsCellId = @"PaperGoodsCell";
        PaperGoodsCell* cell = [tableView dequeueReusableCellWithIdentifier:paperGoodsCellId];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"PaperGoodsCell" owner:nil options:nil].lastObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell setNeedsDisplay];
        return cell;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView styleCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* shoesClothingCellId = @"ShoesClothingCell";
    ShoesClothingCell* cell = [tableView dequeueReusableCellWithIdentifier:shoesClothingCellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ShoesClothingCell" bundle:nil] forCellReuseIdentifier:shoesClothingCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:shoesClothingCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.goodList.count>0&&indexPath.row<self.goodList.count) {
        PaperDetailVo*  goodsVo = [self.goodList objectAtIndex:indexPath.row];
        if (_shopMode==CLOTHESHOES_MODE) {
            //服鞋版显示内容
            ShoesClothingCell* detailItem = (ShoesClothingCell*)cell;
            detailItem.lblName.text = goodsVo.goodsName;
            detailItem.lblStyleNo.text = [NSString stringWithFormat:@"款号：%@",goodsVo.styleCode];
            detailItem.lblStyleCount.text = [NSString stringWithFormat:@"x%.0f",goodsVo.goodsSum];
            detailItem.lblTotalMoney.text = [NSString stringWithFormat:@"￥%.2f", self.isSearchPrice ? goodsVo.goodsReturnTotalPrice : goodsVo.goodsHangTagTotalPrice];
            [detailItem showMarkRed:([ObjectUtil isNotNull:goodsVo.styleCanReturn] && [goodsVo.styleCanReturn integerValue] < goodsVo.goodsSum)];
            
        }else{
            //商超版显示内容
            PaperGoodsCell* detailItem = (PaperGoodsCell*)cell;
            detailItem.type = self.paperType;
            [detailItem initDelegate:self count:goodsVo.oldGoodsSum price:goodsVo.oldGoodsPrice];
            [detailItem loadItem:goodsVo mode:_mode isEdit:_isEdit status:0];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.paperDetailVo = [self.goodList objectAtIndex:indexPath.row];
    if (_shopMode==CLOTHESHOES_MODE) {
        //服鞋版款式详情
        [self showSelectStyleView:ACTION_CONSTANTS_EDIT];
    }else{
        //商超版商品详情
        GoodsDetailEditView* goodsDetailView = [[GoodsDetailEditView alloc] init];
        goodsDetailView.isThirdSupplier = self.isThirdSupplier;
        __weak typeof(self) weakSelf = self;
        [goodsDetailView showGoodsDetail:self.paperDetailVo paperType:_paperType isEdit:_isEdit callBack:^(NSInteger action) {
            if (ACTION_CONSTANTS_DEL==action) {
                //删除商品
                if (![weakSelf.paperDetailVo.operateType isEqualToString:@"add"]) {
                    weakSelf.paperDetailVo.operateType = @"del";
                    [weakSelf.delGoodsList addObject:weakSelf.paperDetailVo];
                }
                [weakSelf.goodList removeObject:weakSelf.paperDetailVo];
            }
            [weakSelf.mainGrid reloadData];
            [weakSelf changeNavigateUI];
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
        [self.navigationController pushViewController:goodsDetailView animated:NO];
        goodsDetailView = nil;
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }
}

#pragma mark - 添加(保存单据基础信息)
// 添加商品
- (IBAction)addBtnClick:(id)sender
{
    if (self.isFirstAdd) {
        //第一次添加，保存单据信息
        if (![self isValide]) {
            return;
        }
        [self saveForAddPaper:@"firstadd" message:@"正在保存..."];
        
    }else{
        if (self.shopMode==CLOTHESHOES_MODE) {
            [self showSelectStyleView:ACTION_CONSTANTS_ADD];
        }else{
            [self showSelectGoodsView];
        }
        
    }
}

#pragma mark - 第一次添加保存
- (void)saveForAddPaper:(NSString *)operateType message:(NSString *)message
{
    NSMutableDictionary* param = [self obtainParams];
    [param setValue:operateType forKey:@"operateType"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"returnGoods/save"];
    __weak typeof(self) weakSelf = self;
    [_logisticService operatePaperDetail:param withUrl:url completionHandler:^(id json) {
        [UIHelper clearChange:weakSelf.headerView];
        weakSelf.isFirstAdd = NO;
        weakSelf.token = nil;
        weakSelf.action = ACTION_CONSTANTS_EDIT;
        [weakSelf.lsHistoryReturnOrder visibal:NO];
        [weakSelf.lstHistoryInOrder visibal:NO];
        [weakSelf.txtPaperNo visibal:YES];
        [weakSelf configTitle:[json objectForKey:@"returnGoodsNo"]];
        [weakSelf.txtPaperNo initData:[json objectForKey:@"returnGoodsNo"]];
        [weakSelf.lsSupplier editEnable:NO];
        weakSelf.paperId = [json objectForKey:@"returnGoodsId"];
        weakSelf.lastVer = [[json objectForKey:@"lastVer"] longValue];
        weakSelf.status = 4;
        [UIHelper refreshUI:weakSelf.headerView];
        weakSelf.mainGrid.tableHeaderView = weakSelf.headerView;
        if (weakSelf.shopMode==CLOTHESHOES_MODE) {
            if (weakSelf.isOpenPickBox) {
                weakSelf.action = ACTION_CONSTANTS_EDIT;
                [weakSelf showHeaderView:weakSelf.action isEdit:weakSelf.isEdit];
                [weakSelf importPackBox];
            }else{
                [weakSelf showSelectStyleView:ACTION_CONSTANTS_ADD];
            }
        }else{
            [weakSelf showSelectGoodsView];
        }
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    } withMessage:message];
    
}

//装箱单导入
- (void)importPackBox
{
    ReturnPackBoxListView* boxListView = [[ReturnPackBoxListView alloc] init];
    __weak typeof(self) weakSelf = self;
    [boxListView loadDataWithEdit:self.isEdit paperType:self.paperType WithPaperId:self.paperId callBack:^{
        [weakSelf selectReturnPaperDetailById:weakSelf.paperId isNeedDel:nil];
    }];
    [self.navigationController pushViewController:boxListView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

//商超模式
- (void)showSelectGoodsView
{
    if (self.goodList.count==200) {
        [LSAlertHelper showAlert:@"最多只能添加200种商品!"];
        return ;
    }
    GoodsBatchChoiceView1 *goodsView = [[GoodsBatchChoiceView1 alloc] init];
    goodsView.supplyId = [self.lsSupplier getStrVal];
    goodsView.isReturn = @"1";
    if ([[Platform Instance] getShopMode] == 3) {
        goodsView.shopName = [[Platform Instance] getkey:ORG_NAME];
    }
    __weak typeof(self) weakSelf = self;
    [goodsView loaddatas:self.shopId callBack:^(NSMutableArray *goodsList) {
        if (goodsList.count>0) {
            //有选择商品
            NSMutableArray *addArr = [NSMutableArray arrayWithCapacity:goodsList.count];
            for (GoodsVo* vo in goodsList) {
                BOOL flag = NO;
                BOOL isHave = NO;
                if (weakSelf.delGoodsList.count>0) {
                    //取出删除列表中的商品
                    for (PaperDetailVo* detailVo in weakSelf.delGoodsList) {
                        if ([vo.goodsId isEqualToString:detailVo.goodsId]) {
                            detailVo.operateType = @"edit";
                            detailVo.goodsSum = 1;
                            detailVo.oldGoodsSum = 1;
                            flag = YES;
                            [addArr addObject:detailVo];
                            [weakSelf.delGoodsList removeObject:detailVo];
                            break;
                        }
                    }
                }
                
                if (weakSelf.goodList.count>0) {
                    //去除列表中已经存在的商品
                    for (PaperDetailVo* detailVo in weakSelf.goodList) {
                        if ([vo.goodsId isEqualToString:detailVo.goodsId]) {
                            isHave = YES;
                            break;
                        }
                    }
                }
                
                if (!flag&&!isHave) {
                    //当前列表不存在的商品，进行添加
                    PaperDetailVo* detailVo = [[PaperDetailVo alloc] init];
                    detailVo.goodsId = vo.goodsId;
                    detailVo.goodsName = vo.goodsName;
                    detailVo.goodsBarcode = vo.barCode;
                    detailVo.goodsPrice = vo.latestReturnPrice;
//                    if ([[Platform Instance] getShopMode] == 1) {
//                         detailVo.goodsPrice = vo.latestReturnPrice;
//                    } else {
//                        detailVo.goodsPrice = vo.purchasePrice;
//                    }
                    
                    detailVo.retailPrice = vo.retailPrice;
                    detailVo.goodsSum = 1;
                    detailVo.goodsTotalPrice = vo.purchasePrice;
                    detailVo.goodsRetailTotalPrice = vo.retailPrice;
                    detailVo.oldGoodsSum = 1;
                    detailVo.oldGoodsPrice = detailVo.goodsPrice;
                    detailVo.operateType = @"add";
                    detailVo.changeFlag = 0;
                    detailVo.type = vo.type;
                    detailVo.goodsStatus = vo.upDownStatus;
                    detailVo.filePath = vo.filePath;
                    [addArr addObject:detailVo];
                }
            }
            
            if ((weakSelf.goodList.count+addArr.count) > 200) {
                //选择的商品总数超过200件,放回原删除的商品
                for (PaperDetailVo* detailVo in addArr) {
                    if ([detailVo.operateType isEqualToString:@"del"]) {
                        [weakSelf.delGoodsList addObject:detailVo];
                    }
                }
                [LSAlertHelper showAlert:@"最多只能添加200种商品!"];
                return ;
            }
            
            if (addArr.count>0) {
                //未超过200件，将原删除的商品重置
                for (PaperDetailVo* detailVo in addArr) {
                    if ([detailVo.operateType isEqualToString:@"del"]) {
                        detailVo.operateType = @"edit";
                        detailVo.goodsSum = 1;
                        detailVo.oldGoodsSum = 1;
                    }
                }
                [weakSelf.goodList addObjectsFromArray:addArr];
            }
            
            [weakSelf.mainGrid reloadData];
            [weakSelf caculateAmount];
            [weakSelf changeNavigateUI];
        }
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
    }];
    [self.navigationController pushViewController:goodsView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
    goodsView = nil;

}

//服鞋模式
- (void)showSelectStyleView:(NSInteger)action
{
    if (self.goodList.count==200) {
        [LSAlertHelper showAlert:@"最多只能添加200款!"];
        return ;
    }
    CloShoesEditView *cloShoesEditView = [[CloShoesEditView alloc] init];
    cloShoesEditView.isOpenPackBox = self.isOpenPickBox;
    cloShoesEditView.shopId = self.shopId;
    cloShoesEditView.isThirdSupply = self.isThirdSupplier;
    __weak typeof(self) weakSelf = self;
    [cloShoesEditView loadDataWithCode:self.paperDetailVo.styleCode withParam:[self obtainParams] withSourceId:self.paperId withAction:action withType:self.paperType withEdit:self.isEdit callBack:^{
        [weakSelf selectReturnPaperDetailById:weakSelf.paperId isNeedDel:nil];
    }];
    [self.navigationController pushViewController:cloShoesEditView animated:NO];
    [XHAnimalUtil animalPush:self.navigationController action:action];
    cloShoesEditView = nil;
}

#pragma mark - 服鞋 验证退货量
- (void)checkReturnGoods:(NSInteger)tag
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:4];
    [param setValue:[self.lsReturnType getStrVal] forKey:@"val"];
    [param setValue:self.supplyId forKey:@"supplyId"];
    [param setValue:self.shopId forKey:@"shopId"];
    [param setValue:[PaperDetailVo converToDicArr:[self obtainGoodsList] paperType:self.paperType] forKey:@"returnGoodsDetailVoList"];
    __weak typeof(self) wself = self;
    [self.logisticService checkReturnGoods:param completionHandler:^(id json) {
        BOOL isSuccess = [[json objectForKey:@"isSuccess"] boolValue];
        if (!isSuccess) {
            NSString *styleId = [json objectForKey:@"styleId"];
            NSNumber *styleCanReturn = [json objectForKey:@"count"];
            for (PaperDetailVo *vo in wself.goodList) {
                if ([styleId isEqualToString:vo.styleId]) {
                    vo.styleCanReturn = styleCanReturn;
                    [LSAlertHelper showAlert:[NSString stringWithFormat:@"款式[%@]当前可退量为%@，现已超出请修改!",vo.goodsName,styleCanReturn]];
                    break;
                }
            }
            [wself.mainGrid reloadData];
        }else{
            [wself updateReturnPaper:tag];
        }
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}


#pragma mark - 单据操作
// 提交
- (IBAction)typeBtnClick:(id)sender
{
    UIButton* button = (UIButton*)sender;
//    if ((self.shopMode==CLOTHESHOES_MODE)&&(button.tag==100||button.tag==102||(button.tag==103&&self.status==4))) {
//        [self checkReturnGoods:button.tag];
//    }else{
//        [self updateReturnPaper:button.tag];
//    }
    
    [self updateReturnPaper:button.tag];
}

- (void)updateReturnPaper:(NSInteger)tag
{
    switch (tag) {
        case 100:
        {
            //确认退货
            if (![self isValide]) {
                return;
            }
            NSString *title = [NSString stringWithFormat:@"确认退货[%@]吗?",[self.txtPaperNo getStrVal]];
            [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
//                [self operatePaperDetail:@"confirm" withMessage:@"正在确认..."];
                [self paperDetailGoodsDeleteCheck:@"confirm" action:@"确认退货"];
            }];
            break;
        }
        case 101:
        {
            //拒绝退货
            if (![self isValide]) {return;}
            NSString *title = [NSString stringWithFormat:@"拒绝退货[%@]吗?",[self.txtPaperNo getStrVal]];
            [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
                [self operatePaperDetail:@"refuse" withMessage:@"正在拒绝..."];
            }];
            break;
        }
        case 102:
        {
            //确认退货
            if (![self isValide]) {
                return;
            }
            NSString *title = [NSString stringWithFormat:@"确认退货[%@]吗?",[self.txtPaperNo getStrVal]];
            [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
//                  [self operatePaperDetail:@"confirm" withMessage:@"正在确认..."];
                [self paperDetailGoodsDeleteCheck:@"confirm" action:@"确认退货"];
            }];
            break;
        }
        case 103:
        {
            //提交
            if (![self isValide]) {
                return;
            }
            NSString *title = [NSString stringWithFormat:@"%@[%@]吗?",(self.status==4?@"提交":@"重新申请"),[self.txtPaperNo getStrVal]];
            [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
                if (self.status == 4)
                {
                    [self paperDetailGoodsDeleteCheck:@"submit" action:@"提交"];
//                    [self operatePaperDetail:@"submit" withMessage:@"正在提交..."];
                }
                else
                {
                    [self paperDetailGoodsDeleteCheck:@"reapply" action:@"重新申请"];
//                    [self operatePaperDetail:@"reapply" withMessage:@"正在重新申请..."];
                }
            }];
            break;
        }
        case 104:
        {
            //删除
            NSString *title = [NSString stringWithFormat:@"删除[%@]吗?",[self.txtPaperNo getStrVal]];
            [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
                    [self operatePaperDetail:@"del" withMessage:@"正在删除..."];
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 删除商品
- (void)delObject:(PaperDetailVo *)item
{
    self.paperDetailVo = item;
    NSString *title = [NSString stringWithFormat:@"删除[%@]吗?",item.goodsName];
    [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
        [self.goodList removeObject:self.paperDetailVo];
        if (![self.paperDetailVo.operateType isEqualToString:@"add"])
        {
            self.paperDetailVo.operateType = @"del";
            [self.delGoodsList addObject:self.paperDetailVo];
        }
        [self changeNavigateUI];
        [self.mainGrid reloadData];

    }];
}

#pragma mark - 验证
- (BOOL)isValide
{
    if ([NSString isBlank:[self.lsSupplier getStrVal]]) {
        [LSAlertHelper showAlert:@"请选择供应商!"];
        return NO;
    }
    
    if (self.lsReceiveWarehouse.hidden == NO && [NSString isBlank:[self.lsReceiveWarehouse getStrVal]]) {
        [LSAlertHelper showAlert:@"请选择收货仓库!"];
        return NO;
    }
    
    if ([NSString isBlank:[self.lsDeliveWarehouse getStrVal]]&&self.isOrg) {
        [LSAlertHelper showAlert:@"请选择发货仓库!"];
        return NO;
    }
    
    if (self.lsReturnType.hidden == NO &&([NSString isBlank:[self.lsReturnType getStrVal]] || [NSString isBlank:[self.lsReturnType getDataLabel]])) {
        [LSAlertHelper showAlert:@"请选择退货类型!"];
        return NO;
    }

    if (self.goodList.count > 200) {
        [LSAlertHelper showAlert:@"最多只能添加200种商品!"];
        return NO;
    }
    return YES;
}

#pragma mark - 修改、添加保存
- (void)save
{
    if (self.isFirstAdd) {
        if (![self isValide]) {
            return;
        }
        if (self.isHistory) {
            //商超导入保存
            [self operatePaperDetail:@"add" withMessage:@"正在保存..."];
        }else{
            [self operatePaperDetail:@"firstadd" withMessage:@"正在保存..."];
        }
    }else{
        if (![self isValide]) {
            return;
        }
        [self operatePaperDetail:@"edit" withMessage:@"正在保存..."];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.token = nil;
}
#pragma mark - 获取参数
- (NSMutableDictionary*)obtainParams
{
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    if ([NSString isBlank:self.token]) {
        self.token = [[Platform Instance] getToken];
    }
    [param setValue:self.token forKey:@"token"];
    
    NSString* date = [self.lsDate getStrVal];
    NSString* time = [self.lsTime getStrVal];
    NSString* dateTime = [NSString stringWithFormat:@"%@ %@",date,time];
    [param setValue:self.paperId forKey:@"returnGoodsId"];
    [param setValue:self.supplyId forKey:@"supplyId"];
    [param setValue:self.supplyName forKey:@"supplyName"];
    [param setValue:self.shopId forKey:@"shopId"];
    [param setValue:self.shopName forKey:@"shopName"];
    
    if (self.paperType==RETURN_PAPER_TYPE) {
        [param setValue:[NSNumber numberWithShort:1] forKey:@"type"];
    }else{
        [param setValue:[NSNumber numberWithShort:2] forKey:@"type"];
    }
    
    if ([NSString isNotBlank:[self.lsReceiveWarehouse getStrVal]]) {
        [param setValue:[self.lsReceiveWarehouse getStrVal] forKey:@"inWarehouseId"];
        [param setValue:self.lsReceiveWarehouse.lblVal.text forKey:@"inWarehouseName"];
    }
    
    if ([NSString isNotBlank:[self.lsDeliveWarehouse getStrVal]]) {
        [param setValue:[self.lsDeliveWarehouse getStrVal] forKey:@"outWarehouseId"];
        [param setValue:self.lsDeliveWarehouse.lblVal.text forKey:@"outWarehouseName"];
    }
    
    if ([NSString isNotBlank:[self.lsReturnType getStrVal]]) {
        [param setValue:[self.lsReturnType getStrVal] forKey:@"returnTypeVal"];
        [param setValue:self.lsReturnType.lblVal.text forKey:@"returnTypeName"];
    }
    
    [param setValue:[NSNumber numberWithLongLong:[DateUtils formateDateTime4:dateTime]] forKey:@"sendendtime"];

    if ([NSString isNotBlank:[self.txtMemo getStrVal]]) {
        [param setValue:[self.txtMemo getStrVal] forKey:@"memo"];
    }
    [param setValue:[NSNumber numberWithLong:self.lastVer] forKey:@"lastVer"];
    
    self.paperVo = [[PaperVo alloc] init];
    self.paperVo.paperId = self.paperId;
    self.paperVo.sendEndTime = [DateUtils formateDateTime4:dateTime];
    self.paperVo.billStatus = self.status;
    return param;
}

- (NSMutableArray *)obtainGoodsList
{
    NSMutableArray *goodsList = [NSMutableArray array];
    if (self.delGoodsList.count>0) {
        [goodsList addObjectsFromArray:self.delGoodsList];
    }
    [goodsList addObjectsFromArray:self.goodList];
    return goodsList;
}

#pragma mark - 单据详情编辑、删除、提交
- (void)operatePaperDetail:(NSString*)operateType withMessage:(NSString*)message
{
    NSMutableDictionary* param = [self obtainParams];
    [param setValue:operateType forKey:@"operateType"];
    [param setValue:[PaperDetailVo converToDicArr:[self obtainGoodsList] paperType:self.paperType] forKey:@"returnGoodsDetailList"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"returnGoods/save"];

    __weak typeof(self) weakSelf = self;
    [_logisticService operatePaperDetail:param withUrl:url completionHandler:^(id json) {
        [weakSelf removeNotification];
        weakSelf.token = nil;
        if (weakSelf.flg==ACTION_CONSTANTS_ADD) {
            weakSelf.paperHandler(nil,ACTION_CONSTANTS_ADD);
        }else if ([operateType isEqualToString:@"edit"]){
            weakSelf.paperHandler(weakSelf.paperVo,ACTION_CONSTANTS_EDIT);
        }else if ([operateType isEqualToString:@"del"]){
            weakSelf.paperHandler(weakSelf.paperVo,ACTION_CONSTANTS_DEL);
        }else if ([operateType isEqualToString:@"submit"]){
            weakSelf.paperVo.billStatus = 1;
            weakSelf.paperHandler(weakSelf.paperVo,ACTION_CONSTANTS_EDIT);
        }else if ([operateType isEqualToString:@"confirm"]){
            weakSelf.paperVo.billStatus = 2;
            weakSelf.paperHandler(weakSelf.paperVo,ACTION_CONSTANTS_EDIT);
        }else if ([operateType isEqualToString:@"refuse"]){
            weakSelf.paperVo.billStatus = 3;
            weakSelf.paperHandler(weakSelf.paperVo,ACTION_CONSTANTS_EDIT);
        }else if ([operateType isEqualToString:@"reapply"]){
            weakSelf.paperVo.billStatus = 4;
            weakSelf.paperHandler(weakSelf.paperVo,ACTION_CONSTANTS_EDIT);
        }
        
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    } withMessage:message];
}


// 进行提交和重新申请提交前check 单子中的商品 删除状况
- (void)paperDetailGoodsDeleteCheck:(NSString *)opType action:(NSString *)actionName {
    
    __weak typeof(self) wself = self;
    NSArray *array = [[PaperDetailVo converToDicArr:[self obtainGoodsList] paperType:self.paperType] copy];
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 102) {
        NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"returnGoods/checkGoods"];
        [_logisticService checkPaperDetailGoods:url params:@{@"returnGoodsDetailList":array} completionHandler:^(id json) {
            
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
                        if ([opType isEqualToString:@"submit"]) {
                            [wself operatePaperDetail:opType withMessage:@"正在提交..."];
                        } else if ([opType isEqualToString:@"reapply"]) {
                            [wself paperDetailGoodsDeleteCheck:opType action:@"重新申请"];
                        } else if ([opType isEqualToString:@"confirm"]) {
                            [wself operatePaperDetail:@"confirm" withMessage:@"正在确认..."];
                        }
                    }];
                }
            } else if ([json[@"returnCode"] isEqualToString:@"success"]) {
                
                if ([opType isEqualToString:@"submit"]) {
                    [wself operatePaperDetail:opType withMessage:@"正在提交..."];
                } else if ([opType isEqualToString:@"reapply"]) {
                    [wself paperDetailGoodsDeleteCheck:opType action:@"重新申请"];
                    
                } else if ([opType isEqualToString:@"confirm"]) {
                    [wself operatePaperDetail:@"confirm" withMessage:@"正在确认..."];
                }
            }
            
        } errorHandler:^(id json) {
            
            [LSAlertHelper showAlert:json];
            
        } withMessage:@""];
    } else {
        if ([opType isEqualToString:@"submit"]) {
            [wself operatePaperDetail:opType withMessage:@"正在提交..."];
        } else if ([opType isEqualToString:@"reapply"]) {
            [wself paperDetailGoodsDeleteCheck:opType action:@"重新申请"];
            
        } else if ([opType isEqualToString:@"confirm"]) {
            [wself operatePaperDetail:@"confirm" withMessage:@"正在确认..."];
        }
    }
   
}


@end
