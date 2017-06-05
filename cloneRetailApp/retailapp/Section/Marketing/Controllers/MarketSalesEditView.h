//
//  MarketSalesEditView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/2.
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
#import "DatePickerBox.h"

@class EditItemText, EditItemRadio2, EditItemRadio, EditItemList, ItemTitle, EditItemMemo, RetailTable2, SaleActVo;
@class MarketModule, FooterListView;
@interface MarketSalesEditView : BaseViewController<INavigateEvent, OptionPickerClient,IEditItemRadioEvent, FooterListEvent, IEditItemListEvent, ISampleListEvent, IEditItemMemoEvent, DatePickerClient, UIActionSheetDelegate>

@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;
//活动是否失效
@property (nonatomic, weak) IBOutlet EditItemRadio2 *rdoStatus;

//基本设置
@property (nonatomic, weak) IBOutlet ItemTitle *TitBase;

//活动编号
@property (nonatomic, weak) IBOutlet EditItemText *txtCode;

//活动名称
@property (nonatomic, weak) IBOutlet EditItemText *txtName;

//会员专享
@property (nonatomic, weak) IBOutlet EditItemRadio *rdoIsMember;

//适用实体门店
@property (nonatomic, weak) IBOutlet EditItemRadio *rdoIsShop;

//价格方案
@property (nonatomic, weak) IBOutlet EditItemList *lsShopPriceScheme;

//会员消费时享受折上折
@property (nonatomic, weak) IBOutlet EditItemRadio *rdoShopDoubleDiscount;

//是否适用微店
@property (nonatomic, weak) IBOutlet EditItemRadio *rdoIsWeixin;

//微店价格方案
@property (nonatomic, weak) IBOutlet EditItemList *lsWeixinPriceScheme;

//微店会员消费时享受折上折
@property (nonatomic, weak) IBOutlet EditItemRadio *rdoWeixinDoubleDiscount;

//有效期设置
@property (nonatomic, weak) IBOutlet ItemTitle *TitValidDate;

//开始时间
@property (nonatomic, weak) IBOutlet EditItemList *lsStartTime;

//结束时间
@property (nonatomic, weak) IBOutlet EditItemList *lsEndTime;

//促销门店设置
@property (nonatomic, weak) IBOutlet ItemTitle *TitShop;

//促销门店
@property (nonatomic, weak) IBOutlet UIView *shopView;

//指定门店范围
@property (nonatomic, weak) IBOutlet EditItemRadio *rdoIsShopArea;

//促销门店
@property (nonatomic, weak) IBOutlet RetailTable2 *RTShopList;

//指定门店的个数
@property (nonatomic, weak) IBOutlet UILabel *lblShopNum;

// 指定门店个数
@property (nonatomic, assign) short shopNum;

@property (nonatomic, weak) IBOutlet UIButton *btnAdd;

@property (nonatomic, strong) IBOutlet UIButton *btnDel;

@property (nonatomic, strong) NSString *isCanDeal;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil saleActId:(NSString*) saleActId action:(int) action  fromView:(int) viewTag;

@end
