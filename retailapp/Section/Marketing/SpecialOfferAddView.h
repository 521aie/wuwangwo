//
//  SpecialOfferAddView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/11/6.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionPickerClient.h"
#import "NavigateTitle2.h"
//#import "MemberTypeVo.h"
#import "FooterListEvent.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"
#import "ISampleListEvent.h"
#import "IEditItemMemoEvent.h"
#import "SymbolNumberInputBox.h"
#import "DatePickerBox.h"

@class EditItemText, EditItemRadio, EditItemList, ItemTitle, RetailTable2, PriceRuleVo, PriceInfoVo;
@class MarketModule, FooterListView;
@interface SpecialOfferAddView : BaseViewController<INavigateEvent, OptionPickerClient,IEditItemRadioEvent, FooterListEvent, IEditItemListEvent, ISampleListEvent, IEditItemMemoEvent, SymbolNumberInputClient, DatePickerClient, UIActionSheetDelegate>

@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;

//特价设置
@property (nonatomic, strong) IBOutlet ItemTitle *TitSpecial;

//会员专享
@property (nonatomic, strong) IBOutlet EditItemRadio *rdoIsMember;

//是否适用门店
@property (nonatomic, strong) IBOutlet EditItemRadio *rdoIsShop;

//是否适用微信
@property (nonatomic, strong) IBOutlet EditItemRadio *rdoIsWeiXin;

//特价方案
@property (nonatomic, strong) IBOutlet EditItemList *lsSaleScheme;

//价格方案
@property (nonatomic, strong) IBOutlet EditItemList *lsShopPriceScheme;

//折扣率
@property (nonatomic, strong) IBOutlet EditItemList *lsDiscountRate;

//特价
@property (nonatomic, strong) IBOutlet EditItemList *lsSalePrice;

//有效期设置
@property (nonatomic, strong) IBOutlet ItemTitle *TitValidDate;

//开始时间
@property (nonatomic, strong) IBOutlet EditItemList *lsStartTime;

//结束时间
@property (nonatomic, strong) IBOutlet EditItemList *lsEndTime;

//促销门店设置
@property (nonatomic, strong) IBOutlet ItemTitle *TitShop;

//促销门店
@property (nonatomic, strong) IBOutlet UIView *shopView;

//指定门店范围
@property (nonatomic, strong) IBOutlet EditItemRadio *rdoIsShopArea;

//促销门店
@property (nonatomic, strong) IBOutlet RetailTable2 *RTShopList;

//指定门店的个数
@property (nonatomic, strong) IBOutlet UILabel *lblShopNum;

// 指定门店个数
@property (nonatomic) short shopNum;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil goodsList:(NSMutableArray*) goodsList styleList:(NSMutableArray*) styleList action:(int) action fromView:(int)viewTag shopId:(NSString*) shopId;

@end
