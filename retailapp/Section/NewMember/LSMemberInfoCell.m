//
//  LSMemberCardInfoCell.m
//  retailapp
//
//  Created by byAlex on 16/9/13.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberInfoCell.h"
#import "ColorHelper.h"
#import "Masonry.h"
#import "UIImageView+SDAdd.h"
#import "LSMemberInfoVo.h"
#import "DateUtils.h"
#import "LSMemberNewAddedVo.h"
#import "UIImageView+SDAdd.h"

@implementation LSMemberInfoCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self configSubViews];
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layoutMargins = UIEdgeInsetsZero;
        self.separatorInset = UIEdgeInsetsZero;
    }
    return self;
}

- (void)configSubViews {
    
    self.mbImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.mbImageView.image = [UIImage imageNamed:@"unregistered"];
    [self.contentView addSubview:self.mbImageView];
    [self.mbImageView ls_addCornerWithRadii:25 roundRect:CGRectMake(0, 0, 50, 50)];
    
    self.mbNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.mbNameLabel.textColor = [ColorHelper getTipColor3];
    self.mbNameLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.mbNameLabel];
    [self.mbNameLabel sizeToFit];
    
    self.mbPhoneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.mbPhoneLabel.textColor = [ColorHelper getTipColor3];
    self.mbPhoneLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.mbPhoneLabel];
    [self.mbPhoneLabel sizeToFit];
    
    self.mbStatus = [[UILabel alloc] initWithFrame:CGRectZero];
    self.mbStatus.lineBreakMode = NSLineBreakByTruncatingTail;
    self.mbStatus.numberOfLines = 0;
    self.mbStatus.textColor = [ColorHelper getTipColor3];
    self.mbStatus.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.mbStatus];
    
    self.mbShowDetailImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.mbShowDetailImageView.image = [UIImage imageNamed:@"ico_next"];
    [self.contentView addSubview:self.mbShowDetailImageView];
    
    [self.mbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15.0);
        make.width.and.height.equalTo(@50.0);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.mbNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10.0);
        make.left.equalTo(self.mbImageView.mas_right).offset(10.0);
        make.right.equalTo(self.contentView.mas_right).offset(-35.0);
    }];
    
    [self.mbPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mbNameLabel.mas_bottom).offset(4.0);
        make.left.equalTo(self.mbImageView.mas_right).offset(10.0);
        make.right.equalTo(self.contentView.mas_right).offset(-35.0);
    }];
    
    [self.mbStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mbPhoneLabel.mas_bottom).offset(4.0);
        make.left.equalTo(self.mbImageView.mas_right).offset(10.0);
        make.right.equalTo(self.contentView.mas_right).offset(-35.0);
        make.height.lessThanOrEqualTo(34.0);
    }];
    
    [self.mbShowDetailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-10.0);
        make.width.and.height.equalTo(@22.0);
    }];
}


// 会员一览界面（查询所有会员）
- (void)fillMemberPackVo:(id)vo {
    
    LSMemberPackVo *packVo = (LSMemberPackVo *)vo;

    self.mbNameLabel.text = @"未注册";
    self.mbImageView.image = [UIImage imageNamed:@"unregistered"];
    
    // 会员名
    if ([NSString isNotBlank:packVo.customerName]) {
        _mbNameLabel.text = packVo.customerName;
    } else if ([NSString isNotBlank:packVo.name]) {
        _mbNameLabel.text = packVo.name;
    } else {
        _mbNameLabel.text = @"-";
    }
    
    // 会员头像
    if ([NSString isNotBlank:packVo.customerRegisterId] && [NSString isNotBlank:packVo.imgPath]) {
        [self.mbImageView ls_setImageWithPath:packVo.imgPath placeholderImage:[UIImage imageNamed:@"unregistered"]];
    }
    
    // 手机号
    self.mbPhoneLabel.text = [NSString stringWithFormat:@"手机：%@",[packVo getMemberPhoneNum]];
    
    // 显示领卡情况
    if ([ObjectUtil isNotEmpty:packVo.cardNames]) {
        
        NSString *ownCardString = [packVo.cardNames componentsJoinedByString:@"、"];
        self.mbStatus.text = [NSString stringWithFormat:@"已领卡:%@",ownCardString];
        self.mbStatus.textColor = [ColorHelper getGreenColor];
        
    } else if ([NSString isNotBlank:packVo.kindCardNames]) {
       
        self.mbStatus.text = [NSString stringWithFormat:@"已领卡:%@",packVo.kindCardNames];
        self.mbStatus.textColor = [ColorHelper getGreenColor];
   
    } else {
        self.mbStatus.text = @"未领卡";
        self.mbStatus.textColor = [ColorHelper getRedColor];
    }
}


// 会员信息汇总， 按天查询新增会员
- (void)fillMemberNewAddedVo:(LSMemberNewAddedVo *)vo {
    
    self.mbNameLabel.text = [NSString isNotBlank:vo.customerName] ? vo.customerName : [NSString isNotBlank:vo.name] ? vo.name : @"-";
    self.mbPhoneLabel.text = [NSString isNotBlank:vo.mobile] ? vo.mobile : @"-";
    if ([NSString isNotBlank:vo.cardNames] || vo.cardNum.integerValue > 0) {
        self.mbStatus.textColor = [ColorHelper getGreenColor];
        self.mbStatus.text = [NSString stringWithFormat:@"已领卡:%@",vo.cardNames];
    }
    else {
        self.mbStatus.text = @"未领卡";
        self.mbStatus.textColor = [ColorHelper getRedColor];
    }
    [self.mbImageView ls_setImageWithPath:vo.imageUrl placeholderImage:[UIImage imageNamed:@"unregistered"]];
}
@end
