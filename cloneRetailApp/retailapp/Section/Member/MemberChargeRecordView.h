//
//  MemberChargeRecordView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/9/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChargeRecordSelectTopView.h"
#import "NavigateTitle2.h"

@class NavigateTitle2, MemberModule, MemberSearchCondition, ChargeRecordSelectTopView;
@interface MemberChargeRecordView : BaseViewController<INavigateEvent, ChargeRecordSelectTopViewDelegate, UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic) NavigateTitle2 *titleBox;
@property (nonatomic, weak) IBOutlet UITableView *mainGrid;

@property (nonatomic, strong) ChargeRecordSelectTopView *chargeRecordSelectTopView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil customerId:(NSString *) customerId;

-(void) selectChargeRecordList:(NSString*) startTime endTime:(NSString*) endtime lastDateTime:(NSString*) lastDateTime;

-(void) loaddatasFromEdit;

@end
