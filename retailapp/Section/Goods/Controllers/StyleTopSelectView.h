//
//  StyleTopSelectView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/10/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IEditItemListEvent.h"
#import "OptionPickerClient.h"
#import "DatePickerBox.h"
#import "SymbolNumberInputBox.h"

@protocol StyleTopSelectViewDelegate <NSObject>

@optional
-(void) showStyleListView:(NSMutableDictionary*) condition;

@end

@interface StyleTopSelectView : UIViewController<IEditItemListEvent,OptionPickerClient, SymbolNumberInputClient>

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

@property (nonatomic, retain) NSString *shopId;

@property (nonatomic, retain) NSString *shopName;

@property (nonatomic) int fromViewTag;

@property (nonatomic, retain) NSMutableDictionary* conditionOfInit;

@property (nonatomic, strong) id<StyleTopSelectViewDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (void)oper;
- (void)resetLblVal;

-(void) loaddatas;

@end
