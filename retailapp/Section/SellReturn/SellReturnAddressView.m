//
//  SellReturnAddressView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/11/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SellReturnAddressView.h"
#import "ServiceFactory.h"
#import "SellReturnService.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "LoginService.h"
#import "OptionPickerBox.h"
#import "AddressPickerBox.h"
#import "NSString+Estimate.h"
@interface SellReturnAddressView ()<INavigateEvent, IEditItemListEvent, AddressPickerClient>

@property (nonatomic, strong) SellReturnService *sellReturnService;
@property (nonatomic,strong) LoginService* addressService;

@property (nonatomic, strong) NSString *provinceId;
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *countyId;
@property (nonatomic, strong) AddressPickerBox *addressPickerBox;

@end

@implementation SellReturnAddressView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.sellReturnService = [ServiceFactory shareInstance].sellReturnService;
    self.addressService = [ServiceFactory shareInstance].loginService;
    
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"退货地址" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    [self.titleDiv addSubview:self.titleBox];
    
    [self initMainView];
    
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
    
    [self shopReturnInfo];
}

- (void)initMainView {
    //联系人
    [self.txtLinkman initLabel:@"联系人" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtLinkman initMaxNum:50];
    
    //联系电话
    [self.txtPhone initLabel:@"联系电话" withHit:nil isrequest:YES type:UIKeyboardTypeNumbersAndPunctuation];
    [self.txtPhone initMaxNum:13];
    
    //所在地区
    [self.lstArea initLabel:@"所在地区" withHit:nil isrequest:YES delegate:self];
    
    //详细地址
    [self.txtAddress initLabel:@"详细地址" withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.txtAddress initMaxNum:100];
    
    //邮编
    [self.txtZipcode initLabel:@"邮编" withHit:nil isrequest:NO type:UIKeyboardTypePhonePad];
    [self.txtZipcode initMaxNum:6];
}

- (void)shopReturnInfo {
    
    __weak SellReturnAddressView* weakSelf = self;
    
    [self.sellReturnService shopReturnInfo:self.shopId completionHandler:^(id json) {
        if (!(weakSelf)) {
            return ;
        }
        //店铺退货地址信息
        ShopReturnInfoVo *infoVo = [ShopReturnInfoVo converToVo:json[@"shopReturnInfoVo"]];
        if (infoVo) {
            [weakSelf.txtLinkman initData:infoVo.linkMan];
            [weakSelf.txtPhone initData:infoVo.phone];
            //地区
//            [weakSelf.stArea initData:infoVo.address withVal:infoVo.address];
            weakSelf.provinceId = infoVo.provinceid;
            weakSelf.cityId = infoVo.cityid;
            weakSelf.countyId = infoVo.countyid;
            
            [weakSelf.txtAddress initData:infoVo.address];
            [weakSelf.txtZipcode initData:infoVo.zipcode];
            
            NSArray *addressList = [[Platform Instance] getAddressList];
            
            __block NSString *area = @"";
            __block NSArray* cityArr = nil;
            __block NSArray* districtArr = nil;
            if ([NSString isNotBlank:weakSelf.provinceId]&&[NSString isNotBlank:weakSelf.cityId]&&[NSString isNotBlank:weakSelf.countyId]) {
                [addressList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSDictionary* dic = obj;
                    if ([weakSelf.provinceId isEqualToString:[dic objectForKey:@"provinceId"]]) {
                        area = [dic objectForKey:@"provinceName"];
                        cityArr = [dic objectForKey:@"cityVoList"];
                    }
                }];
                
                [cityArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSDictionary* dic = obj;
                    if ([weakSelf.cityId isEqualToString:[dic objectForKey:@"cityId"]]) {
                        area = [NSString stringWithFormat:@"%@%@", area, [dic objectForKey:@"cityName"]];
                        districtArr = [dic objectForKey:@"districtVoList"];
                    }
                }];
                [districtArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSDictionary* dic = obj;
                    if ([weakSelf.countyId isEqualToString:[dic objectForKey:@"districtId"]]) {
                        area = [NSString stringWithFormat:@"%@%@", area, [dic objectForKey:@"districtName"]];
                    }
                }];
            }
            [weakSelf.lstArea initData:area withVal:area];
        }
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
    [self getAddressList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        ShopReturnInfoVo *infoVo = [[ShopReturnInfoVo alloc] init];
        
        //联系人
        infoVo.linkMan = [_txtLinkman getStrVal];
        if ([NSString isBlank:infoVo.linkMan]) {
            [AlertBox show:@"联系人必须输入"];
            return;
        }
        
        //联系电话
        infoVo.phone = [_txtPhone getStrVal];
        if ([NSString isBlank:infoVo.phone]) {
            [AlertBox show:@"联系电话必须输入"];
            return;
        }
        
        if(![NSString validateMobile:infoVo.phone] && ![NSString isValidateFax:infoVo.phone]){
            [AlertBox show:@"联系电话格式不正确，请输入正确的手机号或固定电话!"];
            return;

        }
        //所在地区
        if ([NSString isNotBlank:self.provinceId]&&[NSString isNotBlank:self.cityId]&&[NSString isNotBlank:self.countyId]) {
            infoVo.provinceid = self.provinceId;
            infoVo.cityid = self.cityId;
            infoVo.countyid = self.countyId;
        } else {
            [AlertBox show:@"所在地区必须输入"];
            return;
        }
        
        //详细地址
        infoVo.address = [_txtAddress getStrVal];
        if ([NSString isBlank:infoVo.address]) {
            [AlertBox show:@"详细地址必须输入"];
            return;
        }
        
        //邮编
        infoVo.zipcode = [_txtZipcode getStrVal];
//        if ([NSString isBlank:infoVo.zipcode]) {
//            [AlertBox show:@"邮编必须输入"];
//            return;
//        } else
        if (infoVo.zipcode.length != 6 && [NSString isNotBlank:infoVo.zipcode]) {
            [AlertBox show:@"邮编必须为6位"];
            return;
        }
        
        [self dismissViewControllerAnimated:YES completion:^{
            self.sellReturnAddressBack(infoVo);
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)getAddressList {
    
    [self.addressService selectAddressListCallBack:^(id json) {
        
        _addressList = [json objectForKey:@"addressList"];
        NSString *provinceName=nil;
        NSString *cityName=nil;
        NSString *districtName=nil;
        
        NSDictionary *cityList=nil;
        NSDictionary *countyList=nil;
        
        for (NSDictionary* provinceVal in _addressList) {
            NSString* provinceIdVal=[provinceVal objectForKey:@"provinceId"];
            if ([provinceIdVal isEqualToString:_provinceId]) {
                provinceName=[provinceVal objectForKey:@"provinceName"];
                cityList=[provinceVal objectForKey:@"cityVoList"];
                break;
            }
        }
        for (NSDictionary *cityVal in cityList) {
            NSString* cityIdVal=[cityVal objectForKey:@"cityId"];
            if ([cityIdVal isEqualToString:_cityId]) {
                cityName=[cityVal objectForKey:@"cityName"];
                countyList=[cityVal objectForKey:@"districtVoList"];
                break;
            }
        }
        
        for (NSDictionary *districtVal in countyList) {
            NSString* districtIdVal=[districtVal objectForKey:@"districtId"];
            if ([districtIdVal isEqualToString:_countyId]) {
                districtName=[districtVal objectForKey:@"districtName"];
                break;
            }
        }
        if(_countyId==nil || _provinceId==nil || _cityId==nil){
            
        }else{
            NSString * addressVal=[NSString stringWithFormat:@"%@ %@ %@",provinceName,cityName,districtName];
            [self.lstArea initData:addressVal withVal:nil];
        }
        
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];

}
- (void)onItemListClick:(EditItemList*)obj {
    
    if (!_addressPickerBox) {
        self.addressPickerBox = [[AddressPickerBox alloc]init];
        self.addressPickerBox.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        [self.view addSubview:self.addressPickerBox.view];
    }

    [_addressPickerBox initAddress:_addressList pId:self.provinceId cId:self.cityId dId:self.countyId];
    [_addressPickerBox show:obj.lblName.text client:self event:obj.tag];
    
}

- (BOOL)pickAddress:(NSMutableArray*)selectArr event:(NSInteger)eventType {
    NSString* provinceName = [[selectArr objectAtIndex:0] objectForKey:@"provinceName"];
   self.provinceId = [[selectArr objectAtIndex:0] objectForKey:@"provinceId"];
    
    NSString* cityName = [[selectArr objectAtIndex:1] objectForKey:@"cityName"];
    self.cityId = [[selectArr objectAtIndex:1] objectForKey:@"cityId"];
    
    NSString* districtName = @"";
    if (selectArr.count==3) {
        districtName = [[selectArr objectAtIndex:2] objectForKey:@"districtName"];
         self.countyId = [[selectArr objectAtIndex:2] objectForKey:@"districtId"];
    }
    
    NSString* address = nil;
    if ([self.provinceId isEqualToString:@"33"]||[self.provinceId isEqualToString:@"34"]) {
        address = [NSString stringWithFormat:@"%@",provinceName];
    }else{
        address = [NSString stringWithFormat:@"%@%@%@",provinceName,cityName,districtName];
    }
    
    [self.lstArea changeData:address withVal:address];
    return YES;
}

@end
