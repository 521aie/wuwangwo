//
//  LSStyleInfoView.m
//  retailapp
//
//  Created by guozhi on 2017/2/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSStyleInfoView.h"
@interface LSStyleInfoView()


@end

@implementation LSStyleInfoView
+ (instancetype)styleInfoView {
    LSStyleInfoView *view = [[LSStyleInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 88)];
    [view configViews];
    [view configConstraints];
    return view;
}

- (void)configViews {
    //商品图片
    self.imgViewGoods = [[UIImageView alloc] init];
    self.imgViewGoods.layer.cornerRadius = 4;
    self.imgViewGoods.layer.masksToBounds = YES;
    [self addSubview:self.imgViewGoods];
    //商品名字
    self.lblGoodsName = [[UILabel alloc] init];
    self.lblGoodsName.font = [UIFont systemFontOfSize:15];
    self.lblGoodsName.textColor = [ColorHelper getTipColor3];
    self.lblGoodsName.numberOfLines = 0;
    [self addSubview:self.lblGoodsName];
    //款号
    self.lblGoodsCode = [[UILabel alloc] init];
    self.lblGoodsCode.font = [UIFont systemFontOfSize:13];
    self.lblGoodsCode.textColor = [ColorHelper getTipColor6];
    [self addSubview:self.lblGoodsCode];
    //价格
    self.lblPrice = [[UILabel alloc] init];
    self.lblPrice.font = [UIFont systemFontOfSize:13];
    self.lblPrice.textColor = [ColorHelper getTipColor6];
    [self addSubview:self.lblPrice];

}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    //商品图片
    CGFloat margin = 10;
    [self.imgViewGoods remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself).offset(margin);
        make.size.equalTo(68);
        make.top.equalTo(wself).offset(margin);
    }];
    //商品名字
    [self.lblGoodsName remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.imgViewGoods.right).offset(margin);
        make.top.equalTo(wself.imgViewGoods.top).offset(5);
        make.right.equalTo(wself.right).offset(-margin);
    }];
    if (self.isShowPrice) {
        //款号
        [self.lblGoodsCode remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wself.lblGoodsName.left);
            make.top.equalTo(wself.lblGoodsName.bottom).offset(10);
            make.right.equalTo(wself.right).offset(-margin);
        }];
        //价格
        [self.lblPrice remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wself.lblGoodsName.left);
            make.top.equalTo(wself.lblGoodsCode.bottom).offset(10);
            make.right.equalTo(wself.right).offset(-margin);
        }];
    } else {
        //款号
        [self.lblGoodsCode remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wself.lblGoodsName.left);
            make.top.equalTo(wself.lblGoodsName.bottom).offset(10);
            make.right.equalTo(wself.right).offset(-margin);
        }];
    }
  
}

- (void)setStyleInfo:(NSString *)filePath goodsName:(NSString *)goodsName styleCode:(NSString *)styleCode upDownStatus:(int)updownStatus goodsPrice:(NSString *)goodsPrice showPrice:(BOOL)showPrice {
    self.isShowPrice = showPrice;
    [self configConstraints];
    goodsName = [NSString isBlank:goodsName] ? @"" : goodsName;
    //1上架 2下架
    [self.imgViewGoods sd_setImageWithURL:[NSURL URLWithString:filePath] placeholderImage:[UIImage imageNamed:@"img_default"]];
    self.lblGoodsName.text = goodsName;
    self.lblGoodsCode.text = styleCode;
    
    self.lblPrice.hidden = !showPrice;
    self.lblPrice.text = goodsPrice;
    // 1.创建一个富文本
    NSMutableString *attr = [NSMutableString string];
    UIImage *beginImage = nil;
    if (updownStatus == 2) {//商品已下架
        [attr appendString:@" "];
        beginImage = [UIImage imageNamed:@"ico_alreadyOffShelf"];
    }
    [attr appendString:goodsName];
    NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:goodsName];
    if (updownStatus == 2) {
        // 2.添加开始表情图片
        NSTextAttachment *attchBegin = [[NSTextAttachment alloc] init];
        // 表情图片
        attchBegin.image = beginImage;
        attchBegin.bounds = CGRectMake(0, 0, 40, 15);
        // 设置图片大小
        // 创建带有图片的富文本
        NSMutableAttributedString *stringBegin = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attchBegin]];
        [stringBegin addAttribute:NSBaselineOffsetAttributeName value:@-2 range:NSMakeRange(0, stringBegin.length)];
        
        
        [attri insertAttributedString:stringBegin atIndex:0];// 插入某个位置
    }
    
    
    self.lblGoodsName.attributedText = attri;
    
    [self layoutIfNeeded];
    CGFloat h = MAX(self.imgViewGoods.ls_bottom, self.isShowPrice ? self.lblPrice.ls_bottom : self.lblGoodsCode.ls_bottom) + 10;
    self.ls_height = h;
}

@end
