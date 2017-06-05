//
//  BindingDiscountEditView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INameValueItem.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"
#import "OptionPickerClient.h"
#import "ISampleListEvent.h"
#import "SymbolNumberInputBox.h"
#import "NavigateTitle2.h"

@class NavigateTitle2, EditItemList, EditItemRadio, ItemTitle, DiscountGoodsVo;

@interface BindingDiscountEditView : BaseViewController<INavigateEvent, IEditItemListEvent, IEditItemRadioEvent, OptionPickerClient, ISampleListEvent, SymbolNumberInputClient, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic) NavigateTitle2 *titleBox;
@property (nonatomic, weak) IBOutlet UITableView *mainGrid;

//基本设置
@property (nonatomic, strong) IBOutlet ItemTitle *TitBase;

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

//促销规则设置
@property (nonatomic, strong) IBOutlet ItemTitle* TitSalesRegulation;

// 添加cell
@property (nonatomic, strong) IBOutlet UIView* addView;

@property (nonatomic, strong) IBOutlet UIView* headInfoView;

@property (nonatomic, strong) IBOutlet UIView* footInfoView;

@property (nonatomic, strong) IBOutlet UIButton *btnDel;

@property (nonatomic, strong) NSString* isCanDeal;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil bindDiscountId:(NSString*) bindDiscountId salesId:(NSString*) salesId action:(int) action shopId:(NSString*) shopId;

// 从打折规则页面返回
-(void) loaddatasFromSaleRegulationAddView:(DiscountGoodsVo*) discountGoodsVo;

// 从促销商品、款式范围返回
-(void) loaddatasFromGoodsOrStyleListView;

@end
