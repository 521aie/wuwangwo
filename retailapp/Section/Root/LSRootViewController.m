//
//  LSRootViewController.m
//  retailapp
//
//  Created by guozhi on 2017/2/22.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "LSNavigationBar.h"
#import "XHAnimalUtil.h"
@interface LSRootViewController ()<LSNavigationBarDelegate>
/** 自定义导航栏 */
@property (nonatomic, strong) LSNavigationBar *navigationBar;
/** 点击取消按钮是否提示未保存 */
@property (nonatomic, assign) BOOL showAlert;
@end

@implementation LSRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - 导航栏事件

- (void)configNavigationBar {
    self.navigationBar = [LSNavigationBar navigationBar];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
}
- (void)configTitle:(NSString *)title {
    [self.navigationBar configTitle:title];
}

- (void)configTitle:(NSString *)title leftPath:(NSString *)leftPath rightPath:(NSString *)rightPath {
    [self.navigationBar configTitle:title leftPath:leftPath rightPath:rightPath];
}
- (void)configNavigationBar:(LSNavigationBarButtonDirect)direct title:(NSString *)title filePath:(NSString *)filePath {
    [self.navigationBar configNavigationBar:direct title:title filePath:filePath];
}

- (void)editTitle:(BOOL)change act:(NSInteger)action {
    self.showAlert = change;
    [self.navigationBar editTitle:change act:action];
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)direct {
    if (direct == LSNavigationBarButtonDirectLeft) {
        [self popViewController];
    }
}
#pragma mark - <LSNavigationBarDelegate>
- (void)navigationBar:(LSNavigationBar *)navigationBar didEndClickedDirect:(LSNavigationBarButtonDirect)direct {
    if (direct == LSNavigationBarButtonDirectLeft && self.showAlert) {
        __weak typeof(self) wself = self;
        [LSAlertHelper showAlert:@"内容有变更尚未保存,确认要退出吗?" block:nil block:^{
            [wself onNavigateEvent:direct];
        }];
        return;
    }
    [self onNavigateEvent:direct];
    
}




@end
