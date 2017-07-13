//
//  BusinessSummaryBox.m
//  retailapp
//
//  Created by hm on 15/8/5.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "BusinessSummaryBox.h"
#import "NumberUtil.h"
#import "FormatUtil.h"
#import "DateUtils.h"
#import "BusinessDayVO.h"
#import "BusinessDetailLable.h"
#import "UIView+Sizes.h"
#import "RegexKitLite.h"


@implementation BusinessSummaryBox


- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"BusinessSummaryBox" owner:self options:nil];
    [self addSubview:self.view];
    _backGround.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}


-(void) clearData:(NSString*)dayName
{
    self.lblName.text=dayName;
    self.lblTotalAmount.text=@" -";
    
}

//按日查询
- (void)initDataWithList1:(NSMutableArray *)list1 title:(NSString *)title list2:(NSMutableArray *)list2 date:(NSString *)dateStr shopFlag:(int)shopFlag{/**shopFlag 1：按门店，2：按个人*/
    //1：有权限，0：没有权限 isHasAction
    BOOL isHasAction = shopFlag == 1 ? ![[Platform Instance] lockAct:ACTION_INCOME_SEARCH] : ![[Platform Instance] lockAct:ACTION_USER_INCOME_SEARCH];
    for (UIView *view in self.container.subviews) {
        [view removeFromSuperview];
    }
   
    NSString *str =[NSString stringWithFormat:@"%@日",dateStr];
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:str];
    [aAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, str.length-1)];
    self.lblDate.attributedText =aAttributedString;
    aAttributedString = nil;
    NSString* path=@"icon_day.png";
    [self.imgType setImage:[UIImage imageNamed:path]];
    if (list2.count ==1) {
        BusinessDayVO *vo1 = list1[0];
        BusinessDayVO *vo2 = list2[0];
        self.lblName.text = [NSString stringWithFormat:@"%@%@",title,vo2.showName];
        if (isHasAction == 0) {
            self.lblTotalAmount.text = @"-";
        } else {
            if ([vo2.showName isEqualToString:@"客单数(单)"]) {
                NSString* oldValue=[NSString stringWithFormat:@"%d",[vo1.showValue intValue]];
                NSString *regex = @"([0-9])(?=([0-9]{3})+\\.)";
                self.lblTotalAmount.text = [oldValue stringByReplacingOccurrencesOfRegex:regex withString:@"$1,"];
            } else {
                self.lblTotalAmount.text = [self formatNumber:[vo1.showValue doubleValue]];
            }
        }
        self.container.ls_height = 0;
        self.view.ls_height = self.container.ls_bottom;
        self.backGround.ls_height = self.view.ls_height;
        self.ls_height = self.view.ls_height;
        return;
        
    }
    for (int i = 0; i < list2.count; i ++) {
        BusinessDayVO *vo1 = list1[i];
        BusinessDayVO *vo2 = list2[i];
        if (i == 0) {
            self.lblName.text = [NSString stringWithFormat:@"%@%@",title,vo2.showName];
            if (isHasAction == 0) {
                self.lblTotalAmount.text = @"-";
            } else {
                if ([vo2.showName isEqualToString:@"客单数(单)"]) {
                    NSString* oldValue=[NSString stringWithFormat:@"%d",[vo1.showValue intValue]];
                    NSString *regex = @"([0-9])(?=([0-9]{3})+\\.)";
                    self.lblTotalAmount.text = [oldValue stringByReplacingOccurrencesOfRegex:regex withString:@"$1,"];
                } else {
                    self.lblTotalAmount.text = [self formatNumber:[vo1.showValue doubleValue]];
                }
            }
            continue;
        }
        BusinessDetailLable *businessDetailLable = [[NSBundle mainBundle] loadNibNamed:@"BusinessDetailLable" owner:self options:nil].lastObject;
        businessDetailLable.ls_origin = CGPointMake(businessDetailLable.frame.size.width *((i-1) %3), businessDetailLable.frame.size.height * ((i-1) /3));
        [self.container addSubview:businessDetailLable];
        if ((i-1) % 3 == 2) {
            businessDetailLable.view.hidden = YES;
        }
        businessDetailLable.labName.text = [NSString stringWithFormat:@"%@",vo2.showName];
        if (isHasAction == 0) {
            businessDetailLable.labCount.text = @"-";
        } else {
            if ([vo2.showName isEqualToString:@"客单数(单)"]) {
                NSString* oldValue=[NSString stringWithFormat:@"%d",[vo1.showValue intValue]];
                NSString *regex = @"([0-9])(?=([0-9]{3})+\\.)";
                businessDetailLable.labCount.text = [oldValue stringByReplacingOccurrencesOfRegex:regex withString:@"$1,"];
            } else {
                businessDetailLable.labCount.text = [self formatNumber:[vo1.showValue doubleValue]];
            }
        }
        self.container.ls_height = businessDetailLable.ls_bottom;
    }
    self.view.ls_height = self.container.ls_bottom;
    self.backGround.ls_height = self.view.ls_height;
    self.ls_height = self.view.ls_height;
    
    
}

//按月查询
- (void)initDataWithList:(NSMutableArray *)list title:(NSString *)title shopFlag:(int)shopFlag {
    /**shopFlag 1：按门店，2：按个人*/
    //1：有权限，0：没有权限 isHasAction
    for (UIView *view in self.container.subviews) {
        [view removeFromSuperview];
    }
     BOOL isHasAction = shopFlag == 1 ? ![[Platform Instance] lockAct:ACTION_INCOME_SEARCH] : ![[Platform Instance] lockAct:ACTION_USER_INCOME_SEARCH];
    self.lblDate.ls_width = 25;
    self.lblDate.ls_height = 19;
    self.lblDate.ls_left = self.imgType.ls_left+ 7;
    self.lblDate.backgroundColor = [UIColor whiteColor];
    NSRange range =[title rangeOfString:@"月"];
    self.lblDate.text =[title substringToIndex:range.location+range.length];
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:self.lblDate.text];
    [aAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0,self.lblDate.text.length-range.length)];
    self.lblDate.attributedText =aAttributedString;
    NSString* path =@"icon_month.png";
    [self.imgType setImage:[UIImage imageNamed:path]];
    if (list.count == 1) {
        BusinessDayVO *vo = list[0];
        self.lblName.text = [NSString stringWithFormat:@"%@%@",title,vo.showName];
        if (isHasAction == 0) {
            self.lblTotalAmount.text = @"-";
        } else {
            if ([vo.showName isEqualToString:@"客单数(单)"]) {
                NSString* oldValue=[NSString stringWithFormat:@"%d",[vo.showValue intValue]];
                NSString *regex = @"([0-9])(?=([0-9]{3})+\\.)";
                self.lblTotalAmount.text = [oldValue stringByReplacingOccurrencesOfRegex:regex withString:@"$1,"];
            } else {
                self.lblTotalAmount.text = [self formatNumber:[vo.showValue doubleValue]];
            }
        }
        self.container.ls_height = 0;
        self.view.ls_height = self.container.ls_bottom;
        self.backGround.ls_height = self.view.ls_height;
        self.ls_height = self.view.ls_height;
        return;
        
    }
    for (int i = 0; i < list.count; i ++) {
        BusinessDayVO *vo = list[i];
        if (i == 0) {
            self.lblName.text = [NSString stringWithFormat:@"%@%@",title,vo.showName];
            if (isHasAction == 0) {
                self.lblTotalAmount.text = @"-";
            } else {
                if ([vo.showName isEqualToString:@"客单数(单)"]) {
                    NSString* oldValue=[NSString stringWithFormat:@"%d",[vo.showValue intValue]];
                    NSString *regex = @"([0-9])(?=([0-9]{3})+\\.)";
                    self.lblTotalAmount.text = [oldValue stringByReplacingOccurrencesOfRegex:regex withString:@"$1,"];
                } else {
                    self.lblTotalAmount.text = [self formatNumber:[vo.showValue doubleValue]];
                }
            }
            continue;
        }
        BusinessDetailLable *businessDetailLable = [[NSBundle mainBundle] loadNibNamed:@"BusinessDetailLable" owner:self options:nil].lastObject;
        businessDetailLable.ls_origin = CGPointMake(businessDetailLable.frame.size.width *((i-1) %3), businessDetailLable.frame.size.height * ((i-1) /3));
        [self.container addSubview:businessDetailLable];
        if ((i-1) % 3 == 2) {
            businessDetailLable.view.hidden = YES;
        }
        businessDetailLable.labName.text = [NSString stringWithFormat:@"%@",vo.showName];
        if (isHasAction == 0) {
            businessDetailLable.labCount.text = @"-";
        } else {
            if ([vo.showName isEqualToString:@"客单数(单)"]) {
                NSString* oldValue=[NSString stringWithFormat:@"%d",[vo.showValue intValue]];
                NSString *regex = @"([0-9])(?=([0-9]{3})+\\.)";
                businessDetailLable.labCount.text = [oldValue stringByReplacingOccurrencesOfRegex:regex withString:@"$1,"];
            } else {
                businessDetailLable.labCount.text = [self formatNumber:[vo.showValue doubleValue]];
            }
        }
        self.container.ls_height = businessDetailLable.ls_bottom;
    }
    self.view.ls_height = self.container.ls_bottom;
    self.backGround.ls_height = self.view.ls_height;
    self.ls_height = self.view.ls_height;
}

- (NSString *)formatNumber:(double)value
{
    return [FormatUtil formatDoubleWithSeperator:value];
}


@end
