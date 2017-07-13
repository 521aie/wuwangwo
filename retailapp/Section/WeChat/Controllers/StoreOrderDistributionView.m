//
//  StoreOrderDistributionView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/12/11.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#define TAG_LST_OUT_FEE 11
#import "StoreOrderDistributionView.h"
#import "UIHelper.h"
#import "ServiceFactory.h"
#import "OptionPickerBox.h"
#import "NameItemVO.h"
#import "AlertBox.h"
#import "ColorHelper.h"
#import "ScanViewController.h"
#import "XHAnimalUtil.h"
#import "SelectEmployeeListView.h"
#import "WechatService.h"
#import "JsonHelper.h"
#import "SymbolNumberInputBox.h"
#import "ISearchBarEvent.h"

@interface StoreOrderDistributionView () <INavigateEvent, IEditItemListEvent,OptionPickerClient, EditItemText2Delegate,ISearchBarEvent,SymbolNumberInputClient,LSScanViewDelegate>
@property (nonatomic, strong) WechatService *wechatService;
@property (nonatomic, strong) ExpressVo *express;
@end

@implementation StoreOrderDistributionView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    self.wechatService = [ServiceFactory shareInstance].wechatService;
    [self.titleBox initWithName:@"配送信息" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    [self.titleDiv addSubview:self.titleBox];
    self.scrollView.hidden = YES;
    __weak StoreOrderDistributionView *weakSelf = self;
    [_wechatService selectExpress:[[Platform Instance] getkey:SHOP_ID] completionHandler:^(id json) {
        weakSelf.express = [JsonHelper dicTransObj:[json objectForKey:@"express"] obj:[ExpressVo new]];
        weakSelf.scrollView.hidden = NO;
        [weakSelf initMainView];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    
    [UIHelper clearColor:self.mainContainer];
}



- (void)initMainView {
    
    [self.lsMode initLabel:@"配送类型" withHit:nil delegate:self];
    [self.lsMode initData:self.express.sendTypeName withVal:self.express.sendTypeName];
    self.lsMode.tag = 1;
    
    [self.txtMember initLabel:@"配送员" withHit:nil isrequest:YES delegate:self];
    [self.txtMember initData:@"请选择" withVal:nil];
    self.txtMember.imgMore.image=[UIImage imageNamed:@"ico_next.png"];
    self.txtMember.tag = 2;
    
    [self.lsExpress initLabel:@"快递公司" withHit:nil delegate:self];
    if ([NSString isBlank:self.express.logisticsCompanyName]) {
        self.express.logisticsCompanyName = @"中通快递";
    }
    [self.lsExpress initData:self.express.logisticsCompanyName withVal:self.express.logisticsCompanyName];
    self.lsExpress.tag = 3;
    
    //中通快递、圆通速递、申通快递、韵达速递、顺丰速运、天天快递、EMS、其他
    [self.txtOther initLabel:@"快递公司（其他）" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtOther initMaxNum:50];
    
    [self.txtNumber initLabel:@"快递单号" withHit:nil withType:@"" showTag:4 delegate:self];
    [self.txtNumber initMaxNum:20];
    [self.txtNumber initPosition:1];
    self.txtNumber.txtVal.textColor = [ColorHelper getBlueColor];
    self.txtNumber.txtVal.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    self.txtNumber.btnButton.hidden = NO;
    [self.txtNumber.btnButton setImage:[UIImage imageNamed:@"ico_order_scan"] forState:UIControlStateNormal];
    self.txtNumber.btnButton.backgroundColor = [UIColor clearColor];
//    self.txtNumber.btnButton.frame = CGRectMake(320-40, 4, 40, 30);
//    self.txtNumber.txtVal.frame = CGRectMake(self.txtNumber.txtVal.frame.origin.x, self.txtNumber.txtVal.frame.origin.y, 178, self.txtNumber.txtVal.frame.size.height);
    
    UIColor *color = [UIColor redColor];
    NSString* hitStr=@"必填";
    if ([self.txtNumber.txtVal respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.txtNumber.txtVal.attributedPlaceholder = [[NSAttributedString alloc] initWithString:hitStr attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        self.txtNumber.txtVal.placeholder=hitStr;
    }
    [self.lstOutFee initLabel:@"配送费(元)" withHit:@"店家实际发生的配送费" isrequest:NO delegate:self];
    self.lstOutFee.tag = TAG_LST_OUT_FEE;
    [self updateByMode];
}

- (void)updateByMode {
    BOOL isStoreSend = [self.lsMode.currentVal isEqualToString:@"店家配送"];
    if (self.txtMember.hidden == !isStoreSend && self.lsExpress.hidden == isStoreSend) {
    } else {
        self.txtMember.hidden = !isStoreSend;
        self.lsExpress.hidden = isStoreSend;
        self.txtOther.hidden = isStoreSend;
        self.txtNumber.hidden = isStoreSend;
        
        if (isStoreSend) {
            [self.lsExpress initData:self.express.logisticsCompanyName withVal:self.express.logisticsCompanyName];
            [self.txtOther initData:@""];
            [self.txtNumber initData:@""];
        } else {
            [self.txtMember initData:@"请选择" withVal:@""];
        }
    }
    
    if ([self.lsExpress.currentVal isEqualToString:@"其他"]) {
        self.txtOther.hidden = NO;
    } else {
        self.txtOther.hidden = YES;
        [self.txtOther initData:@""];
    }
    
    [UIHelper refreshPos:self.mainContainer scrollview:self.scrollView];
}

- (void)onItemListClick:(EditItemList*)obj {

    if (obj == self.lsMode) {
        NSMutableArray *nameItems = [[NSMutableArray alloc] init];
        NameItemVO *nameItemVo = [[NameItemVO alloc] initWithVal:@"店家配送" andId:@"店家配送"];
        [nameItems addObject:nameItemVo];
        nameItemVo = [[NameItemVO alloc] initWithVal:@"第三方物流配送" andId:@"第三方物流配送"];
        [nameItems addObject:nameItemVo];
        [OptionPickerBox initData:nameItems itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    } else if (obj == self.txtMember) {
        //配送员
        SelectEmployeeListView *selectEmployeeView = [[SelectEmployeeListView alloc] initWithNibName:[SystemUtil getXibName:@"SelectEmployeeListView"] bundle:nil];
        selectEmployeeView.isSelfShop = YES;
        selectEmployeeView.selectedUerId = [self.txtMember getStrVal];
        
        __weak typeof(self) weakSelf = self;
        [selectEmployeeView loadDataWithCallBack:^(NSDictionary *selectUser) {
            if (selectUser!=nil&&selectUser.count>0) {
                NSString *operator = [NSString stringWithFormat:@"%@(%@)",[selectUser objectForKey:@"name"],[selectUser objectForKey:@"staffId"]];
                [weakSelf.txtMember initData:operator withVal:[selectUser objectForKey:@"userId"]];
            }
            [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [weakSelf.navigationController popToViewController:weakSelf animated:YES];
        }];
        [self.navigationController pushViewController:selectEmployeeView animated:NO];
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        
    } else if (obj == self.lsExpress) {
        //快递公司 中通快递、圆通速递、申通快递、韵达速递、顺丰速运、天天快递、EMS、其他
        NSMutableArray *nameItems = [[NSMutableArray alloc] init];
        NameItemVO *nameItemVo = [[NameItemVO alloc] initWithVal:@"中通快递" andId:@"中通快递"];
        [nameItems addObject:nameItemVo];
        nameItemVo = [[NameItemVO alloc] initWithVal:@"圆通速递" andId:@"圆通速递"];
        [nameItems addObject:nameItemVo];
        nameItemVo = [[NameItemVO alloc] initWithVal:@"申通快递" andId:@"申通快递"];
        [nameItems addObject:nameItemVo];
        nameItemVo = [[NameItemVO alloc] initWithVal:@"韵达速递" andId:@"韵达速递"];
        [nameItems addObject:nameItemVo];
        nameItemVo = [[NameItemVO alloc] initWithVal:@"顺丰速运" andId:@"顺丰速运"];
        [nameItems addObject:nameItemVo];
        nameItemVo = [[NameItemVO alloc] initWithVal:@"天天快递" andId:@"天天快递"];
        [nameItems addObject:nameItemVo];
        nameItemVo = [[NameItemVO alloc] initWithVal:@"EMS" andId:@"EMS"];
        [nameItems addObject:nameItemVo];
        nameItemVo = [[NameItemVO alloc] initWithVal:@"其他" andId:@"其他"];
        [nameItems addObject:nameItemVo];
        [OptionPickerBox initData:nameItems itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    } else if (obj == self.lstOutFee) {
        [SymbolNumberInputBox initData:obj.lblVal.text];
        [SymbolNumberInputBox show:obj.lblName.text client:self isFloat:YES isSymbol:YES event:obj.tag];
        [SymbolNumberInputBox limitInputNumber:6 digitLimit:2];
    }
}

- (void)numberClientInput:(NSString *)val event:(NSInteger)eventType {
    if (eventType == TAG_LST_OUT_FEE) {
        [self.lstOutFee initData:val withVal:val];
    }
}

#pragma mark - 条形码扫描

- (void)showButtonTag:(NSInteger)tag {
    ScanViewController *vc = [ScanViewController shareInstance:self types:LSScannerBarcode];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}
// LSScanViewDelegate
- (void)scanSuccess:(ScanViewController *)controller result:(NSString *)scanString {
    [self.txtNumber changeData:scanString];
}

- (void)scanFail:(ScanViewController *)controller with:(NSString *)message {
    [AlertBox show:message];
}


- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == 1) {
        //订单类型
        [self.lsMode initData:[item obtainItemName] withVal:[item obtainItemId]];
        [self updateByMode];
    } else if (eventType == 3) {
        //订单类型
        [self.lsExpress initData:[item obtainItemName] withVal:[item obtainItemId]];
        [self updateByMode];
    }
    
    return YES;
}


- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == 1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        //保存
        NSMutableDictionary *confirmDic = [NSMutableDictionary dictionaryWithCapacity:4];
        
        //扩展字段信息
        NSMutableDictionary *expansionDic = [NSMutableDictionary dictionary];
        if ([self.lsMode.currentVal isEqualToString:@"店家配送"]) {
            NSString *employeeId = [self.txtMember getStrVal];
            if ([NSString isBlank:employeeId]) {
                [AlertBox show:@"请选择配送员!"];
                return;
            }
            [confirmDic setValue:employeeId forKey:@"employeeId"];
            [expansionDic setValue:self.txtMember.lblVal.text forKey:@"send_man"];
            //快递费
            [expansionDic setValue:@"店家配送" forKey:@"logistics_name"];
        } else {
            //快递公司
            NSString *express = nil;
            if ([self.lsExpress.currentVal isEqualToString:@"其他"]) {
                express = self.txtOther.txtVal.text;
            } else {
                express = self.lsExpress.currentVal;
            }
            if ([NSString isBlank:express]) {
                if ([self.lsExpress.currentVal isEqualToString:@"其他"]) {
                    [AlertBox show:@"请输入快递公司名称!"];
                }else{
                    [AlertBox show:@"请选择快递公司!"];
                }
                return;
            }
            [expansionDic setValue:express forKey:@"logistics_name"];
            
            //快递单号
            NSString *expressCode = self.txtNumber.txtVal.text;
            if ([NSString isBlank:expressCode]) {
                [AlertBox show:@"请输入快递单号"];
                return;
            }
            [expansionDic setValue:expressCode forKey:@"logistics_no"];
            
            
        }
        //快递费
        NSString *outFee = self.lstOutFee.lblVal.text;
        if ([NSString isNotBlank:outFee]) {
            [expansionDic setValue:outFee forKey:@"shop_freight"];
        }
        //微店设置默认配送费比传的要不然默认是0
        [confirmDic setValue:[NSString stringWithFormat:@"%.2f", self.express.sendCost] forKey:@"outFee"];
        if (self.consume_points != nil) {
            [expansionDic setValue:self.consume_points forKey:@"consume_points"];

        }
        
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:expansionDic options:NSJSONWritingPrettyPrinted error:&error];
        NSString *expansion =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *str1 = [expansion stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *str = [str1 stringByReplacingOccurrencesOfString:@" " withString:@""];
        [confirmDic setValue:str forKey:@"expansion"];
       
        
        if (self.confirmOrderBack) {
            self.confirmOrderBack(confirmDic);
        }
        
    }
}

@end
