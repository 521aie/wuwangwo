//
//  MarketSalesEditView.m
//  retailapp
//
//  Created by zhangzhiliang on 15/9/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//
#define TAG_RDO_MEMBER_TYPE 100
#define TAG_LST_MEMBER_TYPE 101
#import "MarketSalesEditView.h"
#import "EditItemRadio2.h"
#import "EditItemRadio.h"
#import "EditItemList.h"
#import "EditItemText.h"
#import "ItemTitle.h"
#import "RetailTable2.h"
#import "MarketModuleEvent.h"
#import "MarketRender.h"
#import "DateUtils.h"
#import "UIHelper.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "ShopVo.h"
#import "SelectOrgShopListView.h"
#import "XHAnimalUtil.h"
#import "OptionPickerBox.h"
#import "SaleActVo.h"
#import "ShopSalesVo.h"
#import "LSMarketListController.h"
#import "LSMemberTypeVo.h"
#import "LSMemberCardListController.h"
#import "LSMarketCardVo.h"
//#import "LSMemberCardVo.h"

@interface MarketSalesEditView ()

@property (weak, nonatomic) IBOutlet EditItemRadio *rdoMemberType; /**<指定会员类型>*/
@property (weak, nonatomic) IBOutlet EditItemList *lstMemberType; /**<选择的会员类型>*/
@property (nonatomic, strong) MarketService *marketService;
@property (nonatomic) int action;   // 标识:添加/编辑
@property (nonatomic) int fromViewTag; /**<不同活动viewTag>*/
@property (nonatomic, strong) NSString *saleActId; /**<促销ID>*/
@property (nonatomic, strong) SaleActVo *saleActVo; /**<促销活动信息>*/
@property (nonatomic, strong) ShopVo *tempVo;
@property (nonatomic, strong) NSMutableArray *shopList;
@property (nonatomic, strong) NSMutableArray *shopIdList;
@property (nonatomic, strong) NSMutableArray *shopSalesList; /**<促销门店范围>*/
@property (nonatomic, strong) NSMutableArray *memberCardList; /**<会员卡列表>*/
@property (nonatomic, strong) NSMutableArray *selectmemberCardList; /**<选中的会员卡列表>*/
@end

@implementation MarketSalesEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil saleActId:(NSString*) saleActId action:(int)action fromView:(int)viewTag {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _saleActId = saleActId;
        _action = action;
        _fromViewTag = viewTag;
        _shopList = [[NSMutableArray alloc] init];
        _marketService = [ServiceFactory shareInstance].marketService;   
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configHelpButton];
    [self initNotifaction];
    [self initHead];
    [self initMainView];
    [self loaddatas];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}
- (void)configHelpButton {
    if (self.fromViewTag == SPECIAL_OFFER_LIST_VIEW) {//特价管理
        [self configHelpButton:HELP_MARKET_SPECIAL_MANAGEMENT_ACTIVITY_DETAIL];
    } else if (self.fromViewTag == PIECES_DISCOUNT_LIST_VIEW) {//第N件打折
        [self configHelpButton:HELP_MARKET_PART_N_DISCOUNT_ACTIVITY_DETAIL];
    } else if (self.fromViewTag == BINDING_DISCOUNT_LIST_VIEW) {//捆绑打折
        [self configHelpButton:HELP_MARKET_BUNDLED_DISCOUNT_ACTIVITY_DETAIL];
    } else if (self.fromViewTag == SALES_SEND_OR_SWAP_LIST_VIEW) {//满送/换购
        [self configHelpButton:HELP_MARKET_FULL_DELIVERY_ACTIVITY_DETAIL];
    } else if (self.fromViewTag == SALES_MINUS_LIST_VIEW) {//满送
        [self configHelpButton:HELP_MARKET_FULL_CUT_ACTIVITY_DETAIL];
    } else if (self.fromViewTag == SALES_COUPON_LIST_VIEW) {//优惠券
        [self configHelpButton:HELP_MARKET_COUPON_ACTIVITY_DETAIL];
    }
    
}

- (void)loaddatas {
    
    [self.btnDel setHidden:_action == ACTION_CONSTANTS_ADD];
    if (_action == ACTION_CONSTANTS_ADD) {
        self.titleBox.lblTitle.text = @"添加";
        [self clearDo];
        [self showRdoButtonAndList];
        [self loadMemberCardList];
//        [self showRdoButtonAndListAfterClick:<#(BOOL)#> event:<#(NSInteger)#>];
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
    } else {
        [self showRdoButtonAndList];
        [self selectSalesDetail];
    }
}

#pragma 查询促销活动详情
- (void)selectSalesDetail {
    __weak MarketSalesEditView* weakSelf = self;
    [_marketService selectSaleActDetail:_saleActId completionHandler:^(id json) {
        [weakSelf responseSuccess:json];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark - 加载会员卡列表
// 会员服务化后，使用会员服务化部分的接口
- (void)loadMemberCardList {
    
    __weak typeof(self) wself = self;
    NSString *entityId = [[Platform Instance] getkey:ENTITY_ID];
    NSDictionary *param = @{@"entityId":entityId};
    NSString *url = @"kindCard/list";
    [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        wself.memberCardList = [[LSMemberTypeVo getMemberTypeVos:json[@"data"]] mutableCopy];
        __block NSString *str = @"";
        [wself.saleActVo.salesKindCardVos enumerateObjectsUsingBlock:^(LSSalesKindCardVo *salesKindCardVo, NSUInteger idx, BOOL * _Nonnull stop) {
            [wself.memberCardList enumerateObjectsUsingBlock:^(LSMemberTypeVo *cardVo, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([salesKindCardVo.kindCardId isEqualToString:cardVo.sId]) {
                    cardVo.isSelect = YES;
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"，%@",cardVo.name]];
                }
            }];
        }];
        if ([NSString isNotBlank:str]) {
            str = [str substringFromIndex:1];
            [wself.lstMemberType initData:[NSString stringWithFormat:@"%lu种", (unsigned long)wself.saleActVo.salesKindCardVos.count] withVal:str];
            [wself.lstMemberType initHit:str];
        }
        [UIHelper refreshUI:wself.container scrollview:wself.scrollView];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}


#pragma 后台返回数据封装
- (void)responseSuccess:(id)json {
    
    _saleActVo = [SaleActVo mj_objectWithKeyValues:json[@"saleActVo"]];
    [self loadMemberCardList];
    _shopSalesList = [ShopSalesVo converToArr:[json objectForKey:@"shopSalesVoList"]];
    self.titleBox.lblTitle.text = _saleActVo.name;
    self.selectmemberCardList = [NSMutableArray arrayWithArray:_saleActVo.salesKindCardVos];
    [self fillModel];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)isEdit:(BOOL)flg {
    if (flg) {
        if (!(_saleActVo.salesStatus == 1 && self.saleActVo.currentDay > self.saleActVo.endDate)) {
             //活动已过期的按钮不可修改
             [self.rdoStatus.clickBtn setEnabled:YES];
        }
       
        [self.txtCode editEnabled:YES];
        [self.txtName editEnabled:YES];
        [self.rdoIsMember isEditable:YES];
        [self.lsShopPriceScheme editEnable:YES];
        [self.rdoShopDoubleDiscount isEditable:YES];
        [self.rdoIsWeixin isEditable:YES];
        [self.lsWeixinPriceScheme editEnable:YES];
        [self.rdoWeixinDoubleDiscount isEditable:YES];
        [self.lsStartTime editEnable:YES];
        [self.lsEndTime editEnable:YES];
        [self.rdoIsShopArea isEditable:YES];
        [self.rdoIsShop isEditable:YES];
        self.RTShopList.addBtn.enabled = YES;
        [self.btnDel setHidden:NO];
        [self.btnAdd setHidden:NO];
        [self.rdoMemberType isEditable:YES];
        [self.lstMemberType editEnable:YES];
    } else {
        [self.rdoStatus.clickBtn setEnabled:NO];
        [self.txtCode editEnabled:NO];
        [self.txtName editEnabled:NO];
        [self.rdoIsMember isEditable:NO];
        [self.lsShopPriceScheme editEnable:NO];
        [self.rdoShopDoubleDiscount isEditable:NO];
        [self.rdoIsWeixin isEditable:NO];
        [self.lsWeixinPriceScheme editEnable:NO];
        [self.rdoWeixinDoubleDiscount isEditable:NO];
        [self.lsStartTime editEnable:NO];
        [self.lsEndTime editEnable:NO];
        [self.rdoIsShopArea isEditable:NO];
        [self.rdoIsShop isEditable:NO];
        self.RTShopList.addBtn.enabled = NO;
        [self.btnDel setHidden:YES];
        [self.btnAdd setHidden:YES];
        [self.rdoMemberType isEditable:NO];
        [self.lstMemberType editEnable:NO];
    }
}

#pragma 页面详情数据显示
- (void)fillModel {
    
    if (_saleActVo.salesStatus == 1 && self.saleActVo.currentDay <= self.saleActVo.endDate) {
        [self.rdoStatus initData:@"1"];
        self.rdoStatus.lblName.text = @"活动已生效";
    } else if (_saleActVo.salesStatus == 1 && self.saleActVo.currentDay > self.saleActVo.endDate) {
        [self.rdoStatus initData:@"2"];
        self.rdoStatus.lblName.text = @"活动已过期";
        self.rdoStatus.clickBtn.enabled = NO;
        
    } else if (_saleActVo.salesStatus == 2) {
        [self.rdoStatus initData:@"2"];
        self.rdoStatus.lblName.text = @"活动已失效";
    }
    /*连锁模式：
    当促销活动不是登录用户所属组织添加的，提示文案“提示：该促销活动由＊＊＊＊创建，您只可查看，不可编辑。”
    当促销活动是登录用户所属组织添加的，提示文案“提示：该促销活动由＊＊＊＊创建。”
    （＊＊＊＊表示创建者所属组织名称）
    单店模式：不增加提示信息*/
    if ([[Platform Instance] getShopMode] != 1) {
        NSString *hit = nil;
        if (_saleActVo.ownOrg == 0) {//不是自己创建不可以进行编辑
            hit = [NSString stringWithFormat:@"提示：该促销活动由%@创建，您只可查看，不可编辑。", _saleActVo.ownOrgName];
        } else {
            hit = [NSString stringWithFormat:@"提示：该促销活动由%@创建。", _saleActVo.ownOrgName];
        }
        [self.rdoStatus initHit:hit];
    }
    
    [self.txtCode initData:_saleActVo.code];
    [self.txtCode visibal:YES];
    [self.txtName initData:_saleActVo.name];
    [self.rdoIsMember initData:[NSString stringWithFormat:@"%d", _saleActVo.isMember]];
    [self.rdoMemberType initData:[NSString stringWithFormat:@"%d", _saleActVo.hasKindCard]];
    [self.rdoIsShop initData:[NSString stringWithFormat:@"%d", _saleActVo.isShop]];
    
    [self.lsShopPriceScheme initData:[MarketRender obtainShopPriceScheme:_saleActVo.shopPriceScheme] withVal:[NSString stringWithFormat:@"%d", _saleActVo.shopPriceScheme]];
    [self.rdoShopDoubleDiscount initData:[NSString stringWithFormat:@"%d", _saleActVo.shopDoubleDiscount]];
    
    if ([[self.rdoIsShop getStrVal] isEqualToString:@"0"]) {
        [self.lsShopPriceScheme visibal:NO];
        [self.rdoShopDoubleDiscount visibal:NO];
    }
    
    [self.rdoIsWeixin initData:[NSString stringWithFormat:@"%d", _saleActVo.isWeixin]];
    [self.lsWeixinPriceScheme initData:[MarketRender obtainWeixinPriceScheme:_saleActVo.weixinPriceScheme] withVal:[NSString stringWithFormat:@"%d", _saleActVo.weixinPriceScheme]];
    [self.rdoWeixinDoubleDiscount initData:[NSString stringWithFormat:@"%d", _saleActVo.weixinDoubleDiscount]];
    
    if ([[self.rdoIsWeixin getStrVal] isEqualToString:@"0"]) {
        [self.lsWeixinPriceScheme visibal:NO];
        [self.rdoWeixinDoubleDiscount visibal:NO];
    }
    
    [self.lsStartTime initData:[DateUtils formateTime2:_saleActVo.startDate] withVal:[DateUtils formateTime2:_saleActVo.startDate]];
    
    [self.lsEndTime initData:[DateUtils formateTime2:_saleActVo.endDate] withVal:[DateUtils formateTime2:_saleActVo.endDate]];
    
    
    if ([self.rdoIsShop getVal] || [self.rdoIsWeixin getVal]) {
        /// "适用实体门店"或"适用微店" 未关闭 的情况
        if ([[Platform Instance] getShopMode] == 3) {
            
            if (_saleActVo.shopFlag == 1) {
                // “指定门店范围” 开关关闭
                [self.TitShop visibal:YES];
                [self.rdoIsShopArea visibal:YES];
                [self.rdoIsShopArea initData:@"0"];
                self.shopView.hidden = YES;
                self.RTShopList.hidden = YES;
            } else {
                 // “指定门店范围” 开关打开
                [self.rdoIsShopArea initData:@"1"];
                self.shopView.hidden = NO;
                self.RTShopList.hidden = NO;
                
                if (_shopSalesList != nil && _shopSalesList.count > 0) {
                    for (ShopSalesVo* temp in _shopSalesList) {
                        ShopVo* vo1 = [[ShopVo alloc] init];
                        vo1.shopName = temp.shopName;
                        vo1.code = [NSString stringWithFormat:@"门店编号：%@", temp.shopCode];
                        vo1.shopId = temp.shopId;
                        [_shopList addObject:vo1];
                    }
                    self.RTShopList.isCanDeal = self.isCanDeal;
                    [self.RTShopList loadData:_shopList detailCount:[_shopList count]];
                    self.lblShopNum.text = [NSString stringWithFormat:@"合计%lu个门店", (unsigned long)_shopList.count];
                }
            }
        } else {
            [self.TitShop visibal:NO];
            [self.rdoIsShopArea visibal:NO];
            self.shopView.hidden = YES;
            self.RTShopList.hidden = YES;
        }
        
    } else {
        // "适用实体门店"和"适用微店" 都关闭的情况
        [self.TitShop visibal:NO];
        [self.rdoIsShopArea visibal:NO];
        self.shopView.hidden = YES;
        self.RTShopList.hidden = YES;
    }
    
    if ([self.isCanDeal isEqualToString:@"0"]) {
        [self isEdit:NO];
    }
    [self showMemberView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma 添加页面数据初始化
- (void)clearDo {
    
    [self.rdoStatus visibal:NO];
    [self.txtCode initData:nil];
    [self.txtCode visibal:NO];
    [self.txtName initData:nil];
    [self.rdoIsMember initData:@"0"];
    [self.rdoIsShop initData:@"1"];
    [self.lsShopPriceScheme initData:[MarketRender obtainShopPriceScheme:1] withVal:@"1"];
    [self.rdoShopDoubleDiscount initData:@"0"];
    [self.rdoIsWeixin initData:@"1"];
    [self.lsWeixinPriceScheme initData:[MarketRender obtainWeixinPriceScheme:1] withVal:@"1"];
    [self.rdoWeixinDoubleDiscount initData:@"0"];
    
    NSString *dateString = [DateUtils formateDate2:[NSDate date]];
    [self.lsStartTime initData:dateString withVal:dateString];
    [self.lsEndTime initData:dateString withVal:dateString];
    [self.rdoIsShopArea initData:@"1"];
    [self.RTShopList loadData:nil detailCount:0];
    [self showMemberView];
}

#pragma 各种促销活动下，页面信息显示
- (void)showRdoButtonAndList {
    
    if (_fromViewTag == PIECES_DISCOUNT_LIST_VIEW || _fromViewTag == BINDING_DISCOUNT_LIST_VIEW) {
        
        // 适用实体门店开关
        self.rdoIsShop.btnRadio.enabled = YES;
        
        // 适用实体门店-价格方案
        if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
            [self.lsShopPriceScheme visibal:YES];
        } else {
            [self.lsShopPriceScheme visibal:NO];
        }
        
        //适用实体门店-会员消费时享受折上折
        [self.rdoShopDoubleDiscount visibal:YES];
        
        // 适用微店开关, 连锁默认打开，门店/单店需判断是否开通微店
        if ([[Platform Instance] getShopMode] == 3 || [[Platform Instance] getMicroShopStatus] == 2) {
            [self.rdoIsWeixin initData:@"1"];
            self.rdoIsWeixin.btnRadio.enabled = YES;
        } else {
            [self.rdoIsWeixin initData:@"0"];
            self.rdoIsWeixin.btnRadio.enabled = NO;
        }

        //适用微店-价格方案
        if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101 && [self.rdoIsWeixin getVal]) {
            [self.lsWeixinPriceScheme visibal:YES];
        } else {
            [self.lsWeixinPriceScheme visibal:NO];
        }
        
        //适用微店-会员消费时享受折上折
        if ([self.rdoIsWeixin getVal]) {
            [self.rdoWeixinDoubleDiscount visibal:YES];
        } else {
            [self.rdoWeixinDoubleDiscount visibal:NO];
        }
        
    } else if (_fromViewTag == SALES_SEND_OR_SWAP_LIST_VIEW || _fromViewTag == SALES_MINUS_LIST_VIEW){
      
        //适用实体门店开关
        self.rdoIsShop.btnRadio.enabled = YES;
        
        //适用实体门店-价格方案
        [self.lsShopPriceScheme visibal:NO];
        
        //适用实体门店-会员消费时享受折上折
        [self.rdoShopDoubleDiscount visibal:NO];
        
        //适用微店开关
        [self.rdoIsWeixin initData:@"1"];
        self.rdoIsWeixin.btnRadio.enabled = YES;
        
        //适用微店-价格方案
        [self.lsWeixinPriceScheme visibal:NO];
        
        //适用微店-会员消费时享受折上折
        [self.rdoWeixinDoubleDiscount visibal:NO];
        
    } else if (_fromViewTag == SALES_COUPON_LIST_VIEW){
        
        //适用实体门店开关
        self.rdoIsShop.btnRadio.enabled = NO;
        //适用实体门店-价格方案
        [self.lsShopPriceScheme visibal:NO];
        //适用实体门店-会员消费时享受折上折
        [self.rdoShopDoubleDiscount visibal:NO];
        
        //适用微店开关
        [self.rdoIsWeixin initData:@"0"];
        //适用微店-价格方案
        [self.lsWeixinPriceScheme visibal:NO];
        //适用微店-会员消费时享受折上折
        [self.rdoWeixinDoubleDiscount visibal:NO];
        
    } else if (_fromViewTag == SPECIAL_OFFER_LIST_VIEW) {
        
         //特价管理
         [self.rdoShopDoubleDiscount visibal:NO];
         [self.rdoWeixinDoubleDiscount visibal:NO];
         if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 102) {
             //价格方案：选择项，服鞋模式显示，商超模式隐藏；
             [self.lsShopPriceScheme visibal:NO];
             [self.lsWeixinPriceScheme visibal:NO];
         } else {
             [self.lsWeixinPriceScheme visibal:!self.rdoIsWeixin.hidden];
         }
    }
    
    // 非“优惠券”的情况下
//    if (_fromViewTag != SALES_COUPON_LIST_VIEW) {
//        
//        self.rdoIsWeixin.btnRadio.enabled = YES;
//        
//        // 连锁总部
//        if ([[Platform Instance] getShopMode] == 3 && [[[Platform Instance] getkey:PARENT_ID] isEqualToString:@"0"]) {
//            if ([[Platform Instance] getMicroShopStatus] == 2) {
//                self.rdoIsShop.btnRadio.enabled = YES;
//            } else {
//                self.rdoIsShop.btnRadio.enabled = NO;
//            }
//        } else if ([[Platform Instance] getShopMode] == 1) {
//            // 单店
//            if ([[Platform Instance] getMicroShopStatus] == 2) {
//                self.rdoIsShop.btnRadio.enabled = YES;
//            } else {
//                self.rdoIsShop.btnRadio.enabled = NO;
//            }
//        }
//        else if ([[Platform Instance] getShopMode] == 2) {
//            // 连锁门店
//            self.rdoIsShop.btnRadio.enabled = NO;
//        }
//    }
    
    // 门店，非总部机构用户 
//    if (([[Platform Instance] getShopMode] == 3 && ![[[Platform Instance] getkey:PARENT_ID] isEqualToString:@"0"])
//        || [[Platform Instance] getShopMode] == 2 ) {
//        [self.lsWeixinPriceScheme visibal:NO];
//        [self.rdoWeixinDoubleDiscount visibal:NO];
//        [self.rdoIsShop isEditable:NO];
//    }
}

#pragma 页面初始化
- (void)initMainView {
    
    [self.rdoStatus initLabel:@"活动已生效" withHit:@"" delegate:self];
    [self.rdoStatus.line setHidden:YES];
    self.TitBase.lblName.text = @"基本设置";
    [self.txtCode initLabel:@"活动编号" withHit:nil isrequest:YES type:UIKeyboardTypeAlphabet];
    [self.txtCode editEnabled:NO];
    [self.txtCode initMaxNum:20];
    [self.txtName initLabel:@"活动名称" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtName initMaxNum:50];
    [self.rdoIsMember initLabel:@"会员专享" withHit:nil delegate:self];
    [self.rdoMemberType initLabel:@"指定会员卡类型" withHit:nil delegate:self];
    self.lstMemberType.lblDetail.textAlignment = NSTextAlignmentRight;
    [self.lstMemberType initLabel:@"▪︎ 适用会员卡类型" withHit:nil delegate:self];
    [self.lstMemberType initData:@"全部" withVal:nil];
    self.lstMemberType.imgMore.image = [UIImage imageNamed:@"ico_next"];
    [self.rdoIsShop initLabel:@"适用实体门店" withHit:nil delegate:self];
    NSString *hit = _fromViewTag == SPECIAL_OFFER_LIST_VIEW ? @"此项在特价方案选择“设置折扣率”时生效" : nil;
    [self.lsShopPriceScheme initLabel:@"▪︎ 价格方案" withHit:hit delegate:self];
    [self.rdoShopDoubleDiscount initLabel:@"▪︎ 会员消费时享受折上折" withHit:nil delegate:self];
    if ([[Platform Instance] getShopMode] == 3) {
        [self.rdoIsWeixin initLabel:@"适用微店" withHit:@"开启后，指定促销门店的微店同样适用" delegate:self];
    } else {
        [self.rdoIsWeixin initLabel:@"适用微店" withHit:nil delegate:self];
    }
    [self.lsWeixinPriceScheme initLabel:@"▪︎ 价格方案" withHit:hit delegate:self];
    [self.rdoWeixinDoubleDiscount initLabel:@"▪︎ 会员消费时享受折上折" withHit:nil delegate:self];
    self.TitValidDate.lblName.text = @"有效期设置";
    [self.lsStartTime initLabel:@"开始日期" withHit:nil delegate:self];
    [self.lsEndTime initLabel:@"结束日期" withHit:nil delegate:self];
    self.TitShop.lblName.text = @"促销门店设置";
    [self.rdoIsShopArea initLabel:@"指定门店范围" withHit:nil delegate:self];
    self.lblShopNum.text = @"合计0个门店";
    [self.RTShopList initDelegate:self event:MARKET_SALES_EDIT_SHOP_EVENT kindName:@"" addName:@"添加活动门店..."];
    [self.RTShopList loadData:nil  detailCount:0];
    self.RTShopList.viewTag = MARKET_SALES_EDIT_VIEW;
    
    self.lsShopPriceScheme.tag = MARKET_SALES_EDIT_ISSHOP_SHOPPRICESCHEME;
    self.lsWeixinPriceScheme.tag = MARKET_SALES_EDIT_ISWEIXIN_SHOPPRICESCHEME;
    self.lsStartTime.tag = MARKET_SALES_EDIT_STARTDATE;
    self.lsEndTime.tag = MARKET_SALES_EDIT_ENDDATE;
    self.rdoIsShopArea.tag = MARKET_SALES_EDIT_SHOPAREA;
    self.rdoIsShop.tag = MARKET_SALES_EDIT_ISSHOP;
    self.rdoIsWeixin.tag = MARKET_SALES_EDIT_ISWEIXIN;
    self.rdoStatus.tag = MARKET_SALES_EDIT_ISSTATUS;
    self.lstMemberType.tag = TAG_LST_MEMBER_TYPE;

    // 单店或者是门店：隐藏底部门店选择相关控件
    if ([[Platform Instance] getShopMode] != 3) {
        [self.TitShop visibal:NO];
        [self.rdoIsShopArea visibal:NO];
        self.RTShopList.hidden = YES;
        self.shopView.hidden = YES;
        // 单店和门店 关闭了微店，隐藏微店相关项
        if ([[Platform Instance] getMicroShopStatus] != 2) {
            [self.rdoIsWeixin visibal:NO];
            [self.rdoWeixinDoubleDiscount visibal:NO];
            [self.lsWeixinPriceScheme visibal:NO];
        }
    }
    
    // 优惠券活动不显示适用微店，不论是否开通微店
    if (_fromViewTag == SALES_COUPON_LIST_VIEW) {
        [self.rdoIsWeixin visibal:NO];
    }

    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma mark - 判断会员专享 制定会员卡类型  使用会员卡类型 3个东西的显示
- (void)showMemberView {
    
    if (_fromViewTag  == SALES_COUPON_LIST_VIEW) {
        
        //优惠券不显示会员卡类型 及制定会员卡类型
        [self.rdoMemberType visibal:NO];
        [self.lstMemberType visibal:NO];
        return;
    }
    [self.rdoMemberType visibal:[self.rdoIsMember getVal]];
    [self.lstMemberType visibal:[self.rdoIsMember getVal]];
    if (_fromViewTag == SPECIAL_OFFER_LIST_VIEW) {
        
        //特价管理
        if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
            //价格方案：选择项，服鞋模式显示，商超模式隐藏；
            if (self.rdoIsShop.hidden == NO) {
                [self.lsShopPriceScheme visibal:[self.rdoIsShop getVal]];
            }
            if (!([[Platform Instance] getShopMode] == 3 && ![[Platform Instance] isTopOrg])){
                //机构用户不显示此选项
                if (self.rdoIsWeixin.hidden == NO) {
                    [self.lsWeixinPriceScheme visibal:[self.rdoIsWeixin getVal]];
                }
            }
        }
    }
}

#pragma 导航栏事件
- (void)onNavigateEvent:(Direct_Flag)event {
    
    if (event == DIRECT_LEFT) {
        // 返回到促销活动一览页面
        if (_action == ACTION_CONSTANTS_ADD) {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        } else {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        }
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        [self save];
    }
}

- (IBAction)addShopAreaButton:(id)sender {
    [self showAddEvent:nil];
}

#pragma 添加促销门店范围事件
- (void)showAddEvent:(NSString *)event {
    
    if (_shopList.count >= 50) {
        [AlertBox show:@"促销门店数量已达到上限，请先删除再添加!"]; return ;
    }
    
    //跳转页面至选择门店
    SelectOrgShopListView* selectOrgShopListView = [[SelectOrgShopListView alloc] init];
    [self.navigationController pushViewController:selectOrgShopListView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    __weak MarketSalesEditView* weakSelf = self;
    [selectOrgShopListView loadData:[[Platform Instance] getkey:SHOP_ID] withModuleType:3 withCheckMode:MUTIl_CHECK callBack:^(NSMutableArray *selectArr, id<ITreeItem> item) {
        [weakSelf.navigationController popToViewController:weakSelf animated:NO];
        [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        if (selectArr) {
            for (id<ITreeItem> tempVo in selectArr) {
                if ([tempVo obtainItemType] == 2) {
                    ShopVo* vo1 = [[ShopVo alloc] init];
                    vo1.shopName = [tempVo obtainItemName];
                    vo1.code = [NSString stringWithFormat:@"门店编号：%@", [tempVo obtainItemValue]];
                    vo1.shopId = [tempVo obtainItemId];
                    
                    //判断原来shop列表中是否已经存在
                    BOOL flg = NO;
                    for (ShopVo* temp in weakSelf.shopList) {
                        if ([vo1.shopId isEqualToString:temp.shopId]) {
                            flg = YES;
                            break;
                        }
                    }
                    if (!flg) {
                        [weakSelf.shopList addObject:vo1];
                    }
                }
            }
            
            [weakSelf.RTShopList loadData:weakSelf.shopList detailCount:[weakSelf.shopList count]];
            weakSelf.lblShopNum.text = [NSString stringWithFormat:@"合计%lu个门店", (unsigned long)weakSelf.shopList.count];
            [UIHelper refreshUI:weakSelf.container scrollview:weakSelf.scrollView];
            [self.titleBox editTitle:YES act:self.action];
        }
    }];
}

#pragma 点击促销门店cell事件
- (void)showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>)obj { }

#pragma 点击删除促销门店事件
- (void)delObjEvent:(NSString *)event obj:(id)obj {
   
    _tempVo = (ShopVo *)obj;
    for (ShopVo* temp in self.shopList) {
        if ([[temp obtainItemId] isEqualToString:[_tempVo obtainItemId]]) {
            [self.shopList removeObject:temp]; break ;
        }
    }
    [self.RTShopList loadData:self.shopList detailCount:[self.shopList count]];
    self.lblShopNum.text = [NSString stringWithFormat:@"合计%lu个门店", (unsigned long)self.shopList.count];
    [self.titleBox editTitle:YES act:self.action];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    [self.titleBox editTitle:YES act:self.action];
}

#pragma 开关事件
- (void)onItemRadioClick:(EditItemRadio *)obj {
    
    BOOL isOpened = [[obj getStrVal] isEqualToString:@"1"];
    if (obj == self.rdoIsMember) {
        //打开会员专享开关判断有没有添加会员任何卡类型的 如果没有则提示您还没有设置会员卡类型,请先设置会员卡类型!
        if ([obj getVal] && self.memberCardList.count == 0) {
            [self.rdoIsMember changeData:@"0"];
            [LSAlertHelper showAlert:@"您还没有设置会员卡类型,请先设置会员卡类型!"]; return;
        }
    }
    
    if (obj.tag == MARKET_SALES_EDIT_SHOPAREA) {
        
        self.shopView.hidden = !isOpened;
        self.RTShopList.hidden = !isOpened;
        
    } else if (obj.tag == MARKET_SALES_EDIT_ISSHOP || obj.tag == MARKET_SALES_EDIT_ISWEIXIN) {
        
        if ([obj getVal] && !([_rdoIsShop getVal] && [_rdoIsWeixin getVal])) {
            [self.TitShop visibal:YES];
            [self.rdoIsShopArea visibal:YES];
            if (_saleActVo.shopFlag == 1) {
                [self.rdoIsShopArea initData:@"0"];
                self.shopView.hidden = YES;
                self.RTShopList.hidden = YES;
            } else {
                [self.rdoIsShopArea initData:@"1"];
                self.shopView.hidden = NO;
                self.RTShopList.hidden = NO;
            }
        }
        [self showRdoButtonAndListAfterClick:isOpened event:obj.tag];
    }
    if (obj.tag == MARKET_SALES_EDIT_ISSTATUS) {
        self.rdoStatus.lblName.text = [self.rdoStatus getVal]?@"活动已生效":@"活动已失效";
    }
    [self showMemberView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

// 相关子选项的显示与隐藏
- (void)showRdoButtonAndListAfterClick:(BOOL)result event:(NSInteger)event {
  
    // 点击是否适用门店开关
    if (event == MARKET_SALES_EDIT_ISSHOP) {
        if (result) {
          
            // 开关打开的时候
            if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
                // 服鞋模式
                // N件打折or捆绑打折
                if (_fromViewTag == PIECES_DISCOUNT_LIST_VIEW || _fromViewTag == BINDING_DISCOUNT_LIST_VIEW) {
                    // 适用实体门店：价格方案打开，折上折打开
                    [self.lsShopPriceScheme visibal:YES];
                    [self.rdoShopDoubleDiscount visibal:YES];
                } else if (_fromViewTag == SALES_SEND_OR_SWAP_LIST_VIEW || _fromViewTag == SALES_MINUS_LIST_VIEW) {
                    // 适用实体门店：价格方案隐藏，折上折隐藏
                } else if (_fromViewTag == SALES_COUPON_LIST_VIEW) {
                    // 适用实体门店：价格方案隐藏，折上折隐藏
                }
            } else {
                // 商超模式
                // N件打折or捆绑打折
                if (_fromViewTag == PIECES_DISCOUNT_LIST_VIEW || _fromViewTag == BINDING_DISCOUNT_LIST_VIEW) {
                    // 适用实体门店：价格方案隐藏，折上折打开
                    [self.rdoShopDoubleDiscount visibal:YES];
                } else if (_fromViewTag == SALES_SEND_OR_SWAP_LIST_VIEW || _fromViewTag == SALES_MINUS_LIST_VIEW) {
                    // 适用实体门店：价格方案隐藏，折上折隐藏
                } else if (_fromViewTag == SALES_COUPON_LIST_VIEW) {
                    // 适用实体门店：价格方案隐藏，折上折隐藏
                }
            }
        } else {
            // 开关关闭的时候
            [self.lsShopPriceScheme visibal:NO];
            [self.rdoShopDoubleDiscount visibal:NO];
            // 和"适用微店"联动
            if ([self.rdoIsWeixin getVal] == NO) {
                [self.rdoIsWeixin changeData:@"1"];
                [self showRdoButtonAndListAfterClick:YES event:MARKET_SALES_EDIT_ISWEIXIN];
            }
        }
    } else if (event == MARKET_SALES_EDIT_ISWEIXIN) {
       
        // 点击是否适用微店开关
        if (result) {
            // 开关打开的时候
            if ([[Platform Instance] getkey:SHOP_MODE].integerValue == 101) {
                // 服鞋模式
                if (_fromViewTag == PIECES_DISCOUNT_LIST_VIEW || _fromViewTag == BINDING_DISCOUNT_LIST_VIEW) {
                    // 适用微店：价格方案打开，折上折打开
                    [self.lsWeixinPriceScheme visibal:YES];
                    [self.rdoWeixinDoubleDiscount visibal:YES];
                } else if (_fromViewTag == SALES_SEND_OR_SWAP_LIST_VIEW || _fromViewTag == SALES_MINUS_LIST_VIEW) {
                    // 适用微店：价格方案隐藏，折上折隐藏
                } else if (_fromViewTag == SALES_COUPON_LIST_VIEW) {
                    // 适用微店：价格方案隐藏，折上折隐藏
                }
            } else {
                // 商超模式
                // N件打折or捆绑打折
                if (_fromViewTag == PIECES_DISCOUNT_LIST_VIEW || _fromViewTag == BINDING_DISCOUNT_LIST_VIEW) {
                    // 适用实体门店：价格方案隐藏，折上折打开
                    [self.rdoWeixinDoubleDiscount visibal:YES];
                } else if (_fromViewTag == SALES_SEND_OR_SWAP_LIST_VIEW || _fromViewTag == SALES_MINUS_LIST_VIEW) {
                    // 适用实体门店：价格方案隐藏，折上折隐藏
                } else if (_fromViewTag == SALES_COUPON_LIST_VIEW) {
                    // 适用实体门店：价格方案隐藏，折上折隐藏
                }
            }
        } else {
            // 开关关闭的时候
            [self.lsWeixinPriceScheme visibal:NO];
            [self.rdoWeixinDoubleDiscount visibal:NO];
            // 和“适用门店”联动
            if ([self.rdoIsShop getVal] == NO) {
                [self.rdoIsShop changeData:@"1"];
                [self showRdoButtonAndListAfterClick:YES event:MARKET_SALES_EDIT_ISSHOP];
            }
        }
    }
}

#pragma 下拉框事件
- (void)onItemListClick:(EditItemList *)obj {
    if (obj.tag == MARKET_SALES_EDIT_ISSHOP_SHOPPRICESCHEME) {
        [OptionPickerBox initData:[MarketRender listShopPriceScheme]itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    } else if (obj.tag == MARKET_SALES_EDIT_ISWEIXIN_SHOPPRICESCHEME) {
        [OptionPickerBox initData:[MarketRender listWeixinPriceScheme]itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    } else if (obj.tag == MARKET_SALES_EDIT_STARTDATE || obj.tag == MARKET_SALES_EDIT_ENDDATE) {
        NSDate *date=[DateUtils parseDateTime4:obj.lblVal.text];
        [DatePickerBox show:obj.lblName.text date:date client:self event:(int)obj.tag];
    }
    else if (obj == self.lstMemberType) { //制定会员卡类型
        LSMemberCardListController *vc = [[LSMemberCardListController alloc] init];
        __weak typeof(self) wself = self;
        __block NSString *str = @"";
        if ([[self.lstMemberType getDataLabel] isEqualToString:@"全部"]) {
            [self.memberCardList enumerateObjectsUsingBlock:^(LSMemberTypeVo *cardVo, NSUInteger idx, BOOL * _Nonnull stop) {
                cardVo.isSelect = YES;
            }];
        }
        [vc loadData:self.memberCardList callBlock:^(NSMutableArray *list) {
            NSMutableArray *array = [NSMutableArray array];
            [list enumerateObjectsUsingBlock:^(LSMemberTypeVo *memberCardVo, NSUInteger idx, BOOL * _Nonnull stop) {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"，%@",memberCardVo.name]];
                LSSalesKindCardVo *salesKindCardVo = [[LSSalesKindCardVo alloc] init];
                salesKindCardVo.selectStatus = memberCardVo.isSelect;
                salesKindCardVo.kindCardId = memberCardVo.sId;
                salesKindCardVo.memo = memberCardVo.memo;
                salesKindCardVo.ratio = memberCardVo.ratio.floatValue;
                salesKindCardVo.kindCardName = memberCardVo.name;
                salesKindCardVo.ratioExchangeDegree = memberCardVo.ratioExchangeDegree;
                salesKindCardVo.canUpgrade = memberCardVo.upDegree > 0;
                salesKindCardVo.lastVer = (int)memberCardVo.lastVer;
//                salesKindCardVo.checked = memberCardVo.checked;
                salesKindCardVo.mode = (int)memberCardVo.mode;
                [array addObject:salesKindCardVo];
            }];
            wself.selectmemberCardList = array;
            str = [str substringFromIndex:1];
            [wself.lstMemberType initHit:str];
            [wself.lstMemberType changeData:[NSString stringWithFormat:@"%ld种", list.count] withVal:str];
            [UIHelper refreshUI:wself.container scrollview:wself.scrollView];
            
        }];
        ;
        [self.navigationController pushViewController:vc animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    }
}

// 拾取器值更改
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == MARKET_SALES_EDIT_ISSHOP_SHOPPRICESCHEME) {
        [self.lsShopPriceScheme changeData:[item obtainItemName] withVal:[item obtainItemId]];
    } else if (eventType == MARKET_SALES_EDIT_ISWEIXIN_SHOPPRICESCHEME) {
        [self.lsWeixinPriceScheme changeData:[item obtainItemName] withVal:[item obtainItemId]];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

//选择日期
- (BOOL)pickDate:(NSDate *)date event:(NSInteger)event {
    
    if (event == MARKET_SALES_EDIT_STARTDATE) {
        NSString* dateStr=[DateUtils formateDate2:date];
        [self.lsStartTime changeData:dateStr withVal:dateStr];
    } else if (event == MARKET_SALES_EDIT_ENDDATE) {
        NSString* dateStr=[DateUtils formateDate2:date];
        [self.lsEndTime changeData:dateStr withVal:dateStr];
    }
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    return YES;
}

#pragma 保存事件
- (void)save
{
    if (![self isValid]){
        return;
    }
    
    __weak MarketSalesEditView* weakSelf = self;
    if (_action == ACTION_CONSTANTS_ADD) {
        _saleActVo = [[SaleActVo alloc] init];
        _saleActVo.salesStatus = 1;
        _saleActVo.name = [self.txtName getStrVal];
        _saleActVo.code = [self.txtCode getStrVal];
        _saleActVo.isMember = [[self.rdoIsMember getStrVal] integerValue];
        if ([[self.rdoIsMember getStrVal] integerValue] == 1) {
            _saleActVo.hasKindCard = self.selectmemberCardList.count > 0;
        } else {
            _saleActVo.hasKindCard = 0;
        }
        if ([self.selectmemberCardList count] == 0) {
            _saleActVo.salesKindCardVos = [NSMutableArray array];
        } else {
            _saleActVo.salesKindCardVos = self.selectmemberCardList;
        }
        _saleActVo.isShop = [[self.rdoIsShop getStrVal] integerValue];
        if ([NSString isNotBlank:[self.lsShopPriceScheme getStrVal]]) {
            _saleActVo.shopPriceScheme = [[self.lsShopPriceScheme getStrVal] integerValue];
        }
        _saleActVo.shopDoubleDiscount = [[self.rdoShopDoubleDiscount getStrVal] integerValue];
        if (!self.rdoIsWeixin.isHidden) {
            _saleActVo.isWeixin = [[self.rdoIsWeixin getStrVal] integerValue];
        }else{
            _saleActVo.isWeixin = 0;
        }
        
        if ([NSString isNotBlank:[self.lsWeixinPriceScheme getStrVal]]) {
            _saleActVo.weixinPriceScheme = [[self.lsWeixinPriceScheme getStrVal] integerValue];
        }
        _saleActVo.weixinDoubleDiscount = [[self.rdoWeixinDoubleDiscount getStrVal] integerValue];
        
        _saleActVo.startDate = [DateUtils formateDateTime2:[NSString stringWithFormat:@"%@ 00:00:00", [self.lsStartTime getStrVal]]];
        
        _saleActVo.endDate = [DateUtils formateDateTime2:[NSString stringWithFormat:@"%@ 23:59:59", [self.lsEndTime getStrVal]]] ;
        _saleActVo.shopFlag = [[self.rdoIsShopArea getStrVal] integerValue];
        if ([[Platform Instance] getShopMode] == 3) {
            if ([NSString isBlank:[self.rdoIsShopArea getStrVal]] || [[self.rdoIsShopArea getStrVal] isEqualToString:@"0"]) {
                _saleActVo.shopFlag = 1;
                _shopIdList = nil;
            } else {
                _saleActVo.shopFlag = 2;
                _shopIdList = [[NSMutableArray alloc] init];
                for (ShopVo* vo in _shopList) {
                    [_shopIdList addObject:vo.shopId];
                }
            }
        } else {
            _saleActVo.shopFlag = 0;
        }
        
        if (_fromViewTag == PIECES_DISCOUNT_LIST_VIEW){
            //N件打折
            _saleActVo.salesType = 1;
        } else if (_fromViewTag == SALES_MINUS_LIST_VIEW){
            //满减
            _saleActVo.salesType = 2;
        } else if (_fromViewTag == SALES_SEND_OR_SWAP_LIST_VIEW){
            //满送or换购
            _saleActVo.salesType = 3;
        } else if (_fromViewTag == BINDING_DISCOUNT_LIST_VIEW){
            //捆绑打折
            _saleActVo.salesType = 4;
        } else if (_fromViewTag == SALES_COUPON_LIST_VIEW) {
            //优惠券
            _saleActVo.salesType = 5;
        } else if (_fromViewTag == SPECIAL_OFFER_LIST_VIEW) {
            //特价管理
            _saleActVo.salesType = 7;
        }

        
        [_marketService saveSaleAct:_saleActVo.mj_keyValues shopIdList:_shopIdList operateType:@"add" completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                if ([vc isKindOfClass:[LSMarketListController class]]) {
                    LSMarketListController *listView = (LSMarketListController *)vc;
                    [listView loadDatasFromEditView:ACTION_CONSTANTS_ADD];
                }
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    } else {
        if ([self.rdoStatus.lblName.text isEqualToString:@"活动已生效"]) {
            _saleActVo.salesStatus = 1;
        } else if ([self.rdoStatus.lblName.text isEqualToString:@"活动已过期"]) {
            _saleActVo.salesStatus = 1;
        } else if ([self.rdoStatus.lblName.text isEqualToString:@"活动已失效"]) {
            _saleActVo.salesStatus = 2;
        }
        _saleActVo.name = [self.txtName getStrVal];
        _saleActVo.code = [self.txtCode getStrVal];
        _saleActVo.isMember = [[self.rdoIsMember getStrVal] integerValue];
        if ([[self.rdoIsMember getStrVal] integerValue] == 1) {
//            _saleActVo.hasKindCard = [[self.rdoMemberType getStrVal] integerValue];
            _saleActVo.hasKindCard = self.selectmemberCardList.count > 0;
        } else {
            _saleActVo.hasKindCard = 0;
        }
        
        if ([self.selectmemberCardList count] == 0) {
            _saleActVo.salesKindCardVos = [NSMutableArray array];
        } else {
            _saleActVo.salesKindCardVos = self.selectmemberCardList;
        }
    
        _saleActVo.isShop = [[self.rdoIsShop getStrVal] integerValue];
        if ([NSString isNotBlank:[self.lsShopPriceScheme getStrVal]]) {
            _saleActVo.shopPriceScheme = [[self.lsShopPriceScheme getStrVal] integerValue];
        }
        _saleActVo.shopDoubleDiscount = [[self.rdoShopDoubleDiscount getStrVal] integerValue];
        if (!self.rdoIsWeixin.isHidden) {
            _saleActVo.isWeixin = [[self.rdoIsWeixin getStrVal] integerValue];
        } else{
            _saleActVo.isWeixin = 0;
        }
        
        if ([NSString isNotBlank:[self.lsWeixinPriceScheme getStrVal]]) {
            _saleActVo.weixinPriceScheme = [[self.lsWeixinPriceScheme getStrVal] integerValue];
        }
        _saleActVo.weixinDoubleDiscount = [[self.rdoWeixinDoubleDiscount getStrVal] integerValue];
        
        _saleActVo.startDate = [DateUtils formateDateTime2:[NSString stringWithFormat:@"%@ 00:00:00", [self.lsStartTime getStrVal]]];
        
        _saleActVo.endDate = [DateUtils formateDateTime2:[NSString stringWithFormat:@"%@ 23:59:59", [self.lsEndTime getStrVal]]];
        _saleActVo.shopFlag = [[self.rdoIsShopArea getStrVal] integerValue];
        if ([[Platform Instance] getShopMode] == 3) {
            if ([NSString isBlank:[self.rdoIsShopArea getStrVal]] || [[self.rdoIsShopArea getStrVal] isEqualToString:@"0"]) {
                _saleActVo.shopFlag = 1;
                _shopIdList = nil;
            } else {
                _saleActVo.shopFlag = 2;
                _shopIdList = [[NSMutableArray alloc] init];
                for (ShopVo* vo in _shopList) {
                    [_shopIdList addObject:vo.shopId];
                }
            }
        } else {
            _saleActVo.shopFlag = 0;
        }
        
        if (_fromViewTag == PIECES_DISCOUNT_LIST_VIEW){
            //N件打折
            _saleActVo.salesType = 1;
        } else if (_fromViewTag == SALES_MINUS_LIST_VIEW){
            //满减
            _saleActVo.salesType = 2;
        } else if (_fromViewTag == SALES_SEND_OR_SWAP_LIST_VIEW){
            //满送or换购
            _saleActVo.salesType = 3;
        } else if (_fromViewTag == BINDING_DISCOUNT_LIST_VIEW){
            //捆绑打折
            _saleActVo.salesType = 4;
        } else if (_fromViewTag == SALES_COUPON_LIST_VIEW) {
            //优惠券
            _saleActVo.salesType = 5;
        }

        [_marketService saveSaleAct:_saleActVo.mj_keyValues shopIdList:_shopIdList operateType:@"edit" completionHandler:^(id json) {
            if (!(weakSelf)) {
                return ;
            }
            for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                if ([vc isKindOfClass:[LSMarketListController class]]) {
                    LSMarketListController *listView = (LSMarketListController *)vc;
                    [listView loadDatasFromEditView:ACTION_CONSTANTS_EDIT];
                }
            }
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    }
}

#pragma save-data
- (BOOL)isValid
{
    if ([NSString isNotBlank:[self.txtCode getStrVal]] && [NSString isNotNumAndLetter:[self.txtCode getStrVal]]) {
        [AlertBox show:@"活动编号必须为英数字，请重新输入!"];
        return NO;
    }
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:@"活动名称不能为空，请输入!"];
        return NO;
    }
    if ((self.lstMemberType.hidden == NO) && [[self.lstMemberType getDataLabel] isEqualToString:@"请选择"]) {
        [AlertBox show:@"请选择会员卡类型！"];
        return NO;
    }
    
    if (!self.rdoIsShop.isHidden && !self.rdoIsWeixin.isHidden && [[self.rdoIsShop getStrVal] isEqualToString:@"0"] && [[self.rdoIsWeixin getStrVal] isEqualToString:@"0"]) {
        [AlertBox show:@"适用实体门店开关和适用微店开关不能同时关闭，请重新选择!"];
        return NO;
    }
    
    long long date = [DateUtils formateDateTime3:[DateUtils formateDate2:[NSDate date]]];
    if ([DateUtils formateDateTime3:[self.lsEndTime getStrVal]] < date) {
        [AlertBox show:@"促销活动结束时间不能小于活当前时间！"];
        return NO;
    }
    
    if ([DateUtils formateDateTime3:[self.lsEndTime getStrVal]] < [DateUtils formateDateTime3:[self.lsStartTime getStrVal]]) {
        [AlertBox show:@"促销活动结束时间不能小于活动开始时间！"];
        return NO;
    }
    
    if ([[Platform Instance] getShopMode] == 3 && !self.rdoIsShopArea.isHidden && [[self.rdoIsShopArea getStrVal] isEqualToString:@"1"] && self.shopList.count == 0) {
        [AlertBox show:@"请选择指定门店范围!"];
        return NO;
    }
    
    return YES;
}

#pragma 删除按钮
- (IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:@"确认要删除该促销活动吗？"];
}

#pragma delete
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if(buttonIndex == 0){
        __weak MarketSalesEditView* weakSelf = self;
        if (self.action == ACTION_CONSTANTS_EDIT) {
            [_marketService deleteSaleActDetail:_saleActId completionHandler:^(id json) {
                if (!(weakSelf)) {
                    return ;
                }
                [self delFinish];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
        }
    }
}

#pragma finish delete
- (void)delFinish
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[LSMarketListController class]]) {
            LSMarketListController *listView = (LSMarketListController *)vc;
            [listView loadDatasFromEditView:ACTION_CONSTANTS_DEL];
        }
    }
    [self.navigationController popViewControllerAnimated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
}

- (void)initHead
{
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
}

#pragma notification 处理.
- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_MarketSalesEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_MarketSalesEditView_Change object:nil];
}

#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification*) notification
{
    [self.titleBox editTitle:[UIHelper currChange:self.container] act:self.action];
}

@end
