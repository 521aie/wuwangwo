//
//  StyleChoiceTopView2.h
//  retailapp
//
//  Created by zhangzhiliang on 15/11/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IEditItemListEvent.h"
#import "OptionPickerClient.h"
#import "SymbolNumberInputBox.h"

@class StyleBatchChoiceView2;
@interface StyleChoiceTopView2 : BaseViewController<IEditItemListEvent,OptionPickerClient, SymbolNumberInputClient>

@property (nonatomic, strong) IBOutlet UIView *mainContainer;

@property (nonatomic, weak) IBOutlet EditItemList *lsCategory;
@property (nonatomic, weak) IBOutlet EditItemList *lsSex;
@property (nonatomic, weak) IBOutlet EditItemList *lsMainModel;
@property (nonatomic, weak) IBOutlet EditItemList *lsAuxiliaryModel;
@property (nonatomic, weak) IBOutlet EditItemList *lsYear;
@property (nonatomic, weak) IBOutlet EditItemList *lsSeason;
@property (nonatomic, weak) IBOutlet EditItemList *lsMaxHangTagPrice;

@property (nonatomic, weak) IBOutlet UITextField *txtMinHangTagPrice;

@property (nonatomic, weak) IBOutlet UIButton *btnReset;
@property (nonatomic, weak) IBOutlet UIButton *btnConfirm;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(StyleBatchChoiceView2 *)parentTemp;

-(void)loadDatas:(NSString*) shopId fromViewTag:(int) fromViewTag;

- (void)oper;
- (void)resetLblVal;


@end
