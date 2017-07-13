//
//  ScanPayView.h
//  retailapp
//
//  Created by guozhi on 16/1/21.
//  Copyright (c) 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "AlertBox.h"
#import "SymbolNumberInputBox.h"

@class MainModule,ScanService,EditItemLines;
@interface ScanPayDetail : LSRootViewController<UITextFieldDelegate,AlertBoxClient,SymbolNumberInputClient> {
    MainModule *mainModule;
    ScanService *service;
}
@property (nonatomic, copy) NSString *entityId;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *cardId;
@property (nonatomic, copy) NSString *customerId;

@property (nonatomic, copy) NSString *code;
/**用户头像*/
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
/**用户姓名*/
@property (weak, nonatomic) IBOutlet UILabel *userName;
/**用户手机号*/
@property (weak, nonatomic) IBOutlet UILabel *userPhone;
/**金额标题*/
@property (weak, nonatomic) IBOutlet UILabel *amount;
/**金额内容*/
@property (weak, nonatomic) IBOutlet UITextField *txtAmount;
/**备注标题*/
@property (weak, nonatomic) IBOutlet UILabel *memo;
/**备注内容*/
@property (weak, nonatomic) IBOutlet UITextField *txtMeno;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (weak, nonatomic) IBOutlet UIButton *btn;
- (id)initWithCode:(NSString *)code;
@end
