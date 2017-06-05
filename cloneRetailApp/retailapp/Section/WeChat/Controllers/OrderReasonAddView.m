//
//  OrderReasonAddView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/12/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "OrderReasonAddView.h"
#import "CommonService.h"
#import "ServiceFactory.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "ReasonVo.h"
#import "DicItemConstants.h"
#import "UIHelper.h"
#import "ColorHelper.h"
@interface OrderReasonAddView () <INavigateEvent>

@property (nonatomic, strong) CommonService *commonService;

@end

@implementation OrderReasonAddView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.commonService = [ServiceFactory shareInstance].commonService;
    
    self.titleBox=[NavigateTitle2 navigateTitle:self];
//    [self.titleBox initWithName:@"添加" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];    
    [self.titleBox initWithName:@"添加拒绝原因" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    [self.txtreason initLabel:@"拒绝原因" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtreason.lblName setTextColor:[ColorHelper getTipColor3]];
    [self.titleDiv addSubview:self.titleBox];
}


-(void) onNavigateEvent:(Direct_Flag)event {
    if (event == 1) {
        [XHAnimalUtil animal:self type:kCATransitionPush direction:kCATransitionFromBottom];
            [self.navigationController popViewControllerAnimated:NO];
    } else {
        //保存
        if ([NSString isBlank:[self.txtreason getStrVal]]) {
            [AlertBox show:@"请输入拒绝原因"];
            return ;
        }else{
        [self addReason];
        }
    }
}

- (void)addReason {
    NSString *reason =[self.txtreason getStrVal]; //self.textField.text;
    if ([NSString isBlank:reason]) {
        [AlertBox show:@"请输入拒绝原因"];
        return;
    }
    
    //拒绝原因检索
    __weak typeof(self) weakSelf = self;
    //店铺类型
    [_commonService addReasonByCode:DIC_REFUSE_RESON withReasonName:reason
                    completionHandler:^(id json) {
                        if (!(weakSelf)) {
                            return ;
                        }
                        ReasonVo *reasonVo = [[ReasonVo alloc] init];
                        reasonVo.dicItemId = json[@"dicId"];
                        reasonVo.name = reason;
                        [weakSelf.reasonList addObject:reasonVo];
                        
                        //dicId
                        [weakSelf performSelectorOnMainThread:@selector(addSuccess) withObject:nil waitUntilDone:NO];
                        
                    } errorHandler:^(id json) {
                        
                        [AlertBox show:json];
                    }];
}


- (void)addSuccess {
     [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
    [self.navigationController popViewControllerAnimated:NO];
   
}

@end
