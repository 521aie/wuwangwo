//
//  LSMemberExpenseInfoCell.m
//  retailapp
//
//  Created by byAlex on 16/9/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberExpenseInfoCell.h"
#import "LSMemberExpandRecordVo.h"
#import "Masonry.h"
#import "ColorHelper.h"
#import "NSNumber+Extension.h"

@implementation LSMemberExpenseInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self configSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configSubViews {
    
    self.moneySumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.moneySumLabel.textColor = [ColorHelper getGreenColor];
    self.moneySumLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.moneySumLabel];
    
    self.billIdLable = [[UILabel alloc] initWithFrame:CGRectZero];
    self.billIdLable.textColor = [ColorHelper getTipColor3];
    self.billIdLable.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.billIdLable];
    
//    self.payTypeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    self.payTypeLabel.textColor = [ColorHelper getTipColor3];
//    self.payTypeLabel.font = [UIFont systemFontOfSize:14.0];
//    [self.contentView addSubview:self.payTypeLabel];
    
    
    self.timeLable = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeLable.textColor = [ColorHelper getTipColor3];
    self.timeLable.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.timeLable];
    
    self.mbShowDetailImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.mbShowDetailImageView.image = [UIImage imageNamed:@"ico_next"];
    [self.contentView addSubview:self.mbShowDetailImageView];
    
//    self.orderSource = [[UILabel alloc] initWithFrame:CGRectZero];
//    self.orderSource.textColor = [ColorHelper getRedColor];
//    self.orderSource.font = [UIFont systemFontOfSize:14.0];
//    self.orderSource.textAlignment = NSTextAlignmentCenter;
//    self.orderSource.layer.borderWidth = 1.0;
//    self.orderSource.layer.cornerRadius = 4.0;
//    self.orderSource.layer.borderColor = [ColorHelper getRedColor].CGColor;
//    [self.contentView addSubview:self.orderSource];
//    self.orderSource.hidden = YES;
    
    self.paySourceImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.paySourceImageView];
    self.paySourceImageView.hidden = YES;
    
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomLine.backgroundColor = [ColorHelper getTipColor9];
    [self.contentView addSubview:self.bottomLine];
    
    [self.moneySumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_top).offset(15.0);
        make.left.equalTo(self.contentView.mas_left).offset(10.0);
        make.height.equalTo(@20.0);
    }];
    
    [self.billIdLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.moneySumLabel.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(10.0);
        make.right.lessThanOrEqualTo(self.paySourceImageView.mas_left);
        make.height.equalTo(@20.0);
    }];
    
    [self.paySourceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mbShowDetailImageView.mas_left).offset(-4);
        make.top.equalTo(@12.0);
        make.width.equalTo(@40.0);
        make.height.equalTo(@15.0);
    }];
    
//    [self.payTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(self.billIdLable.mas_bottom);
//        make.left.equalTo(self.contentView.mas_left).offset(10.0);
//        make.height.equalTo(@20.0);
//    }];
    
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.billIdLable.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(10.0);
        make.height.equalTo(@20.0);
    }];
    
    [self.mbShowDetailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-8.0);
        make.width.and.height.equalTo(@22.0);
    }];
    
//    [self.orderSource mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mbShowDetailImageView.mas_left).offset(-4.0);
//        make.top.equalTo(self.contentView.mas_top).offset(10.0);
//    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@1.0);
        make.bottom.equalTo(self.contentView.mas_bottom);
        
    }];
}

- (void)fillMemberExpandVo:(LSMemberExpandRecordVo *)vo {

   self.moneySumLabel.textColor = vo.cost.doubleValue < 0 ? [ColorHelper getGreenColor]:[ColorHelper getRedColor];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"金额：" attributes:@{NSForegroundColorAttributeName : [ColorHelper getTipColor3]}];
    double cost = fabs(vo.cost.doubleValue);
    if (vo.cost.doubleValue < 0 ) {
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"-￥%.2f", cost] attributes:@{NSForegroundColorAttributeName : [ColorHelper getGreenColor]}]];
    } else {
         [attr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%.2f", cost] attributes:@{NSForegroundColorAttributeName : [ColorHelper getRedColor]}]];
    }
  
    self.moneySumLabel.attributedText = attr;
    self.billIdLable.text = [NSString stringWithFormat:@"单号:%@" ,[NSString shortStringForOrderID:vo.code]];
    self.billIdLable.lineBreakMode = NSLineBreakByTruncatingTail;
//    self.payTypeLabel.text = [NSString stringWithFormat:@"支付方式:%@" ,vo.outType];
    self.timeLable.text = [NSString stringWithFormat:@"时间:%@" ,[vo expandTimeString]];
    
    if ([vo.outType isEqualToString:@"weixin"]) {//微信订单
        self.paySourceImageView.image = [UIImage imageNamed:@"weixin"];
        self.paySourceImageView.hidden = NO;
    }
    else if ([vo.outType isEqualToString:@"weiPlatform"]) {//微平台订单
        self.paySourceImageView.image = [UIImage imageNamed:@"weiplatform"];
        self.paySourceImageView.hidden = NO;
    }
    else {//实体订单
        self.paySourceImageView.hidden = YES;
    }
}
@end
