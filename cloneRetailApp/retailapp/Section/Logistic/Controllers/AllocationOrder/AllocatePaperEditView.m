//
//  AllocatePaperEditView.m
//  retailapp
//
//  Created by hm on 15/10/31.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//
#define kCountName @"数量"
#define kCountVal @"0"
#import "AllocatePaperEditView.h"
#import "LogisticModuleEvent.h"
#import "ServiceFactory.h"
#import "UIHelper.h"
#import "ColorHelper.h"
#import "DateUtils.h"
#import "AlertBox.h"
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
#import "PaperVo.h"
#import "NameItemVO.h"
#import "HistoryPaperListView.h"
#import "GoodsDetailEditView.h"
#import "SelectShopListView.h"
#import "CloShoesEditView.h"
#import "GoodsBatchChoiceView1.h"
#import "GoodsVo.h"

@interface AllocatePaperEditView ()<IEditItemListEvent,DatePickerClient,TimePickerClient,OptionPickerClient,PaperCellGoodsDelagate>
@property (nonatomic,strong) LogisticService  * logisticService;
@property (nonatomic,copy  ) NSString         * paperId;
@property (nonatomic,assign) long             lastVer;
@property (nonatomic,assign) NSInteger        paperType;
@property (nonatomic,assign) NSInteger        action;
@property (nonatomic,assign) BOOL             isEdit;
@property (nonatomic,assign) short            status;
@property (nonatomic,copy  ) EditAllocatePaperHandler paperBlock;
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
/**是否启用装箱单*/
@property (nonatomic,assign) BOOL             isOpenPickBox;
/**是否第三方供应商 1是 0否*/
@property (nonatomic,assign) BOOL             isThirdSupplier;
/**是否是第一次添加*/
@property (nonatomic,assign) BOOL             isFirstAdd;
/**调出门店shopId*/
@property (nonatomic,copy  ) NSString         * shopId;
/**唯一性*/
@property (nonatomic,copy) NSString *token;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintAddView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConatraintCrView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConatraintAlView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConatraintSubView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConatraintDelView;
@end

@implementation AllocatePaperEditView


- (void)viewDidLoad {
    [super viewDidLoad];
    _logisticService = [ServiceFactory shareInstance].logisticService;
    self.mainGrid.frame = CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH);
    [self initNavigate];
    [self configHeaderView];
    [self initMainView];
    self.goodList = [NSMutableArray array];
    self.delGoodsList = [NSMutableArray array];
    [self loadData];
}

- (void)configHeaderView {
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 100)];
    self.baseTitle = [LSEditItemTitle editItemTitle];
    [self.headerView addSubview:self.baseTitle];
    
    self.txtPaperNo = [LSEditItemText editItemText];
    [self.headerView addSubview:self.txtPaperNo];
    
    self.lsOutShop = [LSEditItemList editItemList];
    [self.headerView addSubview:self.lsOutShop];
    
    self.lsInShop = [LSEditItemList editItemList];
    [self.headerView addSubview:self.lsInShop];
    
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

#pragma mark - 初始化导航
- (void)initNavigate
{
    [self configTitle:@"" leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event
{
    if (event==LSNavigationBarButtonDirectLeft) {
        //返回前一页面
        [self removeNotification];
        if (!self.isFirstAdd&&self.action==ACTION_CONSTANTS_ADD) {
            self.paperBlock(nil,ACTION_CONSTANTS_ADD);
        }
        [XHAnimalUtil animalEdit:self.navigationController action:_action];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        //页面保存
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
    
    
    [self.txtPaperNo initLabel:@"调拨单号" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    self.txtPaperNo.txtVal.enabled = NO;
    self.txtPaperNo.txtVal.textColor = [UIColor darkGrayColor];
    
    [self.lsOutShop initLabel:@"调出门店" withHit:nil isrequest:YES delegate:self];
    [self.lsOutShop.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    
    [self.lsInShop initLabel:@"调入门店" withHit:nil isrequest:YES delegate:self];
    [self.lsInShop.imgMore setImage:[UIImage imageNamed:@"ico_next.png"]];
    
    [self.lsDate initLabel:@"调拨日期" withHit:nil isrequest:YES delegate:self];
    
    [self.lsTime initLabel:@"调拨时间" withHit:nil isrequest:YES delegate:self];
    
    [self.txtMemo initLabel:@"备注" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtMemo initMaxNum:100];
    [self.goodsTitle configTitle:@"调拨商品" type:LSEditItemTitleTypeDown rightClick:^(LSEditItemTitle *view) {
        float cHeight = self.mainGrid.contentSize.height;
        float mHeight = self.mainGrid.bounds.size.height;
        if (cHeight>mHeight) {
            [wself.mainGrid setContentOffset:CGPointMake(0, cHeight - mHeight) animated:YES];
        }
    }];
    [self.lsMode initLabel:@"展示内容" withHit:nil delegate:self];
    
    self.lsOutShop.tag = OUT_SHOP;
    self.lsInShop.tag = IN_SHOP;
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
    [self.lsOutShop editEnable:NO];
    [self.lsInShop editEnable:(self.action==ACTION_CONSTANTS_ADD)];
    [self.lsDate editEnable:isEdit];
    [self.lsTime editEnable:isEdit];
    [self.txtMemo editEnabled:isEdit];
    if (!isEdit) {
        self.txtMemo.txtVal.placeholder = @"";
    }
    [self.lsMode visibal:self.shopMode==SUPERMARKET_MODE&&(self.status==5||self.action==ACTION_CONSTANTS_ADD)];
}

- (void)showFooterView:(NSInteger)action isEdit:(BOOL)isEdit
{
    self.addView.hidden = !isEdit;
    self.crView.hidden = !((_status==1&&[[self.lsInShop getStrVal] isEqualToString:[[Platform Instance] getkey:SHOP_ID]]));
    self.alView.hidden = !(_status==4&&_isOrg&&![[Platform Instance] lockAct:ACTION_STOCK_ALLOCATE_CHECK]);
    self.subView.hidden = !(_status==5&&self.goodList.count>0);
    self.delView.hidden = !(_status==5);
    self.sumView.hidden = !(self.goodList.count>0);
    
    self.heightConstraintAddView.constant = self.addView.hidden ? 0 : 48;
    self.heightConatraintCrView.constant = self.crView.hidden ? 0 : 64;
    self.heightConatraintSubView.constant = self.subView.hidden ? 0 : 64;
    self.heightConatraintDelView.constant = self.delView.hidden ? 0 : 64;
    self.heightConatraintAlView.constant = self.alView.hidden ? 0 : 64;
    [self.footerView layoutIfNeeded];
    [UIHelper refreshUI:self.footerView];
    self.mainGrid.tableFooterView = self.footerView;
}

#pragma mark - 设置公开参数
- (void)loadPaperId:(NSString*)paperId status:(short)billStatus paperType:(NSInteger)paperType action:(NSInteger)action isEdit:(BOOL)isEdit callBack:(EditAllocatePaperHandler)callBack
{
    self.paperId = paperId;
    self.paperType = paperType;
    self.action = action;
    self.isEdit = isEdit;
    self.status = billStatus;
    self.paperBlock = callBack;
    self.mode = PaperGoodsCellTypeCount;
    //连锁 机构 单店
    self.shopType = [[Platform Instance] getShopMode];
    //服鞋 商超
    self.shopMode = [[[Platform Instance] getkey:SHOP_MODE] integerValue];
    self.isFold = NO;
    self.isOrg = (self.shopType==3);
}

- (void)loadData
{
    [self showHeaderView:_action isEdit:_isEdit];
    [self showFooterView:_action isEdit:_isEdit];
    [self expandBaseInfo];
    [self initNotification];
    [self caculateAmount];
    if (_action==ACTION_CONSTANTS_ADD) {
//        self.titleBox.lblTitle.text = @"添加";
        [self configTitle:@"添加调拨单"];
        [self clearDo];
    }else{
        [self selectAllocatePaperDetailById:_paperId];
    }
}

- (void)clearDo
{
    self.isFirstAdd = YES;
    self.shopId = [[Platform Instance] getkey:SHOP_ID];
    NSDate* date = [NSDate date];
    NSString* dateStr = [DateUtils formateDate2:date];
    NSString* timeStr = [DateUtils formateChineseTime:date];
    [self.lsOutShop initData:[[Platform Instance] getkey:SHOP_NAME] withVal:[[Platform Instance] getkey:SHOP_ID]];
    [self.lsInShop initData:@"请选择" withVal:nil];
    [self.lsDate initData:dateStr withVal:dateStr];
    [self.lsTime initData:timeStr withVal:timeStr];
    [self.txtMemo initData:nil];
    [self.lsMode initData:kCountName withVal:kCountVal];
    [self.mainGrid reloadData];
}

#pragma mark - 查询调拨单详情
- (void)selectAllocatePaperDetailById:(NSString*)paperId
{
    __weak typeof(self) weakSelf = self;
    [_logisticService selectAllocatePaperDetail:paperId completionHandler:^(id json) {
        weakSelf.shopId = [json objectForKey:@"outShopId"];
        [weakSelf configTitle:[json objectForKey:@"allocateNo"]];
        [weakSelf.txtPaperNo initData:[json objectForKey:@"allocateNo"]];
        [weakSelf.lsOutShop initData:[json objectForKey:@"outShopName"] withVal:[json objectForKey:@"outShopId"]];
        [weakSelf.lsInShop initData:[json objectForKey:@"inShopName"] withVal:[json objectForKey:@"inShopId"]];
        NSString* dateTime = [DateUtils formateTime:[[json objectForKey:@"sendEndTime"] longLongValue]];
        NSString* date = [[dateTime componentsSeparatedByString:@" "] objectAtIndex:0];
        NSString* time = [[dateTime componentsSeparatedByString:@" "] objectAtIndex:1];
        [weakSelf.lsDate initData:date withVal:date];
        [weakSelf.lsTime initData:time withVal:time];
        [weakSelf.txtMemo initData:[json objectForKey:@"memo"]];
        weakSelf.lastVer = [[json objectForKey:@"lastVer"] longValue];
        weakSelf.goodList = [PaperDetailVo converToArr:[json objectForKey:@"allocateDetailList"] paperType:weakSelf.paperType];
        [weakSelf.lsMode initData:kCountName withVal:kCountVal];
        [weakSelf.mainGrid reloadData];
        [weakSelf showFooterView:weakSelf.action isEdit:weakSelf.isEdit];
        [weakSelf caculateAmount];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark - IEditItemListEvent协议
- (void)onItemListClick:(EditItemList *)obj
{
    NSDate* date = nil;

    if (obj.tag==IN_SHOP) {
        SelectShopListView* shopListView = [[SelectShopListView alloc] init];
        __weak typeof(self) weakSelf = self;
        [shopListView loadShopList:[obj getStrVal] withType:1 withViewType:NOT_CONTAIN_ALL withIsPush:YES callBack:^(id<ITreeItem> shop) {
            if (shop) {
                if ([[shop obtainItemId] isEqualToString:[weakSelf.lsOutShop getStrVal]]) {
                    [AlertBox show:@"调入门店和调出门店不能相同!"];
                }else{
                    [weakSelf.lsInShop changeData:[shop obtainItemName] withVal:[shop obtainItemId]];
                }
            }
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        }];
        [self.navigationController pushViewController:shopListView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }

    if (obj.tag==DATE) {
        date = [DateUtils parseDateTime4:obj.lblVal.text];
        [DatePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
    }
    if (obj.tag==TIME) {
        date=[DateUtils parseDateTime6:[obj getStrVal]];
        [TimePickerBox show:obj.lblName.text date:date client:self event:obj.tag];
    }
    if (obj.tag==RECORD) {
        
    }
    if (obj.tag==MODE) {
        NSMutableArray* vos = [NSMutableArray arrayWithCapacity:2];
        NameItemVO *item=[[NameItemVO alloc] initWithVal:@"数量" andId:@"0"];
        [vos addObject:item];
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
        }
        _mode = [[vo obtainItemId] integerValue];
        [self.mainGrid reloadData];
    }
    
    return YES;
}

- (void)expandBaseInfo
{
    [self.txtPaperNo visibal:(_action==ACTION_CONSTANTS_EDIT)&&!_isFold];
    [self.lsOutShop visibal:(!_isFold)];
    [self.lsInShop visibal:(!_isFold)];
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
    if (self.shopMode==102) {
        for (PaperDetailVo* detailVo in self.goodList) {
            detailVo.goodsTotalPrice = detailVo.goodsPrice*detailVo.goodsSum;
            amount+=detailVo.goodsTotalPrice;
            sum+=detailVo.goodsSum;
            if (detailVo.type==4) {
                type = YES;
            }
        }
    }else{
        for (PaperDetailVo* detailVo in self.goodList) {
            amount+=detailVo.goodsTotalPrice;
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
    [self showFooterView:self.action isEdit:self.isEdit];
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
        return [self tableView:tableView styleCellForRowAtIndexPath:indexPath];
    }else{
        static NSString* paperGoodsCellId = @"PaperGoodsCell";
        PaperGoodsCell* cell = [tableView dequeueReusableCellWithIdentifier:paperGoodsCellId];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"PaperGoodsCell" bundle:nil] forCellReuseIdentifier:paperGoodsCellId];
            cell = [tableView dequeueReusableCellWithIdentifier:paperGoodsCellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            ShoesClothingCell* detailItem = (ShoesClothingCell*)cell;
            [detailItem loadData:goodsVo isEdit:_isEdit isSearchPrice:YES];
        }else{
            PaperGoodsCell* detailItem = (PaperGoodsCell*)cell;
            detailItem.lblPrice.hidden = (_mode==PaperGoodsCellTypePrice);
            detailItem.lblName.text = goodsVo.goodsName;
            detailItem.lblCode.text = [NSString stringWithFormat:@"%@",goodsVo.goodsBarcode];
            detailItem.lblPrice.text = [NSString stringWithFormat:@"零售价：￥%.2f", goodsVo.goodsPrice];
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
        [self showSelectStyleView:ACTION_CONSTANTS_EDIT];
    }else{
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
        [self saveForAddPaper:@"firstadd" message:@"正在保存..."];
        
    }else{
        
        if (self.shopMode==CLOTHESHOES_MODE) {
            //服鞋商品
            [self showSelectStyleView:ACTION_CONSTANTS_ADD];
        }else{
            //商超商品
            [self showSelectGoodsView];
        }
        
    }
}

#pragma mark - 第一次添加保存
- (void)saveForAddPaper:(NSString *)operateType message:(NSString *)message
{
    NSMutableDictionary* param = [self obtainParams];
    [param setValue:operateType forKey:@"operateType"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"allocate/save"];

    __weak typeof(self) weakSelf = self;
    [_logisticService operatePaperDetail:param withUrl:url completionHandler:^(id json) {
        [UIHelper clearChange:weakSelf.headerView];
        weakSelf.isFirstAdd = NO;
        weakSelf.token = nil;
        [weakSelf.lsInShop editEnable:NO];
        [weakSelf.txtPaperNo visibal:YES];
        [weakSelf configTitle:[json objectForKey:@"allocateNo"]];
        [weakSelf.txtPaperNo initData:[json objectForKey:@"allocateNo"]];
        weakSelf.paperId = [json objectForKey:@"allocateId"];
        weakSelf.lastVer = [[json objectForKey:@"lastVer"] longValue];
        weakSelf.status = 5;
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
    goodsView.inShopId = [self.lsInShop getStrVal];
    goodsView.getStockFlg = YES;
    __weak typeof(self) weakSelf = self;
    [goodsView loaddatas:[[Platform Instance] getkey:SHOP_ID] callBack:^(NSMutableArray *goodsList) {
        if (goodsList.count>0) {
            //有选择商品
            NSMutableArray *addArr = [NSMutableArray arrayWithCapacity:goodsList.count];
            for (GoodsVo* vo in goodsList) {
                BOOL flag = NO;
                BOOL isHave = NO;
                if (weakSelf.delGoodsList.count>0) {
                    for (PaperDetailVo* detailVo in weakSelf.delGoodsList) {
                        if ([vo.goodsId isEqualToString:detailVo.goodsId]) {
//                            detailVo.operateType = @"edit";
//                            detailVo.goodsSum = 1;
//                            detailVo.oldGoodsSum = 1;
                            flag = YES;
                            [addArr addObject:detailVo];
                            [weakSelf.delGoodsList removeObject:detailVo];
                            break;
                        }
                    }
                }
                if (weakSelf.goodList.count>0) {
                    for (PaperDetailVo* detailVo in weakSelf.goodList) {
                        if ([vo.goodsId isEqualToString:detailVo.goodsId]) {
                            isHave = YES;
                            break;
                        }
                    }
                }
                if (!flag&&!isHave) {
                    PaperDetailVo* detailVo = [[PaperDetailVo alloc] init];
                    detailVo.goodsId = vo.goodsId;
                    detailVo.goodsName = vo.goodsName;
                    detailVo.goodsBarcode = vo.barCode;
                    detailVo.goodsPrice = vo.retailPrice;
                    detailVo.retailPrice = vo.retailPrice;
                    detailVo.goodsSum = 1;
                    detailVo.goodsTotalPrice = detailVo.goodsPrice*detailVo.goodsSum;
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
                //选择的商品数超200，原删除商品放回删除队列
                for (PaperDetailVo* detailVo in addArr) {
                    if ([detailVo.operateType isEqualToString:@"del"]) {
                        [weakSelf.delGoodsList addObject:detailVo];
                    }
                }
                [AlertBox show:@"最多只能添加200种商品!"];
                return ;
            }
            
            if (addArr.count>0) {
                //选择的商品数未超200，原删除商品重置数量
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
    cloShoesEditView.shopId = self.shopId;
    cloShoesEditView.inShopId = [self.lsInShop getStrVal];
    __weak typeof(self) weakSelf = self;
    [cloShoesEditView loadDataWithCode:self.paperDetailVo.styleCode withParam:[self obtainParams] withSourceId:self.paperId withAction:action withType:self.paperType withEdit:self.isEdit callBack:^{
        [weakSelf selectAllocatePaperDetailById:weakSelf.paperId];
    }];
    [self.navigationController pushViewController:cloShoesEditView animated:NO];
    [XHAnimalUtil animalPush:self.navigationController action:action];
    cloShoesEditView = nil;
}

#pragma mark - 单据操作
- (IBAction)typeBtnClick:(UIButton *)button {
    if (button.tag==100) {
        //确认收货
        NSString *title = [NSString stringWithFormat:@"确认收货[%@]吗?",[self.txtPaperNo getStrVal]];
        [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
            [self paperDetailGoodsDeleteCheck:@"receipt" action:@"确认收货"];
        }];
        
    }else if (button.tag==101) {
        //拒绝收货
        NSString *title = [NSString stringWithFormat:@"拒绝收货[%@]吗?",[self.txtPaperNo getStrVal]];
        [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
                      [self operatePaperDetail:@"refuse" withMessage:@"正在拒绝..."];
        }];
        
    }else if (button.tag==102) {
        //确认调拨
        NSString *title = [NSString stringWithFormat:@"确认调拨[%@]吗?",[self.txtPaperNo getStrVal]];
        [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
            [self paperDetailGoodsDeleteCheck:@"confirm" action:@"确认调拨"];
        }];
        
    }else if (button.tag==103) {
        //拒绝调拨
        NSString *title = [NSString stringWithFormat:@"拒绝调拨[%@]吗?",[self.txtPaperNo getStrVal]];
        [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
            [self operatePaperDetail:@"refuse" withMessage:@"正在拒绝..."];
        }];
        
    }else if (button.tag==104) {
        NSString *title = [NSString stringWithFormat:@"提交[%@]吗?",[self.txtPaperNo getStrVal]];
        [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
            [self paperDetailGoodsDeleteCheck:@"submit" action:@"提交"];
        }];
        
    }else if (button.tag==105) {
        //删除
        NSString *title = [NSString stringWithFormat:@"删除[%@]吗?",[self.txtPaperNo getStrVal]];
        [LSAlertHelper showSheet:title cancle:@"取消" cancleBlock:nil selectItems:@[@"确认"] selectdblock:^(NSInteger index) {
            [self operatePaperDetail:@"del" withMessage:@"正在删除..."];
        }];
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

    if ([NSString isBlank:[self.lsInShop getStrVal]]) {
        [AlertBox show:@"请选择调入门店!"];
        return NO;
    }
//    NSString* dateTime = [NSString stringWithFormat:@"%@ %@",[self.lsDate getStrVal],[self.lsTime getStrVal]];
//    if ([DateUtils formateDateTime4:dateTime]<(long long)[[NSDate date] timeIntervalSince1970]*1000) {
//        [AlertBox show:@"日期和时间必须大于当前时间!"];
//        return NO;
//    }

//    if (!self.isFirstAdd) {
//        if (self.goodList.count==0) {
//            [AlertBox show:@"请先添加商品!"];
//            return NO;
//        }
//    }
    return YES;
}

#pragma mark - 修改、添加保存
- (void)save
{
    if (![self isValide]) {
        return;
    }
    if (self.isFirstAdd) {
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
- (NSMutableDictionary*)obtainParams
{
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    if ([NSString isBlank:self.token]) {
        self.token = [[Platform Instance] getToken];
    }
    [param setValue:self.token forKey:@"token"];
    
    NSString* dateTime = [NSString stringWithFormat:@"%@ %@",[self.lsDate getStrVal],[self.lsTime getStrVal]];

    [param setValue:[self.lsOutShop getStrVal] forKey:@"outShopId"];
    
    [param setValue:[self.lsInShop getStrVal] forKey:@"inShopId"];
    
    [param setValue:self.paperId forKey:@"allocateId"];
    
    [param setValue:[NSNumber numberWithLongLong:[DateUtils formateDateTime4:dateTime]] forKey:@"sendEndTime"];
    
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
    [param setValue:[PaperDetailVo converToDicArr:[self obtainGoodsList] paperType:self.paperType] forKey:@"allocateDetailList"];
    [param setValue:operateType forKey:@"operateType"];
    NSString* url = [NSString stringWithFormat:URL_PATH_FORMAT,API_ROOT,@"allocate/save"];

    __weak typeof(self) weakSelf = self;
    [_logisticService operatePaperDetail:param withUrl:url completionHandler:^(id json) {
        weakSelf.token = nil;
        [weakSelf removeNotification];
        if (weakSelf.action==ACTION_CONSTANTS_ADD) {
            
            weakSelf.paperBlock(nil,ACTION_CONSTANTS_ADD);
            
        }else if ([operateType isEqualToString:@"edit"]){
            
            weakSelf.paperBlock(weakSelf.paperVo,ACTION_CONSTANTS_EDIT);
            
        }else if ([operateType isEqualToString:@"del"]){
            
            weakSelf.paperBlock(weakSelf.paperVo,ACTION_CONSTANTS_DEL);
            
        }else if ([operateType isEqualToString:@"submit"]){
            
            weakSelf.paperVo.billStatus = 4;
            weakSelf.paperBlock(weakSelf.paperVo,ACTION_CONSTANTS_EDIT);
            
        }else if ([operateType isEqualToString:@"receipt"]){
            
            weakSelf.paperVo.billStatus = 2;
            weakSelf.paperBlock(weakSelf.paperVo,ACTION_CONSTANTS_EDIT);
            
        }else if ([operateType isEqualToString:@"refuse"]){
            
            weakSelf.paperVo.billStatus = 3;
            weakSelf.paperBlock(weakSelf.paperVo,ACTION_CONSTANTS_EDIT);
            
        }else if ([operateType isEqualToString:@"confirm"]){
            
            weakSelf.paperVo.billStatus = 1;
            weakSelf.paperBlock(weakSelf.paperVo,ACTION_CONSTANTS_EDIT);
        }
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    } withMessage:message];
}

//商超check： 进行提交和重新申请提交前check 单子中的商品 删除状况
- (void)paperDetailGoodsDeleteCheck:(NSString *)opType action:(NSString *)actionName {
    
    __weak typeof(self) wself = self;
    NSArray *array = [[PaperDetailVo converToDicArr:[self obtainGoodsList] paperType:self.paperType] copy];
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 102) {
        
        NSString *url = @"allocate/checkGoods";
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:array forKey:@"allocateDetailList"];
        [param setValue:opType forKey:@"operateType"];
        [param setValue:[self.lsOutShop getStrVal] forKey:@"outShopId"];
        [param setValue:[self.lsInShop getStrVal] forKey:@"inShopId"];
        [_logisticService checkPaperDetailGoods:url params:param completionHandler:^(id json) {
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
                            [wself operatePaperDetail:@"submit" withMessage:@"正在提交..."];
                        } else if ([opType isEqualToString:@"receipt"]) {
                            [wself operatePaperDetail:@"receipt" withMessage:@"正在确认..."];
                        } else if ([opType isEqualToString:@"confirm"]) {
                            [wself operatePaperDetail:@"confirm" withMessage:@"正在确认..."];
                        }
                    }];
                }
            } else if ([json[@"returnCode"] isEqualToString:@"success"]) {
                if ([opType isEqualToString:@"submit"]) {
                    [wself operatePaperDetail:@"submit" withMessage:@"正在提交..."];
                } else if ([opType isEqualToString:@"receipt"]) {
                    [wself operatePaperDetail:@"receipt" withMessage:@"正在确认..."];
                } else if ([opType isEqualToString:@"confirm"]) {
                    [wself operatePaperDetail:@"confirm" withMessage:@"正在确认..."];
                }
            }
        } errorHandler:^(id json) {
            
            [LSAlertHelper showAlert:json];
            
        } withMessage:@""];

    } else {
        if ([opType isEqualToString:@"submit"]) {
            [wself operatePaperDetail:@"submit" withMessage:@"正在提交..."];
        } else if ([opType isEqualToString:@"receipt"]) {
            [wself operatePaperDetail:@"receipt" withMessage:@"正在确认..."];
        } else if ([opType isEqualToString:@"confirm"]) {
            [wself operatePaperDetail:@"confirm" withMessage:@"正在确认..."];
        }
    }
}

@end
