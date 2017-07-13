//
//  SaleMinusEditView.h
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

@class EditItemText, EditItemRadio, EditItemList, ItemTitle;
@class MarketModule;
@interface SaleMinusEditView : BaseViewController<INavigateEvent, OptionPickerClient,IEditItemRadioEvent, FooterListEvent, IEditItemListEvent, ISampleListEvent, IEditItemMemoEvent, SymbolNumberInputClient>

@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;

//促销规则设置
@property (nonatomic, strong) IBOutlet ItemTitle* TitSalesRegulation;

//购买数量
@property (nonatomic, strong) IBOutlet EditItemList *lsGoodsCount;

//购买金额
@property (nonatomic, strong) IBOutlet EditItemList *lsMoney;

//购买组合方式
@property (nonatomic, strong) IBOutlet EditItemList *lsGroupType;

//购买款数
@property (nonatomic, strong) IBOutlet EditItemList *lsBuyStyleCount;

//指定商品范围
@property (nonatomic, strong) IBOutlet EditItemRadio *rdoIsGoodsArea;

//款式范围
@property (nonatomic, strong) IBOutlet EditItemList *lsStyleArea;

//商品范围
@property (nonatomic, strong) IBOutlet EditItemList *lsGoodsArea;

//扣减额度设置
@property (nonatomic, strong) IBOutlet ItemTitle* TitMinusMoney;

//扣减金额（元）
@property (nonatomic, strong) IBOutlet EditItemList *lsMinusMoney;

//最多扣减金额（元）
@property (nonatomic, strong) IBOutlet EditItemList *lsMaxMinusMoney;

@property (nonatomic, strong) IBOutlet UIButton *btnDel;

@property (nonatomic, strong) NSString* isCanDeal;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil minusRuleId:(NSString*) minusRuleId salesId:(NSString*) salesId action:(int) action shopId:(NSString*) shopId;

//从促销款式or商品一览返回
-(void) loaddatasFromGoodsOrStyleListView;

@end
