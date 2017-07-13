//
//  MonthReportView.h
//  retailapp
//
//  Created by Jianyong Duan on 15/11/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCommentReportVo.h"

@interface MonthReportView : UIView

@property (nonatomic) NSInteger type;

@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@property (weak, nonatomic) IBOutlet UIImageView *imgGood;
@property (weak, nonatomic) IBOutlet UILabel *lblGood;

@property (weak, nonatomic) IBOutlet UIImageView *imgMedium;
@property (weak, nonatomic) IBOutlet UILabel *lblMedium;

@property (weak, nonatomic) IBOutlet UIImageView *imgBad;
@property (weak, nonatomic) IBOutlet UILabel *lblBad;

@property (weak, nonatomic) IBOutlet UIImageView *imgWeixin;
@property (weak, nonatomic) IBOutlet UILabel *lblWeixin;

@property (weak, nonatomic) IBOutlet UIImageView *imgDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;

@property (weak, nonatomic) IBOutlet UIImageView *imgFlow;
@property (weak, nonatomic) IBOutlet UILabel *lblFlow;

@property (weak, nonatomic) IBOutlet UILabel *lblDescTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSkipTitle;
@property (weak, nonatomic) IBOutlet UIView *leftLine;
@property (weak, nonatomic) IBOutlet UIView *rightLine;


- (id)initWithFrame:(CGRect)frame type:(NSInteger)type;
- (void)showCommentReport:(ShopCommentReportVo *)report viewTypeId:(NSInteger) viewtype;

@end
