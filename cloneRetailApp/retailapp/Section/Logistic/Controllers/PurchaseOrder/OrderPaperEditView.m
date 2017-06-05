//
//  OrderPaperEditView.m
//  retailapp
//
//  Created by hm on 15/10/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//
#define kCountName @"数量"
#define kCountVal @"0"
#define kPriceName @"采购价"
#define kPriceVal @"1"
#define kAmountName @"金额"
#define kAmountVal @"2"
#import "OrderPaperEditView.h"
#import "LogisticModuleEvent.h"
#import "ServiceFactory.h"
#import "UIHelper.h"
#import "ColorHelper.h"
#import "DateUtils.h"
#import "AlertBox.h"
#import "LRender.h"
#import "SignUtil.h"
#import "LSEditItemList.h"
#import "LSEditItemText.h"
#import "SmallTitle.h"
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
#import "PaperVo.h"
#import "NameItemVO.h"
#import "GoodsVo.h"
#import "HistoryPaperListView.h"
#import "GoodsDetailEditView.h"
#import "SelectSupplierListView.h"
#import "SelectShopListView.h"
#import "CloShoesEditView.h"
#import "GoodsBatchChoiceView1.h"
#import "SelectStoreListView.h"

@interface OrderPaperEditView ()<IEditItemListEvent,ISmallTitleEvent,DatePickerClient,TimePickerClient,OptionPickerClient,PaperCellGoodsDelagate,XBStepperDelegate>

@property (nonatomic,strong) LogisticService       * logisticService;
@property (nonatomic,copy  ) NSString              * paperId;
@property (nonatomic,assign) long                  lastVer;
@property (nonatomic,assign) NSInteger             paperType;
@property (nonatomic,assign) NSInteger             action;
@property (nonatomic,assign) BOOL                  isEdit;
@property (nonatomic,assign) short                 status;
@property (nonatomic,copy  ) EditOrderPaperHandler orderPaperHandler;
@property (nonatomic,assign) PaperGoodsCellType             mode;
@property (nonatomic,assign) BOOL                  isFold;
/**UI变化标示位*/
@property (nonatomic,assign) BOOL                  isChangeFlag;
/**101 服鞋 102 商超*/
@property (nonatomic,assign) NSInteger             shopMode;
/**1单店 2连锁 3机构*/
@property (nonatomic,assign) NSInteger             shopType;
@property (nonatomic,strong) NSMutableArray        * goodList;
@property (nonatomic,strong) NSMutableArray        * delGoodsList;
/**商品详情vo*/
@property (nonatomic,strong) PaperDetailVo         * paperDetailVo;
/**单据vo*/
@property (nonatomic,strong) PaperVo               * paperVo;
/**是否是机构*/
@property (nonatomic,assign) BOOL                  isOrg;
/**是否是第一次添加*/
@property (nonatomic,assign) BOOL                  isFirstAdd;
/**是否是历史单导入*/
@property (nonatomic,assign) BOOL                  isHistory;
/**是否是添加*/
@property (nonatomic,assign) NSInteger             flg;
/**历史单id*/
@property (nonatomic,copy  ) NSString              * hitoryPaperId;
/**1采购叫货单 2客户叫货单*/
@property (nonatomic,assign) short                 type;
/**门店/仓库id*/
@property (nonatomic,copy  ) NSString              * shopId;
/**供应商id*/
@property (nonatomic,copy  ) NSString              * supplyId;
/**收货仓库id*/
@property (nonatomic,copy  ) NSString              * inWareHouseId;
/**发货仓库id*/
@property (nonatomic,copy  ) NSString              * outWareHouseId;
/**是否更改供应商*/
@property (nonatomic,assign) BOOL                  isSupplyChange;
//是否可以编辑价格
@property (nonatomic, assign) BOOL isEditPrice;
//是否可以查看价格
@property (nonatomic, assign) BOOL isSearchPrice;
/**避免重复操作*/
@property (nonatomic,copy) NSString *token;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintAddView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConatraintCrView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConatraintSubView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintDelView;
@end

@implementation OrderPaperEditView

- (void)viewDidLoad {
    [super viewDidLoad];
    _logisticService = [ServiceFactory shareInstance].logisticService;
    self.mainGrid.frame = CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH);
    [self configHeaderView];
    [self initNavigate];
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
    self.goodList = [NSMutableArray array];
    self.delGoodsList = [NSMutableArray array];
    [self loadData];
    [UIHelper clearColor:self.footerView];
}

- (void)configHeaderView {
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 100)];
    
    self.lsHistory = [LSEditItemList editItemList];
    [self.headerView addSubview:self.lsHistory];
    
    self.baseTitle = [LSEditItemTitle editItemTitle];
    [self.headerView addSubview:self.baseTitle];
    
    self.txtPaperNo = [LSEditItemText editItemText];
    [self.headerView addSubview:self.txtPaperNo];
    
    self.lsOrgShop = [LSEditItemList editItemList];
    [self.headerView addSubview:self.lsOrgShop];
    
    self.lsSupplier = [LSEditItemList editItemList];
    [self.headerView addSubview:self.lsSupplier];
    
    self.lsReceiveWarehouse = [LSEditItemList editItemList];
    [self.headerView addSubview:self.lsReceiveWarehouse];
    
    self.lsDeliveWarehouse = [LSEditItemList editItemList];
    [self.headerView addSubview:self.lsDeliveWarehouse];
    
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


#pragma mark - 设置参数及回调
- (void)loadPaperId:(NSString*)paperId status:(short)billStatus paperType:(NSInteger)paperType action:(NSInteger)action isEdit:(BOOL)isEdit callBack:(EditOrderPaperHandler)callBack
{
    self.paperId = paperId;
    self.paperType = paperType;
    self.action = action;
    self.isEdit = isEdit;
    self.status = billStatus;
    self.orderPaperHandler = callBack;
    self.mode = PaperGoodsCellTypeCount;
    self.shopType = [[Platform Instance] getShopMode];
    self.isFold = NO;
    self.isOrg = (self.shopType==3);
    self.shopMode = [[[Platform Instance] getkey:SHOP_MODE] integerValue];
    self.type = (paperType==ORDER_PAPER_TYPE)?1:2;
}

//初始化导航
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
            self.orderPaperHandler(nil,ACTION_CONSTANTS_ADD);
        }
        [XHAnimalUtil animalEdit:self.navigationController action:_action];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self save];
    }
}

//初始化主视图
- (void)initMainView
{
    __weak typeof(self) wself = self;
    [self.lsHistory.lblName setFont:[UIFont boldSystemFontOfSize:17]];
    [self.lsHistory.imgMore setImage:[UIImage imageNamed:@"ico_next"]];
    if (self.shopMode==CLOTHESHOES_MODE) {
        [self.lsHistory initLabel:@"从历史采购单导入" withHit:@"快速导入历史采购单信息" delegate:self];
        [self.txtPaperNo initLabel:@"采购单号" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    } else {
//        [self.lsHistory initLabel:@"从历史叫货单导入" withHit:@"快速导入历史叫货单信息" delegate:self];
        [self.lsHistory initLabel:@"从历史采购单导入" withHit:@"快速导入历史采购单信息" delegate:self];
        [self.txtPaperNo initLabel:@"采购单号" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    }
    
    [self.goodsTitle configTitle:@"采购商品" type:LSEditItemTitleTypeDown rightClick:^(LSEditItemTitle *view) {
        float cHeight = self.mainGrid.contentSize.height;
        float mHeight = self.mainGrid.bounds.size.height;
        if (cHeight>mHeight) {
            [wself.mainGrid setContentOffset:CGPointMake(0, cHeight - mHeight) animated:YES];
        }
    }];
    [self.lsHistory.imgMore mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wself.lsHistory);
        make.size.equalTo(22);
        make.right.equalTo(wself.lsHistory.right).offset(-10);
    }];
    
    self.lsHistory.lblVal.placeholder = @"";
    [self.txtPaperNo editEnabled:NO];
    
    [self.baseTitle configTitle:@"基本信息" type:LSEditItemTitleTypeOpen rightClick:^(LSEditItemTitle *view) {
        [wself expandBaseInfo];
    }];
    [self.lsOrgShop initLabel:@"采购机构/门店" withHit:nil isrequest:NO delegate:self];
    [self.lsSupplier initLabel:@"供应商" withHit:nil isrequest:NO delegate:self];
    [self.lsSupplier.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    [self.lsReceiveWarehouse initLabel:@"收货仓库" withHit:nil isrequest:YES delegate:self];
    [self.lsReceiveWarehouse.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    [self.lsDeliveWarehouse initLabel:@"发货仓库" withHit:nil isrequest:YES delegate:self];
    [self.lsDeliveWarehouse.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    [self.lsDate initLabel:@"要求到货日" withHit:nil isrequest:YES delegate:self];
    [self.lsTime initLabel:@"要求到货时间" withHit:nil isrequest:YES delegate:self];
    [self.txtMemo initLabel:@"备注" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtMemo initMaxNum:100];
    [self.lsMode initLabel:@"展示内容" withHit:nil delegate:self];
    self.lblName.text = @"添加采购商品...";
    
    self.lsHistory.tag = HISTORY;
    self.lsSupplier.tag = SUPPLIER;
    self.lsReceiveWarehouse.tag = RECEIVE_WAREHOUSE;
    self.lsDeliveWarehouse.tag = DELIVE_WAREHOUSE;
    self.lsDate.tag = DATE;
    self.lsTime.tag = TIME;
    self.lsMode.tag = MODE;
}

#pragma mark - UI变化通知
- (void)initNotification
{
    [UIHelper initNotification:self.headerView event:Notification_UI_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_Change object:nil];
}

- (void)dataChange:(NSNotification*)notification
{
    [self editTitle:[UIHelper currChange:self.headerView] act:_action];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 显示页面项(是否可编辑)
- (void)showHeaderView:(NSInteger)action isEdit:(BOOL)isEdit
{
    [self.lsHistory visibal:action==ACTION_CONSTANTS_ADD&&(_paperType==ORDER_PAPER_TYPE)];
    [self.lsOrgShop visibal:_paperType==CLIENT_ORDER_PAPER_TYPE];
    [self.lsReceiveWarehouse visibal:self.isOrg&&_paperType==ORDER_PAPER_TYPE];
    [self.lsDeliveWarehouse visibal:_paperType==CLIENT_ORDER_PAPER_TYPE];
    [self.lsHistory editEnable:isEdit];
    [self.lsOrgShop editEnable:NO];
    [self.lsSupplier editEnable:(action==ACTION_CONSTANTS_ADD||(isEdit&&_paperType==CLIENT_ORDER_PAPER_TYPE))];
    [self.lsReceiveWarehouse editEnable:isEdit];
    [self.lsDeliveWarehouse editEnable:isEdit];
    [self.lsDate editEnable:isEdit&&_paperType!=CLIENT_ORDER_PAPER_TYPE];
    [self.lsTime editEnable:isEdit&&_paperType!=CLIENT_ORDER_PAPER_TYPE];
    [self.txtMemo editEnabled:isEdit&&_paperType!=CLIENT_ORDER_PAPER_TYPE];
    if (!(isEdit&&_paperType!=CLIENT_ORDER_PAPER_TYPE)) {
        self.txtMemo.txtVal.placeholder = @"";
    }
    //商超 (添加显示  编辑时采购单未提交显示 客户采购单待确认显示) 服鞋不显示
    [self.lsMode visibal:(self.shopMode==SUPERMARKET_MODE&&((_paperType==ORDER_PAPER_TYPE&&self.status==4)||(_paperType==CLIENT_ORDER_PAPER_TYPE&&self.status==1)||action==ACTION_CONSTANTS_ADD))];
}

#pragma mark - 根据状态显示页面底部按钮
- (void)showFooterView:(NSInteger)action isEdit:(BOOL)isEdit
{
    self.addView.hidden = !isEdit;
    self.crView.hidden = !(_status==1&&_paperType==CLIENT_ORDER_PAPER_TYPE&&isEdit&&self.goodList.count>0);
    self.subView.hidden = !((_status==4&&self.goodList.count>0)||(_status==3&&_paperType==ORDER_PAPER_TYPE));
    if (_status==4) {
        [self.subBtn setTitle:@"提交" forState:UIControlStateNormal];
    }else {
        [self.subBtn setTitle:@"重新申请" forState:UIControlStateNormal];
    }
    self.delView.hidden = !(_status==4);
    self.sumView.hidden = !(self.goodList.count>0);
    self.heightConstraintAddView.constant = self.addView.hidden ? 0 : 48;
    self.heightConatraintCrView.constant = self.crView.hidden ? 0 : 64;
    self.heightConatraintSubView.constant = self.subView.hidden ? 0 : 64;
    self.heightConstraintDelView.constant = self.delView.hidden ? 0 : 64;
    [self.footerView layoutIfNeeded];
    [UIHelper refreshUI:self.footerView];
    self.mainGrid.tableFooterView = self.footerView;
}

#pragma mark - 显示页面信息
- (void)loadData
{
    [self showHeaderView:self.action isEdit:self.isEdit];
    [self showFooterView:self.action isEdit:self.isEdit];
    [self expandBaseInfo];
    [self initNotification];
    if (self.action==ACTION_CONSTANTS_ADD) {
        self.flg = ACTION_CONSTANTS_ADD;
//        self.titleBox.lblTitle.text = @"添加";
        [self configTitle:@"添加采购单"];
        [self clearDo];
    }else{
        self.flg = ACTION_CONSTANTS_EDIT;
        [self selectOrderPaperDetailById:self.paperId isNeedDel:nil];
    }
}

- (void)clearDo
{
    if (self.shopType==3) {
        self.shopId = [[Platform Instance] getkey:ORG_ID];
    }else{
        self.shopId = [[Platform Instance] getkey:SHOP_ID];
    }
    self.isFirstAdd = YES;
    NSDate* date = [NSDate date];
    NSString* dateStr = [DateUtils formateDate2:date];
    NSString* timeStr = [DateUtils formateChineseTime:date];
    [self.lsSupplier initData:@"请选择" withVal:nil];
    [self.lsReceiveWarehouse initData:@"请选择" withVal:nil];
    [self.lsDeliveWarehouse initData:@"请选择" withVal:nil];
    [self.lsDate initData:dateStr withVal:dateStr];
    [self.lsTime initData:timeStr withVal:timeStr];
    [self.txtMemo initData:nil];
    [self.lsMode initData:kCountName withVal:kCountVal];
    [self.mainGrid reloadData];
}

#pragma mark - 查询叫货单详情
- (void)selectOrderPaperDetailById:(NSString*)paperId isNeedDel:(NSString *)isNeedDel
{
    __weak typeof(self) weakSelf = self;
    [_logisticService selectOrderPaperDetail:paperId withType:self.type isNeedDel:isNeedDel completionHandler:^(id json) {
        
        if (weakSelf.action == ACTION_CONSTANTS_EDIT)
        {
            //查看详情或服鞋历史单导入
            [weakSelf configTitle:[json objectForKey:@"orderGoodsNo"]];
            [weakSelf.txtPaperNo initData:[json objectForKey:@"orderGoodsNo"]];
            weakSelf.lastVer = [[json objectForKey:@"lastVer"] longValue];
            [weakSelf.lsHistory visibal:NO];
            [weakSelf.txtPaperNo visibal:YES];
            [UIHelper refreshUI:weakSelf.headerView];
            weakSelf.mainGrid.tableHeaderView = weakSelf.headerView;
        }
        weakSelf.shopId = [json objectForKey:@"shopId"];
        [weakSelf.lsOrgShop initData:[json objectForKey:@"shopName"] withVal:[json objectForKey:@"shopId"]];
        [weakSelf.lsSupplier initData:[json objectForKey:@"supplyName"] withVal:[json objectForKey:@"supplyId"]];
        if ([NSString isBlank:[json objectForKey:@"inWareHouseName"]])
        {
            [weakSelf.lsReceiveWarehouse initData:@"请选择" withVal:nil];
        }
        else
        {
            [weakSelf.lsReceiveWarehouse initData:[json objectForKey:@"inWareHouseName"] withVal:[json objectForKey:@"inWareHouseId"]];
        }
        
        if ([NSString isNotBlank:[json objectForKey:@"outWareHouseName"]])
        {
            [weakSelf.lsDeliveWarehouse initData:[json objectForKey:@"outWareHouseName"] withVal:[json objectForKey:@"outWareHouseId"]];
        }
        else
        {
            [weakSelf.lsDeliveWarehouse initData:@"请选择" withVal:nil];
        }
        
        weakSelf.supplyId = [json objectForKey:@"supplyId"];
        NSString* dateTime = [DateUtils formateTime:[[json objectForKey:@"sendEndTime"] longLongValue]];
        NSString* date = [[dateTime componentsSeparatedByString:@" "] objectAtIndex:0];
        NSString* time = [[dateTime componentsSeparatedByString:@" "] objectAtIndex:1];
        if (![isNeedDel isEqualToString:@"1"]) {//不是从历史单据导入
            [weakSelf.lsDate initData:date withVal:date];
            [weakSelf.lsTime initData:time withVal:time];
        }
        
        [weakSelf.txtMemo initData:[json objectForKey:@"memo"]];
       
        NSMutableArray *arr = [PaperDetailVo converToArr:[json objectForKey:@"orderGoodsDetailList"]
                                               paperType:weakSelf.paperType];
        if (weakSelf.isHistory) {
            
            /** 商超版历史单导入处理
             *  http://k.2dfire.net/pages/viewpage.action?pageId=185729162
             *  商超模式添加"采购货"选择"从历史叫货单导入"，选择的导入单中包含的商品数限制200以下
             */
            if (weakSelf.paperType == ORDER_PAPER_TYPE && [arr count] > 200) {
                [AlertBox show:@"该单据商品数量过多，不支持导入!"];
            }
            else
            {
                self.goodList = arr;
                for (PaperDetailVo *detailVo in weakSelf.goodList) {
                    detailVo.operateType = @"add";
                }
            }
        }
        else
        {
            weakSelf.goodList = arr;
        }
        [weakSelf.lsMode initData:kCountName withVal:kCountVal];
        [weakSelf.mainGrid reloadData];
        [weakSelf caculateAmount];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
}


#pragma mark - IEditItemListEvent协议
- (void)onItemListClick:(EditItemList *)obj
{
    NSDate *date = nil;
    if (obj.tag == HISTORY) {
        //历史单导入
        HistoryPaperListView* historyPaperListView = [[HistoryPaperListView alloc] init];
        __weak typeof(self) weakSelf = self;
        if (self.shopMode==CLOTHESHOES_MODE) {
            //服鞋版历史叫货单导入
//            [historyPaperListView loadPaperId:self.hitoryPaperId withType:HistoryPaperListViewTypeHistoryPurchase callBack:^(NSString *paperId, NSString *paperType, id json) {
//                weakSelf.hitoryPaperId = paperId;
//                [weakSelf.logisticService importOrderPaperById:paperId completionHandler:^(id json) {
//                    weakSelf.action = ACTION_CONSTANTS_EDIT;
//                    weakSelf.isFirstAdd = NO;
//                    weakSelf.status = 4;
//                    [weakSelf.lsSupplier editEnable:NO];
//                    weakSelf.paperId = [json objectForKey:@"orderGoodsId"];
//                    [weakSelf selectOrderPaperDetailById:weakSelf.paperId isNeedDel:nil];
//                } errorHandler:^(id json) {
//                    [AlertBox show:json];
//                }];
//            }];
            [historyPaperListView loadPaperId:self.hitoryPaperId withType:HistoryPaperListViewTypeHistoryPurchase callBack:^(NSString *paperId, NSString *paperType, id json) {
                weakSelf.hitoryPaperId = paperId;
                weakSelf.action = ACTION_CONSTANTS_EDIT;
                weakSelf.isFirstAdd = NO;
                weakSelf.status = 4;
                [weakSelf.lsSupplier editEnable:NO];
                weakSelf.paperId = [json objectForKey:@"orderGoodsId"];
                [weakSelf selectOrderPaperDetailById:weakSelf.paperId isNeedDel:nil];            }];

        }else{
            //商超版历史叫货单导入
            [historyPaperListView loadPaperId:self.hitoryPaperId withType:HistoryPaperListViewTypeHistoryPurchase callBack:^(NSString *paperId, NSString *paperType, id json) {
                weakSelf.hitoryPaperId = paperId;
                weakSelf.isHistory = YES;
                [weakSelf selectOrderPaperDetailById:paperId isNeedDel:@"1"];
            }];
        }
        [self.navigationController pushViewController:historyPaperListView animated:NO];
        historyPaperListView = nil;
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }

    if (obj.tag==SUPPLIER) {
        //选择供应商
        SelectSupplierListView* selectSupplyListView = [[SelectSupplierListView alloc] init];
        // 门店进入，也不显示全选按钮
        __weak typeof(self) weakSelf = self;
        [selectSupplyListView loadDataBySupplyId:[obj getStrVal] supplyFlag:@"self" handler:^(id<INameValue> supplier) {
            if (supplier) {
                if (![[weakSelf.lsSupplier getStrVal] isEqualToString:[supplier obtainItemId]]&&weakSelf.paperType==PURCHASE_PAPER_TYPE) {
                    //更改供应商时，删除商品
                    [weakSelf.goodList removeAllObjects];
                    [weakSelf.mainGrid reloadData];
                    [weakSelf caculateAmount];
                }
                if (weakSelf.paperType==CLIENT_ORDER_PAPER_TYPE) {
                    [weakSelf.lsDeliveWarehouse changeData:@"请选择" withVal:nil];
                }
                weakSelf.isSupplyChange = YES;
                weakSelf.supplyId = [supplier obtainItemId];
                [weakSelf.lsSupplier changeData:[supplier obtainItemName] withVal:[supplier obtainItemId]];
            }
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
        [self.navigationController pushViewController:selectSupplyListView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        selectSupplyListView = nil;
        
    }
    
    if (obj.tag==RECEIVE_WAREHOUSE||obj.tag==DELIVE_WAREHOUSE) {
        //选择收货仓库 发货仓库
        SelectStoreListView *storeView = [[SelectStoreListView alloc] init];
        NSString *orgId = (obj.tag==DELIVE_WAREHOUSE)?[self.lsSupplier getStrVal]:[[Platform Instance] getkey:ORG_ID];
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
    
    if (obj.tag==DATE) {
        //要求到货日
        date = [DateUtils parseDateTime4:obj.lblVal.text];
        [DatePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
    }
    if (obj.tag==TIME) {
        //要求到货时间
        date=[DateUtils parseDateTime6:[obj getStrVal]];
        [TimePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
    }
    if (obj.tag==MODE) {
        //展开项
        NSMutableArray* vos = [NSMutableArray arrayWithCapacity:2];
        NameItemVO *item=[[NameItemVO alloc] initWithVal:kCountName andId:kCountVal];
        [vos addObject:item];
        if (self.isEditPrice) {//有编辑的权限才能看到
            item = [[NameItemVO alloc] initWithVal:kPriceName andId:kPriceVal];
            [vos addObject:item];
            item = [[NameItemVO alloc] initWithVal:kAmountName andId:kAmountVal];
            [vos addObject:item];

        }
        [OptionPickerBox initData:vos itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }
}

//选择日期处理
- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event
{
    NSString* dateStr=[DateUtils formateDate2:date];
    
    [self.lsDate changeData:dateStr withVal:dateStr];
    
    return YES;
}
//选择时间处理
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
        } else  if ([[self.lsMode getStrVal] isEqualToString:kPriceVal]) {
            self.mode = PaperGoodsCellTypePrice;
        } else  if ([[self.lsMode getStrVal] isEqualToString:kAmountVal]) {
            self.mode = PaperGoodsCellTypeAmount;
        }
        [self.mainGrid reloadData];
    }
    
    return YES;
}

#pragma mark - ISmallTitle协议
//折叠
- (void)onTitleExpandClick:(NSInteger)event
{
    if (event==EXPAND_TYPE) {
        [self expandBaseInfo];
    }
}
//展开折叠基本信息
- (void)expandBaseInfo
{
    [self.txtPaperNo visibal:(_action==ACTION_CONSTANTS_EDIT)&&!_isFold];
    [self.lsOrgShop visibal:(!_isFold&&_paperType==CLIENT_ORDER_PAPER_TYPE)];
    [self.lsSupplier visibal:(!_isFold)];
    [self.lsReceiveWarehouse visibal:(!_isFold&&_paperType==ORDER_PAPER_TYPE&&self.isOrg)];
    [self.lsDeliveWarehouse visibal:(!_isFold&&_paperType==CLIENT_ORDER_PAPER_TYPE)];
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

#pragma mark - 计算合计项
- (void)caculateAmount
{
    NSInteger num = self.goodList.count;
    double amount = 0.00;
    double sum = 0.00;
    BOOL type = NO;
    if (self.shopMode==102) {
        for (PaperDetailVo* detailVo in self.goodList) {
            amount+= self.isSearchPrice ? detailVo.goodsTotalPrice : detailVo.retailPrice * detailVo.goodsSum;
            sum += detailVo.goodsSum;
            if (detailVo.type==4) {
                type = YES;
            }
            
        }
    }else{
        for (PaperDetailVo *detailVo in self.goodList) {
            if (self.isSearchPrice) {
                amount+=detailVo.goodsPurchaseTotalPrice;
            } else {
                amount+=detailVo.goodsHangTagTotalPrice;
            }
            sum+=detailVo.goodsSum;
           
        }
    }

    
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

#pragma mark - XBStepperDelegate
- (BOOL)needChangeValue:(PaperGoodsCell *)cell {

    if (self.paperType == ORDER_PAPER_TYPE) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"changeFlag == 1"];
        NSArray *resultArr = [self.goodList filteredArrayUsingPredicate:predicate];
        if (resultArr.count >= 200 && ![resultArr containsObject:cell.goodsVo]) {
            
             [AlertBox show:@"一次最多支持修改200条！"];
            return NO;
        }
        return YES;
    }
    return YES;
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
    if (self.shopMode == CLOTHESHOES_MODE)
    {
       return [self tableView:tableView styleCellForRowAtIndexPath:indexPath];
    }
    else
    {
        static NSString *paperGoodsCellId = @"PaperGoodsCell";
        PaperGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:paperGoodsCellId];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"PaperGoodsCell" bundle:nil] forCellReuseIdentifier:paperGoodsCellId];
            cell = [tableView dequeueReusableCellWithIdentifier:paperGoodsCellId];
           
        }
        cell.type = _paperType;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.stepper.stepperDelegate = self;
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
            //服鞋版显示模式
            ShoesClothingCell* detailItem = (ShoesClothingCell*)cell;
            detailItem.lblName.text = goodsVo.goodsName;
            detailItem.lblStyleNo.text = [NSString stringWithFormat:@"款号：%@",goodsVo.styleCode];
            detailItem.lblStyleCount.text = [NSString stringWithFormat:@"x%.0f",goodsVo.goodsSum];
            NSString *price = nil;
            if (self.isSearchPrice) {
                price = [NSString stringWithFormat:@"￥%.2f",goodsVo.goodsPurchaseTotalPrice];
            } else {
                price = [NSString stringWithFormat:@"￥%.2f",goodsVo.goodsHangTagTotalPrice];
            }

            detailItem.lblTotalMoney.text = price;
        }else{
            //商超版显示模式
            PaperGoodsCell* detailItem = (PaperGoodsCell*)cell;
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
        __weak typeof(self) weakSelf = self;
        [goodsDetailView showGoodsDetail:self.paperDetailVo paperType:_paperType isEdit:_isEdit callBack:^(NSInteger action) {
            if (ACTION_CONSTANTS_DEL==action) {
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

#pragma mark - 添加保存(保存单据基础信息)
- (IBAction)addBtnClick:(id)sender
{
    if (self.isFirstAdd) {
        if (![self isValide]) {
            return;
        }
        [self saveForAddPaper:@"add" message:@"正在保存..." isHistory:NO];
        
    }else{
        
        if (self.shopMode==CLOTHESHOES_MODE) {
            [self showSelectStyleView:ACTION_CONSTANTS_ADD];
        }else{
            [self showSelectGoodsView];
        }
    }
   
}

#pragma mark - 第一次添加保存
- (void)saveForAddPaper:(NSString *)operateType message:(NSString *)message isHistory:(BOOL)isHistory
{
    NSMutableDictionary *param = [self obtainParams];
    [param setValue:operateType forKey:@"operateType"];
    NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderGoods/saveForAddGoods"];

    __weak typeof(self) weakSelf = self;
    [_logisticService operatePaperDetail:param withUrl:url completionHandler:^(id json) {
        [UIHelper clearChange:weakSelf.headerView];
        weakSelf.token = nil;
        weakSelf.action = ACTION_CONSTANTS_EDIT;
        weakSelf.isFirstAdd = NO;
        [weakSelf.lsHistory visibal:NO];
        [weakSelf.txtPaperNo visibal:YES];
        [weakSelf.lsSupplier editEnable:NO];
        [weakSelf configTitle:[json objectForKey:@"orderGoodsNo"]];
        [weakSelf.txtPaperNo initData:[json objectForKey:@"orderGoodsNo"]];
        weakSelf.paperId = [json objectForKey:@"orderGoodsId"];
        weakSelf.lastVer = [[json objectForKey:@"lastVer"] longValue];
        weakSelf.status = 4;
        [UIHelper refreshUI:weakSelf.headerView];
        weakSelf.mainGrid.tableHeaderView = weakSelf.headerView;
        if (weakSelf.shopMode==CLOTHESHOES_MODE) {
            [weakSelf showSelectStyleView:ACTION_CONSTANTS_ADD];
        }else{
            [weakSelf showSelectGoodsView];
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    } withMessage:message];
    
}

//商超模式
- (void)showSelectGoodsView
{
    if (self.goodList.count==200) {
        [AlertBox show:@"最多只能添加200种商品!"];
        return ;
    }
    GoodsBatchChoiceView1 *goodsView = [[GoodsBatchChoiceView1 alloc] init];
    goodsView.viewType = @"1";
    goodsView.supplyId = [self.lsSupplier getStrVal];
    goodsView.isReturn = @"2";
    if ([[Platform Instance] getShopMode] == 3) {
        goodsView.shopName = [[Platform Instance] getkey:ORG_NAME];
    }
    if (_paperType == ORDER_PAPER_TYPE) {
        goodsView.warehouseId = self.shopType==3?[self.lsReceiveWarehouse getStrVal]:@"";
    }
    if ([[Platform Instance] getShopMode] != 3) {//机构不取实际控制不能去掉 不然报错
        goodsView.getStockFlg = YES;
    }
    
    
    __weak typeof(self) weakSelf = self;
    goodsView.supplyId = self.supplyId;
    [goodsView loaddatas:self.shopId callBack:^(NSMutableArray *goodsList) {
        if (goodsList.count>0) {
            //有选择商品
            NSMutableArray *addArr = [NSMutableArray arrayWithCapacity:goodsList.count];
            for (GoodsVo* vo in goodsList) {
                BOOL flag = NO;
                BOOL isHave = NO;
                if (weakSelf.delGoodsList.count>0) {
                    //判断删除列表中是否有选择的商品
                    for (PaperDetailVo* detailVo in weakSelf.delGoodsList) {
                        if ([vo.goodsId isEqualToString:detailVo.goodsId]) {
                            flag = YES;
                            [addArr addObject:detailVo];
                            [weakSelf.delGoodsList removeObject:detailVo];
                            break;
                        }
                    }
                }
                
                if (weakSelf.goodList.count>0) {
                    //判断商品列表中是否已经存在
                    for (PaperDetailVo* detailVo in weakSelf.goodList) {
                        if ([vo.goodsId isEqualToString:detailVo.goodsId]) {
                            isHave = YES;
                            break;
                        }
                    }
                }

                if (!flag&&!isHave) {
                    //删除列表中和商品列表中都没有的商品添加
                    PaperDetailVo* detailVo = [[PaperDetailVo alloc] init];
                    detailVo.goodsId = vo.goodsId;
                    detailVo.goodsName = vo.goodsName;
                    detailVo.goodsBarcode = vo.barCode;
                    detailVo.goodsPrice = vo.purchasePrice;
                    detailVo.retailPrice = vo.retailPrice;
                    detailVo.nowStore = vo.number;
                    detailVo.goodsSum = 1;
                    detailVo.goodsTotalPrice = vo.purchasePrice;
                    detailVo.goodsRetailTotalPrice = vo.retailPrice;
                    detailVo.type = vo.type;
                    detailVo.goodsStatus = vo.upDownStatus;
                    detailVo.oldGoodsSum = 1;
                    detailVo.oldGoodsPrice = detailVo.goodsPrice;
                    detailVo.operateType = @"add";
                    detailVo.filePath = vo.filePath;
                    detailVo.changeFlag = 0;
                    [addArr addObject:detailVo];
                }
            }
            
            if ((weakSelf.goodList.count+addArr.count) > 200) {
                for (PaperDetailVo* detailVo in addArr) {
                    if ([detailVo.operateType isEqualToString:@"del"]) {
                        [weakSelf.delGoodsList addObject:detailVo];
                    }
                }
                [AlertBox show:@"最多只能添加200种商品!"];
                return ;
            }
            
            if (addArr.count>0) {
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
        [AlertBox show:@"最多只能添加200款!"];
        return ;
    }
    CloShoesEditView *cloShoesEditView = [[CloShoesEditView alloc] init];
    cloShoesEditView.supplyId = self.supplyId;
    cloShoesEditView.shopId = self.shopId;
    __weak typeof(self) weakSelf = self;
    [cloShoesEditView loadDataWithCode:self.paperDetailVo.styleCode withParam:[self obtainParams] withSourceId:self.paperId withAction:action withType:self.paperType withEdit:self.isEdit callBack:^{
        [weakSelf selectOrderPaperDetailById:weakSelf.paperId isNeedDel:nil];
    }];
    [self.navigationController pushViewController:cloShoesEditView animated:NO];
    [XHAnimalUtil animalPush:self.navigationController action:action];
    cloShoesEditView = nil;
}

#pragma mark - 单据操作
- (IBAction)typeBtnClick:(UIButton *)button {
    if (button.tag == 100) {
        //确认叫货
        if (self.isSupplyChange) {
            [AlertBox show:@"无法对其他供应商的采购单进行该操作!"];
            return;
        }
        if ([NSString isBlank:[self.lsDeliveWarehouse getStrVal]]&&(_paperType==CLIENT_ORDER_PAPER_TYPE)) {
            [AlertBox show:@"请选择发货仓库!"];
            return;
        }
        NSString *title = [NSString stringWithFormat:@"确认叫货[%@]吗?",[self.txtPaperNo getStrVal]];
        [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
            [self paperDetailGoodsDeleteCheck:@"config" action:@"采购"];
        }];
    } else if (button.tag == 101) {
        //拒绝叫货
        if (self.isSupplyChange) {
            [AlertBox show:@"无法对其他供应商的采购单进行该操作!"];
            return;
        }
        NSString *title = [NSString stringWithFormat:@"拒绝叫货[%@]吗?",[self.txtPaperNo getStrVal]];
        [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
                [self operatePaperDetail:@"refuse" withMessage:@"正在拒绝..."];
        }];
    } else if (button.tag == 102) {
        //提交
        if (![self isValide]) {
            return;
        }
        if (self.status == 4) {
            NSString *title = [NSString stringWithFormat:@"提交[%@]吗?",[self.txtPaperNo getStrVal]];
            [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
                [self paperDetailGoodsDeleteCheck:@"submit" action:@"提交"];
            }];
        } else {
            NSString *title = [NSString stringWithFormat:@"重新申请[%@]吗?",[self.txtPaperNo getStrVal]];
            [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
                [self paperDetailGoodsDeleteCheck:@"reapply" action:@"重新申请"];
            }];
        }
    } else if (button.tag == 103) {
        //删除
        NSString *title = [NSString stringWithFormat:@"删除[%@]吗?",[self.txtPaperNo getStrVal]];
        [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
              [self operatePaperDetail:@"del" withMessage:@"正在删除..."];
        }];
    }
}


#pragma mark - 删除商品
- (void)delObject:(PaperDetailVo *)item {
    self.paperDetailVo = item;
    NSString *title = [NSString stringWithFormat:@"删除[%@]吗?",item.goodsName];
    [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
            //删除商品
            [self.goodList removeObject:self.paperDetailVo];
            //将非添加的商品放入删除队列
            if (![self.paperDetailVo.operateType isEqualToString:@"add"])
            {
                self.paperDetailVo.operateType = @"del";
                self.paperDetailVo.goodsSum = 0.00;
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
        [AlertBox show:@"请选择供应商!"];
        return NO;
    }
    
    if ([NSString isBlank:[self.lsReceiveWarehouse getStrVal]]&&(_paperType==ORDER_PAPER_TYPE)&&self.isOrg) {
        [AlertBox show:@"请选择收货仓库!"];
        return NO;
    }

    return YES;
}

#pragma mark - 修改保存
- (void)save
{
    if (self.isFirstAdd) {
        if (![self isValide]) {
            return;
        }
        [self operatePaperDetail:@"add" withMessage:@"正在保存..."];
    }else{
        [self operatePaperDetail:@"edit" withMessage:@"正在保存..."];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.token = nil;
}

#pragma mark - 获取参数
- (NSMutableDictionary*)obtainParams {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    NSString* date = [self.lsDate getStrVal];
    NSString* time = [self.lsTime getStrVal];
    NSString* dateTime = [NSString stringWithFormat:@"%@ %@",date,time];
    if ([NSString isBlank:self.token]) {
        self.token = [[Platform Instance] getToken];
    }
    [param setValue:self.token forKey:@"token"];
    [param setValue:self.paperId forKey:@"orderGoodsId"];
    
    [param setValue:[NSNumber numberWithLongLong:[DateUtils formateDateTime4:dateTime]] forKey:@"sendEndTime"];
    [param setValue:self.supplyId forKey:@"supplyId"];
    [param setValue:[self.lsReceiveWarehouse getStrVal] forKey:@"inWareHouseId"];
    if (self.paperType==ORDER_PAPER_TYPE) {
        [param setValue:[NSNumber numberWithShort:1] forKey:@"type"];
    }else if (self.paperType==CLIENT_ORDER_PAPER_TYPE) {
        [param setValue:[NSNumber numberWithShort:2] forKey:@"type"];
        [param setValue:[self.lsDeliveWarehouse getStrVal] forKey:@"outWareHouseId"];
    }
    
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

//获取商品列表
- (NSMutableArray *)obtainGoodsList {
    NSMutableArray *goodsList = [NSMutableArray array];
    if (self.delGoodsList.count>0) {
        [goodsList addObjectsFromArray:self.delGoodsList];
    }
    [goodsList addObjectsFromArray:self.goodList];
    return goodsList;
}

#pragma mark - 单据详情编辑、删除、提交
// 提交
- (void)operatePaperDetail:(NSString *)operateType withMessage:(NSString*)message
{
    NSMutableDictionary* param = [self obtainParams];
    if (self.shopMode==SUPERMARKET_MODE) {
        [param setValue:[PaperDetailVo converToDicArr:[self obtainGoodsList] paperType:self.paperType] forKey:@"orderGoodsList"];
    }
    [param setValue:operateType forKey:@"operateType"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderGoods/save"];
    __weak typeof(self) weakSelf = self;
    [_logisticService operatePaperDetail:param withUrl:url completionHandler:^(id json) {
        [weakSelf removeNotification];
        weakSelf.token = nil;
        if (weakSelf.flg==ACTION_CONSTANTS_ADD) {
             weakSelf.orderPaperHandler(nil,ACTION_CONSTANTS_ADD);
        }else if ([operateType isEqualToString:@"edit"]){
            if (weakSelf.isSupplyChange) {
                weakSelf.orderPaperHandler(weakSelf.paperVo,ACTION_CONSTANTS_DEL);
            }else{
                weakSelf.orderPaperHandler(weakSelf.paperVo,ACTION_CONSTANTS_EDIT);
            }
        }else if ([operateType isEqualToString:@"del"]){
            weakSelf.orderPaperHandler(weakSelf.paperVo,ACTION_CONSTANTS_DEL);
        }else if ([operateType isEqualToString:@"submit"]){
            
//            dispatch_time_t timeBegain = dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC);
//            dispatch_after(timeBegain, dispatch_get_main_queue(), ^{
                weakSelf.paperVo.billStatus = 1;
                weakSelf.orderPaperHandler(weakSelf.paperVo,ACTION_CONSTANTS_EDIT);
//            });

        }else if ([operateType isEqualToString:@"config"]){
            weakSelf.paperVo.billStatus = 2;
            weakSelf.orderPaperHandler(weakSelf.paperVo,ACTION_CONSTANTS_EDIT);
        }else if ([operateType isEqualToString:@"refuse"]){
            weakSelf.paperVo.billStatus = 3;
            weakSelf.orderPaperHandler(weakSelf.paperVo,ACTION_CONSTANTS_EDIT);
        }else if ([operateType isEqualToString:@"reapply"]){
            weakSelf.paperVo.billStatus = 4;
            weakSelf.orderPaperHandler(weakSelf.paperVo,ACTION_CONSTANTS_EDIT);
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    } withMessage:message];
}

// 进行提交和重新申请提交前check 单子中的商品 删除状况
- (void)paperDetailGoodsDeleteCheck:(NSString *)opType action:(NSString *)actionName {
   
    __weak typeof(self) wself = self;
    NSArray *array = [[PaperDetailVo converToDicArr:[self obtainGoodsList] paperType:self.paperType] copy];
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 102) {
        NSString *url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"orderGoods/checkGoods"];
        [_logisticService checkPaperDetailGoods:url params:@{@"orderGoodsList":array} completionHandler:^(id json) {
            
            NSString *code = json[@"code"];
            if (code) {
                if ([code isEqualToString:@"MS_MSI_000004"]) {
                    [LSAlertHelper showAlert:[NSString stringWithFormat:@"所有商品已被删除，无法%@!",actionName]];
                } else if ([code isEqualToString:@"MS_MSI_000005"]) {
                    [LSAlertHelper showAlert:[NSString stringWithFormat:@"存在商品已被删除，操作将对这部分商品无效，确认%@吗？",actionName] block:nil block:^{
                        
                        if ([opType isEqualToString:@"submit"]) {
                                [wself operatePaperDetail:opType withMessage:@"正在提交..."];
                        } else if ([opType isEqualToString:@"reapply"]) {
                                [wself operatePaperDetail:opType withMessage:@"正在重新申请..."];
                        } else if ([opType isEqualToString:@"config"]) {
                            [wself operatePaperDetail:opType withMessage:@"正在确认..."];
                        }
                    }];
                }
            } else if ([json[@"returnCode"] isEqualToString:@"success"]) {
                
                if ([opType isEqualToString:@"submit"]) {
                    [wself operatePaperDetail:opType withMessage:@"正在提交..."];
                } else if ([opType isEqualToString:@"reapply"]) {
                    [wself operatePaperDetail:opType withMessage:@"正在重新申请..."];
                } else if ([opType isEqualToString:@"config"]) {
                    [wself operatePaperDetail:opType withMessage:@"正在确认..."];
                }
            }
            
        } errorHandler:^(id json) {
            
            [LSAlertHelper showAlert:json];
            
        } withMessage:@""];
    } else {
        if ([opType isEqualToString:@"submit"]) {
            [wself operatePaperDetail:opType withMessage:@"正在提交..."];
        } else if ([opType isEqualToString:@"reapply"]) {
            [wself operatePaperDetail:opType withMessage:@"正在重新申请..."];
        } else if ([opType isEqualToString:@"config"]) {
            [wself operatePaperDetail:opType withMessage:@"正在确认..."];
        }
    }
    
}

@end
