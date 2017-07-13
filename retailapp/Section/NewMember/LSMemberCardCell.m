//
//  LSMemberCardCell.m
//  retailapp
//
//  Created by byAlex on 16/9/13.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberCardCell.h"
#import "Masonry.h"
#import "ColorHelper.h"
#import "UIImageView+SDAdd.h"
#import "LSCardBackgroundImageVo.h"
#import "LSMemberCardVo.h"
#import "DateUtils.h"
#import "LSMemberConst.h"
#import "NSNumber+Extension.h"

@interface LSMemberCardCell ()

// 共同属性，显示
@property (nonatomic ,strong) UIImageView *bgImagView;/* <背景*/
@property (nonatomic ,strong) UILabel *shopName;/* <左上角 会员卡消费店铺*/
@property (nonatomic ,strong) UILabel *cardTypeName;/* <卡类型名*/
@property (nonatomic ,strong) UILabel *cardNum;/* <卡号*/
@property (nonatomic ,strong) UILabel *statusLabel;/*<已删除此会员卡 提示>*/
@property (nonatomic ,strong) UIImageView *lossHandleImageView;/*<挂失 指示图标>*/
@property (nonatomic ,strong) UIButton *reSendButton;/*<重发此卡button>*/
@property (nonatomic ,strong) UILabel *leftLabel;/*<折扣率title>*/
@property (nonatomic ,strong) UILabel *minddleLabel;/*<余额title>*/
@property (nonatomic ,strong) UILabel *rightLabel;/*<积分title>*/

// 某些情况显示
@property (nonatomic ,strong) UIView *wrapper;/* <底部会员卡信息*/
@property (nonatomic ,strong) UILabel *primedRate;/* <折扣率*/
@property (nonatomic ,strong) UILabel *balance;/* <余额*/
@property (nonatomic ,strong) UILabel *intergral;/* <积分*/
@property (nonatomic ,strong) UIImageView *maskView;/*<一定透明度遮在wrapper上的view>*/
@end
@implementation LSMemberCardCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        [self configSubViews];
    }
    return self;
}

- (void)prepareForReuse {
    self.cardNum.text = @"NO.00000000000";
    self.cardTypeName.text = @"";
    self.primedRate.text = @"10折";
    self.balance.text = @"￥0";
    self.intergral.text = @"0";
    self.cardTypeName.hidden = NO;
    self.cardNum.hidden = NO;
    self.reSendButton.hidden = YES;
    self.statusLabel.hidden  = YES;
    self.lossHandleImageView.hidden = YES;
    self.bgImagView.image = [UIImage imageNamed:kDefaultCardBackgroundImageName];
}


- (void)configSubViews {
    
    self.bgImagView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.bgImagView];
    self.bgImagView.image = [UIImage imageNamed:kDefaultCardBackgroundImageName];
    self.bgImagView.layer.masksToBounds = YES;
    self.bgImagView.layer.cornerRadius = 5.0;
    
    
    self.shopName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.shopName.textColor = [ColorHelper getWhiteColor];
    self.shopName.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:self.shopName];

    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.statusLabel.font = [UIFont systemFontOfSize:12.0];
    self.statusLabel.textColor = [ColorHelper getWhiteColor];
    self.statusLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.layer.cornerRadius = 3.0;
    self.statusLabel.layer.masksToBounds = YES;
    self.statusLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.statusLabel];
    self.statusLabel.hidden = YES;
    
    self.lossHandleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_lossHandle"]];
    [self.contentView addSubview:self.lossHandleImageView];
    self.lossHandleImageView.hidden = YES;
    
    self.cardNum = [[UILabel alloc] initWithFrame:CGRectZero];
    self.cardNum.textColor = [ColorHelper getWhiteColor];
    self.cardNum.font = [UIFont systemFontOfSize:11.0];
    self.cardNum.textAlignment = NSTextAlignmentCenter;
    self.cardNum.alpha = 0.5;
    [self.contentView addSubview:self.cardNum];
    
    self.reSendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.reSendButton setBackgroundColor:[ColorHelper getPlaceholderColor]];
    self.reSendButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    self.reSendButton.titleLabel.textColor = [ColorHelper getRedColor];
    [self.reSendButton setTitle:@"重发此卡" forState:0];
    self.reSendButton.layer.cornerRadius = 30.0;
    self.reSendButton.layer.borderWidth = 0.8;
    self.reSendButton.layer.borderColor = [ColorHelper  getTipColor9].CGColor;
    [self.contentView addSubview:self.reSendButton];
    self.reSendButton.hidden = YES;
    [self.reSendButton addTarget:self action:@selector(reSendCard:) forControlEvents:UIControlEventTouchUpInside];
    
    self.cardTypeName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.cardTypeName.textColor = [ColorHelper getWhiteColor];
    self.cardTypeName.font = [UIFont systemFontOfSize:20.0];
    self.cardTypeName.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.cardTypeName];
    
    self.wrapper = [[UIView alloc] initWithFrame:CGRectZero];
    self.wrapper.backgroundColor = [UIColor clearColor];
    self.wrapper.layer.cornerRadius = 8.0;
    self.wrapper.layer.masksToBounds = YES;
    [self.contentView addSubview:self.wrapper];
    
    [self.bgImagView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 5, 0, 5));
    }];
    
    [self.statusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImagView.mas_right).offset(-10);
        make.top.equalTo(self.bgImagView.mas_top).offset(10);
        make.width.lessThanOrEqualTo(@120);
    }];
    
    [self.lossHandleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImagView.mas_top);
        make.right.equalTo(self.bgImagView.mas_right);
        make.width.and.height.equalTo(@40);
    }];
    
    [self.shopName mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView.mas_leftMargin).offset(5.0);
        make.top.equalTo(self.contentView.mas_topMargin);
    }];
    

    [self.cardTypeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgImagView.mas_centerY);
        make.left.equalTo(self.contentView.mas_leftMargin);
        make.right.equalTo(self.contentView.mas_rightMargin);
    }];
    
    [self.cardNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImagView.mas_centerY);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.left.equalTo(self.contentView.mas_leftMargin);
        make.right.equalTo(self.contentView.mas_rightMargin);
    }];
    
    [self.reSendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.centerX);
        make.centerY.equalTo(self.contentView.centerY).offset(-20.0);
        make.width.and.height.equalTo(@60.0);
    }];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectZero];
    label1.textColor = [ColorHelper getWhiteColor];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:14.0];
    label1.text = @"折扣";
    [self.wrapper addSubview:label1];
    self.leftLabel = label1;
    
    self.primedRate = [[UILabel alloc] initWithFrame:CGRectZero];
    self.primedRate.textColor = RGB(230, 128, 40);
    self.primedRate.textAlignment = NSTextAlignmentCenter;
    self.primedRate.font = [UIFont systemFontOfSize:15.0];
    [self.wrapper addSubview:self.primedRate];
    self.primedRate.text = @"-";
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectZero];
    label2.textColor = [ColorHelper getWhiteColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:14.0];
    label2.text = @"余额";
    [self.wrapper addSubview:label2];
    self.minddleLabel = label2;
    
    self.balance = [[UILabel alloc] initWithFrame:CGRectZero];
    self.balance.textColor = RGB(230, 128, 40);
    self.balance.textAlignment = NSTextAlignmentCenter;
    self.balance.font = [UIFont systemFontOfSize:15.0];
    [self.wrapper addSubview:self.balance];
    self.balance.text = @"-";
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectZero];
    label3.textColor = [ColorHelper getWhiteColor];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font = [UIFont systemFontOfSize:14.0];
    label3.text = @"积分";
    [self.wrapper addSubview:label3];
    self.rightLabel = label3;
    
    self.intergral = [[UILabel alloc] initWithFrame:CGRectZero];
    self.intergral.textColor = RGB(230, 128, 40);
    self.intergral.textAlignment = NSTextAlignmentCenter;
    self.intergral.font = [UIFont systemFontOfSize:15.0];
    [self.wrapper addSubview:self.intergral];
    self.intergral.text = @"-";
    
    [self.wrapper mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@50);
    }];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wrapper.mas_left);
        make.top.equalTo(self.wrapper.mas_top);
        make.width.equalTo(self.wrapper.mas_width).multipliedBy(1.0/3);
        make.height.equalTo(self.wrapper.mas_height).multipliedBy(0.5);
    }];
    
    [self.primedRate mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(label1.mas_bottom);
        make.left.equalTo(self.wrapper.mas_left);
        make.width.equalTo(self.wrapper.mas_width).multipliedBy(1.0/3);
        make.bottom.equalTo(self.wrapper.mas_bottom);
    }];

    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(label1.mas_right);
        make.top.equalTo(self.wrapper.mas_top);
        make.width.equalTo(self.wrapper.mas_width).multipliedBy(1.0/3);
        make.height.equalTo(self.wrapper.mas_height).multipliedBy(0.5);
    }];

    [self.balance mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(label1.mas_bottom);
        make.left.equalTo(self.primedRate.mas_right);
        make.width.equalTo(self.wrapper.mas_width).multipliedBy(1.0/3);;
        make.bottom.equalTo(self.wrapper.mas_bottom);
    }];
    
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2.mas_right);
        make.top.equalTo(self.wrapper.mas_top);
        make.width.equalTo(self.wrapper.mas_width).multipliedBy(1.0/3);
        make.height.equalTo(self.wrapper.mas_height).multipliedBy(0.5);
    }];

    [self.intergral mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(label1.mas_bottom);
        make.left.equalTo(self.balance.mas_right);
        make.right.equalTo(self.wrapper.mas_right);
        make.bottom.equalTo(self.wrapper.mas_bottom);
    }];
    
    self.maskView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.wrapper addSubview:self.maskView];
    self.maskView.image = [UIImage imageNamed:@"ico_card_wrap"];
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.wrapper).insets(UIEdgeInsetsMake(0, 5, 0, 5));
    }];
}

// 会员卡类型界面设置会员卡背景时的图片选择页面，数据填充
- (void)fillCardBackgroundImageVo:(NSString *)imagePath cardInfo:(NSDictionary *)cardInfo {
    
    self.wrapper.hidden = YES;
    int r = 200 , g = 200 , b = 200;
    NSString *colorString = cardInfo[@"fontColor"];
    if ([NSString isNotBlank:colorString]) {
        
        NSArray *colors = [colorString componentsSeparatedByString:@","];
        if (colors.count > 3) {
            r = [colors[1] intValue];
            g = [colors[2] intValue];
            b = [colors[3] intValue];
        }
    }
    UIColor *fontColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    self.cardNum.textColor = fontColor;
    self.cardNum.text = cardInfo[@"cardNum"];
    self.cardTypeName.textColor = fontColor;
    self.cardTypeName.text = cardInfo[@"cardType"];
    self.shopName.textColor = fontColor;
    self.shopName.text = cardInfo[@"shop"];
    self.leftLabel.textColor = fontColor;
    self.minddleLabel.textColor = fontColor;
    self.rightLabel.textColor = fontColor;
    [self.bgImagView ls_setImageWithPath:imagePath placeholderImage:[UIImage imageNamed:kDefaultCardBackgroundImageName]];
    // 隐藏发卡门店，产品调整
    self.shopName.hidden = YES;
}

- (void)fillMemberCardVo:(LSMemberCardVo *)cardVo type:(NSInteger)type {
    
    if (cardVo) {
        // 处理字体颜色
        NSString *textColorStyle = nil;
        if ([NSString isNotBlank:cardVo.cardTypeVo.style]) {
            textColorStyle = [[cardVo.cardTypeVo.style componentsSeparatedByString:@"|"] firstObject];
            if (textColorStyle) {
                int r = 200 , g = 200 , b = 200;
                if ([NSString isNotBlank:textColorStyle]) {
                    
                    NSArray *colors = [textColorStyle componentsSeparatedByString:@","];
                    if (colors.count > 3) {
                        r = [colors[1] intValue];
                        g = [colors[2] intValue];
                        b = [colors[3] intValue];
                    }
                }
                UIColor *fontColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
                self.cardNum.textColor = fontColor;
                self.cardTypeName.textColor = fontColor;
                self.shopName.textColor = fontColor;
                self.leftLabel.textColor = fontColor;
                self.minddleLabel.textColor = fontColor;
                self.rightLabel.textColor = fontColor;
            }
        }
        
        // type == 0 ，也就是type == MBAccessCardsInfoDetailPage ,只有会员详情页面才会判断卡的删除状态
        if (cardVo.isDeleted.boolValue && type == 0) {
            self.reSendButton.hidden = NO;
            self.cardNum.hidden = YES;
            self.cardTypeName.hidden = YES;
            self.statusLabel.hidden = NO;
            self.statusLabel.text = [NSString stringWithFormat:@"会员已删除此%@" ,cardVo.kindCardName];
        }
        else if ([cardVo isLost]) {
            self.lossHandleImageView.hidden = NO;
        }
        
        
        self.cardNum.text = cardVo.code;
        self.shopName.text = [[Platform Instance] getkey:SHOP_NAME];
        self.cardTypeName.text = cardVo.kindCardName;
        if (cardVo.cardTypeVo.mode == CardPrimeDiscount && cardVo.cardTypeVo.ratio) {
            self.primedRate.text = [NSString stringWithFormat:@"%@折" ,[cardVo.cardTypeVo.ratio productStringWithNumber:@(0.1)]];
        }
        else {
            self.primedRate.text = [cardVo.cardTypeVo getModeStringShowRatio];
        }
        
        if ([ObjectUtil isNotNull:cardVo.degree]) {
            self.intergral.text = [NSString stringWithFormat:@"%@" ,[cardVo.degree stringFromNumberWithDecimalDigits:2]];
        }
        
        if ([ObjectUtil isNotNull:cardVo.balance]) {
            self.balance.text =  [NSString stringWithFormat:@"%@",[cardVo.balance currencyStringWithSymbol:@"￥"]];
        }
        
        // cardTypeVo.attachmentId
        [self.bgImagView ls_setImageWithPath:cardVo.filePath
                                 placeholderImage:[UIImage imageNamed:kDefaultCardBackgroundImageName]];
        
    }
    else if (type == 0) {  // type == 0 ，也就是type == MBAccessCardsInfoDetailPage
        // 未领卡情况
        self.cardNum.hidden = YES;
        self.primedRate.text = @"无折扣";
        [self.reSendButton setTitle:@"发卡" forState:0];
        self.reSendButton.hidden = NO;
    }
    self.shopName.hidden = YES;
}

- (void)reSendCard:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kReSendDeletedCardNotificationKey object:self];
}

@end
