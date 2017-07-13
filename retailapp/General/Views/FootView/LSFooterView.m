//
//  LSFooterView.m
//  retailapp
//
//  Created by guozhi on 16/7/14.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSFooterView.h"
#define BTN_W 55
#define TAG_EXPORT 0
#define TAG_ADD 1
#define TAG_SORT 2
#define TAG_SCAN 3
#define TAG_BATCH 4
#define TAG_SELECT_ALL 5
#define TAG_SELECT_NO 6
#define TAG_ONE_CLICK 7
#define TAG_MANUAL 8
#define TAG_COLOR 9
#define TAG_SIZE 10
@interface LSFooterView()
@property (nonatomic, weak) id<LSFooterViewDelegate>delegate;

//手动生成是需要的空间
/** 灰色背景 */
@property (nonatomic, strong) UIImageView *imgViewManual;
/** 提示文字 */
@property (nonatomic, strong) UILabel *lblManual;
/** 手动生成按钮 */
@property (nonatomic, strong) UIButton *btnManual;
@end
@implementation LSFooterView

+ (instancetype)footerView{
    CGFloat footViewW = [UIScreen mainScreen].bounds.size.width;
    CGFloat footViewH = 60;
    CGFloat footViewX = 0;
    CGFloat footViewY = [UIScreen mainScreen].bounds.size.height-footViewH;
    LSFooterView *footerView = [[LSFooterView alloc] initWithFrame:CGRectMake(footViewX, footViewY, footViewW, footViewH)];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (void)initDelegate:(id<LSFooterViewDelegate>)delegate btnsArray:(NSArray *)arr {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.delegate = delegate;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat left = self.frame.size.width - (arr.count - idx)*(BTN_W + 10);
        if ([obj isEqualToString:kFootExport]) {
            [self addBtnWithImgPath:@"ico_export" left:left tag:TAG_EXPORT];
        } else if ([obj  isEqualToString:kFootAdd]) {
            [self addBtnWithImgPath:@"ico_add" left:left tag:TAG_ADD];
        } else if ([obj isEqualToString:kFootSort]) {
            [self addBtnWithImgPath:@"ico_sort" left:left tag:TAG_SORT];
        } else if ([obj isEqualToString:kFootScan]) {
            [self addBtnWithImgPath:@"ico_nav_scan" left:left tag:TAG_SCAN];
        } else if ([obj isEqualToString:kFootBatch]) {
            [self addBtnWithImgPath:@"ico_nav_batch" left:left tag:TAG_BATCH];
        } else if ([obj isEqualToString:kFootSelectAll]) {
            [self addBtnWithImgPath:@"ico_select_all" left:left tag:TAG_SELECT_ALL];
        } else if ([obj isEqualToString:kFootSelectNo]) {
            [self addBtnWithImgPath:@"ico_select_no" left:left tag:TAG_SELECT_NO];
        } else if ([obj isEqualToString:kFootOneClick]) {
            [self addBtnWithImgPath:@"ico_one_click" left:left tag:TAG_ONE_CLICK];
        } else if ([obj isEqualToString:kFootSize]) {
            [self addBtnWithImgPath:@"foot_size" left:left tag:TAG_SIZE];
        } else if ([obj isEqualToString:kFootColor]) {
            [self addBtnWithImgPath:@"foot_color" left:left tag:TAG_COLOR];
        } else if ([obj isEqualToString:kFootManual]) {//手动生成
            [self addBtnWithImgPath:@"unauto" left:left tag:TAG_MANUAL];
        }
    }];
}

- (void)updateButtons:(NSArray *)arr {
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat left = self.frame.size.width - (arr.count - idx)*(BTN_W + 10);
        if ([obj isEqualToString:kFootExport]) {
            [self addBtnWithImgPath:@"ico_export" left:left tag:TAG_EXPORT];
        } else if ([obj  isEqualToString:kFootAdd]) {
            [self addBtnWithImgPath:@"ico_add" left:left tag:TAG_ADD];
        } else if ([obj isEqualToString:kFootSort]) {
            [self addBtnWithImgPath:@"ico_sort" left:left tag:TAG_SORT];
        } else if ([obj isEqualToString:kFootScan]) {
            [self addBtnWithImgPath:@"ico_nav_scan" left:left tag:TAG_SCAN];
        } else if ([obj isEqualToString:kFootBatch]) {
            [self addBtnWithImgPath:@"ico_nav_batch" left:left tag:TAG_BATCH];
        } else if ([obj isEqualToString:kFootSelectAll]) {
            [self addBtnWithImgPath:@"ico_select_all" left:left tag:TAG_SELECT_ALL];
        } else if ([obj isEqualToString:kFootSelectNo]) {
            [self addBtnWithImgPath:@"ico_select_no" left:left tag:TAG_SELECT_NO];
        } else if ([obj isEqualToString:kFootOneClick]) {
            [self addBtnWithImgPath:@"ico_one_click" left:left tag:TAG_ONE_CLICK];
        } else if ([obj isEqualToString:kFootColor]) {
            [self addBtnWithImgPath:@"ico_select_no" left:left tag:TAG_COLOR];
        } else if ([obj isEqualToString:kFootSize]) {
            [self addBtnWithImgPath:@"ico_one_click" left:left tag:TAG_SIZE];
        } else if ([obj isEqualToString:kFootManual]) {//手动生成
            [self addBtnWithImgPath:@"unauto" left:left tag:TAG_MANUAL];
        }
    }];
}

- (void)addBtnWithImgPath:(NSString *)path left:(CGFloat)left tag:(NSInteger)tag{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btnY = (self.frame.size.height - BTN_W)/2;
    btn.frame = CGRectMake(left, btnY, BTN_W, BTN_W);
    btn.tag = tag;
    [btn setImage:[UIImage imageNamed:path] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    if (tag == TAG_MANUAL) {//手动生成灰色背景
        self.btnManual = btn;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:btn.frame];
        imageView.image = [UIImage imageNamed:@"ico_shoudongshengcheng"];
        [self addSubview:imageView];
        self.imgViewManual = imageView;//手动生成文字
        self.imgViewManual.hidden = YES;
        UILabel *lblManual = [[UILabel alloc] initWithFrame:imageView.frame];
        lblManual.font = [UIFont systemFontOfSize:11];
        lblManual.numberOfLines = 0;
        lblManual.textAlignment = NSTextAlignmentCenter;
        lblManual.textColor = [UIColor whiteColor];
        [self addSubview:lblManual];
        self.lblManual = lblManual;
    }
}

/**
 是否显示手动生成按钮

 @param isShow YES 显示手动生成按钮 此时按钮是可以点击的 NO 显示灰色背景及时间此时按钮是不可点击的
 @param text   时间
 */
- (void)showManualBtn:(BOOL)isShow text:(NSString *)text {
    self.btnManual.hidden = !isShow;
    self.imgViewManual.hidden = isShow;
    self.lblManual.hidden = isShow;
    self.lblManual.text = text;
}

- (void)btnClick:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(footViewdidClickAtFooterType:)]) {
        if (btn.tag == TAG_EXPORT) {
            [self.delegate footViewdidClickAtFooterType:kFootExport];
        } else if (btn.tag == TAG_ADD) {
            [self.delegate footViewdidClickAtFooterType:kFootAdd];
        } else if (btn.tag == TAG_SORT) {
            [self.delegate footViewdidClickAtFooterType:kFootSort];
        } else if (btn.tag == TAG_SCAN) {
            [self.delegate footViewdidClickAtFooterType:kFootScan];
        } else if (btn.tag == TAG_BATCH) {
            [self.delegate footViewdidClickAtFooterType:kFootBatch];
        } else if (btn.tag == TAG_SELECT_ALL) {
            [self.delegate footViewdidClickAtFooterType:kFootSelectAll];
        } else if (btn.tag == TAG_SELECT_NO) {
            [self.delegate footViewdidClickAtFooterType:kFootSelectNo];
        } else if (btn.tag == TAG_ONE_CLICK) {
            [self.delegate footViewdidClickAtFooterType:kFootOneClick];
        } else if (btn.tag == TAG_COLOR) {
            [self.delegate footViewdidClickAtFooterType:kFootColor];
        } else if (btn.tag == TAG_SIZE) {
            [self.delegate footViewdidClickAtFooterType:kFootSize];
        } else if (btn.tag == TAG_MANUAL) {//手动生成
            [self.delegate footViewdidClickAtFooterType:kFootManual];
        }
    }
}
@end
