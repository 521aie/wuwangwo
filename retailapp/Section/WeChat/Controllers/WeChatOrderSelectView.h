//
//  WeChatOrderSelectView.h
//  retailapp
//
//  Created by guozhi on 16/3/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IEditItemListEvent.h"
#import "OptionPickerClient.h"
#import "DatePickerBox.h"
@class EditItemList;
@protocol WeChatOrderSelectDelegate <NSObject>
- (void)showFinishEvent;
- (void)showClearEvent;
- (void)showResetEvent;
@end

@interface WeChatOrderSelectView : UIControl <IEditItemListEvent,OptionPickerClient,DatePickerClient>
@property (strong, nonatomic) IBOutlet UIControl *control;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet EditItemList *lstOrderStatus;
@property (weak, nonatomic) IBOutlet EditItemList *lstOrderDate;
@property (nonatomic, assign) id<WeChatOrderSelectDelegate> delegate;

@end
