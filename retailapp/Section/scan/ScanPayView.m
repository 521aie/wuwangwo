//
//  ScanPayView.m
//  retailapp
//
//  Created by guozhi on 16/1/21.
//  Copyright (c) 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ScanPayView.h"
#import "NavigateTitle2.h"
#import "ScanViewController.h"
#import "ScanPayDetail.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"

@interface ScanPayView ()<LSScanViewDelegate>

@property (nonatomic ,strong) ScanViewController *scanViewController;/* <<#desc#>*/
@end

@implementation ScanPayView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    [self loadScanView];
}


- (void)initNavigate {
    [self configTitle:@"扫码收款" leftPath:Head_ICON_BACK rightPath:nil];
   
}

#pragma mark - 二维码扫描

- (void)loadScanView {
    
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerQRcode];
    vc.lblTitle = @"扫码收款";
    float y = 84;
    UILabel *lblTip = [[UILabel alloc] initWithFrame:CGRectMake(0, y, SCREEN_W, 20)];
    lblTip.text = @"扫商圈卡付款码";
    lblTip.textColor = [UIColor whiteColor];
    lblTip.textAlignment = NSTextAlignmentCenter;
    lblTip.font = [UIFont boldSystemFontOfSize:17];
    [vc.view addSubview:lblTip];
    [self.navigationController pushViewController:vc animated:NO];
}

// LSScanViewDelegate
- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    /**
     99925580前8为代表entiyID
     150571162790 中间11为代表手机号
     6  是校验码
     99925580150571627906
     */
    ScanPayDetail *vc = [[ScanPayDetail alloc] initWithCode:scanString];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];

}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [AlertBox show:message];
}

- (void)closeScanView {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
