//
//  SaleCouponEditView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/9.
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
#import "IEditItemMemoEvent.h"
#import "MemoInputView.h"

@class EditItemText, EditItemRadio, EditItemList, ItemTitle, EditItemMemo;
@class MarketModule;
@interface SaleCouponEditView : BaseViewController<INavigateEvent, OptionPickerClient,IEditItemRadioEvent, FooterListEvent, IEditItemListEvent, ISampleListEvent, IEditItemMemoEvent, SymbolNumberInputClient, DatePickerClient, IEditItemMemoEvent, MemoInputClient>
{
    MarketModule *parent;
    
}

@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;


//基本设置
@property (nonatomic, strong) IBOutlet ItemTitle *TitBase;

//优惠券面额
@property (nonatomic, strong) IBOutlet EditItemList *lsCouponWorth;

//数量
@property (nonatomic, strong) IBOutlet EditItemList *lsCount;

//优惠券说明
@property (nonatomic, strong) IBOutlet EditItemMemo *txtremark;

//出券规则设置
@property (nonatomic, strong) IBOutlet ItemTitle* TitCreateCoupon;

//出券条件(购买数量)
@property (nonatomic, strong) IBOutlet EditItemList *lsCouponCreateNum;

//出券条件(购买金额)
@property (nonatomic, strong) IBOutlet EditItemList *lsCouponCreateFee;

//购买组合方式
@property (nonatomic, strong) IBOutlet EditItemList *lsGroupType;

//购买款数
@property (nonatomic, strong) IBOutlet EditItemList *lsBuyStyleCount;

//出券指定商品范围
@property (nonatomic, strong) IBOutlet EditItemRadio *rdoIsCreateGoodsArea;

//出券款式范围
@property (nonatomic, strong) IBOutlet EditItemList *lsCreateStyleArea;

//出券商品范围
@property (nonatomic, strong) IBOutlet EditItemList *lsCreateGoodsArea;

//使用条件设置
@property (nonatomic, strong) IBOutlet ItemTitle* TitUseCoupon;

//使用条件(购买数量)
@property (nonatomic, strong) IBOutlet EditItemList *lsCouponUseNum;

//使用条件(购买金额)
@property (nonatomic, strong) IBOutlet EditItemList *lsCouponUseFee;

//使用开始时间
@property (nonatomic, strong) IBOutlet EditItemList *lsUseStartTime;

//使用结束时间
@property (nonatomic, strong) IBOutlet EditItemList *lsUseEndTime;

//使用指定商品范围
@property (nonatomic, strong) IBOutlet EditItemRadio *rdoIsUseGoodsArea;

//使用款式范围
@property (nonatomic, strong) IBOutlet EditItemList *lsUseStyleArea;

//使用商品范围
@property (nonatomic, strong) IBOutlet EditItemList *lsUseGoodsArea;

@property (nonatomic, strong) IBOutlet UIButton *btnDel;

@property (nonatomic, strong) NSString* isCanDeal;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil salesCouponId:(NSString*) salesCouponId salesId:(NSString*) salesId action:(int) action shopId:(NSString*) shopId;

//从促销款式or商品一览返回
-(void) loaddatasFromGoodsOrStyleListView;

@end
