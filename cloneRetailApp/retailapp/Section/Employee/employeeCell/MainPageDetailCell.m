//
//  MainPageSortCell.m
//  retailapp
//
//  Created by qingmei on 15/10/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MainPageDetailCell.h"
#import "ShowTypeVo.h"
#import "ColorHelper.h"

@interface MainPageDetailCell()
@property (nonatomic, strong)NSString *currentVal;
@property (nonatomic, strong)NSString *oldVal;
@end

@implementation MainPageDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (id)getInstance{
    MainPageDetailCell *item = [[[NSBundle mainBundle]loadNibNamed:@"MainPageDetailCell" owner:self options:nil]lastObject];
    return item;
}
- (void)loadCell:(id)obj{
    //设置字体颜色
    self.lblTitle.textColor = [ColorHelper getTipColor3];
    self.lblDetail.textColor = [ColorHelper getTipColor6];
    
    
    if ([obj isKindOfClass:[ShowTypeVo class]]) {
        ShowTypeVo *temp = obj;
        self.shopTpyeVo = nil;
        self.shopTpyeVo = temp;
        [self changeData:[NSString stringWithFormat:@"%ld",(long)temp.isShow]];
        self.oldVal = [NSString stringWithFormat:@"%ld",(long)temp.isShow];
        self.lblTitle.text = temp.showTypeName;
        switch (temp.showType) {
            case 1:
                self.lblDetail.text = @"销售毛利，即销售商品的毛利润";
                //[strTitle appendString:@"(元/㎡)"];
                break;
            case 2:
                self.lblDetail.text = @"员工-业绩目标管理中设置的业绩目标";
//                [strTitle appendString:@"(元)"];
                break;
            case 3:
                self.lblDetail.text = @"净销售额=销售金额-退货金额";
//                [strTitle appendString:@"(元)"];
                break;
            case 4:
                self.lblDetail.text = @"完成率=净销售额/业绩目标×100%";
//                [strTitle appendString:@"(%)"];
                break;
            case 5:
                self.lblDetail.text = @"客单数=销售单数-退货单数";
//                [strTitle appendString:@"(单)"];
                break;
            case 6:
                self.lblDetail.text = @"客单件=销售订单的总件数/客单数";
//                [strTitle appendString:@"(件)"];
                break;
            case 7:
                self.lblDetail.text = @"客单价=净销售额/客单数";
//                [strTitle appendString:@"(元)"];
                break;
            case 8:
                self.lblDetail.text = @"平均折扣=净销售额/（销售数量×零售价）×100%";
//                [strTitle appendString:@"(%)"];
                break;
            case 9:
                self.lblDetail.text = @"净销售额/店铺面积";
//                [strTitle appendString:@"(元/㎡)"];
                break;
            case 10:
                self.lblDetail.text = @"不计入销售额的支付方式金额合计";
                //                [strTitle appendString:@"(元/㎡)"];
                break;
            default:
                break;
        }
        
    }

}

- (IBAction)clickBtn:(id)sender {
    NSString* val=@"1";
    if ([self.currentVal isEqualToString:@"1"]) {
        val=@"0";
    }
    [self changeData:val];
    
    if (self.delegate) {
        [_delegate clickBtnRadio:self];
    }

}
- (void) changeData:(NSString*)data
{
    self.currentVal=([NSString isBlank:data]) ? @"" :data;
    BOOL result=[self.currentVal isEqualToString:@"1"];
    self.shopTpyeVo.isShow = result;
    self.imgOff.hidden=result;
    self.imgOn.hidden=!result;
   
}

- (BOOL)isDataChange{
    if (![self.currentVal isEqualToString:self.oldVal]) {
        return YES;
    }
    return NO;
}

@end
