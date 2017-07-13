//
//  WithdrawDetailView.m
//  retailapp
//
//  Created by Jianyong Duan on 16/1/4.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "WithdrawDetailView.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "UIHelper.h"
#import "ImageVo.h"
#import "DateUtils.h"
#import "RefuseReasonView.h"
#import "ItemCertId.h"
#import "XHAnimalUtil.h"
@interface WithdrawDetailView ()<INavigateEvent,IEditItemImageEvent>

@property (nonatomic, strong) WithdrawCheckVo *withdrawCheck;

@end

@implementation WithdrawDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:self.checkVo.userName backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
    
    [self initMainView];
    
    if (self.fromRecordView == 1) {
        self.buttonCancel.hidden = NO;
        self.buttonConfig.hidden = YES;
        self.buttonRefuse.hidden = YES;
    } else {
        self.buttonCancel.hidden = YES;
        self.buttonConfig.hidden = NO;
        self.buttonRefuse.hidden = NO;
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    [self getCompanionWithdrawDetail];
}

- (void)initMainView {
    [self.itemCertIdImg initLabel:@"证件图片" delegate:self];
    [self.itemCertIdImg.frontCertId setOnlyShow];
    [self.itemCertIdImg.backCertId setOnlyShow];
    
    [self.txtReason initLabel:@"审核不通过原因" withHit:nil isrequest:NO type:UIKeyboardTypeDefault];
    [self.txtReason editEnabled:NO];
    [self.txtReason visibal:NO];
    
    self.viewOper.hidden = YES;
}

-(void) onNavigateEvent:(Direct_Flag)event {
    if (event == 1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
        //报错
        _withdrawDetailBlock(nil);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getCompanionWithdrawDetail {
    NSString* url =@"withdrawCheck/detail";
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:[NSNumber numberWithInteger:self.checkVo.withdrawCheckId] forKey:@"withdrawCheckId"];
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        self.withdrawCheck = [WithdrawCheckVo converToVo:json[@"withdrawCheck"]];
        [self showDetail];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

- (void)showDetail {
    if (!self.withdrawCheck) {
        return;
    }
    
    //姓名/名称
    self.lblName.text = self.withdrawCheck.userName;

    //手机号码
    self.lblMobile.text = self.withdrawCheck.mobile;
    
    //提现金额（元）
    self.lblAmount.text = [NSString stringWithFormat:@"%.2f", self.withdrawCheck.actionAmount];
    
    //提现方式
    self.lblWithdrawType.text = self.withdrawCheck.withdrawalType;

    //持卡人
    self.lblCardholder.text = self.withdrawCheck.accountName;
    
    //开户行
    self.lblBank.text = self.withdrawCheck.bankName;
    
    //银行卡号
    self.lblCardNo.text = self.withdrawCheck.accountNumber;

    //证件号码
    self.lblCertificateNo.text = self.withdrawCheck.certificateId;
    
    //证件图片
    if (self.withdrawCheck.imageList.count > 0) {
        [self.itemCertIdImg visibal:YES];
        for (ImageVo *imageVo in self.withdrawCheck.imageList) {
            //1：正面，2：反面
            if (imageVo.frontBack == 1) {
                [self.itemCertIdImg initFrontImg:imageVo.filePath];
                [self.itemCertIdImg.frontCertId setOnlyShow];
                if ([NSString isBlank:imageVo.filePath]) {
                    self.itemCertIdImg.frontCertId.imgView.image = [UIImage imageNamed:@"ico_default"];
                    [self.itemCertIdImg.frontCertId showAddUI:NO];
                }
            } else if (imageVo.frontBack == 2) {
                [self.itemCertIdImg initBackImg:imageVo.filePath];
                [self.itemCertIdImg.backCertId setOnlyShow];
                if ([NSString isBlank:imageVo.filePath]) {
                    self.itemCertIdImg.backCertId.imgView.image = [UIImage imageNamed:@"ico_default"];
                    [self.itemCertIdImg.backCertId showAddUI:NO];
                }
            }
        }
    } else {
        self.itemCertIdImg.frontCertId.imgView.image = [UIImage imageNamed:@"ico_default"];
        [self.itemCertIdImg.frontCertId showAddUI:NO];
        self.itemCertIdImg.backCertId.imgView.image = [UIImage imageNamed:@"ico_default"];
        [self.itemCertIdImg.backCertId showAddUI:NO];
    }
    self.itemCertIdImg.userInteractionEnabled = NO;
    self.itemCertIdImg.backCertId.imgDel.hidden = YES;
    self.itemCertIdImg.frontCertId.imgDel.hidden = YES;
    
    //申请时间
    self.lblTime.text = [DateUtils formateTime1:self.withdrawCheck.createTime];
    
    //审核状态


    //申请时间
    self.lblTime.text = [DateUtils formateTime1:self.withdrawCheck.createTime];
    
    //审核状态
    if (self.withdrawCheck.checkResult == 1) {
        self.lblStatus.text = @"未审核";
        
        self.viewOper.hidden = NO;
        
    } else if (self.withdrawCheck.checkResult == 2) {
        self.lblStatus.text = @"审核不通过";
        
        //审核不通过原因
        [self.txtReason visibal:YES];
        [self.txtReason initLabel:@"审核不通过原因" withHit:self.withdrawCheck.refuseReason isrequest:NO type:UIKeyboardTypeDefault];
        self.txtReason.txtVal.hidden=YES;
    } else if (self.withdrawCheck.checkResult == 3) {
        self.lblStatus.text = @"审核通过";
    } else {
        self.lblStatus.text = @"取消";
    }
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//审核不通过
- (IBAction)refuseWithdrawClick:(id)sender {
    RefuseReasonView *reasonView = [[RefuseReasonView alloc] initWithNibName:[SystemUtil getXibName:@"RefuseReasonView"] bundle:nil];
    reasonView.status = 4;
    reasonView.refuseReasonBack = ^(NSString *reason) {
        //审核不通过
        self.withdrawCheck.refuseReason=reason;
        [self upDateWithdraw:@"refuse" refuseReason:reason];
    };
    [self.navigationController pushViewController:reasonView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

//审核通过
- (IBAction)configWithdrawClick:(id)sender {
    [self upDateWithdraw:@"config" refuseReason:nil];
}

//取消
- (IBAction)cancelWithdrawClick:(id)sender {
    [self upDateWithdraw:@"cancel" refuseReason:nil];
}

- (void)upDateWithdraw:(NSString *)operateType refuseReason:(NSString *)reason {
    NSString* url = @"withdrawCheck/updateWithdrawCheck";
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:operateType forKey:@"operateType"];
    if (![param[@"operateType"] isEqualToString:@"cancel"]) {
        self.withdrawCheck.opUserName=[NSString stringWithFormat:@"%@",[[Platform Instance] getkey:USER_NAME]];
        self.withdrawCheck.opUserId=[NSString stringWithFormat:@"%@",[[Platform Instance] getkey:USER_ID]];
        self.withdrawCheck.checkUserName=[NSString stringWithFormat:@"%@",[[Platform Instance] getkey:USER_NAME]];
        self.withdrawCheck.checkUserId=[NSString stringWithFormat:@"%@",[[Platform Instance] getkey:USER_ID]];
    }
    [param setValue:[self.withdrawCheck converToDic] forKey:@"withdrawCheck"];
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        if ([operateType isEqualToString:@"config"]) {
            //config：确认
            self.lblStatus.text = @"审核通过";
            self.checkVo.checkResult = 3;
        } else if ([operateType isEqualToString:@"refuse"]) {
            //refuse：拒绝
            self.lblStatus.text = @"审核不通过";
            self.checkVo.checkResult = 2;
            //审核不通过原因 TODO
            [self.txtReason visibal:YES];
            [self.txtReason initLabel:@"审核不通过原因" withHit:reason isrequest:NO type:UIKeyboardTypeDefault];
        } else {
            //取消
            self.checkVo.checkResult = 4;
        }
        
        self.viewOper.hidden = NO;
        [UIHelper refreshUI:self.container scrollview:self.scrollView];
        [self.navigationController popViewControllerAnimated:YES];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    //    if (refuseReason) {
    //        [param setValue:refuseReason forKey:@"refuseReason"];
    //    }

}

- (void)loadWithdrawDetail:(NSInteger)viewType withIsPush:(BOOL)isPush callBack:(WithdrawDetail)callBack {
    self.withdrawDetailBlock = callBack;
    
}

@end
