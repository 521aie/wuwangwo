//
//  AcountInformationList.m
//  retailapp
//
//  Created by guozhi on 15/11/16.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#define TAG_LST_BANK 1
#define TAG_LST_PROVINCE 2
#define TAG_LST_CITY 3
#define TAG_LST_SUB_BANK 4
#define TAG_TXT_BANK_NUMBER 5
#import "AcountAddView.h"
#import "NavigateTitle2.h"
#import "SystemUtil.h"
#import "XHAnimalUtil.h"
#import "AcountInformationListCell.h"
#import "FooterListView2.h"
#import "EditItemView.h"
#import "EditItemList.h"
#import "UIHelper.h"
#import "OptionPickerBox.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "NameItemVO.h"
#import "NSString+Estimate.h"
#import "Platform.h"
#import "EditItemText.h"
#import "SelectItemList.h"
#import "ShopInfoVO.h"

@implementation AcountAddView

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service = [ServiceFactory shareInstance].otherService;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigate];
    [self initMainView];
    [self initData];
}

- (void)initNavigate {
    self.titleBox = [NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"添加" backImg:Head_ICON_BACK moreImg:nil];
    [self.titleBox editTitle:YES act:ACTION_CONSTANTS_ADD];
    [self.titleDiv addSubview:self.titleBox];
}

- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == 1) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        if ([self isVaild]) {
            if ([NSString isBlank:self.token]) {
                self.token = [[Platform Instance] getToken];
            }
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setValue:self.param forKey:@"userBankVo"];
            __block AcountAddView *weakSelf = self;
            [service addBanks:param completionBlock:^(id json) {
                weakSelf.token = nil;
                [XHAnimalUtil animal:weakSelf.navigationController type:kCATransitionPush direction:kCATransitionFromBottom];
                [weakSelf.navigationController popViewControllerAnimated:NO];
            } errorHandler:^(id json) {
                [AlertBox show:json];
            }];
            
        }
    }
}

- (void)initMainView {
    self.token=nil;
    
    [self.txtName initLabel:@"持卡人" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtName initLabel:@"持卡人" withVal:@""];
    [self.lstBank initLabel:@"开户银行" withHit:nil delegate:self];
    [self.lstProvince initLabel:@"开户省份" withHit:nil delegate:self];
    [self.lstCity initLabel:@"开户城市" withHit:nil delegate:self];
    [self.lstSubBank initLabel:@"开户支行" withHit:nil delegate:self];
    [self.txtBankNumber initLabel:@"银行账号" withHit:nil isrequest:YES type:UIKeyboardTypeNumberPad];
    [self.txtBankNumber initMaxNum:19];
    self.lstBank.tag =TAG_LST_BANK;
    self.lstProvince.tag = TAG_LST_PROVINCE;
    self.lstCity.tag = TAG_LST_CITY;
    self.lstSubBank.tag = TAG_LST_SUB_BANK;
    self.txtBankNumber.tag = TAG_TXT_BANK_NUMBER;
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)initData {
    [self.lstBank initData:@"请选择" withVal:@""];
    [self.lstProvince initData:@"请选择" withVal:@""];
    [self.lstCity initData:@"请选择" withVal:@""];
    [self.lstSubBank initData:@"请选择" withVal:@""];
    self.lstSubBank.imgMore.image = [UIImage imageNamed:@"ico_next"];
    self.txtBankNumber.txtVal.placeholder = @"卡号";
}

- (void)onItemListClick:(EditItemList *)obj {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (obj.tag == TAG_LST_BANK) {
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        NSString *url = @"pay/area/v1/get_banks";
        [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {//查询银行列表
            NameItemVO *itemVo;
            for (NSDictionary *obj in  json[@"data"]) {
                itemVo = [[NameItemVO alloc] initWithVal:obj[@"bankDisplayName"] andId:obj[@"bankName"]];
                [arr addObject:itemVo];
            }
            [OptionPickerBox initData:arr itemId:[obj getStrVal]];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    } else if (obj.tag == TAG_LST_PROVINCE) {
        if ([NSString isBlank:[self.lstBank getStrVal]]) {
            [AlertBox show:@"请选择开户银行"];
            return;
        }
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        [param setValue:[self.lstBank getStrVal] forKey:@"bankName"];
        NSString *url = @"userBank/selectProvinceList";
        [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {//查询银行开户省份
            NameItemVO *itemVo;
            for (NSDictionary *obj in  json[@"provinceList"]) {
                itemVo = [[NameItemVO alloc] initWithVal:obj[@"provinceName"] andId:obj[@"provinceNo"]];
                [arr addObject:itemVo];
            }
            [OptionPickerBox initData:arr itemId:[obj getStrVal]];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
    } else if (obj.tag == TAG_LST_CITY) {
        if ([NSString isBlank:[self.lstProvince getStrVal]]) {
            [AlertBox show:@"请选择开户省份"];
            return;
        }
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:[self.lstBank getStrVal] forKey:@"bankName"];
        [param setValue:[self.lstProvince getStrVal] forKey:@"provinceNo"];
        NSString *url = @"pay/area/v1/get_bank_cities";
        [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {//查询银行开户城市
            NameItemVO *itemVo;
            for (NSDictionary *obj in  json[@"data"]) {
                itemVo = [[NameItemVO alloc] initWithVal:obj[@"cityName"] andId:obj[@"cityNo"]];
                [arr addObject:itemVo];
            }
            [OptionPickerBox initData:arr itemId:[obj getStrVal]];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
        
    } else if (obj.tag == TAG_LST_SUB_BANK) {
        if ([NSString isBlank:[self.lstCity getStrVal]]) {
            [AlertBox show:@"请选择开户城市"];
            return;
        }
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:[self.lstBank getStrVal] forKey:@"bankName"];
        [param setValue:[self.lstCity getStrVal] forKey:@"cityNo"];
        NSString *url = @"pay/area/v1/get_sub_banks";
        [BaseService getRemoteLSOutDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {//查询银行开户支行
            NSArray *array = json[@"data"];
            NSMutableArray *optionList = [[NSMutableArray alloc] init];
            for (NSDictionary *obj in array) {
                ShopInfoVO *shopInfoVO = [ShopInfoVO mj_objectWithKeyValues:obj];
                NameItemVO *nameItem = [[NameItemVO alloc] initWithVal:shopInfoVO.subBankName andId:shopInfoVO.subBankNo];
                [optionList addObject:nameItem];
                
            }
            SelectItemList *vc = [[SelectItemList alloc] initWithtxtTitle:@"开户支行" txtPlaceHolder:@"输入支行关键字"];
            __weak AcountAddView *weakSelf = self;
            [vc selectId:[obj getStrVal] list:optionList callBlock:^(id<INameItem> item) {
                if (item) {
                    [weakSelf.lstSubBank changeData:[item obtainItemName] withVal:[item obtainItemId]];
                }
            }];
            [self.navigationController pushViewController:vc animated:NO];
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
        } errorHandler:^(id json) {
            [AlertBox show:json];
        }];
        
    }
    
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == TAG_LST_BANK) {
        [self.lstBank changeData:[item obtainItemName] withVal:[item obtainItemId]];
        [self.lstProvince initData:@"请选择" withVal:@""];
        [self.lstCity initData:@"请选择" withVal:@""];
        [self.lstSubBank initData:@"请选择" withVal:@""];
    } else if (eventType == TAG_LST_PROVINCE) {
        [self.lstProvince changeData:[item obtainItemName] withVal:[item obtainItemId]];
        [self.lstCity initData:@"请选择" withVal:@""];
        [self.lstSubBank initData:@"请选择" withVal:@""];
        
    } else if (eventType == TAG_LST_CITY) {
        [self.lstCity changeData:[item obtainItemName] withVal:[item obtainItemId]];
        [self.lstSubBank initData:@"请选择" withVal:@""];
    }
    return YES;
}

- (BOOL)isVaild {
    EditItemList* current;
    if ([NSString isBlank:self.txtName.txtVal.text]) {
        [AlertBox show:@"持卡人不能为空"];
        return NO;
    }
    for (UIView*  view in self.container.subviews) {
        if ([view isKindOfClass:[EditItemList class]]) {
            current=(EditItemList*)view;
            if ([NSString isBlank:[current getStrVal]]) {
                [AlertBox show:[NSString stringWithFormat:@"请选择%@",current.lblName.text]];
                return NO;
            }
        }
    }
    if ([NSString isBlank:self.txtBankNumber.txtVal.text]) {
        [AlertBox show:@"银行账号不能为空"];
        return NO;
    }
    if(self.txtBankNumber.txtVal.text.length<10){
        [AlertBox show:@"银行账号长度不能小于10位"];
        return NO;
    }
    if(self.txtBankNumber.txtVal.text.length>20){
        [AlertBox show:@"银行账号长度不能超过20位"];
        return NO;
    }
    
    return YES;
    
}

- (NSMutableDictionary *)param {
    if (_param == nil) {
        _param = [[NSMutableDictionary alloc] init];
    }
    [_param setValue:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entityId"];
    [_param setValue:[[Platform Instance] getkey:USER_ID] forKey:@"userId"];
    [_param setValue:self.txtName.txtVal.text forKey:@"accountName"];
    //1：员工  2：会员
    [_param setValue:@1 forKey:@"userType"];
    [_param setValue:[self.lstBank getDataLabel] forKey:@"bankName"];
    [_param setValue:self.txtBankNumber.txtVal.text forKey:@"accountNumber"];
    [_param setValue:[self.lstProvince getStrVal] forKey:@"provinceId"];
    [_param setValue:[self.lstCity getStrVal] forKey:@"cityId"];
    [_param setValue:[self.lstSubBank getDataLabel] forKey:@"branchName"];
    return _param;
}



@end
