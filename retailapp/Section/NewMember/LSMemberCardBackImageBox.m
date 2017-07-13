//
//  LSMemberCardBackImageBox.m
//  retailapp
//
//  Created by taihangju on 16/9/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberCardBackImageBox.h"
#import "Masonry.h"
#import "ColorHelper.h"
#import "UIImageView+SDAdd.h"

@interface LSMemberCardBackImageBox()


@property (nonatomic ,strong) UIImageView *addImageView;/* <添加图标*/
@property (nonatomic ,strong) NSString *rawPath;/*<初始化时的IamgePath>*/
@property (nonatomic ,strong) NSString *nowPath;/*<新的ImagePath>*/
@end
@implementation LSMemberCardBackImageBox

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textLabel.font = [UIFont systemFontOfSize:15.0];
        self.textLabel.textColor = [ColorHelper getTipColor3];
        [self addSubview:self.textLabel];
        self.textLabel.text = @"选择卡片背景";
        
        UIView *wrapper = [[UIView alloc] initWithFrame:CGRectZero];
        wrapper.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        [self addSubview:wrapper];
        
        UIImageView *addImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        addImageView.image = [UIImage imageNamed:@"add_little"];
        wrapper.layer.cornerRadius = 6.0;
        wrapper.layer.masksToBounds = YES;
        [wrapper addSubview:addImageView];
        self.addImageView = addImageView;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14.0];
        label.textColor = [ColorHelper getTipColor9];
        label.text = @"选择图片";
        [wrapper addSubview:label];
        self.noticeLabel = label;
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [wrapper addSubview:self.imageView];
        
        
        self.shopName = [[UILabel alloc] initWithFrame:CGRectZero];
//        self.shopName.textColor = [ColorHelper getWhiteColor];
        self.shopName.font = [UIFont systemFontOfSize:15.0];
        [wrapper addSubview:self.shopName];
        self.shopName.hidden = YES;
        
        self.cardNumber = [[UILabel alloc] initWithFrame:CGRectZero];
//        self.cardNumber.textColor = [ColorHelper getWhiteColor];
        self.cardNumber.alpha = 0.5;
        self.cardNumber.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
        self.cardNumber.textAlignment = NSTextAlignmentCenter;
        self.cardNumber.hidden = YES;
        [wrapper addSubview:self.cardNumber];
        self.cardNumber.text = @"NO.00000000000";
        
        self.cardTypeName = [[UILabel alloc] initWithFrame:CGRectZero];
//        self.cardTypeName.textColor = [ColorHelper getWhiteColor];
        self.cardTypeName.font = [UIFont systemFontOfSize:30.0];
        self.cardTypeName.textAlignment = NSTextAlignmentCenter;
        [wrapper addSubview:self.cardTypeName];

        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(12.0);
            make.top.equalTo(self.mas_top).offset(4.0);
            make.height.equalTo(@(20.0));
        }];
        
        // 宽高比要求3：2
        [wrapper mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(32.0, 11.0, 4.0, 11.0));
        }];
        
        [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.equalTo(@35);
            make.width.equalTo(@35);
            make.centerX.equalTo(wrapper.mas_centerX);
            make.centerY.equalTo(wrapper.mas_centerY).offset(-15);
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(addImageView.mas_bottom).offset(10);
            make.left.equalTo(wrapper.mas_leftMargin);
            make.right.equalTo(wrapper.mas_rightMargin);
            make.height.equalTo(@20);
        }];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(wrapper).insets(UIEdgeInsetsZero);
        }];
        
        [self.shopName mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(wrapper.mas_leftMargin);
            make.top.equalTo(wrapper.mas_topMargin);
        }];
        
        [self.cardTypeName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(wrapper.mas_centerY);
            make.left.equalTo(wrapper.mas_leftMargin);
            make.right.equalTo(wrapper.mas_rightMargin);
        }];
        
        [self.cardNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(wrapper.mas_centerX);
            make.top.equalTo(self.cardTypeName.mas_bottom);
            make.left.equalTo(wrapper.mas_leftMargin);
            make.right.equalTo(wrapper.mas_rightMargin);
        }];
    }
    return self;
}

- (void)initTarget:(id)target method:(SEL)selector {
    
    [self addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if ([self pointInside:point withEvent:event]) {
        return self;
    }
    return nil;
}


- (void)initFontColor:(NSString *)colorString imagePath:(NSString *)path {
    
    int r = 200 , g = 200 , b = 200;
    if ([NSString isNotBlank:colorString]) {
        
        NSArray *colors = [colorString componentsSeparatedByString:@","];
        if (colors.count > 3) {
            r = [colors[1] intValue];
            g = [colors[2] intValue];
            b = [colors[3] intValue];
        }
    }
    UIColor *fontColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    self.shopName.textColor = fontColor;
    self.cardNumber.hidden = NO;
    self.cardNumber.textColor = fontColor;
    self.cardTypeName.textColor = fontColor;
    self.rawPath = path;
    self.nowPath = path;
    if ([path hasPrefix:@"http"]) {
        [self.imageView ls_setImageWithPath:path placeholderImage:nil];
    }
    
}

- (void)changeFontColor:(NSString *)colorString {
    int r = 200 , g = 200 , b = 200;
    if ([NSString isNotBlank:colorString]) {
        
        NSArray *colors = [colorString componentsSeparatedByString:@","];
        if (colors.count > 3) {
            r = [colors[1] intValue];
            g = [colors[2] intValue];
            b = [colors[3] intValue];
        }
    }
    UIColor *fontColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    self.shopName.textColor = fontColor;
    self.cardNumber.textColor = fontColor;
    self.cardTypeName.textColor = fontColor;
}

- (void)changeFontColor:(NSString *)colorString imagePath:(NSString *)path {
    
    int r = 200 , g = 200 , b = 200;
    if ([NSString isNotBlank:colorString]) {
        
        NSArray *colors = [colorString componentsSeparatedByString:@","];
        if (colors.count > 3) {
            r = [colors[1] intValue];
            g = [colors[2] intValue];
            b = [colors[3] intValue];
        }
    }
    UIColor *fontColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    self.shopName.textColor = fontColor;
    self.cardNumber.textColor = fontColor;
    self.cardTypeName.textColor = fontColor;
    self.nowPath = path;
    if ([path hasPrefix:@"http"]) {
         [self.imageView ls_setImageWithPath:path placeholderImage:nil];
    }
    self.noticeLabel.hidden = YES;
}

- (void)set:(NSString *)shopName cardTypeName:(NSString *)cardName cardNum:(NSString *)number {
    
    self.cardNumber.hidden = NO;
    self.addImageView.hidden = YES;
    self.noticeLabel.hidden = YES;
    self.shopName.text = [NSString isNotBlank:shopName] ? shopName : @"苏木的店";
    self.cardTypeName.text = [NSString isNotBlank:cardName] ? cardName : @"普通会员卡";
    self.cardNumber.text = [NSString isNotBlank:number] ? number : @"NO.00000000000";
}

- (BOOL)baseChangeStatus {
    
    if (!self.rawPath && !self.nowPath) {
        return NO;
    }
    else if ([NSString isNotBlank:self.nowPath]) {
        return ![self.nowPath isEqualToString:self.rawPath];
    }
    return NO;
}

@end
