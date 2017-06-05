//
//  SelectView.h
//  retailapp
//
//  Created by guozhi on 15/10/17.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//
//退货指导的筛选页面
#import <UIKit/UIKit.h>
#import "IEditItemListEvent.h"
#import "OptionPickerClient.h"
#import "INameItem.h"
#import "DatePickerBox2.h"
@protocol SelectViewDelegeate <NSObject>
- (void)selectViewWithResetButtonClickParam:(NSMutableDictionary *)param;
- (void)selectViewWithCompleteButtonClickParam:(NSMutableDictionary *)param;
@end
@class EditItemList;
@interface ReturnGuideSelectView : UIView<IEditItemListEvent,UITextFieldDelegate,DatePickerClient2> {
}

@property (weak, nonatomic) IBOutlet UIView *container;
@property (nonatomic, assign) id<SelectViewDelegeate> delegate;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet EditItemList *lstStart;
@property (weak, nonatomic) IBOutlet EditItemList *lstEnd;
- (void)initView;
- (BOOL)isValid;
@end
