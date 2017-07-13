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
#import "DatePickerBox.h"
@protocol SelectViewDelegeate <NSObject>
- (void)selectViewWithResetButtonClick;
- (void)selectViewWithCompleteButtonClick;
@end
@class EditItemList;
@interface CashRecordSelectView : UIView<IEditItemListEvent,OptionPickerClient,DatePickerClient>
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet EditItemList *lstState;
@property (weak, nonatomic) IBOutlet EditItemList *lstDate;
@property (nonatomic, assign) id<SelectViewDelegeate> delegate;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
- (void)initData;
- (void)initView;
- (BOOL)isValid;
@end
