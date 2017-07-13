//
//  LSPaymentStatusController.m
//  retailapp
//
//  Created by guozhi on 2016/12/5.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSPaymentStatusController.h"
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "ShopInfoVO.h"
#import "AlertBox.h"
#import "PaymentEditView.h"
#import "PaymentTypeView.h"
#import "PaymentView.h"

@interface LSPaymentStatusController ()<INavigateEvent>
/** 标题 */
@property (nonatomic, strong) NavigateTitle2 *titleBox;
/** <#注释#> */
@property (nonatomic, strong) ShopInfoVO *shopInfoVo;
@end

@implementation LSPaymentStatusController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self configConstraints];
    [self loadData];
    [self configHelpButton:HELP_PAYMENT_ACCOUNT];
}

- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"收款账户" backImg:Head_ICON_BACK moreImg:nil];
    [self.view addSubview:self.titleBox];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    [self.titleBox makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(wself.view);
        make.height.equalTo(64);
    }];
}

- (void)onNavigateEvent:(Direct_Flag)event {
    if (event==DIRECT_LEFT) {
        for (UIViewController *viewController in [self.navigationController viewControllers]) {
            if ([viewController isKindOfClass:[PaymentTypeView class]]) {
                PaymentTypeView *vc = (PaymentTypeView *)viewController;
                [vc loadData];
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                [self.navigationController popToViewController:vc animated:NO];
                break;
            }
            if ([viewController isKindOfClass:[PaymentView class]]) {
                PaymentView *vc = (PaymentView *)viewController;
                [vc loadData];
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                [self.navigationController popToViewController:vc animated:NO];
                break;
            }
        }
    }
}

- (void)loadData {
    //获取分账实体ID
    __weak typeof(self) wself = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *entiyId = [[Platform Instance] getkey:PAY_ENTITY_ID];
    [param setValue:entiyId forKey:@"entity_id"];
    ///查询店铺电子支付信息
    NSString *url = @"pay/online/v1/get_online_pay_info";
    [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        wself.shopInfoVo = [ShopInfoVO mj_objectWithKeyValues:json[@"data"]];
        if (wself.status == 1) {
            [wself wait];
        }else if (wself.status == 2){
            [wself success];
        }else if(self.status == 3){
            [wself failure];
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];

}

- (void)wait
{
    __weak typeof (self) weakSelf = self;
    
    //图片
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shalou.png"]];
    [self.view addSubview:image];
    
    //文字1
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.textColor = [UIColor orangeColor];
    tipLabel.font = [UIFont systemFontOfSize:15];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = @"收款账户变更已提交，\n请耐心等待审核";
    tipLabel.numberOfLines = 0;
    [self.view addSubview:tipLabel];
    
    //文字2
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.textColor = [UIColor grayColor];
    detailLabel.font = [UIFont systemFontOfSize:13];
    detailLabel.text = @"注：1.五个工作日内会返回审核结果，请耐心等待。\n2.审核期间，顾客电子支付的钱，由兴业银行转入原账户，审核通过后转入新账户。";
    detailLabel.numberOfLines = 0;
    [self.view addSubview:detailLabel];
    __weak typeof(self) wself = self;
    [image mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(weakSelf.titleBox.bottom).offset(100);
        make.centerX.equalTo(weakSelf.view);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(image.mas_bottom).with.offset(10);
        make.left.equalTo(wself.view.left).offset(10);
        make.right.equalTo(wself.view.right).offset(-10);
    }];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(tipLabel.mas_bottom).with.offset(10);
        make.left.equalTo(wself.view.left).offset(10);
        make.right.equalTo(wself.view.right).offset(-10);
    }];
}

- (void)success
{
    __weak typeof (self) weakSelf = self;
    //图片
    UIImageView *faceView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_smile_face"]];
    [self.view addSubview:faceView];
    
    //label
    UILabel *tipsLabel           = [[UILabel alloc]init];
    tipsLabel.textColor          = [ColorHelper getGreenColor];
    tipsLabel.font               = [UIFont systemFontOfSize:15];
    tipsLabel.textAlignment      = NSTextAlignmentCenter;
    tipsLabel.text               =@"恭喜您，收款账户变更审核通过";
    tipsLabel.numberOfLines = 0;
    [self.view addSubview:tipsLabel];
    
    //按钮
    UIButton *loginBtn           = [[UIButton alloc]init];
    [loginBtn addTarget:self action:@selector(successClick) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font     = [UIFont systemFontOfSize:15];
    [loginBtn setTitle:@"查看收款账户"  forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_full_g"] forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius  = 5;
    [self.view addSubview:loginBtn];
    __weak typeof(self) wself = self;
    [faceView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(weakSelf.titleBox.bottom).offset(100);
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(faceView.mas_bottom).with.offset(10);
        make.left.equalTo(wself.view.left).offset(10);
        make.right.equalTo(wself.view.right).offset(-10);
    }];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(tipsLabel.mas_bottom).offset(20);
        make.height.equalTo(40);
        make.left.equalTo(weakSelf.view.left).offset(10);
        make.right.equalTo(weakSelf.view.right).offset(-10);
    }];
}

-(void)failure
{
    __weak typeof (self) weakSelf = self;
    
    //图片
    UIImageView *faceView    = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_tanhao.png"]];
    [self.view addSubview:faceView];
    
    UILabel *tipsLabel           = [[UILabel alloc]init];
    tipsLabel.textColor          = [ColorHelper getRedColor];
    tipsLabel.font               = [UIFont systemFontOfSize:15];
    tipsLabel.textAlignment      = NSTextAlignmentCenter;
    tipsLabel.text               =@"抱歉，收款账户变更审核未通过";
    tipsLabel.numberOfLines = 0;
    [self.view addSubview:tipsLabel];
    
    //按钮
    UIButton *loginBtn           = [[UIButton alloc]init];
    [loginBtn addTarget:self action:@selector(failureClick) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font     = [UIFont systemFontOfSize:15];
    loginBtn.backgroundColor     =[ColorHelper getRedColor];
    [loginBtn setTitle:@"修改收款账户"  forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_full_r"] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius  = 5;
    [self.view addSubview:loginBtn];
    __weak typeof(self) wself = self;
    if (self.shopInfoVo.settleAccountInfo.auditMessage.length >0 ) {
        //reason
        UILabel   *reasonTip =    [[UILabel alloc]init];
        reasonTip.textColor   = [ColorHelper getTipColor6];
        reasonTip.font  = [UIFont systemFontOfSize:13];
        reasonTip.textAlignment  = NSTextAlignmentCenter;
        reasonTip.text      =[NSString stringWithFormat: @"注：审核未通过原因是%@",self.shopInfoVo.settleAccountInfo.auditMessage];
        reasonTip.numberOfLines = 0;
        [self.view addSubview: reasonTip];
        
        [reasonTip mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(tipsLabel.mas_bottom).offset(20);
            make.left.equalTo(wself.view.left).offset(10);
            make.right.equalTo(wself.view.right).offset(-10);
        }];
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(reasonTip.mas_bottom).with.offset(20);
            make.left.equalTo(weakSelf.view.left).offset(10);
            make.right.equalTo(weakSelf.view.right).offset(-10);
            make.height.equalTo(40);
            
        }];
    } else {
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(tipsLabel.mas_bottom).with.offset(20);
            make.left.equalTo(weakSelf.view.left).offset(10);
            make.right.equalTo(weakSelf.view.right).offset(-10);
            make.height.equalTo(40);
            
        }];
    }
    
    [faceView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(weakSelf.titleBox.bottom).offset(100);
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(faceView.mas_bottom).with.offset(20);
        make.left.equalTo(wself.view.left).offset(10);
        make.right.equalTo(wself.view.right).offset(-10);
    }];
    
    
   
}
#pragma mark - 点击查看收款账户
-(void)successClick
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *saveValue = [NSString stringWithFormat:@"%@-success",self.shopInfoVo.settleAccountInfo.entityId];
    [defaults setValue:[NSString stringWithFormat:@"%lld",self.shopInfoVo.settleAccountInfo.auditTime.longLongValue] forKey:saveValue];
   
    //把数据写到硬盘
    [defaults synchronize];
    [self gotoPaymentEditView];
}

#pragma mark - 点击修改收款账户
- (void)failureClick{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *saveValue = [NSString stringWithFormat:@"%@-failure",self.shopInfoVo.settleAccountInfo.entityId];
    [defaults setValue:[NSString stringWithFormat:@"%lld",self.shopInfoVo.settleAccountInfo.auditTime.longLongValue] forKey:saveValue];
    //把数据写到硬盘
    [defaults synchronize];
    [self gotoPaymentEditView];
    
}

- (void)gotoPaymentEditView {
    PaymentEditView *vc = [[PaymentEditView alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
    
}





@end
