//
//  LSNavigationBar.m
//  retailapp
//
//  Created by guozhi on 2017/3/11.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSNavigationBar.h"
#import "LSNavBtn.h"
@interface LSNavigationBar()
/** 左边按钮 */
@property (nonatomic, strong) LSNavBtn *leftBtn;
/** 右边按钮 */
@property (nonatomic, strong) LSNavBtn *rightBtn;
/** 标题 */
@property (nonatomic, strong) UILabel *lblTitle;
@end
@implementation LSNavigationBar

+ (instancetype)navigationBar {
    LSNavigationBar *navBar = [[LSNavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, kNavH)];
    navBar.backgroundColor = [UIColor colorWithRed:204/256.0 green:0.00 blue:0.00 alpha:0.9];
    [navBar configViews];
    return navBar;
}


- (void)configViews {
    __weak typeof(self) wself = self;
    //左边按钮默认不显示
    self.leftBtn = [LSNavBtn navBtn:LSNavBtnDirectLeft];
    [self addSubview:self.leftBtn];
    [self.leftBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(wself);
        make.size.equalTo(CGSizeMake(60, 44));
    }];
    //标题默认显示
    self.lblTitle = [[UILabel alloc] init];
    self.lblTitle.font = [UIFont boldSystemFontOfSize:20];
    self.lblTitle.textColor = [UIColor whiteColor];
    self.lblTitle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.lblTitle];
    [self.lblTitle makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wself.leftBtn);
        make.centerX.equalTo(wself);
        make.left.equalTo(wself.left).offset(60);
    }];
    
    //右边按钮默认不显示
    self.rightBtn = [LSNavBtn navBtn:LSNavBtnDirectRight];
    [self addSubview:self.rightBtn];
    [self.rightBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(wself);
        make.height.equalTo(44);
        make.size.equalTo(CGSizeMake(60, 44));
    }];
}

/**
 设置标题

 @param title 比如设置@"123" 则导航栏显示的是@“123”
 */
- (void)configTitle:(NSString *)title {
      self.lblTitle.text = title;
}

/**
 设置导航栏及左右按钮的显示

 @param title 标题 比如设置@"123" 则导航栏显示的是@“123”
 @param leftPath 左边按钮 只能传定义的宏以后需要优化 
                返回按钮 Head_ICON_BACK
                取消按钮 Head_ICON_CANCEL
 @param rightPath 右边按钮 只能传定义的宏以后需要优化 
                  保存按钮 Head_ICON_OK
                  取消按钮 Head_ICON_CANCEL
 */
- (void)configTitle:(NSString *)title leftPath:(NSString *)leftPath rightPath:(NSString *)rightPath {
    title = [NSString isBlank:title] ? @"" : title;;
    //设置标题
    self.lblTitle.text = title;
    if ([leftPath isEqualToString:Head_ICON_BACK]) {//返回按钮
        [self configNavigationBar:LSNavigationBarButtonDirectLeft title:@"返回" filePath:Head_ICON_BACK];
    } else if ([leftPath isEqualToString:Head_ICON_CANCEL]) {//取消按钮
        [self configNavigationBar:LSNavigationBarButtonDirectLeft title:@"取消" filePath:Head_ICON_CANCEL];
    }
    
    if ([rightPath isEqualToString:Head_ICON_OK]) {//保存按钮
        [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"保存" filePath:Head_ICON_OK];
    } else if ([rightPath isEqualToString:Head_ICON_CATE]) {//分类
        [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"分类" filePath:Head_ICON_CATE];
    } else if ([rightPath isEqualToString:Head_ICON_CONFIRM]) {//确认
        [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"确认" filePath:Head_ICON_CONFIRM];
    } else if (rightPath == nil) {
        [self configNavigationBar:LSNavigationBarButtonDirectRight title:nil filePath:nil];
    }

}
/**
 设置导航栏按钮

 @param direct 设置左边按钮还是右边按钮
 @param title 设置标题
 @param filePath 设置按钮的图片路径
 */
- (void)configNavigationBar:(LSNavigationBarButtonDirect)direct title:(NSString *)title filePath:(NSString *)filePath {
    LSNavBtn *btn = direct == LSNavigationBarButtonDirectLeft ? self.leftBtn : self.rightBtn;
    [btn setTitle:title forState:UIControlStateNormal];
    if ([NSString isNotBlank:filePath]) {
        [btn setImage:[UIImage imageNamed:filePath] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:filePath] forState:UIControlStateHighlighted];
    }
    btn.tag = direct;
    [btn addTarget:self action:@selector(navBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.hidden = title == nil && filePath == nil;
}

- (void)navBtnClick:(LSNavBtn *)btn {
    [SystemUtil hideKeyboard];
    if ([self.delegate respondsToSelector:@selector(navigationBar:didEndClickedDirect:)]) {
        if (btn.direct == LSNavBtnDirectLeft) {//点击了左边按钮
            [self.delegate navigationBar:self didEndClickedDirect:LSNavigationBarButtonDirectLeft];
        } else if (btn.direct == LSNavBtnDirectRight) {//点击了右边按钮
            [self.delegate navigationBar:self didEndClickedDirect:LSNavigationBarButtonDirectRight];
        }
    }
    
}

- (void)editTitle:(BOOL)change act:(NSInteger)action {
    if (action == ACTION_CONSTANTS_ADD || (change && action == ACTION_CONSTANTS_EDIT)) {
        [self configNavigationBar:LSNavigationBarButtonDirectLeft title:@"取消" filePath:Head_ICON_CANCEL];
        [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"保存" filePath:Head_ICON_OK];
    } else {
        [self configNavigationBar:LSNavigationBarButtonDirectLeft title:@"返回" filePath:Head_ICON_BACK];
        [self configNavigationBar:LSNavigationBarButtonDirectRight title:nil filePath:nil];
    }
}


@end
