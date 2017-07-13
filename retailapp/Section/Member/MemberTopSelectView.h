//
//  MemberTopSelectView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IEditItemListEvent.h"
#import "OptionPickerClient.h"
#import "DatePickerBox.h"

@protocol MemberTopSelectViewDelegate <NSObject>

@optional
-(void) memberSelectToSelectView:(MemberSearchCondition*) memberSearchCondition action:(int) action;

-(void) memberSelectToListView:(MemberSearchCondition*) memberSearchCondition action:(int) action;

@end

@class MemberModule, MemberSearchCondition;
@interface MemberTopSelectView : BaseViewController<IEditItemListEvent,OptionPickerClient,DatePickerClient>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *mainContainer;

@property (nonatomic, weak) IBOutlet EditItemList *lsKindCardName;
@property (nonatomic, weak) IBOutlet EditItemList *lsStatus;
@property (nonatomic, weak) IBOutlet EditItemList *lsActiveTime;
@property (nonatomic, weak) IBOutlet EditItemList *lsStartTime;
@property (nonatomic, weak) IBOutlet EditItemList *lsEndTime;

@property (nonatomic, weak) IBOutlet UIButton *btnReset;
@property (nonatomic, weak) IBOutlet UIButton *btnConfirm;

@property (nonatomic, strong) NSDictionary* dispose;

@property (nonatomic, retain) MemberSearchCondition* conditionOfInit;

@property (nonatomic, strong) id<MemberTopSelectViewDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil fromViewTag:(int) fromViewTag;

- (void)loadMemberTopSelectView;

- (void)oper;
- (void)resetLblVal;

@end
