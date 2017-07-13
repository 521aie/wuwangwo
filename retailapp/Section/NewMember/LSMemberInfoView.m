//
//  LSMemberInfoView.m
//  retailapp
//
//  Created by byAlex on 16/9/12.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberInfoView.h"
#import "Masonry.h"
#import "ColorHelper.h"
#import "UIImageView+SDAdd.h"
#import "LSMemberInfoVo.h"
#import "LSMemberCardVo.h"
#import "DateUtils.h"

@interface LSMemberInfoView()

@property (nonatomic ,assign) id<LSMemberInfoViewDelegate> delgate;/*<>*/
@end

@implementation LSMemberInfoView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<LSMemberInfoViewDelegate>)delegate {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.delgate = delegate;
        [self configSubViews];
    }
    return self;
}


- (void)configSubViews {
    
    // 头像圆角默认是边长的一半
    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//    self.headImageView.image = [UIImage imageNamed:@"unregistered"];
    [self addSubview:self.headImageView];
//    self.headImageView.layer.cornerRadius = 25.0;
    [self.headImageView ls_addCornerWithRadii:25 roundRect:CGRectMake(0, 0, 50, 50)];
    
    self.headLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.headLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
    self.headLabel.textColor =  [ColorHelper getBlackColor];
    [self addSubview:self.headLabel];
    
    self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.phoneLabel.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightThin];
    self.phoneLabel.textColor = [ColorHelper getBlackColor];
    [self addSubview:self.phoneLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"修改" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(phoneChangedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    self.changeButton = button;
    self.changeButton.hidden = YES;
    
    self.birthdayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.birthdayLabel.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightThin];
    self.birthdayLabel.textColor = [ColorHelper getBlackColor];
    [self addSubview:self.birthdayLabel];
    
    self.separateLine = [[UIView alloc] initWithFrame:CGRectZero];
    self.separateLine.backgroundColor = [ColorHelper getTipColor9];
    [self addSubview:self.separateLine];
    

    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.statusLabel.numberOfLines = 0;
    self.statusLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.statusLabel.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightThin];
    self.statusLabel.textColor = [ColorHelper getGreenColor];
    [self addSubview:self.statusLabel];

    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.mas_left).offset(10);
        make.width.and.height.equalTo(50.0);
        make.centerY.equalTo(self.centerY);
    }];
    
    [self.headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(10.0);
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-8.0);
        make.height.equalTo(@19);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.headLabel.mas_bottom);
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.height.equalTo(@19);
    }];
    
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneLabel.mas_right).offset(5.0);
        make.centerY.equalTo(self.phoneLabel.mas_centerY);
        make.width.equalTo(@40.0);
        make.height.equalTo(@30.0);
    }];
    
    [self.birthdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.phoneLabel.mas_bottom);
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-8.0);
        make.height.equalTo(@19);
    }];
    
   
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.birthdayLabel.mas_bottom);
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-8.0);
        make.bottom.lessThanOrEqualTo(self.mas_bottom);
    }];
    
    
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@1);
        make.bottom.equalTo(self.mas_bottom);
    }];

}


- (void)setOwnCardStatusString:(NSArray *)cards cardTypes:(NSArray *)cardTypes {
    
    // LSMemberInfoView 已发卡名称及卡状态拼接
    if ([ObjectUtil isNotEmpty:cards]) {
        
        NSMutableAttributedString *statuString = [[NSMutableAttributedString alloc] initWithString:@"已领卡: " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0 weight:UIFontWeightThin],NSForegroundColorAttributeName:[ColorHelper getGreenColor]}];
        [cards enumerateObjectsUsingBlock:^(LSMemberCardVo *card, NSUInteger idx, BOOL * _Nonnull stop) {
            
            // 找到card 对应的会员卡类型
            LSMemberTypeVo *typeVo = card.cardTypeVo;
            if (!typeVo) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"sId='%@'" ,card.kindCardId]];
                typeVo = [cardTypes filteredArrayUsingPredicate:predicate].firstObject;
            }
            NSString *commonString = (idx == cards.count-1 ? @"" : @"、");
            if ([card isLost]) {
                commonString = (idx == cards.count-1 ? @"(挂失)" :@"(挂失)、");
                NSString *tempString = [NSString stringWithFormat:@"%@%@" ,typeVo.name,commonString];
                NSMutableAttributedString *abbributeString = [[NSMutableAttributedString alloc] initWithString:tempString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0 weight:UIFontWeightThin],NSForegroundColorAttributeName:[ColorHelper getGreenColor]}];
                NSRange range = [tempString rangeOfString:@"(挂失)"];
                [abbributeString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0 weight:UIFontWeightThin],NSForegroundColorAttributeName:[UIColor redColor]} range:range];
                [statuString appendAttributedString:abbributeString];
            }
            else {
                NSString *tempString = [NSString stringWithFormat:@"%@%@" ,typeVo.name,commonString];
                NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:tempString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0 weight:UIFontWeightThin],NSForegroundColorAttributeName:[ColorHelper getGreenColor]}];
                [statuString appendAttributedString:attributeString];
            }
        }];
        
        self.statusLabel.attributedText = statuString;
        
        // 调整LSMemberInfoView 高度
        CGSize size  = [NSString getTextSizeWithText:statuString.string font:[UIFont systemFontOfSize:13.0 weight:UIFontWeightThin] maxSize:CGSizeMake(CGRectGetWidth(self.statusLabel.frame), CGFLOAT_MAX)];
        // 73 是其他子控件和y轴间隙所占的高度
        if (size.height + 73 >= self.ls_height) {
            self.ls_height = 73 + size.height;
            if ([self.delgate respondsToSelector:@selector(memberInfoViewHeightChaged)]) {
                [self.delgate memberInfoViewHeightChaged];
            }
        }
    }
    else {
        NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:@"未领卡" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0 weight:UIFontWeightThin],NSForegroundColorAttributeName:[UIColor redColor]}];
        self.statusLabel.attributedText = attributeString;
    }

}

- (void)fillMemberInfo:(id)obj cards:(NSArray *)cardArray cardTypes:(NSArray *)typeArray phone:(NSString *)phoneStr {
    
    if ([obj isKindOfClass:[LSMemberPackVo class]]) {
        
        LSMemberPackVo *memberPackVo = (LSMemberPackVo *)obj;

        // 同时没有 二维火会员id和微信第三方会员id，即可判断为未注册会员
        if ([NSString isBlank:memberPackVo.customerRegisterThirdPartyPojo.sId] && [NSString isBlank:memberPackVo.customerRegisterThirdPartyPojo.customerRegisterId]) {
            self.headLabel.text = @"未注册";
            self.headImageView.image = [UIImage imageNamed:@"unregistered"];
        } else {
            
            
            NSString *name = @"-";
            if (memberPackVo.customer && [NSString isNotBlank:memberPackVo.customer.name]) {
                name = memberPackVo.customer.name;
            } else if (memberPackVo.customerRegisterThirdPartyPojo) {
                
                if ([NSString isNotBlank:memberPackVo.customerRegisterThirdPartyPojo.nickName]) {
                    name = memberPackVo.customerRegisterThirdPartyPojo.nickName;
                } else if ([NSString isNotBlank:memberPackVo.customerRegisterThirdPartyPojo.customerRegisterPojo.name]) {
                    name = memberPackVo.customerRegisterThirdPartyPojo.customerRegisterPojo.name;
                }
            }
            
            if ([NSString isNotBlank:memberPackVo.customerRegisterThirdPartyPojo.sId]) {
                // 是微信会员 ， 则优先显示
                NSString *sex = [self getSexString:memberPackVo.customer.sex.intValue];
                self.headLabel.text = [NSString stringWithFormat:@"%@ (%@)",name,sex];
                NSString *path = memberPackVo.customerRegisterThirdPartyPojo.url;
                [self.headImageView ls_setImageWithPath:path placeholderImage:[UIImage imageNamed:@"unregistered"]];
            }
            else if ([NSString isNotBlank:memberPackVo.customerRegisterThirdPartyPojo.customerRegisterId]) {
                // 显示二维火会员信息
                NSString *sex = [self getSexString:memberPackVo.customer.sex.intValue];
                self.headLabel.text = [NSString stringWithFormat:@"%@ (%@)",name,sex];
                NSString *path = nil;
                if ([NSString isNotBlank:memberPackVo.customerRegisterThirdPartyPojo.url]) {
                    path = memberPackVo.customerRegisterThirdPartyPojo.url;
                }
                [self.self.headImageView ls_setImageWithPath:path placeholderImage:[UIImage imageNamed:@"unregistered"]];
            }
        }
        
        // 手机号的显示
        self.phoneLabel.text = @"-";
        if ([NSString isNotBlank:memberPackVo.customerRegisterThirdPartyPojo.customerRegisterPojo.mobile]) {
            self.phoneLabel.text = [NSString stringWithFormat:@"手机：%@" ,memberPackVo.customerRegisterThirdPartyPojo.customerRegisterPojo.mobile];
        }
        else if ([NSString isNotBlank:phoneStr]) {
            self.phoneLabel.text = [NSString stringWithFormat:@"手机：%@" ,phoneStr];
        }
        else if ([NSString isNotBlank:memberPackVo.customer.mobile]) {
            self.phoneLabel.text = [NSString stringWithFormat:@"手机：%@" ,memberPackVo.customer.mobile];
        }
        
        // 生日显示:显示店铺会员生日
        if ([NSString isNotBlank:memberPackVo.customer.birthdayStr]) {
            self.birthdayLabel.text = [NSString stringWithFormat:@"生日：%@",memberPackVo.customer.birthdayStr];
        } else {
            self.birthdayLabel.text = [NSString stringWithFormat:@"生日：-"];
        }
//        if ([NSString isNotBlank:memberPackVo.customerRegisterThirdPartyPojo.customerRegisterPojo.birthday]) {
//            NSString *birthStr =  [DateUtils formateTime3:memberPackVo.customerRegisterThirdPartyPojo.customerRegisterPojo.birthday.longLongValue];
//            self.birthdayLabel.text = [NSString stringWithFormat:@"生日：%@",birthStr];
//        }
//        else {
//            self.birthdayLabel.text = [NSString stringWithFormat:@"生日：-"];
//        }
    
        [self setOwnCardStatusString:cardArray cardTypes:typeArray];
    }
}

// 显示手机号修改按钮
- (void)showPhoneNumChangeButton {
    
//    if ([self.phoneLabel.text hasPrefix:@"手机"]) {
        self.changeButton.hidden = NO;
//    }
}

- (void)phoneChangedAction:(UIButton *)sender {
    
    if ([self.delgate respondsToSelector:@selector(memberInfoViewShowPhoneNumChangeNotice)]) {
        [self.delgate memberInfoViewShowPhoneNumChangeNotice];
    }
}


// 默认性别男
-(NSString *)getSexString:(NSInteger)sex{
    
    if (sex == 1) {
        return @"男";
    }
    else if (sex == 2) {
        return @"女";
    }
    return @"男";
}

@end
