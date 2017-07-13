//
//  SelectView.h
//  retailapp
//
//  Created by guozhi on 15/10/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//
//虚拟库存的筛选页面
#import <UIKit/UIKit.h>
#import "IEditItemListEvent.h"
#import "OptionPickerClient.h"
#import "INameItem.h"
#import "SymbolNumberInputBox.h"
@protocol SelectViewDelegeate <NSObject>
- (void)showFinishEventWithParam:(NSMutableDictionary *)param;
@end
@class EditItemList,GoodsService;
@interface SelectView : UIView<IEditItemListEvent,OptionPickerClient,SymbolNumberInputClient,UITextFieldDelegate> {
    GoodsService *service;
}
@property (weak, nonatomic) IBOutlet EditItemList *lstClass;
@property (weak, nonatomic) IBOutlet EditItemList *lstState;
@property (weak, nonatomic) IBOutlet UIView *container;

@property (nonatomic, assign) id<SelectViewDelegeate> delegate;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UITextField *txtStart;
@property (weak, nonatomic) IBOutlet EditItemList *lstSex;
@property (weak, nonatomic) IBOutlet UITextField *txtEnd;
@property (weak, nonatomic) IBOutlet EditItemList *lstYear;
@property (weak, nonatomic) IBOutlet EditItemList *lstSeason;
@property (weak, nonatomic) IBOutlet UILabel *virtualStock;
- (void)initView;
- (void)initData;
@end
