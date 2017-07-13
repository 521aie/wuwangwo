//
//  UnitAddViewController.m
//  retailapp
//
//  Created by guozhi on 16/7/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "UnitAddViewController.h"
#import "LSEditItemText.h"
#import "UIHelper.h"
#import "UnitInfoViewController.h"
#import "UnitAddViewController.h"
#import "AlertBox.h"

@interface UnitAddViewController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) LSEditItemText *txtUnit;

@end

@implementation UnitAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    [self initMainView];
    
}

- (void)initNavigate {
    [self configTitle:@"添加单位" leftPath:Head_ICON_CANCEL rightPath:Head_ICON_OK];
    
}

- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
    if (event == LSNavigationBarButtonDirectRight) {
        if ([NSString isBlank:self.txtUnit.txtVal.text]) {
            [AlertBox show:@"单位不能为空，请输入！"];
            return;
        }
        NSString *url = @"goodsUnit/save";
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:self.txtUnit.txtVal.text forKey:@"unitName"];
        __strong typeof(self) wself = self;
        [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
            [wself.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[UnitInfoViewController class]]) {
                    [obj loadData];
                    [XHAnimalUtil animal:wself.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
                    [wself.navigationController popViewControllerAnimated:NO];

                }
            }];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
        
    } else {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];

    }
}



- (void)initMainView {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    
    
    self.txtUnit = [LSEditItemText editItemText];
    [self.container addSubview:self.txtUnit];
    [self.txtUnit initLabel:@"单位" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtUnit initMaxNum:32];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}


@end
