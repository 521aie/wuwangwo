//
//  AcountInformationList.h
//  retailapp
//
//  Created by guozhi on 15/11/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"

@class NavigateTitle2,EditItemView,OtherService;
@class WithdrawCheckVo;
@interface CashRecordDetail : BaseViewController <INavigateEvent> {
    OtherService *service;
}
@property (weak, nonatomic) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *container;
/**门店提现审核Id*/
@property (nonatomic, strong) NSNumber *shopWithdrawCheckId;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) NSMutableDictionary *param1;
@property (weak, nonatomic) IBOutlet EditItemView *vewName;
@property (weak, nonatomic) IBOutlet EditItemView *vewAcount;
@property (weak, nonatomic) IBOutlet EditItemView *vewCash;
@property (weak, nonatomic) IBOutlet EditItemView *vewTime;
@property (weak, nonatomic) IBOutlet EditItemView *vewState;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labDetail;
@property (weak, nonatomic) IBOutlet UIView *btnBgView;
@property (nonatomic, strong) WithdrawCheckVo *withdrawCheckVo;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withdrawCheckVo:(WithdrawCheckVo *)withdrawCheckVo;
@end
