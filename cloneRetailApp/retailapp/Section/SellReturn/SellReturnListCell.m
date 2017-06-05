//
//  SellReturnListCell.m
//  retailapp
//
//  Created by Jianyong Duan on 15/11/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SellReturnListCell.h"
#import "DateUtils.h"
#import "ColorHelper.h"

@implementation SellReturnListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lblName.font = [UIFont systemFontOfSize:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initWithData:(RetailSellReturnVo *)sellReturnVo {
    
    NSString *customerName = sellReturnVo.customerName;
    customerName = [NSString text:customerName subToIndex:8];
    if ([NSString isNotBlank:customerName] || [NSString isNotBlank:sellReturnVo.customerMobile]) {
        NSString *name = [NSString stringWithFormat:@"%@  %@", customerName?:@"", sellReturnVo.customerMobile?:@""];
        NSMutableAttributedString* attr = [[NSMutableAttributedString alloc] initWithString:name];
        [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(customerName.length, sellReturnVo.customerMobile.length+2)];
        self.lblName.attributedText = attr;
    } else {
        self.lblName.text = @"";
    }
    
    // 全局单号
    NSString *code = sellReturnVo.globalCode?:@"";
    if ([code hasPrefix:@"RBW"]) {
        code = [code substringFromIndex:3];
    }
    self.lblNo.text = code;
    if (sellReturnVo.createTime > 0) {
        self.lblTime.text = [DateUtils formateTime:sellReturnVo.createTime];
    } else {
        self.lblTime.text = @"";
    }
    
    //退货状态
    self.lblStatus.text = [self getStatusString:sellReturnVo.status];
    if (sellReturnVo.status == 6 || sellReturnVo.status == 7) {
        self.lblStatus.textColor = [ColorHelper getRedColor];
    } else if (sellReturnVo.status == 8) {
        self.lblStatus.textColor = [ColorHelper getTipColor6];
    } else if (sellReturnVo.status == 3 || sellReturnVo.status == 2) {
        self.lblStatus.textColor = [ColorHelper getGreenColor];
    } else {
        self.lblStatus.textColor = [ColorHelper getBlueColor];
    }
}

- (NSString *)getStatusString:(short)status {
    NSDictionary *statusDic = @{@"1":@"待审核", @"2":@"退款成功", @"3":@"同意退货", @"4":@"退货中", @"5":@"待退款", @"6":@"拒绝退货", @"7":@"拒绝退款", @"8":@"取消退货", @"9":@"退款失败"};
    NSString *statusString = [statusDic objectForKey:[NSString stringWithFormat:@"%i", status]];
    if ([NSString isNotBlank:statusString]) {
        return statusString;
    } else {
        return @"";
    }
}

@end
