//
//  LSMemberSaveDetailCell.m
//  retailapp
//
//  Created by taihangju on 16/10/8.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberSaveDetailCell.h"
#import "Masonry.h"
#import "LSMemberDetaileVo.h"
#import "DateUtils.h"
#import "LSAlertHelper.h"
#import "NSNumber+Extension.h"

@interface LSMemberSaveDetailCell ()
@property (nonatomic, strong)LSMemberMoneyFlowVo *model;
@end
@implementation LSMemberSaveDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self configSubViews];
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)configSubViews {
    
    self.redRush = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.redRush setTitle:@"红冲" forState:0];
    [self.redRush setImage:[UIImage imageNamed:@"Ico_detail_delete"] forState:0];
    [self.redRush setTitleColor:[UIColor blackColor] forState:0];
    [self.redRush.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
    [self.contentView addSubview:self.redRush];
    self.redRush.imageEdgeInsets = UIEdgeInsetsMake(6, 3, 20, 3);
    self.redRush.titleEdgeInsets = UIEdgeInsetsMake(17, -44, -4, -9);
    self.redRush.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.redRush addTarget:self action:@selector(redRushAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rechargeInfo = [[UILabel alloc] initWithFrame:CGRectZero];
    self.rechargeInfo.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:self.rechargeInfo];
    
//    self.rechargeType = [[UILabel alloc] initWithFrame:CGRectZero];
//    self.rechargeType.font = [UIFont systemFontOfSize:13.0];
//    [self.contentView addSubview:self.rechargeType];
    self.balance = [[UILabel alloc] initWithFrame:CGRectZero];
    self.balance.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:self.balance];
    
    if ([self.reuseIdentifier isEqualToString:@"LSMemberSaveDetailCell"]) {
        self.payScore = [[UILabel alloc] initWithFrame:CGRectZero];
        self.payScore.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:self.payScore];
    }
    
    
    self.payType = [[UILabel alloc] initWithFrame:CGRectZero];
    self.payType.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:self.payType];
    
    self.time = [[UILabel alloc] initWithFrame:CGRectZero];
    self.time.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:self.time];
    
    [self.redRush mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10.0);
        make.top.equalTo(self.contentView.mas_top).offset(8.0);
        make.width.equalTo(@40.0);
        make.height.equalTo(@40.0);
        make.bottom.mas_lessThanOrEqualTo(self.contentView.mas_bottom);
    }];
    
    [self.rechargeInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(4.0);
        make.left.equalTo(@8.0);
        make.right.equalTo(self.redRush.mas_left);
    }];
    
   
    if ([self.reuseIdentifier isEqualToString:@"LSMemberSaveDetailCell"]) {
        [self.payScore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.rechargeInfo.mas_bottom).offset(4.0);
            make.left.equalTo(@8.0);
            make.right.equalTo(self.redRush.mas_left);
        }];
        
        [self.payType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.payScore.mas_bottom).offset(4.0);
            make.left.equalTo(@8.0);
            make.right.equalTo(self.redRush.mas_left);
        }];
    }else{
        [self.payType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.rechargeInfo.mas_bottom).offset(4.0);
            make.left.equalTo(@8.0);
            make.right.equalTo(self.redRush.mas_left);
        }];
    }
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payType.mas_bottom).offset(4.0);
        make.left.equalTo(@8.0);
        make.right.equalTo(self.redRush.mas_left);
    }];
    
    [self.balance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.time.mas_bottom).offset(4.0);
        make.left.equalTo(@8.0);
        make.right.equalTo(self.redRush.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5.0);
    }];
}

- (void)updateConstraints {
    [super updateConstraints];

    if ([NSString isBlank:self.payType.text]) {
        [self.time mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.payType.mas_bottom).offset(4.0);
            make.left.equalTo(self.contentView.mas_left).offset(8.0);
            make.right.equalTo(self.redRush.mas_left);
        }];
    }
    else {
        [self.time mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.payType.mas_bottom).offset(4.0);
            make.left.equalTo(self.contentView.mas_left).offset(8.0);
            make.right.equalTo(self.redRush.mas_left);
        }];
    }
}


- (void)prepareForReuse {
    self.rechargeInfo.text = nil;
    self.payType.text = nil;
    self.time.text = nil;
    self.balance.text = nil;
}

- (void)redRushAction:(UIButton *)sender {
    
    if (self.callBack) {
        
        // 点击充值红冲和积分红冲要先判断有无操作权限
        if (!self.redRush.hidden && [self.rechargeInfo.text containsString:@"充值"]) {
            
            if ([[Platform Instance] lockAct:ACTION_CARD_UNDO_CHARGE]) {
                [LSAlertHelper showAlert:[NSString stringWithFormat:@"您没有[充值红冲]的权限"] block:nil];
                return;
            }
        }
        else if (!self.redRush.hidden && [self.rechargeInfo.text containsString:@"赠分"]) {
            
            if ([[Platform Instance] lockAct:ACTION_CARD_UNDO_GIVE_DEGREE]) {
                [LSAlertHelper showAlert:[NSString stringWithFormat:@"您没有[赠分红冲]的权限"] block:nil];
                return;
            }
        }
        
        self.callBack();
    }
}


// 储值明细 , 数据填充
- (void)fillSaveDetailData:(LSMemberMoneyFlowVo *)obj {
    self.model = obj;
    UIColor *color = nil;
    if (obj.action.integerValue == MoneyActionRecharge) {
        
        NSString *hasRedRushString = @"";
        if (obj.isChanged && obj.isChanged.boolValue) {
            
            self.redRush.hidden = YES;
            hasRedRushString = @"(已红冲)";
        }
        else {
            self.redRush.hidden = NO;
        }
        self.payType.hidden = NO;
        self.payScore.hidden = NO;
        if ([obj.pay isEqual:obj.fee]) {
            self.rechargeInfo.text = [NSString stringWithFormat:@"%@%.2f%@" ,[obj getActionStringWithTextColor:&color] ,obj.fee.doubleValue ,hasRedRushString];
        }
        else if ([obj.pay compare:obj.fee] == NSOrderedAscending) {
            NSString *giftString = [NSString stringWithFormat:@"(含赠送￥%.2f)" ,obj.fee.doubleValue-obj.pay.doubleValue];
            self.rechargeInfo.text = [NSString stringWithFormat:@"%@%0.2f%@%@" , [obj getActionStringWithTextColor:&color] ,obj.fee.doubleValue ,giftString, hasRedRushString];
        }
        self.payScore.text = [NSString stringWithFormat:@"赠送积分：%d",obj.giftDegree.intValue];
        
//       self.payType.text = [obj getPayModeString];
        self.payType.text = @"支付方式: ";
        if ([NSString isNotBlank:obj.payModeStr]) {
            self.payType.text = [NSString stringWithFormat:@"支付方式: %@" ,obj.payModeStr];
        }
    }
    else if (obj.action.integerValue == MoneyActionConsume) {
        
        self.redRush.hidden = YES;
        self.payType.hidden = YES;
        self.payScore.hidden = YES;
        NSString *hasBackRushString = @""; // 是否已回冲
        if (obj.status && obj.status.integerValue == 0) {
            hasBackRushString = @"(已回冲)";
        }
        self.rechargeInfo.text = [NSString stringWithFormat:@"%@%.2f" ,[obj getActionStringWithTextColor:&color] ,obj.pay.doubleValue];
   
    }
    else if (obj.action.integerValue == MoneyActionRedRush) {
        
        self.redRush.hidden = YES;
        self.payType.hidden = YES;
        self.payScore.hidden = YES;
        if ([obj.pay isEqual:obj.fee]) {
            self.rechargeInfo.text = [NSString stringWithFormat:@"%@%.2f" ,[obj getActionStringWithTextColor:&color] ,obj.fee.doubleValue];
        }
        else if ([obj.pay compare:obj.fee] == NSOrderedAscending) {
            NSString *giftString = [NSString stringWithFormat:@"(含赠送￥%.2f)" ,obj.fee.doubleValue-obj.pay.doubleValue];
            self.rechargeInfo.text = [NSString stringWithFormat:@"%@%0.2f%@" , [obj getActionStringWithTextColor:&color] ,obj.fee.doubleValue ,giftString];
        }
    }
    else if (obj.action.integerValue == MoneyActionBackRush || obj.action.integerValue == MoneyActionGoodsReturn) {
        
        self.redRush.hidden = YES;
        self.payType.hidden = YES;
        self.payScore.hidden = YES;
        self.rechargeInfo.text = [NSString stringWithFormat:@"%@%.2f" , [obj getActionStringWithTextColor:&color],obj.pay.doubleValue];
    }
    
    
    self.rechargeInfo.textColor = color;
    
    // 时间
    if (obj.createTime) {
        self.time.text = [NSString stringWithFormat:@"时间：%@" ,[DateUtils formateLongChineseTime:obj.consumeDate.longLongValue]];
    }
    
    self.balance.text = [NSString stringWithFormat:@"卡内余额：%@" ,[obj.balance currencyStringWithSymbol:@"￥"]];
    [self upDataUI];
    [self setNeedsUpdateConstraints];
}

-(void)upDataUI
{
    if ([self.reuseIdentifier isEqualToString:@"LSMemberSaveDetailCell"]) {
        if (self.model.action.integerValue != MoneyActionRecharge) {
            [self.redRush mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(-10.0);
                make.top.equalTo(self.contentView.mas_top).offset(8.0);
                make.width.equalTo(@40.0);
                make.height.equalTo(@40.0);
                make.bottom.mas_lessThanOrEqualTo(self.contentView.mas_bottom);
            }];
            
            [self.rechargeInfo mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_top).offset(4.0);
                make.left.equalTo(@8.0);
                make.right.equalTo(self.redRush.mas_left);
            }];
            
            
            [self.payType mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.rechargeInfo.mas_bottom).offset(4.0);
                make.left.equalTo(@8.0);
                make.right.equalTo(self.redRush.mas_left);
            }];
            
            
            [self.time mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.payType.mas_bottom).offset(4.0);
                make.left.equalTo(@8.0);
                make.right.equalTo(self.redRush.mas_left);
            }];
            
            [self.balance mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.time.mas_bottom).offset(4.0);
                make.left.equalTo(@8.0);
                make.right.equalTo(self.redRush.mas_left);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-5.0);
            }];
        }else{
            [self.redRush mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(-10.0);
                make.top.equalTo(self.contentView.mas_top).offset(8.0);
                make.width.equalTo(@40.0);
                make.height.equalTo(@40.0);
                make.bottom.mas_lessThanOrEqualTo(self.contentView.mas_bottom);
            }];
            
            [self.rechargeInfo mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_top).offset(4.0);
                make.left.equalTo(@8.0);
                make.right.equalTo(self.redRush.mas_left);
            }];
            
            [self.payScore mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.rechargeInfo.mas_bottom).offset(4.0);
                make.left.equalTo(@8.0);
                make.right.equalTo(self.redRush.mas_left);
            }];
            
            
            
            [self.payType mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.payScore.mas_bottom).offset(4.0);
                make.left.equalTo(@8.0);
                make.right.equalTo(self.redRush.mas_left);
            }];
            
            
            [self.time mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.payType.mas_bottom).offset(4.0);
                make.left.equalTo(@8.0);
                make.right.equalTo(self.redRush.mas_left);
            }];
            
            [self.balance mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.time.mas_bottom).offset(4.0);
                make.left.equalTo(@8.0);
                make.right.equalTo(self.redRush.mas_left);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-5.0);
            }];
        }
    }
}

// 积分明细
- (void)fillIntegralDetailData:(LSMemberDegreeFlowVo *)obj {
    
    UIColor *color = nil;
    if (obj.action.integerValue == DegreeActionConsume) {
        
        self.redRush.hidden = YES;
        self.payType.hidden = NO;
        NSString *hasBackReshString = @"";
        if (obj.isChanged && obj.isChanged.boolValue) {
            hasBackReshString = @"(已回冲)";
        }
        
        self.rechargeInfo.text = [NSString stringWithFormat:@"%@%@%@" ,[obj getActionStringWithTextColor:&color] ,obj.num ,hasBackReshString];
//        self.payType.text = [NSString stringWithFormat:@"单号：%@" ,obj.consumeDate];
        // 默认开微店：不显示“单号”栏
        self.payType.text = @"";
    } else if (obj.action.integerValue == DegreeActionRedRush) {
        
        self.redRush.hidden = YES;
        self.payType.hidden = YES;
        self.rechargeInfo.text = [NSString stringWithFormat:@"%@%@" ,[obj getActionStringWithTextColor:&color] ,obj.num];
    } else if (obj.action.integerValue == DegreeActionGift) {
        
        self.payType.hidden = YES;
        NSString *hasBackReshString = @"";
        if (obj.status && obj.status.boolValue) {
            self.redRush.hidden = NO;
        }
        else {
            self.redRush.hidden = YES;
            hasBackReshString = @"(已红冲)";
        }
        self.rechargeInfo.text = [NSString stringWithFormat:@"%@%@%@" ,[obj getActionStringWithTextColor:&color] ,obj.num ,hasBackReshString];
    } else if (obj.action.integerValue == DegreeActionExchange) {
       
        self.payType.hidden = NO;
        self.redRush.hidden = YES;
        self.rechargeInfo.text = [NSString stringWithFormat:@"%@%@" ,[obj getActionStringWithTextColor:&color] ,obj.num];
        self.payType.text = [NSString stringWithFormat:@"兑换商品名称：%@" ,obj.giftName];
    } else if (obj.action.integerValue == DegreeActionBackRush) {
        
        self.payType.hidden = YES;
        self.redRush.hidden = YES;
        self.rechargeInfo.text = [NSString stringWithFormat:@"%@%@" ,[obj getActionStringWithTextColor:&color] ,obj.num];
    }
    
    self.rechargeInfo.textColor = color;
    
    if (obj.consumeDate) {
        NSString *time = [DateUtils formateLongChineseTime:obj.consumeDate.longLongValue];
        self.time.text = [NSString stringWithFormat:@"时间: %@" ,time];
    }
    self.balance.text = [NSString stringWithFormat:@"积分余额：%@" ,obj.degree];
    [self setNeedsUpdateConstraints];
}

@end
