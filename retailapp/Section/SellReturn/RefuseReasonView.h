//
//  RefuseReasonView.h
//  retailapp
//
//  Created by Jianyong Duan on 15/11/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"

typedef void(^RefuseReasonBack)(NSString *refuseReason);

@interface RefuseReasonView : BaseViewController

// input

//1拒绝退货 3拒绝退款 4审核不通过
@property (nonatomic) int status;
@property (nonatomic, strong) RefuseReasonBack refuseReasonBack;

// outlet
@property (nonatomic,weak) IBOutlet UIView* titleDiv;
@property (nonatomic, strong) NavigateTitle2* titleBox;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceHolder;

@end
