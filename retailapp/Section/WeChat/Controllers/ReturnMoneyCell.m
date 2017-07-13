//
//  ReturnMoneyCell.m
//  retailapp
//
//  Created by diwangxie on 16/4/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ReturnMoneyCell.h"
#import "RetailSellReturnVo.h"
#import "DateUtils.h"

@implementation ReturnMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initWithData:(RetailSellReturnVo *)sellReturnVo {

    NSString *customerName = [NSString text:sellReturnVo.customerName subToIndex:8]?:@"";
    NSString *name = [NSString stringWithFormat:@"%@  %@", customerName, sellReturnVo.customerMobile?:@""];
    
    NSMutableAttributedString* attr = [[NSMutableAttributedString alloc] initWithString:name];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(customerName.length, sellReturnVo.customerMobile.length+2)];
    self.lblName.attributedText = attr;
    NSString *code = sellReturnVo.code;
    if ([code hasPrefix:@"RBW"]) {
        code = [code substringFromIndex:3];
    }
    self.lblNo.text = code;
    
    self.lblTime.text = [DateUtils formateTime:sellReturnVo.createTime];
    self.lblMoney.text= [NSString stringWithFormat:@"￥%0.2f",sellReturnVo.discountAmount];
    self.lblMoney.textColor=[UIColor redColor];
    //退货状态
    self.lblStatus.text = [self getStatusString:sellReturnVo.status];
    if (sellReturnVo.status == 6) {
        self.lblStatus.textColor = [ColorHelper getRedColor];
    } else if (sellReturnVo.status == 2) {
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
