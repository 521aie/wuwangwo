//
//  BirthdaySalesView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/6.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionPickerClient.h"
#import "NavigateTitle2.h"
//#import "MemberTypeVo.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"
#import "SymbolNumberInputBox.h"

@class EditItemRadio, EditItemList, ItemTitle, EditItemRadio2;
@class MarketModule, MemberBirSaleVo;
@interface BirthdaySalesView : BaseViewController<INavigateEvent, OptionPickerClient, IEditItemListEvent, SymbolNumberInputClient, IEditItemRadioEvent>

@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;

//是否开启会员生日打折促销
@property (nonatomic, strong) IBOutlet EditItemRadio2* rdoIsUsed;

//促销规则设置
@property (nonatomic, strong) IBOutlet ItemTitle* TitSalesRegulation;

//价格方案
@property (nonatomic, strong) IBOutlet EditItemList *lsShopPriceScheme;

//折扣率
@property (nonatomic, strong) IBOutlet EditItemList *lsDiscountRate;

//限购数量
@property (nonatomic, strong) IBOutlet EditItemList *lsGoodsCount;

//限购次数
@property (nonatomic, strong) IBOutlet EditItemList *lsPurchaseNumber;

//有效期设置
@property (nonatomic, strong) IBOutlet ItemTitle* TitValidDate;

//在会员生日月有效
@property (nonatomic, strong) IBOutlet EditItemRadio* rdoIsMemberMonth;

//在指定时间有效
@property (nonatomic, strong) IBOutlet EditItemRadio* rdoIsAppointDate;

//会员生日前
@property (nonatomic, strong) IBOutlet EditItemList *lsBeforeBir;

//会员生日后
@property (nonatomic, strong) IBOutlet EditItemList *lsAfterBir;

@property (nonatomic) int action;

@property (nonatomic, strong) MemberBirSaleVo* memberBirSaleVo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
