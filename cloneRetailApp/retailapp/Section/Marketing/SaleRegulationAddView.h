//
//  SaleRegulationAddView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/8.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IEditItemListEvent.h"
#import "SymbolNumberInputBox.h"
#import "NavigateTitle2.h"

@class NavigateTitle2, EditItemList, EditItemText;
@interface SaleRegulationAddView : BaseViewController<INavigateEvent, IEditItemListEvent, SymbolNumberInputClient>

@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;

//购买数量
@property (nonatomic, strong) IBOutlet EditItemText *txtGoodsCount;

//购买数量
@property (nonatomic, strong) IBOutlet EditItemList *lsGoodsCount;

//折扣率
@property (nonatomic, strong) IBOutlet EditItemList *lsDiscountRate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil goodsCount:(int) goodsCount fromViewTag:(int) viewTag discountId:(NSString*) discountId countList:(NSMutableArray*) countList;

@end
