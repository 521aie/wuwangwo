//
//  LSStockChangeRecordHeaderView.m
//  retailapp
//
//  Created by guozhi on 2017/2/13.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSStockChangeRecordHeaderView.h"

@interface LSStockChangeRecordHeaderView ()
/** 商品图片 */
@property (nonatomic, strong) UIImageView *imgView;
/** 商品名字 */
@property (nonatomic, strong) UILabel *lblName;
/** 条形码 */
@property (nonatomic, strong) UILabel *lblCode;
/** 时间 */
@property (nonatomic, strong) UILabel *lblTime;
/** 分割线 */
@property (nonatomic, strong) UIView *viewLine;
/** 白色背景 */
@property (nonatomic, strong) UIView *viewBg;
@end

@implementation LSStockChangeRecordHeaderView

+ (instancetype)stockChangeRecordHeaderView {
    LSStockChangeRecordHeaderView *view = [[LSStockChangeRecordHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 88)];
    [view configViews];
    [view configConstraints];
    return view;
}

- (void)configViews {
    self.backgroundColor = [UIColor clearColor];
    //白色背景
    self.viewBg = [[UIView alloc] init];
    self.viewBg.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.viewBg];
    //商品图片
    self.imgView = [[UIImageView alloc] init];
    self.imgView.layer.cornerRadius = 4;
    self.imgView.layer.masksToBounds = YES;
    [self addSubview:self.imgView];
    //商品名字
    self.lblName = [[UILabel alloc] init];
    self.lblName.font = [UIFont systemFontOfSize:15];
    self.lblName.textColor = [ColorHelper getTipColor3];
    self.lblName.numberOfLines = 0;
    [self addSubview:self.lblName];
    //款号
    self.lblCode = [[UILabel alloc] init];
    self.lblCode.font = [UIFont systemFontOfSize:13];
    self.lblCode.textColor = [ColorHelper getTipColor6];
    [self addSubview:self.lblCode];
    
    //时间
    self.lblTime = [[UILabel alloc] init];
    self.lblTime.font = [UIFont systemFontOfSize:13];
    self.lblTime.textColor = [ColorHelper getTipColor6];
    [self addSubview:self.lblTime];
    
    //分割线
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self addSubview:self.viewLine];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    //商品图片
    CGFloat margin = 10;
    [self.imgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(wself).offset(margin);
        make.size.equalTo(68);
        
    }];
    //商品名字
    [self.lblName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.imgView.right).offset(margin);
        make.top.equalTo(wself.imgView.top).offset(5);
        make.right.equalTo(wself.right).offset(-margin);
    }];
    
    
    //款号
    [self.lblCode makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblName.left);
        make.top.equalTo(wself.lblName.bottom).offset(5);
        make.right.equalTo(wself.right).offset(-margin);
    }];
    
    //时间
    [self.lblTime makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.lblName.left);
        make.top.equalTo(wself.lblCode.bottom).offset(5);
        make.right.equalTo(wself.right).offset(-margin);
    }];
    //白色背景
    [self.viewBg makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(wself);
        make.bottom.equalTo(wself.viewLine.top);
    }];
    
    //分割线
    [self.viewLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself);
        make.right.equalTo(wself);
        make.bottom.equalTo(wself.lblTime.bottom).offset(10);
        make.height.equalTo(1);
    }];
    
}


- (void)setName:(NSString *)name code:(NSString *)code colorAndsSize:(NSString *)colorAndsSize time:(NSString *)time filePath:(NSString *)filePath {
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:filePath] placeholderImage:[UIImage imageNamed:@"img_default"]];
    //商品/款式 名称
    self.lblName.text = name;
    //条形码/款号 服鞋在款号后面显示尺码
    if ([[[Platform Instance] getkey:SHOP_MODE] intValue] == 101) {
        self.lblCode.text = [NSString stringWithFormat:@"%@  %@", code, colorAndsSize];
    } else {
        self.lblCode.text = code;
    }
    //时间
    self.lblTime.text = [NSString stringWithFormat:@"时间：%@", time];
    [self layoutIfNeeded];
    CGFloat height = MAX(88, self.viewLine.ls_bottom);
    self.ls_height = height + 10;
    
    
}

@end
