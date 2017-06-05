//
//  RecordChangeDetailCell.m
//  retailapp
//
//  Created by qingmei on 15/10/29.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "RecordChangeDetailCell.h"
#import "StockChangeLogVo.h"
#import "ColorHelper.h"
@implementation RecordChangeDetailCell

+ (id)getInstance{
    RecordChangeDetailCell *item = [[[NSBundle mainBundle]loadNibNamed:@"RecordChangeDetailCell" owner:self options:nil]lastObject];
    return item;
}
- (void)loadCell:(id)obj{
    _lblTitle.textColor = [ColorHelper getTipColor3];
    _lblTime.textColor = [ColorHelper getTipColor6];
    _lblCount.textColor = [ColorHelper getTipColor6];
    _lblChangeCount.textColor = [ColorHelper getTipColor6];
    
    if ([obj isKindOfClass:[StockChangeLogVo class]]) {
        StockChangeLogVo *temp = (StockChangeLogVo *)obj;
        _lblTitle.text = temp.operationType;
        _lblTime.text = temp.opTime;
        NSString *str = nil;
        if ([temp.adjustNum .stringValue containsString:@"."]) {
            if (temp.adjustNum.doubleValue < 0) {
                str = [NSString stringWithFormat:@"数量：%.3f", [temp.adjustNum  doubleValue]];
            } else {
                str = [NSString stringWithFormat:@"数量：+%.3f", [temp.adjustNum  doubleValue]];
            }
        } else {
            if (temp.adjustNum.doubleValue < 0) {
                str = [NSString stringWithFormat:@"数量：%.f", [temp.adjustNum  doubleValue]];
            } else {
                str = [NSString stringWithFormat:@"数量：+%.f", [temp.adjustNum  doubleValue]];
            }
           
        }
        UIColor *color = temp.adjustNum.doubleValue < 0 ? [ColorHelper getGreenColor] : [ColorHelper getRedColor];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
        [attr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(3, str.length - 3)];
        _lblCount.attributedText = attr;
       
//        _lblCount.ls_centerY = self.contentView.ls_centerY;
        
        
        
        

        
        if ([temp.stockBalance.stringValue containsString:@"."]) {
            _lblChangeCount.text = [NSString stringWithFormat:@"变更后：%.3f", [temp.stockBalance doubleValue]];
        } else {
             _lblChangeCount.text = [NSString stringWithFormat:@"变更后：%.f", [temp.stockBalance doubleValue]];
        }
        
        if ([ObjectUtil isNull:temp.stockBalance]) {//兼容以前的版本如果是以前的版本是没有变更后这个概念的
            _lblChangeCount.hidden = YES;
        } else {
            _lblChangeCount.hidden = NO;
        }
        
    }

}
@end
