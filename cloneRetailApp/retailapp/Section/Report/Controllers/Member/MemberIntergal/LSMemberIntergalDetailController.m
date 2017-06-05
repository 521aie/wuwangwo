//
//  LSMemberIntergalDetailController.m
//  retailapp
//
//  Created by guozhi on 2017/1/9.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSMemberIntergalDetailController.h"
#import "XHAnimalUtil.h"
#import "UIHelper.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "MemberIntegralDetailVo.h"
#import "OrderIntegralView.h"
#import "ItemTitle.h"
#import "ViewFactory.h"
#import "Platform.h"
#import "NSString+Estimate.h"
#import "EditItemView.h"
#import "ColorHelper.h"
#import "LSEditItemView.h"
@interface LSMemberIntergalDetailController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *container;
/**积分兑换明细表*/
@property (strong, nonatomic) OrderIntegralView *orderIntegralView;
@property (strong, nonatomic) ItemTitle *shopTitle;

@property (strong, nonatomic) EditItemView *vewShop;
@end

@implementation LSMemberIntergalDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configContainerViews];
    [self loadData];
}

#pragma mark - 初始化导航栏
- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    //标题
    [self configTitle:@"积分兑换明细" leftPath:Head_ICON_BACK rightPath:nil];
    //scollVIew
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    //container
    self.container = [[UIView alloc] init];
    self.container.ls_width = SCREEN_W;
    [self.scrollView addSubview:self.container];
}


- (void)configContainerViews {
    self.orderIntegralView = [OrderIntegralView orderIntegralView];
    self.orderIntegralView.ls_left = 10;
    [self.container addSubview:self.orderIntegralView];
    
    self.shopTitle = [ItemTitle itemTitle:@"门店信息"];
    [self.container addSubview:self.shopTitle];
    
    [LSViewFactor addClearView:self.container y:0 h:20];
    
    self.vewShop = [EditItemView editItemView];
     [self.vewShop initLabel:@"兑换门店" withHit:nil];
    [self.container addSubview:self.vewShop];
    // 单店隐藏兑换门店一栏
    if ([[Platform Instance] getShopMode] == 1) {
        self.vewShop.hidden = YES;
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    self.shopTitle.hidden = YES;
    
}



#pragma mark - 加载数据
- (void)loadData {
    NSString *url = @"customerExchange/exchangeDetail";
    [BaseService getRemoteLSDataWithUrl:url param:self.param withMessage:nil show:YES CompletionHandler:^(id json) {
        
        MemberIntegralDetailVo *memberIntegralDetailVo = [MemberIntegralDetailVo memberIntegralDetailVo:json];
        [self.orderIntegralView initDataWithMemberIntegralDetailVo:memberIntegralDetailVo];
        if ([NSString isNotBlank:memberIntegralDetailVo.shopName]) {
            [self.vewShop initData:memberIntegralDetailVo.shopName withVal:memberIntegralDetailVo.shopName];
        }
        
        NSDictionary *dict = json[@"operater"];
        for (NSString *obj in dict.allKeys) {
            // 操作人为null 的不显示
            if ([NSString isNotBlank:dict[obj]]) {
                LSEditItemView *view = [LSEditItemView editItemView];
                [view initLabel:@"操作人" withHit:nil];
                [view initData:dict[obj]];
                [self.container addSubview:view];
            }
        }
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}


@end
