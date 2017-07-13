//
//  LSMarkAddView.m
//  retailapp
//
//  Created by guozhi on 2016/10/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMarkAddView.h"
@interface LSMarkAddView ()
/** 添加图片 */
@property (nonatomic, strong) UIImageView *imgViewAdd;
/** 按钮相应点击事件 */
@property (nonatomic, strong) UIButton *btn;
/** 添加文字表述 */
@property (nonatomic, strong) UILabel *lblText;
/** 添加按钮回调 */
@property (nonatomic, copy) AddBlock addBlock;
@end

@implementation LSMarkAddView

+ (instancetype)markAddView {
    LSMarkAddView *markAddView =  [[LSMarkAddView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 88)];
    return markAddView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configViews];
        [self configConstraints];
    }
    return self;
}
- (void)setText:(NSString *)text addBlock:(AddBlock)addBlock {
    self.lblText.text = text;
    self.addBlock = addBlock;
}

- (void)configViews {
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //添加按钮
    self.imgViewAdd = [[UIImageView alloc] init];
    self.imgViewAdd.image = [UIImage imageNamed:@"ico_add_rr"];
    [self addSubview:self.imgViewAdd];
    //添加文字描述
    self.lblText = [[UILabel alloc] init];
    self.lblText.textColor = [ColorHelper getRedColor];
    self.lblText.textAlignment = NSTextAlignmentCenter;
    self.lblText.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.lblText];
    //添加按钮
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btn];
    
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    [self.imgViewAdd makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(20, 20));
        make.centerY.equalTo(wself);
        make.right.equalTo(wself.lblText.left).offset(-10);
    }];

    [self.lblText makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wself);
        make.centerX.equalTo(wself.centerX).offset(15);
    }];
    [self.btn makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(wself);
    }];
    
}

- (void)btnClick:(UIButton *)btn {
    if (self.addBlock) {
        self.addBlock();
    }
}


@end
