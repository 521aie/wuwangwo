//
//  KindPayEditView.m
//  retailapp
//
//  Created by 果汁 on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "GuestNoteEditView.h"
#import "LSEditItemText.h"
#import "UIHelper.h"
#import "XHAnimalUtil.h"
#import "NSString+Estimate.h"
#import "AlertBox.h"
#import "ServiceFactory.h"
#import "SettingService.h"
#import "JsonHelper.h"
#import "GuestNoteListView.h"


@implementation GuestNoteEditView

- (void)viewDidLoad {
    [super viewDidLoad];
     service = [ServiceFactory shareInstance].settingService;
    [self initNavigate];
    [self initMainView];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma mark - 初始化导航栏
- (void)initNavigate {
    [self configTitle:@"添加客单备注" leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
}

#pragma mark - 导航栏点击事件
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
    if (event == LSNavigationBarButtonDirectLeft) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        [self save];
    }
}

#pragma mark - 初始化页面
- (void)initMainView {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    
    self.txtMeno = [LSEditItemText editItemText];
    [self.txtMeno initLabel:@"客单备注" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.container addSubview:self.txtMeno];
    self.txtMeno.num = 50;
}


#pragma mark - 保存数据
- (void)save{
    if (![self isValid]) {
        return;
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:self.txtMeno.txtVal.text forKey:@"name"];
    NSString *path = @"billNote/save";
    [service getBillNoteInfo:path param:param completionHandler:^(id json) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[GuestNoteListView class]]) {
                GuestNoteListView *guestNoteEditView = (GuestNoteListView *)vc;
                [guestNoteEditView loadData];
            }
        }
        [self.navigationController popViewControllerAnimated:NO];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
    
}

#pragma mark - 判断是否满足保存条件
- (BOOL)isValid {
        if ([NSString isBlank:[self.txtMeno getStrVal]]) {
            [AlertBox show:@"客单备注不能为空，请输入！"];
            return NO;
        }
    return YES;
}


@end
