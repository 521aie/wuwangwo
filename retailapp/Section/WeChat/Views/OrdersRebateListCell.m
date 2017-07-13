//
//  WeChatRebateOrdersCell.m
//  retailapp
//
//  Created by diwangxie on 16/4/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrdersRebateListCell.h"
#import "ObjectUtil.h"
#import "DateUtils.h"
#import "RebateOrdersVo.h"

@implementation OrdersRebateListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initDate:(NSDictionary *) dic{
    RebateOrdersVo *vo=[RebateOrdersVo convertToRebateOrdersVo:dic];
    if ([ObjectUtil isNotNull:vo]) {
        //可提现金额
        
        if (vo.rebateOrderFee>0) {
            self.lblMoney.text=[NSString stringWithFormat:@"+%.2f",vo.rebateOrderFee];
            
        }else{
            self.lblMoney.text=[NSString stringWithFormat:@"%.2f",vo.rebateOrderFee];
        }
        //返利状态
        self.lblWithdrawState.text=[self getRabateString:vo.rebateState];
        if (vo.rebateState==1) {
            self.lblWithdrawState.textColor=[UIColor colorWithRed:0/255.0 green:136/255.0 blue:204/255.0 alpha:1];
        }else{
            self.lblWithdrawState.textColor=[ColorHelper getGreenColor];
        }
        
        CGFloat h = self.lblWithdrawState.frame.size.height;
        UIFont *font = self.lblMoney.font;
        CGSize maxSize = CGSizeMake(MAXFLOAT, h);
        
        CGSize sizeName = [NSString sizeWithText:self.lblMoney.text maxSize:maxSize font:font];
        
        
        
        self.lblMoney.frame=CGRectMake(41, 62, sizeName.width, 21);
        self.lblWithdrawState.frame=CGRectMake(CGRectGetMaxX(self.lblMoney.frame)+5, 62, 70, 21);
        //时间
        if (vo.openTime>0) {
            self.lblCreateTime.text=[DateUtils formateTime:vo.openTime];
        }
        //订单状态
        if (vo.orderState>0) {
            self.lblOrderState.text=[self getStatusString:vo.orderState];
        }
        
        //订单编号
        if ([ObjectUtil isNotNull:vo.orderCode]) {
            self.orderCode.text=[vo.orderCode substringFromIndex:3];
        }
    }
}

- (NSString *)getStatusString:(short)status {
    //销售订单  状态:11待付款、12付款中、13待分配、15待处理、20配送中、21配送完成、16拒绝配送、22交易取消、23交易关闭
    //供货订单:15待处理、20配送中、21配送完成、16拒绝配送
    NSDictionary *statusDic = @{ @"11":@"待付款", @"13":@"待分配", @"15":@"待处理", @"16":@"拒绝配送", @"20":@"配送中", @"21":@"交易成功", @"22":@"交易取消", @"23":@"交易关闭",@"24":@"配送完成"};
    NSString *statusString = [statusDic objectForKey:[NSString stringWithFormat:@"%i", status]];
    if ([NSString isNotBlank:statusString]) {
        return statusString;
    } else {
        return @"";
    }
}

- (NSString *)getRabateString:(short)status {
    //返利订单  状态:1待结算、2可提现
    NSDictionary *statusDic = @{ @"1":@"(待结算)", @"2":@"(可提现)"};
    NSString *statusString = [statusDic objectForKey:[NSString stringWithFormat:@"%i", status]];
    if ([NSString isNotBlank:statusString]) {
        return statusString;
    } else {
        return @"";
    }
}
@end
