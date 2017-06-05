//
//  ApplyWithdrawView.m
//  retailapp
//
//  Created by Jianyong Duan on 16/1/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ApplyWithdraw.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "MicroDistributeVo.h"
#import "UserBankListView.h"
#import "XHAnimalUtil.h"
#import "WithdrawCheckVo.h"
#import "SystemUtil.h"
#import "ObjectUtil.h"
#import "UIHelper.h"

@interface ApplyWithdraw ()<INavigateEvent, IEditItemListEvent>
@property (nonatomic, strong) MicroDistributeVo *bigPartnerExamVo;
@property (nonatomic, strong) MicroDistributeService *microDistributeService;

//可体现金额


@end

@implementation ApplyWithdraw

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.microDistributeService = [ServiceFactory shareInstance].microDistributeService;
    
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"申请提现" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
    
    self.smallCompanionWithdrawView.hidden=YES;
//    if([[Platform Instance] isBigCompanion]){
//        self.lblSmallCompanionWithdraw.text = [NSString stringWithFormat:@"%.2f",self.smallCompanionWithdraw];
//    }else{
//        self.smallCompanionWithdrawView.hidden=YES;
//    }
    //初始化
    [self.lstAccount initLabel:@"账号" withHit:nil isrequest:YES delegate:self];
    self.lstAccount.imgMore.image = [UIImage imageNamed:@"ico_next"];
    if(self.userBank.accountNumber==nil || [self.userBank.accountNumber isEqual:@""]){
        
    }else{
        self.userBank.lastFourNum=[self.userBank.accountNumber substringFromIndex:self.userBank.accountNumber.length - 4];
        [self.lstAccount initData:[NSString stringWithFormat:@"%@ 尾号%@", self.userBank.bankName, self.userBank.lastFourNum] withVal:self.userBank.accountNumber];

    }
    [self.txtBalance initLabel:@"提现金额" withHit:nil isrequest:YES type:UIKeyboardTypeDecimalPad];
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    //微分销设置
    [self loadSetData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) onNavigateEvent:(Direct_Flag)event {
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)loadSetData {
    __weak typeof(self) weakSelf = self;
    
    [_microDistributeService microDistributeList:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        
        //大伙伴审核提现
        MicroDistributeVo *bigPartnerExamVo = [MicroDistributeVo converToVo:json[@"bigPartnerExamVo"]];
        if ([bigPartnerExamVo.value integerValue] == 1) {
            //“本次最高可提现” + 可提现余额+小伙伴申请提现金额 + “元”
//            weakSelf.maxBalance = weakSelf.maxBalance + self.companionAccount.subApplyWithdraw;
        }
//        [weakSelf.txtBalance initPlaceholder:[NSString stringWithFormat:@"本次最高可提现%.2f元", weakSelf.maxBalance]];
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    NSString *url = @"microDistribute/list";
    [BaseService getRemoteLSDataWithUrl:url param:nil withMessage:nil show:NO CompletionHandler:^(id json) {
        if ([ObjectUtil isNotEmpty:json[@"bigPartnerExamVo"]]) {
            weakSelf.bigPartnerExamVo = [MicroDistributeVo converToVo:json[@"bigPartnerExamVo"]];
        }
        if ([self.bigPartnerExamVo.value integerValue] == 1) {
            weakSelf.maxBalance = weakSelf.maxBalance + weakSelf.smallCompanionWithdraw;
        }
        [weakSelf.txtBalance initPlaceholder:[NSString stringWithFormat:@"本次最高可提现%.2f元", weakSelf.maxBalance]];
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)onItemListClick:(EditItemList*)obj {
    UserBankListView *userBankListView = [[UserBankListView alloc]initWithNibName:[SystemUtil getXibName:@"UserBankListView"] bundle:nil];
    userBankListView.selectId = [self.lstAccount getStrVal];
    userBankListView.selectUserBankHander = ^(UserBankVo *userBank) {
        [self.navigationController popToViewController:self animated:YES];
        
        if (!userBank) {
            return;
        }
        self.userBank = userBank;
        
        [self.lstAccount initData:[NSString stringWithFormat:@"%@ 尾号%@", userBank.bankName, userBank.lastFourNum] withVal:userBank.accountNumber];
    };
    
    [self.navigationController pushViewController:userBankListView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

//确认提现
- (IBAction)withdrawClick:(id)sender {
    [SystemUtil hideKeyboard];
    NSString *userBankId = [self.lstAccount getStrVal];
    if ([NSString isBlank:userBankId]) {
        [AlertBox show:@"请选择银行账户"];
        return;
    }
    
    NSString *actionAmount = [self.txtBalance getStrVal];
    if ([NSString isBlank:actionAmount]) {
        [AlertBox show:@"请输入提现金额"];
        return;
    }
    if (![NSString isFloat:actionAmount] || [actionAmount floatValue] <= 0) {
        [AlertBox show:@"提现金额不能为0"];
        return;
    }
    NSString *blance = [NSString stringWithFormat:@"%.2f",self.maxBalance];
    self.maxBalance = blance.doubleValue;
    if ([actionAmount doubleValue] > self.maxBalance) {
        [AlertBox show:@"超出最高可提现金额"];
        return;
    }
    
    WithdrawCheckVo *withdrawCheck = [[WithdrawCheckVo alloc] init];
    
    //实体Id
    withdrawCheck.entityId = [[Platform Instance] getkey:ENTITY_ID];
    
    //申请者Id(总部 门店 大伙伴)
  withdrawCheck.proposerId = [[Platform Instance] getkey:SHOP_ID];
    //申请者区分 1:门店 2:伙伴 3:机构
    
    if ([[Platform Instance] getShopMode]==3){
        withdrawCheck.proposerType = 3;
        withdrawCheck.parentId = 0;
    }else{
        withdrawCheck.parentId = 0;
        withdrawCheck.proposerType = 1;
    }
    //伙伴上级Id
    
    //操作 1:余额提现审核 2:余额转积分审核
    withdrawCheck.action = 1;
    //发生额
    withdrawCheck.actionAmount = [ [self.txtBalance getStrVal] doubleValue];
//    isValid			是否有效			Byte
//    createTime			创建时间			Integer
//    opTime			操作时间			Integer
//    lastVer			版本号			Integer
    
    //操作人Id 必传
    withdrawCheck.opUserId = [[Platform Instance] getkey:USER_ID];
    withdrawCheck.opUserName = [[Platform Instance] getkey:USER_NAME];
//    checkUserId			审核人Id			String
    withdrawCheck.withdrawalType = @"银行卡";
    withdrawCheck.bankName = self.userBank.bankName;
    withdrawCheck.accountName = self.userBank.accountName;
    withdrawCheck.accountNumber = self.userBank.accountNumber;
    
//    checkUserName			审核人姓名			String
//    refuseReason			审核不同意理由			String
//        mobile			手机号			String					添加时不必传
//    mobileFour			手机号后4位			String					添加时不必传
//    imageList			证件图片列表			List<ImageVo>					不必传
//    certificateId			证件号码			String					不必传		
//    identityTypeId			证件类型			short					1身份证  5护照
    
    __weak typeof(self) weakSelf = self;
    NSString* url = @"withdrawCheck/saveWithDrawCheck";
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [param setValue:[withdrawCheck converToDic] forKey:@"withdrawCheck"];
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
       // NSInteger companionId = [[[Platform Instance] getkey:COMPANION_ID] integerValue];
        //NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
        //[settings setValue:[self.userBank toDictionary] forKey:[NSString stringWithFormat:@"userBank%ld", companionId]];
        //[settings synchronize];
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

@end
