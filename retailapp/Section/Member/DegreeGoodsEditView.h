//
//  DegreeGoodsEditView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"
#import "GoodsGiftVo.h"
#import "FooterListEvent.h"
#import "IEditItemListEvent.h"
#import "SymbolNumberInputBox.h"

@class EditItemText, EditItemList;
@interface DegreeGoodsEditView : BaseViewController<INavigateEvent, IEditItemListEvent, SymbolNumberInputClient, FooterListEvent>

@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;

//商品名称
@property (nonatomic, strong) IBOutlet EditItemText *txtName;
//条码
@property (nonatomic, strong) IBOutlet EditItemText *txtBarcode;
//颜色
@property (nonatomic, strong) IBOutlet EditItemText *txtColour;
//尺码
@property (nonatomic, strong) IBOutlet EditItemText *txtSize;
//商品价格
@property (nonatomic, strong) IBOutlet EditItemText *txtPrice;
//兑换所需积分
@property (nonatomic, strong) IBOutlet EditItemList *lsNeedPoint;

@property (nonatomic, strong) IBOutlet UIButton *btnDel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil goodsGiftVo:(GoodsGiftVo *) goodsGiftVo action:(int) action;

@end
