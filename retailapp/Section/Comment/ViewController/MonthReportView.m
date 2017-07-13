//
//  MonthReportView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/11/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MonthReportView.h"
#import "ColorHelper.h"
#import "UIView+Sizes.h"

@implementation MonthReportView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame type:(NSInteger)type {
    if (self = [super initWithFrame:frame]) {
        self.type = type;
        
        self.lblTime.text = @"上月汇总";
        
        self.imgGood.image = nil;
        self.lblGood.text = @"";
        
        self.imgMedium.image = nil;
        self.lblMedium.text = @"";
        
        self.imgBad.image = nil;
        self.lblBad.text = @"";
        
        self.imgWeixin.image = nil;
        self.lblWeixin.text = @"";

        self.imgDesc.image = nil;
        self.lblDesc.text = @"";

        self.imgFlow.image = nil;
        self.lblFlow.text = @"";
        
        if (self.type==0) {
            self.lblDescTitle.text = @"购物环境";
            self.lblSkipTitle.text = @"售后服务";
        }
    }
    return self;
}

- (void)showCommentReport:(ShopCommentReportVo *)report viewTypeId:(NSInteger) viewType{
    if (report == nil) {
        return;
    }
    
    [self setTotalTitle:report.reportTime];
    if ([self.lblTime.text isEqualToString:@"半年内历史汇总"]) {
        self.leftLine.ls_width = 81;
        self.rightLine.ls_width = 81;
        self.rightLine.ls_right = 305;
    } else {
        self.leftLine.ls_width = 101;
        self.rightLine.ls_width = 101;
        self.rightLine.ls_right = 305;
    }
    if (viewType==0) {
        self.lblDescTitle.text = @"购物环境";
        self.lblSkipTitle.text = @"售后服务";
    }else{
        self.lblDescTitle.text=@"描述相符";
        self.lblSkipTitle.text=@"物流服务";
    }
    //好评
    self.lblGood.text = [NSString stringWithFormat:@"%ld", report.goodCount];
    if (report.goodCountCompare == 2) {
//        self.lblGood.textColor = [ColorHelper getTipColor3];
        self.imgGood.image = [UIImage imageNamed:@"ico_arrow_decreace.png"];
    } else if (report.goodCountCompare == 1) {
//        self.lblGood.textColor = [ColorHelper getRedColor];
        self.imgGood.image = [UIImage imageNamed:@"ico_arrow_increace.png"];
    } else {
//        self.lblGood.textColor = [ColorHelper getOrangeColor];
        self.imgGood.image = nil;
    }
    
    //中评
    self.lblMedium.text = [NSString stringWithFormat:@"%ld", report.mediumCount];
    if (report.mediumCountCompare == 2) {
//        self.lblMedium.textColor = [ColorHelper getTipColor3];
        self.imgMedium.image = [UIImage imageNamed:@"ico_arrow_decreace.png"];
    } else if (report.mediumCountCompare == 1) {
//        self.lblMedium.textColor = [ColorHelper getRedColor];
        self.imgMedium.image = [UIImage imageNamed:@"ico_arrow_increace.png"];
    } else {
//        self.lblMedium.textColor = [ColorHelper getOrangeColor];
        self.imgMedium.image = nil;
    }
    
    //差评
    self.lblBad.text = [NSString stringWithFormat:@"%ld", report.badCount];
    if (report.badCountCompare == 2) {
//        self.lblBad.textColor = [ColorHelper getTipColor3];
        self.imgBad.image = [UIImage imageNamed:@"ico_arrow_decreace.png"];
    } else if (report.badCountCompare == 1) {
//        self.lblBad.textColor = [ColorHelper getRedColor];
        self.imgBad.image = [UIImage imageNamed:@"ico_arrow_increace.png"];
    } else {
//        self.lblBad.textColor = [ColorHelper getOrangeColor];
        self.imgBad.image = nil;
    }
    
    //微店态度
    [self formatScore:[NSString stringWithFormat:@"%.1f分", report.attitudeScore] label:self.lblWeixin];
    if (report.attitudeCompare == 2) {
//        self.lblWeixin.textColor = [ColorHelper getTipColor3];
        self.imgWeixin.image = [UIImage imageNamed:@"ico_arrow_decreace.png"];
        
    } else if (report.attitudeCompare == 1) {
//        self.lblWeixin.textColor = [ColorHelper getRedColor];
        self.imgWeixin.image = [UIImage imageNamed:@"ico_arrow_increace.png"];
    } else {
//        self.lblWeixin.textColor = [ColorHelper getOrangeColor];
        self.imgWeixin.image = nil;
    }

    
    //描述相符
    [self formatScore:[NSString stringWithFormat:@"%.1f分", [report shoppingOrDescriptionScore:viewType]] label:self.lblDesc];
    if ([report shoppingOrDescriptionCompare:viewType] == 2) {
//        self.lblDesc.textColor = [ColorHelper getTipColor3];
        self.imgDesc.image = [UIImage imageNamed:@"ico_arrow_decreace.png"];
    } else if ([report shoppingOrDescriptionCompare:viewType] == 1) {
//        self.lblDesc.textColor = [ColorHelper getRedColor];
        self.imgDesc.image = [UIImage imageNamed:@"ico_arrow_increace.png"];
    } else {
//        self.lblDesc.textColor = [ColorHelper getOrangeColor];
        self.imgDesc.image = nil;
    }

    
    //物流服务
    [self formatScore:[NSString stringWithFormat:@"%.1f分", [report servicOrshippingScore:viewType]] label:self.lblFlow];
    if ([report servicOrshippingCompare:viewType] == 2) {
//        self.lblFlow.textColor = [ColorHelper getTipColor3];
        self.imgFlow.image = [UIImage imageNamed:@"ico_arrow_decreace.png"];
    } else if ([report servicOrshippingCompare:viewType] == 1) {
//        self.lblFlow.textColor = [ColorHelper getRedColor];
        self.imgFlow.image = [UIImage imageNamed:@"ico_arrow_increace.png"];
    } else {
//        self.lblFlow.textColor = [ColorHelper getOrangeColor];
        self.imgFlow.image = nil;
    }

}

- (void)formatScore:(NSString *)score label:(UILabel *)label {
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:score];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(score.length - 1, 1)];
    label.attributedText = attr;
}

- (void)setTotalTitle:(NSString *)reportTime {
    if (reportTime.length != 6) {
        return;
    }
    
    NSInteger currMonth = [self calcMonth:0];
//    NSInteger lastMonth = [self calcMonth:-1];
    if (currMonth == [reportTime integerValue]) {
        self.lblTime.text = @"本月汇总";
    } //else if (lastMonth == [reportTime integerValue]) {
        //self.lblTime.text = @"上月汇总";}
     else {
        NSString *month = [reportTime substringFromIndex:4];
        if ([month intValue] == 1) {
            self.lblTime.text = @"一月汇总";
        } else if ([month intValue] == 2) {
            self.lblTime.text = @"二月汇总";
        } else if ([month intValue] == 3) {
            self.lblTime.text = @"三月汇总";
        } else if ([month intValue] == 4) {
            self.lblTime.text = @"四月汇总";
        } else if ([month intValue] == 5) {
            self.lblTime.text = @"五月汇总";
        } else if ([month intValue] == 6) {
            self.lblTime.text = @"六月汇总";
        } else if ([month intValue] == 7) {
            self.lblTime.text = @"七月汇总";
        } else if ([month intValue] == 8) {
            self.lblTime.text = @"八月汇总";
        } else if ([month intValue] == 9) {
            self.lblTime.text = @"九月汇总";
        } else if ([month intValue] == 10) {
            self.lblTime.text = @"十月汇总";
        } else if ([month intValue] == 11) {
            self.lblTime.text = @"十一月汇总";
        } else if ([month intValue] == 12) {
            self.lblTime.text = @"十二月汇总";
        } else {
            self.lblTime.text = @"半年内历史汇总";
        }
    }
}

#pragma mark - private
- (NSInteger)calcMonth:(int)months {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSInteger year=[comps year];//获取年对应的长整形字符串
    NSInteger month=[comps month];//获取月对应的长整形字符串
    
    year = year + months / 12;
    month = month + months % 12;
    
    if (month < 1) {
        year--;
        month += 12;
    } else if (month > 12) {
        year++;
        month -= 12;
    }
    
    NSString *calcdate = [NSString stringWithFormat:@"%ld%02ld", year, month];
    return [calcdate integerValue];
}

@end
