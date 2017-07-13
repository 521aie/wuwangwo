//
//  WechatGoodsTopSelectView.h
//  retailapp
//
//  Created by zhangzt on 15/10/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IEditItemListEvent.h"
#import "OptionPickerClient.h"
#import "DatePickerBox.h"
#import "SymbolNumberInputBox.h"
#import "DatePickerBox2.h"
#import "EditItemText.h"
@class WechatModule;
@interface WechatGoodsTopSelectView : BaseViewController<IEditItemListEvent,OptionPickerClient,DatePickerClient, SymbolNumberInputClient, DatePickerClient2>
{
    WechatModule *parent;
    BOOL isExpanded;
}

@property (nonatomic, strong) IBOutlet UIView *mainContainer;

@property (nonatomic, weak) IBOutlet EditItemList *lsCategory;
@property (nonatomic, weak) IBOutlet EditItemList *lsSex;
@property (nonatomic, weak) IBOutlet EditItemList *lsYear;
@property (nonatomic, weak) IBOutlet EditItemList *lsSeason;
@property (nonatomic, weak) IBOutlet EditItemList *lsMaxHangTagPrice;

@property (nonatomic, weak) IBOutlet UITextField *txtMinHangTagPrice;

@property (nonatomic, weak) IBOutlet UIButton *btnReset;
@property (nonatomic, weak) IBOutlet UIButton *btnConfirm;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(WechatModule *)parentTemp;

-(void)loadDatas:(NSString*) shopId shopName:(NSString*) shopName fromViewTag:(int) fromViewTag;

- (void)oper;
- (void)resetLblVal;

@end
