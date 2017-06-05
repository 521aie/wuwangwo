//
//  LSByTimeRechargeRecordCell.m
//  retailapp
//
//  Created by taihangju on 2017/3/31.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSByTimeRechargeRecordCell.h"
#import "LSByTimeRechargeRecordVo.h"
#import "DateUtils.h"

@interface LSByTimeRechargeRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *lowerRightLabel; // 右下label
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UILabel *lowerLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *topRightLabel;
@end

@implementation LSByTimeRechargeRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)fillMemberByTimeRechargeVo:(LSByTimeRechargeRecordVo *)vo {
    
    _topRightLabel.hidden = YES;
    
    if ([vo byTimeRechargeRecordVoOperType] == LSByTimeRechargeRecordOperType_Recharge) {
      
        _lowerLeftLabel.textColor = [ColorHelper  getRedColor];
        _lowerLeftLabel.text = [NSString stringWithFormat:@"￥%.2f", vo.price.floatValue];
   
    }  else if ([vo byTimeRechargeRecordVoOperType] == LSByTimeRechargeRecordOperType_Refund) {
       
        _lowerLeftLabel.textColor = [ColorHelper  getGreenColor];
        _lowerLeftLabel.text = [NSString stringWithFormat:@"-￥%.2f", vo.price.floatValue];
    }
    
    
    _name.text = vo.accountCardName;
    _lowerRightLabel.text = [DateUtils formateTime1:vo.createTime.longLongValue];
}

@end
