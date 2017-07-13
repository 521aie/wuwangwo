//
//  GoodsSalePackTopSelectView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IEditItemListEvent.h"
#import "OptionPickerClient.h"
#import "SymbolNumberInputBox.h"
#import "OptionPickerClient.h"
#import "NavigateTitle2.h"

@class EditItemList, NavigateTitle2;
@interface WechatSalePackStyleSelectView : BaseViewController<IEditItemListEvent,OptionPickerClient, SymbolNumberInputClient, OptionPickerClient, INavigateEvent>

@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;

@property (nonatomic, weak) IBOutlet EditItemList *lsCategory;
@property (nonatomic, weak) IBOutlet EditItemList *lsSex;
@property (nonatomic, weak) IBOutlet EditItemList *lsMainModel;
@property (nonatomic, weak) IBOutlet EditItemList *lsAuxiliaryModel;
@property (nonatomic, weak) IBOutlet EditItemList *lsYear;
@property (nonatomic, weak) IBOutlet EditItemList *lsSeason;
@property (nonatomic, weak) IBOutlet EditItemList *lsMaxHangTagPrice;

@property (nonatomic, weak) IBOutlet UITextField *txtMinHangTagPrice;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil salePackId:(NSString*) salePackId;

@end
