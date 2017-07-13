//
//  OrderDetailView.m
//  retailapp
//
//  Created by guozhi on 15/10/13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrderIntegralView.h"
#import "UIHelper.h"
#import "DateUtils.h"
#import "ColorHelper.h"
#import "Platform.h"
#import "UIView+Sizes.h"
#import "MemberIntegralDetailVo.h"
#import "MemberIntegralDetailCellVo.h"
@implementation OrderIntegralView
- (void)awakeFromNib {
    [super awakeFromNib];
   
    [[NSBundle mainBundle] loadNibNamed:@"OrderIntegralView" owner:self options:nil];
    [self addSubview:self.view];
    
    self.container.layer.borderWidth = 0.5;
    self.container.layer.borderColor = [ColorHelper getTipColor6].CGColor;
}

+ (instancetype)orderIntegralView {
    OrderIntegralView *view = [[OrderIntegralView alloc] initWithFrame:CGRectMake(0, 0, 300, 190)];
    [view awakeFromNib];
    view.ls_width = SCREEN_W - 20;
    return view;
}


- (void)initDataWithMemberIntegralDetailVo:(MemberIntegralDetailVo *)memberIntegralDetailVo {

    self.lblTime.text = [DateUtils getTimeStringFromCreaateTime:memberIntegralDetailVo.createtime.stringValue format:@"yyyy-MM-dd HH:mm:ss"];
    self.lblCount.text = [NSString stringWithFormat:@"%@",memberIntegralDetailVo.totalGiftNumber];
    self.lblCode.text = memberIntegralDetailVo.exchangeType;
    self.lblCode.textColor = [ColorHelper getBlueColor];
    self.lblTime.textColor = [ColorHelper getBlueColor];

    if (memberIntegralDetailVo.type.integerValue == 1) {
        
        // 兑换商品
        self.goodName.text = memberIntegralDetailVo.name ? : @"";
        if ([NSString isNotBlank:memberIntegralDetailVo.color] || [NSString isNotBlank:memberIntegralDetailVo.size]) {
            self.goodAttribute.text = [NSString stringWithFormat:@"%@%@" ,memberIntegralDetailVo.color?:@"" ,memberIntegralDetailVo.size?:@""];
        }
        self.goodId.text = memberIntegralDetailVo.barCode ? : @"";
        self.goodNum.text = memberIntegralDetailVo.totalGiftNumber.stringValue ? : @"";
        self.exchangePoint.text = memberIntegralDetailVo.totalPoint.stringValue ? : @"";
    }
    else if (memberIntegralDetailVo.type.integerValue == 2) {
        // 兑换卡余额
        self.goodId.text = memberIntegralDetailVo.name ? : @""; // 这里为了居中显示
        self.goodNum.text = memberIntegralDetailVo.totalGiftNumber.stringValue ? : @"";
        self.exchangePoint.text = memberIntegralDetailVo.totalPoint.stringValue ? : @"";
    }
    
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    self.outFee.text = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber: memberIntegralDetailVo.totalPoint]];
    self.outFee.textColor = [ColorHelper getRedColor];
    [self.outFee sizeToFit];
    [self.labIntegral sizeToFit];
     self.outFee.ls_right = self.labIntegral.ls_left - 2;
}


@end
