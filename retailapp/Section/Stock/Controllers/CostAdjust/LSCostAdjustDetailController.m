//
//  LSCostAdjustDetailController.m
//  retailapp
//
//  Created by hm on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSCostAdjustDetailController.h"
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
#import "StockAdjustVo.h"
#import "StockAdjustDetailVo.h"
#import "AdjustGoodsEditView.h"
#import "PaperGoodsVo.h"
#import "GoodsBatchChoiceView1.h"
#import "GoodsVo.h"
#import "LSCostAdjustStyleEditViewController.h"
#import "SelectStoreListView.h"
#import "LSDealRecordController.h"
#import "LSCostAdjustVo.h"
#import "LSDealRecordVo.h"
#import "LSSCCostAdjustDetailCell.h"
#import "LSCostAdjustDetailVo.h"
#import "LSCostGoodsEditViewController.h"
#import "LSFXCostAdjustDetailCell.h"
#define Notification_UI_Change_STOCK_ADJUST @"Notification_UI_Change_STOCK_ADJUST"
@interface LSCostAdjustDetailController ()<IEditItemListEvent,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) LSEditItemTitle *baseTitle;
@property (nonatomic, strong) LSEditItemText *txtNo;
/** 调整单状态 */
@property (nonatomic, strong) LSEditItemView *vewStatus;
@property (nonatomic, strong) LSEditItemView *vewShop;
@property (nonatomic, strong) LSEditItemText *txtMemo;
@property (nonatomic, strong) LSEditItemTitle *goodsTitle;
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
/**门店|仓库名称*/
@property (nonatomic, copy) NSString *shopName;
/**商品列表展示模式*/
@property (nonatomic,assign) NSInteger mode;
@property (nonatomic, strong) NSString *costShopId;/**<首次添加商品时返回，提交check时需要>*/
/**页面回调block*/
@property (nonatomic,copy)  CallBlock callBlock;
/**页面是否可编辑*/
@property (nonatomic,assign) BOOL isEdit;
/**是否第一次添加*/
@property (nonatomic,assign) BOOL isFirstAdd;
/**是否第一次添加保存后退出页面*/
@property (nonatomic,assign) BOOL isSave;
/**是否折叠基本信息*/
@property (nonatomic,assign) BOOL isFold;
/**调整详情商品模型*/
@property (nonatomic,strong) LSCostAdjustDetailVo *costAdjustDetailVo;
/**调整原因*/
@property (nonatomic, copy) NSString *adjustReason;
/**唯一性*/
@property (nonatomic,copy) NSString *token;
@property (weak, nonatomic) IBOutlet UIButton *btnRefuse;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;
/** 处理记录 */
@property (nonatomic, strong) NSArray *dealRecords;
/** 是否是添加调整单操作 */
@property (nonatomic, assign) BOOL isAdd;
/** 门店Id用来区分添加的商品 */
@property (nonatomic, copy) NSString *shopId;
@end

@implementation LSCostAdjustDetailController

- (instancetype)initWithAction:(int)action costAdjustVo:(LSCostAdjustVo *)costAdjustVo hasCostAdjust:(BOOL)hasCostAdjust CallBlock:(CallBlock)callBlock {
    if (self = [super init]) {
        self.callBlock = callBlock;
        self.action = action;
        //是否有成本价调整的权限
        self.costAdjustVo = costAdjustVo;
        self.hasCostAdjust = ![[Platform Instance] lockAct: ACTION_COST_PRICE_BILLS_CHECK];
        //在未提交状态下可编辑，在待确认状态下，若拥有“成本价调整单确认”权限可编辑
         self.isEdit = self.costAdjustVo.billsStatus == 1 || action == ACTION_CONSTANTS_ADD || (self.costAdjustVo.billsStatus == 2 && self.hasCostAdjust);
         self.shopId = [[Platform Instance] getkey:SHOP_ID];

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    self.stockService = [ServiceFactory shareInstance].stockService;
    [self configTitle];
    [self configDatas];
    [self setupHeaderView];
    [self registerNotification];
    [self showHeaderView];
    [self showFooterView];
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self clearDo];
    }else{
        [self loadData];
    }
    [UIHelper clearColor:self.footerView];
}

- (void)configDatas {
    self.goodsList = [NSMutableArray array];
    self.delList = [NSMutableArray array];
}

- (void)configViews {
     self.mainGrid.frame = CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH);
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
    
    self.vewShop = [LSEditItemView editItemView];
    [_headerView addSubview:self.vewShop];
    
    
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
    
    
    __weak typeof(self) wself = self;
    [self.baseTitle configTitle:@"基本信息" type:LSEditItemTitleTypeOpen rightClick:^(LSEditItemTitle *view) {
        wself.isFold = !wself.isFold;
        [wself showHeaderView];
    }];
    [self.txtNo initLabel:@"调整单号" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtNo editEnabled:NO];
    [self.vewShop initLabel:@"机构" withHit:nil];
    [self.txtMemo initLabel:@"备注" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtMemo initMaxNum:100];
    [self.goodsTitle configTitle:@"调整商品" type:LSEditItemTitleTypeDown rightClick:^(LSEditItemTitle *view) {
        float cHeight = self.mainGrid.contentSize.height;
        float mHeight = self.mainGrid.bounds.size.height;
        if (cHeight>mHeight) {
            [wself.mainGrid setContentOffset:CGPointMake(0, cHeight - mHeight) animated:YES];
        }
    }];
    
    [UIHelper refreshUI:_headerView];

}
#pragma mark - 初始化导航栏
- (void)configTitle {
    if (self.action == ACTION_CONSTANTS_ADD) {
        [self configTitle:@"添加成本价调整单" leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
    } else {
         [self configTitle:self.costAdjustVo.costPriceOpNo leftPath:Head_ICON_BACK rightPath:nil];
    }
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
    if (event == LSNavigationBarButtonDirectLeft) {
        if (self.isAdd) {
            self.callBlock(nil,ACTION_CONSTANTS_ADD);
        }
        [self popViewController];
    }else{
        [self save];
    }

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


#pragma mark - 加载页面数据
- (void)loadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.costAdjustVo.costPriceOpNo forKey:@"costPriceOpNo"];
    NSString *url = @"costPriceOpBills/detail";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        wself.costAdjustVo = [LSCostAdjustVo objectWithKeyValues:json[@"costPriceOpBillsVo"]];
        wself.shopId = wself.costAdjustVo.shopOrOrgId;
        wself.dealRecords = [LSDealRecordVo dealRecordVoWithArray:json[@"billsOpLogVoList"]];
        wself.goodsList = [NSMutableArray arrayWithArray:[LSCostAdjustDetailVo objectArrayWithKeyValuesArray:json[@"costPriceOpDetailVoList"]]];
        if ([ObjectUtil isEmpty:wself.dealRecords]) {//老数据有可能没有处理记录需要做一下兼容
            [wself.lstDealRecord visibal:NO];
        }
        //调整单号
        [wself.txtNo initData:wself.costAdjustVo.costPriceOpNo];
        //调整单状态
        [wself.vewStatus initData:wself.costAdjustVo.billStatusName];
//        wself.vewStatus.lblVal.textColor = wself.costAdjustVo.billStatusColor;
        //门店/机构
        [wself.vewShop initData:wself.costAdjustVo.shopName];
        if (wself.costAdjustVo.shopType == 1) {//门店
            [wself.vewShop initLabel:@"门店" withHit:nil];
        } else {//机构
            [wself.vewShop initLabel:@"机构" withHit:nil];
        }
        //备注
        [wself.txtMemo initData:wself.costAdjustVo.memo];
        [UIHelper refreshUI:wself.headerView];
        [wself.mainGrid reloadData];
        [wself statisticsData];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}
#pragma mark - 显示视图
//显示基本信息项
- (void)showHeaderView {
    [self.txtNo visibal:(self.action==ACTION_CONSTANTS_EDIT && !_isFold)];
    [self.vewStatus visibal:(self.action==ACTION_CONSTANTS_EDIT && !_isFold)];
    [self.lstDealRecord visibal:(self.action==ACTION_CONSTANTS_EDIT) && !_isFold];
    [self.vewShop visibal:([[Platform Instance] getShopMode] == 3 && self.action==ACTION_CONSTANTS_EDIT && !_isFold)];
    //备注：初始默认“可不填”，在未提交状态下可编辑，在待确认状态下，若拥有“成本价调整单确认”权限可编辑
    [self.txtMemo visibal:!_isFold];
    //在未提交状态下可编辑，在待确认状态下，若拥有“成本价调整单确认”权限可编辑
    [self.txtMemo editEnabled:(self.costAdjustVo.billsStatus == 1 || self.action == ACTION_CONSTANTS_ADD)];
    if (!(self.costAdjustVo.billsStatus == 1 || self.action == ACTION_CONSTANTS_ADD)) {
        self.txtMemo.txtVal.placeholder = @"";
    }
    [UIHelper refreshUI:self.headerView];
    self.mainGrid.tableHeaderView = self.headerView;
}

//显示底部按钮
- (void)showFooterView
{
    /*【提交】按钮提交】按钮
    单店模式：非表示
    连锁模式： 调整单状态是“未提交”时，判断调整项数量，若调整项大于0时表示，若调整项为0时不表示
    【删除】按钮
    状态是“未提交”时表示
    【确认调整】 按钮
    单店模式：调整单状态是“未提交”，判断登录者角色权限，若拥有“成本价调整单确认”权限则表示，若没有则不表示
    连锁模式：调整单状态是“待确认”时，根据登录者角色权限判断是否可表示
    如果调整商品一览明细中的商品被全部删除时，不表示
    盘点店铺是否在盘点中，若在盘点中，报错：库存正在盘点中，无法进行该操作！—— 补充于2017/4/6
    【拒绝调整】 按钮
    单店模式：非表示
    连锁模式：调整单状态是“待确认”时，根据登录者角色权限判断是否可表示*/
    //只有未提交和待确认时显示添加按钮并且有库存调整的权限
    //添加调整商品按钮   1.添加模式时，表示
//    2.编辑模式时，调整单状态是“未提交”时表示
//    3.调整单状态是“待确认”时，根据登录者角色权限判断是否可表示（有“库存调整权限”时表示）
    int billStatus = self.costAdjustVo.billsStatus;
    self.addView.hidden = !(self.isEdit);
    self.subView.hidden = !(billStatus == 1 && self.goodsList.count>0);
    self.delView.hidden = !(billStatus == 1);
    self.conView.hidden = !(billStatus == 2 && self.hasCostAdjust && self.goodsList.count > 0);
    __weak typeof(self) wself = self;
    if (billStatus == 2 && self.hasCostAdjust && self.goodsList.count == 0) {
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
    if ([[Platform Instance] getShopMode] == 1) {
        [self.subBtn setTitle:@"确认调整" forState:UIControlStateNormal];
        if (!self.hasCostAdjust) {//成本价调整权限关闭时确认调整按钮不显示
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
- (void)clearDo {
    self.isFirstAdd = YES;
    [self statisticsData];
}


#pragma mark - 查询调整单详情
- (void)selectAdjustGoodsList:(NSString*)adjustCode
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.costAdjustVo.costPriceOpNo forKey:@"costPriceOpNo"];
    NSString *url = @"costPriceOpBills/detail";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        wself.goodsList = [NSMutableArray arrayWithArray:[LSCostAdjustDetailVo objectArrayWithKeyValuesArray:json[@"costPriceOpDetailVoList"]]];
        [wself.mainGrid reloadData];
        [wself statisticsData];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];


}


#pragma mark - 统计数量和金额
- (void)statisticsData
{
    NSInteger num = self.goodsList.count;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"本次调整合计 "];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%tu ",num] attributes:@{NSForegroundColorAttributeName : [ColorHelper getRedColor]}]];
     [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"项" attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}]];
    self.lblTotal.attributedText = attrString;
    [self showFooterView];
}

#pragma mark - IEditItemListEvent
- (void)onItemListClick:(LSEditItemList *)obj {
    if (obj == self.lstDealRecord) {//处理记录
       LSDealRecordController *vc = [[LSDealRecordController alloc] initWithDealRecords:self.dealRecords];
       [self pushViewController:vc];
   }
}




#pragma mark -PaperGoodsCellDelegate协议
//改变导航栏状态
- (void)changeNavigateUI
{
    __block BOOL flag =NO;
    [self.goodsList enumerateObjectsUsingBlock:^(LSCostAdjustDetailVo *obj, NSUInteger idx, BOOL *stop) {
//        if (vo.changeFlag==1||[vo.operateType isEqualToString:@"add"]||vo.reasonFlag==1) {
//            flag = YES;
//            *stop = YES;
//        }
        if ([obj.operateType isEqualToString:@"add"] || obj.isShow) {
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
    LSCostAdjustDetailVo *obj = self.goodsList[indexPath.row];
    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue]==101) {
        LSFXCostAdjustDetailCell *cell = [LSFXCostAdjustDetailCell costAdjustDetailCellWithTableView:tableView];
        cell.obj = obj;
        return cell;
    }else{
        __weak typeof(self) wself = self;
        LSSCCostAdjustDetailCell *cell = [LSSCCostAdjustDetailCell costAdjustDetailCellWithTableView:tableView];
        [cell setObj:obj isEdit:self.isEdit callBlock:^{//修改成本价的时候调用
            [wself changeNavigateUI];
        }];
        return cell;

    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.costAdjustDetailVo = [self.goodsList objectAtIndex:indexPath.row];
    LSCostAdjustDetailVo *obj = self.goodsList[indexPath.row];
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
        //查看服鞋款式详情
        [self showSelectStyleView:ACTION_CONSTANTS_EDIT];
    }else{
       //查看商超商品详情
        LSCostGoodsEditViewController *vc = [[LSCostGoodsEditViewController alloc] init];
        __weak typeof(self) wself = self;
        [vc loadDataWithVo:obj withEdit:self.isEdit callBack:^(LSCostAdjustDetailVo *item, NSInteger action) {
            if (action==ACTION_CONSTANTS_DEL) {
                if (![item.operateType isEqualToString:@"add"]) {
                    item.operateType = @"del";
                    [wself.delList addObject:item];
                }
                [wself.goodsList removeObject:item];
            }
            [wself changeNavigateUI];
            [wself.mainGrid reloadData];
        }];
        [self pushViewController:vc];
    }
    
}


#pragma mark - 添加商品
- (IBAction)onAddEventClick:(id)sender {
    [SystemUtil hideKeyboard];
    if (self.isFirstAdd) {
        [UIHelper clearChange:self.headerView];
        [self saveForFirstAdd];
    }else{
        if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {
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
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[[Platform Instance] getkey:SHOP_ID] forKey:@"shopId"];
    [param setValue:[self.txtMemo getStrVal] forKey:@"memo"];
    //shopType 门店/机构 1：门店/单店 2：机构
    int shopType = [[Platform Instance] getShopMode] == 3 ? 2 : 1;
    [param setValue:@(shopType) forKey:@"shopType"];
    [param setValue:self.token forKey:@"token"];
    NSString *url = @"costPriceOpBills/save";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        wself.dealRecords = [LSDealRecordVo dealRecordVoWithArray:json[@"billsOpLogVoList"]];
        wself.isAdd = YES;
        wself.token = nil;
        wself.action = ACTION_CONSTANTS_EDIT;
        wself.isFirstAdd = NO;
        wself.costAdjustVo = [[LSCostAdjustVo alloc] init];
        wself.costAdjustVo.billsStatus = 1;
        wself.costAdjustVo.costPriceOpNo = [json objectForKey:@"costPriceOpNo"];
        wself.costShopId = [json objectForKey:@"costShopId"];
        wself.costAdjustVo.lastVer = json[@"lastVer"];
        [wself.txtNo visibal:YES];
        [wself.lstDealRecord visibal:YES];
        [wself configTitle:wself.costAdjustVo.costPriceOpNo];
        [wself.txtNo initData:wself.costAdjustVo.costPriceOpNo];
        [wself.vewStatus initData:@"未提交"];
        [wself.vewStatus visibal:YES];
//        wself.vewStatus.lblVal.textColor = [ColorHelper getBlueColor];
        [UIHelper clearChange:wself.headerView];
        [UIHelper refreshUI:wself.headerView];
        wself.mainGrid.tableHeaderView = wself.headerView;
        wself.isEdit = self.costAdjustVo.billsStatus == 1 || wself.action == ACTION_CONSTANTS_ADD || (self.costAdjustVo.billsStatus == 2 && wself.hasCostAdjust);
        [UIHelper clearChange:wself.headerView];
        if (wself.isSave) {
            wself.callBlock(nil,ACTION_CONSTANTS_ADD);
            [wself popViewController];
        }else{
            if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {
                [wself showSelectStyleView:ACTION_CONSTANTS_ADD];
            }else{
                [wself showSelectGoodsView];
            }
        }
        [wself statisticsData];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}

//服鞋商品详情
- (void)showSelectStyleView:(int)action
{
    if (action == ACTION_CONSTANTS_ADD) {
        if (self.goodsList.count==200) {
            [LSAlertHelper showAlert:@"最多只能添加200款商品!"];
            return ;
        }
    }
    __weak typeof(self) wself = self;
    LSCostAdjustStyleEditViewController *vc = [[LSCostAdjustStyleEditViewController alloc] initWithShopId:self.shopId obj:self.costAdjustVo costAdjustDetailVo:self.costAdjustDetailVo action:action isEdit:self.isEdit callBlock:^{
        [wself selectAdjustGoodsList:wself.costAdjustVo.costPriceOpNo];
    }];
    [self pushViewController:vc];
}

#pragma mark - 添加商超商品
- (void)showSelectGoodsView
{
    if (self.goodsList.count == 200) {
        [LSAlertHelper showAlert:@"最多只能添加200种商品!"];
        return ;
    }
    //门店添加的成本价调整单 总部进行修改 如果修改的是门店添加的调整单 则该调整单只能添加门门店的调整单
    //门店A添加一个调整单是待确认状态 总部对这个调整单进行修改 该调整单只能添加门店A的商品
    GoodsBatchChoiceView1 *goodsView = [[GoodsBatchChoiceView1 alloc] init];
    goodsView.mode = 2;
    //商品且过滤拆分组装加工
    goodsView.validTypeList = [NSMutableArray arrayWithObjects:@"1", @"4", nil];
    __weak typeof(self) weakSelf = self;
    [goodsView loaddatas:self.shopId callBack:^(NSMutableArray *goodsList) {
         if (goodsList.count>0) {
             //有选择商品
             NSMutableArray *addArr = [NSMutableArray arrayWithCapacity:goodsList.count];
            for (GoodsVo* vo in goodsList) {
                BOOL flag = NO;
                BOOL isHave = NO;
                if (weakSelf.delList.count>0) {
                    //添加删除队列中存在的商品
                    for (LSCostAdjustDetailVo * obj in weakSelf.delList) {
                        if ([vo.goodsId isEqualToString:obj.goodsId]) {
                            flag = YES;
                            [addArr addObject:obj];
                            [weakSelf.delList removeObject:obj];
                            break;
                        }
                    }
                }
                if (weakSelf.goodsList.count>0) {
                    //已经存在的商品不添加
                    for (LSCostAdjustDetailVo *obj in weakSelf.goodsList) {
                        if ([vo.goodsId isEqualToString:obj.goodsId]) {
                            isHave = YES;
                            break;
                        }
                    }
                }
                if (!flag&&!isHave) {
                    //添加不存在以上两种情况的商品
                    LSCostAdjustDetailVo *obj = [[LSCostAdjustDetailVo alloc] init];
                    obj.goodsId = vo.goodsId;
                    obj.goodsName = vo.goodsName;
                    obj.barCode = vo.barCode;
                    obj.nowStore = vo.nowStore.doubleValue;
                    obj.retailPrice = vo.retailPrice;
                    obj.goodsType = vo.type;
                    obj.goodsStatus = vo.upDownStatus;
                    obj.filePath = vo.filePath;
                    obj.beforeCostPrice = vo.powerPrice.doubleValue;
                    obj.laterCostPrice = vo.powerPrice.doubleValue;
                    obj.operateType  = @"add";
                    [addArr addObject:obj];
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
                 for (LSCostAdjustDetailVo *obj in addArr) {
                     if ([obj.operateType isEqualToString:@"del"]) {
                         obj.operateType = @"edit";
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
    [SystemUtil hideKeyboard];
    // 单店    
    if ([[Platform Instance] getShopMode] == 1) {
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
     [SystemUtil hideKeyboard];
    NSString *title = [NSString stringWithFormat:@"确认调整[%@]吗?",[self.txtNo getStrVal]];
    [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"]
                selectdblock:^(NSInteger index) {
                    [self paperDetailGoodsDeleteCheck:3 actionName:@"确认调整"];
    }];
}

#pragma mark - 拒绝调整
- (IBAction)onRefEventClick:(id)sender
{
     [SystemUtil hideKeyboard];
    NSString *title = [NSString stringWithFormat:@"拒绝调整[%@]吗?",[self.txtNo getStrVal]];
    [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"]
                selectdblock:^(NSInteger index) {
                    [self operatePaperByType:4 withMessage:@"正在拒绝..."];
    }];
}

#pragma mark - 删除调整单
- (IBAction)onDelEventClick:(id)sender
{
    [SystemUtil hideKeyboard];
    __weak typeof(self) wself = self;
    NSString *title = [NSString stringWithFormat:@"删除调整单[%@]吗?",[self.txtNo getStrVal]];
    [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"]
                selectdblock:^(NSInteger index) {
                   
                    wself.token = wself.token?:[[Platform Instance] getToken];
                    NSMutableDictionary *param = [NSMutableDictionary dictionary];
                    [param setValue:self.costAdjustVo.costPriceOpNo forKey:@"costPriceOpNo"];
                    NSString *url = @"costPriceOpBills/delete";
                    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
                        wself.token = nil;
                        wself.callBlock(wself.costAdjustVo,ACTION_CONSTANTS_DEL);
                        [wself popViewController];
                    } errorHandler:^(id json) {
                        [LSAlertHelper showAlert:json];
                    }];
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

#pragma mark - 新增修改调整单商品,以及拒绝、确认调整单等操作
- (void)operatePaperByType:(short)opType withMessage:(NSString *)message
{
    
    if ([NSString isBlank:self.token]) {
        self.token = [[Platform Instance] getToken];
    }
    short modifyStatus = [[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101?1:0;
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSMutableArray *keyValuesList = [NSMutableArray array];
    for (LSCostAdjustDetailVo *obj in [self obtainGoodsList]) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        //调整原因
        [param setValue:obj.adjustReason forKey:@"adjustReason"];
        //调整前成本价
        [param setValue:@(obj.beforeCostPrice) forKey:@"beforeCostPrice"];
        //商品ID
        [param setValue:obj.goodsId forKey:@"goodsId"];
        //商品类型
        [param setValue:@(obj.goodsType) forKey:@"goodsType"];
        //调整后成本价
        [param setValue:@(obj.laterCostPrice) forKey:@"laterCostPrice"];
        //操作类型 add:新增 edit:编辑 del:删除
        [param setValue:obj.operateType forKey:@"operateType"];
        [keyValuesList addObject:param];
    }
    //调整商品
    [param setValue:keyValuesList forKey:@"costPriceOpDetailList"];
    //成本价调整单号
    [param setValue:self.costAdjustVo.costPriceOpNo forKey:@"costPriceOpNo"];
    //版本号
    [param setValue:self.costAdjustVo.lastVer forKey:@"lastVer"];
    //备注
    [param setValue:[self.txtMemo getStrVal] forKey:@"memo"];
    //是否仅改变状态
    [param setValue:@(modifyStatus) forKey:@"modifyStatusOnly"];
    //1:保存 2:提交 3:确认 4:拒绝
    [param setValue:@(opType) forKey:@"opType"];
    [param setValue:self.costAdjustVo.shopOrOrgId forKey:@"shopOrOrgId"];
    //门店/机构 1：门店 2：机构
    [param setValue:@(self.costAdjustVo.shopType) forKey:@"shopType"];
    //款式ID(保存款式信息传入，其他为null)
    [param setValue:self.costAdjustVo.styleId forKey:@"styleId"];
    
    NSString *url = @"costPriceOpBills/saveCostPriceOpDetail";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:message show:YES CompletionHandler:^(id json) {
        wself.token = nil;
        //取最新操作日期
        wself.costAdjustVo.createTime = @([[NSDate date] timeIntervalSince1970] * 1000);
        if (wself.isAdd) {
            weakSelf.callBlock(nil,ACTION_CONSTANTS_ADD);
        }else if (opType == 1){
            wself.costAdjustVo.opName = [[Platform Instance] getkey:EMPLOYEE_NAME];
            wself.costAdjustVo.opStaffId = [[Platform Instance] getkey:STAFF_ID];
            weakSelf.callBlock(wself.costAdjustVo,ACTION_CONSTANTS_EDIT);
        }else if (opType == 2){
            weakSelf.costAdjustVo.billsStatus = 2;
            weakSelf.callBlock(wself.costAdjustVo,ACTION_CONSTANTS_EDIT);
        }else if (opType == 3){
            weakSelf.costAdjustVo.billsStatus = 3;
            weakSelf.callBlock(wself.costAdjustVo,ACTION_CONSTANTS_EDIT);
        }else if (opType == 4){
            weakSelf.costAdjustVo.billsStatus = 4;
            weakSelf.callBlock(wself.costAdjustVo,ACTION_CONSTANTS_EDIT);
        }
        [wself popViewController];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}


#pragma mark - 保存
- (void)save {
    if (self.isFirstAdd) {
        self.isSave = YES;
        [self saveForFirstAdd];
    }else{
        [self operatePaperByType:1 withMessage:@"正在保存..."];
    }
}


// 进行提交和重新申请提交前check 单子中的商品 删除状况
- (void)paperDetailGoodsDeleteCheck:(NSInteger)opType actionName:(NSString *)actionName {
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 102) {
        __weak typeof(self) wself = self;
        NSMutableArray *keyValuesList = [NSMutableArray array];
        for (LSCostAdjustDetailVo *obj in [self obtainGoodsList]) {
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            //调整原因
            [param setValue:obj.adjustReason forKey:@"adjustReason"];
            //调整前成本价
            [param setValue:@(obj.beforeCostPrice) forKey:@"beforeCostPrice"];
            //商品ID
            [param setValue:obj.goodsId forKey:@"goodsId"];
            //商品类型
            [param setValue:@(obj.goodsType) forKey:@"goodsType"];
            //调整后成本价
            [param setValue:@(obj.laterCostPrice) forKey:@"laterCostPrice"];
            //操作类型 add:新增 edit:编辑 del:删除
            [param setValue:obj.operateType forKey:@"operateType"];
            [keyValuesList addObject:param];
        }
        NSString *url = @"costPriceOpBills/checkGoods";
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:keyValuesList forKey:@"costPriceOpDetailList"];
        // shopOrOrgId只是编辑时有值
        [param setValue:self.costAdjustVo.shopOrOrgId forKey:@"shopOrOrgId"];
        [param setValue:self.costShopId forKey:@"adjustShopId"];
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
            [self operatePaperByType:opType withMessage:@"正在提交..."];
        } else {
            [self operatePaperByType:opType withMessage:@"正在确认..."];
        }
    }
}

@end
