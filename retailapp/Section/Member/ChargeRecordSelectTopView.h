//
//  ChargeRecordSelectTopView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IEditItemListEvent.h"
#import "DatePickerBox.h"

@protocol ChargeRecordSelectTopViewDelegate <NSObject>

-(void) selectChangeRecord:(NSString*) startTime endTime:(NSString*) endtime lastDateTime:(NSString*) lastDateTime;

@end

@class MemberModule;
@interface ChargeRecordSelectTopView : BaseViewController<IEditItemListEvent,DatePickerClient>

@property (nonatomic, strong) IBOutlet UIView *mainContainer;

@property (nonatomic, weak) IBOutlet EditItemList *lsDate;

@property (nonatomic, weak) IBOutlet UIButton *btnReset;
@property (nonatomic, weak) IBOutlet UIButton *btnConfirm;

@property (nonatomic, strong) id<ChargeRecordSelectTopViewDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MemberModule *)parentTemp;

- (void)loadChargeRecordTopSelectView;

- (void)oper;
- (void)resetLblVal;

@property (nonatomic) short status;

@end
