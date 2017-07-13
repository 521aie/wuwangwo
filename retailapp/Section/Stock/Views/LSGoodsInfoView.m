//
//  LSGoodsInfoView.m
//  retailapp
//
//  Created by guozhi on 2017/2/10.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSGoodsInfoView.h"

@interface LSGoodsInfoView()
/** 商品图片 */
@property (nonatomic, strong) UIImageView *imgViewGoods;
/** 商品名字 */
@property (nonatomic, strong) UILabel *lblGoodsName;
/** 条形码 */
@property (nonatomic, strong) UILabel *lblGoodsCode;
/** 零售价 */
@property (nonatomic, strong) UILabel *lblPrice;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;

@end

@implementation LSGoodsInfoView
+ (instancetype)goodsInfoView {
    LSGoodsInfoView *view = [[LSGoodsInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 88)];
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
    
    //零售价
    self.lblPrice = [[UILabel alloc] init];
    self.lblPrice.font = [UIFont systemFontOfSize:13];
    self.lblPrice.textColor = [ColorHelper getTipColor6];
    [self addSubview:self.lblPrice];
    
    //分割线
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self addSubview:self.viewLine];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    //商品图片
    CGFloat margin = 10;
    [self.imgViewGoods makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(wself).offset(margin);
        make.size.equalTo(68);
      
    }];
    //商品名字
    [self.lblGoodsName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.imgViewGoods.right).offset(margin);
        make.top.equalTo(wself.imgViewGoods.top).offset(0);
        make.right.equalTo(wself.right).offset(-margin);
    }];
    
    
    //款号
    [self.lblGoodsCode makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblGoodsName.left);
        make.top.equalTo(wself.lblGoodsName.bottom).offset(5);
        make.right.equalTo(wself.right).offset(-margin);
    }];
    
    //零售价
    [self.lblPrice makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblGoodsName.left);
        make.top.equalTo(wself.lblGoodsCode.bottom).offset(5);
        make.right.equalTo(wself.right).offset(-margin);
    }];
    
    //分割线
    [self.viewLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself).offset(10);
        make.right.equalTo(wself).offset(-10);
        make.bottom.equalTo(wself);
        make.height.equalTo(1);
    }];
    
}

- (void)setGoodsName:(NSString *)name barCode:(NSString *)barCode retailPrice:(double)retailPrice filePath:(NSString *)filePath goodsStatus:(short)goodsStatus type:(short)type {
    [self.imgViewGoods sd_setImageWithURL:[NSURL URLWithString:filePath] placeholderImage:[UIImage imageNamed:@"img_default"]];
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
         self.lblPrice.text = [NSString stringWithFormat:@"吊牌价：¥%.2f", retailPrice];
        self.lblGoodsCode.text = [NSString stringWithFormat:@"款号："];
    } else {
         self.lblPrice.text = [NSString stringWithFormat:@"零售价：¥%.2f", retailPrice];
        self.lblGoodsCode.text = barCode;
    }
   
    
    // 1.创建一个富文本
    NSMutableString *goodsName = [NSMutableString string];
    UIImage *beginImage = nil;
    UIImage *endImage = nil;
    if (goodsStatus == 2) {//商品已下架
        [goodsName appendString:@" "];
        beginImage = [UIImage imageNamed:@"ico_alreadyOffShelf"];
    }
    [goodsName appendString:name];
    //de>商品类型(1.普通商品、2.拆分商品、3.组装商品、4.称重商品、5.原料商品、6:加工商品')</code>
    if (type == 2) {//拆分
        [goodsName appendString:@" "];
        endImage = [UIImage imageNamed:@"status_chaifen"];
    } else if (type == 3) {//组装
        [goodsName appendString:@" "];
        endImage = [UIImage imageNamed:@"status_zhuzhuang"];
    } else if (type == 6) {//加工
        [goodsName appendString:@" "];
        endImage = [UIImage imageNamed:@"status_jiagong"];
    } else if (type == 4) {//称重
        [goodsName appendString:@" "];
        endImage = [UIImage imageNamed:@"status_shancheng"];
    }
    NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:goodsName];
    if (goodsStatus == 2) {
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
    if (type == 2 || type == 3 || type == 6 || type == 4) {
        //添加结束图片
        NSTextAttachment *attchEnd = [[NSTextAttachment alloc] init];
        // 表情图片
        attchEnd.image = endImage;
        attchEnd.bounds = CGRectMake(0, 0, 18, 18);
        // 设置图片大小
        // 创建带有图片的富文本
        NSMutableAttributedString *stringEnd  = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attchEnd]];
        [stringEnd addAttribute:NSBaselineOffsetAttributeName value:@-3 range:NSMakeRange(0, stringEnd.length)];
        [attri appendAttributedString:stringEnd];
        
    }
    
    self.lblGoodsName.attributedText = attri;
    
    [self layoutIfNeeded];
    CGFloat height = MAX(88, self.lblPrice.ls_bottom + 10);
    self.ls_height = height;
}




@end

