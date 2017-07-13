//
//  MemberDegreeExchangeEditView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"
#import "TextStepperField.h"
#import "DegreeExchangeCell.h"
#import "DegreeExchangeFootView.h"

@class EditItemText;
@class MemberModule, DegreeExchangeFootView, GoodsGiftVo, CustomerVo;
@interface MemberDegreeChangeEditView : BaseViewController<INavigateEvent, UITableViewDelegate,UITableViewDataSource,TextStepperFieldDelegate, DegreeExchangeCellDelegate, DegreeExchangeFootViewDelegate>

@property (nonatomic, retain) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2 *titleBox;
@property (nonatomic, weak) IBOutlet UITableView *mainGrid;

@property (nonatomic, weak) IBOutlet UIView *backView;

@property (nonatomic, weak) DegreeExchangeFootView *degreeExchangeFootView;

// 手机号码
@property (nonatomic, strong) IBOutlet UILabel *lblMobile;

// 卡内积分
@property (nonatomic, strong) IBOutlet UILabel *lblPoint;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil customerId:(NSString *) customerId;

@end
