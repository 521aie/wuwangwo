//
//  LSServerSelectionButton.m
//  retailapp
//
//  Created by guozhi on 2016/11/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSServerSelectionButton.h"


@implementation LSServerSelectionButton

#pragma mark - 添加按钮到哪个页面
+ (void)addSelfToView:(UIView *)view {
    CGFloat btnX = 20;
    CGFloat btnY = 25;
    CGFloat btnW = 80;
    CGFloat btnH = 30;
    LSServerSelectionButton *btn = [LSServerSelectionButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    NSString *name = [[Platform Instance] getkey:SERVER_API_NAME];
    if (name == nil) {
        name = @"测试环境";
    }
    [btn saveServerPath:name];
    [btn setTitle:name forState:UIControlStateNormal];
    [btn setTintColor:[UIColor whiteColor]];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [btn addTarget:btn action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
}

- (void)saveServerPath:(NSString *)name {
    //retailServer
    __block NSString *url = nil;
    NSArray *list = [self serverSelectionList];
    [list enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"name"] isEqualToString:name]) {
            url = obj[@"url"];
        }
    }];
    
    //retailApi
    NSString *urlOut = nil;
    NSString *appSecert = nil;
    if ([name isEqualToString:@"线上环境"]) {
        urlOut = @"https://retailapi.2dfire.com";
        appSecert = @"29dc4dafc8ad495db12fe411e16197b8";
    } else if ([name isEqualToString:@"预发环境"]) {
        urlOut = @"http://retailapi.2dfire-pre.com";
        appSecert = @"29dc4dafc8ad495db12fe411e16197b8";
    } else {
        urlOut = API_OUT_ROOT;
        appSecert = @"817dff1ce96b49918708401205e78a14";
    }
    [[Platform Instance] saveKeyWithVal:SERVER_API_NAME withVal:name];
    [[Platform Instance] saveKeyWithVal:SERVER_API withVal:url];
    [[Platform Instance] saveKeyWithVal:SERVER_API_OUT withVal:urlOut];
    [[Platform Instance] saveKeyWithVal:SERVER_API_OUT_SECERT withVal:appSecert];
}

#pragma mark - 按钮点击事件
- (void)btnClick:(LSServerSelectionButton *)btn {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"服务器路径选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *list = [self serverSelectionList];
    __weak typeof(self) wself = self;
    [list enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [alertVc addAction:[UIAlertAction actionWithTitle:obj[@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [wself serverSelection:action];
        }]];
    }];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController presentViewController:alertVc animated:YES completion:nil];
    
}

- (void)serverSelection:(UIAlertAction *)action {
    NSArray *list = [self serverSelectionList];
    __weak typeof(self) wself = self;
    __block NSString *url = nil;
    [list enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([action.title isEqualToString:obj[@"name"]]) {
            url = obj[@"url"];
            [wself setTitle:action.title forState:UIControlStateNormal];
            [wself saveServerPath:action.title];
            *stop = YES;
        }
    }];
}

#pragma mark - 服务器选择数据源
- (NSArray *)serverSelectionList {
    NSArray *serverSelectionList = @[@{@"name" : @"测试环境", @"url" : API_ROOT},
                                     @{@"name" : @"预发环境", @"url" : @"http://myshop.2dfire-pre.com/serviceCenter/api"},
                                     @{@"name" : @"线上环境", @"url" : @"https://myshop.2dfire.com/serviceCenter/api"},
                                     @{@"name" : @"青蒿", @"url" : @"http://10.1.87.104:8080/serviceCenter/api"},
                                     @{@"name" : @"胡萝卜", @"url" : @"http://10.1.87.81:8080/serviceCenter/api"},
                                     @{@"name" : @"茭白", @"url" : @"http://10.1.87.165:8080/serviceCenter/api"},
                                     @{@"name" : @"川木", @"url" : @"http://10.1.134.185:8080/serviceCenter/api"},
                                     @{@"name" : @"131环境", @"url" : @"http://10.1.6.131/serviceCenter/api"},
                                     @{@"name" : @"慢sql优化", @"url" : @"http://10.1.6.242:8080/retail-server/serviceCenter/api"},
    
                                     @{@"name" : @"10.1.7.118", @"url" : @"http://10.1.7.118:8080/retail-server/serviceCenter/api"},
                                     @{@"name" : @"陈皮", @"url" : @"http://10.1.87.147:8080/serviceCenter/api"},
                                     @{@"name" : @"香猪", @"url" : @"http://10.1.130.98:8080/serviceCenter/api"},
                                     @{@"name" : @"文元", @"url" : @"http://10.1.87.13:8080/serviceCenter/api"}];
    return serverSelectionList;
}

@end
