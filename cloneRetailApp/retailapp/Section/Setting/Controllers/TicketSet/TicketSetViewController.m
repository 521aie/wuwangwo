//
//  TicketSetViewController.m
//  retailapp
//
//  Created by taihangju on 16/8/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#define TAG_LST_SMALL_TICKET_WIDTH 1
#import "TicketSetViewController.h"
#import "UIView+Sizes.h"
#import "LSEditItemRadio.h"
#import "LSEditItemText.h"
#import "LSEditItemList.h"
#import "LSNavigateItem.h"
#import "LSEditItemTitle.h"
#import "AddItem.h"
#import "OptionPickerBox.h"
#import "AlertBox.h"
#import "ColorHelper.h"
#import "ServiceFactory.h"
#import "TicketTailEditViewController.h"
#import "TicketReviewController.h"
#import "NameItemVO.h"
#import "ReceiptStyleVo.h"
#import "SelectOrgShopListView.h"
#import "UIHelper.h"

@interface TicketSetViewController ()<OptionPickerClient ,IEditItemListEvent ,AddItemDelegate ,IEditItemRadioEvent ,AlertBoxClient>
{
    CGFloat tailItemsOriginY;
    NSInteger shopType; // 机构：0 门店或单店：2
    NSString *currentShopId ;  // 当前选中的门店或者机构的id
}
@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) ReceiptStyleVo *receiptStyleVo;/*<小票设置vo>*/
@property (nonatomic ,assign) BOOL tailChange;/*<尾注内容变化>*/
/** 标准模板预览 */
@property (nonatomic, strong) LSEditItemList *reviewSet;
/** 小票宽度 */
@property (nonatomic, strong) LSEditItemList *lstSmallTicketWidth;
@property (nonatomic, strong) LSEditItemList *lsOrgShop;/*<机构/门店 选择>*/
@property (nonatomic, strong) LSEditItemText *crosshead ;/*<小票标题设置>*/
@property (nonatomic, strong) LSEditItemRadio *logo;/*<店家logo打印控制>*/
@property (nonatomic, strong) LSEditItemRadio *billCode;/*<单号打印控制>*/
@property (nonatomic, strong) LSEditItemRadio *goodName;/*<品名打印控制>*/
@property (nonatomic, strong) LSEditItemRadio *goodNum;/*<货号打印控制>*/
@property (nonatomic ,strong) LSEditItemRadio *rawPrinceTotal;/*<原价合计>*/
@property (nonatomic, strong) LSEditItemRadio *abateAll;/*<优惠合计打印控制>*/
@property (nonatomic, strong) LSEditItemRadio *payDetail;/*<支付明细打印控制>*/
@property (nonatomic, strong) LSEditItemRadio *abateDetail ;/*<优惠明细打印控制>*/
@property (nonatomic, strong) LSEditItemRadio *integral;/*<本次积分打印控制>*/
@property (nonatomic, strong) LSEditItemRadio *cardIntergral;/*<卡内积分打印控制>*/
@property (nonatomic, strong) LSEditItemRadio *cardMoney;/*<卡内余额打印控制>*/
@property (nonatomic, strong) LSEditItemRadio *remark ;/*<客单备注打印控制>*/
@property (nonatomic, strong) LSEditItemRadio *qrCode ;/*<微店二维码打印控制>*/
@property (nonatomic, strong) LSEditItemList *printPosition;/*<尾注打印位置打印控制>*/
/** 折后价 */
@property (nonatomic, strong) LSEditItemRadio *rdoDiscountPrice;
/** 零售价 */
@property (nonatomic, strong) LSEditItemRadio *rdoRetailPrice;
/** 商品单位 */
@property (nonatomic, strong) LSEditItemRadio *rdoGoodsUnit;
/** 会员名 */
@property (nonatomic, strong) LSEditItemRadio *rdoMemberName;
/** 会员手机号 */
@property (nonatomic, strong) LSEditItemRadio *rdoMemberTel;
/** 会员卡号 */
@property (nonatomic, strong) LSEditItemRadio *rdoMemberCard;

@property (nonatomic ,strong) UIView *wrapper;/*<>*/
@property (nonatomic ,strong) NSMutableArray *tailItemArr; // 尾注内容数组
/** <#注释#> */
@property (nonatomic, strong) UIView *container;
@end

@implementation TicketSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    shopType = [[Platform Instance] getShopMode] == 3 ? 0 : 2;
    currentShopId = [[Platform Instance] getkey:SHOP_ID];
    [self getTicketSetData:YES];
    [self configSuviews];
    [self initNotification];
    [self configHelpButton:HELP_SETTING_SMALL_TICKET_SET];
}


- (void)configSuviews {
    
    CGFloat screenWidth = SCREEN_W;
   
    // 导航栏
    [self configTitle:@"小票设置" leftPath:Head_ICON_BACK rightPath:nil];
    // scrollview
    self.scrollView = [[UIScrollView alloc] initWithFrame:
                       CGRectMake(0, kNavH, screenWidth, SCREEN_H - kNavH)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - kNavH)];
    [self.scrollView addSubview:self.container];
        // 选择机构/门店 ,单个门店不需要选择
    if ([[Platform Instance] getShopMode] == 3) {
        
        self.lsOrgShop = [LSEditItemList editItemList];
        self.lsOrgShop.imgMore.image = [UIImage imageNamed:@"ico_next"];
        [self.lsOrgShop initLabel:@"机构/门店" withHit:@"" delegate:self];
         [self.lsOrgShop initData:[[Platform Instance] getkey:ORG_NAME] withVal:[[Platform Instance] getkey:ORG_ID]];
        [self.container addSubview:self.lsOrgShop];
    }
    
    // 小票设置预览
    self.reviewSet = [LSEditItemList editItemList];
    [self.reviewSet initLabel:@"标准模板预览" withHit:nil delegate:self];
    self.reviewSet.imgMore.image = [UIImage imageNamed:@"ico_next"];
    self.reviewSet.line.hidden = YES;
    self.reviewSet.lblVal.hidden = YES;
    [self.container addSubview:self.reviewSet];
    //小票规格
    LSEditItemTitle *headTitle = [LSEditItemTitle editItemTitle];
    [headTitle configTitle:@"小票规格"];
    [self.container addSubview:headTitle];
    //小票宽度
    self.lstSmallTicketWidth = [LSEditItemList editItemList];
    [self.lstSmallTicketWidth initLabel:@"小票宽度" withHit:nil delegate:self];
    self.lstSmallTicketWidth.line.hidden = YES;
    [self.lstSmallTicketWidth initData:@"58mm" withVal:@"1"];
    self.lstSmallTicketWidth.tag = TAG_LST_SMALL_TICKET_WIDTH;
    [self.container addSubview:self.lstSmallTicketWidth];
    
// 小票头部部分
    headTitle = [LSEditItemTitle editItemTitle];
    [headTitle configTitle:@"小票头部"];
    [self.container addSubview:headTitle];

     // 店家LOGO
    self.logo = [LSEditItemRadio editItemRadio];
    [self.logo initLabel:@"店家LOGO" withHit:nil];
    [self.logo initData:@"0"];
    self.logo.delegate = self;
    [self.container addSubview:self.logo];
    
    // 小票标题, 默认小店名称 “二维火” , 店名最长支持50个长度
    self.crosshead = [LSEditItemText editItemText];
    [self.crosshead initLabel:@"小票标题" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    self.crosshead.notificationType = @"crossheadMayChanged";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(crossheadMayChanged)
                                                 name:@"crossheadMayChanged" object:nil];
    [self.crosshead initData:@"二维火"];
    [self.crosshead initMaxNum:50];
    [self.container addSubview:self.crosshead];
    
    // 单号打印成条码控制 默认关闭
    self.billCode = [LSEditItemRadio editItemRadio];
    [self.billCode initLabel:@"将单号打印成条码" withHit:nil];
    [self.billCode initData:@"0"];
    self.billCode.delegate = self;
    self.billCode.line.hidden = YES;
    [self.container addSubview:self.billCode];

// 小票明细
    LSEditItemTitle *goodNote = [LSEditItemTitle editItemTitle];
    [goodNote configTitle:@"小票明细"];
    [self.container addSubview:goodNote];
    
    // 品名 默认打开
    self.goodName = [LSEditItemRadio editItemRadio];
    [self.goodName initLabel:@"品名" withVal:@"1" withHit:@""];
    self.goodName.delegate = self;
    [self.container addSubview:self.goodName];
    
    // 货号 默认打开
    self.goodNum = [LSEditItemRadio editItemRadio];
    [self.goodNum initLabel:@"货号" withVal:@"1" withHit:@""];
    self.goodNum.delegate = self;
    [self.container addSubview:self.goodNum];
    
    // 折后价默认打开
    self.rdoDiscountPrice = [LSEditItemRadio editItemRadio];
    [self.rdoDiscountPrice initLabel:@"折后价" withHit:nil delegate:self];
    [self.rdoDiscountPrice initData:@"1"];
    [self.container addSubview:self.rdoDiscountPrice];
    
    // “零售价”（默认关闭)
    self.rdoRetailPrice = [LSEditItemRadio editItemRadio];
    [self.rdoRetailPrice initLabel:@"零售价" withHit:nil delegate:self];
    [self.rdoRetailPrice initData:@"0"];
    [self.container addSubview:self.rdoRetailPrice];
    
    //商品单位
    self.rdoGoodsUnit = [LSEditItemRadio editItemRadio];
    [self.rdoGoodsUnit initLabel:@"商品单位" withHit:nil delegate:self];
    self.rdoGoodsUnit.line.hidden = YES;
    [self.rdoGoodsUnit initData:@"0"];
    [self.container addSubview:self.rdoGoodsUnit];

// 小票金额
    LSEditItemTitle *money = [LSEditItemTitle editItemTitle];
    [money configTitle:@"小票金额"];
    [self.container addSubview:money];
    
    // 原价合计
    self.rawPrinceTotal = [LSEditItemRadio editItemRadio];
    [self.rawPrinceTotal initLabel:@"原价合计" withVal:@"1" withHit:@""];
    self.rawPrinceTotal.delegate = self;
    [self.container addSubview:self.rawPrinceTotal];

    
    // 优惠合计
    self.abateAll = [LSEditItemRadio editItemRadio];
    [self.abateAll initLabel:@"优惠合计" withVal:@"0" withHit:@""];
    self.abateAll.delegate = self;
    [self.container addSubview:self.abateAll];
    
    // 支付明细 默认关闭
    self.payDetail = [LSEditItemRadio editItemRadio];
    [self.payDetail initLabel:@"支付明细" withVal:@"0" withHit:@""];
    self.payDetail.delegate = self;
    [self.container addSubview:self.payDetail];

    // 优惠明细 默认关闭
    self.abateDetail = [LSEditItemRadio editItemRadio];
    [self.abateDetail initLabel:@"优惠明细" withVal:@"0" withHit:@""];
    self.abateDetail.delegate = self;
    self.abateDetail.line.hidden = YES;
    [self.container addSubview:self.abateDetail];
    
// 会员信息
    LSEditItemTitle *memberInfo = [LSEditItemTitle editItemTitle];
    [memberInfo configTitle:@"会员信息"];
    [self.container addSubview:memberInfo];
    // 会员名 默认关闭
    self.rdoMemberName = [LSEditItemRadio editItemRadio];
    [self.rdoMemberName initLabel:@"会员名" withHit:nil];
    [self.rdoMemberName initData:@"0"];
    [self.container addSubview:self.rdoMemberName];
    // 会员手机号 默认关闭
    self.rdoMemberTel = [LSEditItemRadio editItemRadio];
    [self.rdoMemberTel initLabel:@"会员手机号" withHit:nil];
    [self.rdoMemberTel initData:@"0"];
    [self.container addSubview:self.rdoMemberTel];
    // 会员卡号 默认打开
    self.rdoMemberCard = [LSEditItemRadio editItemRadio];
    [self.rdoMemberCard initLabel:@"会员卡号" withHit:nil];
    [self.rdoMemberCard initData:@"1"];
    [self.container addSubview:self.rdoMemberCard];
    
    // 本次积分 默认打开
    self.integral = [LSEditItemRadio editItemRadio];
    [self.integral initLabel:@"本次积分" withVal:@"1" withHit:@""];
    self.integral.delegate = self;
    [self.container addSubview:self.integral];
    
    // 卡内积分 默认关闭
    self.cardIntergral = [LSEditItemRadio editItemRadio];
    [ self.cardIntergral initLabel:@"卡内积分" withVal:@"0" withHit:@""];
     self.cardIntergral.delegate = self;
    [self.container addSubview: self.cardIntergral];
    
    // 卡内余额 默认关闭
    self.cardMoney = [LSEditItemRadio editItemRadio];
    [self.cardMoney initLabel:@"卡内余额" withVal:@"0" withHit:@""];
    self.cardMoney.delegate = self;
    self.cardMoney.line.hidden = YES;
    [self.container addSubview:self.cardMoney];

// 小票尾部
    LSEditItemTitle *tail = [LSEditItemTitle editItemTitle];
    NSMutableAttributedString *abttriStr = [[NSMutableAttributedString alloc]
                                            initWithString:@"小票尾部 (最多可添加10行尾注)"];
    [abttriStr setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName :
                                   [UIFont systemFontOfSize:15]} range:NSMakeRange(0, 4)];
    [abttriStr setAttributes:@{NSForegroundColorAttributeName:[ColorHelper getTipColor9], NSFontAttributeName :
                                   [UIFont systemFontOfSize:13]} range:NSMakeRange(4, 13)];
    tail.lblName.attributedText = abttriStr;
    tail.lblName.backgroundColor = [UIColor clearColor];
    [self.container addSubview:tail];
    
    
    // 动态部分 小票尾注信息
    
    // 分块方便整体调整frame ，
    NSInteger count = ([[Platform Instance] getMicroShopStatus] == 2 ? 4 : 3);
    UIView *wrapper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 48*count+28)];
    [self.container addSubview:wrapper];
    self.wrapper = wrapper;
    
    // 添加尾注内容item
    AddItem *addTail = [AddItem loadFromNib];
    [addTail initDelegate:self titleName:@"添加尾注内容"];
    [self.container addSubview:addTail];
    
    // 尾注打印位置 默认关闭
    self.printPosition = [LSEditItemList editItemList];
    self.printPosition.ls_top = addTail.ls_bottom;
    [self.printPosition initLabel:@"尾注打印位置" withHit:@"" delegate:self];
    [self.printPosition initData:@"居中" withVal:@"2"];
    [self.container addSubview:self.printPosition];
    
    // 打印客单备注 默认关闭
    self.remark = [LSEditItemRadio editItemRadio];
    [self.remark initLabel:@"打印客单备注" withVal:@"0" withHit:@""];
    self.remark.delegate = self;
    self.remark.ls_top = CGRectGetMaxY(self.printPosition.frame);
    [self.container addSubview:self.remark ];
    
    // 开通微店显示
    if ([[Platform Instance] getMicroShopStatus] == 2) {
        // 打印微店二维码 默认关闭
        self.qrCode = [LSEditItemRadio editItemRadio];
        [self.qrCode initLabel:@"打印微店二维码" withVal:@"0" withHit:@""];
        self.qrCode.delegate = self;
        self.qrCode.ls_top = CGRectGetMaxY(self.remark .frame);
        [self.container addSubview:self.qrCode];
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    
}


// 动态部分，添加小票尾注内容
- (void)displayTicketSetItems {
    
    
    if (!self.tailItemArr) {
        self.tailItemArr = [NSMutableArray arrayWithCapacity:10];
    }
    
    if (self.tailItemArr.count && self.tailChange) {
        [self.tailItemArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.tailItemArr removeAllObjects];
    }
    
    // fill model
    if (!self.tailChange) {
        
        [self.crosshead initData:(self.receiptStyleVo.receiptTitle ? : @"二维火")];
        [self.logo initLabel:@"店家LOGO" withVal:@(self.receiptStyleVo.hasLogo).stringValue];
        [self.billCode initLabel:@"将单号打印成条码" withVal:@(self.receiptStyleVo.orderNumToBarCode).stringValue];
        [self.goodName initLabel:@"品名" withVal:@(self.receiptStyleVo.hasGoodsName).stringValue];
        [self.goodNum initLabel:@"货号" withVal:@(self.receiptStyleVo.hasBarCode).stringValue];
        [self.rawPrinceTotal initLabel:@"原价合计" withVal:@(self.receiptStyleVo.hasTotalOriginal).stringValue];
        [self.abateAll initLabel:@"优惠合计" withVal:@(self.receiptStyleVo.hasDiscount).stringValue];
        [self.payDetail initLabel:@"支付明细" withVal:@(self.receiptStyleVo.hasPayDetail).stringValue];
        [self.abateDetail initLabel:@"优惠明细" withVal:@(self.receiptStyleVo.hasDiscountDetail).stringValue];
        [self.integral initLabel:@"本次积分" withVal:@(self.receiptStyleVo.hasPoint).stringValue];
        [self.cardIntergral initLabel:@"卡内积分" withVal:@(self.receiptStyleVo.hasPointBalance).stringValue];
        [self.cardMoney initLabel:@"卡内余额" withVal:@(self.receiptStyleVo.hasMoneyBalance).stringValue];
        NSString *position = (self.receiptStyleVo.bottomLocation == 1 ? @"居左" :
                              (self.receiptStyleVo.bottomLocation == 2 ? @"居中" : @"居右"));
        [self.printPosition initData:position withVal:@(self.receiptStyleVo.bottomLocation).stringValue ];
        [self.remark initLabel:@"打印客单备注" withVal:@(self.receiptStyleVo.hasComment).stringValue];
        [self.qrCode initLabel:@"打印微店二维码" withVal:@(self.receiptStyleVo.hasWeiqrcode).stringValue];
        //小票宽度
        if (self.receiptStyleVo.receiptWithType == 1) {
             [self.lstSmallTicketWidth initData:@"58mm" withVal:@"1"];
        } else {
            [self.lstSmallTicketWidth initData:@"80mm" withVal:@"2"];
        }
        //折扣价
        [self.rdoDiscountPrice initData:@(self.receiptStyleVo.hasDiscountMoney).stringValue];
        //零售价
        [self.rdoRetailPrice initData:@(self.receiptStyleVo.hasRetailPrice).stringValue];
        if ([ObjectUtil isNull:self.receiptStyleVo.hasGoodsUnit]) {
            [self.rdoGoodsUnit visibal:NO];
        } else {
            [self.rdoGoodsUnit visibal:YES];
        }
        [self.rdoGoodsUnit initData:self.receiptStyleVo.hasGoodsUnit.stringValue];
        //会员名字
        [self.rdoMemberName initData:@(self.receiptStyleVo.hasCustomerName).stringValue];
        //会员卡号
        [self.rdoMemberCard initData:@(self.receiptStyleVo.hasCardCode).stringValue];
        //会员手机号
        [self.rdoMemberTel initData:@(self.receiptStyleVo.hasCustomerMobile).stringValue];
       
    }
    
    if (self.tailChange || !self.tailItemArr.count) {
        
        for (NSInteger index = 0 ;index < self.receiptStyleVo.bottomContentList.count ; ++index)
        {
            NSString *tailStrings = self.receiptStyleVo.bottomContentList[index];
            LSNavigateItem *item = [LSNavigateItem createItem:tailStrings];
            [item addTarget:self action:@selector(tailContentEdit:) forControlEvents:UIControlEventTouchUpInside];
            item.tag = index;
            [self.wrapper addSubview:item];
            [self.tailItemArr addObject:item];
        }
    }
    [UIHelper refreshUI:self.wrapper];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    [self tryChageNavigationStatus];
}


// 尾注内容编辑
- (void)tailContentEdit:(LSNavigateItem *)item {
    
    [self saveDatasToModel];
    NSString *tailString = self.receiptStyleVo.bottomContentList[item.tag];
    TailModel *model = [[TailModel alloc] init:tailString index:[item tag] type:TailEdit shopId:currentShopId];
    TicketTailEditViewController *editTailVc = [[TicketTailEditViewController alloc]
                                               init:model callBack:^(TailModel *tailModel) {
                                                  
           self.tailChange = YES;
           if (tailModel.tailType == TailDel) {
               
               [self.receiptStyleVo.bottomContentList removeObjectAtIndex:tailModel.index];
           }else {
               
               self.receiptStyleVo.bottomContentList[tailModel.index] = tailModel.editTailString;
           }
//           [self tryChageNavigationStatus];
           [self displayTicketSetItems];
    }];
    editTailVc.currentTailArray = [self.receiptStyleVo.bottomContentList copy];
    [self pushController:editTailVc from:kCATransitionFromRight];
    
}
#pragma mark - 初始化通知
- (void)initNotification {
    [UIHelper initNotification:self.container event:Notification_UI_KindPayEditView_Change];
    [UIHelper initNotification:self.wrapper event:Notification_UI_KindPayEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_KindPayEditView_Change object:nil];
    
}

#pragma mark - 页面里面的值改变时调用
- (void)dataChange:(NSNotification *)notification {
    
    [self tryChageNavigationStatus];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


// 是否需要更改导航栏状态
- (void)tryChageNavigationStatus {
    BOOL edit = [UIHelper currChange:self.container] || [UIHelper currChange:self.wrapper] || self.tailChange;
    [self editTitle:edit act:ACTION_CONSTANTS_EDIT];
}


#pragma mark - 通知
// 小票 店家名称变化通知
- (void)crossheadMayChanged {
    
    [self tryChageNavigationStatus];
}


#pragma mark - 协议方法

// INavigateEvent
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
    
    if (event == LSNavigationBarButtonDirectLeft) {
        [self popToLatestViewController:kCATransitionFromLeft];
    }
    else if (event == LSNavigationBarButtonDirectRight)
    {
        [self saveTicketSetData];
    }
}

// OptionPickerClient
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    
    if (eventType == TAG_LST_SMALL_TICKET_WIDTH) {//小票设置
        id<INameItem> item = (id<INameItem>)selectObj;
        [self.lstSmallTicketWidth changeData:[item obtainItemName] withVal:[item obtainItemId]];
        //选择80mm小票后，将按钮全部打开，再切换成58mm，货号按钮应自动关闭
        [self onItemRadioClick:self.rdoDiscountPrice];
    } else {
        NameItemVO *vo = (NameItemVO *)selectObj;
        [self.printPosition changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
        self.receiptStyleVo.bottomLocation = [[vo obtainItemId] integerValue];
    }
    return YES;
}

// IEditItemListEvent
- (void)onItemListClick:(LSEditItemList *)obj {
    
    if ([obj isEqual:self.printPosition]) {
        
        NSArray *datas = @[[[NameItemVO alloc] initWithVal:@"居左" andId:@"1"],
                           [[NameItemVO alloc] initWithVal:@"居中" andId:@"2"],
                           [[NameItemVO alloc] initWithVal:@"居右" andId:@"3"]];

        
        [OptionPickerBox initData:datas itemId:[obj getStrVal]];
        [OptionPickerBox show:@"尾注打印位置" client:self event:11];
    }
    else if ([obj isEqual:self.lsOrgShop])
    {
        //选择机构门店
        SelectOrgShopListView *orgShopListView = [[SelectOrgShopListView alloc] init];
        __weak typeof(self) weakSelf = self;
        [orgShopListView loadData:[obj getStrVal] withModuleType:3 withCheckMode:SINGLE_CHECK callBack:^(NSMutableArray *selectArr, id<ITreeItem> item) {
            
            if (item) {
                shopType = [[(id)item valueForKey:@"type"] integerValue];
                currentShopId = [item obtainItemId];
                [obj initData:[item obtainItemName] withVal:[item obtainItemId]];
                [weakSelf getTicketSetData:YES];
            }
            [weakSelf popToLatestViewController:kCATransitionFromLeft];
        }];
        [weakSelf pushController:orgShopListView from:kCATransitionFromRight];
    } else if (obj == self.reviewSet) {//标准模板预览
        TicketReviewController *reviewVc = [[TicketReviewController alloc] init];
        if ([[self.lstSmallTicketWidth getDataLabel] isEqualToString:@"58mm"]) {
            reviewVc.type = SmallTicketType58mm;
        } else {
            reviewVc.type = SmallTicketType80mm;
        }
        [self pushController:reviewVc from:kCATransitionFromRight];
    } else if (obj == self.lstSmallTicketWidth) {//小票宽度
        NSArray *datas = @[[[NameItemVO alloc] initWithVal:@"58mm" andId:@"1"],
                           [[NameItemVO alloc] initWithVal:@"80mm" andId:@"2"]];
        
        [OptionPickerBox initData:datas itemId:[self.lstSmallTicketWidth getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }
}

// AddItemDelegate
- (void)showAddItemEvent {
  
    // 最多支持添加10条尾注
    if (self.receiptStyleVo.bottomContentList.count >= 10) {
        [AlertBox show:@"最多只能添加10行尾注！"];
        return;
    }
    
    // 尾注内容添加
    [self saveDatasToModel];
    TailModel *model = [[TailModel alloc] init:@"" index:-1 type:TailAdd shopId:currentShopId];
    TicketTailEditViewController *addTailVc = [[TicketTailEditViewController alloc]
                                               init:model callBack:^(TailModel *tailModel) {
                                                  
            self.tailChange = YES;
            [self.receiptStyleVo.bottomContentList addObject:tailModel.editTailString];
//            [self tryChageNavigationStatus];
            [self displayTicketSetItems];
        
    }];
     addTailVc.currentTailArray = [self.receiptStyleVo.bottomContentList copy];
    [self pushController:addTailVc from:kCATransitionFromRight];
}

// IEditItemRadioEvent
- (void)onItemRadioClick:(id)obj {
    /**
    “折后价”（默认打开）、“零售价”（默认关闭）
     80mm小票可以同时选中“品名”、“货号”、“折后价”、“零售价”
     58mm小票，当同时选中“折后价”和“零售价”时，“货号”、“品名”选择其一（联动效果）;当“货号”和“品名”都选中时，打开“零售价”和“折后价”后，关闭“货号”（PS：品名的优先级比货号高）
     
     品名和货号必选其一，折后价和零售价必选其一    
     */
    
    //品名和货号必选其一，折后价和零售价必选其一
    BOOL is58mm = [[self.lstSmallTicketWidth getDataLabel] isEqualToString:@"58mm"];
    if (obj == self.goodName) {//品名  品名和货号必选其一 品名关闭时如果货号是关闭的货号开关打开
        if (![self.goodName getVal] && ![self.goodNum getVal]) {
            [self.goodNum changeData:@"1"];
        }
        
        if (is58mm) {//当同时选中“折后价”和“零售价”时，“货号”、“品名”选择其一（联动效果）
            if ([self.rdoRetailPrice getVal] && [self.rdoDiscountPrice getVal]) {
                if ([self.goodName getVal] && [self.goodNum getVal]) {
                    [self.goodNum changeData:@"0"];
                }
            }
        }
    } else if (obj == self.goodNum) {//货号
        if (![self.goodName getVal] && ![self.goodNum getVal]) {
            [self.goodName changeData:@"1"];
        }
        if (is58mm) {//当同时选中“折后价”和“零售价”时，“货号”、“品名”选择其一（联动效果）
            if ([self.rdoRetailPrice getVal] && [self.rdoDiscountPrice getVal]) {
                if ([self.goodName getVal] && [self.goodNum getVal]) {
                    [self.goodName changeData:@"0"];
                }
            }
        }
    } else if (obj == self.rdoDiscountPrice) {//折扣价
        if (![self.rdoDiscountPrice getVal] && ![self.rdoRetailPrice getVal]) {
            [self.rdoRetailPrice changeData:@"1"];
        }
        //当“货号”和“品名”都选中时，打开“零售价”和“折后价”后，关闭“货号”（PS：品名的优先级比货号高）
        if (is58mm) {
            if ([self.rdoRetailPrice getVal] && [self.rdoDiscountPrice getVal] && [self.goodName getVal] && [self.goodNum getVal]) {
                [self.goodNum changeData:@"0"];
            }
        }
    } else if (obj == self.rdoRetailPrice) {//零售价
        if (![self.rdoDiscountPrice getVal] && ![self.rdoRetailPrice getVal]) {
            [self.rdoDiscountPrice changeData:@"1"];
        }
        
        //当“货号”和“品名”都选中时，打开“零售价”和“折后价”后，关闭“货号”（PS：品名的优先级比货号高）
        if (is58mm) {
            if ([self.rdoRetailPrice getVal] && [self.rdoDiscountPrice getVal] && [self.goodName getVal] && [self.goodNum getVal]) {
                [self.goodNum changeData:@"0"];
            }
        }
    }
}


// AlertBoxClient ,保存完成后点击确认后重新加载下数据
- (void)understand {
    
    [self getTicketSetData:NO];
}



#pragma mark - 小票设置数据获取

- (void)saveDatasToModel {
    
    self.receiptStyleVo.receiptTitle = self.crosshead.txtVal.text;
    self.receiptStyleVo.hasLogo = self.logo.currentVal.integerValue;
    self.receiptStyleVo.orderNumToBarCode = self.billCode.currentVal.integerValue;
    self.receiptStyleVo.hasGoodsName = self.goodName.currentVal.integerValue;
    self.receiptStyleVo.hasBarCode = self.goodNum.currentVal.integerValue;
    self.receiptStyleVo.hasTotalOriginal = self.rawPrinceTotal.currentVal.integerValue;
    self.receiptStyleVo.hasDiscount = self.abateAll.currentVal.integerValue;
    self.receiptStyleVo.hasPayDetail = self.payDetail.currentVal.integerValue;
    self.receiptStyleVo.hasDiscountDetail = self.abateDetail.currentVal.integerValue;
    self.receiptStyleVo.hasPoint = self.integral.currentVal.integerValue;
    self.receiptStyleVo.hasPointBalance = self.cardIntergral.currentVal.integerValue;
    self.receiptStyleVo.hasMoneyBalance = self.cardMoney.currentVal.integerValue;
    self.receiptStyleVo.hasComment = self.remark.currentVal.integerValue;
    self.receiptStyleVo.hasWeiqrcode = self.qrCode.currentVal.integerValue;
    self.receiptStyleVo.shopId = currentShopId;
    self.receiptStyleVo.hasGoodsUnit = @(self.rdoGoodsUnit.currentVal.integerValue);
    //小票宽度
    self.receiptStyleVo.receiptWithType = [[self.lstSmallTicketWidth getStrVal] integerValue];
    //是否显示折后价
    self.receiptStyleVo.hasDiscountMoney = [self.rdoDiscountPrice getVal] ? 1 : 0;
    //是否显示零售价
    self.receiptStyleVo.hasRetailPrice = [self.rdoRetailPrice getVal] ? 1 : 0;
    //是否显示会员名
    self.receiptStyleVo.hasCustomerName = [self.rdoMemberName getVal] ? 1 : 0;
    //是否显示会员手机号
    self.receiptStyleVo.hasCustomerMobile = [self.rdoMemberTel getVal] ? 1 : 0;
    //是否显示会员名
    self.receiptStyleVo.hasCardCode = [self.rdoMemberCard getVal] ? 1 : 0;
    
}

- (void)getTicketSetData:(BOOL)show {
    
    [[ServiceFactory shareInstance].settingService acquireNoteSettingDetail:currentShopId  withShow:show completionHandler:^(id json) {
        
        self.receiptStyleVo = [ReceiptStyleVo converToVo:json[@"receiptStyle"]];
        if (self.receiptStyleVo) {
            self.tailChange = NO; // 加载新的数据，记录尾注更改状态也应设为初始值
            [self displayTicketSetItems];
        }
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}


- (void)saveTicketSetData {
    
    if (self.crosshead.txtVal.text.length == 0) {
        [AlertBox show:@"小票标题不可为空，请输入！"];
        return;
    }

    [self saveDatasToModel];
    [[ServiceFactory shareInstance].settingService updateNoteSetting:shopType receiptStyle:self.receiptStyleVo completionHandler:^(id json) {
        
        if ([[json valueForKey:@"returnCode"] isEqualToString:@"success"]) {
            
            // 保存完成重新加载数据，并对对界面控件进行初始化
            if ([[Platform Instance] getShopMode] == 3) {
    
               [AlertBox show:@"保存成功！" client:self];
            }else {
            
                [self popToLatestViewController:kCATransitionFromLeft];
            }
            
        }
    } errorHandler:^(id json) {
        
        [AlertBox show:json];
    }];
}

@end
