//
//  MemberTypeEditView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionPickerClient.h"
#import "NavigateTitle2.h"
#import "FooterListEvent.h"
#import "IEditItemListEvent.h"
#import "IEditItemRadioEvent.h"
#import "SymbolNumberInputBox.h"

@class EditItemText, EditItemRadio, EditItemList;
@class KindCardVo;
@interface MemberTypeEditView : BaseViewController<INavigateEvent, OptionPickerClient,IEditItemRadioEvent, FooterListEvent, IEditItemListEvent, SymbolNumberInputClient>

@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;

//会员类型名称
@property (nonatomic, strong) IBOutlet EditItemText *txtMemberTypeName;
//可否升级
@property (nonatomic, strong) IBOutlet EditItemRadio *rdoIsUpgrade;
//下一级卡类型
@property (nonatomic, strong) IBOutlet EditItemList *lsNextCardType;
//升级所需积分
@property (nonatomic, strong) IBOutlet EditItemList *lsNeedIntegral;
//消费积分比例
@property (nonatomic, strong) IBOutlet EditItemList *lsIntegralRatio;
//价格方案
@property (nonatomic, strong) IBOutlet EditItemList *lsPriceScheme;
//折扣率
@property (nonatomic, strong) IBOutlet EditItemList *lsDiscountRatio;
//备注
@property (nonatomic, strong) IBOutlet EditItemText *txtMemo;

@property (nonatomic, strong) IBOutlet UIButton *btnDel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil kindCardId:(NSString*) kindCardId action:(int) action;

@end
