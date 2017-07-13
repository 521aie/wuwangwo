//
//  LSGoodsSummaryInfoView.m
//  retailapp
//
//  Created by taihangju on 2017/3/2.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSGoodsSummaryInfoView.h"
#import "UIImageView+SDAdd.h"
#import "LSMemberGoodsGiftVo.h"
#import "GoodsGiftListVo.h"
#import "NSNumber+Extension.h"

@interface LSGoodsSummaryInfoView ()

@property (nonatomic, strong) UIImageView *icon;/**<商品图片>*/
@property (nonatomic, strong) UILabel *info;/**<商品相关信息>*/
@property (nonatomic, strong) UIImageView *typeImage;/**<类型标示图标>*/
//@property (nonatomic, weak) MASConstraint *typeImageLeft;/**<typeImage 水平距离icon 的距离>*/
//@property (nonatomic, strong) UILabel *name;/**<商品名称>*/
//@property (nonatomic, strong) UILabel *code;/**<商品编码/条码>*/
//@property (nonatomic, strong) UILabel *attri;/**<商品款式颜色属性>*/
//@property (nonatomic, strong) UILabel *price;/**<零售价>*/
@end

@implementation LSGoodsSummaryInfoView

+ (instancetype)goodsSummaryInfoView {
    
    LSGoodsSummaryInfoView *infoView = [[LSGoodsSummaryInfoView alloc] initWithFrame:CGRectZero];
    return infoView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configSubviews];
    }
    return self;
}

- (void)configSubviews {
    
    _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
    _icon.image = [UIImage imageNamed:@"img_default"];
    [_icon ls_addCornerWithRadii:4 roundRect:CGRectMake(0, 0, 68, 68)];
    [self addSubview:_icon];
    
    _info = [[UILabel alloc] initWithFrame:CGRectZero];
    _info.numberOfLines = 0;
    [self addSubview:_info];

    _typeImage = [[UIImageView alloc] init];
    [self addSubview:_typeImage];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self addSubview:line];
    
//    _code = [[UILabel alloc] initWithFrame:CGRectZero];
//    _code.font = [UIFont systemFontOfSize:13.0];
//    _code.textColor = [ColorHelper getTipColor6];
//    [self addSubview:_code];
//    
//    if ([[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101) {
//        _attri = [[UILabel alloc] initWithFrame:CGRectZero];
//        _attri.font = [UIFont systemFontOfSize:13.0];
//        _attri.textColor = [ColorHelper getTipColor6];
//        [self addSubview:_attri];
//    }
//    
//    _price = [[UILabel alloc] initWithFrame:CGRectZero];
//    _price.font = [UIFont systemFontOfSize:13.0];
//    _price.textColor = [ColorHelper getRedColor];
//    [self addSubview:_price];

    __weak typeof(self) wself = self;
    [wself.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@10);
        make.width.and.height.equalTo(@68);
        make.bottom.lessThanOrEqualTo(wself.mas_bottom).with.offset(-10).with.priorityHigh();
    }];
    
    [wself.info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.icon.mas_right).offset(8);
        make.top.equalTo(wself.icon.mas_top);
        make.right.equalTo(wself.mas_right).offset(-28);
        make.bottom.equalTo(wself.mas_bottom).mas_offset(-10);
    }];
    
    [wself.typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.icon.mas_right).offset(30);
        make.top.equalTo(wself.icon.mas_top);
        make.width.and.height.equalTo(@15);
    }];
    
    CGFloat height = 1/[UIScreen mainScreen].scale;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.mas_left);
        make.right.equalTo(wself.mas_right);
        make.bottom.equalTo(wself.mas_bottom);
        make.height.equalTo(@(height));
    }];
}

- (void)fillGoodsSummaryInfo:(id)vo {
    
    NSString *name = nil;
    NSString *code = nil;
    NSString *attri = @"";
    NSString *price = nil;
    NSInteger goodStatus = 1; // 商品上架状态@1 上架 @2 下架
    NSString *goodTypeIconName = nil; // 商品类型名称
    BOOL isCloth = [[[Platform Instance] getkey:SHOP_MODE] integerValue] == 101;
    if ([vo isKindOfClass:[LSMemberGoodsGiftVo class]]) {
        
        LSMemberGoodsGiftVo *giftVo = (LSMemberGoodsGiftVo *)vo;
        if ([ObjectUtil isNotNull:giftVo.goodsStatus]) {
            goodStatus = giftVo.goodsStatus.integerValue;
        }
        
        name = giftVo.name?:@"";
        if ([NSString isNotBlank:giftVo.goodsColor] || [NSString isNotBlank:giftVo.goodsSize]) {
            attri = [NSString stringWithFormat:@"%@ %@",giftVo.goodsColor?:@"",giftVo.goodsSize?:@""];
        }
        code = isCloth?giftVo.innerCode:giftVo.barCode;
        code = [NSString isNotBlank:code]?code:@"";
        price = [NSString stringWithFormat:@"零售价: ￥%@",[giftVo.price convertToStringWithFormat:@"###,##0.00"]];
        [_icon ls_setImageWithPath:giftVo.picture placeholderImage:[UIImage imageNamed:@"img_default"]];
        goodTypeIconName = [giftVo goodTypeImageString];

    } else if ([vo isKindOfClass:[GoodsGiftListVo class]]) {
     
        GoodsGiftListVo *giftVo = (GoodsGiftListVo *)vo;
        name = giftVo.name?:@"";
        code = isCloth?giftVo.innerCode:giftVo.barCode;
        code = [NSString isNotBlank:code]?code:@"";
        goodStatus = giftVo.goodsStatus.integerValue;
        if ([NSString isNotBlank:giftVo.goodsColor] || [NSString isNotBlank:giftVo.goodsSize]) {
            attri = [NSString stringWithFormat:@"%@ %@",giftVo.goodsColor?:@"",giftVo.goodsSize?:@""];
        }
        price = [NSString stringWithFormat:@"零售价: ￥%@",[giftVo.price convertToStringWithFormat:@"###,##0.00"]];
        [_icon ls_setImageWithPath:giftVo.picture placeholderImage:[UIImage imageNamed:@"img_default"]];
        goodTypeIconName = [giftVo goodTypeImageString];
    }
    
    if ([NSString isNotBlank:goodTypeIconName]) {
        _typeImage.image = [UIImage imageNamed:goodTypeIconName];
    }
    
     NSMutableAttributedString *mutAttri = [[NSMutableAttributedString alloc] init];
     if (goodStatus == 2) {
         // 添加已下架图标
         NSTextAttachment *textAttach = [[NSTextAttachment alloc] init];
         textAttach.image = [UIImage imageNamed:@"ico_alreadyOffShelf"];
         textAttach.bounds = CGRectMake(0, -2, 40, 15);
         NSAttributedString *attri = [NSAttributedString attributedStringWithAttachment:textAttach];
         [mutAttri insertAttributedString:attri atIndex:0];
     }
    
    NSArray *list = @[name,code,attri,price];
    [list enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) {
            
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.paragraphSpacing = 6.0;
            NSAttributedString *attr = [[NSAttributedString alloc] initWithString:name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName:[ColorHelper getBlackColor],NSParagraphStyleAttributeName:style}];
            [mutAttri appendAttributedString:attr];
        } else {
            
            if ([NSString isNotBlank:str]) {
                NSString *string = [NSString stringWithFormat:@"\n%@",str];
                NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                style.lineSpacing = 4.0;
                NSAttributedString *attr = [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0],NSForegroundColorAttributeName:[ColorHelper getTipColor6],NSParagraphStyleAttributeName:style}];
                [mutAttri appendAttributedString:attr];
            }
        }
    }];
    self.info.attributedText = mutAttri;
}
@end
