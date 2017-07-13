//
//  SytleChoiceTopView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/10/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IEditItemListEvent.h"
#import "OptionPickerClient.h"
#import "SymbolNumberInputBox.h"

@protocol StyleChoiceTopViewDelegate <NSObject>

@optional
- (void)showStyleListView:(NSMutableDictionary *)condition;

@end

@class StyleChoiceView;
@interface StyleChoiceTopView : UIViewController<IEditItemListEvent,OptionPickerClient, SymbolNumberInputClient>

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

@property (nonatomic, retain) NSMutableDictionary* conditionOfInit;

@property (nonatomic, retain) NSString *shopId;

@property (nonatomic) int fromViewTag;

@property (nonatomic, strong) id<StyleChoiceTopViewDelegate> delegate;

/**
 第一次进来为0，页面初始化，第二次进来页面不做操作
 */
@property (nonatomic, assign) short count;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

-(void) loaddatas;

- (void)oper;
- (void)resetLblVal;

@end
